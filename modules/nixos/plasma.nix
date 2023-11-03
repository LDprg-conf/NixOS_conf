{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  imports = [ ./xorg.nix ];

  environment.systemPackages = with pkgs; [
    wayland-utils
    clinfo
    libsForQt5.sddm-kcm
  ];

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;

  services.xserver.desktopManager.xterm.enable = false;

  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource modesetting NVIDIA-0
    ${pkgs.xorg.xrandr}/bin/xrandr --auto
  '';

  services.xserver.desktopManager.plasma5.enable = true;

  programs.xwayland.enable = true;

  services.xserver.displayManager.defaultSession = "plasmawayland";

  programs.kdeconnect.enable = true;
}
