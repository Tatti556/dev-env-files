return {
  "folke/noice.nvim",
  event = "VeryLazy",
  cond = not vim.g.vscode,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    presets = {
      command_palette = true,
      long_message_to_split = true,
    },
  },
}
