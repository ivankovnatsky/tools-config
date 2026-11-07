require("nvim-web-devicons").setup({})
require("lualine").setup({ sections = { lualine_b = { "diff", "diagnostics" } } })
require("which-key").setup({})
require("trouble").setup({})
require("fidget").setup({})
require("neo-tree").setup({
  filesystem = {
    filtered_items = { hide_by_name = { ".git" }, hide_dotfiles = false, show_hidden_count = false },
  },
})
require("oil").setup({ view_options = { show_hidden = true } })
require("oil-lsp-diagnostics").setup({})
