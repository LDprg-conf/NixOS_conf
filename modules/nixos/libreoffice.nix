{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    libreoffice-qt
    hunspell
    hunspellDicts.uk_UA
    hunspellDicts.th_TH
  ];
}
