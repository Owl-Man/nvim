vim.o.background = "dark"
vim.o.termguicolors = true

local c = {
  bg        = "#1E1F22",
  bg_alt    = "#2B2D30",
  bg_hover  = "#2A2B2E",
  bg_sel    = "#2E436E",
  border    = "#43454A",
  fg        = "#BCBEC4",
  fg_dim    = "#6F737A",
  pink      = "#C77DBA",
  blue      = "#57A8F5",
  teal      = "#299999",
  yellow    = "#FFC66D",
  lavender  = "#9876AA",
  green     = "#6AAB73",
  comment   = "#7A9E7E",
  red       = "#F75464",
  warn      = "#FACD39",
}

local apply = function()
  local s = function(name, opts) vim.api.nvim_set_hl(0, name, opts) end
  local l = function(name, target) vim.api.nvim_set_hl(0, name, { link = target }) end

  s("Normal",        { bg = c.bg, fg = c.fg })
  s("NormalNC",      { link = "Normal" })
  s("NormalFloat",   { bg = c.bg_alt, fg = c.fg })
  s("FloatBorder",   { fg = c.border })
  s("CursorLine",    { bg = c.bg_hover })
  s("CursorColumn",  { bg = c.bg_hover })
  s("ColorColumn",   { bg = c.bg_hover })
  s("LineNr",        { fg = c.fg_dim })
  s("CursorLineNr",  { fg = c.fg, bold = true })
  s("SignColumn",    { bg = c.bg })
  s("Folded",        { bg = c.bg_alt, fg = c.fg_dim })
  s("FoldColumn",    { bg = c.bg, fg = c.fg_dim })
  s("Visual",        { bg = c.bg_sel })
  s("Search",        { bg = "#3F4A5A", fg = "#FFFFFF" })
  s("IncSearch",     { bg = "#3F4A5A", fg = "#FFFFFF", bold = true })
  s("MatchParen",    { bg = c.border, bold = true })
  s("StatusLine",    { bg = c.bg_alt, fg = c.fg })
  s("StatusLineNC",  { bg = c.bg, fg = c.fg_dim })
  s("WinBar",        { bg = c.bg, fg = c.fg_dim })
  s("WinBarNC",      { bg = c.bg, fg = c.fg_dim })
  s("TabLine",       { bg = c.bg_alt, fg = c.fg_dim })
  s("TabLineSel",    { bg = c.bg, fg = c.fg })
  s("TabLineFill",   { bg = c.bg_alt })
  s("WinSeparator",  { fg = c.border })
  s("VertSplit",     { link = "WinSeparator" })
  s("Pmenu",         { bg = c.bg_alt, fg = c.fg })
  s("PmenuSel",      { bg = c.bg_sel, fg = "#FFFFFF" })
  s("PmenuSbar",     { bg = c.bg_alt })
  s("PmenuThumb",    { bg = c.border })
  s("WildMenu",      { link = "PmenuSel" })
  s("Title",         { fg = c.blue, bold = true })
  s("Directory",     { fg = c.blue })
  s("Question",      { fg = c.green })
  s("MoreMsg",       { fg = c.blue })
  s("ModeMsg",       { fg = c.fg })
  s("NonText",       { fg = c.border })
  s("EndOfBuffer",   { fg = c.border })
  s("SpecialKey",    { fg = c.fg_dim })
  s("Conceal",       { fg = c.fg_dim })
  s("ErrorMsg",      { fg = c.red })
  s("WarningMsg",    { fg = c.warn })
  s("DiffAdd",       { bg = "#29422D" })
  s("DiffChange",    { bg = "#2E3A4A" })
  s("DiffDelete",    { bg = "#4A2A2E" })
  s("DiffText",      { bg = "#3A4A5A" })

  s("DiagnosticError", { fg = c.red })
  s("DiagnosticWarn",  { fg = c.warn })
  s("DiagnosticInfo",  { fg = c.blue })
  s("DiagnosticHint",  { fg = c.comment })
  s("DiagnosticOk",    { fg = c.green })

  s("LspCodeLens",          { fg = c.fg_dim })
  s("LspCodeLensSeparator", { fg = c.border })
  s("LspInlayHint",         { fg = c.fg_dim, italic = true })
  s("LspReferenceText",     { bg = c.bg_hover })
  s("LspReferenceRead",     { bg = c.bg_hover })
  s("LspReferenceWrite",    { bg = c.bg_hover })

  s("@variable",            { fg = c.fg })
  s("@variable.parameter",  { fg = c.fg })
  s("@variable.member",     { fg = c.lavender })
  s("@variable.builtin",    { fg = c.pink })
  s("@field",               { fg = c.fg })
  s("@property",            { fg = c.lavender })
  s("@constant",            { fg = c.lavender })
  s("@constant.builtin",    { fg = c.pink })

  s("@function",         { fg = c.yellow })
  s("@function.call",    { fg = c.yellow })
  s("@function.builtin", { fg = c.yellow })
  s("@method",           { fg = c.yellow })
  s("@method.call",      { fg = c.yellow })
  s("@constructor",      { fg = c.teal })

  s("@type",            { fg = c.teal })
  s("@type.builtin",    { fg = c.pink })
  s("@type.definition", { fg = c.teal })
  s("@type.qualifier",  { fg = c.pink })
  s("@namespace",       { fg = c.teal })
  s("@module",          { fg = c.teal })

  s("@keyword",          { fg = c.pink, bold = true })
  s("@keyword.type",     { fg = c.pink, bold = true })
  s("@keyword.modifier", { fg = c.pink, bold = true })
  s("@keyword.operator", { fg = c.pink, bold = true })
  s("@keyword.directive",{ fg = c.pink, bold = true })
  l("@keyword.return",     "@keyword")
  l("@keyword.control",    "@keyword")
  l("@keyword.conditional","@keyword")
  l("@keyword.repeat",     "@keyword")
  l("@keyword.exception",  "@keyword")
  l("@keyword.import",     "@keyword")
  l("@conditional",        "@keyword")
  l("@repeat",             "@keyword")
  l("@exception",          "@keyword")
  l("@include",            "@keyword")
  l("@storageclass",       "@keyword")

  s("@operator",  { fg = c.fg })
  s("@boolean",   { fg = c.pink })
  s("@number",    { fg = c.blue })
  s("@float",     { fg = c.blue })
  s("@string",    { fg = c.green })
  s("@character", { fg = c.green })
  s("@comment",   { fg = c.comment, italic = true })
  s("@attribute", { fg = c.teal })

  s("@punctuation",           { fg = c.fg })
  s("@punctuation.bracket",   { fg = c.fg })
  s("@punctuation.delimiter", { fg = c.fg })
  s("@punctuation.special",   { fg = c.fg })

  l("Comment",    "@comment")
  l("String",     "@string")
  l("Number",     "@number")
  l("Boolean",    "@boolean")
  l("Keyword",    "@keyword")
  l("Function",   "@function")
  l("Type",       "@type")
  l("Identifier", "@variable")
  l("Constant",   "@constant")
  l("Operator",   "@operator")
  s("Special",    { fg = c.blue })
  s("Todo",       { fg = c.warn, bold = true })
  s("Error",      { fg = c.red })
  s("Underlined", { fg = c.blue, underline = true })
  s("Ignore",     { fg = c.fg_dim })
end

vim.api.nvim_create_autocmd("ColorScheme", { callback = apply })
vim.cmd.colorscheme("default")
apply()
