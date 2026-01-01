return {
	{
		-- You can easily change to a different colorscheme.
		-- Change the name of the colorscheme plugin below, and then
		-- change the command in the config to whatever the name of that colorscheme is.
		--
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("catppuccin").setup({
				transparent_background = true,
				show_end_of_buffer = true,
				integrations = {
					fidget = true,
				},
			})

			-- Load the colorscheme here.
			-- Like many other themes, this one has different styles, and you could load
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
	},
}
