-- Drop packpath entries bundled by wrapped nvim builds (e.g. nix's vim-pack-dir),
-- whose start/ plugins would shadow the vim.pack checkouts.
vim.opt.packpath = { vim.fn.stdpath("data") .. "/site", vim.env.VIMRUNTIME }

-- Must be registered before vim.pack.add() so hooks also run on first install.
vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("pack_hooks", { clear = true }),
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if kind ~= "install" and kind ~= "update" then
      return
    end

    -- Needs a C compiler (Xcode Command Line Tools).
    if name == "telescope-fzf-native.nvim" then
      local out = vim.system({ "make" }, { cwd = ev.data.path }):wait()
      if out.code ~= 0 then
        vim.notify("telescope-fzf-native: make failed\n" .. (out.stderr or ""), vim.log.levels.ERROR)
      end
    end

    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

local function gh(repo)
  return "https://github.com/" .. repo
end

vim.pack.add({
  gh("folke/tokyonight.nvim"),
  gh("dasupradyumna/midnight.nvim"),
  gh("nvim-lua/plenary.nvim"),
  gh("nvim-tree/nvim-web-devicons"),
  gh("MunifTanjim/nui.nvim"),

  gh("rafamadriz/friendly-snippets"),
  gh("onsails/lspkind.nvim"),
  gh("L3MON4D3/LuaSnip"),
  gh("hrsh7th/nvim-cmp"),
  gh("hrsh7th/cmp-nvim-lsp"),
  gh("hrsh7th/cmp-buffer"),
  gh("hrsh7th/cmp-path"),
  gh("hrsh7th/cmp-emoji"),
  gh("f3fora/cmp-spell"),
  gh("saadparwaiz1/cmp_luasnip"),

  gh("LnL7/vim-nix"),
  gh("axelf4/vim-strip-trailing-whitespace"),
  gh("tpope/vim-sensible"),
  gh("tpope/vim-sleuth"),
  gh("justinmk/vim-sneak"),
  gh("christoomey/vim-sort-motion"),
  gh("tpope/vim-eunuch"),
  gh("jghauser/mkdir.nvim"),
  gh("tpope/vim-repeat"),
  gh("tpope/vim-surround"),
  gh("tpope/vim-commentary"),
  gh("tpope/vim-fugitive"),
  gh("famiu/bufdelete.nvim"),
  gh("nvim-mini/mini.nvim"),
  gh("mbbill/undotree"),
  gh("fatih/vim-go"),
  gh("benoror/gpg.nvim"),
  gh("ethanholz/nvim-lastplace"),
  gh("windwp/nvim-autopairs"),
  gh("RRethy/vim-illuminate"),
  gh("rmagatti/auto-session"),
  gh("pwntester/octo.nvim"),
  gh("obsidian-nvim/obsidian.nvim"),

  gh("neovim/nvim-lspconfig"),
  gh("lukas-reineke/lsp-format.nvim"),
  gh("nvimtools/none-ls.nvim"),
  gh("stevearc/conform.nvim"),
  gh("nvimdev/lspsaga.nvim"),

  gh("nvim-telescope/telescope-fzf-native.nvim"),
  gh("nvim-telescope/telescope.nvim"),

  gh("nvim-treesitter/nvim-treesitter"),
  gh("nvim-treesitter/nvim-treesitter-context"),

  gh("nvim-lualine/lualine.nvim"),
  gh("folke/which-key.nvim"),
  gh("folke/trouble.nvim"),
  gh("j-hui/fidget.nvim"),
  gh("nvim-neo-tree/neo-tree.nvim"),
  gh("stevearc/oil.nvim"),
  gh("JezerM/oil-lsp-diagnostics.nvim"),
})

-- One failing setup (e.g. fzf-native not built) must not abort the rest of init.
for _, mod in ipairs({ "ui", "completion", "editor", "lsp", "telescope", "treesitter" }) do
  local ok, err = pcall(require, "plugins." .. mod)
  if not ok then
    vim.schedule(function()
      vim.notify("plugins." .. mod .. ": " .. err, vim.log.levels.ERROR)
    end)
  end
end
