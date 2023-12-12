# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  imports = [ ../../modules/home-manager/default-apps.nix ];

  home.packages = with pkgs; [
    kate
    thunderbird
    helvum
    easyeffects
    protonup-qt
    whatsapp-for-linux
    signal-desktop
    quickemu
    element-desktop
    telegram-desktop
    qbittorrent
    nextcloud-client
    freerdp
    bitwarden
    android-tools
    mongodb-compass
    wireshark
    nix-your-shell
    webcord
    spotify
    revolt-desktop
    libsForQt5.kcalc
    gitkraken
    ngrok
    freeorion
    tor-browser
    ferdium
    minecraft
    geogebra
    ptouch-print
    obsidian
    #displaycal
  ];

  programs.brave.enable = true;

  programs.kitty.enable = true;
  programs.kitty.shellIntegration.enableBashIntegration = true;
  programs.kitty.shellIntegration.enableFishIntegration = true;
  programs.kitty.settings = {
    background_opacity = "0.8";
    font_size = 10;
  };

  home.sessionVariables = {
    EDITOR = "code";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
  };
}
