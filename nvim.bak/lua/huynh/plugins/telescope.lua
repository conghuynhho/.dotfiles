-- import telescope plugin safely
local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
	return
end

-- import telescope actions safely
local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
	return
end

-- import telescope zoxide utils safely
local zoxide_utils_setup, z_utils = pcall(require, "telescope._extensions.zoxide.utils")
if not zoxide_utils_setup then
	return
end

-- configure telescope
telescope.setup({
	-- configure custom mappings
	defaults = {
		layout_config = {
			width = 0.75,
			prompt_position = "top",
			preview_cutoff = 120,
			horizontal = { mirror = false },
			vertical = { mirror = false },
		},
		find_command = {
			"rg",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
		},
		prompt_prefix = " ",
		selection_caret = " ",
		entry_prefix = "  ",
		initial_mode = "insert",
		selection_strategy = "reset",
		sorting_strategy = "ascending",
		layout_strategy = "horizontal",
		file_sorter = require("telescope.sorters").get_fuzzy_file,
		file_ignore_patterns = {},
		generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
		path_display = {},
		winblend = 0,
		border = {},
		borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
		color_devicons = true,
		use_less = true,
		set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
		qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
		buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
				-- ["<esc>"] = actions.close,
				["<CR>"] = actions.select_default + actions.center,
			},
			n = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
			},
		},
	},
	extensions = {
		zoxide = {
			prompt_title = "[ Zoxide Change working directory ]",
			list_command = "zoxide query -ls",
			mappings = {
				default = {
					action = function(selection)
						vim.cmd.edit(selection.path)
					end,
					after_action = function(selection)
						print("Directory changed to " .. selection.path)
					end,
				},
				["<C-s>"] = { action = z_utils.create_basic_command("split") },
				["<C-v>"] = { action = z_utils.create_basic_command("vsplit") },
				["<C-e>"] = { action = z_utils.create_basic_command("edit") },
				-- ["<C-b>"] = {
				--   keepinsert = true,
				--   action = function(selection)
				--     builtin.file_browser({ cwd = selection.path })
				--   end
				-- },
				-- ["<C-f>"] = {
				--   keepinsert = true,
				--   action = function(selection)
				--     builtin.find_files({ cwd = selection.path })
				--   end
				-- },
				-- ["<C-t>"] = {
				--   action = function(selection)
				--     vim.cmd.tcd(selection.path)
				--   end
				-- },
			},
		},
		repo = {
			list = {
				fd_opts = {
					"--no-ignore-vcs", -- fd search function won't ignore folder was in gitignore
				},
				search_dirs = { "~/GGJ", "~/Personal", "~/Downloads", "~/.config" },
			},
		},
	},
})

telescope.load_extension("fzf")
telescope.load_extension("media_files")
telescope.load_extension("zoxide")
telescope.load_extension("neoclip")
telescope.load_extension("repo")
