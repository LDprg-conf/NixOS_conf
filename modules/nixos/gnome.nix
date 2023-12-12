{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  imports = [ ./xorg.nix ];

  # services.xserver.displayManager.sddm.enable = true;

  # ${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
  # services.xserver.displayManager.sessionCommands = ''
  #  ${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource modesetting NVIDIA-0
  #  ${pkgs.xorg.xrandr}/bin/xrandr --auto
  # '';

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;

  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${
      pkgs.writeText "gdm-monitors.xml" ''
        <monitors version="2">
          <configuration>
            <logicalmonitor>
              <x>0</x>
              <y>0</y>
              <scale>1</scale>
              <primary>yes</primary>
              <monitor>
                <monitorspec>
                  <connector>HDMI-A-1</connector>
                  <vendor>MSI</vendor>
                  <product>G274QPF-QD</product>
                  <serial>CC2H253800958</serial>
                </monitorspec>
                <mode>
                  <width>2560</width>
                  <height>1440</height>
                  <rate>144.000</rate>
                </mode>
              </monitor>
              <monitor>
                <monitorspec>
                  <connector>eDP-1</connector>
                  <vendor>CMN</vendor>
                  <product>0x1521</product>
                  <serial>0x00000000</serial>
                </monitorspec>
                <mode>
                  <width>1920</width>
                  <height>1080</height>
                  <rate>144.003</rate>
                </mode>
              </monitor>
            </logicalmonitor>
          </configuration>
        </monitors>
      ''
    }"
  ];

  services.xserver.desktopManager.gnome.enable = true;

  programs.xwayland.enable = true;

  programs.kdeconnect.enable = true;
}
