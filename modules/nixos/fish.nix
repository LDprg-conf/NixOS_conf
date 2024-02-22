{ inputs, outputs, self, user, host, lib, config, pkgs, nix-your-shell, ... }: {
  environment.systemPackages = with pkgs; [
    #fishPlugins.bass
    #fishPlugins.done
    fishPlugins.fzf-fish
    fzf
    fishPlugins.grc
    grc
    fishPlugins.forgit
    fishPlugins.tide
    fishPlugins.sponge
    fishPlugins.autopair
  ];

  programs.fish = {
    enable = true;
    promptInit = ''
      nix-your-shell fish | source
    '';
  };
}
