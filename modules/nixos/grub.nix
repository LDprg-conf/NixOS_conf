{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      configurationLimit = 50;
      efiSupport = true;
      device = "nodev";
    };
  };

  boot.plymouth.enable = true;
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 0;
  boot.kernelParams = [ "quiet" "udev.log_level=3" ];
}
