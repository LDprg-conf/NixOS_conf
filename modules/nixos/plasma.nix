{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  # Enable networking
  networking.networkmanager.enable = true;

  services.xserver.excludePackages = with pkgs; [ xterm ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.libinput.enable = true;

  services.xserver.dpi = 96;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  services.xserver.displayManager.defaultSession = "plasmawayland";

  programs.kdeconnect.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "at";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.browsing = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.openFirewall = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-kde ];
  };

}
