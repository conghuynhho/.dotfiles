vim.api.nvim_create_autocmd({ "UIEnter" }, {
	callback = function(event)
		local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
		if client ~= nil and client.name == "Firenvim" then
			vim.o.guifont = "JetBrainsMonoNL Nerd Font:h20"
			vim.cmd("command! -nargs=1 SetFS set guifont=JetBrainsMonoNL\\ Nerd\\ Font:h<args>")
			-- vim.o.guifont = "CaskaydiaCove Nerd Font:h40"
		end
	end,
})

vim.g.firenvim_config = {
	-- globalSettings = { alt = "all" },
	localSettings = {
		[".*"] = {
			cmdline = "neovim",
			content = "text",
			priority = 0,
			selector = "textarea",
			takeover = "never",
		},
	},
}
