{
  pkgs,
  config,
  ...
}: {
  home.packages = with config.colorScheme.palette; [
    (pkgs.writeShellScriptBin "colors" ''
      #!/usr/bin/env bash
      show_color() {
          perl -e 'foreach $a(@ARGV){print "\e[48:2::".join(":",unpack("C*",pack("H*",$a)))."m             \e[49m "};print "\n"' "$@"
      }
      echo "Base16 Colors"
      echo "-------------"
      echo "base00 ${base00}"
      show_color ${base00}
      echo "base01 ${base01}"
      show_color ${base01}
      echo "base02 ${base02}"
      show_color ${base02}
      echo "base03 ${base03}"
      show_color ${base03}
      echo "base04 ${base04}"
      show_color ${base04}
      echo "base05 ${base05}"
      show_color ${base05}
      echo "base06 ${base06}"
      show_color ${base06}
      echo "base07 ${base07}"
      show_color ${base07}
      echo "base08 ${base08}"
      show_color ${base08}
      echo "base09 ${base09}"
      show_color ${base09}
      echo "base0A ${base0A}"
      show_color ${base0A}
      echo "base0B ${base0B}"
      show_color ${base0B}
      echo "base0C ${base0C}"
      show_color ${base0C}
      echo "base0D ${base0D}"
      show_color ${base0D}
      echo "base0E ${base0E}"
      show_color ${base0E}
      echo "base0F ${base0F}"
      show_color ${base0F}
    '')
  ];
}
