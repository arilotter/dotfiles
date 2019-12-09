let
  hex = rec {
    color0 = "#21222C";
    color1 = "#FF5555";
    color2 = "#50FA7B";
    color3 = "#F1FA8C";
    color4 = "#BD93F9";
    color5 = "#FF79C6";
    color6 = "#8BE9FD";
    color7 = "#F8F8F2";
    color8 = "#6272A4";
    color9 = "#FF6E6E";
    color10 = "#69FF94";
    color11 = "#FFFFA5";
    color12 = "#D6ACFF";
    color13 = "#FF92DF";
    color14 = "#A4FFFF";
    color15 = "#FFFFFF";

    black = color0;
    red = color1;
    green = color2;
    yellow = color3;
    blue = color4;
    magenta = color5;
    cyan = color6;
    white = color7;

    brightblack = color8;
    brightred = color9;
    brightgreen = color10;
    brightyellow = color11;
    brightblue = color12;
    brightmagenta = color13;
    brightcyan = color14;
    brightwhite = color15;

    background = "#0D011E";
    foreground = "#FFFFD8";
    cursor = "#361766";
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