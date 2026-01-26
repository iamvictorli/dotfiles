-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  -- disabled plugins
  { "akinsho/bufferline.nvim", enabled = false },

  -- disable inlay hints by default
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
    },
  },

  -- which-key configuration
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        -- Override <leader>w from "windows" group to "Save"
        { "<leader>w", "<cmd>w<cr>", desc = "Save current buffer", icon = { icon = "", color = "cyan" } },
        { "<leader>wm", hidden = true },
        { "<leader>wd", hidden = true },
        -- Override <leader>q from "quit/session" group to "Quit"
        { "<leader>q", "<cmd>q<cr>", desc = "Quit current buffer", icon = { icon = "󰗼", color = "red" } },
        { "<leader>qq", hidden = true },
        { "<leader>qd", hidden = true },
        { "<leader>ql", hidden = true },
        { "<leader>qs", hidden = true },
        { "<leader>qS", hidden = true },
        -- Window splits: replace <leader>- and <leader>| with <leader>\ and <leader><CR>
        { "<leader>-", hidden = true },
        { "<leader>|", hidden = true },
        { "<leader>\\", "<C-w>vzz", desc = "Split window right" },
        { "<leader><CR>", "<C-w>szz", desc = "Split window below" },
        -- Window management under <leader>uw
        { "<leader>uw", group = "window" },
        { "<leader>uwo", "<C-w>o", desc = "Close all other windows" },
        { "<leader>uw=", "<C-w>=", desc = "Equally high and wide" },
        {
          "<leader>uw<space>",
          function()
            require("which-key").show({ keys = "<c-w>", loop = true })
          end,
          desc = "Window Hydra Mode",
        },
      },
    },
  },

  -- https://www.lazyvim.org/plugins/colorscheme#tokyonightnvim
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "storm",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },
  -- grug-far: search and replace
  {
    "MagicDuck/grug-far.nvim",
    keys = {
      {
        "<leader>sw",
        function()
          require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
        end,
        mode = "n",
        desc = "Search word under cursor",
      },
    },
  },

  -- Disable snacks.nvim <leader>sw to allow grug-far to use it
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>sw", false },
    },
  },

  {
    "alexghergh/nvim-tmux-navigation",
    config = function()
      require("nvim-tmux-navigation").setup({
        disable_when_zoomed = true,
      })
    end,
  },
}
