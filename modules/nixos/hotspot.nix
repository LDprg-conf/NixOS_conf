{ inputs, outputs, self, user, host, lib, config, pkgs, nix-your-shell, ... }: 
let
  hotspot= pkgs.writeShellScriptBin "hotspot" ''
    sudo create_ap wlan0 wlan0 LD-Laptop 12345678 --freq-band 2.4 
  '';
in {
  environment.systemPackages = [
      hotspot
    ];
}
