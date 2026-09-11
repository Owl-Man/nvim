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
  map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, "Workspace symbols")
  map("n", "<leader>ds", vim.lsp.buf.document_symbol, "Document symbols")
end

return M
