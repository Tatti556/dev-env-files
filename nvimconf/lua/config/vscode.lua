-- VSCode-Neovim専用設定
-- foldはVSCode側が所有するため、z系キーをVSCodeコマンドへ転送する。
-- folds.lua (Treesitter expr fold) とは併用しない。

local map = vim.keymap.set
local notify = function(cmd)
  return function()
    vim.fn.VSCodeNotify(cmd)
  end
end
local opts = { silent = true }

-- 見出し行での開閉トグル / 畳む / 開く
map("n", "za", notify("editor.toggleFold"), opts)
map("n", "zc", notify("editor.fold"), opts)
map("n", "zo", notify("editor.unfold"), opts)
map("n", "zC", notify("editor.foldRecursively"), opts)
map("n", "zO", notify("editor.unfoldRecursively"), opts)

-- 全体 / レベル指定 (Markdownの #, ## 対応)
map("n", "zM", notify("editor.foldAll"), opts)
map("n", "zR", notify("editor.unfoldAll"), opts)
map("n", "z1", notify("editor.foldLevel1"), opts)
map("n", "z2", notify("editor.foldLevel2"), opts)
map("n", "z3", notify("editor.foldLevel3"), opts)
map("n", "z4", notify("editor.foldLevel4"), opts)

-- 前後のfoldへ移動
map("n", "zj", notify("editor.gotoNextFold"), opts)
map("n", "zk", notify("editor.gotoPreviousFold"), opts)
