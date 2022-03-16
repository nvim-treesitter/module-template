local highlight_utils = require("hidesig.highlight_utils")
local ts_query = require("nvim-treesitter.query")
local ts_utils = require("nvim-treesitter.ts_utils")
local util = require("hidesig.util")

local hidesig = {}
local cachedHighlightGroup = {}
local namespace = vim.api.nvim_create_namespace("hidesig_ns")

---Get or create new highlight group
---@param bufnr integer
---@param startLine integer
---@param startCol integer
---@return string # Highlight group name
function hidesig.getOrCreateHighlightGroup(bufnr, startLine, startCol)
  local highlightGroup = highlight_utils.getHightlightGroupForRange(bufnr, startLine, startCol)

  if cachedHighlightGroup[highlightGroup] ~= nil then
    return cachedHighlightGroup[highlightGroup]
  end

  local color = highlight_utils.getHighlightGroupColor(highlightGroup)
  local darkenValue = hidesig.opacity or 0.75
  local newHighlightGroup = string.format("%sDimmed", highlightGroup)

  cachedHighlightGroup[highlightGroup] = newHighlightGroup

  vim.api.nvim_set_hl(
    namespace,
    newHighlightGroup,
    {
      fg = util.darken(color, darkenValue),
      undercurl = false,
      underline = false,
    }
  )

  return newHighlightGroup
end

--- Traverse node to dim highlight color
---@param bufnr integer Buffer number
---@param node any Treesitter node
function hidesig.traverseNode(bufnr, node)
  local startLine, startCol, _, _ = node:range() -- range of the capture
  local highlightGroup = hidesig.getOrCreateHighlightGroup(bufnr, startLine, startCol)

  ts_utils.highlight_node(node, bufnr, namespace, highlightGroup)
  if node:child_count() < 1 then
    return
  else
    for childNode in node:iter_children() do
      hidesig.traverseNode(bufnr, childNode)
    end
  end
end

---Highlight specific lines
---@param bufnr integer # Buffer number
---@param range table # List of changes in format { startRow, endRow }
---@param tree any # Syntax tree
---@param lang string # Buffer language
function hidesig.highlightLines(bufnr, range, tree, lang)
  -- check if there's a popup visible
  if vim.fn.pumvisible() == 1 or not lang then
    return
  end

  local rootNode = tree:root()
  local parsedQuery = ts_query.get_query(lang, "hidesig")
  local startRow = range[1]
  local endRow = range[2]

  vim.api.nvim_buf_clear_namespace(bufnr, namespace, startRow, endRow)

  for _, captures in parsedQuery:iter_matches(rootNode, bufnr, startRow, endRow) do
    local sigBlock = captures[2] -- capture @sig_def

    if sigBlock ~= nil and not sigBlock:has_error() then
      for rootChildNode in sigBlock:iter_children() do
        hidesig.traverseNode(bufnr, rootChildNode)
      end
    end
  end
end

--- Teardown state and clear namespace for buffer
---@param bufnr integer # Buffer number
function hidesig.teardown(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
end

--- Perform hidesig highlighting logic for Ruby sorbet signature definition for entire buf
--- @param bufnr integer # Buffer number
--- @param lang string # Language name
--- @param opacity number # Number from 0.0 to 1.0
function hidesig.fullUpdate(bufnr, lang, opacity)
  hidesig.opacity = opacity
  vim.api.nvim__set_hl_ns(namespace)

  local parser = vim.treesitter.get_parser(bufnr, lang)
  local syntaxTree = parser:parse()[1]
  local treeRange = { syntaxTree:root():range() }

  -- highlight the entire buffer
  hidesig.highlightLines(
    bufnr,
    { treeRange[1], treeRange[3] },
    syntaxTree,
    lang
  )
end

--- Perform hidesig highlighting logic for Ruby sorbet signature definition for visible part of buf
--- @param bufnr integer # Buffer number
--- @param lang string # Language name
--- @param opacity number # Number from 0.0 to 1.0
function hidesig.updateVisibleBuf(bufnr, lang, opacity)
  hidesig.opacity = opacity
  vim.api.nvim__set_hl_ns(namespace)

  local parser = vim.treesitter.get_parser(bufnr, lang)
  local syntaxTree = parser:parse()[1]
  local startLine = vim.fn.line('w0') - 1
  local endLine = vim.fn.line('w$')

  hidesig.highlightLines(
    bufnr,
    { startLine, endLine },
    syntaxTree,
    lang
  )
end

return hidesig
