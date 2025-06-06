-- Highlight when yanking
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text.',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

-- Line Number Settings
vim.opt.nu = true             -- Enable line numbers
vim.opt.relativenumber = true -- Enable relative line numbers

-- Tab and Indentation Settings
vim.opt.tabstop = 4        -- Number of spaces a tab counts for
vim.opt.softtabstop = 4    -- Number of spaces for a Tab in insert mode
vim.opt.shiftwidth = 4     -- Number of spaces used for autoindent
vim.opt.expandtab = true   -- Convert tabs to spaces
vim.opt.smartindent = true -- Enable smart indentation

-- Text Wrapping Settings
vim.opt.wrap = false -- Disable line wrapping

-- File Backup and Swap Settings
if vim.fn.has('win32') == 1 then
  vim.opt.undodir = os.getenv("USERPROFILE") .. "\\.vim\\undodir"     -- Set undo directory on Windows
  vim.opt.backupdir = os.getenv("USERPROFILE") .. "\\.vim\\backupdir" -- Set backup directory on Windows
  vim.opt.directory = os.getenv("USERPROFILE") .. "\\.vim\\swap"      -- Set swap directory on Windows
else
  vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"              -- Set undo directory on Unix
  vim.opt.backupdir = os.getenv("HOME") .. "/.vim/backupdir"          -- Set backup directory on Unix
  vim.opt.directory = os.getenv("HOME") .. "/.vim/swap"               -- Set swap directory on Unix
end

vim.opt.undofile = true -- Enable persistent undo
vim.opt.swapfile = true -- Enable swap file
vim.opt.backup = true   -- Enable file backup

-- Split Settings
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Search Settings
vim.opt.hlsearch = false -- Disable search highlighting
vim.opt.incsearch = true -- Enable incremental search

-- UI Settings
vim.opt.colorcolumn = "101"        -- Highlight column at position 101
vim.opt.cursorline = true          -- Highlight the current line
vim.opt.termguicolors = true       -- Enable true color support
vim.opt.scrolloff = 10             -- Keep 10 lines visible above and below the cursor
vim.opt.display:append("lastline") -- Ensure last line is always displayed
vim.opt.signcolumn = "yes"         -- Show the sign column (for diagnostics, Git, etc.)
vim.opt.isfname:append("@-@")      -- Include '@-' as a filename character

-- Performance Settings
vim.opt.updatetime = 50 -- Faster completion (default is 4000 ms)

-- Netrw Settings
vim.g.netrw_browse_split = 0 -- Open files in the same window
vim.g.netrw_winsize = 25     -- Set netrw window size

-- Other Settings
vim.opt.hidden = true -- Allow buffer switching without saving
vim.opt.clipboard:prepend { 'unnamedplus' }


vim.filetype.add {
  extension = {
    njk = 'html',
  },
}
