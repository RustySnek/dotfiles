return {
	"neovim/nvim-lspconfig",
	config = function()
		local lsp = require("lspconfig")
		lsp.pyright.setup({})
		lsp.lua_ls.setup({})
		lsp.ts_ls.setup({})
		lsp.nil_ls.setup({})
		lsp.clangd.setup({})

		lsp.cssls.setup({})

		lsp.html.setup({
			configurationSection = { "html", "css", "javascript", "heex" },
			embeddedLanguages = {
				css = true,
				javascript = true,
			},
			settings = {
				html = {
					format = {
						wrapLineLength = 80,
						contentUnformatted = "pre",
						enable = false,
					},
				},
			},
			provideFormatter = true,
		})
	end,
}
