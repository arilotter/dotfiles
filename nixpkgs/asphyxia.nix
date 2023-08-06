with import <nixpkgs> { };

stdenv.mkDerivation rec {
  pname = "asphyxia-core";
  coreVersion = "1.40";
  pluginsVersion = "0.5";
  version = "${coreVersion}-${pluginsVersion}";

  src = fetchurl {
    url = "https://github.com/asphyxia-core/asphyxia-core.github.io/releases/download/v${coreVersion}/asphyxia-core-linux-x64.zip";
    sha256 = "sha256-YFAXHzxoLuKfflwqYvpifefRE2/KbShuQ0v+0LG7OCg=";
  };
  plugins = fetchurl {
    url = "https://github.com/asphyxia-core/plugins/archive/refs/tags/${pluginsVersion}.zip";
    sha256 = "sha256-MWM5NY3PQWWUnG264dNgZQKNopwPgmj9Om3qM+aUXtc=";
  };

  nativeBuildInputs = [ pkgs.unzip autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib ];

  sourceRoot = ".";

  unpackPhase = ''
    unzip $src
    unzip $plugins
    mv plugins-${pluginsVersion}/* plugins/
  '';

  installPhase = ''
    install -m755 -D asphyxia-core $out/bin/asphyxia-core
    cp -R plugins $out/bin/plugins
  '';

  meta = with lib; {
    description = "Asphyxia CORE";
    homepage = "https://asphyxia-core.github.io/";
    #license = licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
  };
}




