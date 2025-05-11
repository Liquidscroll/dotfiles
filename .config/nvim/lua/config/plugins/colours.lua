return {
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_background = true,
      background_clear = { "bufferline", "float_win", "telescope", "which-key" },
      plugins = { bufferline = { underline_selected = true, bold = false }, },
    },
    config = function(_, opts)
      local monokai = require("monokai-pro")
      monokai.setup(opts)
      monokai.load()
      vim.cmd.colorscheme "monokai-pro"
      -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
  },
  {
    'brenoprata10/nvim-highlight-colors',
    ft = "css, html",
    opts = {
      render = 'virtual',
      virtual_symbol_position = 'inline',
    }
  }
}
