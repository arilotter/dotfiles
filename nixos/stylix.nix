{ pkgs, ... }:
{
  stylix = {
    enable = true;
    image = ../wallpapers/future_funk_4k.jpg;
    polarity = "light";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine-dawn.yaml";
    fonts = {
      monospace = {
        name = "FiraCode Nerd Font Reg";
        package = pkgs.nerd-fonts.fira-code;
      };
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-emoji;
      };
      sizes = {
        desktop = 12;
        popups = 12;
        applications = 12;
        terminal = 12;
      };
    };
  };
}
