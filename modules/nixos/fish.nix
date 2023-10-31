{ inputs, outputs, self, user, host, lib, config, pkgs, nix-your-shell, ... }: {
  environment.systemPackages = with pkgs; [
    fishPlugins.bass
    #fishPlugins.done
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
      set --global hydro_color_pwd $fish_color_operator
      set --global hydro_color_prompt $fish_color_operator
      set --global hydro_color_git $fish_color_user
      set --global hydro_color_duration $fish_color_normal
    '';
  };
}
