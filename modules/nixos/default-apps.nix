{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  imports = [ ./lutris.nix ./steam.nix ./vscode.nix ];
}
