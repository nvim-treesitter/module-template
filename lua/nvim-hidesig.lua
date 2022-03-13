local queries = require "nvim-treesitter.query"

local M = {}

function M.init()
  require "nvim-treesitter".define_modules {
    nvim_hidesig = {
      module_path = "nvim-hidesig.internal",
      is_supported = function(lang)
        return queries.get_query(lang, "sig_def") ~= nil
      end
    }
  }
end

return M
