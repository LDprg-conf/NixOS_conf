{ inputs, pkgs, ... }: {
  imports = [ ./xorg.nix ];

  services.xserver.displayManager.gdm.enable = true;

  programs.xwayland.enable = true;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
}
