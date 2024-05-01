{...}: {
  programs.git = {
    enable = true;
    signing = {
      signByDefault = true;
      key = "0x2C6DADC139281E59";
    };
    userEmail = "jodlowskipascal@gmail.com";
    userName = "Pascal Jodlowski";
  };
}
