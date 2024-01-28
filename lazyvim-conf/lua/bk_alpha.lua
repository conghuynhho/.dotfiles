return {
  "goolord/alpha-nvim",
  opts = function(_, opts)
    -- acsii art generator: https://fsymbols.com/generators/carty/
    -- https://patorjk.com/software/taag/#p=display&v=0&f=ANSI%20Shadow&t=
    local logo = [[
          ██╗  ██╗██╗   ██╗██╗   ██╗███╗  ██╗██╗  ██╗          Z
          ██║  ██║██║   ██║╚██╗ ██╔╝████╗ ██║██║  ██║      Z
          ███████║██║   ██║ ╚████╔╝ ██╔██╗██║███████║   z
          ██╔══██║██║   ██║  ╚██╔╝  ██║╚████║██╔══██║ z
          ██║  ██║╚██████╔╝   ██║   ██║ ╚███║██║  ██║
          ╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚═╝  ╚══╝╚═╝  ╚═╝
      ]]

    opts.section.header.val = vim.split(logo, "\n", { trimemptry = true })
    opts.section.buttons.val = {
      -- opts.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
      opts.button("f", "󰱼 " .. " Find file", ":Telescope find_files <CR>"),
      opts.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
      opts.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
      opts.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
      opts.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
      opts.button("s", " " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
      -- opts.button("l", "" .. " Lazy", ":Lazy<CR>"),
      opts.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
      opts.button("q", " " .. " Quit", ":qa<CR>"),
    }
  end,
}
