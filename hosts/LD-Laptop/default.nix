# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    ../../modules/nixos/default-apps.nix
    ../../modules/nixos/grub.nix
    ../../modules/nixos/plasma.nix
    ../../modules/nixos/pipewire.nix
    ../../modules/nixos/fish.nix
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/kernel-latest.nix
    ../../modules/nixos/rust.nix
    ../../modules/nixos/cpp.nix

    ./hardware.nix
  ];

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
    [ nvtop mangohud git pre-commit python3 ]
    ++ (with self.packages.${pkgs.system}; [ fdm ]);
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

  #services.xserver.autorun = false;

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

  hardware.bluetooth.enable = true;

  services.ananicy.package = pkgs.ananicy-cpp;
  services.ananicy.enable = true;

  programs.java = {
    enable = true;
    package = pkgs.openjdk19;
  };
}
