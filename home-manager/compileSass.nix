{
  pkgs,
  inputFile,
  otherFiles ? "/dev/null",
}:
let
  base = builtins.baseNameOf inputFile;
in
"${
  pkgs.runCommand "compiledSass" { } ''
    mkdir src;
    cp ${inputFile} src/${base};
    cp -t ./src ${otherFiles};
    ls -R ./src;
    mkdir $out;
    ${pkgs.sass}/bin/sass src/${base} $out/style.css
  ''
}/style.css"
