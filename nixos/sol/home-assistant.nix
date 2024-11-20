{
  pkgs,
  config,
  lib,
  ...
}: {
  services.home-assistant = {
    enable = true;
    openFirewall = true;
    extraComponents = [
      "esphome"
      "met"
      "radio_browser"
      "hue"
      "roku"
      "cast"
    ];
    config = {
      default_config = {};
    };
  };
}
