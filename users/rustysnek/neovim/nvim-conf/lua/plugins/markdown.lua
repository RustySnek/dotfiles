return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("render-markdown").setup({})

		vim.keymap.set("n", "<leader>mp", ":RenderMarkdown toggle<CR>", { desc = "Render Markdown Toggle" })
	end,
}
