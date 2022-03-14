-- source https://github.com/folke/tokyonight.nvim/blob/main/lua/tokyonight/util.lua
local util = {}

util.bg = "#000000"

---Convert hex to rgb value
---@param hex_str string
---@return table array of rgb values
function util.hexToRgb(hex_str)
  local hex = "[abcdef0-9][abcdef0-9]"
  local pat = "^#(" .. hex .. ")(" .. hex .. ")(" .. hex .. ")$"
  hex_str = string.lower(hex_str)

  assert(string.find(hex_str, pat) ~= nil, "hex_to_rgb: invalid hex_str: " .. tostring(hex_str))

  local r, g, b = string.match(hex_str, pat)
  return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) }
end

---Blend two colors with alpha amount from 0.0 to 1.0
---@param fg string foreground color
---@param bg string background color
---@param alpha number number between 0 and 1. 0 results in bg, 1 results in fg
---@return string Hex value for new color
function util.blend(fg, bg, alpha)
  bg = util.hexToRgb(bg)
  fg = util.hexToRgb(fg)

  local blendChannel = function(i)
    local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format("#%02X%02X%02X", blendChannel(1), blendChannel(2), blendChannel(3))
end

---Darken a hex color by an alpha value with optional background hex
---@param hex string Hex value for color
---@param amount number Alpha value between 0.0 to 1.0. 0 results in bg, 1 results in fg
---@return string Hex string for new color. E.g. '#2D2D2D'
function util.darken(hex, amount, bg)
  return util.blend(hex, bg or util.bg, math.abs(amount))
end

return util
