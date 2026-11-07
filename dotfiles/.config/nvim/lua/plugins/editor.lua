require("nvim-lastplace").setup({})
require("nvim-autopairs").setup({})
require("illuminate").configure({
  filetypes_denylist = { "Outline", "TelescopePrompt", "alpha", "harpoon", "reason" },
  under_cursor = false,
})
require("auto-session").setup({})
require("octo").setup({})
require("obsidian").setup({
  frontmatter = { enabled = false },
  legacy_commands = false,
  ui = { enable = false },
  workspaces = { { name = "Notes", path = "~/Notes" } },
})
