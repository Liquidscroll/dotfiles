return {
  {
    "nvim-lua/plenary.nvim",
  },
  {
    'Aasim-A/scrollEOF.nvim',
    event = { 'CursorMoved', 'WinScrolled' },
    opts = {},
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true,
    opts = {
      disable_filetype = { "TelescopePrompt", "oil" },
    },
  },
}
