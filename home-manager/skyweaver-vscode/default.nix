with import <nixpkgs> {}; let
  inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;
in
  buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "skyweaver-vscode";
      publisher = "arilotter";
      version = "0.0.1";
      sha256 = "0sm2fr9zbk1759r52dpnz9r7xbvxladlpinlf2i0hyaa06bhp3b1";
    };

    vsix = ./skyweaver-vscode-0.0.1.zip;

    meta = {
      description = ''
        Visual Studio Code plugin for developing Skyweaver cards
      '';
    };
  }
