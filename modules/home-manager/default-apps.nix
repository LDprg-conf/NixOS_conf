{ inputs, outputs, user, host, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [ discord gparted vscode nixfmt ];
  programs.firefox.enable = true;
}
