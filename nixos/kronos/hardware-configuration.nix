{
  nixpkgs.hostPlatform = "aarch64-linux";

  hardware.raspberry-pi.config.all = {
    base-dt-params = {
      # enable autoprobing of bluetooth driver
      # https://github.com/raspberrypi/linux/blob/c8c99191e1419062ac8b668956d19e788865912a/arch/arm/boot/dts/overlays/README#L222-L224
      krnbt = {
        enable = true;
        value = "on";
      };
      #  dtparam=i2c_arm $SETTING $CONFIG &&
      # SETTING=on
      i2c_arm = {
        enable = true;
        value = "on";
      };
      spi = {
        enable = true;
        value = "on";
      };
    };
    dt-overlays = {
      sharp = {
        enable = true;
        params = { };
      };
      i2c-bbqX0kbd = {
        enable = true;
        params = {
          irq_pin = {
            enable = true;
            value = "4";
          };
        };
      };
    };
    options = {
      framebuffer_width = {
        enable = true;
        value = "400";
      };
      framebuffer_height = {
        enable = true;
        value = "240";
      };
    };
  };
}
