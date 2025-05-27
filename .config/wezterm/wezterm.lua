local wezterm = require("wezterm")
local act = wezterm.action

local function is_vi_process(pane)
  return (pane:get_foreground_process_name() or ""):find("n?vim") ~= nil
end

local function conditional_activate_pane(window, pane, pane_direction, vim_direction)
  if is_vi_process(pane) then
    window:perform_action(act.SendKey({ key = vim_direction, mods = "ALT" }), pane)
  else
    window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
  end
end

for name, key in pairs({ right = "l", left = "h", up = "k", down = "j" }) do
  wezterm.on("ActivatePaneDirection-" .. name, function(window, pane)
    conditional_activate_pane(window, pane, name:gsub("^%l", string.upper), key)
  end)
end

-- local tab_selectors = {}
-- for i = 1, 8 do
--   table.insert(tab_selectors, {
--     key = tostring(i),
--     mods = 'CTRL|ALT',
--     action = act { ActivateTab = i - 1, },
--   })
-- end

local tab_movers = {}
for i = 1, 8 do
  -- CTRL+ALT + number to move to that position
  table.insert(tab_movers, {
    key = tostring(i),
    mods = "CTRL|ALT",
    action = wezterm.action.MoveTab(i - 1),
  })
end

wezterm.on('user-var-changed', function(window, pane, name, value)
  local overrides = window:get_config_overrides() or {}
  if name == "ZEN_MODE" then
    local incremental = value:find("+")
    local number_value = tonumber(value)
    if incremental ~= nil then
      while (number_value > 0) do
        window:perform_action(wezterm.action.IncreaseFontSize, pane)
        number_value = number_value - 1
      end
      overrides.enable_tab_bar = false
    elseif number_value < 0 then
      window:perform_action(wezterm.action.ResetFontSize, pane)
      overrides.font_size = nil
      overrides.enable_tab_bar = true
    else
      overrides.font_size = number_value
      overrides.enable_tab_bar = false
    end
  end
  window:set_config_overrides(overrides)
end)

local function font_with_fallback(name, params)
  local names = {
    name,
    "Iosevka Nerd Font",
    "Font Awesome 5 Free",
    "Font Awesome 5 Brands",
    "Hack Nerd Font",
  }
  return wezterm.font_with_fallback(names, params)
end

return {
  check_for_updates = false,

  -- Font config
  font_size = 14.0,
  font = font_with_fallback("Maple Mono", { weight = "Light" }),
  font_rules = {
    {
      italic = true,
      font = font_with_fallback("Maple Mono", {
        weight = "Light",
        italic = true,
      }),
    },
  },
  freetype_load_target = "Light",
  warn_about_missing_glyphs = false,
  quick_select_patterns = {
    "> (.*)",
  },

  -- Screen config
  line_height = 1.5,
  cell_width = 0.9,
  -- dpi = 96.0,
  bold_brightens_ansi_colors = true,
  alternate_buffer_wheel_scroll_speed = 0,
  -- System config
  audible_bell = "Disabled",
  send_composed_key_when_left_alt_is_pressed = false,
  send_composed_key_when_right_alt_is_pressed = true,
  term = "xterm-256color",
  scrollback_lines = 50000,
  enable_wayland = true,
  cursor_blink_rate = 800,
  default_cursor_style = "SteadyBar",
  window_padding = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 4,
  },

  -- Colors
  color_scheme = "kanagawa-wave",
  color_schemes = {
    nightfox = wezterm.color.load_scheme(os.getenv("HOME") .. "/.config/wezterm/schemes/nightfox.toml"),
    nordfox = wezterm.color.load_scheme(os.getenv("HOME") .. "/.config/wezterm/schemes/nordfox.toml"),
    carbonfox = wezterm.color.load_scheme(os.getenv("HOME") .. "/.config/wezterm/schemes/carbonfox.toml"),
    ['kanagawa-wave'] = wezterm.color.load_scheme(os.getenv("HOME") .. "/.config/wezterm/schemes/kanagawa.toml"),
    ['kanagawa-dragon'] = wezterm.color.load_scheme(os.getenv("HOME") .. "/.config/wezterm/schemes/kanagawa-dragon.toml"),
    oldworld = wezterm.color.load_scheme(os.getenv("HOME") .. "/.config/wezterm/schemes/oldworld.toml"),
  },

  -- tabbar
  enable_tab_bar = true,
  use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,
  tab_max_width = 80,

  -- bindings
  leader = { key = " ", mods = "CTRL" },
  keys = {
    { key = "v", mods = "CMD",      action = act.PasteFrom("Clipboard") },
    { key = "c", mods = "CMD",      action = act.CopyTo("Clipboard") },
    { key = "#", mods = "ALT",      action = act({ SendString = "#" }) },
    { key = "h", mods = "ALT",      action = act.EmitEvent("ActivatePaneDirection-left") },
    { key = "j", mods = "ALT",      action = act.EmitEvent("ActivatePaneDirection-down") },
    { key = "k", mods = "ALT",      action = act.EmitEvent("ActivatePaneDirection-up") },
    { key = "l", mods = "ALT",      action = act.EmitEvent("ActivatePaneDirection-right") },
    { key = "H", mods = "ALT",      action = act({ AdjustPaneSize = { "Left", 5 } }) },
    { key = "J", mods = "ALT",      action = act({ AdjustPaneSize = { "Down", 5 } }) },
    { key = "K", mods = "ALT",      action = act({ AdjustPaneSize = { "Up", 5 } }) },
    { key = "L", mods = "ALT",      action = act({ AdjustPaneSize = { "Right", 5 } }) },
    { key = "b", mods = "ALT",      action = act.RotatePanes 'CounterClockwise' },
    { key = "B", mods = "ALT",      action = act.RotatePanes 'Clockwise' },
    { key = "H", mods = "CTRL|ALT", action = act({ ActivatePaneDirection = "Left" }) },
    { key = "J", mods = "CTRL|ALT", action = act({ ActivatePaneDirection = "Down" }) },
    { key = "K", mods = "CTRL|ALT", action = act({ ActivatePaneDirection = "Up" }) },
    { key = "L", mods = "CTRL|ALT", action = act({ ActivatePaneDirection = "Right" }) },
    { key = "r", mods = "CTRL|ALT", action = wezterm.action.ReloadConfiguration },
    { key = "5", mods = "LEADER",   action = act({ SplitHorizontal = { args = { "zsh" } } }) },
    { key = "2", mods = "LEADER",   action = act({ SplitVertical = { args = { "zsh" } } }) },
    { key = "c", mods = "LEADER",   action = act({ SpawnCommandInNewTab = { cwd = wezterm.home_dir } }) },
    { key = "x", mods = "LEADER",   action = act({ CloseCurrentPane = { confirm = true } }) },
    { key = "X", mods = "LEADER",   action = act({ CloseCurrentTab = { confirm = true } }) },
    { key = "z", mods = "LEADER",   action = "TogglePaneZoomState" },
    { key = "/", mods = "CTRL",     action = act({ SendString = "" }) },

    -- table.unpack(tab_selectors),
    table.unpack(tab_movers),
  },
  mouse_bindings = {
    {
      event = { Down = { streak = 1, button = { WheelUp = 1 } } },
      mods = "NONE",
      action = act.ScrollByLine(-3),
      alt_screen = false,
    },
    {
      event = { Down = { streak = 1, button = { WheelDown = 1 } } },
      mods = "NONE",
      action = act.ScrollByLine(3),
      alt_screen = false,
    },
  },
  unix_domains = { { name = "unix" } },
}
