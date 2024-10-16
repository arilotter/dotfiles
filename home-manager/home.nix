{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  home = {
    username = "ari";
    homeDirectory = "/home/ari";
    stateVersion = "23.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  };

  home.packages = with pkgs; [
    (pkgs.callPackage ./runpod {})
    # shell config
    starship # prompt
    eza # ls replacement

    binaryen # wasm bullshit for skyweaver

    # "desktop" env
    upower # battery
    neofetch # i mean, c'mon :)

    # TUI tools
    bottom # system manager, like htop
    nvtopPackages.full
    lazydocker # docker manager
    lazygit # git manager

    # command-line utils
    screen
    thefuck
    killall
    file # file type identification
    graphviz # graph visualization
    jq # json processing tool
    ripgrep # grep replacement
    tokei # code LoC
    imagemagickBig
    ranger

    # programming tools
    devenv
    jdk11 # java
    trickle # limit bandwidth artificially
    wabt # webassembly binary tools
    google-cloud-sdk # google cloud sdk
    awscli # aws cli
    ansible # ansible devops bullshit
    nixd # nix lang server

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
    ".cargo/config.toml".text = ''
      [net]
      git-fetch-with-cli = true   # use the `git` executable for git operations
    '';
  };

  home.sessionVariables = {};

  programs.direnv.enable = true;

  programs.fish = {
    enable = true;
    shellAliases = {
      gcp = "git cherry-pick";
      netcopy = ''nc -q 0 tcp.st 7777 | grep URL | cut -d " " -f 2 | pbcopy'';
      reload-fish = "exec fish";
      gs = "git status";
      gp = "git pull";
      gc = "git commit -m";
      gca = "git commit --amend";
      gl = "git log";
      gf = "git fetch -p";
      ls = "eza";
      lg = "lazygit";
      ld = "lazydocker";
      gcm = "git checkout master";
      gco = "git checkout";
      p = "pnpm";
      # open a link on the connected android phone
      phone = "adb shell am start --user 0 -a android.intent.action.VIEW -d";
    };

    shellInit = ''
      starship init fish | source

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
    extraConfig.pull.rebase = true;
    extraConfig.rebase.autoStash = true;
    extraConfig.diff.tool = "default-difftool";
    extraConfig.push.default = "simple";
    extraConfig.push.autoSetupRemote = true;
    extraConfig.url."git@github.com:".insteadOf = "https://github.com/";
    lfs.enable = true;
    delta.enable = true;
  };
}
