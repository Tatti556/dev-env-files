return {
  "saghen/blink.cmp",
  version = "1.*",

  ---@module "blink.cmp"
  ---@type blink.cmp.Config
  opts = {
    -- Neovim標準の補完操作に近いキーマップを使用する。
    keymap = { preset = "default" },

    -- LSPにはobsidian.nvim内蔵のobsidian-lsも含まれる。
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    -- Rust版が利用できない環境ではLua版へフォールバックする。
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },

  opts_extend = { "sources.default" },
}
