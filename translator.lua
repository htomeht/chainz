-----------------------------
-- Module for handling keymaps
-- Contains a loader and internal representation for keybinds
-- This module should provide a standard API for keybinds
-- The actual loader will only work for a standard lua representation for now
--

-- Awesome 
--local awful = require("awful")

-- Lookup tables for fast conversion
local _event2internal = {
  ["Shift_R"] = "Shift",
  ["Shift_L"] = "Shift",
  ["Control_R"] = "Control",
  ["Control_L"] = "Control",
  ["Alt_L"] = "Mod1",
  ["Meta_L"] = "Mod1",
  ["Super_L"] = "Mod4"
}

local _bind2internal = { 
  ["S"] = "Shift",
  ["C"] = "Control",
  ["A"] = "Mod1",
  ["M"] = "Mod4"
}


local _module = {}

local _translate_bind = function(value)
  _ret = {}
  _translated = _bind2internal[value]
  if _translated ~= nil then
    _ret.value = _translated
    _ret.type = "mod"
  else
    _ret.value = value
    _ret.type = "key"
  end
  return _ret
end

local _translate_event = function(value)
  _ret = {}
  _translated = _event2internal[value]
  if _translated ~= nil then
    _ret.value = _translated
    _ret.type = "mod"
  else
    _ret.value = value
    _ret.type = "key"
  end
  return _ret
end

_module.translate_event = _translate_event
_module.translate_bind = _translate_bind
return _module

