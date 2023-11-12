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
                "https://raw.githubusercontent.com/SpotX-Official/SpotX-Bash/main/spotx.sh";
              hash = "sha256-uXWzNrX9LixGx9IwP7Y0VSiXXp6RTbjqqGfqsU5mPoM=";
            };
          in {
            buildInputs = [ prev.perl prev.unzip prev.zip ];
            postInstall = (attrs.postInstall or "") + ''
                  cp ${patchScript} spotx.sh
                  chmod +x spotx.sh
              	  bash spotx.sh -P $out/share/spotify/ -ch
              	'';
          });
      })
      (final: prev: {
        gitkraken = prev.gitkraken.overrideAttrs (attrs:
          let
            patchScript = prev.fetchurl {
              url =
                "https://archive.org/download/git-cracken_202310/GitCracken.zip";
              hash = "sha256-v3CHPwyJf7iiwAweWNfW5wDuXWT3ijWqhfiDGNf0krs=";
            };
          in {
            buildInputs = [
              prev.unzip
              prev.nodejs
              prev.yarn
              prev.nodePackages.rimraf
              prev.nodePackages.typescript
            ];

            postFixup = (attrs.postFixup or "") + ''
              unzip ${patchScript} -d gitcracken-patch
              cd gitcracken-patch/GitCracken

              chmod 775 -R *

              yarn build

              chmod +w $out/share/gitkraken/resources

              yarn run gitcracken patcher --asar $out/share/gitkraken/resources/app.asar >> /dev/null             
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
      warn-dirty = false;
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      trusted-users = [ "root" "ld" ];
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
    extraGroups = [ "networkmanager" "wheel" "wireshark" "docker" "dialout" ];
  };
  # users.users.test = {
  #   isNormalUser = true;
  #   extraGroups = [ "networkmanager" "wheel" "wireshark" "docker" "dialout" ];
  # };

  environment.systemPackages = with pkgs; [
    neovim
    vim
    wget
    git
    gh
    neofetch
    ranger
    lshw
    unzip
    zip
    xz
    unrar
    rar
    curl
    htop
    btop
    killall
    ripgrep
    tree
    iftop
    iotop
    nethogs
    cachix
    pciutils
    rsync
    progress
  ];

  services.fwupd.enable = true;
  services.irqbalance.enable = true;

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  zramSwap.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "unstable";
}
