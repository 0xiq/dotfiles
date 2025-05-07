-- Use spaces instead of tabs
vim.cmd("set expandtab") 

-- Number of spaces tabs count for
vim.cmd("set tabstop=2")

-- Number of spaces tabs count for in editing operations
vim.cmd("set softtabstop=2")

-- Size of an indent
vim.cmd("set shiftwidth=2")

-- line numbers
vim.cmd("set number")
vim.cmd("set relativenumber")

vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.backup = false
vim.opt.ignorecase = true
vim.opt.undofile = true
vim.opt.incsearch = true
vim.opt.scrolloff = 8


--text width for md files
vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = { '*.md' },
  callback = function()
    vim.opt.textwidth = 80
  end,
})

-- Set transparent background
vim.cmd [[
  highlight Normal ctermbg=none guibg=none
  highlight NonText ctermbg=none guibg=none
  highlight LineNr guibg=none
  highlight SignColumn guibg=none
  highlight EndOfBuffer guibg=none
]]

-- tmux cursor settings
vim.opt.guicursor = {
  "n-v-c-sm:block-blinkwait300-blinkon200-blinkoff150",  -- normal/visual/command = block
  "i-ci-ve:ver25-blinkwait300-blinkon200-blinkoff150",   -- insert/command‑insert = bar
  "r-cr-o:hor20"                                         -- replace etc. = underline
}

vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    vim.opt.guicursor = "a:ver25-blinkwait300-blinkon200-blinkoff150"
  end,
})

vim.g.mapleader= " "

