return {
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      indent = {
        enable = true,
      },
      chunk = {
        enable = true,
        style = "#7E9CD8", -- Kanagawa: crystalBlue
        delay = 0,
        chars = {
          right_arrow = "→",
        },
      },
    },
  },
}
