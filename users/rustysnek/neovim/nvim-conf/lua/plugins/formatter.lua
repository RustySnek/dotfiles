return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black" },
			javascript = { "prettierd" },
			typescript = { "prettierd" },
			htmlangular = { "prettierd" },
			css = { "prettierd" },
			scss = { "prettierd" },
			nix = { "nixfmt" },
			dart = { "dart_format" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
	},
}
