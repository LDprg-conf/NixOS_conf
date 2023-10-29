{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    lutris
    winetricks
    #wineWowPackages.stable
    #wineWowPackages.stagingFull
    #wineWowPackages.wayland
    #wine 
    #wine64
  ];
}
