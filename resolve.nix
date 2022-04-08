# Based on https://github.com/egasimus/nur-packages/blob/b892a8769ba7f1391c725fd76ccd47c7e1a7a794/davinci-resolve/default.nix
# downloader based on https://github.com/NixOS/nixpkgs/issues/94032#issuecomment-733637809
# which is itself based on https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=davinci-resolve
# also based on https://discourse.nixos.org/t/fixup-phase-cant-find-libcuda-so-1-build-abort-how-to-provide-dummy-libcuda-so-1/9541/3?u=brogos

{ appimageTools
, autoPatchelfHook
, bash
, buildFHSUserEnv
, callPackage
, dpkg
, e2fsprogs
, fakeroot
, fetchurl
, fuse
, glib
, glibc
, gnome3
, kmod
, lib
, libarchive
, ocl-icd
, pkgs
, qt5
, runCommand
, stdenv
, strace
, targetPlatform
, unzip
, utillinux
, vmTools
, writeScriptBin
, writeShellScriptBin
, xkeyboard_config
, zlib
}:
let
  rpath = stdenv.lib.makeLibraryPath [ fuse glib glibc zlib ];

  pname = "davinci-resolve";
  version = "16.2.8";

  installer =
    let
      name = "${pname}-${version}-src";
      context = rec {
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = "jNBFgg52xkOBYO5XF2p8Fr0BGW02jkqj12OireVCZYE=";
        impureEnvVars = lib.fetchers.proxyImpureEnvVars;
        nativeBuildInputs = with pkgs; [ curl gnused unzip ];

        SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
        DOWNLOADID = "3dc96708d3e841c4a19f9ca17aca2e6b";
        REFERID = "0221c32a73844413bc0b1ec35686a4d3";
        SITEURL = "https://www.blackmagicdesign.com/api/register/us/download/${DOWNLOADID}";
        USERAGENT = builtins.concatStringsSep " " [
          "User-Agent: Mozilla/5.0 (X11; Linux ${targetPlatform.system})"
          "AppleWebKit/537.36 (KHTML, like Gecko)"
          "Chrome/77.0.3865.75"
          "Safari/537.36"
        ];
        REQJSON = ''{
         "firstname": "Arch",
         "lastname": "Linux",
         "email": "someone@archlinux.org",
         "phone": "202-555-0194",
         "country": "us",
         "state": "New York",
         "city": "AUR",
         "product": "DaVinci Resolve"
      }'';
      };
    in
    runCommand name context ''
      REQJSON="$(  printf '%s' "$REQJSON"   | sed 's/[[:space:]]\+/ /g')"
      USERAGENT="$(printf '%s' "$USERAGENT" | sed 's/[[:space:]]\+/ /g')"
      RESOLVEURL=$(curl \
           -s \
           -H 'Host: www.blackmagicdesign.com' \
           -H 'Accept: application/json, text/plain, */*' \
           -H 'Origin: https://www.blackmagicdesign.com' \
           -H "$USERAGENT" \
           -H 'Content-Type: application/json;charset=UTF-8' \
           -H "Referer: https://www.blackmagicdesign.com/support/download/$REFERID/Linux" \
           -H 'Accept-Encoding: gzip, deflate, br' \
           -H 'Accept-Language: en-US,en;q=0.9' \
           -H 'Authority: www.blackmagicdesign.com' \
           -H 'Cookie: _ga=GA1.2.1849503966.1518103294; _gid=GA1.2.953840595.1518103294' \
           --data-ascii "$REQJSON" \
           --compressed \
           "$SITEURL")
      curl --retry 3 --retry-delay 3 \
           -H "Host: sw.blackmagicdesign.com" \
           -H "Upgrade-Insecure-Requests: 1" \
           -H "$USERAGENT" \
           -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" \
           -H "Accept-Language: en-US,en;q=0.9" \
           --compressed \
           "$RESOLVEURL" \
           > resolve.zip
      mkdir -p $out
      unzip resolve.zip -d $out
      rm resolve.zip
    '';

  unpacked =
    let
      name = "${pname}-${version}-unpacked";
      context = {
        nativeBuildInputs = [ bash fakeroot dpkg strace libarchive ];
      };
      script = ''
        mkdir -p $out
        ls -l
        bsdtar x -f ${installer}/DaVinci_Resolve_${version}_Linux.run -C $out
        echo $out
        echo $PWD
      '';
    in
    runCommand name context script;

  davinci_binaries = stdenv.mkDerivation rec {
    version = "16.2.8";
    pname = "davinci_resolve";

    src = unpacked;

    passAsFile = [ "steamWrapper" ];

    nativeBuildInputs = [
      unzip
      libarchive # to get bsdtar
    ];

    # Otherwise it tries automatically to path the binaries, but we don't care, we use steam-run:
    dontFixup = true;

    installPhase = ''
      mkdir -p $out/{bin,opt}
      cp -r $src/* $out/opt/
    '';

    meta = {
      description = "DaVinci Resolve";
      homepage = https://;
      license = stdenv.lib.licenses.unfree;
      maintainers = [ stdenv.lib.maintainers.tobiasBora ];
      platforms = stdenv.lib.platforms.linux;
    };
  };
  # xkbcommon: ERROR: failed to add default include path /usr/share/X11/xkb
  # Qt: Failed to create XKB context!
  # Use QT_XKB_CONFIG_ROOT environmental variable to provide an additional search path, add ':' as separator to provide several search paths and/or make sure that XKB configuration data directory contains recent enough contents, to update please see http://cgit.freedesktop.org/xkeyboard-config/ .
  # Inspired by https://github.com/NixOS/nixpkgs/blob/7ebcaec02f2f250220db63ffc87d69663ffdaa86/pkgs/applications/editors/android-studio/common.nix
  davinci_fhsWrapper = writeShellScriptBin "davinci_resolve" ''
    export QT_XKB_CONFIG_ROOT "${xkeyboard_config}/share/X11/xkb"
    ${davinci_binaries}/opt/bin/resolve
  '';

  buildFHS_with_lib = buildFHSUserEnv {
    name = "fhs";

    targetPkgs = pkgs: [
      davinci_fhsWrapper
    ];

    multiPkgs = p: (appimageTools.defaultFhsEnvArgs.multiPkgs p) ++ [
      p.ocl-icd
      p.clinfo
      qt5.qtbase
      p.ffmpeg
      p.libxml2
      p.libuuid
    ];
    runScript = "davinci_resolve";
  };
in
buildFHS_with_lib
