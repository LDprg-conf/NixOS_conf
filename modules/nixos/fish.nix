{ inputs, outputs, self, user, host, lib, config, pkgs, nix-your-shell, ... }: {
  environment.systemPackages = with pkgs; [
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fzf
    fishPlugins.grc
    grc
  ];

  programs.fish = {
    enable = true;
    promptInit = ''
      nix-your-shell fish | source
    '';
  };
}
