return {
	"akinsho/flutter-tools.nvim",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"stevearc/dressing.nvim",
	},
	config = function()
		require("flutter-tools").setup({
			debugger = {
				enabled = false,
			},
			widget_guides = {
				enabled = true,
			},
			closing_tags = {
				enabled = true,
			},
			dev_log = {
				enabled = true,
				open_cmd = "tabedit",
			},
		})

		-- Hot reload on save for Dart/Flutter files (async)
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = { "*.dart" },
			callback = function()
				vim.schedule(function()
					vim.cmd("silent! FlutterReload")
				end)
			end,
		})

		-- Hot restart keybinding
		vim.keymap.set("n", "<leader>fr", ":FlutterRestart<CR>", { desc = "Flutter Restart" })
	end,
}
