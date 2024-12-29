with import <nixpkgs> { };
buildGoPackage rec {
  pname = "drone-cli";
  version = "1.2.0";

  goPackagePath = "github.com/drone/drone-cli";

  src = fetchFromGitHub {
    owner = "drone";
    repo = pname;
    rev = "v${version}";
    sha256 = "1b1c3mih760z3hx5xws9h4m1xhlx1pm4qhm3sm31cyim9p8rmi4s";
  };

  meta = with stdenv.lib; {
    description = "Drone CLI";
    homepage = "https://github.com/drone/drone-cli";
    platforms = platforms.unix;
  };
}
