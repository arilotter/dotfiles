put your hashed password into /etc/nixos/hashedPassword.nix
you can get this with mkpasswd

run `setup.sh` to make the symlinks you need, then run `home-manager switch`.

system level config in `configuration.nix`, user-level config in `nixpkgs/home.nix`