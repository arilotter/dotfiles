{ config, pkgs, nix-colors, e, ... }:

let
  mozilla = import (builtins.fetchGit {
    url = "https://github.com/mozilla/nixpkgs-mozilla.git";
    ref = "master";
  });

in
{
  home.username = "ari";
  home.homeDirectory = "/home/ari";
  home.stateVersion = "23.05"; # Don't change unless instructed

  colorScheme = nix-colors.colorSchemes.paraiso;

  home.packages = with pkgs; [
    # shell config
    starship # prompt
    exa # ls replacement
    sudoedit # edit files as root w/o ur editor being root

    # desktop env
    hyprpaper # wallpaper manager
    gnome3.nautilus # file manager
    pamixer # audio control shell for gbar
    e.packages.x86_64-linux.grimblast # screenshot tool
    upower # battery
    wezterm # terminal emulator
    pavucontrol # audio control
    blueman # bluetooth manager
    wofi # launcher
    wl-clipboard # copy/paste cli
    neofetch # i mean, c'mon :)

    vlc # video player
    spotify # music player
    firefox # web browser
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
      vscodeExtensions = with vscode-extensions; [
        ms-python.python
        vscode-extensions.vadimcn.vscode-lldb
        ms-vsliveshare.vsliveshare
        golang.go
        matklad.rust-analyzer
        ms-azuretools.vscode-docker
        dbaeumer.vscode-eslint
        svelte.svelte-vscode
        usernamehw.errorlens
        github.copilot
        ms-vscode.cpptools
        (import ./skyweaver-vscode)
      ]
      ++ vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "platformio-ide";
          publisher = "platformio";
          version = "2.5.2";
          sha256 = "sha256-4Ukoj+gjDnKtIuKaaeiTQJooTeQEzeRfxJOg6E72mi8=";
        }
        {
          name = "vitest-explorer";
          publisher = "ZixuanChen";
          version = "0.2.39";
          sha256 = "sha256-W5u493ubJ/qjEnPt7qUTIriHOvfpqSheYjaC5MSXlTQ=";
        }

        {
          name = "tsl-problem-matcher";
          publisher = "amodio";
          version = "0.6.2";
          sha256 = "sha256-o+kYuC4bmY7OQJDv32Kpp21p2j/wiNPcVB8vjzOMl+s=";
        }
        {
          name = "shader";
          publisher = "slevesque";
          version = "1.1.5";
          sha256 = "sha256-Pf37FeQMNlv74f7LMz9+CKscF6UjTZ7ZpcaZFKtX2ZM=";
        }
        {
          name = "blockman";
          publisher = "leodevbro";
          version = "1.2.0";
          sha256 = "1gpq717r002h3w4238rc57y0fvnwrhrc2a7rpdayw79ar7ahqaiv";
        }
        {
          name = "nix-ide";
          publisher = "jnoortheen";
          version = "0.1.3";
          sha256 = "1c2yljzjka17hr213hiqad58spk93c6q6xcxvbnahhrdfvggy8al";
        }
        {
          name = "vetur";
          publisher = "octref";
          version = "0.33.1";
          sha256 = "1iq2h87j7dr4vf9zgzihd5q4d95grc0iirz68az5dnvy19nvfv57";
        }
        {
          name = "even-better-toml";
          publisher = "tamasfe";
          version = "0.19.2";
          sha256 = "sha256-JKj6noi2dTe02PxX/kS117ZhW8u7Bhj4QowZQiJKP2E=";
        }
        {
          name = "horizon-theme-vscode";
          publisher = "jolaleye";
          version = "2.0.2";
          sha256 = "1ch8m9h6zxn8xj92ml5294637ygabnyird3f6vbh1djzwwz5rykc";
        }
        {
          name = "prettier-vscode";
          publisher = "esbenp";
          version = "5.8.0";
          sha256 = "0h7wc4pffyq1i8vpj4a5az02g2x04y7y1chilmcfmzg2w42xpby7";
        }
        {
          name = "gitlens";
          publisher = "eamodio";
          version = "11.0.6";
          sha256 = "0qlaq7hn3m73rx9bmbzz3rc7khg0kw948z2j4rd8gdmmryy217yw";
        }
        {
          name = "vs-code-prettier-eslint";
          publisher = "rvest";
          version = "0.4.1";
          sha256 = "0inqkn574zjzg52qcnmpfhsbzbi6vxnr2lrqqff9mh5vvvqsm6v0";
        }
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
  programs.home-manager.enable = true;

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
    # bug workaround
    config.allowUnfreePredicate = (pkg: true);
    overlays = [
      mozilla
      (self: super: {
        firefox-nightly-bin = super.latest.firefox-nightly-bin;
      })
    ];
  };
}
