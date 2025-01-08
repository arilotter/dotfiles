{
  inputs,
  config,
  pkgs,
  ...
}:
let
  c = config.colorScheme.palette;
in
{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      font-family = "FiraCode Nerd Font Reg";
      gtk-titlebar = false;
      window-padding-x = 8;
      window-padding-y = 8;
      theme = "sys";
    };
    themes.sys = {
      palette = [
      "0=#${c.base00}"
      "1=#${c.base08}"
      "2=#${c.base0B}"
      "3=#${c.base0A}"
      "4=#${c.base0D}"
      "5=#${c.base0E}"
      "6=#${c.base0C}"
      "7=#${c.base05}"
      "8=#${c.base03}"
      "9=#${c.base09}"
      "10=#${c.base01}"
      "11=#${c.base02}"
      "12=#${c.base04}"
      "13=#${c.base06}"
      "14=#${c.base0F}"
      "15=#${c.base07}"
      ];
            foreground = "#${c.base05}";
      background = "#${c.base00}";

      selection-background = "#${c.base05}";
      selection-foreground = "#${c.base00}";
      cursor-color = "#${c.base05}";
      cursor-text = "#${c.base00}";
    };
  };
}
