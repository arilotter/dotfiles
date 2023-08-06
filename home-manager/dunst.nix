{ pkgs, ...}:
let
t = import ./theme.nix pkgs;
in
{
  enable = true;
  settings = {
    global = {
      geometry = "400x10-10-40";
      transparency = 10;
      separator_height = 0;
      padding = 12;
      horizontal_padding = 12;
      font = "Fira Code 10";
      format = "<b>%s</b>\n%b";

      icon_position = "left";
      max_icon_size = 48;

      dmenu = "rofi -dmenu -p Dunst";
      browser = "/run/current-system/sw/bin/google-chrome-stable";
    };
    shortcuts = {
      close = "ctrl+space";
      history = "ctrl+shift+space";
      context = "ctrl+slash";
    };
    urgency_low = {
      background = "#eaeaea";
      foreground = "#202020";
      timeout = 3;
      icon = "";
    };
    urgency_normal = {
      background = "#eaeaea";
      foreground = "#202020";
      timeout = 3;
      icon = "";
    };
    urgency_critical = {
      background = "#ff5555";
      foreground = "#202020";
      timeout = 0;
      icon = "";
    };
  };
}