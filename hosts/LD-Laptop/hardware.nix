{ inputs, outputs, self, user, host, config, lib, pkgs, modulesPath, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  options.vfio.enable = lib.mkEnableOption "Configure the machine for VFIO";

  imports = [
    inputs.hardware.nixosModules.common-cpu-amd-pstate
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-laptop-ssd

    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  config =
    let cfg = config.vfio;
    in {
      boot = {
        initrd = {
          availableKernelModules = [
            "nvme"
            "sd_mod"
            "tcp_bbr"
            "usb_storage"
            "usbhid"
            "vfio_pci"
            "xhci_pci"

            "nvidia"
            "nvidia_drm"
            "nvidia_modeset"
            "nvidia_uvm"
          ];

          kernelModules = [ "zstd" "z3fold" ];

          preDeviceCommands = lib.mkMerge [
            (
              ''
                printf zstd > /sys/module/zswap/parameters/compressor
                printf z3fold > /sys/module/zswap/parameters/zpool
              ''
            )
            (lib.mkIf cfg.enable ''
              modprobe -i vfio-pci
            '')
          ];
        };

        kernelModules = [ "kvm-amd" ];
        extraModprobeConfig = "options nvidia-drm modeset=1";
        blacklistedKernelModules =
          [ "i915" "intel_agp" "viafb" "radeon" "radeonsi" "nouveau" ];
        supportedFilesystems = [ "ntfs" "btrfs" ];
        kernelParams = [ "zswap.enabled=1" "iommu=1" "iommu=pt" ]
          ++ lib.optional cfg.enable "vfio-pci.ids=10de:2520,10de:228e";
      };

      # Enable OpenGL
      hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };

      # Load nvidia driver for Xorg and Wayland
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        modesetting.enable = true;

        powerManagement = {
          enable = false;
          finegrained = false;
        };

        open = true;

        nvidiaSettings = true;

        package = config.boot.kernelPackages.nvidiaPackages.beta;
      };

      environment.systemPackages = [
        pkgs.wireguard-tools
        pkgs.looking-glass-client
        pkgs.scream
        nvidia-offload
      ];

      systemd.tmpfiles.rules = [
        "f /dev/shm/scream 0660 ld qemu-libvirtd -"
        "f /dev/shm/looking-glass 0660 ld qemu-libvirtd -"
      ];

      fileSystems."/" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "btrfs";
        options = [ "compress=zstd" "noatime" "ssd" ];
      };

      fileSystems."/home" = {
        device = "/dev/disk/by-label/data";
        fsType = "btrfs";
        options = [ "compress=zstd" "noatime" "ssd" ];
      };

      fileSystems."/boot/efi" = {
        device = "/dev/disk/by-label/BOOT";
        fsType = "vfat";
        options = [ "noatime" ];
      };

      services.btrfs.autoScrub.enable = true;
      services.btrfs.autoScrub.interval = "weekly";

      # services.snapper.configs = {
      #   home = {
      #     SUBVOLUME = "/home/ld";
      #     ALLOW_USERS = [ "ld" ];
      #     TIMELINE_CREATE = true;
      #     TIMELINE_CLEANUP = true;
      #   };
      # };

      swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

      services.fstrim.enable = true;
      services.udisks2.enable = true;

      networking.useDHCP = lib.mkDefault true;

      networking.extraHosts = ''
        127.0.0.1 LD-Laptop.local LD-Laptop
      '';

      hardware.cpu.amd.updateMicrocode = true;

      systemd.user.services.scream-ivshmem = {
        enable = true;
        description = "Scream IVSHMEM";
        serviceConfig = {
          ExecStart = "${pkgs.scream}/bin/scream-ivshmem-pulse /dev/shm/scream";
          Restart = "always";
        };
        wantedBy = [ "multi-user.target" ];
        requires = [ "pipewire-pulse.service" ];
      };

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    };
}
