return {
  {
    "nvim-lua/plenary.nvim",
    lazy = false,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    lazy = false,
    config = function()
      require("telescope").setup({})
    end,
  },
  
  {
    "mbbill/undotree",
    cmd = {
      "UndotreeToggle",
    },
  },

  {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
          local harpoon = require("harpoon")

          harpoon:setup()

          vim.keymap.set("n", "<leader>A", function()
              harpoon:list():prepend()
          end)
          vim.keymap.set("n", "<leader>a", function()
              harpoon:list():add()
          end)
          vim.keymap.set("n", "<C-e>", function()
              harpoon.ui:toggle_quick_menu(harpoon:list())
          end)

          vim.keymap.set("n", "<leader>1", function()
              harpoon:list():select(1)
          end)
          vim.keymap.set("n", "<leader>2", function()
              harpoon:list():select(2)
          end)
          vim.keymap.set("n", "<leader>3", function()
              harpoon:list():select(3)
          end)
          vim.keymap.set("n", "<leader>4", function()
              harpoon:list():select(4)
          end)
          vim.keymap.set("n", "<leader>5", function()
              harpoon:list():select(5)
          end)
      end,
  },

   {
       'stevearc/oil.nvim',
       ---@module 'oil'
       ---@type oil.SetupOpts
       opts = { show_hidden = true, watch_for_changes = true },
      -- Optional dependencies
      dependencies = { { "nvim-mini/mini.icons", opts = {} } },
      -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
      -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
      lazy = false,
  },

  {
    "tpope/vim-fugitive",
    cmd = {
      "Git",
      "G",
    },
  },

  {
      "chentoast/marks.nvim",
      event = { "BufReadPre", "BufNewFile" },
      opts = {},
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        signs = {
            add          = { text = '┃' },
            change       = { text = '┃' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = '┆' },
        },
        signs_staged = {
            add          = { text = '┃' },
            change       = { text = '┃' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = '┆' },
        },
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 300,
        ignore_whitespace = true,
      },
      current_line_blame_formatter = " <author>, <author_time:%R> - <summary>",
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, "Next hunk")
        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, "Prev hunk")
        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>hd", gs.diffthis, "Diff this")
        map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff this (~)")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk (inner)")
      end,
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local ibl = require("ibl")
      ibl.setup({
        indent = {
          char = "│",
          tab_char = "│",
          smart_indent_cap = false,
        },
        scope = {
          enabled = true,
          show_start = true,
          show_end = false,
        },
        exclude = {
          filetypes = { "help", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
        },
      })

      vim.api.nvim_create_autocmd("BufWritePost", {
        callback = function(args)
          ibl.refresh(args.buf)
        end,
      })
    end,
  },

  {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach",
    config = function()
      local function h(name)
        return vim.api.nvim_get_hl(0, { name = name })
      end

      vim.api.nvim_set_hl(0, "SymbolUsageContent", { fg = h("Comment").fg, italic = true })
      vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = h("Function").fg, italic = true })
      vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = h("Type").fg, italic = true })
      vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = h("@keyword").fg, italic = true })

      local function text_format(symbol)
        local res = {}

        local stacked = symbol.stacked_count > 0 and ("+%s"):format(symbol.stacked_count) or ""

        if symbol.references then
          local usage = symbol.references <= 1 and "usage" or "usages"
          local num = symbol.references == 0 and "no" or symbol.references
          table.insert(res, { ("󰌹 %s %s"):format(num, usage), "SymbolUsageRef" })
        end

        if symbol.definition then
          if #res > 0 then
            table.insert(res, { "  ", "NonText" })
          end
          table.insert(res, { ("󰳽 %s defs"):format(symbol.definition), "SymbolUsageDef" })
        end

        if symbol.implementation then
          if #res > 0 then
            table.insert(res, { "  ", "NonText" })
          end
          table.insert(res, { ("󰡱 %s impls"):format(symbol.implementation), "SymbolUsageImpl" })
        end

        if stacked ~= "" then
          if #res > 0 then
            table.insert(res, { "  ", "NonText" })
          end
          table.insert(res, { (" %s"):format(stacked), "SymbolUsageImpl" })
        end

        return res
      end

      local SymbolKind = vim.lsp.protocol.SymbolKind

      require("symbol-usage").setup({
        text_format = text_format,
        kinds = {
          SymbolKind.Function,
          SymbolKind.Method,
          SymbolKind.Constructor,
          SymbolKind.Field,
          SymbolKind.Property,
          SymbolKind.Event,
          SymbolKind.Class,
          SymbolKind.Struct,
          SymbolKind.Interface,
          SymbolKind.Enum,
        },
        references = { enabled = true },
        definition = { enabled = false },
        implementation = { enabled = true },
      })

      vim.api.nvim_create_autocmd("FileChangedShellPost", {
        callback = function()
          local M = require("symbol-usage")
          local state = require("symbol-usage.state")
          local buf = vim.api.nvim_get_current_buf()
          local workers = state and state.get_buf_workers(buf) or {}
          if #workers == 0 then
            pcall(M.refresh)
            return
          end
          for _, w in ipairs(workers) do
            pcall(w.run, w, true)
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    priority = 1000,
    build = ":TSUpdate",
    config = function()
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if ok then
        configs.setup({
          ensure_installed = { "c_sharp", "c", "cpp", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
          sync_install = false,
          auto_install = true,
          highlight = { enable = true },
          indent = { enable = true },
        })
      end
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        theme = "auto",
        section_separators = "",
        component_separators = "",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = { enabled = true },
        hover = { enabled = true },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
  },

  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = { window = { winblend = 0 } },
      progress = { display = { done_ttl = 2 } },
    },
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = true,
        disable_filetype = { "TelescopePrompt", "fugitive", "git" },
        fast_wrap = { map = "<M-w>" },
      })

      local ok_cmp, cmp = pcall(require, "cmp")
      if ok_cmp then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },

  {
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
    config = function()
      require("nvim-navic").setup({
        icons = {
          Class = "∘ ", Method = "ƒ ", Property = "■ ",
          Field = "□ ", Constructor = "⬡ ", Enum = "_enum ",
          Interface = " intf ", Function = " func ", Variable = " var ",
          Constant = " const ", String = " s ", Number = " n ",
          Boolean = " b ", Array = " arr ", Object = " obj ",
          Key = " k ", Null = " null ", EnumMember = " em ",
          Struct = " st ", Event = " ev ", Operator = " op ",
          TypeParameter = " tp ",
        },
        highlight = true,
        separator = " › ",
        depth_limit = 0,
      })

      local links = {
        NavicIconsFile = "Comment",
        NavicIconsClass = "Type",
        NavicIconsMethod = "Function",
        NavicIconsProperty = "Property",
        NavicIconsField = "Field",
        NavicIconsConstructor = "Function",
        NavicIconsEnum = "Type",
        NavicIconsInterface = "Type",
        NavicIconsFunction = "Function",
        NavicIconsVariable = "Variable",
        NavicIconsConstant = "Constant",
        NavicIconsString = "String",
        NavicIconsNumber = "Number",
        NavicIconsBoolean = "Boolean",
        NavicIconsArray = "Type",
        NavicIconsObject = "Type",
        NavicIconsKey = "Identifier",
        NavicIconsNull = "Special",
        NavicIconsEnumMember = "Constant",
        NavicIconsStruct = "Type",
        NavicIconsEvent = "Function",
        NavicIconsOperator = "Operator",
        NavicIconsTypeParameter = "Type",
        NavicText = "Comment",
        NavicSeparator = "Comment",
      }
      for name, target in pairs(links) do
        vim.api.nvim_set_hl(0, name, { link = target, default = true })
      end
    end,
    init = function()
      vim.o.winbar = "%#NavicSeparator#%{&nu?'  ':'  '}%#NavicText#%f%{v:lua.require'nvim-navic'.is_available()?' › ':''}%#NavicIconsFile#%{v:lua.require'nvim-navic'.get_location()}"
    end,
  },

  {
    "ahmedkhalf/project.nvim",
    opts = {
      patterns = { ".sln", ".csproj", ".git", "_darcs", "Makefile", "package.json" },
      detection_chdir = 1,
      silent_chdir = true,
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)

      local project = require("project_nvim.project")
      project.find_lsp_root = function()
        local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
        local clients = vim.lsp.get_clients and vim.lsp.get_clients({ bufnr = 0 }) or vim.lsp.buf_get_clients()
        if next(clients) == nil then
          return nil
        end
        for _, client in pairs(clients) do
          local filetypes = client.config.filetypes
          if filetypes and vim.tbl_contains(filetypes, buf_ft) then
            if not vim.tbl_contains(require("project_nvim.config").options.ignore_lsp, client.name) then
              return client.config.root_dir, client.name
            end
          end
        end
        return nil
      end

      vim.api.nvim_create_user_command("CdRoot", function()
        vim.cmd("cd " .. (require("project_nvim.project").get_root(vim.fn.expand("%:p")) or "."))
      end, {})
    end,
},
{
    "sphamba/smear-cursor.nvim",
    opts = {
        smear_between_buffers = true,
        smear_between_neighbor_lines = true,
        legacy_computing_symbols_support = false,
        trailing_stiffness = 0.8,
        distance_stop_animating = 0.8,
        stiffness = 0.9,
        time_interval = 12,
        filetypes_disabled = {
            "TelescopePrompt",
            "TelescopeResults",
            "DressingInput",
            "oil",
            "lazy",
            "mason",
            "noice",
            "notify",
        },
    },
}
}
