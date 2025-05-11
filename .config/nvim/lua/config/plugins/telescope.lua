return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      local telescope = require('telescope.builtin')


      vim.keymap.set("n", "<leader>fh", telescope.help_tags, { desc = "Telescope: Open help" })
      vim.keymap.set("n", "<leader>fd", telescope.find_files, { desc = "Telescope: Find Files" })
      vim.keymap.set("n", "<leader>fc", function() telescope.find_files { cwd = vim.fn.stdpath("config") } end,
        { desc = "Telescope: Find Files in Neovim Config" })

      require "config.plugins.telescope.multigrep".setup()
    end,
  }
}
