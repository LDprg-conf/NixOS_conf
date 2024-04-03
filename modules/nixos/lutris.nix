{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (lutris.override { extraLibraries = _: [ gamemode gamescope-wsi ]; })
    winetricks
    heroic

    wineWowPackages.staging
  ];
}
