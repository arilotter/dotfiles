{
  services.immich = {
    enable = true;
    port = 2283;
    openFirewall = true;
  };
  users.users.immich.extraGroups = [ "video" "render" ];
}
