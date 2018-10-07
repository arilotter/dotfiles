source $stdenv/setup

configurePhase() {
  ./autogen.sh
  ./configure --prefix=$out
}
buildPhase() {
  make
  make install
}
genericBuild