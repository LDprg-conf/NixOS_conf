{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [ discord gparted vscode nixfmt glxinfo vlc ];
}
