{
  config,
  pkgs,
  ...
}:
let
  c = config.colorScheme.palette;
in
{
  home.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    GDK_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORM_THEME = "qt6ct";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    HYPRCURSOR_THEME = config.home.pointerCursor.name;
    HYPRCURSOR_SIZE = config.home.pointerCursor.size;
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        before_sleep_cmd = "hyprlock";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
      };
      listener = [
        {
          timeout = 60;
          on-timeout = "hyprlock";
        }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 10;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          color = "rgb(${c.base00})";
        }
      ];

      input-field = [
        {
          size = "400, 50";
          position = "0, 0";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          rounding = -1;
          font_color = "rgb(${c.base05})";
          inner_color = "rgb(${c.base00})";
          outer_color = "rgb(${c.base05})";
          outline_thickness = 2;
          placeholder_text = "";
          fail_text = "";
        }
      ];
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      "$terminal" = "kitty";
      "$mod" = "SUPER";

      exec-once = [
        "hyprpaper"
        "systemctl --user enable xdg-desktop-portal-hyprland"
        "waybar"
        "gnome-keyring-daemon --start --components=secrets"
      ];

      monitor = [
        # uhhh how do we do this per-system? lol
        "DP-2,3840x2160@60,2160x200,1"
        "DP-1,2160x3840@60,0x0,1,transform,3"
        "eDP-1,2560x1600@165,0x0,1"
      ];

      general = {
        gaps_in = 4;
        gaps_out = 4;
        border_size = 4;
        "col.active_border" = "rgb(${c.base0D})";
        "col.inactive_border" = "rgb(${c.base00})";
        layout = "dwindle";
      };

      decoration = {
        rounding = 9;
        blur.enabled = false;
        shadow.enabled = false;
      };

      animations.enabled = false;

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
      };

      master.smart_resizing = true;

      gestures = {
        workspace_swipe = true;
        workspace_swipe_distance = 600;
        workspace_swipe_cancel_ratio = 0.5;
        workspace_swipe_min_speed_to_force = 7;
      };

      input = {
        kb_layout = "us";
        repeat_delay = 300;
        repeat_rate = 50;
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.3;
          disable_while_typing = false;
        };
      };

      layerrule = [ "blur,waybar" ];

      bindm = [
        # Move/resize windows with mod + LMB/RMB and dragging
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindl = [
        ",switch:on:Lid Switch,exec,systemctl suspend"
        ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
        ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
      ];

      binde = [
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 5+"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 5-"
        ", XF86AudioRaiseVolume, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +3%"
        ", XF86AudioLowerVolume, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -3%"
      ];

      bind =
        [
          "$mod, Return, exec, ${pkgs.kitty}/bin/kitty"
          "$mod, R, togglesplit"
          "$mod, F, fullscreen"
          "$mod, D, exec, rofi -show drun -show-icons"
          "$mod Shift, Q, killactive"

          "$mod, Tab, workspace, previous"
          "ALT, Tab, cyclenext"
          "ALT, Tab, bringactivetotop"
          "$mod, Space, togglefloating"
          "$mod Shift, Space, pseudo"
          "$mod, C, exec, ags toggle-window notificationsCenter"
          "$mod, N, exec, ags toggle-window quicksettings"
          ", Print, exec, grimblast copysave output # screenshot"
          ", XF86AudioMute, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle"

          # screenshot area
          "SUPER_SHIFT,S, exec, grimblast copysave area"

          "SUPER_SHIFT,A,movetoworkspace,special"
          "SUPER,A,togglespecialworkspace"

          # Move focus with mod + arrow keys
          "$mod, Left, movefocus, l"
          "$mod, Right, movefocus, r"
          "$mod, Up, movefocus, u"
          "$mod, Down, movefocus, d"

          # Move windows with mod + arrow keys
          "$mod Shift, Left, movewindow, l"
          "$mod Shift, Right, movewindow, r"
          "$mod Shift, Up, movewindow, u"
          "$mod Shift, Down, movewindow, d"
          # Scroll through existing workspaces with mod + scroll
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (
            builtins.genList (
              x:
              let
                ws =
                  let
                    c = (x + 1) / 10;
                  in
                  builtins.toString (x + 1 - (c * 10));
              in
              [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            ) 10
          )
        );

      windowrulev2 = [
        "float,class:^(pavucontrol)$"
        "float,title:(Open Files)$"
        "float,title:(Save File)$"
      ];

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        layers_hog_keyboard_focus = true;
        disable_autoreload = false;
        allow_session_lock_restore = true;
        vrr = 2;
      };
    };
  };
}
