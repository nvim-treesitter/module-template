local hidesig = require("nvim-hidesig.hidesig")
local configs = require("nvim-treesitter.configs")

local M = {}

function M.attach(bufnr, lang)
  local config = configs.get_module("hidesig")
  hidesig.setup(config)
  hidesig.perform(bufnr, lang)
end

function M.detach(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, hidesig.ns, 0, -1)
end

return M
