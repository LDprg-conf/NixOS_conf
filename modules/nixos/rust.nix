{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  nixpkgs.overlays = [ inputs.fenix.overlays.default ];
  environment.systemPackages = with pkgs;
    [ rust-analyzer-nightly ]
    ++ (with inputs.fenix.packages.${pkgs.system}.minimal.toolchain;
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
