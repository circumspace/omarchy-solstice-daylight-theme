-- Solstice Daylight — Neovim theme for Omarchy (aether.nvim base16 engine).
-- Follows Omarchy's stock `beta` contract so `theme-hotreload` can live-swap it:
-- real plugin spec (spec[1] ≠ "LazyVim/LazyVim") + STRING opts.colorscheme.
--
-- aether ignores base16 for most highlight/Treesitter groups and captures inside
-- fenced code blocks leak to fallbacks (unmatched -> near-black Normal; injected
-- names arrive as BOTH `foo` and `@foo`). We force readable, on-theme hues on both
-- spellings + @markup.* + a soft-slate @none code fallback, right after
-- :colorscheme and on every ColorScheme event. Cream canvas is deliberate: WCAG
-- shows a darker bg collapses the near-black body ink toward 1:1, so we fix the
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
			local rose, onrose = "#B04878", "#FFFFFF"
			local C = {
				code = "#333742",
				body = "#22242C", identifier = "#22242C",
				comment = "#5E6472", string = "#3E6B4C", number = "#8A6608",
				constant = "#9E4E14", keyword = "#A83F6E", operator = "#2F6E6C",
				function_ = "#3E5E8C", type = "#6E5737", special = "#8A5A00",
				link = "#3E5E8C",
			}
			local function force_contrast()
				-- register each group as BOTH `name` and `@name` so injected and
				-- non-injected Treesitter spellings both resolve.
				local function reg(names, tbl)
					for _, g in ipairs(names) do
						vim.api.nvim_set_hl(0, g, tbl)
						if g:sub(1, 1) == "@" then
							vim.api.nvim_set_hl(0, g:sub(2), tbl)
						else
							vim.api.nvim_set_hl(0, "@" .. g, tbl)
						end
					end
				end
				local hi = vim.api.nvim_set_hl
				reg({ "Normal" }, { fg = "#111111" })
				-- selection / search (rose, white ink)
				for _, g in ipairs({ "Visual", "VisualNOS", "@Visual", "@VisualNOS" }) do
					hi(0, g, { bg = rose, fg = onrose })
				end
				hi(0, "IncSearch", { bg = rose, fg = onrose, bold = true })
				hi(0, "MatchWord", { bg = rose, fg = onrose })
				hi(0, "MatchWordRef", { bg = rose, fg = onrose })
				-- code-block base / unmatched tokens -> soft slate (not #111)
				reg({ "none", "NormalFloat", "@none" }, { fg = C.code })
				reg({ "@markup.raw", "@markup.raw.block", "@markup.raw.inline" }, { fg = C.code })
				-- comments
				reg({ "Comment", "@comment", "@comment.documentation" }, { fg = C.comment, italic = true })
				reg({ "Todo", "@comment.todo" }, { fg = C.constant, bold = true, italic = true })
				-- strings / chars
				reg({ "String", "Character", "@string", "@string.documentation", "@character", "@string.special" },
					{ fg = C.string })
				-- numbers / constants
				reg({ "Number", "Float", "@number", "@float" }, { fg = C.number })
				reg({ "Constant", "Boolean", "@constant", "@constant.builtin", "@boolean" }, { fg = C.constant })
				-- keywords / statements / preproc
				reg({ "Keyword", "Statement", "Conditional", "Repeat", "Exception", "Label", "Include", "Define",
					"Macro", "PreProc", "@keyword", "@keyword.function", "@keyword.return", "@keyword.conditional",
					"@keyword.repeat", "@keyword.exception", "@keyword.import", "@keyword.directive", "@label" },
					{ fg = C.keyword })
				-- operators / special
				reg({ "Operator", "@operator" }, { fg = C.operator })
				reg({ "Special", "@function.macro", "@spell", "@preproc" }, { fg = C.special })
				-- functions / methods
				reg({ "Function", "@function", "@function.call", "@function.builtin", "@method", "@method.call" },
					{ fg = C.function_ })
				-- types / storage
				reg({ "Type", "StorageClass", "Structure", "Typedef", "@type", "@type.builtin", "@structure",
					"@constructor" }, { fg = C.type })
				-- identifiers / variables / fields
				reg({ "Identifier", "@variable", "@variable.member", "@variable.parameter", "@variable.global",
					"@variable.field", "@property", "@field", "@parameter" }, { fg = C.identifier })
				reg({ "@variable.builtin" }, { fg = C.keyword, italic = true })
				-- markdown / markup (what README previews render)
				reg({ "@markup.strong", "@markup.heading", "@text.strong", "@text.title", "@markup.heading.1",
					"@markup.heading.2", "@markup.heading.3", "@markup.heading.4", "@markup.heading.5",
					"@markup.heading.6", "@text.title.1.markdown", "@text.title.2.markdown", "@text.title.3.markdown",
					"@text.title.4.markdown", "@text.title.5.markdown", "@text.title.6.markdown" },
					{ fg = C.keyword, bold = true })
				reg({ "@markup.emphasis", "@text.emphasis", "@markup.italic" }, { fg = C.body, italic = true })
				reg({ "@markup.link", "@markup.link.label", "@text.uri", "@string.special.url", "@markup.link.url" },
					{ fg = C.link, underline = true })
				reg({ "@markup.list" }, { fg = C.constant })
				reg({ "@markup.quote" }, { fg = C.comment, italic = true })
				reg({ "@markup.math" }, { fg = C.type })
				reg({ "@markup.environment" }, { fg = C.function_ })
				reg({ "@markup.diff.add", "@text.diff.add" }, { fg = C.string, bold = true })
				reg({ "@markup.diff.delete", "@text.diff.delete" }, { fg = C.constant, bold = true })
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