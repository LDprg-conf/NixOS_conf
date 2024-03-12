{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
    package = pkgs.steam.override {
      extraLibraries = p: with p; [ (lib.getLib [ networkmanager gamemode gamescope-wsi ]) ];
    };
  };

  environment.systemPackages = with pkgs; [
    xdotool
    xorg.xwininfo
    yad
    protontricks
    vulkan-headers
    vulkan-loader
    vulkan-tools
  ];
}
