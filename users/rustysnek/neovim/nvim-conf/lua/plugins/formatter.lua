return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform will run multiple formatters sequentially
			python = { "black" },
			-- Use a sub-list to run only the first available formatter
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			htmlangular = { "prettierd" },
			css = { "prettierd" },
			scss = { "prettierd" },
			nix = { "nixfmt" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
	},
}
