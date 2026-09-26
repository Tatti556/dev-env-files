local function project_name()
  local filename = vim.api.nvim_buf_get_name(0)
  local start = filename ~= "" and vim.fs.dirname(filename) or vim.uv.cwd()
  local root = vim.fs.root(start, {
    ".git",
    "package.json",
    "pyproject.toml",
    "Cargo.toml",
    "go.mod",
  }) or vim.uv.cwd()

  return vim.fs.basename(root)
end

local function mode_theme(accent)
  return {
    a = { bg = accent, fg = "#001419" },
    b = { bg = "#1a1a22", fg = accent },
    c = { bg = "#1a1a22", fg = "#839496" },
  }
end

local mode_accents = {
  n = "#7aa3f7",
  i = "#849900",
  c = "#b28500",
  v = "#d23681",
  V = "#d23681",
  ["\22"] = "#d23681",
  R = "#db302d",
  t = "#849900",
}

local function current_mode_accent()
  return mode_accents[vim.fn.mode(1):sub(1, 1)] or mode_accents.n
end

-- 左側の輪郭線を現在のモード色に追従させる。
local function left_divider()
  return {
    function()
      return ""
    end,
    color = function()
      return {
        bg = "#1a1a22",
        fg = current_mode_accent(),
      }
    end,
    padding = 0,
    separator = "",
  }
end

local function right_divider()
  return {
    function()
      return ""
    end,
    color = function()
      return {
        bg = "#1a1a22",
        fg = current_mode_accent(),
      }
    end,
    padding = 0,
    separator = "",
  }
end

local function date_time()
  local now = os.date("*t")
  local weekdays = {
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
  }

  return string.format(
    "%04d-%02d-%02d %s 󰥔 %02d:%02d",
    now.year,
    now.month,
    now.day,
    weekdays[now.wday],
    now.hour,
    now.min
  )
end

-- mode と時刻は色面、その他は Solarized Osaka の statusline 背景に揃える
local mozumasu_solarized_osaka = {
  normal = mode_theme("#7aa3f7"),
  insert = mode_theme("#849900"),
  command = mode_theme("#b28500"),
  visual = mode_theme("#d23681"),
  replace = mode_theme("#db302d"),
  terminal = mode_theme("#849900"),
  inactive = {
    a = { bg = "#1a1a22", fg = "#576d74" },
    b = { bg = "#1a1a22", fg = "#576d74" },
    c = { bg = "#1a1a22", fg = "#576d74" },
  },
}

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",

    -- VSCode Neovimではlualineを読み込まない
    cond = function()
      return not vim.g.vscode
    end,

    opts = {
      options = {
        theme = mozumasu_solarized_osaka,
        globalstatus = true,
        component_separators = {
          left = "",
          right = "",
        },
        section_separators = {
          left = "",
          right = "",
        },
      },

      sections = {
        lualine_a = {
          {
            "mode",
            separator = {
              left = "",
              right = "",
            },
          },
        },
        lualine_b = {
          {
            "branch",
            separator = "",
          },
        },
        lualine_c = {
          left_divider(),
          {
            function()
              return "󱉭 " .. project_name()
            end,
            color = { fg = "#cb4b16" },
          },
          {
            "diagnostics",
            symbols = {
              error = " ",
              warn = " ",
              info = " ",
              hint = "󰌵 ",
            },
          },
          left_divider(),
          {
            "filetype",
            icon_only = true,
            separator = "",
            padding = {
              left = 1,
              right = 0,
            },
          },
          {
            "filename",
            path = 1,
            symbols = {
              modified = " ●",
              readonly = " ",
              unnamed = "[No Name]",
              newfile = "[New]",
            },
          },
        },
        lualine_x = {
          {
            "diff",
            symbols = {
              added = " ",
              modified = " ",
              removed = " ",
            },
          },
        },
        lualine_y = {
          right_divider(),
          {
            "encoding",
            fmt = string.upper,
            separator = "",
            padding = {
              left = 1,
              right = 1,
            },
          },
          right_divider(),
          {
            "progress",
            separator = "",
            padding = {
              left = 1,
              right = 0,
            },
          },
          right_divider(),
          {
            "location",
            separator = "",
            padding = {
              left = 0,
              right = 1,
            },
          },
        },
        lualine_z = {
          {
            date_time,
          },
        },
      },

      extensions = {
        "neo-tree",
      },
    },
  },
}
