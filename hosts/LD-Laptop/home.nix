# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, flatpaks, self, user, host, lib, config, pkgs, ... }: {
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
    nodejs
    yarn
    qbittorrent
    nextcloud-client
    freerdp
    bitwarden
    android-tools
    vivaldi
    mongodb-compass
    wireshark
    nix-your-shell
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

  services.flatpak = {
    deduplicate = false;
    packages = [
      "flathub:app/org.kde.index//stable"
      "flathub:app/com.spotify.Client/x86_64/stable"
      "flathub:app/com.axosoft.GitKraken/x86_64/stable"
      "flathub:app/org.freedownloadmanager.Manager/x86_64/stable"
    ];
    remotes = { "flathub" = "https://flathub.org/repo/flathub.flatpakrepo"; };
    postInitCommand =
      "bash <(curl -sSL https://raw.githubusercontent.com/SpotX-CLI/SpotX-Linux/main/install.sh) -P ~/.local/share/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/ -cef";
  };
}
