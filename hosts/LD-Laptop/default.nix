# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, user, host, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    ../../modules/default-apps.nix
    ../../modules/systemd-boot.nix
    ../../modules/plasma.nix
    ../../modules/pipewire.nix

    ./hardware.nix
  ];

  users.users = { ld = { description = "LD"; }; };
}
