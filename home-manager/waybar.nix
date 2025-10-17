{ ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "right";
        width = 50;
        margin = "16";
        margin-right = 0;
        spacing = 0;
        output = [
          "DP-2"
          "eDP-1"
        ];
        reload_style_on_change = true;
        modules-left = [ "hyprland/workspaces" ];
        modules-right = [
          "tray"
          "backlight"
          "network"
          "battery"
          "pulseaudio"
          "idle_inhibitor"
          "disk"
          "memory"
          "cpu"
          "temperature"
          "clock"
          "clock#calendar"
        ];

        battery = {
          format = "{icon}  {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        network = {
          format-wifi = "  {signalStrength}%";
          format-ethernet = "  {ifname}";
          format-disconnected = "󰤫";
        };
        pulseaudio = {
          scroll-step = 1;
          format = "{icon}  {volume}%";
          format-bluetooth = "vol.{volume}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = "";
          format-source = "{volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          rotate = 0;
          on-click = "pavucontrol";
        };

        backlight = {
          device = "amdgpu_bl1";
          format = "{icon} {percent}%";
          format-icons = [
            "󰛩"
            "󱩎"
            "󱩏"
            "󱩐"
            "󱩑"
            "󱩒"
            "󱩓"
            "󱩔"
            "󱩕"
            "󱩖"
            "󰛨"
          ];
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰛊 ";
            deactivated = "󰾫 ";
          };
        };

        disk = {
          interval = 30;
          format = "󰋊 {percentage_used}%";
          tooltip-format = ''{used} used out of {total} on "{path}" ({percentage_used}%)'';
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

        "clock#calendar" = {
          format = "{:%a %b %d}";
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
    # style = ''
    #   * {
    #       font-family: "${fonts.${cfg.font}.name}";
    #       font-size: ${toString fonts.sizes.desktop}pt;
    #   }
    # '';
  };
}
