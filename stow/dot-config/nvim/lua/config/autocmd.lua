-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.filetype.add({
	extension = {
		beancount = "beancount",
		bean = "beancount",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "beancount" },
	callback = function()
		vim.o.tabstop = 2
		vim.o.shiftwidth = 2
		vim.o.expandtab = true
	end,
})
