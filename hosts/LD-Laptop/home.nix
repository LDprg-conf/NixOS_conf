# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, user, host, lib, config, pkgs, ... }: {
  home = {
    packages = with pkgs; [
      firefox
      gparted
      kate
      thunderbird
      vscode
      nixfmt
      discord
      helvum
      easyeffects
      steam
      protonup-qt
      whatsapp-for-linux
      signal-desktop
    ];
  };
}
