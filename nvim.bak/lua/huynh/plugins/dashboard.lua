-- import dashboard plugin safely
-- https://github.com/nvimdev/dashboard-nvim
local dashboard_status, dashboard = pcall(require, "dashboard")
if not dashboard_status then
	print("dashboard  not found")
	return
end

dashboard.setup({
	theme = "hyper",
	config = {
		week_header = {
			enable = true,
		},
		shortcut = {
			{ desc = " Update", group = "@property", action = "PackerSync", key = "u" },
			{
				-- icon = " ",
				icon = " ",
				icon_hl = "@variable",
				desc = "Files",
				group = "Label",
				action = "Telescope find_files",
				key = "f",
			},
			{
				desc = " Recents",
				group = "unknown",
				action = "Telescope oldfiles",
				key = "o",
			},
			{
				desc = " Repo",
				group = "Number",
				action = "Telescope repo list",
				key = "r",
			},
			{
				desc = " dotfiles",
				group = "Number",
				action = function()
					require("telescope.builtin").find_files({
						prompt_title = "Find dotfiles and my config files",
						-- cwd = { "~/.config", "~/Personal/config.huynh" },
						search_dirs = { "~/.config", "~/Personal/config.huynh" },
					})
				end,
				key = "d",
			},
		},
	},
})
