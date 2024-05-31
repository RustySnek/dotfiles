{...}: {
  programs.git = {
    enable = true;
    signing = {
      signByDefault = true;
      key = "0x3F8D13F3CBE83642";
    };
    userEmail = "jodlowskipascal@gmail.com";
    userName = "Pascal Jodlowski";
  };
}
