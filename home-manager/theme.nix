let
  hex = {
    color0 = "#000000";
    color1 = "#D27858";
    color2 = "#E87C58";
    color3 = "#D07D61";
    color4 = "#A58676";
    color5 = "#F7835D";
    color6 = "#ED8A66";
    color7 = "#b5b5b9";
    color8 = "#7e7e81";
    color9 = "#D27858";
    color10 = "#E87C58";
    color11 = "#D07D61";
    color12 = "#A58676";
    color13 = "#F7835D";
    color14 = "#ED8A66";
    color15 = "#b5b5b9";
    black = "#000000";
    red = "#D27858";
    green = "#E87C58";
    yellow = "#D07D61";
    blue = "#A58676";
    magenta = "#F7835D";
    cyan = "#ED8A66";
    white = "#b5b5b9";
    brightblack = "#7e7e81";
    brightred = "#D27858";
    brightgreen = "#E87C58";
    brightyellow = "#D07D61";
    brightblue = "#A58676";
    brightmagenta = "#F7835D";
    brightcyan = "#ED8A66";
    brightwhite = "#b5b5b9";
    background = "#000000";
    foreground = "#b5b5b9";
    cursor = "#b5b5b9";
  };
  hex2rgb = hex: 
    builtins.concatStringsSep "," [
      builtins.toInt "0x${builtins.substring 1 2 hex}"
      builtins.toInt "0x${builtins.substring 3 2 hex}"
      builtins.toInt "0x${builtins.substring 5 2 hex}"
    ];
  hex2xrgba = hex: 
    builtins.concatStringsSep "/" [
      builtins.substring 1 2 hex
      builtins.substring 3 2 hex
      builtins.substring 5 2 hex
      "ff"
    ];
  hex2strip = hex: builtins.substring 1 7 hex;
  hex2zerox = hex: "0x${builtins.substring 1 7 hex}";

in {
  # absolute path to current wallpaper
  wallpaper = "";

  # Colors
  # 0xRRGGBB
  hex = hex;

  # red,grn,blu
  rgb = builtins.mapAttrs (name: value: hex2rgb value) hex;

  # rr,gg,bb,aa
  xrgba = builtins.mapAttrs (name: value: hex2xrgba value) hex;
  
  # RRGGBB
  strip = builtins.mapAttrs (name: value: hex2strip value) hex;
  
  # 0xRRGGBB
  zerox = builtins.mapAttrs (name: value: hex2zerox value) hex;
}