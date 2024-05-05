{ lib, pkgs, ... }: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall =
      true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall =
      true; # Open ports in the firewall for Source Dedicated Server
    extraCompatPackages = with pkgs; [
      # proton-ge-custom
    ];
    package = pkgs.steam.override {
      extraLibraries = p: with p; [ (lib.getLib [ gamemode gamescope-wsi ]) ];
    };
  };

  environment.systemPackages = with pkgs; [ protontricks ];
}
