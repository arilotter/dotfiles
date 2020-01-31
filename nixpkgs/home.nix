{ pkgs, ... }:

let
  theme = import ./theme.nix;
  # i3blocks-git = import ./i3blocks;
  # oomox = import ./oomox;
  mozilla = import (builtins.fetchGit {
    url = "https://github.com/arilotter/nixpkgs-mozilla.git";
    ref = "please_work_4";
  });
in
{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    mozilla
    (self: super: {
      latest = {
        firefox-nightly-bin = super.lib.firefoxOverlay.firefoxVersion {
          version = "73.0a1";
          timestamp = "2019-12-04-09-56-40"; 

          release = false;
        };
        rustChannels.nightly.rust = (super.rustChannelOf { date = "2019-11-24"; channel = "nightly"; }).rust.override {
          targets = [
            "wasm32-unknown-unknown"
          ];

          extensions = [
            "rustfmt-preview"
            "clippy-preview"
            "rust-src"
            "rustc-dev"
          ];
        };
      };
    })
    (self: super: {
      pywal = super.pywal.overrideAttrs(oldAttrs: {
        patches = oldAttrs.patches ++ [ ./pywal_colored_light_theme_backgrounds.patch ];
      });
    })
  ];
  
  home.packages = with pkgs; [
    # system utils
    gotop
    xclip
    psmisc
    acpi
    sysstat
    lm_sensors
    file
    smartmontools
    graphviz
    toilet
    xorg.xev

    pciutils
    imagemagickBig
    poppler_utils
    wabt
    cowsay
    gnupg
    ripgrep
    starship
    jq
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
    (yarn.override {
      nodejs = nodejs_latest;
    })
    redis
    nodejs-12_x
    ms-sys
    (import ./git-quick-stats)
    awscli
    ansible
    swiProlog
    glslang
    latest.rustChannels.nightly.rust
    libimobiledevice
    gitAndTools.git-extras
    google-chrome
    wasm-gc
    lldb
    gdb
    valgrind
    geckodriver
    iodine
    linuxPackages.perf
    ripgrep
    pkg-config
    openssl
    clang
    binutils
    gnuradio
    gr-limesdr
    cargo-flamegraph
    docker-compose
    # (import ./drone-cli)


    # desktop env
    pywal
    i3status-rust
    i3lock
    gnome3.dconf
    maim
    pavucontrol
    feh
    libnotify
    inotify-tools
    s-tui
    (import ./xwobf)
    (import ./srandrd)
    
    blueman
    exa
    lsof
    wine

    # apps
    appimage-run
    latest.firefox-nightly-bin
    vscode
    alacritty
    pcmanfm
    gnome3.eog
    gnome3.gucharmap
    neofetch
    woeusb
    simplescreenrecorder
    kicad
    atom
    arduino
    xoscope
    vlc
    spotify
    transmission-gtk
    prusa-slicer
    meshlab
    dolphinEmu
    
    # chat
    weechat
    discord
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

    compton = import ./compton.nix pkgs;
    network-manager-applet = {
      enable = true;
    };
  };

  xdg.configFile."alacritty/alacritty.yml".text = import ./alacritty.nix theme;
  programs.fish = {
    enable = true;
    shellAliases = {
      pbpaste = "xclip -selection clipboard -o";
      pbcopy = "xclip -selection clipboard -i";
      netcopy = "nc -q 0 tcp.st 7777 | grep URL | cut -d \" \" -f 2 | pbcopy";
      reload-fish = "exec fish";
      fix-bluetooth-audio = "pacmd set-card-profile (pacmd list-sinks | sed -n \"s/card: \\([0-9]*\\) <bluez.*/\\1/p\" | xargs) a2dp_sink";
      gs = "git status";
      gp = "git pull";
      gc = "git commit -m";
      gl = "git log";
      gf = "git fetch -p";
      ls = "exa";
    };
    shellInit = ''
      starship init fish | source
      set -gx VISUAL code
      # set -gx QT_AUTO_SCREEN_SCALE_FACTOR 1

      set -gx PATH $PATH ~/.yarn/bin ~/.npm/bin ~/bin ~/go/bin ~/.cargo/bin

      gpg-connect-agent /bye
      set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
      sh ~/dotfiles/secrets

      function checkout-last-version
        set card $argv[1]
        git checkout (git rev-list -n 1 HEAD -- "$card")^ -- "$card"
      end
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
  };
}
