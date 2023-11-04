{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  imports = [ ./xorg.nix ];

  environment.systemPackages = with pkgs; [ wayland-utils clinfo ];

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;

  services.xserver.desktopManager.xterm.enable = false;

  services.xserver.desktopManager.plasma5.enable = true;

  programs.xwayland.enable = true;

  services.xserver.displayManager.defaultSession = "plasmawayland";

  programs.kdeconnect.enable = true;
}
