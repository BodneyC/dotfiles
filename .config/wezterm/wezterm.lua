local wezterm = require 'wezterm'
local act = wezterm.action

local function is_vi_process(pane)
  -- get_foreground_process_name On Linux, macOS and Windows,
  -- the process can be queried to determine this path. Other operating systems
  -- (notably, FreeBSD and other unix systems) are not currently supported
  return pane:get_foreground_process_name():find('n?vim') ~= nil
  -- return pane:get_title():find("n?vim") ~= nil
end

local function conditional_activate_pane(window, pane, pane_direction, vim_direction)
  if is_vi_process(pane) then
    window:perform_action(
    -- This should match the keybinds you set in Neovim.
      act.SendKey({ key = vim_direction, mods = 'ALT' }),
      pane
    )
  else
    window:perform_action(act.ActivatePaneDirection(pane_direction), pane)
  end
end

wezterm.on('ActivatePaneDirection-right', function(window, pane)
  conditional_activate_pane(window, pane, 'Right', 'l')
end)
wezterm.on('ActivatePaneDirection-left', function(window, pane)
  conditional_activate_pane(window, pane, 'Left', 'h')
end)
wezterm.on('ActivatePaneDirection-up', function(window, pane)
  conditional_activate_pane(window, pane, 'Up', 'k')
end)
wezterm.on('ActivatePaneDirection-down', function(window, pane)
  conditional_activate_pane(window, pane, 'Down', 'j')
end)

local tab_selectors = {}
for i = 1, 8 do
  -- CTRL+ALT + number to activate that tab
  table.insert(tab_selectors, {
    key = tostring(i),
    mods = 'CTRL|ALT',
    action = act {
      ActivateTab = i - 1,
    },
  })
end

local function font_with_fallback(name, params)
  local names = {
    name,
    'Font Awesome 5 Free',
    'Font Awesome 5 Brands',
    'Hack Nerd Font',
  }
  return wezterm.font_with_fallback(names, params)
end

return {
  -- Font config
  font_size = 14.0,
  font = font_with_fallback('Iosevka Nerd Font', {
    weight = 'Regular',
  }),
  font_rules = {
    -- {
    --   italic = true,
    --   font = font_with_fallback('Victor Mono Nerd Font', {
    --     italic = true,
    --   }),
    -- },
  },
  freetype_load_target = 'Light',
  -- Screen config
  line_height = 1.2,
  -- dpi = 96.0,
  bold_brightens_ansi_colors = true,
  alternate_buffer_wheel_scroll_speed = 0,
  -- System config
  audible_bell = 'Disabled',
  send_composed_key_when_left_alt_is_pressed = false,
  send_composed_key_when_right_alt_is_pressed = true,
  term = 'xterm-256color',
  scrollback_lines = 10000,
  enable_wayland = true,
  cursor_blink_rate = 800,
  default_cursor_style = 'SteadyBar',
  window_padding = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 4,
  },

  -- Colors
  color_scheme = 'nightfox',
  color_schemes = {
    nightfox = wezterm.color.load_scheme(os.getenv('HOME') .. '/.config/wezterm/schemes/nightfox.toml'),
  },

  -- tabbar
  enable_tab_bar = true,
  use_fancy_tab_bar = false,
  hide_tab_bar_if_only_one_tab = true,

  -- bindings
  leader = { key = ' ', mods = 'CTRL', },
  keys = {
    { key = 'h', mods = 'ALT',      action = act.EmitEvent('ActivatePaneDirection-left') },
    { key = 'j', mods = 'ALT',      action = act.EmitEvent('ActivatePaneDirection-down') },
    { key = 'k', mods = 'ALT',      action = act.EmitEvent('ActivatePaneDirection-up') },
    { key = 'l', mods = 'ALT',      action = act.EmitEvent('ActivatePaneDirection-right') },
    { key = 'H', mods = 'ALT',      action = act { AdjustPaneSize = { 'Left', 5 } } },
    { key = 'J', mods = 'ALT',      action = act { AdjustPaneSize = { 'Down', 5 } } },
    { key = 'K', mods = 'ALT',      action = act { AdjustPaneSize = { 'Up', 5 } } },
    { key = 'L', mods = 'ALT',      action = act { AdjustPaneSize = { 'Right', 5 } } },
    { key = 'H', mods = 'CTRL|ALT', action = act { ActivatePaneDirection = 'Left', } },
    { key = 'J', mods = 'CTRL|ALT', action = act { ActivatePaneDirection = 'Down', } },
    { key = 'K', mods = 'CTRL|ALT', action = act { ActivatePaneDirection = 'Up', } },
    { key = 'L', mods = 'CTRL|ALT', action = act { ActivatePaneDirection = 'Right', } },
    { key = '5', mods = 'LEADER',   action = act { SplitHorizontal = { args = { 'zsh' } } } },
    { key = '2', mods = 'LEADER',   action = act { SplitVertical = { args = { 'zsh' } } } },
    { key = 'c', mods = 'LEADER',   action = act { SpawnCommandInNewTab = { args = { 'zsh' } } } },
    { key = 'x', mods = 'LEADER',   action = act { CloseCurrentPane = { confirm = true, } } },
    { key = 'X', mods = 'LEADER',   action = act { CloseCurrentTab = { confirm = true, } } },
    { key = 'z', mods = 'LEADER',   action = 'TogglePaneZoomState', },
    { key = '/', mods = 'CTRL',     action = act { SendString = '', } },
    table.unpack(tab_selectors),
  },
  unix_domains = { { name = "unix" } }
}
