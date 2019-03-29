with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "srandrd";
  src = fetchFromGitHub {
    owner = "jceb";
    repo = "srandrd";
    rev = "1ab4880b0f2154e0b1b8d4acf7188a8c63d0fa5b";
    sha256 = "174vbya270gmpkfvgv1p0y5h023mm985a6sjln8s7vgvm13ix9c9";
  };
  makeFlags = [ "PREFIX=$(out)" ];
  buildInputs = [ xorg.libX11 xorg.libXrandr xorg.libXinerama ];
}