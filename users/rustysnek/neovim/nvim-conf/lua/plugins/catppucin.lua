return {
	"catppuccin/nvim",
	name = "catppucin",
	config = function()
		local cat = require("catppuccin")
		vim.cmd.colorscheme("catppuccin")
		cat.setup({
			transparent_background = true,
			integrations = {
				treesitter = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
					},
				},
				coc_nvim = false,
				lsp_trouble = false,
				cmp = true,
				lsp_saga = true,
				gitgutter = false,
				gitsigns = false,
				telescope = true,
				nvimtree = false,
				dap = {
					enabled = false,
					enable_ui = false,
				},
				neotree = {
					enabled = false,
					show_root = true,
					transparent_panel = false,
				},
				which_key = false,
				indent_blankline = {
					enabled = true,
					colored_indent_levels = false,
				},
				dashboard = false,
				neogit = false,
				vim_sneak = false,
				fern = false,
				barbar = false,
				markdown = true,
				lightspeed = false,
				leap = false,
				ts_rainbow = false,
				hop = false,
				notify = true,
				telekasten = false,
				symbols_outline = false,
				mini = false,
				aerial = false,
				vimwiki = false,
				beacon = false,
				navic = {
					enabled = false,
					custom_bg = "NONE",
				},
				overseer = false,
				fidget = true,
				treesitter_context = false,
			},

			custom_highlights = function(C)
				return {
					CmpItemKindSnippet = { fg = C.base, bg = C.mauve },
					CmpItemKindKeyword = { fg = C.base, bg = C.red },
					CmpItemKindText = { fg = C.base, bg = C.teal },
					CmpItemKindMethod = { fg = C.base, bg = C.blue },
					CmpItemKindConstructor = { fg = C.base, bg = C.blue },
					CmpItemKindFunction = { fg = C.base, bg = C.blue },
					CmpItemKindFolder = { fg = C.base, bg = C.blue },
					CmpItemKindModule = { fg = C.base, bg = C.blue },
					CmpItemKindConstant = { fg = C.base, bg = C.peach },
					CmpItemKindField = { fg = C.base, bg = C.green },
					CmpItemKindProperty = { fg = C.base, bg = C.green },
					CmpItemKindEnum = { fg = C.base, bg = C.green },
					CmpItemKindUnit = { fg = C.base, bg = C.green },
					CmpItemKindClass = { fg = C.base, bg = C.yellow },
					CmpItemKindVariable = { fg = C.base, bg = C.flamingo },
					CmpItemKindFile = { fg = C.base, bg = C.blue },
					CmpItemKindInterface = { fg = C.base, bg = C.yellow },
					CmpItemKindColor = { fg = C.base, bg = C.red },
					CmpItemKindReference = { fg = C.base, bg = C.red },
					CmpItemKindEnumMember = { fg = C.base, bg = C.red },
					CmpItemKindStruct = { fg = C.base, bg = C.blue },
					CmpItemKindValue = { fg = C.base, bg = C.peach },
					CmpItemKindEvent = { fg = C.base, bg = C.blue },
					CmpItemKindOperator = { fg = C.base, bg = C.blue },
					CmpItemKindTypeParameter = { fg = C.base, bg = C.blue },
					CmpItemKindCopilot = { fg = C.base, bg = C.teal },
				}
			end,
			run = ":CatppuccinCompile",
		})
	end,
}
