{
  pkgs,
  inputs,
  ...
}: {
  programs.nixvim = {
    enable = true;

    plugins.lualine.enable = true;
  };
}
