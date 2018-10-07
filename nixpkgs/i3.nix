{ pkgs, ... }:
  let theme = import ./theme.nix;
  ws = {
    _1 = "1";
    _2 = "2";
    _3 = "3";
    _4 = "4";
    _5 = "5";
    _6 = "6";
    _7 = "7";
    _8 = "8";
    _9 = "9";
    _10 = "10";
  };
  mod = "Mod4";
in
{
  enable = true;
  package = pkgs.i3-gaps;
  config = {
    modifier = mod;
    keybindings = {
      "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +3%";
      "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -3%";
      "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle # mute sound";
      "XF86MonBrightnessUp" = "exec --no-startup-id light -A 10";
      "XF86MonBrightnessDown" = "exec --no-startup-id light -U 10";
      "${mod}+Return" = "exec kitty";

      "${mod}+Shift+q" = "kill";

      "${mod}+z" = "exec --no-startup-id exec i3zen";

      "${mod}+d" = "exec rofi -modi drun -show drun -display-drun \"\" -show-icons ";
      "${mod}+Shift+d" = "exec rofi -show window";
      "${mod}+Shift+f" = "exec rofi -show emoji -modi emoji";

      "${mod}+j" = "focus left";
      "${mod}+k" = "focus down";
      "${mod}+l" = "focus up";
      "${mod}+semicolon" = "focus right";

      "${mod}+Left" = "focus left";
      "${mod}+Down" = "focus down";
      "${mod}+Up" = "focus up";
      "${mod}+Right" = "focus right";

      "${mod}+Shift+j" = "move left";
      "${mod}+Shift+k" = "move down";
      "${mod}+Shift+l" = "move up";
      "${mod}+Shift+semicolon" = "move right";

      "${mod}+Shift+Left" = "move left";
      "${mod}+Shift+Down" = "move down";
      "${mod}+Shift+Up" = "move up";
      "${mod}+Shift+Right" = "move right";

      "${mod}+h" = "split h";
      "${mod}+v" = "split v";
      "${mod}+f" = "fullscreen toggle";

      "${mod}+s" = "layout stacking";
      "${mod}+w" = "layout tabbed";
      "${mod}+e" = "layout toggle split";

      "${mod}+Shift+space" = "floating toggle";

      "${mod}+space" = "focus mode_toggle";

      "${mod}+a" = "focus parent";

      #"${mod}+d" = "focus child";

      "Mod1+Tab" = "workspace next";
      "Mod1+Shift+Tab" = "workspace prev";

      # switch to workspace
      "${mod}+1" = "workspace ${ws._1}";
      "${mod}+2" = "workspace ${ws._2}";
      "${mod}+3" = "workspace ${ws._3}";
      "${mod}+4" = "workspace ${ws._4}";
      "${mod}+5" = "workspace ${ws._5}";
      "${mod}+6" = "workspace ${ws._6}";
      "${mod}+7" = "workspace ${ws._7}";
      "${mod}+8" = "workspace ${ws._8}";
      "${mod}+9" = "workspace ${ws._9}";
      "${mod}+0" = "workspace ${ws._10}";

      # move focused container to workspace
      "${mod}+Shift+1" = "move container to workspace ${ws._1}";
      "${mod}+Shift+2" = "move container to workspace ${ws._2}";
      "${mod}+Shift+3" = "move container to workspace ${ws._3}";
      "${mod}+Shift+4" = "move container to workspace ${ws._4}";
      "${mod}+Shift+5" = "move container to workspace ${ws._5}";
      "${mod}+Shift+6" = "move container to workspace ${ws._6}";
      "${mod}+Shift+7" = "move container to workspace ${ws._7}";
      "${mod}+Shift+8" = "move container to workspace ${ws._8}";
      "${mod}+Shift+9" = "move container to workspace ${ws._9}";
      "${mod}+Shift+0" = "move container to workspace ${ws._10}";

      # reload the configuration file
      "${mod}+Shift+c" = "reload";

      # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
      "${mod}+Shift+r" = "restart";

      # exit i3 (logs you out of your X session)
      "${mod}+Shift+e" = "exec \"i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'\"";
      
      "${mod}+r" = "mode resize";

    };
    colors = with theme; {
      background = hex.background;
      focused = {
        border = hex.background;
        background = hex.background;
        text = hex.foreground;
        indicator = hex.background;
        childBorder = hex.foreground;
      };
      focusedInactive = {
        border = hex.background;
        background = hex.background;
        text = hex.foreground;
        indicator = hex.background;
        childBorder = hex.background;
      };
      unfocused = {
        border = hex.background;
        background = hex.background;
        text = hex.foreground;
        indicator = hex.background;
        childBorder = hex.background;
      };
      urgent = {
        border = hex.background;
        background = hex.background;
        text = hex.foreground;
        indicator = hex.background;
        childBorder = hex.background;
      };
      placeholder = {
        border = hex.background;
        background = hex.background;
        text = hex.foreground;
        indicator = hex.background;
        childBorder = hex.background;
      };
    };
    bars = [{
      fonts = [ "FuraCode Nerd Font 12" ];
      position = "bottom";
      statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.cache/wal/i3status-rs.toml";
      colors = with theme; {
        background = hex.background;
        statusline = hex.foreground;
        separator = hex.foreground;
        focusedWorkspace = { border = hex.color4; background = hex.foreground; text = hex.background; };
        activeWorkspace = { border = hex.color4; background = hex.background; text = hex.foreground; };
        inactiveWorkspace = { border = hex.black; background = hex.black; text = hex.foreground; };
        urgentWorkspace = { border = hex.red; background = hex.red; text = hex.black; };
      };
    }];
    window = {
      border = 4;
    };
    floating = {
      criteria = [ {"window_type"="dialog"; } { "window_type"="menu"; } ];
    };
  };
}