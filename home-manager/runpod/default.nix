{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "runpodctl";
  version = "1.14.3";

  src = fetchFromGitHub {
    owner = "runpod";
    repo = "runpodctl";
    rev = "v${version}";
    hash = "sha256-ot/xxCL0RnMG39KDqINdAj6BSX+OLY6CusmP9Ubn8QI=";
  };

  vendorHash = "sha256-OGUt+L0wP6eQkY/HWL+Ij9z9u+wsQ5OLK/IAq+1ezVA=";

  meta = {
    description = "Runpod's CLI";
    homepage = "https://github.com/runpod/runpodctl";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ arilotter ];
  };
}
