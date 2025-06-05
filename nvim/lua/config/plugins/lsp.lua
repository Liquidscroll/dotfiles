return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load lucit types when the `vim.uv` word if ound
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            { path = "wezterm-types",      mods = { "wezterm" } },
            { plugins = { "nvim-dap-ui" }, types = true }
          },
        },
      },
      { 'saghen/blink.cmp' },
    },
    config = function()
      local lspconfig = require('lspconfig')
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local on_attach = function(_, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        -- Go to the definition of the symbol under the cursor
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to Definition", unpack(opts) })
        -- Show information about the symbol under the cursor
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Show Hover Information", unpack(opts) })
        -- Go to the implementation of the symbol under the cursor
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = "Go to Implementation", unpack(opts) })
        -- Rename all references to the symbol under the cursor
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename Symbol", unpack(opts) })
        -- Show available code actions for the current cursor position
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Code Action", unpack(opts) })
        -- List all references to the symbol under the cursor
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = "Find References", unpack(opts) })
        -- Format the current buffer asynchronously
        vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end,
          { desc = "Format Buffer", unpack(opts) })
      end

      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            runtime = { version = "Lua 5.1" },
            diagnostics = {
              globals = { "bit", "vim", "it", "describe", "before_each", "after_each", "wezterm" },
            },
            workspace = {
              library = {
                vim.fn.expand('$VIMRUNTIME/lua'),
                vim.fn.stdpath('config') .. '/lua',
                require('lazy.core.config').options.root .. '/lazy.nvim/lua',
                require('lazy.core.config').options.root .. '/wezterm-types',
              },
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          }
        }
      }

      lspconfig.clangd.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { 'clangd', '--background-index', '--clang-tidy', '--log=verbose' },
        init_options = {
          fallbackFlags = { '-std=c++17' },
        },
      }

      lspconfig.zls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
        settings = {
          zls = {
            enable_inlay_hints = true,
            enable_snippets = true,
            warn_style = true,
          },
        },
      }

      lspconfig.rust_analyzer.setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      lspconfig.pylsp.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          pylsp = {

            plugins = {
              -- ── completions ────────────────────────────────────────────
              jedi_completion = { enabled = true, include_params = true },
              jedi_definition = { enabled = true },
              jedi_hover      = { enabled = true },

              -- ── import / refactor tools (rope) ─────────────────────────
              rope_completion = { enabled = true },

              -- ── lint / type check (optional but nice) ─────────────────
              ruff            = { enabled = true },
              yapf            = { enabled = true },

              -- ── formatting & style ────────────────────────────────────
              pycodestyle     = {
                ignore = { "W391" },
                maxLineLength = 100,
              },
            },
          },
        },
      }

      lspconfig.hyprls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      lspconfig.bashls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      lspconfig.cssls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      lspconfig.taplo.setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      lspconfig.neocmake.setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      vim.g.zig_fmt_parse_errors = 0
      vim.g.zig_fmt_autosave = 1

      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end

          if client:supports_method('textDocument/formatting') then
            -- Format the current buffer on save
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end,
            })
          end
        end,
      })

      vim.diagnostic.config({
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = true,
          header = "",
          prefix = "",
        },
      })
      local opts = { noremap = true, silent = true, } --[[buffer = bufnr]] -- }
      -- Go to the definition of the symbol under the cursor
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Go to Definition", unpack(opts) })
      -- Show information about the symbol under the cursor
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Show Hover Information", unpack(opts) })
      -- Go to the implementation of the symbol under the cursor
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = "Go to Implementation", unpack(opts) })
      -- Rename all references to the symbol under the cursor
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename Symbol", unpack(opts) })
      -- Show available code actions for the current cursor position
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Code Action", unpack(opts) })
      -- List all references to the symbol under the cursor
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = "Find References", unpack(opts) })
      -- Format the current buffer asynchronously
      vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end,
        { desc = "Format Buffer", unpack(opts) })
    end,
  }
}
