{ inputs, outputs, self, user, host, lib, config, pkgs, nix-your-shell, ... }: {
  environment.systemPackages = with pkgs;
    [
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
      fishPlugins.puffer
      fishPlugins.z
      fishPlugins.colored-man-pages
    ] ++ (with self.packages.${pkgs.system}; [ fish-abbreviation-tips gitnow ]);

  programs.fish = {
    enable = true;
    promptInit = ''
      nix-your-shell fish | source
    '';
  };
}
