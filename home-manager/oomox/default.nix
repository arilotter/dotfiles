with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "oomox";
  src = fetchFromGitHub {
    owner = "themix-project";
    repo = "oomox";
    rev = "69c41084d8509a0916c145793cbe2fb045dfd3cc";
    sha256 = "1j4d07fbsddx2k7m7xhl9q219dgj9rrr7b2rxwhpm0ysvh84jg3r";
    fetchSubmodules = true;
  };
  buildPhase = '''';
  installPhase = ''
  mkdir -p $out
	make install
  cp -R ./distrib/* $out
  '';
  buildInputs = [ bc gtk3 gdk_pixbuf glib sassc librsvg python3Packages.pygobject3 ];
}