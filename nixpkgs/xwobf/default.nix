with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "xwobf";
  src = fetchFromGitHub {
    owner = "glindste";
    repo = "xwobf";
    rev = "4ff96e34a155b32336c65d301f88b561b9450b82";
    sha256 = "1ym287q18dbflifzp0an6an036adr4jn9p51c998wqdbb8r1y2xp";
  };
  patches = [ ./xwobf.c.patch ];
  makeFlags = [ "PREFIX=$(out)" ];
  buildInputs = [ pkgconfig imagemagick xorg.libxcb.dev ];
}