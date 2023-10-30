{...}: {
  programs.git = {
    enable = true;
    signing = {
      signByDefault = true;
      key = null;
    };
    userEmail = "jodlowskipascal@gmail.com";
    userName = "Pascal Jodlowski";
  };
}
