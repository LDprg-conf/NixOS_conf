{ pkgs, ... }: {
  home.packages = with pkgs; [ discord gparted glxinfo vlc ];
  imports = [ ./vscode.nix ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      nix-your-shell fish | source
    '';
  };
}
