{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    docker-compose
    docker
  ];
  virtualisation.docker.enable = true;
  #virtualisation.docker.enableNvidia = true;
  virtualisation.docker.rootless = {
    enable = false;
    setSocketVariable = true;
  };
}
