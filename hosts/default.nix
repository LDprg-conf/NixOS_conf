# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, self, user, host, lib, config, pkgs, nix-your-shell, ... }: {
  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
    overlays = [
      (final: prev: {
        spotify = prev.spotify.overrideAttrs (attrs:
          let
            patchScript = prev.fetchurl {
              url =
                "https://raw.githubusercontent.com/SpotX-CLI/SpotX-Linux/main/install.sh";
              hash = "sha256-QmV3Fln/EhzAqTn1Zhcz1NDprhClUoFFmETA644+lUA=";
            };
          in {
            buildInputs = [ prev.perl prev.unzip prev.zip ];
            postInstall = (attrs.postInstall or "") + ''
                  cp ${patchScript} install.sh
                  chmod +x install.sh
              	  bash install.sh -P $out/share/spotify/ -cef
              	'';
          });
      })
      (final: prev: {
        gitkraken = prev.gitkraken.overrideAttrs (attrs:
          let
            patchScript = prev.fetchurl {
              url = "https://archive.org/download/git-cracken/GitCracken.zip";
              hash = "sha256-IdJXtgXOZe+h+80EDsXhX6CLqAJbc3LqqH3nfATXX/w=";
            };
          in {
            buildInputs = [
              prev.yarn
              prev.nodePackages.rimraf
              prev.nodePackages.typescript
              prev.nodejs
              prev.unzip
            ];

            prePatch = ''
              unzip ${patchScript} -d gitcracken-patch
            '';

            patches = [
              ./gitcracken.patch
            ];

            postInstall = (attrs.postInstall or "") + ''
                  cd gitcracken-patch/GitCracken-main

                  chmod 775 -R *

                  yarn build

                  yarn run gitcracken patcher --asar $out/share/gitkraken/resources/app.asar

                  #ls -al $out/share/gitkraken/resources

                  exit 111
              	'';
          });
      })
    ];
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    # Grabage Collector
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      trusted-users = [ "root" ];
    };
  };

  # TODO: Set your hostname
  networking.hostName = "${host}";

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  console.keyMap = "de";

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "wireshark" "docker" ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    gh
    neofetch
    ranger
    lshw
    unzip
    zip
    unrar
    rar
    curl
    htop
    killall
    ripgrep
    tree
    iftop
    cachix
  ];

  services.fwupd.enable = true;
  services.irqbalance.enable = true;

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  zramSwap.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "unstable";
}
