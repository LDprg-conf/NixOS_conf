{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    (lutris.override {
      extraLibraries = pkgs: [
        gamemode
        gamescope-wsi
      ];
    })
    winetricks
    heroic

    #wineWowPackages.stable
    wineWowPackages.staging
    #wineWowPackages.wayland
    #wine
    #wine64

    gst_all_1.gstreamer
    gst_all_1.gst-vaapi
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-base
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-viperfx

    cairo
  ];
}
