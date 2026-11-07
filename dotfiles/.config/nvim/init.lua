vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

vim.g.mapleader = " "

require("config.options")
require("config.pack")
require("config.keymaps")
require("config.commands")
require("config.lsp")
require("config.autocmds")
require("config.appearance")
require("auto-capitalize")
