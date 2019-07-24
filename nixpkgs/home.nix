{ pkgs, ... }:

let
  theme = import ./theme.nix;
  # i3blocks-git = import ./i3blocks;
  # oomox = import ./oomox;
  mozilla = import (builtins.fetchGit {
    url = "https://github.com/mozilla/nixpkgs-mozilla.git";
    rev = "200cf0640fd8fdff0e1a342db98c9e31e6f13cd7";
  });
in
{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    mozilla
    (self: super: {
      latest = {
        firefox-nightly-bin = super.latest.firefox-nightly-bin;
        rustChannels.nightly.rust = (super.rustChannelOf { date = "2019-07-19"; channel = "nightly"; }).rust.override {
          targets = [
            "wasm32-unknown-unknown"
          ];

          extensions = [
            "rustfmt-preview"
            "clippy-preview"
            "rust-src"
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
    openssl
    rename
    usbutils
    ffmpeg
    pciutils
    wine
    imagemagickBig
    poppler_utils
    wabt
    cowsay
    gnupg

    yubikey-manager

    # languages & build tools
    go
    gnumake
    lua
    tokei
    python
    python3Full
    cmake
    yarn
    nodejs-12_x
    ms-sys
    (import ./git-quick-stats)
    awscli
    ansible
    swiProlog
    glslang
    cargo-edit
    latest.rustChannels.nightly.rust
    libimobiledevice
    gitAndTools.git-extras
    google-chrome
    wasm-gc
    lldb
    gdb
    valgrind

    iodine
    # (import ./wasmtime {})


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
    gimp
    atom
    arduino
    xoscope
    vlc
    
    # chat
    weechat
    discord
  ];
  
  programs.home-manager = {
    enable = true;
    path = "https://github.com/rycee/home-manager/archive/release-19.03.tar.gz";
  };

  xsession = {
    enable = true;
    windowManager.i3 = import ./i3.nix pkgs;
  };
  programs.autorandr = import ./autorandr.nix pkgs;

  programs.rofi = import ./rofi.nix pkgs;
  services.dunst = import ./dunst.nix pkgs;
  services.compton = import ./compton.nix pkgs;
  programs.fish = {
    enable = true;
    shellAliases = {
      pbpaste = "xclip -selection clipboard -o";
      pbcopy = "xclip -selection clipboard -i";
      netcopy = "nc -q 0 tcp.st 7777 | grep URL | cut -d \" \" -f 2 | pbcopy";
      reload-fish = "exec fish";
      fix-bluetooth-audio = "pacmd set-card-profile (pacmd list-sinks | sed -n \"s/card: \\([0-9]*\\) <bluez.*/\\1/p\" | xargs) a2dp_sink";
    };
    shellInit = ''
      fish-nix-shell --info-right | source
      fundle plugin 'MaxMilton/pure'
      fundle plugin 'jethrokuan/z'
      set -gx VISUAL \"nano\"
      set -gx QT_AUTO_SCREEN_SCALE_FACTOR 1

      set -gx PATH ~/.yarn/bin ~/.npm/bin ~/bin ~/go/bin ~/.cargo/bin $PATH

      fundle init

      alias ls "exa"
      gpg-connect-agent /bye
      set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
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
    lfs.enable = true;
  };

}
