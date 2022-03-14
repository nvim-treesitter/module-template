local queries = require "nvim-treesitter.query"

local M = {}

function M.init()
  require "nvim-treesitter".define_modules {
    hidesig = {
      module_path = "nvim-hidesig.internal",
      is_supported = function(lang)
        return queries.get_query(lang, "sig_def") ~= nil
      end,
      opacity = 0.75
    }
  }
end

return M
