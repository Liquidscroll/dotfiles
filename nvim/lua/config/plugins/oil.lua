return {
  {
    'stevearc/oil.nvim',
    lazy = false,
    dependencies = {
      "loctvl842/monokai-pro.nvim",
      "nvim-tree/nvim-web-devicons"
    },
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {

    },
    config = function()
      local colours = require("monokai-pro.colorscheme").base
      -- vim.api.nvim_set_hl(0, 'OilConfWin', { bg = colours.dimmed5 })
      -- vim.api.nvim_set_hl(0, 'OilConfShad', { bg = "none" })
      require("oil").setup({
        win_options = { foldcolumn = "0" },
        buf_options = { buflisted = true, },
        view_options = {
          show_hidden = true,
        },
        watch_for_changes = true,
        -- confirmation = {
        --   win_options = {
        --     winhl =
        --     "Normal:OilConfWin,NormalFloat:OilConfWin,Float:OilConfWin,FloatBorder:OilConfWin,FloatShadow:OilConfShad,FloatShadowThrough:OilConfShad",
        --   }
        -- }
      })
      vim.keymap.set("n", "\\", "<cmd>Oil<CR>", { desc = "Open Oil" })

      local oil_dir_highlights = {
        "OilDir",
        "OilDirHidden",
        "OilDirIcon",
      }

      for _, hl in ipairs(oil_dir_highlights) do
        vim.api.nvim_set_hl(0, hl, { bg = "none", fg = colours.dimmed2 })
        -- vim.cmd("highlight " .. hl .. " guibg=none guifg=" .. colours.dimmed2)
      end

      -- for _, group in pairs(vim.fn.getcompletion("DevIcon", "highlight")) do
      --   vim.cmd("highlight " .. group .. " guibg=none guifg=" .. colours.dimmed1)
      -- end
    end,
  }
}
