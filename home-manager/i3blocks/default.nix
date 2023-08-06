with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "i3blocks-git";
  src = fetchFromGitHub {
    owner = "vivien";
    repo = "i3blocks";
    rev = "103c78101e605d2b34ec55e4f0dea0315db7aaf0";
    sha256 = "03nabf68a7w3ipzmkx2lrp0sqrpscfl2cqby661db79fznfj0ic9";
  };
  builder = ./builder.sh;
  nativeBuildInputs = [ autoconf automake ];
}