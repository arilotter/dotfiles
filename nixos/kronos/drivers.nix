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
  # https://github.com/w4ilun/bbqX0kbd_driver/
  bbqX0kbdSrc = pkgs.fetchFromGitHub {
    owner = "w4ilun";
    repo = "bbqX0kbd_driver";
    rev = "a54d036d08911f3a7bce457b739f51f12b652303";
    sha256 = "sha256-H+lnOXiphHX9GWpEZXM1VcZBPNSk4p4mKvKly8tu8x4=";
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
      name = "bbqX0kbd_driver";
      version = "0.0.1-${kernel.version}";
      src = bbqX0kbdSrc;

      hardeningDisable = [ "pic" "format" ];
      nativeBuildInputs = kernel.moduleBuildDependencies ++ [ pkgs.dtc ];

      KROOT = "${kernel.dev}/lib/modules/${kernel.version}/build";
      KDIR = "${kernel.dev}/lib/modules/${kernel.version}/build";
      postPatch = ''
        sed -i  "s/BBQX0KBD_TYPE BBQ.*/BBQX0KBD_TYPE ${type}/g" source/mod_src/config.h
        sed -i  "s/BBQ20KBD_TRACKPAD_USE BBQ20KBD_TRACKPAD_AS.*/BBQ20KBD_TRACKPAD_USE ${trackpad}/g" source/mod_src/config.h
        sed -i  "s/BBQX0KBD_INT BBQ.*/BBQX0KBD_INT ${int}/g" source/mod_src/config.h
        sed -i  "s/BBQX0KBD_INT_PIN .*/BBQX0KBD_INT_PIN ${intPin}/g" source/mod_src/config.h
        sed -i  "s/BBQX0KBD_POLL_PERIOD .*/BBQX0KBD_POLL_PERIOD ${pollPeriod}/g" source/mod_src/config.h
        sed -i  "s/BBQX0KBD_ASSIGNED_I2C_ADDRESS .*/BBQX0KBD_ASSIGNED_I2C_ADDRESS ${assignedI2cAddress}/g" source/mod_src/config.h
        cp source/dts_src/i2c-bbqX0kbd-int.dts source/dts_src/i2c-bbqX0kbd.dts
      '';
      buildPhase = ''
        runHook preBuild
        make
        make dtbo
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p $out/lib/modules/${kernel.version}/kernel/drivers/i2c/
        cp bbqX0kbd.ko $out/lib/modules/${kernel.version}/kernel/drivers/i2c/
        mkdir -p $out/share/keymaps/
        echo 'include "${pkgs.kbd}/share/keymaps/i386/qwerty/us.map.gz"' > $out/share/keymaps/bbqX0kbd
        cat ./source/mod_src/bbqX0kbd.map >> $out/share/keymaps/bbqX0kbd
      
        mkdir -p $out/boot/overlays/
        cp i2c-bbqX0kbd.dtbo $out/boot/overlays/i2c-bbqX0kbd.dtbo
        runHook postInstall
      '';
    };
in
{
  boot.extraModulePackages = [ sharpDriver keyboardDriver ];
  boot.kernelModules = [ "i2c-dev" ];
  console.packages = [ keyboardDriver ];
  console.keyMap = "bbqX0kbd";
  console.earlySetup = true;

  # fix for wifi rpi 3 and light 2
  boot.extraModprobeConfig = ''
    options brcmfmac roamoff=1 feature_disable=0x82000
  '';

  sdImage = {
    populateFirmwareCommands = ''
      mkdir -p firmware/overlays/
      cp ${sharpOverlay}/sharp.dtbo firmware/overlays/
      cp ${keyboardDriver}/boot/overlays/i2c-bbqX0kbd.dtbo firmware/overlays/
      cp ${cmdline} firmware/cmdline.txt
    '';
  };
}
