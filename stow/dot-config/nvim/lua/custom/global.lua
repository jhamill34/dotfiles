-- Set <space> as the leader key
-- See `:help mapleader`
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false
vim.g.python3_host_prog = vim.env.PYENV_ROOT .. "/versions/neovim-venv-3.11.13/bin/python3"

vim.filetype.add({
	extension = {
		ferrocount = "ferrocount",
		beancount = "ferrocount",
		bean = "ferrocount",
	},
})
