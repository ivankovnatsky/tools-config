vim.lsp.log.set_level("off")

local border = "rounded"

vim.diagnostic.config({ float = { border = border } })

local function on_attach(client, bufnr)
  require("lsp-format").on_attach(client, bufnr)
end

-- Re-run on_attach when a server registers capabilities dynamically
-- (e.g. formatting) after the initial attach.
vim.lsp.handlers["client/registerCapability"] = (function(overridden)
  return function(err, res, ctx, ...)
    local result = overridden(err, res, ctx, ...)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if client then
      for bufnr, _ in pairs(client.attached_buffers) do
        on_attach(client, bufnr)
      end
    end
    return result
  end
end)(vim.lsp.handlers["client/registerCapability"])

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_on_attach", { clear = false }),
  desc = "Run LSP onAttach",
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client then
      on_attach(client, event.buf)
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_binds", { clear = true }),
  desc = "Load keymaps for LspAttach",
  callback = function(args)
    local binds = {
      {
        "<leader>cd",
        vim.diagnostic.open_float,
        "Line Diagnostics",
      },
      {
        "[d",
        function()
          vim.diagnostic.jump({ count = 1, float = true })
        end,
        "Next Diagnostic",
      },
      {
        "]d",
        function()
          vim.diagnostic.jump({ count = -1, float = true })
        end,
        "Previous Diagnostic",
      },
      { "<leader>cr", vim.lsp.buf.rename, "Rename" },
      { "<leader>cw", vim.lsp.buf.workspace_symbol, "Workspace Symbol" },
      { "K", vim.lsp.buf.hover, "Hover" },
      { "gD", vim.lsp.buf.declaration, "Goto Declaration" },
      { "gI", vim.lsp.buf.implementation, "Goto Implementation" },
      { "gd", vim.lsp.buf.definition, "Goto Definition" },
      { "gr", vim.lsp.buf.references, "Goto References" },
    }
    for _, b in ipairs(binds) do
      vim.keymap.set("n", b[1], b[2], { buffer = args.buf, silent = true, desc = b[3] })
    end
  end,
})

local capabilities =
  vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), require("cmp_nvim_lsp").default_capabilities())

local servers = {
  gopls = {},
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        runtime = { version = "LuaJIT" },
        telemetry = { enable = false },
        workspace = {
          checkThirdParty = false,
          library = { "$(runtimepath)/lua", vim.env.VIMRUNTIME .. "/lua" },
        },
      },
    },
  },
  nil_ls = {
    settings = {
      ["nil"] = {
        diagnostics = { excludedFiles = { "" } },
        formatting = { command = { "nixfmt" } },
        nix = {
          binary = "nix",
          flake = { autoArchive = true, autoEvalInputs = false, nixpkgsInputName = "nixpkgs" },
          maxMemoryMB = 2048,
        },
      },
    },
  },
  pyright = {},
  rust_analyzer = {},
  tinymist = {},
}

for name, cfg in pairs(servers) do
  vim.lsp.config(name, vim.tbl_extend("keep", cfg, { capabilities = capabilities }))
  vim.lsp.enable(name)
end
