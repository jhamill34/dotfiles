vim.api.nvim_create_user_command("LinkWithoutDate", function()
	local current_file = vim.fn.expand("%:p")
	if current_file == "" then
		print("No file currently open")
		return
	end

	local current_dir = vim.fn.expand("%:p:h")
	local current_basename = vim.fn.expand("%:t")
	local new_filename = "_" .. current_basename
	local new_path = current_dir .. "/" .. new_filename

	-- Check if target file already exists
	if vim.fn.filereadable(new_path) == 1 then
		print("File with underscore prefix already exists: " .. new_filename)
		return
	end

	-- Single shell command with proper escaping
	local cmd = string.format(
		"!f='%s' && dir='%s' && new_path='%s' && link_name=$(echo '%s' | sed 's/^[0-9]\\{4\\}-[0-9]\\{2\\}-[0-9]\\{2\\}_//') && mv \"$f\" \"$new_path\" && ln -s \"$new_path\" \"$dir/$link_name\" && echo \"Created: $new_path -> $link_name\"",
		current_file,
		current_dir,
		new_path,
		current_basename
	)

	vim.cmd(cmd)

	-- Reload the buffer with the new filename
	vim.cmd("edit " .. new_path)
end, {
	desc = "Rename current file with underscore prefix and create a symbolic link without date prefix",
})
