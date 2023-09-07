# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, user, host, lib, config, pkgs, ... }: {
  imports = [
    ../../modules/home-manager/default-apps.nix
  ];

  home.packages = with pkgs; [
    firefox
    gparted
    kate
    thunderbird
    vscode
    nixfmt
    helvum
    easyeffects
    protonup-qt
    whatsapp-for-linux
    signal-desktop
  ];
}
