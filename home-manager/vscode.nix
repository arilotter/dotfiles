{
  pkgs,
  inputs,
  ...
}:
let
  vsc-ext = inputs.vscode-ext.extensions.${pkgs.system}.vscode-marketplace;
in
{
  home.sessionVariables = {
    SUDO_EDITOR = "code";
    VISUAL = "code";
  };

  programs.git.extraConfig.core.editor = "code --wait";

  programs.vscode = {
    enable = true;
    extensions = with vsc-ext; [
      bierner.markdown-mermaid
      ms-vscode-remote.remote-containers
      semanticdiff.semanticdiff
      ms-python.python
      ms-python.vscode-pylance
      ms-python.black-formatter
      golang.go
      rust-lang.rust-analyzer
      dbaeumer.vscode-eslint
      usernamehw.errorlens
      jnoortheen.nix-ide
      # (import ./skyweaver-vscode)
      tamasfe.even-better-toml
      # jolaleye.horizon-theme-vscode
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint
      gruntfuggly.todo-tree
      wallabyjs.quokka-vscode
      yoavbls.pretty-ts-errors
      slevesque.shader
      xaver.clang-format
      ms-playwright.playwright
      ms-vscode-remote.remote-ssh
    ];

    userSettings = {
      "files.autoSave" = "afterDelay";
      "files.autoSaveDelay" = 150;
      "editor.multiCursorLimit" = 50000;
      "window.menuBarVisibility" = "toggle";
      "editor.inlayHints.enabled" = "offUnlessPressed";
      "editor.formatOnSave" = true;
      "typescript.tsserver.experimental.enableProjectDiagnostics" = true;
    };
  };
}
