{ ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      name = "VictorMono NerdFont";
      size = 18;
    };
    settings = {
      confirm_os_window_close = 0;
      # Leftover pixels (window height % cell height) go below the grid instead
      # of splitting above/below, so the fetch image sits flush with the top.
      placement_strategy = "top";
    };
    extraConfig = builtins.concatStringsSep "\n" [
      ''
        map ctrl+shift+w discard_event
        font_family VictorMono Nerd Font
        disable_ligatures never
        font_size	18
        background_opacity 0.95
        bold_font	auto
        background	#161616
        foreground	#FFD9FA
        active_border_color	#1c2e5d
      ''
    ];
  };
}
