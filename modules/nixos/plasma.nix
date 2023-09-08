{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  # Enable networking
  networking.networkmanager.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "at";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
}
