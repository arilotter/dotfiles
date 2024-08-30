{ pkgs, inputs, ... }:

let
  vsc-ext = inputs.vscode-ext.extensions.${pkgs.system}.vscode-marketplace;
in
{
  colorScheme = inputs.nix-colors.colorSchemes."solarized-light";

  imports = [
    ./hyprland.nix
    ./kitty.nix
    ./mako.nix
    ./firefox.nix
    ./rofi.nix
    ./waybar.nix
    ./discord.nix
    ./supersonic.nix
    ./colors.nix
  ];

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Nordzy-cursors";
    size = 48;
    package = pkgs.nordzy-cursor-theme;
  };

  home.packages = with pkgs; [
    # desktop env
    hyprpaper # wallpaper manager
    nautilus # file manager
    inputs.hypr-contrib.packages.${pkgs.system}.grimblast # screenshot tool
    pavucontrol # audio control
    blueman # bluetooth manager
    wl-clipboard # copy/paste cli
    monado # xr? :D

    #oooooooooh ai
    lmstudio
    # 3d pwint
    prusa-slicer

    easyeffects # mic settings

    vlc # video player
    google-chrome # web browser
    slack

    (vscode-with-extensions.override {
      vscodeExtensions = with vsc-ext; [
        bierner.markdown-mermaid
        supermaven.supermaven
        arrterian.nix-env-selector
        ms-vscode-remote.remote-containers
        semanticdiff.semanticdiff
        ms-python.python
        ms-python.vscode-pylance
        ms-python.black-formatter
        ms-vsliveshare.vsliveshare
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
        biomejs.biome
        yoavbls.pretty-ts-errors
        slevesque.shader
        xaver.clang-format
        ms-playwright.playwright
      ];
    })

    #clang format needs..
    clang-tools
  ];

  home.file = {
    ".config/hypr/hyprpaper.conf".text = ''
      preload = /home/ari/dotfiles/wallpapers/future_funk_4k.jpg
      wallpaper = ,/home/ari/dotfiles/wallpapers/future_funk_4k.jpg
    '';
  };

  programs.git.extraConfig.core.editor = "code --wait";

  programs.fish = {
    shellAliases = {
      pbpaste = "wl-paste";
      pbcopy = "wl-copy";
    };
    shellInit = ''

      set -gx GDK_BACKEND wayland
      set -gx MOZ_ENABLE_WAYLAND 1

      set -gx SUDO_EDITOR code
      set -gx VISUAL code
    '';
  };
}
