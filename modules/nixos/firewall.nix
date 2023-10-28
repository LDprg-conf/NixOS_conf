{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  networking.firewall = {
    enable = true;
    extraCommands =
      "iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns";
    allowedTCPPorts = [ 47624 ];
    allowedTCPPortRanges = [{
      from = 2300;
      to = 2400;
    }];
    allowedUDPPortRanges = [{
      from = 2300;
      to = 2400;
    }];
  };
}
