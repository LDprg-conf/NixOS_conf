{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  virtualisation.docker.enable = true;
  virtualisation.docker.liveRestore = false;
  #virtualisation.docker.enableNvidia = true;

  #virtualisation.docker.rootless = {
  #  enable = true;
  #  setSocketVariable = true;
  #};
}
