local opts = {
  autoread = true,
  autowrite = true,
  backup = false,
  breakindent = true,
  cmdheight = 0,
  completeopt = { "menuone", "noselect", "noinsert" },
  cursorline = true,
  encoding = "utf-8",
  expandtab = true,
  fileencoding = "utf-8",
  foldcolumn = "0",
  foldenable = true,
  foldlevel = 99,
  foldlevelstart = 99,
  foldmethod = "marker",
  grepformat = "%f:%l:%c:%m",
  grepprg = "rg --vimgrep --smart-case",
  hlsearch = true,
  ignorecase = true,
  incsearch = true,
  lazyredraw = true,
  -- Empty mouse keeps terminal-native selection for copy-paste.
  mouse = "",
  number = true,
  relativenumber = true,
  scrolloff = 8,
  shiftwidth = 2,
  showcmd = true,
  showmatch = true,
  showmode = true,
  smartcase = false,
  smartindent = true,
  softtabstop = 2,
  swapfile = false,
  tabstop = 2,
  termguicolors = true,
  undofile = true,
  updatetime = 50,
  wrap = true,
}

for k, v in pairs(opts) do
  vim.opt[k] = v
end

vim.opt.path = ".,"
vim.opt.path:append("**")

vim.opt.langmap = "йq,цw,уe,кr,еt,нy,гu,шi,щo,зp,х[,ї],"
  .. "фa,іs,вd,аf,пg,рh,оj,лk,дl,ж\\;,є',ґ\\\\,яz,чx,сc,мv,иb,тn,ьm,б\\,,ю.,"
  .. "ЙQ,ЦW,УE,КR,ЕT,НY,ГU,ШI,ЩO,ЗP,Х{,Ї},ФA,"
  .. 'ІS,ВD,АF,ПG,РH,ОJ,ЛK,ДL,Ж\\:,Є\\",Ґ\\|,ЯZ,ЧX,СC,МV,ИB,ТN,ЬM,Б\\<,Ю>,№#'

vim.g.copilot_filetypes = {
  gitcommit = true,
  markdown = true,
  yaml = true,
}

vim.g.pr_script = "gh-pr"
