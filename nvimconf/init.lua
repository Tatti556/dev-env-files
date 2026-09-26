if vim.g.vscode then
    require("config.vscode")
else
    require("config.options")
    require("config.keymaps")
    require("config.lazy")
    require("config.folds")
end