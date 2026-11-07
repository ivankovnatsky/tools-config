vim.api.nvim_set_hl(0, "Comment", { italic = true })

vim.api.nvim_create_autocmd("BufReadPre", {
  desc = "Disable Copilot for large files",
  callback = function()
    local file_size = vim.fn.getfsize(vim.fn.expand("<afile>"))
    if file_size > 100000 or file_size == -2 then
      vim.b.copilot_enabled = false
    end
  end,
})

vim.api.nvim_create_augroup("fmt", { clear = true })

local filetypes = {
  dhall = "ts=2 sts=2 sw=2 expandtab",
  jsonnet = "ts=2 sts=2 sw=2 expandtab",
  helm = "commentstring=#\\ %s",
}

for filetype, settings in pairs(filetypes) do
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup(filetype, { clear = true }),
    pattern = filetype,
    command = "setlocal " .. settings,
  })
end

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = vim.api.nvim_create_augroup("custom_filetype", { clear = true }),
  pattern = "*.typ",
  command = "set filetype=typst",
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  command = "checktime",
})
