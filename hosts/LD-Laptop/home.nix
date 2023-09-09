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
    gitkraken
  ];

  services.flatpak = {
    packages = [
      "flathub:org.kde.index//stable"
      "flathub:com.spotify.Client/x86_64/stable"
      "flathub:com.axosoft.GitKraken/x86_64/stable"
    ];
    remotes = {
      "flathub" = "https://flathub.org/repo/flathub.flatpakrepo";
      "flathub-beta" = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    };
    postInitCommand = "bash <(curl -sSL https://raw.githubusercontent.com/SpotX-CLI/SpotX-Linux/main/install.sh) -P ~/.local/share/flatpak/app/com.spotify.Client/x86_64/stable/active/files/extra/share/spotify/ -cef";
  };
}
