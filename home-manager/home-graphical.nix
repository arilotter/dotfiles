{ config, pkgs, inputs, ... }:

let
  vsc-ext = inputs.vscode-ext.extensions.${pkgs.system}.vscode-marketplace;
in
{

  colorScheme = inputs.nix-colors.colorSchemes.paraiso;

  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        isDefault = true;
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          bitwarden
          sponsorblock
          refined-github
        ];
      };
    };
  };

  home.packages = with pkgs; [
    # desktop env
    hyprpaper # wallpaper manager
    gnome3.nautilus # file manager
    pamixer # audio control shell for gbar
    inputs.hypr-contrib.packages.${pkgs.system}.grimblast # screenshot tool
    kitty # terminal emulator
    pavucontrol # audio control
    blueman # bluetooth manager
    wofi # launcher
    wl-clipboard # copy/paste cli
    monado # xr? :D
    sass # for gbar

    easyeffects # mic settings

    vlc # video player
    spotify # music player
    google-chrome # web browser
    vesktop
    slack

    # VS code setup!
    (vscode-with-extensions.override {
      vscodeExtensions = with vsc-ext; [
        ms-vscode-remote.remote-containers
        semanticdiff.semanticdiff
        ms-python.python
        ms-python.vscode-pylance
        ms-python.black-formatter
        ms-vsliveshare.vsliveshare
        golang.go
        rust-lang.rust-analyzer
        dbaeumer.vscode-eslint
        usernamehw.errorlens
        ms-vscode.cpptools
        jnoortheen.nix-ide
        # (import ./skyweaver-vscode)
        tamasfe.even-better-toml
        # jolaleye.horizon-theme-vscode
        esbenp.prettier-vscode
        dbaeumer.vscode-eslint
        gruntfuggly.todo-tree
        wallabyjs.quokka-vscode
        biomejs.biome
        yoavbls.pretty-ts-errors
        slevesque.shader
        xaver.clang-format
        ms-playwright.playwright
      ];
    })

    #clang format needs..
    clang-tools
  ];

  home.file = {
    ".config/hypr/hyprpaper.conf".text = ''
      preload = /home/ari/dotfiles/wallpapers/future_funk_4k.jpg
      wallpaper = ,/home/ari/dotfiles/wallpapers/future_funk_4k.jpg
    '';
    ".config/gBar/style.css".source = import ./compileSass.nix {
      pkgs = pkgs;
      inputFile = ./gBar/style.scss;
      otherFiles = "${pkgs.writeTextDir "colors.scss" (import ./gBar/colors.scss.nix config)}/colors.scss";
    };
  };

  wayland.windowManager.hyprland =
    {
      enable = true;
      xwayland.enable = true;
      extraConfig = import ./hyprland.nix pkgs;
    };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "right";
        width = 20;
        margin = "8";
        spacing = 16;
        output = "DP-2";
        reload_style_on_change = true;
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-right = [
          "tray"
          "idle_inhibitor"
          "disk"
          "memory"
          "cpu"
          "temperature"
          "clock"
        ];
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰛊 ";
            deactivated = "󰾫 ";
          };
        };
        disk = {
          intervel = 30;
          format = "󰋊 {percentage_used}%";
          tooltip-format = "{used} used out of {total} on \"{path}\" ({percentage_used}%)";
        };
        memory = {
          interval = 10;
          format = " {used}";
          tooltip-format = "{used}GiB used of {total}GiB ({percentage}%)";
        };
        cpu = {
          interval = 10;
          format = " {usage}%";
        };
        temperature = {
          interval = 10;
        };
        clock = {
          interval = 1;
          format = "{:%H:%M:%S}";
        };
        "hyprland/workspaces" = {
          show-special = true;
          persistent-workspaces = {
            "*" = [
              1
              2
              3
              4
              5
              6
              7
              8
              9
              10
            ];
          };
          format = "{icon}";
          format-icons = {
            active = "";
            empty = "";
            default = "";
            urgent = "";
            special = "󰠱";
          };
          # "format-window-separator ="|";
          # "window-rewrite-default ="";
          # "window-rewrite ={
          #   "title<.*youtube.*> =" ", # Windows whose titles contain "youtube"
          #   "class<firefox> =" ", # Windows whose classes are "firefox"
          #   "class<firefox> title<.*github.*> =" ", # Windows whose class is "firefox" and title contains "github". Note that "class" always comes first.
          #   "class<alacritty> ="", # Windows that contain "foot" in either class or title. For optimization reasons, it will only match against a title if at least one other window explicitly matches against a title.
          #   "code ="󰨞"
          #   }
        };
        "hyprland/window" = {
          icon = true;
          icon-size = 22;
          rewrite = {
            "(.*) — Mozilla Firefox" = "$1 - 🦊";
            "(.*) - Visual Studio Code" = "$1 - 󰨞 ";
            "(.*) - Discord" = "$1 - 󰙯 ";
            "^$" = "👾";
          };
        };
      };
    };
  };

  services =
    {
      dunst = import ./dunst.nix pkgs;
      network-manager-applet.enable = true;
    };
  programs.fish = {
    shellAliases = {
      pbpaste = "wl-paste";
      pbcopy = "wl-copy";
    };
    shellInit = ''

      set -gx GDK_BACKEND wayland
      set -gx MOZ_ENABLE_WAYLAND 1

      set -gx SUDO_EDITOR code
      set -gx VISUAL code
    '';
  };
}
