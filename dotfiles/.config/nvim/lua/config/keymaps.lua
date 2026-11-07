local map = vim.keymap.set

map("n", "<C-h>", "<C-W>h", { silent = true, desc = "Move to window left" })
map("n", "<C-l>", "<C-W>l", { silent = true, desc = "Move to window right" })
map("n", "<C-k>", "<C-W>k", { silent = true, desc = "Move to window over" })
map("n", "<C-j>", "<C-W>j", { silent = true, desc = "Move to window bellow" })
map("n", "ZA", ":bd<CR>", { silent = true, desc = "Close buffer" })
map("n", "ZX", ":w | bd<CR>", { silent = true, desc = "Save and close buffer" })

local function live_grep_cword()
  require("telescope.builtin").live_grep({ default_text = vim.fn.expand("<cword>") })
end

local function find_files_cword()
  require("telescope.builtin").find_files({ default_text = vim.fn.expand("<cword>") })
end

-- TODO: visual-mode variants still use the word under cursor, not the selection.
map("n", "<leader>rg", live_grep_cword, { silent = true, desc = "Search word under cursor" })
map("v", "<leader>rg", live_grep_cword, { silent = true, desc = "Search word under cursor" })
map("n", "<leader>fi", find_files_cword, { silent = true, desc = "Find files with word under cursor" })
map("v", "<leader>fi", find_files_cword, { silent = true, desc = "Find files with selected text" })

-- Global Lspsaga maps; buffer-local vim.lsp.buf maps from config/lsp.lua take
-- precedence in buffers with an attached LSP client.
map("n", "gd", "<cmd>Lspsaga finder def<CR>", { silent = true, desc = "Goto Definition" })
map("n", "gr", "<cmd>Lspsaga finder ref<CR>", { silent = true, desc = "Goto References" })
map("n", "gI", "<cmd>Lspsaga finder imp<CR>", { silent = true, desc = "Goto Implementation" })
map("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true, desc = "Hover" })
map("n", "<leader>cw", "<cmd>Lspsaga outline<CR>", { silent = true, desc = "Outline" })
map("n", "<leader>cr", "<cmd>Lspsaga rename<CR>", { silent = true, desc = "Rename" })
map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true, desc = "Code Action" })
map("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true, desc = "Line Diagnostics" })
map("n", "[d", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true, desc = "Next Diagnostic" })
map("n", "]d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true, desc = "Previous Diagnostic" })

map({ "n", "v" }, "<leader>cf", "<cmd>lua vim.lsp.buf.format()<cr>", { silent = true, desc = "Format" })
