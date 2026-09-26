local function set_background(highlights, groups, background)
  for _, group in ipairs(groups) do
    highlights[group].bg = background
  end
end

local function bufferline_highlights(defaults)
  local highlights = defaults.highlights
  local ui = require("kanagawa.colors").setup().theme.ui
  local inactive_bg = ui.bg_m3
  local visible_bg = ui.bg_m1
  local selected_bg = ui.bg_p1

  -- タブ本体だけを着色し、タブがない右側の余白は透過する。
  set_background(highlights, {
    "fill",
    "trunc_marker",
    "group_separator",
    "offset_separator",
  }, "none")

  highlights.background.bg = inactive_bg
  highlights.tab.bg = inactive_bg
  highlights.tab_close.bg = inactive_bg
  highlights.tab_selected.bg = selected_bg

  for _, group in ipairs({
    "buffer",
    "numbers",
    "diagnostic",
    "hint",
    "hint_diagnostic",
    "info",
    "info_diagnostic",
    "warning",
    "warning_diagnostic",
    "error",
    "error_diagnostic",
    "modified",
    "duplicate",
    "close_button",
    "pick",
  }) do
    highlights[group].bg = inactive_bg
    highlights[group .. "_visible"].bg = visible_bg
    highlights[group .. "_selected"].bg = selected_bg
  end

  -- 補色側の斜めグリフで、タブ背景だけを描き外側を透過する。
  for group, background in pairs({
    separator = inactive_bg,
    separator_visible = visible_bg,
    separator_selected = selected_bg,
    tab_separator = inactive_bg,
    tab_separator_selected = selected_bg,
  }) do
    highlights[group].fg = background
    highlights[group].bg = "none"
  end

  highlights.indicator_visible.bg = visible_bg
  highlights.indicator_selected.bg = selected_bg
  highlights.offset_separator.fg = ui.nontext

  return highlights
end

return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",

    -- VSCode Neovim では tabline を読み込まない
    cond = function()
      return not vim.g.vscode
    end,

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    opts = {
      highlights = bufferline_highlights,
      options = {
        mode = "buffers",
        -- 左右を逆向きに傾けた台形タブ。
        separator_style = "slant",
        indicator = {
          icon = "▎",
          style = "icon",
        },
        -- 各タブに丸囲みの閉じるボタンを表示する。
        buffer_close_icon = "󰅖",
        show_buffer_close_icons = true,
        show_close_icon = false,
        always_show_bufferline = true,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-tree",
            text_align = "left",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    },

    config = function(_, opts)
      -- 標準 slant の補色を使い、台形同士の間を透過する。
      require("bufferline.constants").sep_chars.slant = { "", "" }
      require("bufferline").setup(opts)

      -- slant が左斜辺の直後へ足す空白を除き、タブ本体へ接続する。
      local render_bufferline = _G.nvim_bufferline
      _G.nvim_bufferline = function()
        local rendered = render_bufferline()
        local connected = rendered:gsub("(%%#BufferLine[^#]*Separator[^#]*#) ", "%1")
        return connected
      end
    end,
  },
}
