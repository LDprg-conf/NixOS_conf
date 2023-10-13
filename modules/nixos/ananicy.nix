{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  services.ananicy.package = pkgs.ananicy-cpp;
  services.ananicy.enable = true;

  services.ananicy.extraRules = [
    # Games
    {
      name = "eldenring.exe";
      type = "game";
    }
    {
      name = "AoE2DE_s.exe";
      type = "game";
    }
    
    # Compiles
    {
      name = "nix";
      type = "compiler";
    }
  ];
  

  environment.systemPackages = with pkgs; [ ananicy-rules-cachyos ];
}
