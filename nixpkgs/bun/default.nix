with import <nixpkgs> { };

stdenv.mkDerivation rec {
  pname = "bun";
  version = "0.1.1";
  src = pkgs.fetchzip {
    url = "https://github.com/Jarred-Sumner/bun-releases-for-updater/releases/download/bun-v${version}/bun-linux-x64.zip";
    sha256 = "sha256-dNs5TNfNroJ9gE8KxX0C5EvIiRakIRZbMDMqS/GOhew=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src/bun $out/bin/bun
    chmod +x $out/bin/bun
  '';
  meta = with lib; {
    description = "A fast all-in-one JavaScript runtime";
    homepage = "https://github.com/Jarred-Sumner/bun";
    license = licenses.mit;
    maintainers = [ ];
  };

}
