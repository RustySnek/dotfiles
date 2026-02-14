return {
	"neovim/nvim-lspconfig",
	config = function()
		vim.lsp.config("pyright", {})
		vim.lsp.enable("pyright")
		vim.lsp.config("lua_ls", {})
		vim.lsp.enable("lua_ls")
		vim.lsp.config("ts_ls", {})
		vim.lsp.enable("ts_ls")
		vim.lsp.config("nil_ls", {})
		vim.lsp.enable("nil_ls")
		vim.lsp.config("clangd", {})
		vim.lsp.enable("clangd")
		vim.lsp.config("terraformls", {})
		vim.lsp.enable("terraformls")

		vim.lsp.config("cssls", {})
		vim.lsp.enable("cssls")

		vim.lsp.config("html", {
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
		vim.lsp.enable("html")
	end,
}
