local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Keep module resolution local when testing with --config-file.
package.path = wezterm.config_dir .. "/?.lua;" .. package.path

-- Shells and font carried over from the previous Windows configuration.
config.default_prog = {
  "C:/Users/tatti/scoop/apps/pwsh/current/pwsh.exe", "-NoLogo",
}
config.launch_menu = {
  { label = "PowerShell 7", args = config.default_prog },
  { label = "Windows PowerShell", args = { "powershell.exe", "-NoLogo" } },
  {
    label = "Git Bash",
    args = { "C:/Users/tatti/scoop/apps/git/current/bin/bash.exe", "-l" },
  },
}
config.font = wezterm.font("UDEV Gothic NF")
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false

config.automatically_reload_config = true
config.font_size = 13.0
config.use_ime = true
-- Windows の Acrylic を透過・ぼかし背景として表示する
config.window_background_opacity = 0.7
config.win32_system_backdrop = "Acrylic"

----------------------------------------------------
-- Tab
----------------------------------------------------
-- タブバー右側に最小化・最大化・閉じるボタンを表示
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
-- タブバーの表示
config.show_tabs_in_tab_bar = true
-- ウィンドウ操作ボタンを保つため、タブが一つでも表示
config.hide_tab_bar_if_only_one_tab = false
-- falseにするとタブバーの透過が効かなくなる
-- config.use_fancy_tab_bar = false

-- タブバーの透過
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}

-- タブバーを背景色に合わせる
config.window_background_gradient = {
  colors = { "#000000" },
}

-- タブの追加ボタンを非表示
config.show_new_tab_button_in_tab_bar = false
-- タブの閉じるボタンを非表示
config.show_close_tab_button_in_tabs = false

-- タブ同士の境界線を非表示
config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
}

-- タブの形をカスタマイズ
-- タブの左側の装飾
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
-- タブの右側の装飾
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#FFFFFF"
  local edge_background = "none"
  if tab.is_active then
    background = "#ae8b2d"
    foreground = "#FFFFFF"
  end
  local edge_foreground = background
  local pane_title = tab.tab_title ~= "" and tab.tab_title or tab.active_pane.title
  local padding = max_width >= 8 and "   " or ""
  local title_width = math.max(0, max_width - 2 - 2 * #padding)
  local title = padding .. wezterm.truncate_right(pane_title, title_width) .. padding
  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

----------------------------------------------------
-- keybinds
----------------------------------------------------
config.disable_default_key_bindings = true
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables
config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 2000 }

return config
