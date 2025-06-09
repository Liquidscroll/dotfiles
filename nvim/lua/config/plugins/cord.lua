return {
  {
    'vyfor/cord.nvim',
    build = ':Cord update',
    opts = {
      log_level = vim.log.levels.TRACE,
      editor = {
        tooltip = 'coder codin codes',
      },
      display = {
        theme = 'atom',
      },
      idle = {
        state = 'probs afk',
      },
      buttons = {
        {
          label = function(opts)
            return opts.repo_url and 'View Repo' or 'View Repo'
          end,
          url = function(opts) return opts.repo_url or '' end,
        },
      },
    }
  }
}
