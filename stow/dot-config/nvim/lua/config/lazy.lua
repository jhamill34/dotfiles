-- What do we want?
--   Plugin Manager (lazy?)
--   Fuzzy finding (snacks or telescope)
--   LSP (plugin or manual, I just need to learn how this works so I can add a custom one)
--   Auto Complete (blink)
--   Tree Sitter Highlighting
--   Terminal usage (quick floating?)
--   Formatting (conform)
--   Git or JJ integration (git-signs, lazygit, jj specific?)
--
-- Plugins that I already have
--   Which key
--   Todo comment highlighting
--   Neorg for notes
--   Mini.nvim has some stuff but we should figure out what
--   Harpoon for when I need adhoc quick switching
--   Undotree?
--   guess indent
--   Symbols outline
--   Snacks (explorer, fuzzy find, etc.)
--   Oil
--   Rust
--
-- Rarely used?
--  d2
--  dadbod (sql interface)
--  goyo (zen mode)
--

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ import = "plugins" },
}, {
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
