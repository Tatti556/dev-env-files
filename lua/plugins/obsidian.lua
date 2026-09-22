
return {
  "obsidian-nvim/obsidian.nvim",

  -- 安定版を使用
  version = "*",

  -- VSCode Neovim上では無効化
  enabled = not vim.g.vscode,

  opts = {
    -- 新形式のコマンドを使用
    legacy_commands = false,

    ----------------------------------------
    -- Vault
    ----------------------------------------

    workspaces = {
      {
        name = "personal",
        path = "C:/Users/tatti/Documents/Obsidan_DATA/2607_vault",
      },
    },

    ----------------------------------------
    -- 新規ノート
    ----------------------------------------

    -- 新規ノートの保存先
    notes_subdir = "000_inbox",
    new_notes_location = "notes_subdir",

    -- タイトルを基にファイル名を生成
    note_id_func = function(title, dir)
      return require("obsidian.builtin").title_id(title, dir)
    end,

    -- 通常ノートには既定テンプレートを適用しない
    note = {
      template = vim.NIL,
    },

    ----------------------------------------
    -- テンプレート
    ----------------------------------------

    templates = {
      enabled = true,

      -- Vault内のテンプレート保存先
      folder = "999_template",

      -- テンプレートの日付・時刻形式
      date_format = "YYYY-MM-DD",
      time_format = "HH:mm",
    },

    ----------------------------------------
    -- デイリーノート
    ----------------------------------------

    daily_notes = {
      enabled = true,

      -- デイリーノートのルートフォルダ
      folder = "001_DailyNotes",

      -- 年 / 年月 / 年月日.md
      -- 例：2026/2026-09/2026-09-22.md
      date_format = "YYYY/YYYY-MM/YYYY-MM-DD",

      -- デイリーノートの別名
      alias_format = "YYYY-MM-DD",

      -- 添付されたデイリーノート用テンプレート
      template = "daily-temp_v2_tasks.md",

      -- タグはテンプレートのYAMLで管理
      default_tags = {},

      -- 土日もデイリーノートの対象にする
      workdays_only = false,

      -- 週の開始を日曜日に設定
      start_of_week = 0,
    },

    ----------------------------------------
    -- 検索
    ----------------------------------------

    picker = {
      name = "telescope.nvim",
    },

    ----------------------------------------
    -- 同期
    ----------------------------------------

    -- 公式Obsidian Syncは使用しない
    sync = {
      enabled = false,
    },
  },
}

