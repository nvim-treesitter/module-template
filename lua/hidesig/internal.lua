local highlight_utils = require("hidesig.highlight_utils")
local util = require("hidesig.util")

local hidesig = {}
local cachedHighlightGroup = {}

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
  local darkenValue = hidesig.configs.opacity or 0.75
  local newHighlightGroup = string.format("%sDimmed", highlightGroup)

  cachedHighlightGroup[highlightGroup] = newHighlightGroup

  vim.api.nvim_set_hl(
    hidesig.ns,
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
  local startLine, startCol, _, endCol = node:range() -- range of the capture
  local highlightGroup = hidesig.getOrCreateHighlightGroup(bufnr, startLine, startCol)

  vim.api.nvim_buf_add_highlight(
    bufnr,
    hidesig.ns,
    highlightGroup,
    startLine,
    startCol,
    endCol
  )

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
---@param changes table # List of changes in format { startRow, startCol, endRow, endCol }
---@param tree any # Syntax tree
---@param lang string # Buffer language
function hidesig.highlightLines(bufnr, changes, tree, lang)
  -- check if there's a popup visible
  if vim.fn.pumvisible() == 1 or not lang then
    return
  end

  local rootNode = tree:root()
  local query = [[
    (
      call
        method: (identifier) @sig_keyword
        block:  [(block) (do_block)]
      (#eq? @sig_keyword "sig")
    ) @sig_def
  ]]
  local parsedQuery = vim.treesitter.parse_query(lang, query)

  for _, change in ipairs(changes) do
    local startRow = change[1]
    local endRow = change[3]

    vim.api.nvim_buf_clear_namespace(bufnr, hidesig.ns, startRow, endRow)

    for _, captures in parsedQuery:iter_matches(rootNode, bufnr, startRow, endRow) do
      local sigBlock = captures[2] -- capture @sig_def

      if sigBlock ~= nil and not sigBlock:has_error() then
        for rootChildNode in sigBlock:iter_children() do
          hidesig.traverseNode(bufnr, rootChildNode)
        end
      end
    end
  end
end

--- Setup hidesig module with config options, must be called before perform
---@param configs table configuration for hidesig
-- @param configs.opacity float value from 0.0 to 1.0
function hidesig.setup(bufnr, configs)
  hidesig.ns = vim.api.nvim_create_namespace("hidesig_ns")
  vim.api.nvim__set_hl_ns(hidesig.ns)
  hidesig.configs = configs or {}
  hidesig.enabledBuffers = {}
  hidesig.enabledBuffers[bufnr] = true
end

--- Teardown state and clear namespace for buffer
---@param bufnr integer # Buffer number
function hidesig.teardown(bufnr)
  if hidesig.ns == nil then
    error("[hidesig.lua] Must call setup() before teardown()")
    return
  end

  hidesig.enabledBuffers[bufnr] = nil
  vim.api.nvim_buf_clear_namespace(bufnr, hidesig.ns, 0, -1)
end

--- Perform hidesig highlighting logic for Ruby sorbet signature definition
--- @param bufnr integer buffer number
--- @param lang string Language name
function hidesig.perform(bufnr, lang)
  if hidesig.ns == nil then
    error("[hidesig.lua] Must call setup() before perform()")
    return
  end

  local parser = vim.treesitter.get_parser(bufnr, lang)
  local syntaxTree = parser:parse()[1]

  -- highlight the entire buffer
  hidesig.highlightLines(bufnr, { { syntaxTree:root():range() } }, syntaxTree, lang)
end

return hidesig
