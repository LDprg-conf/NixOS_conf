{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps:
      with ps; [
        openssl.dev
        pkg-config
        platformio
        zlib
        python3
        gcc
        llvm
        lld
        lldb
        gdb
        clang
        mold
        rust-analyzer-nightly
      ]);
    extensions = with pkgs.vscode-extensions;
      [
        bbenoist.nix
        brettm12345.nixfmt-vscode
        eamodio.gitlens
        esbenp.prettier-vscode
        github.codespaces
        github.vscode-github-actions
        github.vscode-pull-request-github
        jnoortheen.nix-ide
        ms-azuretools.vscode-docker
        ms-dotnettools.csharp
        ms-python.python
        # ms-python.vscode-pylance
        ms-vscode-remote.remote-containers
        ms-vscode-remote.remote-ssh
        ms-vscode.anycode
        ms-vscode.cmake-tools
        # ms-vscode.cpptools
        ms-vscode.hexeditor
        ms-vscode.live-server
        ms-vscode.makefile-tools
        ms-vsliveshare.vsliveshare
        njpwerner.autodocstring
        pkief.material-icon-theme
        rust-lang.rust-analyzer
        serayuzgur.crates
        tamasfe.even-better-toml
        tyriar.sort-lines
        waderyan.gitblame
        yzhang.markdown-all-in-one
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
          sha256 = "sha256-qYlhCioa3LiI67iubC1XQatY5JaeGLT26Q1Q1TWBczo=";
        }
        {
          name = "saturated-dark-modern-oled";
          publisher = "LDprg";
          version = "1.0.6";
          sha256 = "sha256-aV6ZQWJgyzHp/30vG74SPi4Va2ALnFWQnZtWxsv+mug=";
        }
      ];
  };
}
