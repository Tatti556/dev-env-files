local function focus_target_window(state)
  local utils = require("neo-tree.utils")
  local target_win = utils.get_appropriate_window(state)
  if not vim.api.nvim_win_is_valid(target_win) then
    return nil
  end
  vim.api.nvim_set_current_win(target_win)
  return target_win
end

local function set_buffer_persistent(bufnr, persistent)
  if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buftype == "" then
    vim.b[bufnr].neo_tree_keep_buffer = persistent
    vim.bo[bufnr].bufhidden = persistent and "hide" or "wipe"
  end
end

-- 現在のバッファを置き換えて開く。
local function open_in_current_buffer(state)
  local node = state.tree:get_node()
  if not node or node.type ~= "file" then
    state.commands.open(state)
    return
  end

  local target_win = focus_target_window(state)
  if not target_win then
    return
  end

  local previous_buf = vim.api.nvim_win_get_buf(target_win)
  local was_persistent = vim.b[previous_buf].neo_tree_keep_buffer == true
  set_buffer_persistent(previous_buf, false)

  local opened, err = pcall(state.commands.open, state)
  if not opened then
    set_buffer_persistent(previous_buf, was_persistent)
    error(err, 0)
  end

  local current_buf = vim.api.nvim_get_current_buf()
  local keep_current = was_persistent or vim.b[current_buf].neo_tree_keep_buffer == true
  set_buffer_persistent(current_buf, keep_current)
end

-- 現在のバッファを残して同じタブページ内で開く。
local function open_in_new_buffer(state)
  local node = state.tree:get_node()
  if not node or node.type ~= "file" then
    state.commands.open(state)
    return
  end

  local target_win = focus_target_window(state)
  if not target_win then
    return
  end

  local previous_buf = vim.api.nvim_win_get_buf(target_win)
  set_buffer_persistent(previous_buf, true)
  state.commands.open(state)
  set_buffer_persistent(vim.api.nvim_get_current_buf(), true)
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",

    -- Oilとは別キーで必要時に起動する
    cmd = { "Neotree" },

    keys = {
      {
        "<leader>n",
        "<CMD>Neotree toggle<CR>",
        desc = "Neo-treeを開く/閉じる",
      },
    },

    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },

    opts = {
      filesystem = {
        -- Oilのdefault_file_explorerと競合させない
        hijack_netrw_behavior = "disabled",
      },

      window = {
        mappings = {
          -- splitで開く
          ["<leader>sv"] = "open_vsplit",
          ["<leader>sh"] = "open_split",

          -- 現在のバッファを残して同じタブページ内の新しいバッファで開く
          ["t"] = open_in_new_buffer,

          -- 通常選択は現在のバッファを置き換える
          ["<cr>"] = open_in_current_buffer,
          ["<2-LeftMouse>"] = open_in_current_buffer,

          -- 競合キーを無効化
          ["s"] = "none",
          ["S"] = "none",
        },
      },
    },
  },
}
