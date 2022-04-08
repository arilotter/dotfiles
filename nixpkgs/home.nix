{ pkgs, ... }:
let
  theme = import ./theme.nix;
  # i3blocks-git = import ./i3blocks;
  # oomox = import ./oomox;
  mozilla = import (builtins.fetchGit {
    url = "https://github.com/mozilla/nixpkgs-mozilla.git";
    ref = "master";
  });
in
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [ "openssl-1.0.2u" ];
  nixpkgs.overlays = [
    mozilla
    (self: super: {
      latest = {
        firefox-nightly-bin = super.latest.firefox-nightly-bin;
        rustChannels.nightly.rust = (super.rustChannelOf {
          channel = "nightly";
          date = "2021-12-05";
        }).rust.override {
          targets = [ "wasm32-unknown-unknown" ];

          extensions =
            [ "rustfmt-preview" "clippy-preview" "rust-src" ];
        };
      };
    })
    (self: super: {
      pywal = super.pywal.overrideAttrs (oldAttrs: {
        patches = oldAttrs.patches
          ++ [ ./pywal_colored_light_theme_backgrounds.patch ];
      });
    })
    (self: super: {
      prusa-slicer = super.prusa-slicer.overrideAttrs
        (oldAttrs: {
          version = "2.3.0";
        });
    })
    (self: super: {
      yubikey-touch-detector = self.callPackage ./yubikey-touch-detector { };
      replay-browser = self.callPackage ./replay { };
    })
  ];

  home.packages = with pkgs; [
    # system utils
    bottom
    xclip
    psmisc
    acpi
    sysstat
    lm_sensors
    file
    smartmontools
    graphviz
    toilet
    trickle
    xorg.xev

    pciutils
    imagemagickBig
    poppler_utils
    wabt
    cowsay
    starship
    jq
    google-cloud-sdk
    # yubikey-manager
    grc

    # languages & build tools
    go
    gnumake
    lua
    tokei
    python
    python3Full
    cmake
    yarn
    redis
    nodejs_latest
    ms-sys
    (import ./git-quick-stats)
    awscli
    ansible
    blender
    libuuid
    swiProlog
    glslang
    latest.rustChannels.nightly.rust
    gitAndTools.git-extras
    google-chrome
    lldb
    gdb
    valgrind
    geckodriver
    iodine
    linuxPackages.perf
    ripgrep
    pkg-config
    openssl
    # binutils
    cargo-flamegraph
    docker-compose
    wasm-pack
    insomnia
    binaryen
    gitAndTools.gh
    lazydocker
    lazygit
    nixpkgs-fmt
    gnupg
    # prusa-slicer
    pngquant
    # (import ./drone-cli)

    # desktop env
    pywal
    flite
    i3status-rust
    i3lock
    dconf
    maim
    pavucontrol
    feh
    libnotify
    inotify-tools
    s-tui
    clang
    lld
    inkscape
    # (import ./xwobf)
    (import ./srandrd)
    yubikey-touch-detector

    blueman
    exa
    lsof
    wine
    barrier
    pfetch

    # tor-browser-bundle-bin
    # apps
    appimage-run
    # firefox
    steam
    minecraft
    android-studio
    jdk11
    latest.firefox-nightly-bin
    replay-browser
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
          name = "better-toml";
          publisher = "bungcip";
          version = "0.3.2";
          sha256 = "08lhzhrn6p0xwi0hcyp6lj9bvpfj87vr99klzsiy8ji7621dzql3";
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
    alacritty
    gnome3.eog
    neofetch
    woeusb
    simplescreenrecorder
    arduino
    xoscope
    vlc
    spotify
    transmission-gtk
    meshlab
    bitwarden

    # chat
    weechat
    discord


    #remote desktop shit
    xpra
  ];

  programs.home-manager = {
    enable = true;
    path = "https://github.com/rycee/home-manager/archive/master.tar.gz";
  };

  xsession = {
    enable = true;
    windowManager.i3 = import ./i3.nix pkgs;
  };
  programs.autorandr = import ./autorandr.nix pkgs;
  programs.rofi = import ./rofi.nix pkgs;
  services = {
    dunst = import ./dunst.nix pkgs;

    picom = import ./compton.nix pkgs;
    network-manager-applet = { enable = true; };
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      extraConfig = ''
        pinentry-program ${pkgs.pinentry-qt}/bin/pinentry
      '';
    };
  };
  programs.gpg.enable = true;


  xdg.configFile."alacritty/alacritty.yml".text = import ./alacritty.nix theme;
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
      gl = "git log";
      gf = "git fetch -p";
      ls = "exa";
      lg = "lazygit";
      ld = "lazydocker";
      gcm = "git checkout master";
    };
    shellInit = ''
      starship init fish | source
      source ~/dotfiles/secrets
      
      set -gx VISUAL code
      # set -gx QT_AUTO_SCREEN_SCALE_FACTOR 1

      set -gx ANDROID_HOME $HOME/Android/Sdk
      set -gx PATH $PATH ~/.yarn/bin ~/.npm/bin ~/bin ~/go/bin ~/.cargo/bin $ANDROID_HOME/emulator $ANDROID_HOME/tools $ANDROID_HOME/tools/bin $ANDROID_HOME/platform-tools

      gpg-connect-agent /bye
      set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
      
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
}
