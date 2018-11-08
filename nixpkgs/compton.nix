{ pkgs, ...}:
let
t = import ./theme.nix pkgs;
in
{
  enable = true;
  activeOpacity = "1.0";
  inactiveOpacity = "0.9";
}