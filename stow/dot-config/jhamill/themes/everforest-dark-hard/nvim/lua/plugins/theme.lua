return {
	{
		-- You can easily change to a different colorscheme.
		-- Change the name of the colorscheme plugin below, and then
		-- change the command in the config to whatever the name of that colorscheme is.
		--
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
		"sainnhe/everforest",
		name = "everforest",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		config = function()
			vim.g.everforest_background = "hard"
			vim.g.everforest_better_performance = 1
			vim.g.everforest_transparent_background = 1
			vim.o.background = "dark"

			-- Load the colorscheme here.
			vim.cmd.colorscheme("everforest")
		end,
	},
}
