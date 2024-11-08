#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
nix run .#genflake flake.nix && sudo nixos-rebuild switch --flake $SCRIPT_DIR