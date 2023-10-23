function CloseOtherWindow(direction)
	local old_win = vim.api.nvim_get_current_win()
	vim.cmd(string.format("wincmd %s", direction))
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_set_current_win(old_win)
	if #vim.api.nvim_list_wins() > 1 then
		vim.api.nvim_win_close(win, false)
	end
end

function Close_left()
	CloseOtherWindow("h")
end

function Close_down()
	CloseOtherWindow("j")
end

function Close_up()
	CloseOtherWindow("k")
end

function Close_right()
	CloseOtherWindow("l")
end

function _G.put(arg)
	vim.print(arg)
end
