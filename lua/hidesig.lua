local queries = require "nvim-treesitter.query"

local M = {}

function M.init()
  require "nvim-treesitter".define_modules {
    hidesig = {
      module_path = "hidesig.main",
      is_supported = function(lang)
        local isSupported = queries.get_query(lang, "sig_def") ~= nil
        return isSupported
      end,
      opacity = 0.75
    }
  }
end

return M
