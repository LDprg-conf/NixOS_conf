{ user, config, lib, pkgs, ... }: {

  options.vfio.enable = lib.mkEnableOption "Configure the machine for VFIO";

  config =
    let cfg = config;
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
          ];

          kernelModules =
            [ "kvm-amd" "i2c-dev" "i2c-piix4" "amdgpu" "zstd" "z3fold" ];

          preDeviceCommands = lib.mkMerge [
            ''
              printf zstd > /sys/module/zswap/parameters/compressor
              printf z3fold > /sys/module/zswap/parameters/zpool
            ''
            (lib.mkIf cfg.vfio.enable ''
              modprobe -i vfio-pci
            '')
          ];
        };

        kernelParams = [
          "lymouth.nolog"
          "udev.log_level=3"
          "iommu=1"
          "iommu=pt"
          "zswap.enabled=1"
          "quiet"
        ] ++ lib.optional cfg.vfio.enable "vfio-pci.ids=10de:2520,10de:228e";
        supportedFilesystems = [ "ntfs" "btrfs" ];

        consoleLogLevel = 0;
        initrd.verbose = false;
        loader.timeout = 2;
        plymouth.enable = true;
        tmp.useTmpfs = true;
      };

      hardware = {
        i2c.enable = true;

        cpu.amd.updateMicrocode = true;

        graphics = {
          enable = true;
          extraPackages = with pkgs; [
            libvdpau-va-gl
            rocmPackages.clr.icd
            amdvlk
            vaapiVdpau
          ];
        };

        nvidia = lib.mkIf (!cfg.vfio.enable) {
          modesetting.enable = true;

          nvidiaSettings = true;

          open = true;

          package = config.boot.kernelPackages.nvidiaPackages.beta;

          powerManagement = {
            enable = true;
            finegrained = true;
          };

          dynamicBoost.enable = true;

          prime = {
            offload.enable = lib.mkForce true;
            offload.enableOffloadCmd = lib.mkForce true;
            sync.enable = lib.mkForce false;

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

        dbus.implementation = "broker";

        xserver.videoDrivers = lib.mkIf (!cfg.vfio.enable) [ "nvidia" ];

        hardware.bolt.enable = true;

        asusd = {
          enable = true;
          enableUserService = true;
          asusdConfig = ''
            (
              charge_control_end_threshold: 80,
              panel_od: false,
              mini_led_mode: false,
              disable_nvidia_powerd_on_battery: true,
              ac_command: "${pkgs.ryzenadj} --power-saving",
              bat_command: "${pkgs.ryzenadj} --max-performance",
              platform_policy_linked_epp: true,
              platform_policy_on_battery: Balanced,
              platform_policy_on_ac: Performance,
              ppt_pl1_spl: None,
              ppt_pl2_sppt: None,
              ppt_fppt: None,
              ppt_apu_sppt: None,
              ppt_platform_sppt: None,
              nv_dynamic_boost: None,
              nv_temp_target: None,
            )
          '';
        };
        supergfxd.enable = true;
        switcherooControl.enable = true;

        earlyoom.enable = true;
      };

      programs = {
        rog-control-center = {
          enable = true;
          autoStart = true;
        };

        tuxclocker = {
          enable = true;
          enabledNVIDIADevices = [ 0 ];
          useUnfree = true;
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
        pkgs.looking-glass-client
        pkgs.ryzenadj
        pkgs.gwe
        pkgs.scream
        pkgs.wireguard-tools
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
