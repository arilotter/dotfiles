{pkgs, lib, config, ...}:
with lib;
let
  liveshareGist = builtins.fetchTarball {
    url = "https://gist.github.com/ottidmes/9360fc1f0fbd8443506b45c2149388a9/archive/cb10805e5857d503ae8ed38b3f2de40c164ec519.tar.gz";
    sha256 = "0vm3m4axmhy7pm1li7gcwr37zydp8z5va8vn47rxpa0pnssj3nsp";
  };
  livesharePkg = pkgs.callPackage liveshareGist {};
  cfg = config.services.vsliveshare;
  pkg = livesharePkg.override { enableDiagnosticsWorkaround = cfg.enableDiagnosticsWorkaround; };

  writableWorkaroundScript = pkgs.writeScript "vsliveshare-writable-workaround.sh" ''
    #!${pkgs.bash}/bin/bash
    out=${pkg}
    src=$out/share/vscode/extensions/ms-vsliveshare.vsliveshare
    # We do not want to pass any invalid path to `rm`.
    if [[ ! -d "${cfg.extensionsDir}" ]]; then
      echo "The VS Code extensions directory '${cfg.extensionsDir}' does not exist" >&2
      exit 1
    fi
    dst="${cfg.extensionsDir}"/ms-vsliveshare.vsliveshare-$(basename $out | sed 's/.*vsliveshare-//')
    # Only run the script when the build has actually changed.
    if [[ $(dirname "$(dirname "$(readlink "''${dst}/dotnet_modules/vsls-agent-wrapped")")") == $src ]]; then
      exit 0
    fi
    # Remove all previous versions of VS Code Live Share.
    rm -r "${cfg.extensionsDir}"/ms-vsliveshare.vsliveshare*
    # Create the extension directory.
    mkdir -p "$dst"
    # Symlink files which should remain unchanged.
    find $src -type f \( -name \*.a -o -name \*.dll -o -name \*.pdb \) | while read -r src_file; do
      dst_file="''${dst}''${src_file#''${src}}"
      mkdir -p $(dirname "$dst_file")
      ln -s "$src_file" "$dst_file"
    done
    # Symlink ELF executables and copy over executable files.
    find $src -type f -executable | while read -r src_file; do
      dst_file="''${dst}''${src_file#''${src}}"
      mkdir -p $(dirname "$dst_file")
      if file "$src_file" | grep -wq ELF; then
        ln -s "$src_file" "$dst_file"
      else
        cp --no-preserve=mode,ownership,timestamps "$src_file" "$dst_file"
        chmod +x "$dst_file"
      fi
    done
    # Copy over the remaining files and directories.
    # FIXME: Use a different command that does not warn about files being the same.
    cp -r --no-clobber --no-preserve=mode,ownership,timestamps "$src/." "$dst" 2> >(grep -Ev "^cp: '.*' and '.*' are the same file$")
    exit 0
  '';

in {
  options.services.vsliveshare = with types; {
    enable = mkEnableOption "VS Code Live Share extension";
    enableWritableWorkaround = mkEnableOption "copying the build to the VS Code extension directory to ensure write access";
    enableDiagnosticsWorkaround = mkEnableOption "an UNIX socket that filters out the diagnostic logging done by VSLS Agent";

    extensionsDir = mkOption {
      type = str;
      default = "$HOME/.vscode/extensions";
      description = ''
        The VS Code extensions directory.
        CAUTION: The workaround will remove ms-vsliveshare.vsliveshare* inside this directory!
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ bash desktop-file-utils xlibs.xprop ]
      ++ optional (!cfg.enableWritableWorkaround) pkg;

    services.gnome-keyring.enable = true;

    systemd.user.services.vsliveshare-writable-workaround = /*mkIf cfg.enableWritableWorkaround*/ {

      Unit = {
        Description = "VS Code Live Share extension writable workaround";
        PartOf = [ "graphical-session-pre.target" ];
      };

      Service = {
        Environment = makeBinPath (with pkgs; [ file ]);
        ExecStart = writableWorkaroundScript;
      };

      Install = {
        WantedBy = [ "graphical-session-pre.target" ];
      };
    };
  };
}