_: {
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 50;
    efi.canTouchEfiVariables = true;
  };
}
