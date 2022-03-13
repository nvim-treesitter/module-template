local queries = require "nvim-treesitter.query"

local M = {}

-- TODO: In this function replace `module-template` with the actual name of your module.
function M.init()
  require "nvim-treesitter".define_modules {
    module_template = {
      module_path = "nvim-hidesig.internal",
      is_supported = function(lang)
        return lang == 'ruby'
      end
    }
  }
end

return M
