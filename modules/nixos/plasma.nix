{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  imports = [ ./xorg.nix ];

  # config = lib.mkIf (config.specialisation != { }) {

  environment.systemPackages = with pkgs; [ wayland-utils clinfo ];

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;

  #services.xserver.displayManager.sddm.settings = {
  #  General = {
  #    DisplayServer = "wayland";
  #    GreeterEnvironment = ''
  #      QT_QPA_PLATFORM=wayland
  #      QT_WAYLAND_SHELL_INTEGRATION=layer-shell
  #    '';
  #  };
  #};

  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource modesetting NVIDIA-0
    ${pkgs.xorg.xrandr}/bin/xrandr --auto
  '';

  services.xserver.desktopManager.plasma5.enable = true;

  programs.xwayland.enable = true;

  services.xserver.displayManager.defaultSession = "plasmawayland";

  programs.kdeconnect.enable = true;
  #};
}
