
local map = vim.keymap.set

vim.g.mapleader = " "

map("n", "<Esc>", "<cmd>nohlsearch<CR>", {
  desc = "検索ハイライトを消す",
})

map("n", "<leader>w", "<cmd>write<CR>", {
  desc = "保存",
})

map("n", "<leader>q", "<cmd>quit<CR>", {
  desc = "終了",
})

map("n", "<C-h>", "<C-w>h", { desc = "左のウィンドウへ" })
map("n", "<C-j>", "<C-w>j", { desc = "下のウィンドウへ" })
map("n", "<C-k>", "<C-w>k", { desc = "上のウィンドウへ" })
map("n", "<C-l>", "<C-w>l", { desc = "右のウィンドウへ" })

map("i", "jj", "<Esc>", {desc = "Insertモードを抜ける",})

vim.keymap.set("n", "<leader>aa", "ggVG", {desc = "全選択",})
