{ inputs
, outputs
, self
, user
, host
, lib
, config
, pkgs
, fenix
, rust-overlay
, ...
}: {
  imports = [
    ../../modules/nixos/default-apps.nix

    ../../modules/nixos/ananicy.nix
    ../../modules/nixos/apparmor.nix
    ../../modules/nixos/docker.nix
    ../../modules/nixos/firewall.nix
    ../../modules/nixos/fish.nix
    ../../modules/nixos/grub.nix
    ../../modules/nixos/hotspot.nix
    ../../modules/nixos/kernel-latest.nix
    ../../modules/nixos/libreoffice.nix
    ../../modules/nixos/pipewire.nix
    ../../modules/nixos/plasma.nix

    ./hardware.nix
  ];

  nixpkgs.overlays = [
    fenix.overlays.default
    rust-overlay.overlays.default
  ];

  # system.autoUpgrade = {
  #   enable = true;
  #   allowReboot = false;
  #   randomizedDelaySec = "45min";
  #   operation = "boot";
  #   dates = "daily";
  #   flake = inputs.self.outPath;
  #   flags = [
  #     "--update-input"
  #     "nixpkgs"
  #     "--commit-lock-file"
  #     "-L" # print build logs
  #   ];
  # };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-kde ];
  };

  users.users.ld = {
    description = "LD";
    shell = pkgs.fish;
  };

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };

  users.defaultUserShell = pkgs.fish;
  environment.shells = with pkgs; [ fish ];

  environment.systemPackages = with pkgs;
    [
      wayland-utils
      clinfo
      openrgb
      mangohud
      git
      pre-commit
      esptool
      antimicrox
      nix-your-shell
      cifs-utils
      samba
      simple-http-server
      appimage-run
      fuse
      fuse3
      niv
      gamescope-wsi
      fira
      fira-code
      fira-code-nerdfont
    ] ++ (with self.packages.${pkgs.system}; [ jdownload2 fdm vk_hdr_layer ])
    ++ (with self.inputs.nix-alien.packages.${system}; [ nix-alien ]);

  specialisation."VFIO".configuration = {
    system.nixos.tags = [ "with-vfio" ];
    vfio.enable = true;
  };

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = "\\xff\\xff\\xff\\xff\\x00\\x00\\x00\\x00\\xff\\xff\\xff";
    magicOrExtension = "\\x7fELF....AI\\x02";
  };

  services.hardware.bolt.enable = true;
  programs.gnupg.agent.enable = true;

  services.udev.packages = [ pkgs.openrgb ];

  security.polkit.enable = true;

  services.preload.enable = true;

  services.logmein-hamachi.enable = true;
  programs.haguichi.enable = true;

  programs.gamescope.enable = true;
  programs.gamescope.env = {
    ENABLE_HDR_WSI = "1";
  };

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;

    packages = with pkgs; [
      ubuntu_font_family

      fira-code
      fira-code-symbols
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Ubuntu" ];
        sansSerif = [ "Ubuntu" ];
        monospace = [ "FiraCode" ];
      };
    };
  };


  programs.gamemode.enable = true;
  programs.gamemode.settings = {
    general = {
      renice = 0;
      ioprio = ''"off"'';
    };
  };

  hardware.bluetooth.enable = true;

  services.joycond.enable = true;

  programs.nix-ld.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu.ovmf.enable = true;
    qemu.runAsRoot = false;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };
  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;

  networking.nameservers =
    [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];

  services.resolved = {
    enable = true;
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
  };
}
