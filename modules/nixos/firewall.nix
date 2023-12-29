{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  networking.firewall = {
    enable = false;
    extraCommands =
      "iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns"; # Samba discovery fix
    allowedTCPPorts = [
      53
      80 # HTTP
      443 # HTTPS
      47624 # DirectPlay
      10099 # Desynced
    ];
    allowedTCPPortRanges = [{
      from = 2300;
      to = 2400; # DirectPlay
    }];
    allowedUDPPorts = [
      35862 # Cosmoteer
      51820 # Wireguard
      17771 # hamachi
      34197 # Factorio
    ];
    allowedUDPPortRanges = [{
      from = 2300;
      to = 2400; # DirectPlay
    }];
  };
}
