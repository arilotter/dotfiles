{
  config,
  pkgs,
  ...
}:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "${pkgs.ghostty}/bin/ghostty";

    theme =
      let
        inherit (config.lib.formats.rasi) mkLiteral;
      in
      {
        "*".spacing = 2;
        "#window" = {
          border = 0;
          padding = mkLiteral "2.5ch";
        };

        "#mainbox" = {
          border = 0;
          padding = 0;
        };

        "#message" = {
          border = mkLiteral "2px 0px 0px";
          padding = mkLiteral "1px";
        };

        "inputbar".children = mkLiteral "[ prompt,textbox-prompt-colon,entry,case-indicator ]";

        "textbox-prompt-colon" = {
          expand = false;
          str = "";
          margin = mkLiteral "0px 0.3em 0em 0em";
        };

        "#listview" = {
          fixed-height = 0;
          border = mkLiteral "2px 0px 0px";
          spacing = mkLiteral "2px";
          scrollbar = true;
          padding = mkLiteral "2px 0px 0px";
        };

        "#element" = {
          border = 0;
          padding = mkLiteral "1px";
        };

        "#scrollbar" = {
          width = mkLiteral "4px";
          border = 0;
          handle-width = mkLiteral "8px";
          padding = 0;
        };

        "#sidebar".border = mkLiteral "2px 0px 0px";

        "#inputbar".spacing = 0;
        "#case-indicator".spacing = 0;
        "#entry".spacing = 0;
        "#prompt".spacing = 0;
      };
  };
}
