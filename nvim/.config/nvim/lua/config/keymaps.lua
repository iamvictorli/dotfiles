-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "[Y]anks to system clipboard" })

-- Center buffer while navigating
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "stays on middle screen while <C-d>" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "stays on middle screen while <C-u>" })
vim.keymap.set("n", "{", "{zz", { desc = "Jump to previous paragraph and center" })
vim.keymap.set("n", "}", "}zz", { desc = "Jump to next paragraph and center" })

-- nvim-tmux-navigation
local nvim_tmux_nav = require("nvim-tmux-navigation")
vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft, { desc = "Navigate Left" })
vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown, { desc = "Navigate Down" })
vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp, { desc = "Navigate Up" })
vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight, { desc = "Navigate Right" })
vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive, { desc = "Navigate Last Active" })
vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext, { desc = "Navigate Next" })

-- Remap wrap toggle to <leader>uu
require("snacks").toggle.option("wrap", { name = "Wrap" }):map("<leader>uu")

-- Spectre for global find/replace
-- vim.keymap.set("n", "<leader>S", function()
-- 	require("spectre").toggle()
-- end, { desc = "Toggle Spectre for global find/replace" })

-- Spectre for word under cursor (visual)
-- vim.keymap.set("n", "<leader>sw", function()
-- 	require("spectre").open_visual({ select_word = true })
-- end, { desc = "Search current word using Spectre" })

-- Jump to start/end of line
-- vim.keymap.set("n", "L", "$", { desc = "Jump to end of line" })
-- vim.keymap.set("n", "H", "^", { desc = "Jump to beginning of line" })
