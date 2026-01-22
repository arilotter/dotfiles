{
  signal-desktop,
  writeShellScriptBin,
  procps,
  symlinkJoin,
  makeWrapper,
}:

# Signal desktop is slow as fuck to sync messages because it does like disk read/writes for every single message
# so we can speed that up to instant by just sticking it in a ramdisk

let
  wrapperScript = writeShellScriptBin "signal-desktop-ramdisk" ''
    set -e

    SIGNAL_PATH="''${XDG_CONFIG_HOME:-$HOME/.config}/Signal"
    SIGNAL_BACKUP="''${XDG_CONFIG_HOME:-$HOME/.config}/Signal-backup"
    RAMDISK_DIR="''${TMPDIR:-/tmp}/signal-ramdisk-$$"

    cleanup() {
      local exit_code=$?
      echo "cleaning up signal ramdisk dir.."
      
      # kill signal if it's still running
      ${procps}/bin/pkill -x signal-desktop 2>/dev/null || true
      
      # if symlink exists, restore data
      if [[ -L "$SIGNAL_PATH" ]]; then
        rm -f "$SIGNAL_PATH"
        
        if [[ -d "$RAMDISK_DIR/Signal" ]]; then
          echo "restoring data from ramdisk..."
          mv "$RAMDISK_DIR/Signal" "$SIGNAL_PATH"
        fi
      fi
      
      if [[ -d "$RAMDISK_DIR" ]]; then
        rm -rf "$RAMDISK_DIR"
      fi
      
      exit $exit_code
    }

    trap cleanup EXIT INT TERM

    # kill any running signal-desktop
    ${procps}/bin/pkill -x signal-desktop 2>/dev/null || echo "signal not running :)"
    sleep 1

    # restore from backup if signal folder doesn't exist
    if [[ ! -d "$SIGNAL_PATH" ]] && [[ -d "$SIGNAL_BACKUP" ]]; then
      echo "restoring signal data from backup..."
      cp -r "$SIGNAL_BACKUP" "$SIGNAL_PATH"
    fi

    # if real signal folder exists (not ramdisk symlink), back it up
    if [[ -d "$SIGNAL_PATH" ]] && [[ ! -L "$SIGNAL_PATH" ]]; then
      echo "backing up signal data..."
      if [[ -d "$SIGNAL_BACKUP" ]]; then
        rm -rf "''${SIGNAL_BACKUP}.old"
        mv "$SIGNAL_BACKUP" "''${SIGNAL_BACKUP}.old"
      fi
      cp -r "$SIGNAL_PATH" "$SIGNAL_BACKUP"
    fi

    # setup ramdisk
    if [[ ! -L "$SIGNAL_PATH" ]]; then
      echo "setting up ramdisk..."
      mkdir -p "$RAMDISK_DIR"
      
      # move signal data to ramdisk
      if [[ -d "$SIGNAL_PATH" ]]; then
        mv "$SIGNAL_PATH" "$RAMDISK_DIR/"
      else
        mkdir -p "$RAMDISK_DIR/Signal"
      fi
      
      # replace signal data dir w ramdisk symlink
      ln -sf "$RAMDISK_DIR/Signal" "$SIGNAL_PATH"
      echo "signal data is now on ramdisk at $RAMDISK_DIR"
    fi

    # launch actual signal
    echo "launching signal.."
    exec ${signal-desktop}/bin/signal-desktop "$@"
  '';

in
symlinkJoin {
  name = "signal-desktop-ramdisk";
  paths = [ wrapperScript ];

  buildInputs = [ makeWrapper ];

  postBuild = ''
    mkdir -p $out/share/applications

    # rip desktop file from original signal
    substitute ${signal-desktop}/share/applications/signal.desktop \
      $out/share/applications/signal-ramdisk.desktop \
      --replace "Exec=signal-desktop" "Exec=$out/bin/signal-desktop-ramdisk" \
      --replace "Name=Signal" "Name=Signal (Ramdisk)"

    # copy icon and other shit
    for dir in ${signal-desktop}/share/*; do
      if [[ -d "$dir" ]] && [[ "$(basename "$dir")" != "applications" ]]; then
        ln -sf "$dir" $out/share/
      fi
    done
  '';

  meta = signal-desktop.meta // {
    description = "${signal-desktop.meta.description} (with ramdisk wrapper for performance)";
  };
}
