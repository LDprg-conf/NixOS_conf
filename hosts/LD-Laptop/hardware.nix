{ inputs, outputs, self, user, host, config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd-pstate
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-laptop-ssd

    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "tcp_bbr"
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  networking.wireless.iwd.enable = true;

  environment.systemPackages = [ pkgs.wireguard-tools ];

  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  boot.extraModprobeConfig = "options nvidia-drm modeset=1";
  boot.blacklistedKernelModules =
    [ "i915" "intel_agp" "viafb" "radeon" "nouveau" ];
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelParams = [ "zswap.enabled=1" ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/data";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  services.fstrim.enable = true;
  services.udisks2.enable = true;

  networking.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = true;

  boot.swraid.enable = false;

  # 32GB
  zramSwap.memoryMax = 34359738368;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
