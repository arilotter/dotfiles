with import <nixpkgs> { };

stdenv.mkDerivation {
  name = "git-quick-stats";
  src = fetchFromGitHub {
    owner = "arzzen";
    repo = "git-quick-stats";
    rev = "8bfc58710a32557beef663b96bdf21f8d6d81a09";
    sha256 = "101qdh49j4x4h1532zjbgr4wdk6m2awyhbpki14zq33p4zs4xb7v";
  };
  patches = [ ./Makefile.patch ];
  patchFlags = [ "-p0" ];
  makeFlags = [ "PREFIX=$(out)" ];
  buildInputs = [ git gawk gnused coreutils gnugrep utillinux ];
}
