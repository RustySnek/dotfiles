local plugins = {
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp"
  },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "sindrets/diffview.nvim",
      "ibhagwan/fzf-lua",
    },
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^4", -- Recommended
    lazy = false,   -- This plugin is already lazy
  },
  "saadparwaiz1/cmp_luasnip",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/nvim-cmp",
  "jose-elias-alvarez/null-ls.nvim",
  "neovim/nvim-lspconfig",
  "mfussenegger/nvim-dap",
  "rcarriga/nvim-dap-ui",
  "mellow-theme/mellow.nvim",
  "tomasr/molokai",
  "elixir-tools/elixir-tools.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-treesitter/nvim-treesitter",
  "norcalli/nvim-colorizer.lua",
  'junegunn/fzf',
}
return plugins
