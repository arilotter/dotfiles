{
  pkgs,
  inputs,
  ...
}: {
  colorScheme = inputs.nix-colors.colorSchemes."solarized-light";

  imports = [
    ./home.nix
    ./hyprland.nix
    ./kitty.nix
    ./mako.nix
    ./firefox.nix
    ./rofi.nix
    ./waybar.nix
    ./discord.nix
    ./supersonic.nix
    ./vscode.nix
    ./neovim.nix
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

    #clang format needs..
    clang-tools
  ];

  home.file = {
    ".config/hypr/hyprpaper.conf".text = ''
      preload = /home/ari/dotfiles/wallpapers/future_funk_4k.jpg
      wallpaper = ,/home/ari/dotfiles/wallpapers/future_funk_4k.jpg
    '';
  };

  programs.fish = {
    shellAliases = {
      pbpaste = "wl-paste";
      pbcopy = "wl-copy";
    };
  };
}
