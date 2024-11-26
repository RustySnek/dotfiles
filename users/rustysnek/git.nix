{ ... }:
{
  programs.git = {
    enable = true;
    signing = {
      signByDefault = true;
      key = "0x68A31460574C24D5";
    };
    userEmail = "jodlowskipascal@gmail.com";
    userName = "Pascal Jodlowski";
  };
}
