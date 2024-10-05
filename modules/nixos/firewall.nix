_: {
  networking.firewall = {
    enable = true;
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
    }
      {
        from = 21114;
        to = 21119; # Rustdesk
      }];
    allowedUDPPorts = [
      35862 # Cosmoteer
      51820 # Wireguard
      17771 # hamachi
      34197 # Factorio
      30502 # RimWorld
      34314 # RimWorld
      21116 # Rustdesk
    ];
    allowedUDPPortRanges = [{
      from = 2300;
      to = 2400; # DirectPlay
    }];
  };
}
