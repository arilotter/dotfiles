{
  nixpkgs.hostPlatform = "aarch64-linux";

  hardware.beepy.enable = true;

  # raspberry pi doesn't do so hot without swap.
  zramSwap.enable = true;
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];
}
