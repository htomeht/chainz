-----------------------------
-- Module for handling keymaps
-- Contains a loader and internal representation for keybinds
-- This module should provide a standard API for keybinds
-- The actual loader will only work for a standard lua representation for now
--

-- Awesome 
--local awful = require("awful")

-- Chainz
local loader = require("chainz.loader")
local parser = require("chainz.parser")
local keymaps = require("chainz.keymaps")
local settings = require("chainz.settings")
local translator = require("chainz.translator")

local _module = {}


-- Modules
_module.parser = parser
_module.loader = loader
_module.keymaps = keymaps

-- Functions
_module.load_map = loader.keymap
return _module
