vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cmdheight = 0

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250

vim.opt.clipboard = "unnamedplus"

-- 通常選択のバッファは再利用し、Neo-treeのtで開いたバッファだけ保持する。
-- buftypeが空でない特殊バッファ（Neo-tree、terminal、quickfixなど）は対象外。
local function configure_buffer_lifecycle(bufnr)
  if vim.bo[bufnr].buftype == "" then
    local keep_buffer = vim.b[bufnr].neo_tree_keep_buffer == true
    vim.bo[bufnr].bufhidden = keep_buffer and "hide" or "wipe"
  end
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("ReuseNormalBuffers", { clear = true }),
  callback = function(args)
    configure_buffer_lifecycle(args.buf)
  end,
})

-- 起動時に既に存在する[No Name]にも適用する。
configure_buffer_lifecycle(0)
