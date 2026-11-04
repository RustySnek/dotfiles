# Forest polybar themes, ported from the old scripts/styles.sh. Each theme is
# built into its own config dir; set `rustysnek.polybar.theme` to pick the one
# the bars start with, the launcher's right-click menu switches at runtime.
#
# background/foreground/sep, palette and icons end up in polybar's [color] and
# [icon] sections; backgroundAlt/accent/selected only colour the rofi menus.
let
  # accent colors
  defaultPalette = {
    foreground-icon = "\${color.foreground}";
    ws-empty = "\${color.foreground}";
    white = "#FFFFFF";
    black = "#000000";
    red = "#EC7875";
    pink = "#EC407A";
    purple = "#BA68C8";
    blue = "#42A5F5";
    cyan = "#4DD0E1";
    teal = "#00B19F";
    green = "#61C766";
    lime = "#B9C244";
    yellow = "#FDD835";
    amber = "#FBC02D";
    orange = "#E57C46";
    brown = "#AC8476";
    indigo = "#6C77BB";
    gray = "#9E9E9E";
    blue-gray = "#6D8895";
  };

  # pumpkin, ember & candlelight
  halloweenPalette = {
    foreground-icon = "#FFA552";
    ws-empty = "#4A2E18";
    white = "#FFE8CC";
    black = "#000000";
    red = "#D9361A";
    pink = "#FF5500";
    purple = "#FF8C1A";
    blue = "#FFA64D";
    cyan = "#FFC27A";
    teal = "#E8822A";
    green = "#FFB347";
    lime = "#FFC870";
    yellow = "#FF8000";
    amber = "#FFA000";
    orange = "#FF7518";
    brown = "#8B4A1F";
    indigo = "#E0701F";
    gray = "#7A5A44";
    blue-gray = "#B8763A";
  };

  # feather icons
  featherIcons = {
    launcher = "";
    sysmenu = "";
    ws-1 = "1;";
    ws-2 = "2;";
    ws-3 = "3;";
    ws-4 = "4;";
    ws-5 = "5;";
    ws-default = "";
    cpu = "";
    memory = "";
    fs-mounted = "";
    fs-unmounted = "";
    mpd-online = "";
    mpd-offline = "";
    date = " ";
    bat-charging = "";
    bat-discharging = "";
    bat-full = "";
    net-connected = "";
    net-disconnected = "";
    vol-0 = "";
    vol-1 = "";
    vol-2 = "";
    vol-muted = "";
    light-0 = "";
    light-1 = "";
    light-2 = "";
    light-3 = "";
    light-4 = "";
    bar-indicator = "";
  };

  # Nerd Font (Material Design) icons, drawn with font-3 (T4)
  halloweenIcons = {
    launcher = "%{T4}󰮣%{T-}";
    sysmenu = "%{T4}󰭿%{T-}";
    ws-1 = "1;%{T4}󰮿%{T-}";
    ws-2 = "2;%{T4}󰮿%{T-}";
    ws-3 = "3;%{T4}󰮿%{T-}";
    ws-4 = "4;%{T4}󰮿%{T-}";
    ws-5 = "5;%{T4}󰮿%{T-}";
    ws-default = "%{T4}󰮿%{T-}";
    cpu = "%{T4}󰙚%{T-}";
    memory = "%{T4}󱄲%{T-}";
    fs-mounted = "%{T4}󰮢%{T-}";
    fs-unmounted = "%{T4}󰯆%{T-}";
    mpd-online = "%{T4}󱑷%{T-}";
    mpd-offline = "%{T4}󱑷%{T-}";
    date = "%{T4}󰭟%{T-} ";
    bat-charging = "%{T4}󱐋%{T-}";
    bat-discharging = "%{T4}󰗢%{T-}";
    bat-full = "%{T4}󱟓%{T-}";
    net-connected = "%{T4}󰯊%{T-}";
    net-disconnected = "%{T4}󱇫%{T-}";
    vol-0 = "%{T4}󰏒%{T-}";
    vol-1 = "%{T4}󰏒%{T-}";
    vol-2 = "%{T4}󰏒%{T-}";
    vol-muted = "%{T4}󰧵%{T-}";
    light-0 = "%{T4}󰽤%{T-}";
    light-1 = "%{T4}󰽧%{T-}";
    light-2 = "%{T4}󰽡%{T-}";
    light-3 = "%{T4}󰽨%{T-}";
    light-4 = "%{T4}󰽢%{T-}";
    bar-indicator = "%{T4}󰮿%{T-}";
  };
in
{
  default = {
    label = "Default";
    menuIcon = "";
    background = "#212B30";
    foreground = "#C4C7C5";
    sep = "#3F5360";
    backgroundAlt = "#263035";
    accent = "#EC407A";
    selected = "#4DD0E1";
    palette = defaultPalette;
    icons = featherIcons;
  };
  nord = {
    label = "Nord";
    menuIcon = "";
    background = "#3B4252";
    foreground = "#E5E9F0";
    sep = "#5B6579";
    backgroundAlt = "#454C5C";
    accent = "#BF616A";
    selected = "#88C0D0";
    palette = defaultPalette;
    icons = featherIcons;
  };
  gruvbox = {
    label = "Gruvbox";
    menuIcon = "";
    background = "#282828";
    foreground = "#EBDBB2";
    sep = "#505050";
    backgroundAlt = "#313131";
    accent = "#FB4934";
    selected = "#8EC07C";
    palette = defaultPalette;
    icons = featherIcons;
  };
  dark = {
    label = "Dark";
    menuIcon = "";
    background = "#141C21";
    foreground = "#93A1A1";
    sep = "#3C4449";
    backgroundAlt = "#1E262B";
    accent = "#D12F2C";
    selected = "#33C5BA";
    palette = defaultPalette;
    icons = featherIcons;
  };
  cherry = {
    label = "Cherry";
    menuIcon = "";
    background = "#1F1626";
    foreground = "#FFFFFF";
    sep = "#473F4E";
    backgroundAlt = "#292030";
    accent = "#D94084";
    selected = "#4F5D95";
    palette = defaultPalette;
    icons = featherIcons;
  };
  halloween = {
    label = "Halloween";
    menuIcon = "󰮿";
    background = "#0D0A08";
    foreground = "#FFE9D6";
    sep = "#3D2716";
    backgroundAlt = "#1A120C";
    accent = "#FF6A00";
    selected = "#FF7518";
    palette = halloweenPalette;
    icons = halloweenIcons;
  };
}
