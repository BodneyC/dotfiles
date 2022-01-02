local wezterm = require 'wezterm'

local function font_with_fallback(name, params)
  local names = {
    name,
    'Font Awesome 5 Free',
    'Font Awesome 5 Brands',
    'Hack Nerd Font',
  }
  return wezterm.font_with_fallback(names, params)
end

do
  -- WARN: There is no way to control wezterm via the CLI, in other words,
  --  there cannot be a vim-wezterm-navigator plugins at the mo

  local NVIM_PATH = os.getenv('HOME') .. '/.local/bin/nvim'

  for k, v in pairs({
    l = 'Right',
    k = 'Up',
    j = 'Down',
    h = 'Left',
  }) do
    wezterm.on('pass-if-vim-M-' .. k, function(window, pane)
      if pane:get_foreground_process_name() == NVIM_PATH then
        print('IS VIM!')
        window:perform_action(wezterm.action {
          SendKey = {
            key = k,
            mods = 'ALT',
          },
        }, pane)
      else
        window:perform_action(wezterm.action {
          ActivatePaneDirection = v,
        }, pane)
      end
    end)
  end
end

local tab_selectors = {}
for i = 1, 8 do
  -- CTRL+ALT + number to activate that tab
  table.insert(tab_selectors, {
    key = tostring(i),
    mods = 'CTRL|ALT',
    action = wezterm.action {
      ActivateTab = i - 1,
    },
  })
end

return {
  -- Font config
  font_size = 16.0,
  font = font_with_fallback('Iosevka', {
    weight = 'Light',
  }),
  font_rules = {
    {
      italic = true,
      font = font_with_fallback('VictorMono Nerd Font', {
        weight = 'ExtraLight',
        italic = true,
      }),
    },
  },
  freetype_load_target = 'Light',
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
  window_padding = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 4,
  },
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
        '#313234',
        '#BF6262',
        '#A2A565',
        '#E9A96F',
        '#789BAD',
        '#9F7AA5',
        '#638E8A',
        '#E3E8E3',
      },
      brights = {
        '#313234',
        '#BF6262',
        '#A2A565',
        '#E9A96F',
        '#789BAD',
        '#9F7AA5',
        '#638E8A',
        '#E3E8E3',
      },
    },
  },
  -- tabbar
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  -- colors = {
  --   tab_bar = {
  --     background = '#0b0022',
  --     active_tab = {
  --       bg_color = '#2b2042',
  --       fg_color = '#c0c0c0',
  --       intensity = 'Normal',
  --       underline = 'None',
  --       italic = false,
  --       strikethrough = false,
  --     },
  --     inactive_tab = {
  --       bg_color = '#1b1032',
  --       fg_color = '#808080',
  --     },
  --     inactive_tab_hover = {
  --       bg_color = '#3b3052',
  --       fg_color = '#909090',
  --       italic = true,
  --     },
  --   },
  -- },
  -- bindings
  leader = {
    key = ' ',
    mods = 'CTRL',
  },
  keys = {
    {
      key = '5',
      mods = 'LEADER',
      action = wezterm.action {
        SplitHorizontal = {
          args = {'zsh'},
        },
      },
    },
    {
      key = '%',
      mods = 'LEADER',
      action = wezterm.action {
        SplitHorizontal = {
          args = {'zsh'},
        },
      },
    },
    {
      key = '2',
      mods = 'LEADER',
      action = wezterm.action {
        SplitVertical = {
          args = {'zsh'},
        },
      },
    },
    {
      key = '"',
      mods = 'LEADER',
      action = wezterm.action {
        SplitVertical = {
          args = {'zsh'},
        },
      },
    },
    {
      key = 'c',
      mods = 'LEADER',
      action = wezterm.action {
        SpawnCommandInNewTab = {
          args = {'zsh'},
        },
      },
    },
    {
      key = 'x',
      mods = 'LEADER',
      action = wezterm.action {
        CloseCurrentPane = {
          confirm = true,
        },
      },
    },
    {
      key = 'X',
      mods = 'LEADER',
      action = wezterm.action {
        CloseCurrentTab = {
          confirm = true,
        },
      },
    },
    {
      key = 'z',
      mods = 'LEADER',
      action = 'TogglePaneZoomState',
    },
    {
      key = 'h',
      mods = 'ALT',
      action = wezterm.action {
        EmitEvent = 'pass-if-vim-M-h',
      },
    },
    {
      key = 'j',
      mods = 'ALT',
      action = wezterm.action {
        EmitEvent = 'pass-if-vim-M-j',
      },
    },
    {
      key = 'k',
      mods = 'ALT',
      action = wezterm.action {
        EmitEvent = 'pass-if-vim-M-k',
      },
    },
    {
      key = 'l',
      mods = 'ALT',
      action = wezterm.action {
        EmitEvent = 'pass-if-vim-M-l',
      },
    },
    {
      key = 'H',
      mods = 'ALT',
      action = wezterm.action {
        ActivatePaneDirection = 'Left',
      },
    },
    {
      key = 'J',
      mods = 'ALT',
      action = wezterm.action {
        ActivatePaneDirection = 'Down',
      },
    },
    {
      key = 'K',
      mods = 'ALT',
      action = wezterm.action {
        ActivatePaneDirection = 'Up',
      },
    },
    {
      key = 'L',
      mods = 'ALT',
      action = wezterm.action {
        ActivatePaneDirection = 'Right',
      },
    },
    {
      key = 'H',
      mods = 'CTRL|ALT',
      action = wezterm.action {
        AdjustPaneSize = {'Left', 5},
      },
    },
    {
      key = 'J',
      mods = 'CTRL|ALT',
      action = wezterm.action {
        AdjustPaneSize = {'Down', 5},
      },
    },
    {
      key = 'K',
      mods = 'CTRL|ALT',
      action = wezterm.action {
        AdjustPaneSize = {'Up', 5},
      },
    },
    {
      key = 'L',
      mods = 'CTRL|ALT',
      action = wezterm.action {
        AdjustPaneSize = {'Right', 5},
      },
    },
    {
      key = '/',
      mods = 'CTRL',
      action = wezterm.action {
        SendString = '',
      },
    },
    table.unpack(tab_selectors),
  },
}
