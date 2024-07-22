with import <nixpkgs> { };

let
  wineLolGlibc = stdenv.mkDerivation {
    name = "wine-lol-glibc";
    src = fetchFromGitHub {
      owner = "glindste";
      repo = "xwobf";
      rev = "4ff96e34a155b32336c65d301f88b561b9450b82";
      sha256 = "1ym287q18dbflifzp0an6an036adr4jn9p51c998wqdbb8r1y2xp";
    };
    patches = [ ./xwobf.c.patch ];
    makeFlags = [ "PREFIX=$(out)" ];
    buildInputs = [ pkgconfig imagemagick xorg.libxcb.dev ];
  };
  stdenv.mkDerivation rec {
  name = "wine-lol";
  version = "4.9";
  src = fetchFromGitHub {
    owner = "glindste";
    repo = "xwobf";
    rev = "4ff96e34a155b32336c65d301f88b561b9450b82";
    sha256 = "1ym287q18dbflifzp0an6an036adr4jn9p51c998wqdbb8r1y2xp";
  };
  pocPatch = fetchurl (https://bugs.winehq.org/attachment.cgi?id=64481);
  patchStub = fetchurl (https://bugs.winehq.org/attachment.cgi?id=64496);
  srcs = [
    https://dl.winehq.org/wine/source/4.x/wine-$_pkgbasever.tar.xz
    "wine-staging-v$_pkgbasever.tar.gz::https://github.com/wine-staging/wine-staging/archive/v$_pkgbasever.tar.gz"
    30-win32-aliases.conf
  ]
    patches = [ ./xwobf.c.patch ];
  makeFlags = [ "PREFIX=$(out)" ];
  buildInputs = [ pkgconfig imagemagick xorg.libxcb.dev ];
  }
