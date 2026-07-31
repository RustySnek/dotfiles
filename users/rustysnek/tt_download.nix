{ pkgs, ... }:
let
  tt_download = pkgs.writeShellApplication {
    name = "tt_download";
    runtimeInputs = with pkgs; [
      unstable.yt-dlp
      ffmpeg-full
      coreutils
      findutils
    ];
    text = ''
      URL="''${1:?Usage: tt_download <URL> [-r name] [-e]}"
      shift || true

      OUT_NAME=""
      ETERNAL=0
      ETERNAL_DIR="/home/rustysnek/Documents/NextCloud/EternalMemes"
      while [[ $# -gt 0 ]]; do
        case "$1" in
          -r)
            OUT_NAME="''${2:?Missing name}"
            shift 2
            ;;
          -e)
            ETERNAL=1
            shift
            ;;
          *)
            shift
            ;;
        esac
      done

      TMP="$(mktemp -d)"
      trap 'rm -rf "$TMP"' EXIT

      sanitize() {
        echo "$1" | tr -cd '[:alnum:] ._-'
      }

      # download
      yt-dlp -f "bestvideo+bestaudio/best" -o "$TMP/%(title)s.%(ext)s" "$URL"

      INPUT="$(find "$TMP" -type f | head -n 1)"

      BASE="$(basename "''${INPUT%.*}")"

      if [[ -n "$OUT_NAME" ]]; then
        BASE="$(sanitize "$OUT_NAME")"
      else
        BASE="$(sanitize "$BASE")"
      fi

      # decide destination directory up front
      if [[ "$ETERNAL" -eq 1 ]]; then
        DEST_DIR="$ETERNAL_DIR"
        mkdir -p "$DEST_DIR"
      else
        DEST_DIR="$PWD"
      fi

      # avoid overwriting: if a file with the same name exists, append _1, _2, ...
      RENAMED=0
      OUT="$DEST_DIR/''${BASE}.mp4"
      if [[ -e "$OUT" ]]; then
        n=1
        while [[ -e "$DEST_DIR/''${BASE}_''${n}.mp4" ]]; do
          n=$((n + 1))
        done
        OUT="$DEST_DIR/''${BASE}_''${n}.mp4"
        RENAMED=1
      fi

      # normalize + size control
      ffmpeg -y -i "$INPUT" \
        -vf "fps=30,scale='min(720,iw)':-2" \
        -c:v libx264 -pix_fmt yuv420p \
        -preset slow \
        -b:v 900k -maxrate 1000k -bufsize 2000k \
        -c:a aac -b:a 96k \
        -movflags +faststart \
        "$OUT"

      echo "$OUT"

      if [[ "$RENAMED" -eq 1 ]]; then
        echo "WARNING: a file named ''${BASE}.mp4 already existed in $DEST_DIR; saved as $(basename "$OUT") instead." >&2
      fi
    '';
  };
in
{
  home.packages = [ tt_download ];
}
