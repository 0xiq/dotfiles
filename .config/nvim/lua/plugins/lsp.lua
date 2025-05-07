return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
  },

  config = function()
    -- Consistent ronding for boders
    vim.diagnostic.config({
      float = { border = "rounded" },
    })

    local cmp = require("cmp")
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )

    require("mason").setup()
    require("mason-lspconfig").setup({
      automatic_installation = false,
      ensure_installed = {
        "lua_ls",
        "svelte",
      },
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,
        ["svelte"] = function()
          require("lspconfig")["svelte"].setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              vim.api.nvim_create_autocmd("BufWritePost", {
                pattern = { "*.js", "*.ts" },
                callback = function(ctx)
                  -- this bad boy updates imports between svelte and ts/js files
                  client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
                end,
              })
            end,
          })
        end,
        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "Lua 5.1" },
                diagnostics = {
                  globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                },
              },
            },
          })
        end,
      },
    })
    local l = vim.lsp
    l.handlers["textDocument/hover"] = function(_, result, ctx, config)
      config = config or { border = "rounded", focusable = true }
      config.focus_id = ctx.method
      if not (result and result.contents) then
        return
      end
      local markdown_lines = l.util.convert_input_to_markdown_lines(result.contents)
      markdown_lines = vim.tbl_filter(function(line)
        return line ~= ""
      end, markdown_lines)
      if vim.tbl_isempty(markdown_lines) then
        return
      end
      return l.util.open_floating_preview(markdown_lines, "markdown", config)
    end

    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    vim.api.nvim_set_hl(0, "CmpNormal", {})
    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<S-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<S-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<S-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-e>"] = vim.NIL,
      }),

      window = {
        completion = {
          scrollbar = false,
          border = "rounded",
          winhighlight = "Normal:CmpNormal",
        },
        documentation = {
          scrollbar = false,
          border = "rounded",
          winhighlight = "Normal:CmpNormal",
        },
      },
      sources = cmp.config.sources({
        {
          name = "nvim_lsp",
          entry_filter = function(entry, ctx)
            return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
          end,
        },
      }, {}),
    })

    local autocmd = vim.api.nvim_create_autocmd
    autocmd({ "BufEnter", "BufWinEnter" }, {
      pattern = { "*.vert", "*.frag" },
      callback = function(e)
        vim.cmd("set filetype=glsl")
      end,
    })

    autocmd("LspAttach", {
      callback = function(e)
        local opts = { buffer = e.buf, remap = false }

        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = e.buf, desc = desc })
        end

        map("n", "gd", vim.lsp.buf.definition, "[LSP] Go to definition")
        map("n", "K", vim.lsp.buf.hover, "[LSP] Hover documentation")

        map("n", "<leader>lf", vim.lsp.buf.format, "[LSP] Format buffer")
        map("n", "<leader>la", vim.lsp.buf.code_action, "[LSP] Code action")
        map("n", "<leader>lr", vim.lsp.buf.rename, "[LSP] Rename symbol")

        map("n", "<leader>k", vim.diagnostic.open_float, "[Diagnostics] Open float")
        map("n", "<leader>ln", vim.diagnostic.goto_next, "[Diagnostics] Next diagnostic")
        map("n", "<leader>lp", vim.diagnostic.goto_prev, "[Diagnostics] Prev diagnostic")
      end,
    })
  end,
}
