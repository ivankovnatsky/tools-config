require("lsp-format").setup({})

local null_ls = require("null-ls")
null_ls.setup({
  on_attach = require("lsp-format").on_attach,
  sources = {
    null_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }),
    null_ls.builtins.formatting.fish_indent,
    null_ls.builtins.formatting.stylua,
  },
  update_in_insert = false,
})

require("conform").setup({
  format_on_save = { lsp_fallback = true, timeout_ms = 500 },
  formatters_by_ft = { rust = { "rustfmt" } },
  notify_on_error = true,
})

require("lspsaga").setup({
  beacon = { enable = true },
  code_action = {
    extend_gitsigns = false,
    keys = { exec = "<CR>", quit = { "<Esc>", "q" } },
    num_shortcut = true,
    only_in_cursor = true,
    show_server_name = true,
  },
  diagnostic = { border_follow = true, diagnostic_only_current = false, show_code_action = true },
  hover = { open_cmd = "!open", open_link = "gx" },
  implement = { enable = false },
  lightbulb = { enable = false, sign = false, virtual_text = true },
  outline = {
    auto_close = true,
    auto_preview = true,
    close_after_jump = true,
    keys = { jump = "e", quit = "q", toggle_or_jump = "o" },
    layout = "normal",
    win_position = "right",
  },
  rename = { auto_save = false, keys = { exec = "<CR>", quit = { "<C-k>", "<Esc>" }, select = "x" } },
  scroll_preview = { scroll_down = "<C-f>", scroll_up = "<C-b>" },
  symbol_in_winbar = { enable = true },
  ui = { border = "rounded", code_action = "💡" },
})
