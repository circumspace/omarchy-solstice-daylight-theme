-- Solstice Daylight — Neovim theme for Omarchy (aether.nvim base16 engine).
-- Follows Omarchy's stock `beta` contract so `theme-hotreload` can live-swap it:
-- real plugin spec (spec[1] ≠ "LazyVim/LazyVim") + STRING opts.colorscheme.
--
-- aether ignores base16 for most highlight/Treesitter groups (it maps them to
-- its own semantic palette), so on the cream canvas several tokens leak as pale
-- pastels — and a whole class of MARKDOWN/`@markup.*` groups (what READMEs are
-- made of) are left at aether's washed defaults. We force readable, on-theme
-- hues across the real groups + TS captures + markdown, right after :colorscheme
-- and on every ColorScheme event (re-fires on live reload). Keeping the cream
-- canvas is deliberate: measured WCAG shows a darker bg collapses contrast for
-- the near-black body ink (all tokens drop toward 1:1), so the fix is the
-- tokens, not the background.
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
			-- on-theme readable palette for the light (cream) canvas:
			local rose, onrose = "#B04878", "#FFFFFF"
			local C = {
				ink = "#111111", body = "#22242C", muted = "#4A4F5C", comment = "#5E6472",
				string = "#3E6B4C", number = "#8A6608", constant = "#9E4E14",
				keyword = "#A83F6E", operator = "#2F6E6C", function_ = "#3E5E8C",
				type = "#6E5737", special = "#8A5A00", link = "#3E5E8C", quote = "#5E6472",
			}
			local function force_contrast()
				local hi = vim.api.nvim_set_hl
				local function many(names, tbl)
					for _, g in ipairs(names) do hi(0, g, tbl) end
				end
				-- base structural text
				hi(0, "Normal", { fg = C.ink })
				hi(0, "NormalFloat", { fg = C.ink, bg = "#F2EADA" })
				hi(0, "NormalNC", { fg = C.ink })
				hi(0, "NonText", { fg = C.muted })
				hi(0, "Whitespace", { fg = C.muted })
				hi(0, "EndOfBuffer", { fg = C.muted })
				hi(0, "Conceal", { fg = C.muted })
				hi(0, "Directory", { fg = C.function_, bold = true })
				-- selection / search / matches (rose, white ink)
				hi(0, "Visual", { bg = rose, fg = onrose })
				hi(0, "VisualNOS", { bg = rose, fg = onrose })
				hi(0, "IncSearch", { bg = rose, fg = onrose, bold = true })
				hi(0, "MatchWord", { bg = rose, fg = onrose })
				hi(0, "MatchWordRef", { bg = rose, fg = onrose })
				-- comments
				hi(0, "Comment", { fg = C.comment, italic = true })
				many({ "@comment", "@comment.documentation" }, { fg = C.comment, italic = true })
				hi(0, "@comment.todo", { fg = C.constant, bold = true, italic = true })
				hi(0, "Todo", { fg = C.constant, bold = true, italic = true })
				-- strings
				hi(0, "String", { fg = C.string })
				many({ "@string", "@string.documentation", "@character", "@string.special" }, { fg = C.string })
				-- numbers / constants
				hi(0, "Number", { fg = C.number })
				hi(0, "Float", { fg = C.number })
				hi(0, "Constant", { fg = C.constant })
				hi(0, "Boolean", { fg = C.constant })
				many({ "@number", "@float", "@constant", "@constant.builtin", "@boolean" }, { fg = C.constant })
				-- keywords / statements / preproc
				many({ "Keyword", "Statement", "Conditional", "Repeat", "Exception", "Label",
					"Include", "Define", "Macro", "PreProc" }, { fg = C.keyword })
				many({ "@keyword", "@keyword.function", "@keyword.return", "@keyword.conditional",
					"@keyword.repeat", "@keyword.exception", "@keyword.import", "@keyword.directive", "@label" },
					{ fg = C.keyword })
				-- operators / special
				hi(0, "Operator", { fg = C.operator })
				hi(0, "@operator", { fg = C.operator })
				hi(0, "Special", { fg = C.special })
				many({ "@function.macro", "@spell" }, { fg = C.special })
				-- functions
				hi(0, "Function", { fg = C.function_ })
				many({ "@function", "@function.call", "@method", "@method.call", "@function.builtin" },
					{ fg = C.function_ })
				-- types
				hi(0, "Type", { fg = C.type })
				many({ "StorageClass", "Structure", "Typedef", "@type", "@type.builtin", "@structure", "@constructor" },
					{ fg = C.type })
				-- identifiers / variables
				hi(0, "Identifier", { fg = C.body })
				many({ "@variable", "@variable.member", "@variable.parameter", "@variable.global",
					"@property", "@field", "@parameter" }, { fg = C.body })
				hi(0, "@variable.builtin", { fg = C.keyword, italic = true })
				-- markdown / markup (this is what README previews render)
				many({ "@markup.strong", "@markup.heading", "@text.strong", "@text.title", "@text.title.1.markdown",
					"@text.title.2.markdown", "@text.title.3.markdown", "@text.title.4.markdown",
					"@text.title.5.markdown", "@text.title.6.markdown", "@markup.heading.1", "@markup.heading.2",
					"@markup.heading.3", "@markup.heading.4" }, { fg = C.keyword, bold = true })
				many({ "@markup.emphasis", "@text.emphasis", "@markup.italic" }, { fg = C.body, italic = true })
				many({ "@markup.raw", "@markup.raw.block", "@markup.raw.inline", "@string.special", "@none" },
					{ fg = C.string })
				many({ "@markup.link", "@markup.link.label", "@text.uri", "@string.special.url" },
					{ fg = C.link, underline = true })
				hi(0, "@markup.link.url", { fg = C.link, underline = true })
				hi(0, "@markup.list", { fg = C.constant })
				hi(0, "@markup.quote", { fg = C.quote, italic = true })
				hi(0, "@markup.math", { fg = C.type })
				hi(0, "@markup.environment", { fg = C.function_ })
				hi(0, "@markup.diff.add", { fg = C.string, bold = true })
				hi(0, "@markup.diff.delete", { fg = C.constant, bold = true })
				-- diagnostic / completion readability
				hi(0, "@text.diff.add", { fg = C.string })
				hi(0, "@text.diff.delete", { fg = C.constant })
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