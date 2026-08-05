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
    "tpope/vim-fugitive",
    cmd = {
      "Git",
      "G",
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
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
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = true,
        show_start = true,
        show_end = false,
      },
      exclude = {
        filetypes = { "help", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
      },
    },
  },

  {
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach",
    config = function()
      require("symbol-usage").setup({
        vt_position = "end_of_line",
        text_format = function(symbol)
          local refs = symbol.references and (" 󰌹 " .. symbol.references) or ""
          local def = symbol.definition and ("󰊕 " .. symbol.definition) or ""
          local imp = symbol.implementation and ("󰡱 " .. symbol.implementation) or ""
          return string.format("%s%s%s", refs, def, imp)
        end,
      })
    end,
  },

  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 2000,
    config = function()
      require("kanagawa").setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        colors = {
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors)
          return {}
        end,
        theme = "wave",
        background = {
          dark = "wave",
          light = "lotus",
        },
      })
      vim.cmd.colorscheme("kanagawa")
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nightfox").setup({
        options = {
          transparent = false,
          styles = {
            comments = "italic",
            keywords = "bold",
          },
        },
      })
      vim.cmd.colorscheme("carbonfox")
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
          ensure_installed = { "c_sharp", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
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
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
    opts = {
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
    },
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
      vim.api.nvim_create_user_command("CdRoot", function()
        vim.cmd("cd " .. (require("project_nvim.project").get_root(vim.fn.expand("%:p")) or "."))
      end, {})
    end,
  },
}
