{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 47624 ];
    allowedTCPPortRanges = [
       {
        from = 2300;
        to = 2400;
      }
    ];
    allowedUDPPortRanges = [
       {
        from = 2300;
        to = 2400;
      }
    ];
  };
}
