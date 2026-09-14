-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "[Y]anks to system clipboard" })

-- Center buffer while navigating
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center cursor" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center cursor" })
vim.keymap.set("n", "{", "{zz", { desc = "Jump to previous paragraph and center" })
vim.keymap.set("n", "}", "}zz", { desc = "Jump to next paragraph and center" })
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zvzz'", { expr = true, desc = "Next Search Result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward].'zz'", { expr = true, desc = "Next Search Result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward].'zz'", { expr = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zvzz'", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward].'zz'", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward].'zz'", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("n", "G", "Gzz", { desc = "Go to end of file and center" })
vim.keymap.set("n", "gg", "ggzz", { desc = "Go to beginning of file and center" })
vim.keymap.set("n", "gd", "gdzz", { desc = "Go to definition and center" })
vim.keymap.set("n", "<C-i>", "<C-i>zz", { desc = "Jump forward in jump list and center" })
vim.keymap.set("n", "<C-o>", "<C-o>zz", { desc = "Jump backward in jump list and center" })
vim.keymap.set("n", "%", "%zz", { desc = "Jump to matching bracket and center" })
vim.keymap.set("n", "*", "*zz", { desc = "Search for word under cursor and center" })
vim.keymap.set("n", "#", "#zz", { desc = "Search backward for word under cursor and center" })

-- Jump to start/end of line
vim.keymap.set("n", "L", "$", { desc = "Jump to end of line" })
vim.keymap.set("n", "H", "^", { desc = "Jump to beginning of line" })
vim.keymap.set("v", "L", "$<left>", { desc = "Move to end of line in visual mode" })
vim.keymap.set("v", "H", "^", { desc = "Move to beginning of line in visual mode" })

-- from https://github.com/paulbkim-dev/vim-herdr-navigation
-- Seamless navigation between Neovim splits and Herdr panes. This config loads
-- after LazyVim's default keymaps, so these mappings win.
local function navigate_neovim_or_herdr(wincmd, direction)
  local previous_window = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. wincmd)
  if vim.api.nvim_get_current_win() ~= previous_window then
    return
  end

  if vim.env.HERDR_PANE_ID and vim.env.HERDR_PANE_ID ~= "" then
    local herdr = vim.env.HERDR_BIN_PATH
    if herdr == nil or herdr == "" then
      herdr = "herdr"
    end
    vim.fn.system({ herdr, "pane", "focus", "--direction", direction, "--pane", vim.env.HERDR_PANE_ID })
  end
end

local function map_neovim_or_herdr_navigation(lhs, wincmd, direction, description)
  vim.keymap.set("n", lhs, function()
    navigate_neovim_or_herdr(wincmd, direction)
  end, { silent = true, noremap = true, desc = description })
end

map_neovim_or_herdr_navigation("<C-h>", "h", "left", "Navigate left (Vim/Herdr)")
map_neovim_or_herdr_navigation("<C-j>", "j", "down", "Navigate down (Vim/Herdr)")
map_neovim_or_herdr_navigation("<C-k>", "k", "up", "Navigate up (Vim/Herdr)")
map_neovim_or_herdr_navigation("<C-l>", "l", "right", "Navigate right (Vim/Herdr)")

-- Remap wrap toggle to <leader>uu
local snacks = require("snacks")
snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uu")
snacks.toggle.zoom():map("<leader>uz")
snacks.toggle.zen():map("<leader>uZ")

-- diagnostic
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
    vim.cmd("normal! zz")
  end
end
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
