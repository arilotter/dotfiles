{
  nixpkgs.hostPlatform = "aarch64-linux";

  # raspberry pi doesn't do so hot without swap.
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 8 * 1024;
  }];

  # enable autoprobing of bluetooth driver
  # https://github.com/raspberrypi/linux/blob/c8c99191e1419062ac8b668956d19e788865912a/arch/arm/boot/dts/overlays/README#L222-L224
  hardware.raspberry-pi.config.all.base-dt-params.krnbt = {
    enable = true;
    value = "on";
  };
}
