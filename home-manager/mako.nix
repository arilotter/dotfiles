{ config, ... }:
{
  services.mako = {
    enable = true;
    settings = {
      icons = true;
      sort = "-time";
      layer = "overlay";
      anchor = "bottom-right";
      width = 400;
      height = 230;
      padding = "16";
      margin = "10,10,10";
      output = "HDMI-A-1";
      borderSize = 2;
      borderRadius = 6;
      defaultTimeout = 5000;
    };
    extraConfig = ''
      format=<b>%s</b>\n\n%b
    '';
  };
}
