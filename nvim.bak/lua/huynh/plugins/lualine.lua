-- import lualine plugin safely
-- https://github.com/nvim-lualine/lualine.nvim/blob/master/README.md
local status, lualine = pcall(require, "lualine")
if not status then
	return
end

-- get lualine nightfly theme
local lualine_nightfly = require("lualine.themes.nightfly")

local function current_buffer_number()
	return "﬘ " .. vim.api.nvim_get_current_buf()
end

local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

-- local function current_date() return string.sub(os.date "%x", 1, 5) end

local function current_working_dir()
	local cwd = string.sub(vim.fn.getcwd(), 18)
	return "~" .. cwd
end

-- new colors for theme
local new_colors = {
	blue = "#65D1FF",
	green = "#3EFFDC",
	violet = "#FF61EF",
	yellow = "#FFDA7B",
	black = "#000000",
}

-- change nightlfy theme colors
lualine_nightfly.normal.a.bg = new_colors.blue
lualine_nightfly.insert.a.bg = new_colors.green
lualine_nightfly.visual.a.bg = new_colors.violet
lualine_nightfly.command = {
	a = {
		gui = "bold",
		bg = new_colors.yellow,
		fg = new_colors.black, -- black
	},
}

-- configure lualine with modified theme
lualine.setup({
	options = {
		theme = lualine_nightfly,
		icons_enabled = true,
		component_separators = { left = "⦚", right = " ⦚" },
		section_separators = { left = " ", right = " " },
		disabled_filetypes = {},
		always_divide_middle = false,
		globalstatus = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = {
			{ "b:gitsigns_head", color = { fg = "#4aa6ff" }, icon = { "", color = { fg = "#f2891c" } } },
			{ "diff", source = diff_source },
			{ "diagnostics", sources = { "nvim_diagnostic" } },
		},
		lualine_c = {
			{ "filename", path = 4, symbols = { modified = "[]", readonly = " " } },
			{ "lsp_progress", display_components = { "lsp_client_name" } },
		},
		lualine_x = { { "filetype", icon_only = true } },
		lualine_y = {
			-- { current_buffer_number, color = { fg = "#A9A9A9" } },
			{ current_working_dir, color = { fg = "#A9A9A9" } },
			-- { current_date, color = { fg = "#A9A9A9" } },
		},
		lualine_z = { { "location", color = { fg = "#6d7275", bg = "#131313" } } },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { { "filename", path = 1, symbols = { modified = "[]", readonly = " " } } },
		lualine_x = { "location" },
		-- lualine_y = { { current_buffer_number, color = { fg = "#A9A9A9" } } },
		lualine_y = {},
		lualine_z = {},
	},
	extensions = {},
})
