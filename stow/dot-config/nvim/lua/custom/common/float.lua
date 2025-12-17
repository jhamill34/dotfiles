local M = {}

--- @class FloatingOpts
--- @field width integer?
--- @field height integer?
--- @field term boolean?
--- @field auto_enter boolean?
--- @field on_close (fun(lines: string[]))?

--- @class FloatingState
--- @field buf integer
--- @field win integer
--- @field job integer?

--- @class FloatingCls
--- @field opts FloatingOpts?
--- @field state FloatingState
local FloatingWindow = {}
FloatingWindow.__index = FloatingWindow

--- @param opts FloatingOpts
--- @return FloatingCls
function FloatingWindow.new(opts)
	opts = opts or {
		term = false,
	}

	--- @type FloatingCls
	local instance = {
		opts = opts,
		state = {
			buf = -1,
			win = -1,
			job = nil,
		},
	}

	setmetatable(instance, FloatingWindow)

	return instance
end

--- @return integer
local function create_buffer()
	local buf = vim.api.nvim_create_buf(false, true)

	-- auto close
	vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = buf })

	return buf
end

--- @return integer
local function setup_terminal()
	local job_id = vim.fn.jobstart(vim.o.shell, {
		term = true,
	})

	return job_id
end

function FloatingWindow:create()
	-- calculate dimensions
	local width = self.opts.width or math.floor(vim.o.columns * 0.5)
	local height = self.opts.height or math.floor(vim.o.lines * 0.5)

	-- calculate location
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	-- determine if we need to create a new buffer or not
	local buf = nil
	if vim.api.nvim_buf_is_valid(self.state.buf) then
		buf = self.state.buf
	else
		buf = create_buffer()

		self.state.buf = buf

		if self.opts.term then
			self.state.job = vim.api.nvim_buf_call(buf, setup_terminal)
		end
	end

	-- define window configuration
	local win_config = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
	}

	local auto_enter = true
	if self.opts.auto_enter ~= nil then
		auto_enter = self.opts.auto_enter
	end

	-- Actually display the window
	self.state.win = vim.api.nvim_open_win(buf, auto_enter, win_config)

	if self.opts.on_close ~= nil then
		vim.api.nvim_create_autocmd("BufWinLeave", {
			buffer = buf, -- Only trigger for THIS specific buffer
			callback = function()
				-- 1. Get all lines from the buffer
				local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
				self.opts.on_close(lines)
			end,
			once = true, -- Ensure the autocommand cleans itself up after running
		})
	end
end

function FloatingWindow:hide()
	vim.api.nvim_win_hide(self.state.win)
end

function FloatingWindow:toggle()
	if not vim.api.nvim_win_is_valid(self.state.win) then
		self:create()
	else
		self:hide()
	end
end

--- @param cmd string[]
function FloatingWindow:send(cmd)
	if self.state.job ~= nil then
		vim.fn.chansend(self.state.job, cmd)
	end
end

M.new_floating_window = FloatingWindow.new

return M
