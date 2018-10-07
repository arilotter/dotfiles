#!/usr/bin/env bash
if [[ ! -d $(realpath ~/.config/nixpkgs) ]]; then ln -s $(realpath ./nixpkgs) $(realpath ~/.config/nixpkgs); fi
if [[ ! -d $(realpath ~/.config/wal) ]]; then ln -s $(realpath ./wal) $(realpath ~/.config/wal); fi
if [[ ! -d $(realpath ~/.config/i3) ]]; then mkdir ~/.config/i3; fi
if [[ ! -d $(realpath ~/.config/i3/blocks) ]]; then ln -s  $(realpath ./i3/blocks) $(realpath ~/.config/i3/blocks); fi
if [[ ! -f $(realpath ~/.config/i3/bar.toml) ]]; then ln -s  $(realpath ./i3/bar.toml) $(realpath ~/.config/i3/bar.toml); fi
if [[ ! -f $(realpath ~/bin/change-theme) ]]; then ln -s  $(realpath ./bin/change-theme) $(realpath ~/bin/change-theme); fi