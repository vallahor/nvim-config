local ok, heirline = pcall(require, "heirline")
if not ok then
	return
end

local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local Align = { provider = "%=" }
local Space = { provider = " " }

local FileNameBlock = {
	-- let's first set up some attributes needed by this component and it's children
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
}

local FileName = {
	provider = function(self)
		local filename = vim.fn.fnamemodify(self.filename, ":.")
		if filename == "" then
			return "[No Name]"
		end
		if not conditions.width_percent_below(#filename, 0.25) then
			filename = vim.fn.pathshorten(filename)
		end
		return filename
	end,
}

local FileFlags = {
	{
		provider = function()
			if vim.bo.modified then
				return "[+]"
			end
		end,
	},
	{
		provider = function()
			if not vim.bo.modifiable or vim.bo.readonly then
				return "[RO]"
			end
		end,
	},
}

local FileType = {
	provider = function()
		return " [" .. string.upper(vim.bo.filetype) .. "]"
	end,
}

local FileFormat = {
	provider = function()
		local fmt = vim.bo.fileformat
		return " [" .. fmt:upper() .. "]"
	end,
}

FileNameBlock = utils.insert(
	FileNameBlock,
	Space,
	utils.insert(FileName), -- a new table where FileName is a child of FileNameModifier
	Space,
	{ provider = "%<" }
)

local Git = {
	condition = conditions.is_git_repo,

	init = function(self)
		self.status_dict = vim.b.gitsigns_status_dict
		self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
	end,

	{ -- git branch name
		provider = function(self)
			return " [" .. self.status_dict.head .. "]"
		end,
	},
}

local viMode = {
	init = function(self)
		self.mode = vim.fn.mode(1) -- :h mode()

		-- execute this only once, this is required if you want the ViMode
		-- component to be updated on operator pending mode
		if not self.once then
			vim.api.nvim_create_autocmd("ModeChanged", { command = "redrawstatus" })
			self.once = true
		end
	end,
	static = {
		mode_names = {
			n = "N",
			no = "N?",
			nov = "N?",
			noV = "N?",
			["no\22"] = "N?",
			niI = "Ni",
			niR = "Nr",
			niV = "Nv",
			nt = "Nt",
			v = "V",
			vs = "Vs",
			V = "V_",
			Vs = "Vs",
			["\22"] = "^V",
			["\22s"] = "^V",
			s = "S",
			S = "S_",
			["\19"] = "^S",
			i = "I",
			ic = "Ic",
			ix = "Ix",
			R = "R",
			Rc = "Rc",
			Rx = "Rx",
			Rv = "Rv",
			Rvc = "Rv",
			Rvx = "Rv",
			c = "C",
			cv = "Ex",
			r = "...",
			rm = "M",
			["r?"] = "?",
			["!"] = "!",
			t = "T",
		},
	},
	provider = function(self)
		return "[" .. self.mode_names[self.mode] .. "]"
	end,
	update = "ModeChanged",
}

local Ruler = {
	-- %l = current line number
	-- %L = number of lines in the buffer
	-- provider = "%7(%l/%3L%)",
	provider = "%7(%l/%L%)",
}

local statusline = {
	viMode,
	Git,
	FileNameBlock,
	FileFlags,
	{ provider = "%=" },
	Ruler,
	FileType,
	FileFormat,
}

heirline.setup(statusline)
