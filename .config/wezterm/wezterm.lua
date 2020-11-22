local wezterm = require 'wezterm'

function font_with_fallback(name, params)
  local names = {name, 'Font Awesome 5 Free', 'Font Awesome 5 Brands', 'Hack Nerd Font'}
  return wezterm.font_with_fallback(names, params)
end

local tab_selectors = {}
for i = 1, 8 do
  -- CTRL+ALT + number to activate that tab
  table.insert(tab_selectors, {
    key = tostring(i),
    mods = 'CTRL|ALT',
    action = wezterm.action {ActivateTab = i - 1},
  })
end

wezterm.on('feed-keys-if-vim', function(window, pane)
  local cmd = 'ps -o state= -o comm= -t \'' .. pane:pane_id() .. '\''
  local handle = io.popen(cmd)
  local result = handle:read('*a')
  if string.find(result, 'vim') then
    window:perform_action(wezterm.action {SendString = '\x1bl'})
  else
    window:perform_action(wezterm.action {ActivatePaneDirection = 'Right'})
  end
end)

return {
  -- Font config
  font_size = 16.0,
  font = font_with_fallback('VictorMono Nerd Font'),
  font_antialias = 'Subpixel',
  font_hinting = 'Full',
  -- Screen config
  dpi = 96.0,
  bold_brightens_ansi_colors = true,
  -- System config
  send_composed_key_when_left_alt_is_pressed = false,
  send_composed_key_when_right_alt_is_pressed = true,
  term = 'xterm-256color',
  scrollback_lines = 10000,
  enable_wayland = false,
  cursor_blink_rate = 800,
  default_cursor_style = 'SteadyBar',
  window_padding = {left = 4, right = 4, top = 4, bottom = 4},
  -- Colors
  color_scheme = 'spacegray',
  color_schemes = {
    spacegray = {
      foreground = '#B3B8C4',
      background = '#111314',
      cursor_bg = '#52ad70',
      cursor_fg = 'black',
      cursor_border = '#52ad70',
      scrollbar_thumb = '#222222',
      split = '#444444',
      ansi = {
        '#313234', '#BF6262', '#A2A565', '#E9A96F', '#789BAD', '#9F7AA5', '#638E8A',
        '#E3E8E3',
      },
      brights = {
        '#313234', '#BF6262', '#A2A565', '#E9A96F', '#789BAD', '#9F7AA5', '#638E8A',
        '#E3E8E3',
      },
    },
  },
  -- tabbar
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  colors = {
    tab_bar = {
      background = '#0b0022',
      active_tab = {
        bg_color = '#2b2042',
        fg_color = '#c0c0c0',
        intensity = 'Normal',
        underline = 'None',
        italic = false,
        strikethrough = false,
      },
      inactive_tab = {bg_color = '#1b1032', fg_color = '#808080'},
      inactive_tab_hover = {bg_color = '#3b3052', fg_color = '#909090', italic = true},
    },
  },
  -- bindings
  leader = {key = ' ', mods = 'CTRL'},
  keys = {
    {
      key = '5',
      mods = 'LEADER',
      action = wezterm.action {SplitHorizontal = {args = {'zsh'}}},
    }, {
      key = '%',
      mods = 'SHIFT|LEADER',
      action = wezterm.action {SplitHorizontal = {args = {'zsh'}}},
    },
    {
      key = '2',
      mods = 'LEADER',
      action = wezterm.action {SplitVertical = {args = {'zsh'}}},
    }, {
      key = '"',
      mods = 'SHIFT|LEADER',
      action = wezterm.action {SplitVertical = {args = {'zsh'}}},
    }, {
      key = 'c',
      mods = 'LEADER',
      action = wezterm.action {SpawnCommandInNewTab = {args = {'zsh'}}},
    }, {
      key = 'x',
      mods = 'LEADER',
      action = wezterm.action {CloseCurrentPane = {confirm = true}},
    }, {
      key = 'X',
      mods = 'LEADER',
      action = wezterm.action {CloseCurrentTab = {confirm = true}},
    }, {key = 'z', mods = 'LEADER', action = 'TogglePaneZoomState'},
    {key = 'H', mods = 'ALT', action = wezterm.action {ActivatePaneDirection = 'Left'}},
    {key = 'J', mods = 'ALT', action = wezterm.action {ActivatePaneDirection = 'Down'}},
    {key = 'K', mods = 'ALT', action = wezterm.action {ActivatePaneDirection = 'Up'}},
    {key = 'L', mods = 'ALT', action = wezterm.action {ActivatePaneDirection = 'Right'}},
    {key = 'H', mods = 'CTRL|ALT', action = wezterm.action {AdjustPaneSize = {'Left', 5}}},
    {key = 'J', mods = 'CTRL|ALT', action = wezterm.action {AdjustPaneSize = {'Down', 5}}},
    {key = 'K', mods = 'CTRL|ALT', action = wezterm.action {AdjustPaneSize = {'Up', 5}}},
    {
      key = 'L',
      mods = 'CTRL|ALT',
      action = wezterm.action {AdjustPaneSize = {'Right', 5}},
    }, {key = '/', mods = 'CTRL', action = wezterm.action {SendString = ''}},
    table.unpack(tab_selectors),
  },
}
