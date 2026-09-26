return {
  {
    "craftzdog/solarized-osaka.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,

    opts = {
      -- WezTerm の背景を透過したまま Solarized Osaka の配色を使う
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },

      -- フローティングウィンドウと winbar の前景色は維持し、背景だけ透過する
      on_highlights = function(highlights)
        for _, group in ipairs({
          "NormalFloat",
          "FloatBorder",
          "FloatTitle",
          "WinBar",
          "WinBarNC",
          "TabLine",
          "TabLineFill",
          "TabLineSel",
        }) do
          local current = type(highlights[group]) == "table" and highlights[group] or {}
          highlights[group] = vim.tbl_extend("force", current, {
            bg = "none",
          })
        end
      end,
    },

    config = function(_, opts)
      require("solarized-osaka").setup(opts)
      vim.cmd.colorscheme("solarized-osaka")
    end,
  },
}
