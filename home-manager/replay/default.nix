{ lib
, stdenv
, fetchurl
, config
, wrapGAppsHook
, alsa-lib
, atk
, cairo
, curl
, cups
, dbus-glib
, dbus
, fontconfig
, freetype
, gdk-pixbuf
, glib
, glibc
, gtk2
, gtk3
, libkrb5
, libX11
, libXScrnSaver
, libxcb
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libXinerama
, libXrender
, libXt
, libcanberra
, libnotify
, gnome
, libGLU
, libGL
, nspr
, nss
, pango
, pipewire
, pciutils
, libheimdal
, libpulseaudio
, systemd
, writeScript
, writeText
, xidel
, coreutils
, gnused
, gnugrep
, gnupg
, ffmpeg
, runtimeShell
, mesa # firefox wants gbm for drm+dmabuf
, systemLocale ? config.i18n.defaultLocale or "en-US"
}:
let
  nss_lib = nss.override
    { useP11kit = false; };

  policies = {
    DisableAppUpdate = true;
  } // config.firefox.policies or { };

  policiesJson = writeText "firefox-policies.json" (builtins.toJSON { inherit policies; });
in
stdenv.mkDerivation rec {
  name = "replay-browser-${version}";

  version = "0.0.1";

  src = fetchurl {
    url = "https://static.replay.io/downloads/linux-replay.tar.bz2";
    sha256 = "sha256-z5saTlX6oj5giPsMSpsnslG1mpfnRR0fk55zAGYuXzM=";
  };

  libPath = lib.makeLibraryPath
    [
      stdenv.cc.cc
      alsa-lib
      atk
      cairo
      curl
      cups
      dbus-glib
      dbus
      fontconfig
      freetype
      gdk-pixbuf
      glib
      glibc
      gtk2
      gtk3
      libkrb5
      mesa
      libX11
      libXScrnSaver
      libXcomposite
      libXcursor
      libxcb
      libXdamage
      libXext
      libXfixes
      libXi
      libXinerama
      libXrender
      libXt
      libcanberra
      libnotify
      libGLU
      libGL
      nspr
      nss
      pango
      pipewire
      pciutils
      libheimdal
      libpulseaudio
      systemd
      ffmpeg
    ] + ":" + lib.makeSearchPathOutput "lib" "lib64" [
    stdenv.cc.cc
  ];

  inherit gtk3;

  buildInputs = [ wrapGAppsHook gtk3 gnome.adwaita-icon-theme ];

  sourceRoot = "./replay";

  # "strip" after "patchelf" may break binaries.
  # See: https://github.com/NixOS/patchelf/issues/10
  dontStrip = true;
  dontPatchELF = true;

  patchPhase = ''
    # Don't download updates from Mozilla directly
    echo 'pref("app.update.auto", "false");' >> defaults/pref/channel-prefs.js
  '';

  installPhase =
    ''
      mkdir -p "$prefix/usr/lib/replay"
      cp -r * "$prefix/usr/lib/replay"

      mkdir -p "$out/bin"
      ln -s "$prefix/usr/lib/replay/replay" "$out/bin/"

      for executable in \
        replay plugin-container \
        updater crashreporter
      do
        if [ -e "$out/usr/lib/replay/$executable" ]; then
          patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            "$out/usr/lib/replay/$executable"
        fi
      done

      find . -executable -type f -exec \
        patchelf --set-rpath "$libPath" \
          "$out/usr/lib/replay/{}" \;

      # wrapFirefox expects "$out/lib" instead of "$out/usr/lib"
      ln -s "$out/usr/lib" "$out/lib"

      gappsWrapperArgs+=(--argv0 "$out/bin/.replay-wrapped")

      # See: https://github.com/mozilla/policy-templates/blob/master/README.md
      mkdir -p "$out/lib/replay/distribution";
      ln -s ${policiesJson} "$out/lib/replay/distribution/policies.json";
    
    '';

  meta = with lib; {
    homepage = "https://replay.io";
    description = "Replay Browser";
    platforms = platforms.linux;
  };
}
