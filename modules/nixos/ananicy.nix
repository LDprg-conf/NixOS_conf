{ pkgs, ... }: {
  services = {
    ananicy = {
      package = pkgs.ananicy-cpp;
      enable = true;

      extraRules = [
        # Games
        {
          name = "RelicCoH3.exe";
          type = "Game";
        }
        {
          name = "Ryujinx";
          type = "Game";
        }
        {
          name = "Hearthstone.exe";
          type = "Game";
        }
        {
          name = "factorio.exe";
          type = "Game";
        }
        {
          name = "Magicraft.exe";
          type = "Game";
        }
        {
          name = "BackpackBattles.x86_64";
          type = "Game";
        }
        {
          name = "gamescope-wl";
          type = "Game";
        }
        {
          name = "CivilizationVI.exe";
          type = "Game";
        }
        {
          name = "bg3_dx11.exe";
          type = "Game";
        }
        {
          name = "bg3.exe";
          type = "Game";
        }
        {
          name = "AssassinsCreed_Dx10.exe";
          type = "Game";
        }
        {
          name = "AssassinsCreed_Dx9.exe";
          type = "Game";
        }
        {
          name = "AssassinsCreed_Game.exe";
          type = "Game";
        }
        {
          name = "eldenring.exe";
          type = "Game";
        }
        {
          name = "AoE2DE_s.exe";
          type = "Game";
        }

        # Compiles
        {
          name = "nix";
          type = "compiler";
        }
        {
          name = "rustc";
          type = "compiler";
        }

        # Chat
        {
          name = ".ferdium-wrapped";
          type = "Chat";
        }

        # Browsers
        {
          name = ".brave-wrapped";
          type = "Doc-View";
        }

      ];
    };
  };

  environment.systemPackages = with pkgs; [ ananicy-rules-cachyos ];
}
