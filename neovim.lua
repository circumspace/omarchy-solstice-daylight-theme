-- Solstice Daylight — Neovim colorscheme (Omarchy / LazyVim).
-- Self-contained: registers the "solstice_daylight" scheme and hands it to
-- LazyVim, so there is no upstream plugin dependency. Colors are the Solaris 9
-- CDE palette: cream canvas, grey-lavender chrome, rose selection.
local palette = {
	bg = "#FAF5EC", -- cream canvas
	bg_alt = "#F1EADB", -- subtle contrast surface
	fg = "#000000",
	muted = "#585A6A",
	dim = "#808898",
	chrome = "#AFB2C3", -- chrome grey-lavender
	rose = "#B04878", -- accent / selection
	red = "#C23D3D",
	green = "#4A7A5A",
	yellow = "#C4983B",
	blue = "#4A6DA0",
	cyan = "#5A8A8A",
	magenta = "#B04878",
}

local function apply()
	vim.cmd("hi clear")
	if vim.fn.exists("syntax_on") then
		vim.cmd("syntax reset")
	end
	vim.g.colors_name = "solstice_daylight"
	vim.o.background = "light"
	vim.opt.termguicolors = true

	local c = palette
	local function hl(group, opts)
		vim.api.nvim_set_hl(0, group, opts)
	end

	-- Editor chrome
	hl("Normal", { fg = c.fg, bg = c.bg })
	hl("NormalFloat", { fg = c.fg, bg = c.bg_alt })
	hl("NormalNC", { fg = c.fg, bg = c.bg })
	hl("LineNr", { fg = c.dim, bg = c.bg })
	hl("CursorLineNr", { fg = c.rose, bg = c.bg, bold = true })
	hl("CursorLine", { bg = c.bg_alt })
	hl("CursorColumn", { bg = c.bg_alt })
	hl("ColorColumn", { bg = c.bg_alt })
	hl("SignColumn", { fg = c.dim, bg = c.bg })
	hl("Folded", { fg = c.muted, bg = c.bg_alt, italic = true })
	hl("FoldColumn", { fg = c.dim, bg = c.bg })
	hl("MatchWord", { bg = c.chrome, fg = c.fg })
	hl("MatchWordRef", { bg = c.chrome, fg = c.fg })
	hl("IncSearch", { bg = c.rose, fg = "#FFFFFF" })
	hl("Search", { bg = c.yellow, fg = c.fg })
	hl("Substitute", { bg = c.red, fg = "#FFFFFF" })
	hl("Directory", { fg = c.blue, bold = true })

	-- Statusline / tabline
	hl("StatusLine", { fg = c.fg, bg = c.chrome })
	hl("StatusLineNC", { fg = c.muted, bg = c.chrome })
	hl("TabLine", { fg = c.muted, bg = c.bg })
	hl("TabLineSel", { fg = "#FFFFFF", bg = c.rose, bold = true })
	hl("TabLineFill", { bg = c.bg })

	-- Popup menu / completion
	hl("Pmenu", { fg = c.fg, bg = c.bg_alt })
	hl("PmenuSel", { fg = "#FFFFFF", bg = c.rose })
	hl("PmenuSbar", { bg = c.chrome })
	hl("PmenuThumb", { bg = c.rose })
	hl("WildMenu", { fg = "#FFFFFF", bg = c.rose })

	-- Borders / separators
	hl("VertSplit", { fg = c.chrome })
	hl("WinSeparator", { fg = c.chrome })
	hl("FloatBorder", { fg = c.chrome, bg = c.bg_alt })

	-- Visual selection
	hl("Visual", { bg = c.rose, fg = "#FFFFFF" })
	hl("VisualNOS", { bg = c.chrome })

	-- Diagnostics
	hl("DiagnosticError", { fg = c.red })
	hl("DiagnosticWarn", { fg = c.yellow })
	hl("DiagnosticInfo", { fg = c.blue })
	hl("DiagnosticHint", { fg = c.cyan })
	hl("DiagnosticOk", { fg = c.green })
	hl("DiagnosticUnderlineError", { sp = c.red, undercurl = true })
	hl("DiagnosticUnderlineWarn", { sp = c.yellow, undercurl = true })
	hl("DiagnosticUnderlineInfo", { sp = c.blue, undercurl = true })
	hl("DiagnosticUnderlineHint", { sp = c.cyan, undercurl = true })

	-- Terminal ANSI
	for i, name in ipairs({
		"TermBlack", "TermRed", "TermGreen", "TermYellow",
		"TermBlue", "TermMagenta", "TermCyan", "TermWhite",
	}) do
		hl(name, { fg = c[({ "muted", "red", "green", "yellow", "blue", "magenta", "cyan", "fg" })[i]] })
	end

	-- Treesitter capture groups
	hl("@comment", { link = "Comment" })
	hl("@string", { link = "String" })
	hl("@string.special", { fg = c.cyan })
	hl("@character", { fg = c.cyan })
	hl("@number", { link = "Number" })
	hl("@float", { link = "Number" })
	hl("@boolean", { fg = c.yellow, bold = true })
	hl("@function", { fg = c.blue })
	hl("@function.call", { fg = c.blue })
	hl("@function.builtin", { fg = c.cyan })
	hl("@method", { fg = c.blue })
	hl("@keyword", { fg = c.magenta })
	hl("@keyword.function", { fg = c.magenta })
	hl("@keyword.return", { fg = c.magenta })
	hl("@keyword.operator", { fg = c.cyan })
	hl("@operator", { fg = c.cyan })
	hl("@conditional", { fg = c.magenta })
	hl("@repeat", { fg = c.magenta })
	hl("@exception", { fg = c.magenta })
	hl("@include", { fg = c.magenta })
	hl("@define", { fg = c.magenta })
	hl("@preproc", { fg = c.cyan })
	hl("@type", { fg = c.cyan, italic = true })
	hl("@type.builtin", { fg = c.cyan, bold = true })
	hl("@variable", { fg = c.fg })
	hl("@variable.builtin", { fg = c.red, italic = true })
	hl("@field", { fg = c.blue })
	hl("@property", { fg = c.blue })
	hl("@constant", { fg = c.yellow })
	hl("@constant.builtin", { fg = c.yellow, bold = true })
	hl("@constructor", { fg = c.cyan })
	hl("@namespace", { fg = c.cyan })
	hl("@tag", { fg = c.magenta })
	hl("@tag.attribute", { fg = c.blue })
	hl("@parameter", { fg = c.fg, italic = true })
	hl("@label", { fg = c.yellow })
	hl("@text.strong", { fg = c.fg, bold = true })
	hl("@text.emphasis", { fg = c.fg, italic = true })
	hl("@text.title", { fg = c.blue, bold = true })
	hl("@text.uri", { fg = c.blue, underline = true })
	hl("@text.todo", { fg = "#FFFFFF", bg = c.yellow, bold = true })
	hl("@diff.plus", { fg = c.green })
	hl("@diff.minus", { fg = c.red })
	hl("@diff.delta", { fg = c.yellow })

	-- LSP symbol kinds
	hl("@lsp.type.comment", { link = "Comment" })
	hl("@lsp.type.string", { link = "String" })
	hl("@lsp.type.number", { link = "Number" })
	hl("@lsp.type.keyword", { link = "@keyword" })
	hl("@lsp.type.function", { link = "@function" })
	hl("@lsp.type.variable", { link = "@variable" })
end

-- Define and register the scheme so `:colorscheme solstice_daylight` works too.
pcall(function()
	vim.api.nvim_set_hl(0, "Normal", {}) -- ensure hl namespace is warm
end)

return {
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = function()
				apply()
			end,
		},
	},
}