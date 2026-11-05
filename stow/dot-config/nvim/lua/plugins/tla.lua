return {
	{
		"susliko/tla.nvim",
		config = function()
			require("tla").setup()
		end,
	},
	{
		"florentc/vim-tla",
	},
	{
		"Julian/lean.nvim",
		event = {
			"BufReadPre *.lean",
			"BufNewFile *.lean",
		},
		opts = {
			mappings = true,
		},
	},
}
