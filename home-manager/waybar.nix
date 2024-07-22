{ config, ... }:
let c = config.colorScheme.palette; in
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "right";
        width = 50;
        margin = "16";
        margin-right = 0;
        spacing = 0;
        output = [ "DP-2" "eDP-1" ];
        reload_style_on_change = true;
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-right = [
          "backlight"
          "network"
          "tray"
          "battery"
          "pulseaudio"
          "idle_inhibitor"
          "disk"
          "memory"
          "cpu"
          "temperature"
          "clock"
        ];

        battery = {
          # format = "{icon} {percent}%";
        };

        network = {
          format-wifi = "  {signalStrength}%";
          format-ethernet = "  {ifname}: {ipaddr}/{cidr}";
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
            default = [ "" "" "" ];
          };
          rotate = 0;
          on-click = "pavucontrol";
        };

        backlight = {
          device = "amdgpu_bl1";
          format = "{icon} {percent}%";
          format-icons = [ "󰛩" "󱩎" "󱩏" "󱩐" "󱩑" "󱩒" "󱩓" "󱩔" "󱩕" "󱩖" "󰛨" ];
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

    style = ''
      * {
        font-family: "FiraCode Nerd Font";
        font-size: 12px;
        min-height: 0;
        color: #${c.base05};
      }

      window#waybar {
        background-color: #${c.base00};
        border-radius: 0;
        border: 2px solid #${c.base05};
        border-right: 0;
        margin-top: 8px;
        margin-bottom: 8px;
      }

      #workspaces button {
        color: #${c.base05};
        background: transparent;
      }
      #workspaces button.focused {
        background: #${c.base01};
      }

      #idle_inhibitor, #disk, #temperature, #cpu, #memory, #network, #pulseaudio, #clock, #battery, #tray {
        background: transparent;
        margin: 0;
        padding: 8px;
        border-top: 1px solid #${c.base05};
      }

      #idle_inhibitor.activated {
        background: #${c.base04};
      }
    '';
  };
}
