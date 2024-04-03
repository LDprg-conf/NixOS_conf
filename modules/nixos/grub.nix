_: {
  boot = {
    loader = {
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
  };
}
