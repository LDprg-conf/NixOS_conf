{ pkgs, ... }: {
  home.packages = with pkgs; [ discord gparted glxinfo vlc ];
  imports = [ ./vscode.nix ];
}
