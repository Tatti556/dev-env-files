
return {
  {
    "stevearc/oil.nvim",

    -- VSCode NeovimではOilを使わない
    cond = not vim.g.vscode,

    -- コマンドまたはキーマップ使用時に読み込む
    cmd = { "Oil" },

    -- ファイルアイコン表示用
    dependencies = {
      {
        "nvim-mini/mini.icons",
        opts = {},
      },
    },

    opts = {
      -- ディレクトリを開いたとき、Oilを使う
      default_file_explorer = true,

      -- 表示する列
      columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
      },

      -- 隠しファイルも表示する
      view_options = {
        show_hidden = true,
      },

      keymaps = {
        -- ウィンドウ移動キーとの競合を回避
        ["<C-h>"] = false,
        ["<C-l>"] = false,

        -- 垂直分割で開く
        ["<leader>sv"] = {
          "actions.select",
          opts = {
            vertical = true,
          },
          desc = "垂直分割で開く",
        },

        -- 水平分割で開く
        ["<leader>sh"] = {
          "actions.select",
          opts = {
            horizontal = true,
          },
          desc = "水平分割で開く",
        },
      },
    },

    keys = {
      {
        "<leader>e",
        "<cmd>Oil<cr>",
        desc = "Oilを開く",
      },
      {
        "-",
        "<cmd>Oil<cr>",
        desc = "親ディレクトリを開く",
      },
    },
  },
}
