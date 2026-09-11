return {
  {
    "williamboman/mason.nvim",
    opts = { PATH = "prepend" },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "roslyn-language-server", "netcoredbg", "clangd", "codelldb" },
      auto_update = false,
      run_on_start = true,
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      automatic_enable = false,
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "SmiteshP/nvim-navic",
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")

      vim.lsp.commands["roslyn.client.peekReferences"] = function()
        vim.lsp.buf.references({ includeDeclaration = false })
      end
      if ok_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      vim.diagnostic.config({
        virtual_text = { spacing = 4, prefix = "●" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
      })

      vim.lsp.config("roslyn", {
        capabilities = capabilities,
        on_attach = require("owl.utils.lsp").on_attach,
        settings = {
          ["csharp|background_analysis"] = {
            dotnet_analyzer_diagnostics_scope = "openFiles",
            dotnet_compiler_diagnostics_scope = "openFiles",
          },
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
          ["csharp|completion"] = {
            dotnet_show_name_completion_suggestions = true,
            dotnet_provide_regex_completions = true,
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_trigger_completion_in_argument_lists = true,
          },
      },
      })

      vim.lsp.config("clangd", {
        capabilities = capabilities,
        on_attach = require("owl.utils.lsp").on_attach,
        cmd = { "clangd", "--background-index", "--clang-tidy" },
      })
      vim.lsp.enable("clangd")
    end,
  },
  {
    "seblyng/roslyn.nvim",
    opts = {
      filewatching = "roslyn",
      lock_target = true,
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind-nvim",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        window = {
          completion = cmp.config.window.bordered({ maxheight = 10 }),
          documentation = cmp.config.window.bordered({ maxheight = 15 }),
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "…",
            show_labelDetails = true,
            before = function(entry, vim_item)
              vim_item.menu = ({
                nvim_lsp = "[LSP]", luasnip = "[Snip]", buffer = "[Buf]", path = "[Path]",
              })[entry.source.name]
              return vim_item
            end,
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "nvim_lsp_signature_help" },
          { name = "luasnip", priority = 750 },
          { name = "path" },
        }, {
          { name = "buffer", keyword_length = 3, max_item_count = 5 },
        }),
      })

      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    config = function()
      local home = vim.fn.expand("~")
      local global_csharpier = home .. "/.dotnet/tools/csharpier"
      local mason_csharpier = vim.fn.stdpath("data") .. "/mason/bin/csharpier"

      local csharpier_cmd
      if vim.fn.executable(global_csharpier) == 1 then
        csharpier_cmd = global_csharpier
      elseif vim.fn.executable(mason_csharpier) == 1 then
        csharpier_cmd = mason_csharpier
      else
        csharpier_cmd = "csharpier"
      end

      require("conform").setup({
        formatters_by_ft = {
          cs = { "csharpier" },
          c = { "clang_format" },
          cpp = { "clang_format" },
        },
        formatters = {
          csharpier = {
            command = csharpier_cmd,
            args = { "format", "--stdin-path", "$FILENAME" },
            stdin = true,
          },
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "NicholasMata/nvim-dap-cs",
      "williamboman/mason.nvim",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      local netcoredbg_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"
      dap.adapters.coreclr = {
        type = "executable",
        command = netcoredbg_path,
        args = { "--interpreter=vscode" },
      }

      require("dap-cs").setup({ netcoredbg = { path = netcoredbg_path } })

      table.insert(dap.configurations.cs, {
        type = "coreclr",
        name = "Attach to Unity Editor (pick process)",
        request = "attach",
        processId = function()
          return require("dap.utils").pick_process({ filter = "Unity" })
        end,
      })

      local codelldb_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb_path,
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.c = {
        {
          name = "Launch (gcc build)",
          type = "codelldb",
          request = "launch",
          program = function()
            local file = vim.fn.expand("%:p")
            local out = vim.fn.expand("%:p:r")
            local cmd = "gcc -g " .. file .. " -o " .. out
            vim.fn.system(cmd)
            if vim.v.shell_error ~= 0 then
              vim.notify("Build failed!", vim.log.levels.ERROR)
              return ""
            end
            return out
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          name = "Launch (existing executable)",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          name = "Attach to process",
          type = "codelldb",
          request = "attach",
          pid = function()
            return require("dap.utils").pick_process()
          end,
          cwd = "${workspaceFolder}",
        },
      }
      dap.configurations.cpp = dap.configurations.c

      dapui.setup()
      require("nvim-dap-virtual-text").setup({ commented = true })

      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticSignWarn", linehl = "DapStoppedLine", numhl = "" })

      vim.keymap.set("n", "<F5>", function() dap.continue() end, { desc = "DAP continue" })
      vim.keymap.set("n", "<F10>", function() dap.step_over() end, { desc = "DAP step over" })
      vim.keymap.set("n", "<F11>", function() dap.step_into() end, { desc = "DAP step into" })
      vim.keymap.set("n", "<S-F11>", function() dap.step_out() end, { desc = "DAP step out" })
      vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Condition: ")) end, { desc = "Conditional breakpoint" })
      vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end, { desc = "REPL" })
      vim.keymap.set("n", "<leader>du", function() dapui.toggle() end, { desc = "DAP UI toggle" })
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "CitizenHarris/neotest-dotnet", branch = "main" },
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-dotnet")({
            dap = { justMyCode = false, adapter_name = "coreclr" },
            discovery_root = "solution",
          }),
        },
        diagnostic = { enabled = true },
        floating = { border = "rounded" },
      })
    end,
    keys = {
      { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file tests" },
      { "<leader>tn", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
      { "<leader>ts", function() require("neotest").run.stop() end, desc = "Stop tests" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Output" },
      { "<leader>tp", function() require("neotest").summary.toggle() end, desc = "Summary panel" },
    },
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      mode = "workspace_diagnostics",
      auto_close = false,
      auto_open = false,
      use_diagnostic_signs = true,
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (workspace)" },
      { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols" },
      { "<leader>xl", "<cmd>Trouble lsp toggle<cr>", desc = "LSP refs/defs" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix" },
    },
  },
}
