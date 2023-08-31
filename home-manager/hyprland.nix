{ pkgs, config, ... }: ''
  # Startup 
  exec-once = hyprpaper
  exec-once = gBar bar 0
  exec-once = ${pkgs.gnome3.gnome-keyring}/bin/gnome-keyring-daemon --daemonize --components=secrets
  # todo lockscreen

  input {
    kb_layout = us
    repeat_delay = 300
    repeat_rate = 50
  
    follow_mouse = 1

    touchpad {
      natural_scroll = yes
    }
  }

  gestures {
    workspace_swipe = true
    workspace_swipe_distance = 600
    workspace_swipe_cancel_ratio = 0.5
    workspace_swipe_min_speed_to_force = 7
  }

  general {
    gaps_in = 6
    gaps_out = 12
    border_size = 8
    col.inactive_border = rgba(bbbbdd55)
    col.active_border = rgba(bb3355ff)
    layout = dwindle
  }
  
  misc {
    disable_hyprland_logo = true
    disable_splash_rendering = true
    mouse_move_enables_dpms = true
    layers_hog_keyboard_focus = true
    vfr = false
  }


  decoration {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      rounding = 4
      multisample_edges = true

      blur {
        enabled = false
        size = 5
        passes = 1
      }

      shadow_range=20
      shadow_render_power=2
      col.shadow= 0x4D000000
      col.shadow_inactive=0x4D000000

      blurls=bar0
      blurls=bar1
      blurls=quicksettings
      blurls=indicator0
      blurls=indicator1
      blurls=wofi
      blurls=notifications
      blurls=notificationsCenter
      blurls=gtk-layer-shell
  }


  animations {
      enabled = true
      bezier=myBezier,0.48,0.46,0,1
      animation = windows, 1, 1, myBezier
      animation = windowsOut, 1, 1, myBezier, popin 80%
      animation = border, 1, 1, default
      animation = borderangle, 1, 1, default
      animation = fade, 1, 1, myBezier
      animation = workspaces, 1, 1, myBezier
  }

  dwindle {
      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
      pseudotile = yes # master switch for pseudotiling. Enabling is bound to mod + P in the keybinds section below
      preserve_split = yes # you probably want this
  }

  master {
      # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      new_is_master = true
  }

  gestures {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      workspace_swipe = yes
  }

  monitor=DP-1,3840x2160@60,2160x200,1
  monitor=DP-3,2160x3840@60,0x0,1,transform,3



  layerrule=ignorealpha[0.99],wofi
  layerrule=ignorealpha[0.99],quicksettings
  layerrule=ignorealpha[0.99],notificationsCenter
  layerrule=ignorealpha[0.99],indicator0
  layerrule=ignorealpha[0.99],indicator1

  windowrulev2=float,class:^(pavucontrol)$

  # Keybinds! 
  $mod = SUPER
  bind = $mod, Return, exec, ${pkgs.kitty}/bin/kitty
  bind = $mod, R, togglesplit
  bind = $mod, F, fullscreen
  bind = $mod, D, exec, wofi --show drun --allow-images
  bind = $mod Shift, Q, killactive

  bind = $mod, Tab, workspace, previous
  bind = ALT, Tab, cyclenext
  bind = ALT, Tab, bringactivetotop
  bind = $mod, Space, togglefloating
  bind = $mod Shift, Space, pseudo
  bind = $mod, C, exec, ags toggle-window notificationsCenter
  bind = $mod, N, exec, ags toggle-window quicksettings
  bind = , Print, exec, grimblast copysave output # screenshot
  binde = , XF86MonBrightnessUp, exec, ${pkgs.light}/bin/light -A 5
  binde = , XF86MonBrightnessDown, exec, ${pkgs.light}/bin/light -U 5
  binde = , XF86AudioRaiseVolume, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +3%
  binde = , XF86AudioLowerVolume, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -3%
  bind = , XF86AudioMute, exec, ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle
  
  # screenshot area
  bind = SUPER_SHIFT,S, exec, grimblast copysave area

  bind = SUPER_SHIFT,A,movetoworkspace,special
  bind = SUPER,A,togglespecialworkspace


  # Move focus with mod + arrow keys
  bind = $mod, Left, movefocus, l
  bind = $mod, Right, movefocus, r
  bind = $mod, Up, movefocus, u
  bind = $mod, Down, movefocus, d


  # Move windows with mod + arrow keys
  bind = $mod Shift, Left, movewindow, l
  bind = $mod Shift, Right, movewindow, r
  bind = $mod Shift, Up, movewindow, u
  bind = $mod Shift, Down, movewindow, d

  # Switch workspaces with mod + [0-9]
  bind = $mod, 1, workspace, 1
  bind = $mod, 2, workspace, 2
  bind = $mod, 3, workspace, 3
  bind = $mod, 4, workspace, 4
  bind = $mod, 5, workspace, 5
  bind = $mod, 6, workspace, 6
  bind = $mod, 7, workspace, 7
  bind = $mod, 8, workspace, 8
  bind = $mod, 9, workspace, 9
  bind = $mod, 0, workspace, 10

  # Move active window to a workspace with mod + SHIFT + [0-9]
  bind = $mod SHIFT, 1, movetoworkspace, 1
  bind = $mod SHIFT, 2, movetoworkspace, 2
  bind = $mod SHIFT, 3, movetoworkspace, 3
  bind = $mod SHIFT, 4, movetoworkspace, 4
  bind = $mod SHIFT, 5, movetoworkspace, 5
  bind = $mod SHIFT, 6, movetoworkspace, 6
  bind = $mod SHIFT, 7, movetoworkspace, 7
  bind = $mod SHIFT, 8, movetoworkspace, 8
  bind = $mod SHIFT, 9, movetoworkspace, 9
  bind = $mod SHIFT, 0, movetoworkspace, 10

  # Scroll through existing workspaces with mod + scroll
  bind = $mod, mouse_down, workspace, e+1
  bind = $mod, mouse_up, workspace, e-1

  # Move/resize windows with mod + LMB/RMB and dragging
  bindm = $mod, mouse:272, movewindow
  bindm = $mod, mouse:273, resizewindow

  bindl=,switch:on:Lid Switch,exec,systemctl suspend
''
