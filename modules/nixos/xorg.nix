{ pkgs, ... }: {
  # Enable networking
  networking.networkmanager.enable = true;

  services.xserver.excludePackages = with pkgs; [ xterm ];
  services.xserver.desktopManager.xterm.enable = false;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.libinput.enable = true;

  services.xserver.dpi = 96;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "at";
    variant = "";
  };

  programs.dconf.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers =
    [ pkgs.brlaser pkgs.samsung-unified-linux-driver ];
  services.printing.browsing = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;

  # Enable SANE for scanners
  hardware.sane.enable = true;
  services.ipp-usb.enable = true;
}
