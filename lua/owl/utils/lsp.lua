local M = {}

function M.on_attach(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    local ok, navic = pcall(require, "nvim-navic")
    if ok then
      navic.attach(client, bufnr)
    end
  end

  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "gy", vim.lsp.buf.definition, "Definition")
  map("n", "gD", vim.lsp.buf.type_definition, "Go to type definition")
  map("n", "gr", vim.lsp.buf.references, "References")
  map("n", "gi", vim.lsp.buf.implementation, "Implementation")

  map("n", "K", vim.lsp.buf.hover, "Hover")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
  map({ "n", "v" }, "<A-CR>", vim.lsp.buf.code_action, "Quick fix (Alt+Enter)")
  map("n", "<leader>e", vim.diagnostic.open_float, "Open diagnostic float")
  map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
  map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
  map("n", "<leader>cl", function()
    require("telescope.builtin").lsp_references({ include_declaration = false })
  end, "Find all references (grep preview)")

  local function format()
    local conform_ok, conform = pcall(require, "conform")
    if not conform_ok then
      require("lazy").load({ plugins = { "conform.nvim" } })
      conform_ok, conform = pcall(require, "conform")
    end
    if conform_ok then
      conform.format({ async = true, lsp_fallback = true })
    else
      vim.lsp.buf.format({ async = true })
    end
  end
  map("n", "<leader>f", format, "Format file")
  map("v", "<leader>f", format, "Format selection")

  local function format_range(start_line, start_col, end_line, end_col)
    vim.lsp.buf.format({
      async = true,
      range = {
        start = { start_line, start_col },
        ["end"] = { end_line, end_col },
      },
    })
  end
  map("n", "<leader>fl", function()
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1
    format_range(line, 0, line + 1, 0)
  end, "Format current line (LSP)")
  map("v", "<leader>fl", function()
    local s = vim.fn.getpos("'<")
    local e = vim.fn.getpos("'>")
    format_range(s[2] - 1, s[3] - 1, e[2] - 1, math.max(e[3] - 1, 0))
  end, "Format selection (LSP)")
  map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace symbols")
  map("n", "<leader>ds", vim.lsp.buf.document_symbol, "Document symbols")

  map("n", "<leader>xE", function()
    local d = vim.diagnostic.get(0, { severity = { min = vim.log.levels.ERROR } })
    vim.fn.setqflist({}, "r", { title = "Errors " .. vim.fn.expand("%:t"), items = vim.diagnostic.toqflist(d) })
    vim.cmd("copen")
  end, "Errors of current file in quickfix")
end

return M
