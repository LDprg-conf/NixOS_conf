{ inputs, outputs, self, user, host, config, lib, pkgs, modulesPath, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  options.vfio.enable = with lib;
    mkEnableOption "Configure the machine for VFIO";

  imports = [
    inputs.hardware.nixosModules.common-cpu-amd-pstate
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-laptop-ssd

    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  config = let cfg = config.vfio;
  in {
    boot = {
      initrd.availableKernelModules = [
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

      kernelModules = [ "kvm-amd" ];
      extraModprobeConfig = "options nvidia-drm modeset=1";
      blacklistedKernelModules =
        [ "i915" "intel_agp" "viafb" "radeon" "radeonsi" "nouveau" ];
      supportedFilesystems = [ "ntfs" ];
      kernelParams = [ "zswap.enabled=1" "amd_iommu=on" ]
        ++ lib.optional cfg.enable ("vfio-pci.ids=10de:2520");
    };

    # Enable OpenGL
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    hardware.opengl.extraPackages = with pkgs; [ vaapiVdpau ];

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = lib.mkIf cfg.enable [ "nvidia" ];

    hardware.nvidia = lib.mkIf cfg.enable {
      modesetting.enable = true;

      powerManagement = {
        enable = false;
        finegrained = false;
      };

      open = false; # Doesn't work with 6.7

      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    networking.wireless.iwd.enable = true;

    environment.systemPackages = [ pkgs.wireguard-tools nvidia-offload ];

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

    # 32GB
    zramSwap.memoryMax = 34359738368;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
