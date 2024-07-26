{
  pkgs ? import <nixpkgs> { },
}:
with pkgs;
rustPlatform.buildRustPackage {
  name = "wasmtime";
  src = fetchFromGitHub {
    owner = "cranestation";
    repo = "wasmtime";
    rev = "8dc1d90352121e6e7ef953be9f32e29618a19627";
    sha256 = "1i2ig6fbp1bnhghh27xgnscp8pc2rmmhp4glq3j0r6xg7k85k3fp";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [
    python
    cmake
    clang
  ];
  buildInputs = [ llvmPackages.libclang ];
  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";
  cargoPatches = [ ./Cargo.lock.patch ];
  cargoSha256 = "1jbpq09czm295316gdv3y0pfapqs0ynj3qbarwlnrv7valq5ak13";
}
