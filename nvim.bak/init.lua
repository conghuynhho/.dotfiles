require("huynh.plugins-setup")
require("huynh.core.options")
require("huynh.core.keymaps")
require("huynh.core.colorscheme")
require("huynh.plugins.comments")
require("huynh.plugins.nvim-tree")
require("huynh.plugins.lualine")
require("huynh.plugins.telescope")
require("huynh.plugins.nvim-cmp")
require("huynh.plugins.lsp.mason")
require("huynh.plugins.lsp.lspsaga")
require("huynh.plugins.lsp.lspconfig")
require("huynh.plugins.lsp.null-ls")
require("huynh.plugins.autopairs")
require("huynh.plugins.treesitter")
require("huynh.plugins.gitsigns")
require("huynh.plugins.toggleterm")
require("huynh.plugins.neoclip")
require("huynh.plugins.firenvim")
require("huynh.plugins.dashboard")
require("huynh.plugins.bufferline")
require("huynh.plugins.hop")
-- vim.lsp.start({
--   name = "lua-language-server",
--   cmd = { "lua-language-server" },
--   before_init = require("neodev.lsp").before_init,
--   root_dir = vim.fn.getcwd(),
--   settings = { Lua = {} },
-- })
