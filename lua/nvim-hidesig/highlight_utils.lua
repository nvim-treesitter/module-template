local highlighter = require("vim.treesitter.highlighter")
local ts_utils = require("nvim-treesitter.ts_utils")

local highlight_utils = {}

--- Get tree-sitter highlight groups for a buffer
-- @params bufnr The buffer number
-- @params row Line number
-- @params col Column number
-- @return array of matched highlight groups used for specified range. E.g {"TSFunction", "TSVariable"}
function highlight_utils.get_treesitter_hl(bufnr, row, col)
  local rubyHighlighter = highlighter.active[bufnr]
  if not rubyHighlighter then
    return {}
  end

  local matches = {}

  rubyHighlighter.tree:for_each_tree(function(tstree, tree)
    if not tstree then
      return
    end

    local root = tstree:root()
    local root_start_row, _, root_end_row, _ = root:range()

    if root_start_row > row or root_end_row < row then
      return
    end

    local query = rubyHighlighter:get_query(tree:lang())

    if not query:query() then
      return
    end

    local iter = query:query():iter_captures(root, rubyHighlighter.bufnr, row, row + 1)

    for capture, node, _ in iter do
      local hl = query.hl_cache[capture]

      if hl and ts_utils.is_in_node_range(node, row, col) then
        local c = query._query.captures[capture] -- name of the capture in the query
        if c ~= nil then
          local general_hl = query:_get_hl_from_capture(capture)
          table.insert(matches, general_hl)
        end
      end
    end
  end, true)

  return matches
end

--- Get highest priorty tree-sitter highlight group used for a range in a buffer
-- @params bufnr The buffer number
-- @params row Line number
-- @params col Column number
-- @return Name of highlight group used in type string. E.g. "TSFunction"
function highlight_utils.getHightlightGroupForRange(bufnr, row, col)
  local ts_hi = highlight_utils.get_treesitter_hl(bufnr, row, col)
  local final = #ts_hi >= 1 and ts_hi[#ts_hi]

  if type(final) ~= "string" then
    final = "Normal"
  end

  return final
end

--- Get color used by (n)vim for a highlight group
-- @params hlGroup Name of the highlight group
-- @return hex string representation of color. E.g "#7aa2f7"
function highlight_utils.getHighlightGroupColor(hlGroup)
  local hl = vim.api.nvim_get_hl_by_name(hlGroup, true)
  local color = string.format("#%x", hl["foreground"] or 0)
  if #color ~= 7 then
    color = "#ffffff"
  end

  return color
end

return highlight_utils
