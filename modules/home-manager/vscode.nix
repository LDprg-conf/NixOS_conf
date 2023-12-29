{ inputs, outputs, self, user, host, lib, config, pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages
      (ps: with ps; [ rustup platformio zlib openssl.dev pkg-config ]);
    extensions = with pkgs.vscode-extensions;
      [
        ms-python.python
        ms-python.vscode-pylance
        ms-vscode.anycode
        ms-vscode.cpptools
        ms-vscode.cmake-tools
        ms-vscode.makefile-tools
        ms-vscode.live-server
        ms-vsliveshare.vsliveshare
        ms-vscode-remote.remote-ssh
        ms-vscode.hexeditor
        ms-dotnettools.csharp
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-containers
        tamasfe.even-better-toml
        bbenoist.nix
        jnoortheen.nix-ide
        brettm12345.nixfmt-vscode
        esbenp.prettier-vscode
        njpwerner.autodocstring
        serayuzgur.crates
        yzhang.markdown-all-in-one
        rust-lang.rust-analyzer
        eamodio.gitlens
        github.vscode-github-actions
        github.vscode-pull-request-github
        github.codespaces
        waderyan.gitblame
        tyriar.sort-lines
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "remote-ssh-edit";
          publisher = "ms-vscode-remote";
          version = "0.86.0";
          sha256 = "sha256-JsbaoIekUo2nKCu+fNbGlh5d1Tt/QJGUuXUGP04TsDI=";
        }
        {
          name = "platformio-ide";
          publisher = "platformio";
          version = "3.3.2";
          sha256 = "sha256-r+ekcYFAbM8tWTUpIH1/ns2i6QC/RK6MWsjA8Xll+80=";
        }
      ];
  };
}
