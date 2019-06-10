{ pkgs, rustChannelOf, buildRustCrate, fetchFromGitHub }:
let 
  rustChannel = rustChannelOf {
      date = "2018-11-10";
      channel = "nightly";
  };
in
buildRustCrate {
  version = "0.1.0";
  name = "rust-analyzer";
  src = fetchFromGitHub {
    owner = "rust-analyzer";
    repo = "rust-analyzer";
    rev = "64ab5ab10d32e7e8ec085af818d3d94211aea39b";
    sha256 = "079rq0bxwz5dvdsjdarzqs5pvrkmhwr1a25llm5rz8gvm4y4rxr1";
  };
  installPhase = "cargo install-lsp";
  buildInputs = [ pkgs.cargo ];
}