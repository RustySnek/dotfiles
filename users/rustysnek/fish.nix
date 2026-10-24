{ pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      function fish_greeting
        [ (tput lines) -ge 18 ]; or return
        if [ (tput cols) -ge 60 ]; and [ "$TERM" = xterm-kitty ]; and not set -q SSH_TTY
          fetch
        else if [ (tput cols) -ge 40 ]
          ${pkgs.fastfetch}/bin/fastfetch
        end
      end
      fish_config theme choose Lava

      # pure prompt, Halloween palette (same colors as fastfetch.nix).
      # Globals shadow the universal defaults pure sets in its conf.d.
      set -g pure_color_primary ff7518 # pumpkin
      set -g pure_color_info 76d72b # slime
      set -g pure_color_mute 9b5de5 # witch
      set -g pure_color_success ff7518 # pumpkin
      set -g pure_color_danger d7263d # blood
      set -g pure_color_warning ffc300 # candy corn
      set -g pure_color_light e9e4d4 # bone
      # pure passes pre-rendered escapes through as-is, so this prefixes the cwd with a bat.
      set -g pure_color_current_directory (set_color 9b5de5)'󰭟 '(set_color ff7518)
      set -g pure_symbol_prompt '󰮣 ❯' # red on non-zero exit
      set -g pure_symbol_git_dirty ' 󱇪'
      set -g pure_color_git_dirty pure_color_danger
      set -g pure_symbol_git_stash '󰮢'
      set -g pure_symbol_ssh_prefix '󰊠 '
      set -g pure_symbol_container_prefix '󰭿 '
      set -g pure_symbol_virtualenv_prefix '󱑷 '
    '';
    plugins = with pkgs.fishPlugins; [
      {
        name = "pure";
        src = pure.src;
      }
    ];
    shellAliases = {
      "du" = "${pkgs.dust}/bin/dust";
      "ls" = "${pkgs.unstable.eza}/bin/eza --icons auto";
      "la" = "${pkgs.unstable.eza}/bin/eza --icons auto -la --extended --git";
      "cat" = "${pkgs.bat}/bin/bat";
      "df" = "${pkgs.duf}/bin/duf";
      "ps" = "${pkgs.procs}/bin/procs";
      "curl" = "${pkgs.curlie}/bin/curlie";
      "dig" = "${pkgs.doggo}/bin/doggo";
      "cp" = "${pkgs.xcp}/bin/xcp";
    };
  };

  home.persistence."/nix/persist" = {
    files = [ ".local/share/fish/fish_history" ];
  };

  programs.kitty.settings.shell = "${pkgs.fish}/bin/fish";
}
