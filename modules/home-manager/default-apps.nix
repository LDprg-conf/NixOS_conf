{ inputs, outputs, user, host, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [ firefox discord gparted vscode nixfmt ];
}
