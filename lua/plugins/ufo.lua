return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
  },
  config = function()
    vim.opt.foldcolumn = "1"
    vim.opt.fillchars:append({ foldinner = "│" })
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
    vim.opt.foldenable = true

    local ufo = require("ufo")

    vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "すべてのfoldを開く" })
    vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "すべてのfoldを閉じる" })

    ufo.setup({
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    })
  end,
}
