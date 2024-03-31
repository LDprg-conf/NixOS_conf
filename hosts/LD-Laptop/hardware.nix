{ user, config, lib, pkgs, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {

  options.vfio.enable = lib.mkEnableOption "Configure the machine for VFIO";

  config = let cfg = config.vfio;
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

          "nvidia_drm"
          "nvidia_modeset"
          "nvidia_uvm"
        ];

        kernelModules = [ "nvidia" "amdgpu" "zstd" "z3fold" ];

        preDeviceCommands = lib.mkMerge [
          ''
            printf zstd > /sys/module/zswap/parameters/compressor
            printf z3fold > /sys/module/zswap/parameters/zpool
          ''
          (lib.mkIf cfg.enable ''
            modprobe -i vfio-pci
          '')
        ];
      };

      blacklistedKernelModules =
        [ "i915" "intel_agp" "viafb" "radeon" "radeonsi" "nouveau" ];
      extraModprobeConfig = "options nvidia-drm modeset=1";
      kernelModules = [ "kvm-amd" "i2c-dev" "i2c-piix4" ];
      kernelParams = [ "zswap.enabled=1" "iommu=1" "iommu=pt" ]
        ++ lib.optional cfg.enable "vfio-pci.ids=10de:2520,10de:228e";
      supportedFilesystems = [ "ntfs" "btrfs" ];

      loader.timeout = 2;
    };

    hardware = {
      i2c.enable = true;

      cpu.amd.updateMicrocode = true;

      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [
          nvidia-vaapi-driver
          vaapiVdpau
          libvdpau-va-gl
          rocmPackages.clr.icd
        ];
      };

      nvidia = {
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
    };

    systemd.tmpfiles.rules = [
      "f /dev/shm/scream 0660 ld qemu-libvirtd -"
      "f /dev/shm/looking-glass 0660 ld qemu-libvirtd -"
    ];

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "btrfs";
        options = [ "compress=zstd" "noatime" "ssd" ];
      };

      "/home" = {
        device = "/dev/disk/by-label/data";
        fsType = "btrfs";
        options = [ "compress=zstd" "noatime" "ssd" ];
      };

      "/boot/efi" = {
        device = "/dev/disk/by-label/BOOT";
        fsType = "vfat";
        options = [ "noatime" ];
      };
    };

    swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

    services = {
      btrfs.autoScrub.enable = true;
      btrfs.autoScrub.interval = "weekly";

      snapper.configs = {
        home = {
          SUBVOLUME = "/home/ld";
          ALLOW_USERS = [ "ld" ];
          TIMELINE_CREATE = true;
          TIMELINE_CLEANUP = true;
        };
      };

      fstrim.enable = true;
      udisks2.enable = true;

      xserver.videoDrivers = [ "nvidia" ];

      power-profiles-daemon.enable = false;
      tlp.enable = false;

      hardware.bolt.enable = true;

      asusd = {
        enable = true;
        enableUserService = true;
      };
    };

    programs = {
      rog-control-center = {
        enable = true;
        autoStart = true;
      };

      auto-cpufreq.enable = true;
      auto-cpufreq.settings = {
        battery = {
          governor = "powersave";
          energy_performance_preference = "power";
          scaling_max_freq = 2000000;
          turbo = "never";
        };
        charger = {
          governor = "performance";
          energy_performance_preference = "performance";
          turbo = "always";
        };
      };
    };

    powerManagement.enable = true;

    networking = {
      useDHCP = lib.mkDefault true;
      networkmanager.wifi.powersave = false;
      extraHosts = ''
        127.0.0.1 LD-Laptop.local LD-Laptop
      '';
    };

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

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
