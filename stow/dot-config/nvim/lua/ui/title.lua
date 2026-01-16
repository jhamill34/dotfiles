local jhamill = [[
     ██╗██╗  ██╗ █████╗ ███╗   ███╗██╗██╗     ██╗     
     ██║██║  ██║██╔══██╗████╗ ████║██║██║     ██║     
     ██║███████║███████║██╔████╔██║██║██║     ██║     
██   ██║██╔══██║██╔══██║██║╚██╔╝██║██║██║     ██║     
╚█████╔╝██║  ██║██║  ██║██║ ╚═╝ ██║██║███████╗███████╗
 ╚════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝╚══════╝╚══════╝ ]]

local M = {}

function M.get_header()
	local user = vim.fn.expand("$USER")
	if user == "josh.hamill.-nd" then
		return mickey .. "\n\n" .. dclm_dev
	end

	return jhamill
end

return M
