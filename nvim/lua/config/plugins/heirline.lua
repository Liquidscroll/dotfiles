return
{
  "rebelot/heirline.nvim",
  --  enabled = false,
  --  event = "UIEnter",
  dependencies = {
    "neovim/nvim-lspconfig",
    "tpope/vim-fugitive",
  },
  config = function(_, _)
    local colours = require("monokai-pro.colorscheme").base

    local heirline = require("heirline")
    local utils = require("heirline.utils")
    local conditions = require("heirline.conditions")

    vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "󰌵", texthl = "DiagnosticSignHint" })

    --  ==========================
    --     Statusline Components
    --  ==========================

    -- ViMode Component
    -- Displays the current mode (e.g., NORMAL, INSERT) with corresponding color
    local ViMode = {
      init = function(self)
        self.mode = vim.fn.mode(1)
      end,
      static = {
        mode_names = {
          n = "NORMAL",
          no = "NORMAL",
          nov = "NORMAL",
          noV = "NORMAL VISUAL LINE",
          ["no\22"] = "NORMAL VISUAL BLOCK",
          niI = "NORMAL INSERT",
          niR = "NORMAL REPLACE",
          niV = "NORMAL VISUAL",
          nt = "NORMAL TERMINAL",
          v = "VISUAL",
          vs = "VISUAL SELECT",
          V = "VISUAL LINE",
          Vs = "VISUAL LINE SELECT",
          ["\22"] = "VISUAL BLOCK",
          ["\22s"] = "VISUAL BLOCK SELECT",
          s = "SELECT",
          S = "SELECT LINE",
          ["\19"] = "SELECT BLOCK",
          i = "INSERT",
          ic = "INSERT",
          ix = "INSERT UNDO",
          R = "REPLACE",
          Rc = "REPLACE",
          Rx = "REPLACE UNDO",
          Rv = "VISUAL REPLACE",
          Rvc = "VISUAL REPLACE",
          Rvx = "VISUAL REPLACE UNDO",
          c = "COMMAND",
          cv = "EX MODE",
          r = "PROMPT",
          rm = "MORE PROMPT",
          ["r?"] = "CONFIRM",
          ["!"] = "SHELL",
          t = "TERMINAL",
        },
        mode_colors = {
          n = colours.white,
          i = colours.green,
          v = colours.purple,
          V = colours.purple,
          ["\22"] = colours.purple,
          c = colours.yellow,
          s = colours.yellow,
          S = colours.yellow,
          ["\19"] = colours.yellow,
          R = colours.red,
          r = colours.red,
          ["!"] = colours.red,
          t = colours.yellow,
        },
      },
      provider = function(self)
        return " " .. self.mode_names[self.mode] .. " "
      end,
      hl = function(self)
        local mode = self.mode:sub(1, 1)
        return { fg = self.mode_colors[mode], bold = true, bg = colours.none }
      end,
      update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
          vim.cmd("redrawstatus")
        end),
      },
    }

    -- FileNameBlock Component
    -- Displays the file's icon and name
    local FileNameBlock = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
      end,
    }

    -- FileIcon Component
    local FileIcon = {
      init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ":e")
        self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension,
          { default = true })
      end,
      provider = function(self)
        return self.icon and (self.icon .. " ")
      end,
      hl = function(self)
        return { fg = self.icon_color }
      end
    }

    -- FileName Component
    local FileName = {
      provider = function(self)
        local filename = vim.fn.fnamemodify(self.filename, ":p:~")
        if filename == "" then return "[No Name]" end

        -- Shorten the filename if it's too long
        if not conditions.width_percent_below(#filename, 0.25) then
          local comps = vim.split(filename, "[/\\]+")
          local new_comps = { comps[1], comps[2], "...", comps[#comps - 1], comps[#comps] }
          filename = table.concat(new_comps, "/")
        end
        return filename
      end,
      hl = { fg = colours.gray },
    }

    -- FileNameModifier Component
    -- Highlights the filename if the buffer is modified
    local FileNameModifier = {
      hl = function()
        if vim.bo.modified then
          return { fg = colours.white, bold = true, force = true }
        end
      end,
    }

    -- Combine FileNameBlock components
    FileNameBlock = utils.insert(FileNameBlock,
      FileIcon,
      utils.insert(FileNameModifier, FileName),
      { provider = '%<' }
    )

    -- Align Component
    local Align = { hl = { bg = colours.none }, provider = "%=" }

    -- Space Component
    local Space = { hl = { bg = colours.none }, provider = " ", }

    -- FileType Component
    local FileType = {
      provider = function()
        return string.upper(vim.bo.filetype)
      end,
      hl = { fg = colours.white, bold = true },
    }

    -- Ruler Component
    local Ruler = {
      provider = "%7(%l/%3L%):%2c %P",
      hl = { bg = colours.none },
    }

    -- LSPActive Component
    -- Displays the active LSP clients
    local LSPActive = {
      condition = conditions.lsp_attached,
      update = { 'LspAttach', 'LspDetach' },
      -- Or complicate things a bit and get the servers names
      provider = function()
        local names = {}
        for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
          table.insert(names, server.name)
        end
        return "[" .. table.concat(names, " ") .. "]"
      end,
      hl = { fg = "green", bold = true },
    }

    -- Diagnostics Component
    -- Displays diagnostic counts with icons
    local Diagnostics = {

      condition = conditions.has_diagnostics,

      static = {
        error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
        warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
        info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
        hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
      },

      init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      end,

      update = { "DiagnosticChanged", "BufEnter" },
      -- Error Section
      {
        condition = function(self) return self.errors > 0 end,
        {
          provider = function(self) return self.error_icon end,
          hl = { fg = colours.red, bg = colours.none },
        },
        {
          provider = function(self) return self.errors .. " " end,
          hl = { bg = colours.none },
        }
      },
      -- Warning Section
      {
        condition = function(self) return self.warnings > 0 end,
        {
          provider = function(self) return self.warn_icon end,
          hl = { fg = colours.orange, bg = colours.none },
        },
        {
          provider = function(self) return self.warnings .. " " end,
          hl = { bg = colours.none },
        }
      },
      -- Info Section
      {
        condition = function(self) return self.info > 0 end,
        {
          provider = function(self) return self.info_icon end,
          hl = { fg = colours.cyan, bg = colours.none },
        },
        {
          provider = function(self) return self.info .. " " end,
          hl = { bg = colours.none },
        }
      },
      -- Hint Section
      {
        condition = function(self) return self.hints > 0 end,
        {
          provider = function(self) return self.hint_icon end,
          hl = { fg = colours.green, bg = colours.none },
        },
        {
          provider = function(self) return self.hints .. " " end,
          hl = { bg = colours.none },
        }
      },
    }

    -- Git Component
    -- Displays the current Git branch
    local Git = {
      init = function(self)
        local status = vim.fn['FugitiveStatusline']()
        self.branch = status:match("%[Git%((.-)%)%]")
      end,
      hl = { fg = colours.yellow, bg = colours.none },
      {
        provider = function(self)
          if self.branch and self.branch ~= "" then
            return "|  " .. self.branch
          else
            return ''
          end
        end,
      }
    }

    -- WorkDir Component (not used)
    -- Displays the current working directory
    local WorkDir = {
      provider = function()
        local icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. " "
        local cwd = vim.fn.getcwd(0)
        cwd = vim.fn.fnamemodify(cwd, ":~")
        if not conditions.width_percent_below(#cwd, 0.25) then
          cwd = vim.fn.pathshorten(cwd)
        end
        local trail = cwd:sub(-1) == '/' and '' or "/"
        return icon .. cwd .. trail
      end,
      hl = { fg = "blue", bold = true },
    }

    -- TerminalName Component (not used)
    -- Displays the terminal name
    local TerminalName = {
      provider = function()
        local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
        return " " .. tname
      end,
      hl = { fg = "blue", bold = true },
    }

    --  ==========================
    --     Statusline Definition
    --  ==========================

    -- Default Statusline
    local DefaultStatusline = {
      condition = function()
        return vim.bo.buftype ~= "terminal" and vim.bo.filetype ~= "oil"
      end,
      hl = { bg = colours.none },
      ViMode,
      Space,
      Space,
      FileNameBlock,
      Space,
      Git,
      Align,
      FileType,
      Space,
      Space,
      Ruler
    }

    -- Inactive Statusline Component
    local InactiveStatusline = {
      condition = conditions.is_not_active,
      FileNameBlock,
      Align,
    }

    -- Special Statusline Component for special buffers
    local SpecialStatusline = {
      condition = function()
        return conditions.buffer_matches({
          buftype = { "nofile", "prompt", "help", "quickfix" },
          filetype = { "fugitive" },
        })
      end,
      FileType,
      Space,
      Align,
    }

    -- Complete StatusLine
    local StatusLine = {
      hl = { bg = colours.none },
      fallthrough = false,
      SpecialStatusline,
      InactiveStatusline,
      DefaultStatusline,
    }

    --  ==========================
    --     WinBar Definition
    --  ==========================

    local TermWinBar = {
      condition = function()
        return vim.bo.buftype == "terminal" and vim.api.nvim_win_get_config(0).relative ~= ""
      end,
      provider = "",
    }

    local OilWinBar = {
      condition = function()
        return vim.bo.filetype == "oil"
      end,
      provider = function()
        local cwd = vim.fn.getcwd()
        return " " .. cwd .. " "
      end,
      hl = { fg = colours.white },
    }

    local DefaultWinBar = {
      LSPActive, Space, Diagnostics, Align, hl = { bg = "none" },
    }

    local WinBar = {
      fallthrough = false,
      TermWinBar,
      OilWinBar,
      DefaultWinBar,
    }

    vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
      callback = function()
        if vim.bo.filetype == "oil" then
          require("oil.actions").cd.callback({ scope = nil, silent = true })
        end
      end,
    })

    --  ==========================
    --     Bufferline Components
    --  ==========================

    -- Initialise the buflist cache
    local buflist_num_cache = {}

    -- TablineBufnr Component
    -- Displays the buffer number
    local TablineBufnr = {
      provider = function(self)
        return tostring(buflist_num_cache[self.bufnr]) .. ". "
      end,
      hl = function(self)
        if self.is_active or self.is_visible then
          return { fg = colours.white, bg = colours.none }
        else
          return { fg = colours.light_gray, bg = colours.none }
        end
      end,
    }

    -- TablineFileName Component
    -- Displays the buffer's filename
    local TablineFileName = {
      provider = function(self)
        local filename = self.filename
        filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
        return filename
      end,
      hl = function(self)
        if self.is_active or self.is_visible then
          return { bold = true, fg = colours.white, bg = colours.none }
        else
          return { bold = false, fg = colours.light_gray, bg = colours.none }
        end
      end,
    }

    -- TabFileNameModifier Component
    -- Italicises the filename if the buffer is modified
    local TabFileNameModifer = {
      hl = function(self)
        if vim.api.nvim_get_option_value("modified", { buf = self.bufnr }) then
          -- use `force` because we need to override the child's hl foreground
          return { italic = true, force = true, }
        end
      end,
    }

    -- TablineFileFlags Component
    -- Displays lock icon for non-modifiable or readonly buffers
    local TablineFileFlags = {
      condition = function(self)
        return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
            or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
      end,
      provider = function(self)
        if vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) == "terminal" then
          return "  "
        else
          return ""
        end
      end,
      hl = { fg = colours.orange, },
    }

    -- TablineFileNameBlock Component
    -- Combines buffer components and handles clicks
    local TablineFileNameBlock = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(self.bufnr)
      end,
      hl = function(self)
        return {
          bg = colours.none,
          underline = self.is_active or self.is_visible,
          sp = colours.peanut,
          force = true,
        }
      end,
      on_click = {
        callback = function(_, minwid, _, button)
          if (button == "m") and not vim.api.nvim_get_option_value("modified", { buf = minwid }) then
            buflist_num_cache[minwid] = nil
            vim.schedule(function()
              vim.api.nvim_buf_delete(minwid, { force = false })
            end)
          else
            vim.api.nvim_win_set_buf(0, minwid)
          end
        end,
        minwid = function(self)
          return self.bufnr
        end,
        name = "heirline_tabline_buffer_callback",
      },
      TablineBufnr,
      FileIcon,
      utils.insert(TabFileNameModifer, TablineFileName),
      TablineFileFlags,
    }

    -- TablineCloseButton Component
    -- Close button for each buffer tab
    local TablineCloseButton = {
      Space,
      {
        provider = "󰅖 ",
        hl = { fg = colours.light_gray, bg = colours.none },
        on_click = {
          condition = function(self)
            return not vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
          end,
          callback = function(_, minwid)
            if not vim.api.nvim_get_option_value("modified", { buf = minwid }) then
              buflist_num_cache[minwid] = nil
              vim.schedule(function()
                vim.api.nvim_buf_delete(minwid, { force = true })
                vim.cmd.redrawtabline()
              end)
            end
          end,
          minwid = function(self)
            return self.bufnr
          end,
          name = "heirline_tabline_close_buffer_callback",
        },
      },
    }

    -- TablineBufferBlock Component
    -- Wraps the buffer components with separators
    local TablineBufferBlock = utils.surround({ "|" }, function(self)
      if self.is_active then
        return colours.peanut
      else
        return colours.gray
      end
    end, { TablineFileNameBlock, TablineCloseButton })

    -- Function to get buffers
    local get_bufs = function()
      return vim.tbl_filter(function(bufnr)
        local ft = vim.bo[bufnr].filetype
        if (ft == "oil") then return false end
        local bt = vim.bo[bufnr].buftype
        if (bt == "terminal") then return false end
        local listed = vim.bo[bufnr].buflisted
        return listed
        -- local bt = vim.api.nvim_buf_get_option_value("buftype", { buf = bufnr })
        -- local ft = vim.api.nvim_buf_get_option_value("filetype", { buf = bufnr })
        -- return vim.api.nvim_buf_get_option_value("buflisted", ) and bt ~= "terminal" and ft ~= "oil"
      end, vim.api.nvim_list_bufs())
    end
    -- return vim.tbl_filter(function(bufnr)
    --   return vim.api.nvim_get_option_value("buflisted", { buf = bufnr })
    -- end, vim.api.nvim_list_bufs())

    -- Initialise the buflist cache
    local buflist_cache = {}

    -- setup an autocmd that updates the buflist_cache every time that buffers are added/removed
    vim.api.nvim_create_autocmd({ "VimEnter", "UIEnter", "BufAdd", "BufDelete" }, {
      callback = function(opts)
        vim.schedule(function()
          local buffers = get_bufs()
          for i, v in ipairs(buffers) do
            buflist_cache[i] = v
            buflist_num_cache[v] = i
          end
          for i = #buffers + 1, #buflist_cache do
            buflist_cache[i] = nil
          end
        end)
      end,
    })

    -- TabLineOffset Component
    -- Adjusts the tabline offset for specific filetypes
    local TabLineOffset = {
      condition = function(self)
        local win = vim.api.nvim_tabpage_list_wins(0)[1]
        local bufnr = vim.api.nvim_win_get_buf(win)
        self.windid = win
        if vim.bo[bufnr].filetype == "neo-tree" then
          self.title = "Neo-Tree"
          return true
        else
          return false
        end
      end,
      provider = function(self)
        local title = self.title
        local width = vim.api.nvim_win_get_width(self.windid)
        local pad = math.ceil((width - #title) / 2)
        return string.rep(" ", pad) .. title .. string.rep(" ", pad)
      end,
      hl = function(self)
        if vim.api.nvim_get_current_win() == self.windid then
          return { fg = colours.white, bg = colours.none, underline = true } --"TablineSel"
        else
          return { fg = colours.light_gray, bg = colours.none }              --"Tabline"
        end
      end,
    }

    --  ==========================
    --     Bufferline Definition
    --  ==========================

    -- Assembles the bufferline with the defined components
    local BufferLine = { TabLineOffset, utils.make_buflist(
      TablineBufferBlock,
      { provider = "", hl = { fg = colours.gray, bg = colours.none } },
      { provider = "", hl = { fg = colours.gray, bg = colours.none } },
      function()
        return buflist_cache
      end,
      false
    ), Align }

    --  ==========================
    --     TabPage Definition (not used)
    --  ==========================

    -- Tabpage Component
    -- Represents a single tab page
    local Tabpage = {
      provider = function(self)
        return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
      end,
      hl = function(self)
        if not self.is_active then
          return "TabLine"
        else
          return "TabLineSel"
        end
      end,
    }

    -- TabpageClose Component
    -- Close button for tab pages
    local TabpageClose = {
      provider = "%999X  %X",
      hl = "TabLine",
    }

    -- TabPages Component
    -- Assembles the tab pages
    local TabPages = {
      -- only show this component if there's 2 or more tabpages
      condition = function()
        return #vim.api.nvim_list_tabpages() >= 2
      end,
      { provider = "%=" },
      utils.make_tablist(Tabpage),
      TabpageClose,
    }

    -- Initialize Heirline with the defined components
    heirline.setup({
      statusline = StatusLine,
      tabline = BufferLine,
      winbar = WinBar,
      opts = {
        -- if the callback returns true, the winbar will be disabled for that window
        -- the args parameter corresponds to the table argument passed to autocommand callbacks. :h nvim_lua_create_autocmd()
        disable_winbar_cb = function(args)
          return conditions.buffer_matches({
            buftype = { "nofile", "prompt", "help", "quickfix" },
            filetype = { "^git.*", "fugitive", "Trouble", "dashboard" },
          }, args.buf)
        end,
      },
    })

    -- Always show tabline
    vim.o.showtabline = 2

    -- Hide unlisted buffers
    vim.cmd([[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])

    -- Highlight overrides for StatusLine
    vim.cmd([[
            highlight StatusLine guibg=NONE
            highlight StatusLineNC guibg=NONE
        ]])

    -- Helper functions to find, change and close buffers
    local function find_curr_buffer(buffers)
      local curr_bufnr = vim.api.nvim_get_current_buf()
      for i, bufnr in ipairs(buffers) do
        if bufnr == curr_bufnr then
          return i
        end
      end
      return nil
    end

    local function change_buffer(direction)
      local buffers = buflist_cache
      local curr_idx = find_curr_buffer(buffers)

      if not curr_idx then
        return
      end

      local new_idx = (curr_idx + direction - 1) % #buffers + 1
      local new_bufnr = buffers[new_idx]
      vim.api.nvim_win_set_buf(0, new_bufnr)
    end

    local function close_buffer()
      local curr_bufnr = vim.api.nvim_get_current_buf()
      buflist_num_cache[curr_bufnr] = nil

      --change_buffer(-1)
      vim.schedule(function()
        vim.api.nvim_buf_delete(curr_bufnr, { force = true })
        -- vim.cmd.redrawtabline()
      end)
    end

    -- Keymaps to navigate buffers
    vim.keymap.set("n", "<Tab>", function()
      change_buffer(1)
    end, { noremap = true, silent = true })

    vim.keymap.set("n", "<S-Tab>", function()
      change_buffer(-1)
    end, { noremap = true, silent = true })

    vim.keymap.set("n", "<leader>c", function()
      close_buffer()
    end, { noremap = true, silent = true })
  end,
  opts = {
    disable_winbar_cb = function(args)
      return conditions.buffer_matches({
        buftype = { "oil_preview", "nofile", "prompt", "help", "quickfix" },
        filetype = { "^git.*", "fugitive", "Trouble", "dashboard" },
      }, args.buf)
    end,
  }
}
