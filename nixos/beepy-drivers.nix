{ pkgs, ... }:
let
  kernel = pkgs.rpi-kernels.latest.kernel;
  sharp-drm-src = pkgs.fetchFromGitHub {
    owner = "ardangelo";
    repo = "sharp-drm-driver";
    rev = "8bdc22653f0555b286c014dbb95bc8064f9693c4";
    sha256 = "sha256-eRj74G3SNwHgMqF9KYfCGLfaf2g+EZSdpIdnKW+FPwI=";
  };
  sharpDriver = pkgs.stdenv.mkDerivation rec {
    name = "sharp-drm";
    version = "0.0.1-${kernel.version}";
    src = sharp-drm-src;
    hardeningDisable = [ "pic" "format" ];
    nativeBuildInputs = kernel.moduleBuildDependencies;

    LINUX_DIR = "${kernel.dev}/lib/modules/${kernel.version}/build";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/modules/${kernel.version}/extra
      INSTALL_MOD_PATH=$out make -C '${LINUX_DIR}' M='$(shell pwd)' modules_install
      runHook postInstall
    '';
  };

  cmdline = pkgs.writeText "cmdline.txt" ''
    dwc_otg.lpm_enable=0 console=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline rootwait fbcon=font:VGA8x8 fbcon=map:10
  '';
  sharpOverlay = pkgs.runCommand "sharp-overlay" { } ''
    mkdir $out
    ${pkgs.dtc}/bin/dtc -@ -I dts -O dtb -o $out/sharp-drm.dtbo ${sharp-drm-src}/sharp-drm.dts
  '';
  # https://github.com/ardangelo/beepberry-keyboard-driver
  beepy-kbd-src = pkgs.fetchFromGitHub {
    owner = "ardangelo";
    repo = "beepberry-keyboard-driver";
    rev = "9a755c0c4f1ac2d025a7f879d9132335420d235f";
    sha256 = "sha256-Hriw9tPOi2ZF/z56ySdXLBHFCeAqs0GMjuyAMswJrK0=";
  };
  keyboardDriver =
    pkgs.stdenv.mkDerivation rec {
      pname = "beepy-kbd-driver";
      version = "2023-08-25-${kernel.version}";
      src = beepy-kbd-src;

      hardeningDisable = [ "pic" "format" ];
      nativeBuildInputs = kernel.moduleBuildDependencies ++ [ pkgs.dtc ];

      LINUX_DIR = "${kernel.dev}/lib/modules/${kernel.version}/build";

      installPhase = ''
        runHook preInstall
        INSTALL_MOD_PATH=$out make -C '${LINUX_DIR}' M='$(shell pwd)' modules_install

        # Install keymap
        mkdir -p $out/share/keymaps/
        cp ./beepy-kbd.map $out/share/keymaps

        # Install device tree overlay
        mkdir -p $out/boot/overlays/
        cp ./beepy-kbd.dtbo $out/boot/overlays

        ls -R $out

        runHook postInstall
      '';
    };
in
{
  # setup the Sharp display & BB keyboard
  boot.extraModulePackages = [ sharpDriver keyboardDriver ];
  boot.kernelModules = [ "i2c-dev" ];
  console.packages = [ keyboardDriver ];
  console.keyMap = "beepy-kbd";
  console.earlySetup = true;
  hardware.raspberry-pi.config.all = {
    dt-overlays = {
      sharp-drm = {
        enable = true;
        params = { };
      };
      beepy-kbd = {
        enable = true;
        params = {
          irq_pin = {
            enable = true;
            value = "4";
          };
        };
      };
    };

    base-dt-params = {
      i2c_arm = {
        enable = true;
        value = "on";
      };
      spi = {
        enable = true;
        value = "on";
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

  # fix for wifi rpi 3 and light 2
  boot.extraModprobeConfig = ''
    options brcmfmac roamoff=1 feature_disable=0x82000
  '';

  sdImage = {
    compressImage = false;
    populateFirmwareCommands = ''
      mkdir -p firmware/overlays/
      chmod -R 777 firmware/overlays
      ls -laR ${keyboardDriver}
      cp ${sharpOverlay}/sharp-drm.dtbo firmware/overlays/
      cp ${keyboardDriver}/boot/overlays/* firmware/overlays/
      cp ${cmdline} firmware/cmdline.txt
    '';
  };
}
