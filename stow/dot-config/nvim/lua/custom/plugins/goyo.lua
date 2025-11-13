return {
	{
		"junegunn/goyo.vim",
		config = function()
			vim.g.goyo_width = 120

			vim.keymap.set("n", "<leader>z", ":Goyo<CR>")
		end,
	},
}
