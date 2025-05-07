vim.g.mapleader = " "

-- yank to clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])

-- yank line to clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]])
