return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    opts = {
      picker = {
        enabled = true,
        ui_select = false,
      },
      notifier = {enabled = true},
      indent = {
        enabled = true,
        scope = {
          enabled = true,
        },
        animate = {
          enabled = false,
        },
      },
    },

    keys = {
      {
        "<leader>sf",
        function()
          Snacks.picker.files()
        end,
        desc = "Snacks: ファイル検索",
      },
      {
        "<leader>sg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Snacks: 文字列検索",
      },
      {
        "<leader>sb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Snacks: バッファ検索",
      },
      {
        "<leader>sm",
        function()
          Snacks.scratch()
        end,
        desc = "Snacks: スクラッチメモ",
      },
      {
       "<leader>sl",
        function()
          Snacks.scratch.select()
       end,
       desc = "Snacks: スクラッチリスト",
      },
    },
  },
}
