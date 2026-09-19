-- Solstice Daylight — Neovim theme for Omarchy (aether.nvim base16 engine).
-- Follows Omarchy's stock `beta` contract so `theme-hotreload` can live-swap it:
-- real plugin spec (spec[1] ≠ "LazyVim/LazyVim") + STRING opts.colorscheme.
--
-- aether ignores most base16 slots for its actual highlight/Treesitter groups
-- (it maps Keyword/Constant/Type/Identifier to its own semantic palette), leaving
-- pale, low-contrast tokens on the cream canvas. We seed base16 for what aether
-- honors, then force readable colors across the real groups + TS captures right
-- after :colorscheme and on every ColorScheme event (re-fires on live reload).
-- Selection highlight is the brighter rose #B04878 with white ink, kept distinct.
return {
	{
		"bjarneo/aether.nvim",
		name = "aether",
		priority = 1000,
		opts = {
			disable_italics = false,
			colors = {
				base00 = "#FAF5EC", base01 = "#E9E2D2", base02 = "#E4DCC7",
				base03 = "#5E6472", base04 = "#4A4F5C", base05 = "#000000",
				base06 = "#20222A", base07 = "#AFB2C3", base08 = "#B03535",
				base09 = "#9E4E14", base0A = "#8A6608", base0B = "#3E6B4C",
				base0C = "#2F6E6C", base0D = "#3E5E8C", base0E = "#A83F6E",
				base0F = "#6E5737",
			},
		},
		config = function(_, opts)
			local rose, onrose = "#B04878", "#FFFFFF"
			local function force_contrast()
				local hi = vim.api.nvim_set_hl
				local C = {
					comment = "#5E6472", string = "#3E6B4C", number = "#8A6608",
					constant = "#9E4E14", keyword = "#A83F6E", operator = "#2F6E6C",
					function_ = "#3E5E8C", identifier = "#22242C", type = "#6E5737",
					variable = "#111111", special = "#8A5A00",
				}
				local function many(names, tbl)
					for _, g in ipairs(names) do hi(0, g, tbl) end
				end
				-- selection / search (rose, white ink)
				hi(0, "Visual", { bg = rose, fg = onrose })
				hi(0, "VisualNOS", { bg = rose, fg = onrose })
				hi(0, "IncSearch", { bg = rose, fg = onrose, bold = true })
				hi(0, "MatchWord", { bg = rose, fg = onrose })
				hi(0, "MatchWordRef", { bg = rose, fg = onrose })
				-- comments
				hi(0, "Comment", { fg = C.comment, italic = true })
				many({ "@comment", "@comment.documentation" }, { fg = C.comment, italic = true })
				hi(0, "@comment.todo", { fg = C.constant, bold = true, italic = true })
				-- strings
				hi(0, "String", { fg = C.string })
				many({ "@string", "@string.documentation", "@character", "@string.special" }, { fg = C.string })
				-- numbers / constants
				hi(0, "Number", { fg = C.number })
				hi(0, "Float", { fg = C.number })
				hi(0, "Constant", { fg = C.constant })
				hi(0, "Boolean", { fg = C.constant })
				many({ "@number", "@float", "@constant", "@constant.builtin", "@boolean" }, { fg = C.constant })
				-- keywords / statements / preproc (all deep rose)
				many({ "Keyword", "Statement", "Conditional", "Repeat", "Exception", "Label",
					"Include", "Define", "Macro", "PreProc" }, { fg = C.keyword })
				many({ "@keyword", "@keyword.function", "@keyword.return", "@keyword.conditional",
					"@keyword.repeat", "@keyword.exception", "@keyword.import", "@keyword.directive", "@label" },
					{ fg = C.keyword })
				-- operators / special
				hi(0, "Operator", { fg = C.operator })
				hi(0, "@operator", { fg = C.operator })
				hi(0, "Special", { fg = C.special })
				hi(0, "@function.macro", { fg = C.special })
				-- functions
				hi(0, "Function", { fg = C.function_ })
				many({ "@function", "@function.call", "@method", "@method.call", "@function.builtin" },
					{ fg = C.function_ })
				-- types
				hi(0, "Type", { fg = C.type })
				many({ "StorageClass", "Structure", "Typedef", "@type", "@type.builtin", "@structure", "@constructor" },
					{ fg = C.type })
				-- identifiers / variables
				hi(0, "Identifier", { fg = C.identifier })
				many({ "@variable", "@variable.member", "@property", "@field", "@parameter" }, { fg = C.identifier })
				hi(0, "@variable.builtin", { fg = C.keyword, italic = true })
				-- markup
				hi(0, "@text.title", { fg = C.function_, bold = true })
				hi(0, "@text.uri", { fg = C.function_, underline = true })
				hi(0, "@markup.heading", { fg = C.keyword, bold = true })
			end
			local grp = vim.api.nvim_create_augroup("solstice_daylight_contrast", { clear = true })
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "aether",
				group = grp,
				callback = force_contrast,
			})
			require("aether").setup(opts)
			vim.cmd.colorscheme("aether")
			force_contrast()
		end,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "aether",
		},
	},
}