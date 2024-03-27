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

  config =
    let cfg = config.vfio;
    in {

      # KERNEL

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

        blacklistedKernelModules =
          [ "i915" "intel_agp" "viafb" "radeon" "radeonsi" "nouveau" ];
        extraModprobeConfig = "options nvidia-drm modeset=1";
        kernelModules = [ "kvm-amd" "i2c-dev" "i2c-piix4" ];
        kernelParams =
          [ "amd_pstate=active" "zswap.enabled=1" "iommu=1" "iommu=pt" ]
          ++ lib.optional cfg.enable "vfio-pci.ids=10de:2520,10de:228e";
        supportedFilesystems = [ "ntfs" "btrfs" ];

        loader.timeout = 2;
      };

      hardware.i2c.enable = true;

      # NVIDIA GPU

      hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [
          nvidia-vaapi-driver
          vaapiVdpau
          libvdpau-va-gl
        ];
      };

      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        modesetting.enable = true;

        nvidiaSettings = true;

        open = true;

        package = config.boot.kernelPackages.nvidiaPackages.stable;

        powerManagement = {
          enable = false;
          finegrained = false;
        };

        prime = {
          sync.enable = true;

          amdgpuBusId = "PCI:6:0:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };

      # FILESYSTEM

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

      services.snapper.configs = {
        home = {
          SUBVOLUME = "/home/ld";
          ALLOW_USERS = [ "ld" ];
          TIMELINE_CREATE = true;
          TIMELINE_CLEANUP = true;
        };
      };

      swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

      services.fstrim.enable = true;
      services.udisks2.enable = true;

      # POWERMANAGEMENT

      powerManagement.enable = true;

      services.power-profiles-daemon.enable = false;

      services.tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

          CPU_MIN_PERF_ON_AC = 0;
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MIN_PERF_ON_BAT = 0;
          CPU_MAX_PERF_ON_BAT = 20;

          #Optional helps save long term battery health
          START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
          STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
        };
      };

      # NETWORK

      networking.useDHCP = lib.mkDefault true;
      networking.networkmanager.wifi.powersave = false;
      networking.extraHosts = ''
        127.0.0.1 LD-Laptop.local LD-Laptop
      '';

      # CPU

      hardware.cpu.amd.updateMicrocode = true;

      # ETC

      environment.systemPackages = [
        pkgs.wireguard-tools
        pkgs.looking-glass-client
        pkgs.scream
        nvidia-offload
      ];

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

      services.hardware.bolt.enable = true;

      services = {
        asusd = {
          enable = true;
          enableUserService = true;
        };
      };

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    };
}
