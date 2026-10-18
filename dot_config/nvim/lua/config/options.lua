-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.root_spec = { "cwd", "lsp", { ".git", "lua" } }

vim.g.lazyvim_ts_lsp = "tsgo"

require("config.platform")
