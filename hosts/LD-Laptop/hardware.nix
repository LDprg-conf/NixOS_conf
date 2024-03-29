{ user, config, lib, pkgs, ... }: {
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

      tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

          CPU_SCALING_MIN_FREQ_ON_AC = 400000;
          CPU_SCALING_MAX_FREQ_ON_AC = 4463000;
          CPU_SCALING_MIN_FREQ_ON_BAT = 400000;
          CPU_SCALING_MAX_FREQ_ON_BAT = 1000000;

          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;

          CPU_MIN_PERF_ON_AC = 0;
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MIN_PERF_ON_BAT = 0;
          CPU_MAX_PERF_ON_BAT = 30;

          USB_EXCLUDE_BTUSB = 1;

          PCIE_ASPM_ON_AC = "performance";
          PCIE_ASPM_ON_BAT = "powersave";

          RADEON_DPM_STATE_ON_AC = "performance";
          RADEON_DPM_STATE_ON_BAT = "battery";

          RESTORE_THRESHOLDS_ON_BAT = 1;

          START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
          STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
        };
      };

      hardware.bolt.enable = true;

      asusd = {
        enable = true;
        enableUserService = true;
      };
    };

    programs.rog-control-center = {
      enable = true;
      autoStart = true;
    };

    powerManagement.enable = true;

    networking = {
      useDHCP = lib.mkDefault true;
      networkmanager.wifi.powersave = false;
      extraHosts = ''
        127.0.0.1 LD-Laptop.local LD-Laptop
      '';
    };

    environment.systemPackages =
      [ pkgs.wireguard-tools pkgs.looking-glass-client pkgs.scream ];

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
