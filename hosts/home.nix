# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # TODO: Set your username
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
    ];
  };
}
