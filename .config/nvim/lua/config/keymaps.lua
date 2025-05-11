-- These are done immediately before configuring lazy.nvim.
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<leader><leader>xs", "<cmd>source %<CR>")
vim.keymap.set("n", "<leader>xs", ":.lua<CR>")
vim.keymap.set("v", "<leader>xs", ":lua<CR>")

vim.keymap.set("n", "\\", "<cmd>Ex<CR>")

-- Using Neo-Tree instead
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open Project View" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection down" })

vim.keymap.set("x", "<leader>p", "\"_dP", { desc = "Replace word with selection" })

vim.keymap.set("n", "<leader>y", "\"+y", { desc = "Copy selection to system clipboard" })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = "Copy selection to system clipboard" })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "Copy selection to system clipboard" })

vim.keymap.set("n", "<leader>d", "\"_d", { desc = "Delete without copying" })
vim.keymap.set("v", "<leader>d", "\"_d", { desc = "Delete without copying" })

vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "" })

vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>", { desc = "" })
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>", { desc = "" })

-- These mappings control the size of splits (height/width)
vim.keymap.set("n", "<M-,>", "<c-w>5<")
vim.keymap.set("n", "<M-.>", "<c-w>5>")
vim.keymap.set("n", "<M-t>", "<C-W>+")
vim.keymap.set("n", "<M-s>", "<C-W>-")
