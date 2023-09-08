# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, user, host, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    ../../modules/nixos/default-apps.nix
    ../../modules/nixos/systemd-boot.nix
    ../../modules/nixos/plasma.nix
    ../../modules/nixos/pipewire.nix
    ../../modules/nixos/fish.nix
    ../../modules/nixos/nvidia.nix

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

  hardware.nvidia.prime = {
    amdBusId = "PCI:6:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}
