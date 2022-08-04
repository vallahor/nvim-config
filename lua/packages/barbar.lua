local ok, bufferline = pcall(require, "bufferline")
if not ok then
	return
end
bufferline.setup({
    icons = false,
    animation = true,
    auto_hide = false,
    tabpages = true,
    closable = true,
    clickable = true,
    icon_custom_colors = false,

    icon_separator_active = '▎',
    icon_separator_inactive = '▎',
    icon_close_tab = '',
    icon_close_tab_modified = '',

    insert_at_end = false,
    insert_at_start = false,

    maximum_padding = 1,
    maximum_length = 30,

    semantic_letters = true,
    letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
    no_name_title = nil,
})
