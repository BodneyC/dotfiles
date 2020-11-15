local wezterm = require'wezterm'

return {
  -- Font config
  font_size = 10.0,
  font = wezterm.font("VictorMono Nerd Font"),
  -- font_rules = {
  --   {
  --     italic = true,
  --     font = wezterm.font("VictorMono Nerd Font Light Italic")
  --   },
  --   {
  --     italic = true,
  --     intensity = "Bold",
  --     font = wezterm.font("VictorMono Nerd Font Medium Italic")
  --   },
  --   {
  --     intensity = "Bold",
  --     font = wezterm.font("VictorMono Nerd Font Italic Regular")
  --   },
  --   {
  --     intensity = "Half",
  --     font = wezterm.font("VictorMono Nerd Font Medium")
  --   },
  -- },
  font_antialias = "Subpixel", -- None, Greyscale, Subpixel
  font_hinting = "Full",  -- None, Vertical, VerticalSubpixel, Full
  -- Screen config
  dpi = 96.0,
  bold_brightens_ansi_colors = true,
  -- System config
  send_composed_key_when_left_alt_is_pressed=false,
  send_composed_key_when_right_alt_is_pressed=true,
  term = "xterm-256color",
  scrollback_lines = 10000,
  enable_wayland = false,
  cursor_blink_rate = 800,
  default_cursor_style = "SteadyBar",
}
