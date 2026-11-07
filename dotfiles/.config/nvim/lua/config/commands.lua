vim.cmd([[
function! PrComplete(ArgLead, CmdLine, CursorPos)
  let l:options = ['create', 'merge', 'view']
  return join(filter(l:options, 'v:val =~ "^" . a:ArgLead'), "\n")
endfunction

function! CopyPathComplete(ArgLead, CmdLine, CursorPos)
  let l:options = ['abs', 'file', 'git']
  return join(filter(l:options, 'v:val =~ "^" . a:ArgLead'), "\n")
endfunction

function! CopyPathFunction(...)
  if a:0 == 0
    let @+ = getcwd()
    echo "Copied absolute working directory path to clipboard"
  elseif a:1 == 'file'
    let @+ = expand('%:p')
    echo "Copied absolute file path to clipboard"
  elseif a:1 == 'dir'
    let @+ = expand('%:p:h')
    echo "Copied directory path of current file to clipboard"
  elseif a:1 == 'git'
    let git_root = system('git rev-parse --show-toplevel 2>/dev/null')
    if v:shell_error
      echoerr "Not in a git repository"
    else
      let current_path = expand('%:p')
      let git_root = substitute(git_root, '\n\+$', '', '')
      let relative_path = substitute(current_path, '^' . escape(git_root, '/') . '/', '', '')
      let @+ = relative_path
      echo "Copied git-relative file path to clipboard"
    endif
  else
    echoerr "Invalid mode: " . a:1
  endif
endfunction

function! PrFunction(action)
  if a:action == 'create'
    execute 'terminal ' . g:pr_script . ' create'
  elseif a:action == 'merge'
    execute 'terminal ' . g:pr_script . ' merge'
  elseif a:action == 'view'
    execute '!' . g:pr_script . ' view'
  else
    echoerr "Invalid action: " . a:action
  endif
endfunction

function! GetVisualSelection()
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  let lines = getline(line_start, line_end)
  if len(lines) == 0
    return ''
  endif
  let lines[-1] = lines[-1][: column_end - 2]
  let lines[0] = lines[0][column_start - 1:]
  return join(lines, "\n")
endfunction
]])

function _G.TelescopeGrepString(input)
  require("telescope.builtin").grep_string({ search = input })
end

local cmds = {
  MouseToggle = { "if &mouse == 'a' | set mouse= | else | set mouse=a | endif", "Toggle mouse." },
  SpellToggle = { "if &spell | set nospell | else | set spell | endif", "Toggle spell check." },
  Eat = { 'silent %y+\necho "Copied file contents to clipboard"\n', "Copy file contents to clipboard." },
  PasteReplace = { "%d | put + | 0d | wall", "Replace file contents with clipboard." },
  ReplaceFileText = { "PasteReplace", "Replace file contents with clipboard (alias for PasteReplace)." },
  CopyPath = { "call CopyPathFunction()", "Copy absolute working directory path to clipboard" },
  CopyPathFile = { "call CopyPathFunction('file')", "Copy absolute file path to clipboard" },
  CopyPathDir = { "call CopyPathFunction('dir')", "Copy directory path of current file to clipboard" },
  CopyPathGit = { "call CopyPathFunction('git')", "Copy git-relative file path to clipboard" },
  PrCreate = { "call PrFunction('create')", "Create a new pull request" },
  PrMerge = { "call PrFunction('merge')", "Merge a pull request" },
  PrView = { "call PrFunction('view')", "View pull request files in browser" },
  E = {
    "e %:h/<args>",
    "Open a new file in the same directory as the current file",
    { nargs = 1, complete = "dir" },
  },
  EditInCurrentDir = {
    "E <args>",
    "Open a file in the same directory as the current file",
    { nargs = 1, complete = "dir" },
  },
  Files = { "Telescope find_files", "Find files using Telescope" },
  Buffers = { "Telescope buffers", "List buffers using Telescope" },
  Registers = { "Telescope registers", "List registers using Telescope" },
  GFiles = { "Telescope git_files", "Find git files using Telescope" },
  OFiles = { "Telescope oldfiles", "Find recently opened files using Telescope" },
  Rg = {
    "lua require('telescope.builtin').grep_string({ search = <q-args> })",
    "Search using ripgrep (static)",
    { nargs = "?" },
  },
  RG = { "Telescope live_grep", "Search using ripgrep (dynamic)" },
  WA = { "wa", "Write all buffers (typo alias for :wa)" },
  Xa = { "xa", "Save all and quit (typo alias for :xa)" },
  XA = { "xa", "Save all and quit (typo alias for :xa)" },
}

for name, spec in pairs(cmds) do
  local opts = vim.tbl_extend("force", { bang = true, bar = true, desc = spec[2] }, spec[3] or {})
  vim.api.nvim_create_user_command(name, spec[1], opts)
end
