{ config, ... }:
let
  c = config.colorScheme.palette;
in
{
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "FiraCode Nerd Font Reg";
      touch_scroll_multiplier = "10.0";

      window_margin_width = 8;

      foreground = "#${c.base05}";
      background = "#${c.base00}";

      selection_background = "#${c.base05}";
      selection_foreground = "#${c.base00}";
      url_color = "#${c.base04}";
      cursor = "#${c.base05}";
      cursor_text_color = "#${c.base00}";
      active_border_color = "#${c.base03}";
      inactive_border_color = "#${c.base01}";
      active_tab_background = "#${c.base00}";
      active_tab_foreground = "#${c.base05}";
      inactive_tab_background = "#${c.base01}";
      inactive_tab_foreground = "#${c.base04}";
      tab_bar_background = "#${c.base01}";
      wayland_titlebar_color = "#${c.base00}";
      macos_titlebar_color = "#${c.base00}";

      color0 = "#${c.base00}";
      color1 = "#${c.base08}";
      color2 = "#${c.base0B}";
      color3 = "#${c.base0A}";
      color4 = "#${c.base0D}";
      color5 = "#${c.base0E}";
      color6 = "#${c.base0C}";
      color7 = "#${c.base05}";

      color8 = "#${c.base03}";
      color9 = "#${c.base09}";
      color10 = "#${c.base01}";
      color11 = "#${c.base02}";
      color12 = "#${c.base04}";
      color13 = "#${c.base06}";
      color14 = "#${c.base0F}";
      color15 = "#${c.base07}";
    };
  };
}
