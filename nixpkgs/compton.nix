{ pkgs, ...}:
let
t = import ./theme.nix pkgs;
in
{
  enable = false;
  activeOpacity = "1.0";
  inactiveOpacity = "0.9";
}