{ pkgs, ... }: {
  imports = [ ./xorg.nix ];

  environment.systemPackages = with pkgs; [
    kdePackages.plasma-thunderbolt
    kdePackages.filelight
    kdePackages.sddm-kcm
    kdePackages.colord-kde
    xwaylandvideobridge
    partition-manager
  ];

  services = {
    # xserver.displayManager.sddm = {
    #   enable = true;
    #   wayland.enable = true;

    #   settings = {
    #     Theme = {
    #       Current = "breeze";
    #       ThemeDir = "/sddmt";
    #     };
    #   };
    # };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command =
            "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd startplasma-wayland";
          user = "greeter";
        };
      };
    };

    desktopManager.plasma6.enable = true;
  };

  programs.xwayland.enable = true;
  programs.kdeconnect.enable = true;
}
