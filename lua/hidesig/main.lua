local hidesig = require("hidesig.internal")
local configs = require("nvim-treesitter.configs")

local M = {}

function M.attach(bufnr, lang)
  local config = configs.get_module("hidesig")
  hidesig.setup(bufnr, config)
  hidesig.perform(bufnr, lang)
end

function M.detach(bufnr)
  hidesig.teardown(bufnr)
end

return M
