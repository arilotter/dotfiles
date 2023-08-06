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
  home.stateVersion = "23.05"; # Please read the comment before changing.

  colorScheme = nix-colors.colorSchemes.paraiso;

  home.packages = with pkgs; [
    # shell config
    starship # prompt
    exa # ls replacement

    # desktop env
    hyprpaper # wallpaper manager
    gnome3.nautilus # file manager
    pamixer # audio control shell for gbar
    e.packages.x86_64-linux.grimblast # screenshot tool
    upower # battery
    firefox # web browser
    google-chrome # web browser
    wezterm # terminal emulator
    pavucontrol # audio control
    blueman # bluetooth manager
    neofetch # i mean, c'mon :)
    vlc # video player
    spotify # music player
    discord


    # TUI tools
    bottom # system manager, like htop
    lazydocker # docker manager
    lazygit # git manager

    # command-line utils
    file # file type identification
    graphviz # graph visualization
    toilet # text to ascii art
    jq # json processing tool
    ripgrep # grep replacement
    tokei # code statistics

    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        vscode-extensions.vadimcn.vscode-lldb
        ms-vsliveshare.vsliveshare
        golang.go
        matklad.rust-analyzer
        ms-azuretools.vscode-docker
        dbaeumer.vscode-eslint
        svelte.svelte-vscode
        usernamehw.errorlens
        github.copilot
        (import ./skyweaver-vscode)
      ]
      ++ vscode-utils.extensionsFromVscodeMarketplace [
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
        # {
        #   name = "rust-analyzer";
        #   publisher = "matklad";
        #   version = "0.2.465";
        #   sha256 = "1qv52c2ans594zxxl9cv343hdkc292k851p99khdcjr1qcfgcib9";
        # }
        # {
        #   name = "vscode-docker";
        #   publisher = "ms-azuretools";
        #   version = "1.6.0";
        #   sha256 = "1snjj09qn0c6ipd3i3xyzah4gnh17j5h9vn01db294xpbl2q80n0";
        # }
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
  programs.rofi = import ./rofi.nix pkgs;
  services =
    {
      dunst = import ./dunst.nix pkgs;
      network-manager-applet.enable = true;
    };
  programs.fish = {
    enable = true;
    shellAliases = {
      pbpaste = "xclip -selection clipboard -o";
      pbcopy = "xclip -selection clipboard -i";
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
      p = "pnpm";
    };
    shellInit = ''
      starship init fish | source
      source ~/dotfiles/secrets
      
      set -gx VISUAL code
      # set -gx QT_AUTO_SCREEN_SCALE_FACTOR 1

      set -gx ANDROID_HOME $HOME/Android/Sdk
      set -gx PATH $PATH ~/.yarn/bin ~/.npm/bin ~/bin ~/go/bin ~/.cargo/bin $ANDROID_HOME/emulator $ANDROID_HOME/tools $ANDROID_HOME/tools/bin $ANDROID_HOME/platform-tools

      # gpg-connect-agent /bye
      # set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
      
      export RUST_SRC_PATH=/nix/store/rffmq1pqkl48aajqf2xraf28bbm4302k-rust-src/lib/rustlib/src/rust/library
      
      function checkout-last-version
        set card $argv[1]
        git checkout (git rev-list -n 1 HEAD -- "$card")^ -- "$card"
      end

      set -gx SW_API_HOST "https://local-skyweaver-api.0xhorizon.net"
      set -gx SW_AUTH_TOKEN "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NvdW50IjoiMHgyMDM3MTI0NzMwZjRkMmQ1MTI0OGQyYzA1ZDJhZTVjYmQyODhlZDY3IiwiYXBwIjoiU2t5d2VhdmVyIiwiZXhwIjoxNjU1ODM2Nzg4LCJpYXQiOjE2MjQzMDA3ODgsIm9nbiI6Imh0dHBzOi8vbG9jYWwuMHhob3Jpem9uLm5ldCJ9.rFCF1PhcAEJbUdMB4LFd4L6ElqA8rtxMi46gK8fQBB"

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
    extraConfig.url."git@github.com:".insteadOf = "https://github.com/";
    lfs.enable = true;
    delta.enable = true;
  };
  # bug workaround
  nixpkgs = {
    config.allowUnfreePredicate = (pkg: true);
    # permittedInsecurePackages = [ "openssl-1.0.2u" ];
    overlays = [
      mozilla
      (self: super: {
        firefox-nightly-bin = super.latest.firefox-nightly-bin;
        rust-nightly-pinned = (super.rustChannelOf {
          channel = "nightly";
          date = "2023-06-23";
        }).rust.override {
          targets = [ "wasm32-unknown-unknown" "x86_64-pc-windows-msvc" "x86_64-apple-darwin" "x86_64-unknown-linux-gnu" ];

          extensions =
            [ "rustfmt-preview" "rust-src" ];
        };
      })
    ];
  };
}
