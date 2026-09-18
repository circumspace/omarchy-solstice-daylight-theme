-- Solstice Daylight — Neovim theme for Omarchy (aether.nvim base16 engine).
-- Follows Omarchy's stock `beta`-theme contract so `theme-hotreload` can
-- live-swap it: a real plugin spec (spec[1] ≠ "LazyVim/LazyVim") + a STRING
-- opts.colorscheme resolvable by :colorscheme.
-- Palette: cream canvas, grey-lavender chrome, rose (#B04878) selection/accents.
--
-- aether only sets Visual at load (derived from an internal `blue0`, not base02)
-- and does NOT re-clobber it afterward, so we force the rose selection groups
-- synchronously right after applying the scheme, and re-apply on every future
-- ColorScheme event (Omarchy's live reload re-fires `:colorscheme aether`).
return {
	{
		"bjarneo/aether.nvim",
		name = "aether",
		priority = 1000,
		opts = {
			disable_italics = false,
			colors = {
				base00 = "#FAF5EC", -- bg: cream canvas
				base01 = "#E9E2D2",
				base02 = "#E4DCC7", -- cursorline (a step off cream)
				base03 = "#808898", -- comments (chrome-dim)
				base04 = "#585A6A", -- dark fg (muted)
				base05 = "#000000", -- fg (ink)
				base06 = "#20222A",
				base07 = "#AFB2C3", -- chrome
				base08 = "#C23D3D", -- red
				base09 = "#C2591E", -- orange
				base0A = "#C4983B", -- yellow
				base0B = "#4A7A5A", -- green (strings)
				base0C = "#5A8A8A", -- cyan
				base0D = "#4A6DA0", -- blue (functions)
				base0E = "#B04878", -- magenta (storage/cursor-word, rose)
				base0F = "#8B7355", -- brown
			},
		},
		config = function(_, opts)
			local rose, onrose = "#B04878", "#FFFFFF"
			local function force_selection()
				local hi = vim.api.nvim_set_hl
				hi(0, "Visual", { bg = rose, fg = onrose })
				hi(0, "VisualNOS", { bg = rose, fg = onrose })
				hi(0, "IncSearch", { bg = rose, fg = onrose, bold = true })
				hi(0, "MatchWord", { bg = rose, fg = onrose })
				hi(0, "MatchWordRef", { bg = rose, fg = onrose })
			end
			local grp = vim.api.nvim_create_augroup("solstice_daylight_selection", { clear = true })
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "aether",
				group = grp,
				callback = force_selection,
			})
			require("aether").setup(opts)
			vim.cmd.colorscheme("aether")
			force_selection()
		end,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "aether",
		},
	},
}