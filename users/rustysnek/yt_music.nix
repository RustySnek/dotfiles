{ pkgs, ... }:
let
  yt_music = pkgs.writeShellApplication {
    name = "yt_music";
    runtimeInputs = with pkgs; [
      unstable.yt-dlp
      ffmpeg-full
      atomicparsley
      coreutils
    ];
    text = ''
      URL="''${1:?Usage: yt_music <URL> [-d subdir|/full/path]}"
      shift || true

      BASE_DIR="/home/rustysnek/Documents/NextCloud/music/Chunchumaru"
      DEST_DIR="$BASE_DIR"
      while [[ $# -gt 0 ]]; do
        case "$1" in
          -d)
            ARG="''${2:?Missing dir}"
            if [[ "$ARG" = /* ]]; then
              DEST_DIR="$ARG"
            else
              DEST_DIR="$BASE_DIR/$ARG"
            fi
            shift 2
            ;;
          *)
            shift
            ;;
        esac
      done

      mkdir -p "$DEST_DIR"

      # highest audio quality, embed thumbnail + all available metadata
      yt-dlp \
        -f "bestaudio/best" \
        --extract-audio \
        --audio-format best \
        --audio-quality 0 \
        --embed-thumbnail \
        --embed-metadata \
        --add-metadata \
        --no-overwrites \
        -o "$DEST_DIR/%(title)s.%(ext)s" \
        "$URL"
    '';
  };
in
{
  home.packages = [ yt_music ];
}
