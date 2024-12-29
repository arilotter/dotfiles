let
  keys = import ../ssh-pubkeys.nix;
in
{
  "sol-smbpasswd.age".publicKeys = [
    keys.luna
    keys.sol
    keys.hermes
  ];
  "ari-passwd.age".publicKeys = [
    keys.luna
    keys.sol
    keys.hermes
  ];
}
