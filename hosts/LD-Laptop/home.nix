{ pkgs, ... }: {
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
    bitwarden
    spotify
    revolt-desktop
    kdePackages.kcalc
    kdePackages.skanlite
    kdePackages.skanpage
    gitkraken
    ngrok
    freeorion
    tor-browser
    ferdium
    minecraft
    geogebra6
    ptouch-print
    obsidian
    linux-wifi-hotspot
    btrfs-assistant
    ryujinx
    webcord
    drawio
    zed-editor
  ];

  programs = {
    brave.enable = true;
    firefox.enable = true;

    kitty = {
      enable = true;
      shellIntegration.enableBashIntegration = true;
      shellIntegration.enableFishIntegration = true;
      settings = {
        background_opacity = "0.93";
        font_size = 11;
        confirm_os_window_close = 0;
      };
    };
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
      nix-your-shell fish | source
    '';
  };
}
