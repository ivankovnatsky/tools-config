local telescope = require("telescope")
telescope.setup({
  defaults = {
    layout_config = { width = 0.9 },
  },
})
telescope.load_extension("fzf")
