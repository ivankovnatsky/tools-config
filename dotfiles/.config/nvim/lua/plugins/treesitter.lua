-- Parsers are compiled locally: needs `tree-sitter` CLI (>= 0.26.1), curl, tar
-- and a C compiler on PATH.
local seed_parsers = {
  "bash",
  "diff",
  "fish",
  "git_config",
  "gitcommit",
  "go",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "nix",
  "python",
  "query",
  "regex",
  "rust",
  "toml",
  "typst",
  "vim",
  "vimdoc",
  "yaml",
}

local function can_build()
  return vim.fn.executable("tree-sitter") == 1 and vim.fn.executable("cc") == 1
end

local ts = require("nvim-treesitter")
ts.setup({})

if can_build() then
  ts.install(seed_parsers)
else
  vim.schedule(function()
    vim.notify("nvim-treesitter: tree-sitter CLI or cc missing, parsers not installed", vim.log.levels.WARN)
  end)
end

local available = {}
for _, lang in ipairs(ts.get_available()) do
  available[lang] = true
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("treesitter_setup", { clear = true }),
  callback = function(args)
    local buf = args.buf
    local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
    if not lang then
      return
    end
    if not vim.treesitter.language.add(lang) then
      if available[lang] and can_build() then
        ts.install({ lang })
      end
      return
    end
    if vim.treesitter.query.get(lang, "indents") ~= nil then
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.b[buf].undo_ftplugin = (vim.b[buf].undo_ftplugin and vim.b[buf].undo_ftplugin .. " | " or "")
        .. "setlocal indentexpr<"
    end
  end,
})

require("treesitter-context").setup({})
