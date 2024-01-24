{ inputs, outputs, self, user, host, lib, config, pkgs, fenix, ... }: {
  home.packages = with pkgs; [ discord gparted nixfmt glxinfo vlc ];
  imports = [ ./vscode.nix ];
}
