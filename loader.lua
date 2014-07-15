-----------------------------
-- Module for handling keymaps
-- Contains a loader and internal representation for keybinds
-- This module should provide a standard API for keybinds
-- The actual loader will only work for a standard lua representation for now

local pairs = pairs
local ipairs = ipairs

-- Awesome 
--local awful = require("awful")

-- Chainz
local utils = require("chainz.utils")
local keymaps = require("chainz.keymaps")
local settings = require("chainz.settings")
local translator = require("chainz.translator")

local _module = {}

--------------------------------------------------------
-- Link
local _keybind = function(str)
  local _instance = {}
  -- Book keeping
  local _type = "C_KeyBind"
  local _str_repr = _type .. ":" .. str

  -- Internals
  local _lookup = {} -- Lookup table
  local _mods = {} -- Modifiers
  local _key = nil -- Key

  for index, value in pairs(utils.split(str, "-")) do
    local _translation = translator.translate_bind(value)
    if _translation.type == "mod" then
      _mods[index] = _translation.value 
    elseif _translation.type == "key" then
      _key = _translation.value
    end
  end

  -- Instance construction
  _instance.mods = _mods
  _instance.key = _key
  _instance.str_repr = str
  _instance.type = _type
  return _instance
end

--------------------------------------------------------
-- Keychain
local _keychain = function(str,fn)
  local _instance = {}
  -- Book keeping
  local _type = "C_KeyChain"
  local _str_repr = _type .. ":" .. str

  -- Internals
  local _binds = {}
  local _function = fn -- Function that is run when the keychain is entered

  for index, value in pairs(utils.split(str, " ")) do
    _binds[index] = _keybind(value)
  end

  -- Instance construction
  _instance.type = _type
  _instance.str_repr = _str_repr
  _instance.binds = _binds --Contains a set of unorderd binds
  _instance.fn = _function
  return _instance
end
--------------------------------------------------------
-- Keymap
local _keymap = function(map)
  -- Register each keybind in keymap to chainz internals
  local _instance = {}
  -- Book keeping
  local _type = "C_KeyMap"
  local _str_repr = "NO REPRESENTATION YET"

  -- Internals
  local _keychains = {}

  for index, chain in ipairs(map) do
    print(index,chain)
    _keychains[index] = _keychain(chain[1], chain[2])
    -- We might also want to register the binds here
  end

  
  _instance.keybinds = _keybinds
  _instance.str_repr = _str_repr
  _instance.type = _type
  return _instance
end

_module.keymap = _keymap
_module.keymaps = keymaps -- Forward to keymaps.lua
return _module
