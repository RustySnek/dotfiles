{...}: {
  programs.git = {
    enable = true;
    signing = {
      signByDefault = true;
      key = "0x560F18EB136A3A14";
    };
    userEmail = "jodlowskipascal@gmail.com";
    userName = "Pascal Jodlowski";
  };
}
