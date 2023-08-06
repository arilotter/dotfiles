theme: ''
  window:
    padding:
      x: 2
      y: 2

    dynamic_padding: false

    decorations: full

  scrolling:
    # Maximum number of lines in the scrollback buffer.
    # Specifying '0' will disable scrolling.
    history: 10000

    # Number of lines the viewport will move for every line scrolled when
    # scrollback is enabled (history > 0).
    multiplier: 3


  # Font configuration (changes require restart)
  font:
    # Normal (roman) font face
    normal:
      # Font family
      #
      # Default:
      #   - (macOS) Menlo
      #   - (Linux) monospace
      #   - (Windows) Consolas
      family: FiraCode Nerd Font
      # family: Tewi
      # The `style` can be specified to pick a specific face.
      #style: Regular

    # Bold font face
    #bold:
    # Font family
    #
    # If the bold family is not specified, it will fall back to the
    # value specified for the normal font.
    #family: monospace

    # The `style` can be specified to pick a specific face.
    #style: Bold

    # Italic font face
    #italic:
    # Font family
    #
    # If the italic family is not specified, it will fall back to the
    # value specified for the normal font.
    #family: monospace

    # The `style` can be specified to pick a specific face.
    #style: Italic

    # Point size
    size: 8.0

    # Offset is the extra space around each character. `offset.y` can be thought of
    # as modifying the line spacing, and `offset.x` as modifying the letter spacing.
    offset:
      x: 0
      y: 0

    # Glyph offset determines the locations of the glyphs within their cells with
    # the default being at the bottom. Increasing `x` moves the glyph to the right,
    # increasing `y` moves the glyph upwards.
    glyph_offset:
      x: 0
      y: 0


  # Display the time it takes to redraw each frame.
  # render_timer: false

  # Keep the log file after quitting Alacritty.
  # persistent_logging: false

  # If `true`, bold text is drawn using the bright color variants.
  draw_bold_text_with_bright_colors: true

  # Colors (Tomorrow Night Bright)
  colors:
    # Default colors
    primary:
      foreground: "${theme.zerox.foreground}"
      background: "${theme.zerox.background}"

      # Normal colors
      normal:
        black: "${theme.zerox.black}"
        red: "${theme.zerox.red}"
        green: "${theme.zerox.green}"
        yellow: "${theme.zerox.yellow}"
        blue: "${theme.zerox.blue}"
        magenta: "${theme.zerox.magenta}"
        cyan: "${theme.zerox.cyan}"
        white: "${theme.zerox.white}"

      # Bright colors
      bright:
        black: "${theme.zerox.brightblack}"
        red: "${theme.zerox.brightred}"
        green: "${theme.zerox.brightgreen}"
        yellow: "${theme.zerox.brightyellow}"
        blue: "${theme.zerox.brightblue}"
        magenta: "${theme.zerox.brightmagenta}"
        cyan: "${theme.zerox.brightcyan}"
        white: "${theme.zerox.brightwhite}"

      visual_bell:
        animation: EaseOutExpo
        duration: 0
        color: "0xffffff"

      background_opacity: 1.0

      mouse_bindings:
        - { mouse: Middle, action: PasteSelection }

      mouse:
        double_click: { threshold: 300 }
        triple_click: { threshold: 300 }

        hide_when_typing: false

        url:
          modifiers: None

      selection:
        # When set to `true`, selected text will be copied to the primary clipboard.
        save_to_clipboard: false

      # Allow terminal applications to change Alacritty's window title.
      dynamic_title: true

      cursor:
        # Cursor style
        #
        # Values for `style`:
        #   - ▇ Block
        #   - _ Underline
        #   - | Beam
        style: Block

        # If this is `true`, the cursor will be rendered as a hollow box when the
        # window is not focused.
        unfocused_hollow: true

      live_config_reload: true

      # Send ESC (\x1b) before characters when alt is pressed.
      alt_send_esc: true

      key_bindings:
        - { key: Paste, action: Paste }
        - { key: Copy, action: Copy }
        - { key: L, mods: Control, action: ClearLogNotice }
        - { key: L, mods: Control, chars: "\x0c" }
        - { key: Home, chars: "\x1bOH", mode: AppCursor }
        - { key: Home, chars: "\x1b[H", mode: ~AppCursor }
        - { key: End, chars: "\x1bOF", mode: AppCursor }
        - { key: End, chars: "\x1b[F", mode: ~AppCursor }
        - { key: PageUp, mods: Shift, action: ScrollPageUp, mode: ~Alt }
        - { key: PageUp, mods: Shift, chars: "\x1b[5;2~", mode: Alt }
        - { key: PageUp, mods: Control, chars: "\x1b[5;5~" }
        - { key: PageUp, chars: "\x1b[5~" }
        - { key: PageDown, mods: Shift, action: ScrollPageDown, mode: ~Alt }
        - { key: PageDown, mods: Shift, chars: "\x1b[6;2~", mode: Alt }
        - { key: PageDown, mods: Control, chars: "\x1b[6;5~" }
        - { key: PageDown, chars: "\x1b[6~" }
        - { key: Tab, mods: Shift, chars: "\x1b[Z" }
        - { key: Back, chars: "\x7f" }
        - { key: Back, mods: Alt, chars: "\x1b\x7f" }
        - { key: Insert, chars: "\x1b[2~" }
        - { key: Delete, chars: "\x1b[3~" }
        - { key: Left, mods: Shift, chars: "\x1b[1;2D" }
        - { key: Left, mods: Control, chars: "\x1b[1;5D" }
        - { key: Left, mods: Alt, chars: "\x1b[1;3D" }
        - { key: Left, chars: "\x1b[D", mode: ~AppCursor }
        - { key: Left, chars: "\x1bOD", mode: AppCursor }
        - { key: Right, mods: Shift, chars: "\x1b[1;2C" }
        - { key: Right, mods: Control, chars: "\x1b[1;5C" }
        - { key: Right, mods: Alt, chars: "\x1b[1;3C" }
        - { key: Right, chars: "\x1b[C", mode: ~AppCursor }
        - { key: Right, chars: "\x1bOC", mode: AppCursor }
        - { key: Up, mods: Shift, chars: "\x1b[1;2A" }
        - { key: Up, mods: Control, chars: "\x1b[1;5A" }
        - { key: Up, mods: Alt, chars: "\x1b[1;3A" }
        - { key: Up, chars: "\x1b[A", mode: ~AppCursor }
        - { key: Up, chars: "\x1bOA", mode: AppCursor }
        - { key: Down, mods: Shift, chars: "\x1b[1;2B" }
        - { key: Down, mods: Control, chars: "\x1b[1;5B" }
        - { key: Down, mods: Alt, chars: "\x1b[1;3B" }
        - { key: Down, chars: "\x1b[B", mode: ~AppCursor }
        - { key: Down, chars: "\x1bOB", mode: AppCursor }
        - { key: F1, chars: "\x1bOP" }
        - { key: F2, chars: "\x1bOQ" }
        - { key: F3, chars: "\x1bOR" }
        - { key: F4, chars: "\x1bOS" }
        - { key: F5, chars: "\x1b[15~" }
        - { key: F6, chars: "\x1b[17~" }
        - { key: F7, chars: "\x1b[18~" }
        - { key: F8, chars: "\x1b[19~" }
        - { key: F9, chars: "\x1b[20~" }
        - { key: F10, chars: "\x1b[21~" }
        - { key: F11, chars: "\x1b[23~" }
        - { key: F12, chars: "\x1b[24~" }
        - { key: F1, mods: Shift, chars: "\x1b[1;2P" }
        - { key: F2, mods: Shift, chars: "\x1b[1;2Q" }
        - { key: F3, mods: Shift, chars: "\x1b[1;2R" }
        - { key: F4, mods: Shift, chars: "\x1b[1;2S" }
        - { key: F5, mods: Shift, chars: "\x1b[15;2~" }
        - { key: F6, mods: Shift, chars: "\x1b[17;2~" }
        - { key: F7, mods: Shift, chars: "\x1b[18;2~" }
        - { key: F8, mods: Shift, chars: "\x1b[19;2~" }
        - { key: F9, mods: Shift, chars: "\x1b[20;2~" }
        - { key: F10, mods: Shift, chars: "\x1b[21;2~" }
        - { key: F11, mods: Shift, chars: "\x1b[23;2~" }
        - { key: F12, mods: Shift, chars: "\x1b[24;2~" }
        - { key: F1, mods: Control, chars: "\x1b[1;5P" }
        - { key: F2, mods: Control, chars: "\x1b[1;5Q" }
        - { key: F3, mods: Control, chars: "\x1b[1;5R" }
        - { key: F4, mods: Control, chars: "\x1b[1;5S" }
        - { key: F5, mods: Control, chars: "\x1b[15;5~" }
        - { key: F6, mods: Control, chars: "\x1b[17;5~" }
        - { key: F7, mods: Control, chars: "\x1b[18;5~" }
        - { key: F8, mods: Control, chars: "\x1b[19;5~" }
        - { key: F9, mods: Control, chars: "\x1b[20;5~" }
        - { key: F10, mods: Control, chars: "\x1b[21;5~" }
        - { key: F11, mods: Control, chars: "\x1b[23;5~" }
        - { key: F12, mods: Control, chars: "\x1b[24;5~" }
        - { key: F1, mods: Alt, chars: "\x1b[1;6P" }
        - { key: F2, mods: Alt, chars: "\x1b[1;6Q" }
        - { key: F3, mods: Alt, chars: "\x1b[1;6R" }
        - { key: F4, mods: Alt, chars: "\x1b[1;6S" }
        - { key: F5, mods: Alt, chars: "\x1b[15;6~" }
        - { key: F6, mods: Alt, chars: "\x1b[17;6~" }
        - { key: F7, mods: Alt, chars: "\x1b[18;6~" }
        - { key: F8, mods: Alt, chars: "\x1b[19;6~" }
        - { key: F9, mods: Alt, chars: "\x1b[20;6~" }
        - { key: F10, mods: Alt, chars: "\x1b[21;6~" }
        - { key: F11, mods: Alt, chars: "\x1b[23;6~" }
        - { key: F12, mods: Alt, chars: "\x1b[24;6~" }
        - { key: F1, mods: Super, chars: "\x1b[1;3P" }
        - { key: F2, mods: Super, chars: "\x1b[1;3Q" }
        - { key: F3, mods: Super, chars: "\x1b[1;3R" }
        - { key: F4, mods: Super, chars: "\x1b[1;3S" }
        - { key: F5, mods: Super, chars: "\x1b[15;3~" }
        - { key: F6, mods: Super, chars: "\x1b[17;3~" }
        - { key: F7, mods: Super, chars: "\x1b[18;3~" }
        - { key: F8, mods: Super, chars: "\x1b[19;3~" }
        - { key: F9, mods: Super, chars: "\x1b[20;3~" }
        - { key: F10, mods: Super, chars: "\x1b[21;3~" }
        - { key: F11, mods: Super, chars: "\x1b[23;3~" }
        - { key: F12, mods: Super, chars: "\x1b[24;3~" }
        - { key: NumpadEnter, chars: "\n" }
''
