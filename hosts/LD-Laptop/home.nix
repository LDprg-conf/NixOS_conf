# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, flatpaks, self, user, host, lib, config, pkgs, ... }: {
  imports = [
    ../../modules/home-manager/default-apps.nix
    inputs.flatpaks.homeManagerModules.default
  ];

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
    qtcreator
    qbittorrent
    motrix
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

  services.flatpak = {
    packages = [
      "flathub:org.kde.index//stable"
      "flathub:com.spotify.Client/x86_64/stable"
      "flathub:com.axosoft.GitKraken/x86_64/stable"
      "flathub:org.jdownloader.JDownloader/x86_64/stable"
    ];
    remotes = {
      "flathub" = "https://flathub.org/repo/flathub.flatpakrepo";
      "flathub-beta" = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    };
    postInitCommand =
      "bash <(curl -sSL https://raw.githubusercontent.com/SpotX-CLI/SpotX-Linux/main/install.sh) -P ~/.local/share/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/ -cef";
  };
}
