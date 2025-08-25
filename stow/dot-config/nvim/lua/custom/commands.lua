vim.api.nvim_create_user_command("LinkWithoutDate", function(opts)
	local current_file = vim.fn.expand("%:p")
	if current_file == "" then
		print("No file currently open")
		return
	end

	local target_dir = opts.args ~= "" and opts.args or vim.fn.expand("%:p:h")
	local cmd = string.format(
		[[f='%s'; ln -s "$f" "%s/$(basename "$f" | sed 's/^[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}_//')"]],
		current_file,
		target_dir
	)
	vim.cmd("!" .. cmd)
end, {
	nargs = "?",
	desc = "Create a symbolic link to current file without the date prefix. Optional: specify target directory",
})
