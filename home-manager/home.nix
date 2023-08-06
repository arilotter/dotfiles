{ config, pkgs, inputs, ... }:

let
  vsc-ext = inputs.vscode-ext.extensions.${pkgs.system}.vscode-marketplace;
in
{
  home = {
    username = "ari";
    homeDirectory = "/home/ari";
    stateVersion = "23.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  };

  programs.home-manager.enable = true;

  # systemd.user.startServices = "sd-switch";

  colorScheme = inputs.nix-colors.colorSchemes.paraiso;

  home.packages = with pkgs; [
    # shell config
    starship # prompt
    exa # ls replacement

    # desktop env
    hyprpaper # wallpaper manager
    gnome3.nautilus # file manager
    pamixer # audio control shell for gbar
    inputs.hypr-contrib.packages.${pkgs.system}.grimblast # screenshot tool
    upower # battery
    wezterm # terminal emulator
    pavucontrol # audio control
    blueman # bluetooth manager
    wofi # launcher
    wl-clipboard # copy/paste cli
    neofetch # i mean, c'mon :)
    monado # xr? :D

    vlc # video player
    spotify # music player
    inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin # web browser
    google-chrome # web browser
    discord
    slack

    # TUI tools
    bottom # system manager, like htop
    lazydocker # docker manager
    lazygit # git manager

    # command-line utils
    thefuck
    file # file type identification
    graphviz # graph visualization
    toilet # text to ascii art
    jq # json processing tool
    ripgrep # grep replacement
    tokei # code LoC
    imagemagickBig


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
        vsc-ext.rvest.vs-code-prettier-eslint
      ];
    })


    # programming tools
    jdk11 # java
    nixpkgs-fmt # nix formatting tool
    trickle # limit bandwidth artificially
    wabt # webassembly binary tools
    google-cloud-sdk # google cloud sdk
    awscli # aws cli
    ansible # ansible devops bullshit
    wabt # wasm binary toolkit

    # programming languages
    go
    python3Full
    lua
    rustup
    nodejs_latest

    # build tools
    pkg-config
    gnumake
    cmake
    clang

    # debuggers
    lldb
    gdb
    valgrind

    # graphics tools
    pngquant # png compression
  ];

  home.file = {
    ".config/hypr/hyprpaper.conf".text = ''
      preload = /home/ari/dotfiles/wallpapers/future_funk_4k.jpg
      wallpaper = ,/home/ari/dotfiles/wallpapers/future_funk_4k.jpg
    '';
    ".config/gBar/style.css".source = ./gBar/style.css;
    ".config/gBar/style.scss".source = ./gBar/style.scss;
  };
  home.sessionVariables = { };

  wayland.windowManager.hyprland =
    {
      enable = true;
      xwayland =
        { enable = true; hidpi = true; };
      nvidiaPatches = true;
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
  programs.direnv.enable = true;
  services =
    {
      dunst = import ./dunst.nix pkgs;
      network-manager-applet.enable = true;
    };
  programs.fish = {
    enable = true;
    shellAliases = {
      gcp = "git cherry-pick";
      pbpaste = "wl-paste";
      pbcopy = "wl-copy";
      netcopy = ''nc -q 0 tcp.st 7777 | grep URL | cut -d " " -f 2 | pbcopy'';
      reload-fish = "exec fish";
      fix-bluetooth-audio = ''
        pacmd set-card-profile (pacmd list-sinks | sed -n "s/card: \([0-9]*\) <bluez.*/\1/p" | xargs) a2dp_sink'';
      gs = "git status";
      gp = "git pull";
      gc = "git commit -m";
      gca = "git commit --amend";
      gl = "git log";
      gf = "git fetch -p";
      ls = "exa";
      lg = "lazygit";
      ld = "lazydocker";
      gcm = "git checkout master";
      gco = "git checkout";
      p = "pnpm";
    };
    shellInit = ''
      starship init fish | source
      source ~/dotfiles/secrets
      

      set -gx GDK_BACKEND wayland
      set -gx MOZ_ENABLE_WAYLAND 1

      set -gx SUDO_EDITOR code
      set -gx VISUAL code

      set -gx ANDROID_HOME $HOME/Android/Sdk
      set -gx PATH $PATH ~/.yarn/bin ~/.npm/bin ~/bin ~/go/bin ~/.cargo/bin $ANDROID_HOME/emulator $ANDROID_HOME/tools $ANDROID_HOME/tools/bin $ANDROID_HOME/platform-tools

      function checkout-last-version
        set card $argv[1]
        git checkout (git rev-list -n 1 HEAD -- "$card")^ -- "$card"
      end

      set -gx SW_API_HOST "https://local-skyweaver-api.0xhorizon.net"
      set -gx SW_AUTH_TOKEN "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NvdW50IjoiMHgyMDM3MTI0NzMwZjRkMmQ1MTI0OGQyYzA1ZDJhZTVjYmQyODhlZDY3IiwiYXBwIjoiU2t5d2VhdmVyIiwiZXhwIjoxNjU1ODM2Nzg4LCJpYXQiOjE2MjQzMDA3ODgsIm9nbiI6Imh0dHBzOi8vbG9jYWwuMHhob3Jpem9uLm5ldCJ9.rFCF1PhcAEJbUdMB4LFd4L6ElqA8rtxMi46gK8fQBB"

      thefuck --alias | source
    '';
  };
  programs.git = {
    enable = true;
    userEmail = "arilotter@gmail.com";
    userName = "Ari Lotter";
    extraConfig.core.editor = "code --wait";
    extraConfig.pull.rebase = true;
    extraConfig.rebase.autoStash = true;
    extraConfig.diff.tool = "default-difftool";
    extraConfig.push.default = "simple";
    extraConfig.push.autoSetupRemote = true;
    extraConfig.url."git@github.com:".insteadOf = "https://github.com/";
    lfs.enable = true;
    delta.enable = true;
  };

  nixpkgs = {
    # workaround for https://github.com/nix-community/home-manager/issues/2942
    config.allowUnfreePredicate = (pkg: true);
  };
}
