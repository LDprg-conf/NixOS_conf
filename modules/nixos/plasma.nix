{ pkgs, ... }: {
  imports = [ ./xorg.nix ];

  environment.systemPackages = with pkgs; [
    kdePackages.plasma-thunderbolt
    kdePackages.filelight
    kdePackages.sddm-kcm
    kdePackages.colord-kde
    xwaylandvideobridge
    partition-manager
  ];

  services = {
    xserver.displayManager.sddm = {
      # enable = true;
      wayland.enable = true;

      settings = {
        Theme = {
          Current = "breeze";
          ThemeDir = "/sddmt";
        };
      };
    };

    xserver.displayManager.gdm.enable = true;

    desktopManager.plasma6.enable = true;
  };

  programs.xwayland.enable = true;
  programs.kdeconnect.enable = true;
}
