{
  config,
  lib,
  pkgs,
  ...
}:
let
  # term_image.png is 992x1585; VictorMono cells are 600x1550 units,
  # so 21 cols x 13 rows keeps the aspect ratio.
  logoWidth = 21;
  logoHeight = 13;
  logoPadding = 2;
  # 21x13 cells at the 13x34 px VictorMono 18 cell (96 DPI).
  imageSize = {
    w = 276;
    h = 442;
  };

  # fastfetch's image logos either drop the APNG animation (kitty-direct) or
  # misplace it and leave the cursor inside it (kitty-icat), and `kitten icat`
  # decodes every frame on each spawn. So decode the frames once into raw RGBA
  # and prebuild the graphics escapes: a new shell just prints `show` and kitty
  # reads the frames straight from the store (t=f) and runs the animation.
  termImage =
    pkgs.runCommand "term-image-kitty"
      {
        nativeBuildInputs = [
          pkgs.ffmpeg-full
          pkgs.python3
        ];
      }
      ''
        mkdir $out
        ffmpeg -v error -i ${../../term_image.png} -vf scale=${toString imageSize.w}:${toString imageSize.h}:flags=lanczos \
          -fps_mode passthrough -f rawvideo -pix_fmt rgba frames.raw
        python3 - ${../../term_image.png} ${toString imageSize.w} ${toString imageSize.h} \
          ${toString logoWidth} ${toString logoHeight} ${toString logoPadding} <<'EOF'
        import base64, mmap, os, struct, sys

        src = sys.argv[1]
        w, h, cols, rows, pad = map(int, sys.argv[2:])
        frames_path = os.environ["out"] + "/frames.rgba"

        # Frame delays from the APNG fcTL chunks.
        data = open(src, "rb").read()
        delays, i = [], 8
        while i < len(data):
            n, kind = struct.unpack(">I4s", data[i : i + 8])
            if kind == b"fcTL":
                num, den = struct.unpack(">HH", data[i + 28 : i + 32])
                delays.append(round(1000 * num / (den or 100)))
            i += 12 + n

        size = w * h * 4
        frames = os.path.getsize("frames.raw") // size
        assert frames == len(delays), (frames, len(delays))

        # kitty mmaps t=f data at offset O, which must be page aligned.
        stride = -(-size // mmap.ALLOCATIONGRANULARITY) * mmap.ALLOCATIONGRANULARITY
        with open("frames.raw", "rb") as raw, open(frames_path, "wb") as out:
            for _ in range(frames):
                out.write(raw.read(size).ljust(stride, b"\0"))

        def apc(keys, payload=""):
            return "\x1b_G" + keys + (";" + payload if payload else "") + "\x1b\\"

        ident = "q=2,i=1031"
        pixels = "%s,f=32,t=f,s=%d,v=%d,S=%d" % (ident, w, h, size)
        path = base64.b64encode(frames_path.encode()).decode()
        # Save cursor, draw at row 0 / col pad without moving it, restore.
        seq = "\x1b7\x1b[1;%dH" % (pad + 1)
        seq += apc("a=T,%s,O=0,c=%d,r=%d,C=1" % (pixels, cols, rows), path)
        seq += apc("a=a,%s,r=1,z=%d" % (ident, delays[0]))
        for k in range(1, frames):
            seq += apc("a=f,X=1,%s,O=%d,z=%d" % (pixels, k * stride, delays[k]), path)
        seq += apc("a=a,%s,s=3,v=1" % ident)
        seq += "\x1b8"
        open(os.environ["out"] + "/show", "w").write(seq)
        EOF
      '';

  # fastfetch only reserves the space; `fetch` draws the image over it.
  blankLogo = pkgs.writeText "fastfetch-blank-logo" (
    lib.concatStringsSep "\n" (
      lib.replicate logoHeight (lib.concatStrings (lib.replicate logoWidth " "))
    )
  );

  # Halloween palette (truecolor SGR params)
  pumpkin = "38;2;255;117;24";
  candy = "38;2;255;195;0";
  slime = "38;2;118;215;43";
  blood = "38;2;215;38;61";
  witch = "38;2;155;93;229";
  bone = "38;2;233;228;212";
  black = "38;2;0;0;0";

  row =
    label: icon: color: module:
    module
    // {
      key = "│ {#${color}}${icon} {#${bone}} ${label} {#keys}│";
      outputColor = color;
    };
  border = key: {
    type = "custom";
    inherit key;
  };
in
{
  # The image escapes position absolutely, hence the clear.
  programs.fish.functions.fetch = ''
    clear
    ${config.programs.fastfetch.package}/bin/fastfetch --logo-type file-raw --logo ${blankLogo} \
      --logo-padding-left ${toString logoPadding} --logo-padding-right ${toString logoPadding}
    ${pkgs.coreutils}/bin/cat ${termImage}/show
  '';

  programs.fastfetch = {
    enable = true;
    settings = {
      logo.type = "none";
      display = {
        separator = " ";
        brightColor = false;
        color.keys = pumpkin;
        duration = {
          abbreviation = true;
          spaceBeforeUnit = "never";
        };
      };
      modules = [
        (border "╭───────────╮")
        (row "distro" "󰻀" slime {
          type = "os";
          format = "{pretty-name}";
        })
        (row "kernel" "󰌢" pumpkin {
          type = "kernel";
          format = "{release}";
        })
        (row "uptime" "" witch { type = "uptime"; })
        (row "shell " "" blood {
          type = "shell";
          format = "{pretty-name}";
        })
        (row "pkgs  " "󰏖" candy {
          type = "packages";
          format = "{all}";
        })
        (row "memory" "󰍛" slime {
          type = "memory";
          format = "{used} | {total}";
        })
        (border "├───────────┤")
        (row "colors" "󰏘" bone {
          type = "custom";
          format = builtins.concatStringsSep " " (
            map (c: "{#${c}}") [
              pumpkin
              black
              slime
              blood
              witch
              candy
              bone
            ]
          );
        })
        (border "╰───────────╯")
      ];
    };
  };
}
