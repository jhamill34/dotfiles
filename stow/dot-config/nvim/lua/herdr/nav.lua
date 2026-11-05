-- vim-herdr-navigation — Neovim side
--
-- Seamless <C-h/j/k/l> navigation between Neovim splits and herdr panes: move
-- between Neovim splits, and at a split edge hand off to herdr so focus crosses
-- into the neighbouring herdr pane. When not inside herdr it falls back to tmux
-- (if any) or plain wincmd, so a tmux setup keeps working.
--
-- Load it so it wins over other <C-h/j/k/l> mappings (e.g. vim-tmux-navigator).
-- The simplest reliable way is to drop it in your config's after/plugin dir:
--   cp editor/nvim.lua ~/.config/nvim/after/plugin/herdr_nav.lua
-- or source it from your config after plugins load:
--   dofile("/path/to/vim-herdr-navigation/editor/nvim.lua")

local function nav(wincmd, dir)
	local prev = vim.api.nvim_get_current_win()
	vim.cmd("wincmd " .. wincmd)
	if vim.api.nvim_get_current_win() ~= prev then
		return -- moved within Neovim
	end
	-- At a split edge: cross into the surrounding multiplexer.
	-- The Herdr app (herdr-core terminals) comes first: its terminals can inherit a
	-- stale HERDR_PANE_ID that points at the TUI.
	if vim.env.HC_TERMINAL_ID and vim.env.HC_TERMINAL_ID ~= "" and vim.fn.executable("herdr-app") == 1 then
		-- In the background, so Neovim never waits on it. A Kanso strip shows panes as layout
		-- blocks, which pane.go refuses: then the strip's own move.
		vim.fn.jobstart({
			"sh", "-c", 'herdr-app do pane.go --direction "$1" >/dev/null 2>&1 || herdr-app do "kanso-strip.go-$1" >/dev/null 2>&1',
			"sh", dir,
		}, { detach = true })
	elseif vim.env.HERDR_PANE_ID and vim.env.HERDR_PANE_ID ~= "" then
		local herdr = vim.env.HERDR_BIN_PATH
		if herdr == nil or herdr == "" then
			herdr = "herdr"
		end
		-- Target this pane explicitly: `--current` resolves to the server's
		-- globally focused pane, which is not necessarily the one we are in.
		vim.fn.system({ herdr, "pane", "focus", "--direction", dir, "--pane", vim.env.HERDR_PANE_ID })
	elseif vim.env.TMUX and vim.env.TMUX ~= "" then
		local tmux = { left = "Left", down = "Down", up = "Up", right = "Right" }
		pcall(vim.cmd, "TmuxNavigate" .. tmux[dir])
	end
end

local function map(lhs, wincmd, dir, desc)
	vim.keymap.set("n", lhs, function()
		nav(wincmd, dir)
	end, { silent = true, noremap = true, desc = desc })
end

map("<C-h>", "h", "left", "Navigate left (vim/herdr)")
map("<C-j>", "j", "down", "Navigate down (vim/herdr)")
map("<C-k>", "k", "up", "Navigate up (vim/herdr)")
map("<C-l>", "l", "right", "Navigate right (vim/herdr)")

-- The Herdr app takes <C-h/j/k/l> itself (its vim-nav mod). For a Neovim pane it calls
-- HerdrNav over this instance's RPC socket, which `hc label` publishes on the terminal
-- (herdr.nvim=<socket>): typing the key with `hc keys` instead waits until the person
-- seems to have stopped typing, seconds right after a :split.
local WINCMD = { left = "h", down = "j", up = "k", right = "l" }
function _G.HerdrNav(dir)
	if WINCMD[dir] then nav(WINCMD[dir], dir) end
end

local term = vim.env.HC_TERMINAL_ID
if term and term ~= "" and vim.v.servername ~= "" and vim.fn.executable("hc") == 1 then
	vim.fn.jobstart({ "hc", "label", term, "herdr.nvim=" .. vim.v.servername }, { detach = true })
	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function() vim.fn.jobstart({ "hc", "label", term, "herdr.nvim=" }, { detach = true }) end,
	})
end
