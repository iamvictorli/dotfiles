-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "[Y]anks to system clipboard" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "stays on middle screen while <C-d>" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "stays on middle screen while <C-u>" })
