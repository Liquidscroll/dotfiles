return {
  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'brenoprata10/nvim-highlight-colors'
    },
    lazy = false,
    version = '1.*',
    -- build = 'cargo build --release',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
        ['<C-w>'] = { 'select_prev', 'fallback' },
        ['<C-s>'] = { 'select_next', 'fallback' },
        ['<C-q>'] = { 'accept', 'fallback' },
        ['<Tab>'] = {},
        ['<S-Tab>'] = {},
        ['<Up>'] = {},
        ['<Down>'] = {},
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },

      signature = { enabled = true },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            fallbacks = { 'lsp' },
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        }
      },
      completion = {
        menu = {
          draw = {
            components = {
              kind_icon = {
                text = function(ctx)
                  local icon = ctx.kind_icon
                  if ctx.item.source_name == "LSP" then
                    local colour_item = require("nvim-highlight-colors")
                        .format(ctx.item.documentation, { kind = ctx.kind })
                    if colour_item and colour_item.abbr ~= "" then
                      icon = colour_item.abbr
                    end
                  end
                  return icon .. ctx.icon_gap
                end,
                highlight = function(ctx)
                  local highlight = "BlinkCmpKind" .. ctx.kind
                  if ctx.item.source_name == "LSP" then
                    local colour_item = require("nvim-highlight-colors")
                        .format(ctx.item.documentation, { kind = ctx.kind })
                    if colour_item and colour_item.abbr_hl_group then
                      highlight = colour_item.abbr_hl_group
                    end
                  end
                  return highlight
                end,
              }
            }
          }
        }
      }
    },
  },
}
