local highlight_utils = require("nvim-hidesig.highlight_utils")
local util = require("nvim-hidesig.util")

local hidesig = {}

--- Traverse node to dim highlight color
---@param bufnr integer Buffer number
---@param node any Treesitter node
function hidesig.traverseNode(bufnr, node)
  local startLine, startCol, _, endCol = node:range() -- range of the capture
  local highlightGroup = highlight_utils.getHightlightGroupForRange(bufnr, startLine, startCol)
  local color = highlight_utils.getHighlightGroupColor(highlightGroup)
  local darkenValue = hidesig.configs.opacity or 0.75

  vim.api.nvim_set_hl(
    hidesig.ns,
    string.format("%sDimmed", highlightGroup),
    {
      fg = util.darken(color, darkenValue),
      undercurl = false,
      underline = false,
    }
  )

  vim.api.nvim_buf_add_highlight(
    bufnr,
    hidesig.ns,
    string.format("%sDimmed", highlightGroup),
    startLine,
    startCol,
    endCol
  )

  if node:child_count() == 0 then
    return
  else
    for childNode in node:iter_children() do
      traverseNode(childNode)
    end
  end
end

--- Setup hidesig module with config options, must be called before perform
---@param configs table configuration for hidesig
-- @param configs.opacity float value from 0.0 to 1.0
function hidesig.setup(configs)
  hidesig.ns = vim.api.nvim_create_namespace("hidesig_ns")
  hidesig.configs = configs or {}
end

--- Perform hidesig highlighting logic for Ruby sorbet signature definition
--- @param bufnr integer buffer number
--- @param lang string Language name
function hidesig.perform(bufnr, lang)
  if hidesig.ns == nil then
    error("[hidesig.lua] Must call setup() before perform()")
    return
  end

  local languageTree = vim.treesitter.get_parser(bufnr, lang)
  local syntaxTree = languageTree:parse()
  local bufferRoot = syntaxTree[1]:root()

  local query = [[
    (
      call
        method: (identifier) @sig_keyword
        block:  [(block) (do_block)]
      (#eq? @sig_keyword "sig")
    ) @sig_def
  ]]

  local parsedQuery = vim.treesitter.parse_query(lang, query)

  -- TODO: May need to clear highlight before adding running highlight. Otherwise commented code may retain the highlight
  -- reference https://github.dev/p00f/nvim-ts-rainbow/blob/master/lua/rainbow/internal.lua:51
  vim.api.nvim_buf_clear_namespace(bufnr, hidesig.ns, 0, -1)
  for _, captures in parsedQuery:iter_matches(bufferRoot, bufnr) do
    local sigBlock = captures[2] -- capture @sig_def

    for rootChildNode in sigBlock:iter_children() do
      hidesig.traverseNode(bufnr, rootChildNode)
    end
  end
end

return hidesig
