{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  services.ananicy.package = pkgs.ananicy-cpp;
  services.ananicy.enable = true;

  services.ananicy.extraRules = [
    {
      name = "eldenring.exe";
      type = "Game";
    }
    {
      name = "Steam.exe";
      type = "BG_CPUIO";
    }
    {
      name = "steamwebhelper.exe";
      type = "BG_CPUIO";
    }
    {
      name = "steam";
      type = "IN_DIFF";
    }
    {
      name = "steamwebhelper";
      type = "BG_CPUIO";
    }
  ];
}
