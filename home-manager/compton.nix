{ pkgs, ...}:
let
t = import ./theme.nix pkgs;
in
{
  extraOptions = ''
    shadow = true;
    no-dnd-shadow = true;
    no-dock-shadow = true;
    clear-shadow = true;
    shadow-radius = 0;
    shadow-offset-x = 4;
    shadow-offset-y = 4;
    shadow-opacity = 1.00;
    shadow-red = 0.00;
    shadow-green = 0.00;
    shadow-blue = 0.00;
    backend = "glx";
  '';
  enable = false;
}