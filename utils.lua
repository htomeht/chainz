local table = table
local pairs = pairs
local string = string
local setmetatable = setmetatable

local _module = {}

local _key2bind = {
   ["Shift"]   = "S",
   ["Control"] = "C",
   ["Mod1"]    = "A",
   ["Mod4"]    = "M"
}

local _code2key = {
  ["Shift_R"] = "Shift",
  ["Shift_L"] = "Shift",
  ["Control_R"] = "Control",
  ["Control_L"] = "Control",
  ["Alt_L"] = "Mod1",
  ["Meta_L"] = "Mod1",
  ["Super_L"] = "Mod4"
}
local _bind2key = { 
  ["S"] = "Shift",
  ["C"] = "Control",
  ["A"] = "Mod1",
  ["M"] = "Mod4"
}

-- Split a string by a pattern
--
-- @str, any string but in this case will likely be a keybind mapping
-- @pat, a pattern used as a delimiter
local _split = function(str, pat)
  --print("DEBUG: SPLIT")
  pattern = "[^"..pat.."]+" or "[^%s]+"
  if pattern:len() == 0 then pattern = "[^%s]+" end
  local parts = {__index = table.insert}
  setmetatable(parts, parts)
  str:gsub(pattern, parts)
  setmetatable(parts, nil)
  parts.__index = nil
  return parts
end

local _tail = function(tbl)
  if tbl == nil then return nil end
  if #tbl <= 1 then return nil end
  local _tbl = {}
  for i, v in ipairs(tbl) do
    if i > 1 then
      table.insert(_tbl,v)
    end
  end
  return _tbl
end

local _head = function(tbl)
  if tbl == nil then return nil end
  if #tbl == 0 then return nil end 
  return tbl[1]
end

-- Very simple and slightly crappy hash that ignores order
-- I haven't done much to ensure there are no collisions
-- If this leads to issues I will write a real hashing function
local _hash = function(input)
  local _ret = 0

  local _convert = function(char)
    local _value = 0 
    if char == "M" then _value = _value + 3 * string.byte(char) 
    elseif char == "A" then _value = _value + 7 * string.byte(char)
    elseif char == "S" then _value = _value + 11 * string.byte(char)
    elseif char == "C" then _value = _value + 17 * string.byte(char)
    elseif char == "-" then
    else
      _value = _value + string.byte(char) 
    end
    return _value
  end

  if type(input) == "table" then -- Hash a key state
    --print("HASH TABLE:", input)
    for k, v in pairs(input[1]) do
      --print(v)
      --print(key2bind[v])
      --print(_convert(key2bind[v]))
      --print(string.byte("C")*17)
      _ret = _ret + _convert(_key2bind[v])
    end
    --print(input[2])
    _ret = _ret + string.byte(input[2])
  elseif type(input) == "string" then -- Hash a keycode ("C-t")
    --print("HASH STRING:", input)
    for i = 1, #input do
      local c = input:sub(i,i)
      --print("C = ", c, "Val = ", _convert(c))
      _ret = _ret + _convert(c)
    end
    --print("TOTAL: ", _ret)
  end
  return _ret


end
-- Public interface
_module.split = _split
_module.head = _head
_module.tail = _tail
_module.hash = _hash
_module.key2bind = _key2bind
_module.code2key = _code2key
_module.bind2key = _bind2key
return _module
