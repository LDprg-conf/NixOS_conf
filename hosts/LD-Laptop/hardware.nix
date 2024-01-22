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
    "sd_mod"
    "tcp_bbr"
    "usb_storage"
    "usbhid"
    "xhci_pci"

    "vfio"
    "vfio_iommu_type1"
    "vfio_pci"

    "nvidia"
    "nvidia_drm"
    "nvidia_modeset"
    "nvidia_uvm"
  ];

  networking.wireless.iwd.enable = true;

  environment.systemPackages = [ pkgs.wireguard-tools ];

  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  boot.extraModprobeConfig = "options nvidia-drm modeset=1";
  boot.blacklistedKernelModules =
    [ "i915" "intel_agp" "viafb" "radeon" "radeonsi" "nouveau" ];
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelParams =
    [ "zswap.enabled=1" "amd_iommu=on" "vfio-pci.ids=10de:2520,10de:228e" ];

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

  networking.extraHosts = ''
    127.0.0.1 LD-Laptop.local LD-Laptop
  '';

  hardware.cpu.amd.updateMicrocode = true;

  boot.swraid.enable = false;

  # 32GB
  zramSwap.memoryMax = 34359738368;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
