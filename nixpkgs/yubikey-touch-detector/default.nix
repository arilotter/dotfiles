{ pkgs, lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "yubikey-touch-detector";
  version = "1.9.1";
  src = fetchFromGitHub {
    owner = "maximbaz";
    repo = "yubikey-touch-detector";
    rev = "1.9.1";
    sha256 = "1zg68wk211w6rpmhpinws0ihfp2xzmfgfxissw5dypav104m3mr3";
  };
  vendorSha256 = "1jz5qm9fmnljzkmyrizlb3ziq9vy4vqz2zqbnp704prb0qdwpq2i";
  nativeBuildInputs = with pkgs; [ pkg-config go ];

  buildInputs = with pkgs; [ gnupg openssh libnotify ];
}
