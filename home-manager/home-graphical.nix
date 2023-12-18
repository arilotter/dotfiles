{ lib, config, pkgs, inputs, ... }:

let
  vsc-ext = inputs.vscode-ext.extensions.${pkgs.system}.vscode-marketplace;
in
{

  colorScheme = inputs.nix-colors.colorSchemes.paraiso;

  home.packages = with pkgs; [
    # desktop env
    hyprpaper # wallpaper manager
    gnome3.nautilus # file manager
    pamixer # audio control shell for gbar
    inputs.hypr-contrib.packages.${pkgs.system}.grimblast # screenshot tool
    kitty # terminal emulator
    pavucontrol # audio control
    blueman # bluetooth manager
    wofi # launcher
    wl-clipboard # copy/paste cli
    monado # xr? :D
    sass # for gbar

    easyeffects # mic settings

    vlc # video player
    spotify # music player
    inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin # web browser
    google-chrome # web browser
    discord
    slack

    # VS code setup!
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = [
        vsc-ext.ms-python.python
        vsc-ext.vadimcn.vscode-lldb
        vsc-ext.ms-vsliveshare.vsliveshare
        vsc-ext.golang.go
        vsc-ext.rust-lang.rust-analyzer
        vsc-ext.ms-azuretools.vscode-docker
        vsc-ext.dbaeumer.vscode-eslint
        vsc-ext.svelte.svelte-vscode
        vsc-ext.usernamehw.errorlens
        vsc-ext.github.copilot
        vsc-ext.ms-vscode.cpptools
        vsc-ext.jnoortheen.nix-ide
        # (import ./skyweaver-vscode)
        vsc-ext.tamasfe.even-better-toml
        # vsc-ext.jolaleye.horizon-theme-vscode
        vsc-ext.esbenp.prettier-vscode
        vsc-ext.dbaeumer.vscode-eslint
        vsc-ext.gruntfuggly.todo-tree
        vsc-ext.wallabyjs.quokka-vscode
        vsc-ext.eamodio.gitlens
      ];
    })
  ];

  home.file = {
    ".config/hypr/hyprpaper.conf".text = ''
      preload = /home/ari/dotfiles/wallpapers/future_funk_4k.jpg
      wallpaper = ,/home/ari/dotfiles/wallpapers/future_funk_4k.jpg
    '';
    ".config/gBar/style.css".source = import ./compileSass.nix {
      pkgs = pkgs;
      inputFile = ./gBar/style.scss;
      otherFiles = "${pkgs.writeTextDir "colors.scss" (import ./gBar/colors.scss.nix config)}/colors.scss";
    };
  };

  wayland.windowManager.hyprland =
    {
      enable = true;
      xwayland.enable = true;
      extraConfig = import ./hyprland.nix pkgs;
    };

  programs.gBar = {
    enable = true;
    config = {
      Location = "B";
      EnableSNI = true;
      SNIIconSize = {
        Discord = 26;
        OBS = 23;
      };
      WorkspaceSymbols = [ " " " " ];
    };
  };

  services =
    {
      dunst = import ./dunst.nix pkgs;
      network-manager-applet.enable = true;
    };
  programs.fish = {
    shellAliases = {
      pbpaste = "wl-paste";
      pbcopy = "wl-copy";
    };
    shellInit = ''
      alias code codium

      set -gx GDK_BACKEND wayland
      set -gx MOZ_ENABLE_WAYLAND 1

      set -gx SUDO_EDITOR code
      set -gx VISUAL code
    '';
  };
}
