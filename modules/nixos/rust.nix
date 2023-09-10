{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  nixpkgs.overlays = [ fenix.overlays.default ];
  environment.systemPackages = with pkgs;
    [ rust-analyzer-nightly ]
    ++ (with fenix.packages.${pkgs.system}.minimal.toolchain;
      [
        (fenix.complete.withComponents [
          "cargo"
          "clippy"
          "rust-src"
          "rustc"
          "rustfmt"
        ])
      ]);
}
