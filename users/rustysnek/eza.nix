{ pkgs, ... }:
let
  # Halloween palette (same as fastfetch.nix and the pure prompt in fish.nix)
  pumpkin = "#ff7518";
  ember = "#e85d04";
  candy = "#ffc300";
  slime = "#76d72b";
  blood = "#d7263d";
  witch = "#9b5de5";
  ghost = "#c9c3e6";
  bone = "#e9e4d4";
  dusk = "#5c4a6e";

  # eza merges these over its default styles field by field, so only the
  # colour changes and its bold/underline markers (e.g. mount points) stay.
  fg = foreground: { inherit foreground; };
in
{
  xdg.configFile."eza/theme.yml".source = (pkgs.formats.yaml { }).generate "eza-theme.yml" {
    filekinds = {
      normal = fg bone;
      directory = fg pumpkin;
      mount_point = fg pumpkin;
      symlink = fg witch;
      executable = fg slime;
      pipe = fg candy;
      special = fg candy;
      block_device = fg candy;
      char_device = fg candy;
      socket = fg blood;
    };
    file_type = {
      image = fg witch;
      video = fg blood;
      music = fg slime;
      lossless = fg slime;
      crypto = fg candy;
      document = fg ghost;
      compressed = fg blood;
      compiled = fg ember;
      build = fg candy;
      source = fg candy;
    };
    perms = {
      user_read = fg candy;
      user_write = fg blood;
      user_execute_file = fg slime;
      user_execute_other = fg slime;
      group_read = fg candy;
      group_write = fg blood;
      group_execute = fg slime;
      other_read = fg candy;
      other_write = fg blood;
      other_execute = fg slime;
      special_user_file = fg witch;
      special_other = fg witch;
    };
    # Sizes heat up from bone to blood.
    size = {
      number_byte = fg bone;
      unit_byte = fg bone;
      number_kilo = fg slime;
      unit_kilo = fg slime;
      number_mega = fg candy;
      unit_mega = fg candy;
      number_giga = fg pumpkin;
      unit_giga = fg pumpkin;
      number_huge = fg blood;
      unit_huge = fg blood;
      major = fg candy;
      minor = fg candy;
    };
    users = {
      user_you = fg candy;
      group_yours = fg candy;
      user_other = fg bone;
      group_other = fg bone;
      user_root = fg blood;
      group_root = fg blood;
    };
    links = {
      normal = fg blood;
      multi_link_file = fg blood;
    };
    git = {
      new = fg slime;
      modified = fg candy;
      deleted = fg blood;
      renamed = fg witch;
      typechange = fg witch;
      conflicted = fg blood;
    };
    git_repo = {
      branch_main = fg slime;
      branch_other = fg candy;
      git_clean = fg slime;
      git_dirty = fg blood;
    };
    punctuation = fg dusk;
    date = fg witch;
    inode = fg ghost;
    blocks = fg ghost;
    octal = fg witch;
    header = fg bone;
    symlink_path = fg witch;
    control_char = fg blood;
    broken_symlink = fg blood;
  };
}
