{ pkgs, ... }: {
  networking.networkmanager.enable = true;

  services = {
    libinput.enable = true;

    xserver = {
      enable = true;

      excludePackages = with pkgs; [ xterm ];
      desktopManager.xterm.enable = false;

      dpi = 96;

      xkb = {
        layout = "at";
        variant = "";
      };
    };

    printing = {
      enable = true;
      drivers = [ pkgs.brlaser pkgs.samsung-unified-linux-driver ];
      browsing = true;
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    ipp-usb.enable = true;
  };

  programs.dconf.enable = true;
  hardware.sane.enable = true;
}
