{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    lutris
    winetricks
    wineWowPackages.stable
    wineWowPackages.staging
    wineWowPackages.waylandFull
  ];
}
