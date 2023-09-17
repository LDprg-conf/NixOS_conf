{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [ gcc clang llvm jetbrains.clion ];
}
