{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./home.nix
    ./hyprland.nix
    ./ghostty.nix
    ./mako.nix
    ./firefox.nix
    ./rofi.nix
    ./waybar.nix
    ./supersonic.nix
    ./vscode.nix
    ./neovim.nix
  ];

  home.packages = with pkgs; [
    # desktop env
    hyprpaper # wallpaper manager
    nautilus # file manager
    inputs.hypr-contrib.packages.${pkgs.system}.grimblast # screenshot tool
    pavucontrol # audio control
    blueman # bluetooth manager
    wl-clipboard # copy/paste cli
    monado # xr? :D

    vesktop # discord

    # 3d pwint
    prusa-slicer

    easyeffects # mic settings

    vlc # video player
    google-chrome # web browser
    slack # ew
    stremio # streaming video

    # clang format needs..
    clang-tools

    # wine
    wineWowPackages.waylandFull

    ledger-live-desktop
  ];

  programs.fish.shellAliases = {
    pbpaste = "wl-paste";
    pbcopy = "wl-copy";
  };
}
