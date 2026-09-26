return {
  {
    "rebelot/kanagawa.nvim",
    --enabled = false,

    -- 起動時に読み込む
    lazy = false,

    -- 他のプラグインより先に読み込む
    priority = 1000,

    opts = {
      -- wave / dragon / lotus
      theme = "wave",

      -- WezTerm の背景を表示しつつ、Kanagawa の前景色を維持する
      transparent = true,
      terminalColors = true,

      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },

      -- フローティングウィンドウも端末背景になじませる
      overrides = function()
        return {
          NormalFloat = { bg = "none" },
          FloatBorder = { bg = "none" },
          FloatTitle = { bg = "none" },
          -- Kanagawa が設定するタブの未使用領域も透過する
          TabLineFill = { bg = "none" },
        }
      end,

      background = {
        dark = "wave",
        light = "lotus",
      },
    },

    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd("colorscheme kanagawa")
    end,
  },
}
