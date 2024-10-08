{ inputs
, self
, lib
, pkgs
, fenix
, rust-overlay
, ...
}:
{
  imports = [
    ../../modules/nixos/apparmor.nix
    ../../modules/nixos/firewall.nix
    ../../modules/nixos/fish.nix
    ../../modules/nixos/grub.nix
    ../../modules/nixos/hotspot.nix
    ../../modules/nixos/kernel-latest.nix
    ../../modules/nixos/libreoffice.nix
    ../../modules/nixos/lutris.nix
    ../../modules/nixos/pipewire.nix
    ../../modules/nixos/plasma.nix
    ../../modules/nixos/podman.nix
    ../../modules/nixos/steam.nix

    ./hardware.nix
  ];

  nixpkgs.overlays = [
    fenix.overlays.default
    rust-overlay.overlays.default
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-kde ];
  };

  users = {
    users.ld.description = "LD";

    defaultUserShell = pkgs.fish;
  };

  environment.shells = with pkgs; [ fish ];

  environment.systemPackages =
    with pkgs;
    [
      wayland-utils
      clinfo
      openrgb
      mangohud
      pre-commit
      esptool
      antimicrox
      nix-your-shell
      cifs-utils
      samba
      simple-http-server
      appimage-run
      fuse
      fuse3
      niv
      gamescope-wsi
      fira
      fira-code
      fira-code-nerdfont
      distrobox
      openconnect
      networkmanager-openconnect
      zoom-us
      jetbrains.idea-ultimate
      jetbrains.idea-community-bin
      # config.nur.repos.sikmir.mqtt-explorer
    ]
    ++ (with self.packages.${pkgs.system}; [
      jdownload2
      fdm
      vk_hdr_layer
    ])
    ++ (with self.inputs.nix-alien.packages.${system}; [ nix-alien ]);

  specialisation."VFIO".configuration = {
    system.nixos.tags = [ "with-vfio" ];
    vfio.enable = true;
  };

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = "\\xff\\xff\\xff\\xff\\x00\\x00\\x00\\x00\\xff\\xff\\xff";
    magicOrExtension = "\\x7fELF....AI\\x02";
  };

  services = {
    udev.packages = [ pkgs.openrgb ];

    xserver.wacom.enable = true;

    logmein-hamachi.enable = true;

    joycond.enable = true;

    # resolved = {
    #   enable = true;
    #   dnssec = "true";
    #   domains = [ "~." ];
    #   fallbackDns = [
    #     "1.1.1.1#one.one.one.one"
    #     "1.0.0.1#one.one.one.one"
    #   ];
    #   dnsovertls = "true";
    # };
  };

  programs = {
    haguichi.enable = true;

    gamescope = {
      enable = true;
      env = {
        DXVK_HDR = "1";
      };
      args = [
        "--hdr-enabled"
      ];
    };

    gamemode.enable = true;

    virt-manager.enable = true;
    nix-ld.enable = true;
    gnupg.agent.enable = true;
  };

  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;

    packages = with pkgs; [
      ubuntu_font_family

      fira-code
      fira-code-symbols
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Ubuntu" ];
        sansSerif = [ "Ubuntu" ];
        monospace = [ "FiraCode" ];
      };
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };

    opentabletdriver.enable = true;
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      ovmf.enable = true;
      runAsRoot = false;
      swtpm.enable = true;
    };
    onBoot = "ignore";
    parallelShutdown = 10;
  };
  virtualisation.spiceUSBRedirection.enable = true;

  networking.nameservers = [
    "1.1.1.1#one.one.one.one"
    "1.0.0.1#one.one.one.one"
  ];

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false; # Decrease boot time by disabeling network wait
}
