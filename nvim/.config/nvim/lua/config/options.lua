-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disables Clipboard Sync
vim.opt.clipboard = ""

-- disables all snacks animations
vim.g.snacks_animate = false

-- Disable netrw (using mini-files instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Keep markdown preview open when switching buffers
vim.g.mkdp_auto_close = 0
