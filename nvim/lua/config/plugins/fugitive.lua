return {
  "tpope/vim-fugitive",
  config = function()
    vim.keymap.set("n", "gf", "<cmd>diffget //2<CR>")
    vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
  end
}
