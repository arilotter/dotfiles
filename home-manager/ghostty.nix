{
  inputs,
  config,
  pkgs,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      gtk-titlebar = false;
      window-padding-x = 8;
      window-padding-y = 8;
    };
  };
}
