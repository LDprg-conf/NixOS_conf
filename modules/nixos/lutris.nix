{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (lutris.override {
      extraLibraries = _: [ gamemode gamescope-wsi ];
      extraPkgs = _: [
        gamemode
        gamescope-wsi
        winetricks
      ];
    })
    winetricks
    heroic

    wineWowPackages.staging
  ];
}
