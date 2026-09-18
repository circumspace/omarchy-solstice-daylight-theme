-- Solstice Daylight — Neovim theme for Omarchy (aether.nvim base16 engine).
-- Follows Omarchy's stock contract (see the `beta` theme) so the built-in
-- `theme-hotreload` autocmd can unload + re-apply it on theme switch:
--   * a real plugin spec (spec[1] ≠ "LazyVim/LazyVim") gives a theme_plugin_name
--   * opts.colorscheme is a STRING ("aether") — resolvable by :colorscheme
--   * aether.hotreload wires it to Omarchy's LazyReload event
-- Colors are the Solaris 9 CDE light palette: cream canvas, chrome grey-lavender,
-- rose (#B04878) for selection + keyword/storage accents.
return {
	{
		"bjarneo/aether.nvim",
		name = "aether",
		priority = 1000,
		opts = {
			disable_italics = false,
			colors = {
				base00 = "#FAF5EC", -- bg: cream canvas
				base01 = "#E9E2D2", -- status / strong surfaces
				base02 = "#B04878", -- SELECTION background (rose)
				base03 = "#808898", -- comments / invisibles (chrome-dim)
				base04 = "#585A6A", -- dark foreground (muted)
				base05 = "#000000", -- default foreground (ink)
				base06 = "#20222A", -- light foreground
				base07 = "#AFB2C3", -- light background (chrome)

				base08 = "#C23D3D", -- red: variables / errors
				base09 = "#C2591E", -- orange: integers / constants
				base0A = "#C4983B", -- yellow: classes / types
				base0B = "#4A7A5A", -- green: strings
				base0C = "#5A8A8A", -- cyan: support / regex
				base0D = "#4A6DA0", -- blue: functions / keywords
				base0E = "#B04878", -- magenta: storage / cursor-word (rose)
				base0F = "#8B7355", -- brown: deprecated
			},
		},
		config = function(_, opts)
			require("aether").setup(opts)
			vim.cmd.colorscheme("aether")
			require("aether.hotreload").setup()
		end,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "aether",
		},
	},
}