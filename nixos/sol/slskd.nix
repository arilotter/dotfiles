{...}: {
  services.slskd = {
    enable = true;
    environmentFile = "/home/ari/slskd.env";
    domain = null;
    settings = {
      shares = {
        directories = ["/mnt/storage/music"];
        filters = [
          "\.ini$"
          "Thumbs.db$"
          "\.DS_Store$"
        ];
      };
      global.upload.slots = 5;
      directories.downloads = "/mnt/storage/music-new-downloads";
    };
  };
}
