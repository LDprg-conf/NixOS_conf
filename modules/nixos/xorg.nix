{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  # Enable networking
  networking.networkmanager.enable = true;

  services.xserver.excludePackages = with pkgs; [ xterm ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.libinput.enable = true;

  services.xserver.dpi = 96;

  # Configure keymap in X11
  services.xserver = {
    layout = "at";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser pkgs.samsung-unified-linux-driver ];
  services.printing.browsing = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.openFirewall = true;
}
