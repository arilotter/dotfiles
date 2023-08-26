{ pkgs, ... }:
let
  kernel = pkgs.rpi-kernels.latest.kernel;
  lcpDriver = pkgs.fetchFromGitHub {
    owner = "w4ilun";
    repo = "Sharp-Memory-LCD-Kernel-Driver";
    rev = "56fc25d3cc0d8d32065b6e54f3901378a1b83dea";
    sha256 = "sha256-DV59M1x1W+5P7HRCZCFRKrfTlITwTOlV0EQ6ERWnKjs=";
  };
  sharpDriver = pkgs.stdenv.mkDerivation rec {
    name = "sharp";
    version = "0.0.1-${kernel.version}";
    src = lcpDriver;
    hardeningDisable = [ "pic" "format" ];
    nativeBuildInputs = kernel.moduleBuildDependencies;

    KROOT = "${kernel.dev}/lib/modules/${kernel.version}/build";

    buildPhase = ''
      runHook preBuild
      make KROOT=${KROOT}
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib/modules/${kernel.version}/extra
      make KROOT=${KROOT} modules_install INSTALL_MOD_PATH=$out
      runHook postInstall
    '';
  };

  cmdline = pkgs.writeText "cmdline.txt" ''
    dwc_otg.lpm_enable=0 console=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline rootwait fbcon=map:10
  '';
  sharpOverlay = pkgs.runCommand "sharp-overlay" { } ''
    mkdir $out
    ${pkgs.dtc}/bin/dtc -@ -I dts -O dtb -o $out/sharp.dtbo ${lcpDriver}/sharp.dts
  '';
  # https://github.com/ardangelo/beepberry-keyboard-driver
  beepy-kbd-src = pkgs.fetchFromGitHub {
    owner = "ardangelo";
    repo = "beepberry-keyboard-driver";
    rev = "9a755c0c4f1ac2d025a7f879d9132335420d235f";
    sha256 = "sha256-Hriw9tPOi2ZF/z56ySdXLBHFCeAqs0GMjuyAMswJrK0=";
  };
  keyboardDriver =
    let
      type = "BBQ20KBD_PMOD";
      trackpad = "BBQ20KBD_TRACKPAD_AS_KEYS";
      int = "BBQX0KBD_USE_INT";
      intPin = "4";
      pollPeriod = "40";
      assignedI2cAddress = "BBQX0KBD_DEFAULT_I2C_ADDRESS";
      i2cAddress = "0x1F";
    in
    pkgs.stdenv.mkDerivation rec {
      pname = "beepy-kbd-driver";
      version = "2023-08-25-${kernel.version}";
      src = beepy-kbd-src;

      hardeningDisable = [ "pic" "format" ];
      nativeBuildInputs = kernel.moduleBuildDependencies ++ [ pkgs.dtc ];

      LINUX_DIR = "${kernel.dev}/lib/modules/${kernel.version}/build";
      KDIR = "${kernel.dev}/lib/modules/${kernel.version}/build";
      postPatch = ''
        sed -i  "s/BBQX0KBD_TYPE BBQ.*/BBQX0KBD_TYPE ${type}/g" src/config.h
        sed -i  "s/BBQ20KBD_TRACKPAD_USE BBQ20KBD_TRACKPAD_AS.*/BBQ20KBD_TRACKPAD_USE ${trackpad}/g" src/config.h
        sed -i  "s/BBQX0KBD_INT BBQ.*/BBQX0KBD_INT ${int}/g" src/config.h
        sed -i  "s/BBQX0KBD_INT_PIN .*/BBQX0KBD_INT_PIN ${intPin}/g" src/config.h
        sed -i  "s/BBQX0KBD_POLL_PERIOD .*/BBQX0KBD_POLL_PERIOD ${pollPeriod}/g" src/config.h
        sed -i  "s/BBQX0KBD_ASSIGNED_I2C_ADDRESS .*/BBQX0KBD_ASSIGNED_I2C_ADDRESS ${assignedI2cAddress}/g" src/config.h
      '';
      buildPhase = ''
        runHook preBuild
        make
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        INSTALL_MOD_PATH=$out make -C '${LINUX_DIR}' M='$(shell pwd)' modules_install

        # Install keymap
        mkdir -p $out/share/keymaps/
        cp ./beepy-kbd.map $out/share/keymaps

        # Install device tree overlay
        mkdir -p $out/boot/overlays/
        cp ./beepy-kbd.dtbo $out/boot/overlays

        runHook postInstall
      '';
    };
in
{
  boot.extraModulePackages = [ sharpDriver keyboardDriver ];
  boot.kernelModules = [ "i2c-dev" ];
  console.packages = [ keyboardDriver ];
  console.keyMap = "beepy-kbd";
  console.earlySetup = true;

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
      cp ${sharpOverlay}/sharp.dtbo firmware/overlays/
      cp ${keyboardDriver}/boot/overlays/* firmware/overlays/
      cp ${cmdline} firmware/cmdline.txt
    '';
  };
}
