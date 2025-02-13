{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    docker-compose
    docker
  ];
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = false;
    setSocketVariable = false;
  };
}
