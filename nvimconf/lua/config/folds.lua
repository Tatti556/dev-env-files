
-- Markdownのheaderによる開閉 (案A: Treesitter expr fold)
-- init.lua の通常Neovim分岐からのみ読み込むこと。
-- VSCode-NeovimではVSCode側がfoldを所有するため読み込まない。

vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end,
  desc = "MarkdownはTreesitterでheader単位にfoldする",
})
