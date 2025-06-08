return {
	"neovim/nvim-lspconfig",
	config = function()
		local lsp = require("lspconfig")
		lsp.pyright.setup({})
		lsp.lua_ls.setup({})
		lsp.ts_ls.setup({})
		lsp.nil_ls.setup({})

		lsp.cssls.setup({})
		lsp.html.setup({
			configurationSection = { "html", "css", "javascript", "heex" },
			settings = {
				html = {
					format = {
						wrapLineLength = 80, -- Sets the maximum line length to 80
						unformatted = "pre", -- Optional: prevent reformatting specific tags
						contentUnformatted = "pre", -- Optional: prevent reformatting content inside specific tags
					},
				},
			},
			embeddedLanguages = {
				css = true,
				javascript = true,
			},
			provideFormatter = true,
		})
	end,
}
