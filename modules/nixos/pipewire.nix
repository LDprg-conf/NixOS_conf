{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  imports = [ inputs.nix-gaming.nixosModules.pipewireLowLatency ];

  environment.systemPackages = with pkgs; [ pavucontrol ];

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    lowLatency = {
      enable = true;
      quantum = 96;
      rate = 48000;
    };
  };

}
