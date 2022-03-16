local hidesig = require("hidesig.internal")
local ts_configs = require("nvim-treesitter.configs")
local cmd = vim.api.nvim_command

local cmdEvents = {
  "InsertLeave",
  "CursorMoved",
}

local M = {}

function M.partialUpdateCmd(event, bufnr, lang, opacity)
  return string.format(
    [[autocmd %s <buffer=%d> lua require('hidesig.internal').updateVisibleBuf(%d, '%s', %0.2f)]],
    event,
    bufnr,
    bufnr,
    lang,
    opacity
  )
end

function M.attach(bufnr, lang)
  local config = ts_configs.get_module("hidesig")
  local opacity = config.opacity
  hidesig.fullUpdate(bufnr, lang, opacity)

  cmd(string.format("augroup NvimHidesig_%d", bufnr))
  cmd("au!")
  for _, event in ipairs(cmdEvents) do
    cmd(M.partialUpdateCmd(
      event,
      bufnr,
      lang,
      opacity
    ))
  end
  cmd("augroup END")
end

function M.detach(bufnr)
  hidesig.teardown(bufnr)
  --
  for _, event in ipairs(cmdEvents) do
    cmd(string.format("autocmd! NvimHidesig_%d %s", bufnr, event))
  end
end

return M
