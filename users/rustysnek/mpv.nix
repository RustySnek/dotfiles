{ pkgs, ... }:
let
  # Anime4K v4.0.1 + FSRCNNX + KrigBilateral + SSimDownscaler, prebuilt in nixpkgs
  shaders = "${pkgs.mpv-shim-default-shaders}/share/mpv-shim-default-shaders/shaders";

  a4k = names: builtins.concatStringsSep ":" (map (n: "${shaders}/Anime4K_${n}.glsl") names);

  # Rungs, cheapest first. Each doubling runs at source res (1024x576) or at the
  # first-pass output (2048x1152); a second doubling is the expensive one because
  # it runs at 1152p. Clamp_Highlights is only needed alongside Restore_CNN.
  upscaleOnly = a4k [ "Upscale_CNN_x2_S" ];
  restoreS = a4k [
    "Clamp_Highlights"
    "Restore_CNN_S"
    "Upscale_CNN_x2_S"
  ];
  restoreM = a4k [
    "Clamp_Highlights"
    "Restore_CNN_M"
    "Upscale_CNN_x2_M"
  ];

  # Official Mode A/B/C. These add the second x2 pass at 1152p input.
  modeAFast = a4k [
    "Clamp_Highlights"
    "Restore_CNN_M"
    "Upscale_CNN_x2_M"
    "AutoDownscalePre_x2"
    "AutoDownscalePre_x4"
    "Upscale_CNN_x2_S"
  ];
  modeAHQ = a4k [
    "Clamp_Highlights"
    "Restore_CNN_VL"
    "Upscale_CNN_x2_VL"
    "AutoDownscalePre_x2"
    "AutoDownscalePre_x4"
    "Upscale_CNN_x2_M"
  ];

  # Line weight, not resolution. This is the one rung that visibly changes
  # the image on soft cel-era sources.
  lines = a4k [
    "Upscale_CNN_x2_S"
    "Darken_HQ"
    "Thin_HQ"
  ];

  fsrcnnx = "${shaders}/FSRCNNX_x2_8-0-4-1.glsl";
in
{
  programs.mpv = {
    enable = true;

    config = {
      vo = "gpu-next";
      gpu-api = "vulkan";
      # Vulkan video decode is zero-copy into the same device gpu-next renders on;
      # vaapi needs an interop layer. Falls back left to right.
      hwdec = "vulkan,vaapi";

      # No profile=high-quality: it forces scale=ewa_lanczossharp back on.
      # After a CNN doubling to 2048x1152 only 1.25x is left, so a separable
      # 6-tap filter is indistinguishable from a ~32-tap polar EWA and far cheaper.
      # ewa_lanczossoft is mpv-vo=gpu only; gpu-next has no libplacebo analog.
      scale = "spline36";
      cscale = "spline36";
      dscale = "mitchell";
      correct-downscaling = true;

      # 576p anime rips band in gradients; this matters more than sharpening.
      deband = true;
      deband-iterations = 1;
      deband-threshold = 48;
      deband-range = 16;
      # Source is a grainy 2003 telecine. Adding synthetic grain on top is
      # counterproductive; the native grain already masks banding.
      deband-grain = 0;

      dither-depth = "auto";
      temporal-dither = true;

      # picom is running; without this it composites every frame of a windowed
      # 1440p surface on top of the shader chain.
      x11-bypass-compositor = "yes";

      keep-open = true;
      save-position-on-quit = true;
      sub-auto = "fuzzy";
      alang = "jpn,ja,jp";
      slang = "eng,en";
    };

    profiles = {
      "anime-sd" = {
        profile-desc = "cond:sub-720p CNN upscale";
        profile-cond = ''get("height", 0) <= 720'';
        profile-restore = "copy-equal";
        glsl-shaders = upscaleOnly;
      };
    };

    bindings = {
      "CTRL+0" = ''no-osd change-list glsl-shaders clr ""; show-text "shaders: off"'';
      "CTRL+1" = ''no-osd change-list glsl-shaders set "${upscaleOnly}"; show-text "A4K: upscale S (default)"'';
      "CTRL+2" = ''no-osd change-list glsl-shaders set "${restoreS}"; show-text "A4K: restore+upscale S"'';
      "CTRL+3" = ''no-osd change-list glsl-shaders set "${restoreM}"; show-text "A4K: restore+upscale M"'';
      "CTRL+4" = ''no-osd change-list glsl-shaders set "${modeAFast}"; show-text "A4K: Mode A (fast)"'';
      "CTRL+5" = ''no-osd change-list glsl-shaders set "${modeAHQ}"; show-text "A4K: Mode A (VL)"'';
      "CTRL+7" = ''no-osd change-list glsl-shaders set "${lines}"; show-text "A4K: upscale S + darken/thin"'';
      "CTRL+6" = ''no-osd change-list glsl-shaders set "${fsrcnnx}"; show-text "FSRCNNX x2 8-0-4-1"'';
    };
  };
}
