# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, self, user, host, lib, config, pkgs, nix-your-shell, ... }: {
  # You can import other NixOS modules here
  imports = [
    ../../modules/nixos/default-apps.nix
    ../../modules/nixos/grub.nix
    ../../modules/nixos/pipewire.nix
    ../../modules/nixos/fish.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/kernel-latest.nix
    ../../modules/nixos/rust.nix
    ../../modules/nixos/cpp.nix
    ../../modules/nixos/libreoffice.nix
    ../../modules/nixos/firewall.nix
    ../../modules/nixos/ananicy.nix
    ../../modules/nixos/apparmor.nix
    ../../modules/nixos/docker.nix
    ../../modules/nixos/preload.nix

    ./hardware.nix

    ../../modules/nixos/plasma.nix
  ];

  # specialisation = {
  #   hyprland.configuration = {
  #     system.nixos.tags = [ "hyprland" ];
  #     imports = [ ../../modules/nixos/hyprland.nix ];
  #   };
  # };

  nixpkgs.overlays = [ nix-your-shell.overlays.default ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-kde xdg-desktop-portal-gtk ];
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
      #nvtop
      mangohud
      git
      pre-commit
      python3
      esptool
      antimicrox
      libnotify
      nix-your-shell
      direnv
    ];

  services.preload.enable = true;

  programs.gamescope.enable = true;

  services.flatpak.enable = true;
  services.flatpak = {
    packages = [ "flathub:org.kde.index//stable" ];
    remotes = {
      "flathub" = "https://flathub.org/repo/flathub.flatpakrepo";
      "flathub-beta" = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    };
  };

  boot.loader.timeout = 3;

  hardware.nvidia.prime = {
    sync.enable = true;
    #offload.enable = true;
    #offload.enableOffloadCmd = true;

    amdgpuBusId = "PCI:6:0:0";
    nvidiaBusId = "PCI:1:0:0";
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

  powerManagement.enable = true;
  programs.gamemode.enable = true;
  programs.gamemode.settings = {
    general = {
      renice = 0;
      ioprio = ''"off"'';
    };
  };

  hardware.bluetooth.enable = true;

  services.joycond.enable = true;

  programs.java = {
    enable = true;
    package = pkgs.openjdk19;
  };
}
