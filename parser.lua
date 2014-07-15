-- System
local table = table
local pairs = pairs
local string = string

-- Awsome
local awful = require("awful")

-- Chainz

local utils = require "chainz.utils"
local translator = require "chainz.translator"

-- Module

local _module = {}

local _event_parser = function()
  print("Chainz::Parser Started")
  local _instance = {}
  local _mods = {}
  local _keys = {}

  -- Returns the active keys in a table
  local _active = function(tbl)
    local _tbl = {}
    for key, pressed in pairs(tbl) do 
      if pressed == true then _tbl[#_tbl+1] = key end
    end
    return _tbl
  end

  local _parser = function(mod, key, event)
    print("Chainz::Parsing an Event")
    local t = translator.translate_event(key)

    if event == "release" then
      -- Release stuff
      if t.type == "key" and _key == t.value then
        _keys[t.value] = false
      elseif t.type == "mod" then
        _mods[t.value] = true
      end

    elseif event == "press" then
      -- Press stuff
      if t.type == "key"  then
        _keys[t.value] = true
      elseif t.type == "mod" then
        _mods[t.value] = true
      end
    end
    
    print("Chainz::Parsing finished")
  end

  return _parser
end

local _debug_keygrabber = function()
  print("\n---Starting Keygrabber in debugging mode---")

  local _parse = _event_parser()  
  local _grabber = awful.keygrabber.run(function(mod, key, event)
    print(string.format("\nChainz::%s Event Received - Key=%s",event, key))
    local parsed_event = _parse(mod, key, event)
    awful.keygrabber.stop(_grabber)
  end)
end

_module.debug_keygrabber = _debug_keygrabber
return _module

---- This function parses a single bind, this is where you would make changes
---- if you wanted to change the representation of a bind. This will return a
---- table in a special form.
---- 
---- @bind, a single bind in the {"C-t h c", func} format
---- @returns, a bind in the form {bind = {{"Ctrl"}, "t"}, chain = {"h", "c"}, fn = func}
--local _gen_link = function(link, tail, fn)
--  local _self = {}
--
--  local _mod = {}
--  local _key = nil
--  local _fn = nil
--  local _chain = {} -- Used to add links to, not used in this function
--
--  -- If this link is the final one in a chain then the function should be run from here
--  if tail == nil or #tail < 1 then
--    _fn = fn  
--  end
--
--  -- Initiate some values
--  for _, v in pairs(utils.split(link, "-")) do
--    if utils.bind2key[v] ~= nil then 
--      _mod[#_mod+1] = utils.bind2key[v]
--    else
--      _key = v
--      break
--    end
--  end
--
--  -- Determine if a specified mod is used to call this link
--  local _contains_mod = function(m)
--    for _,v in pairs(_mod) do 
--      print(string.format("Modifiers: %s = %s -> %s", m, v, tostring(m==v)))
--      if m == v then 
--        return true 
--      end 
--    end
--    return false
--  end
--
--  -- Determine if ALL mods in a list are set in this link
--  local _match = function(mod, key) 
--    print("Chainz: Matching Link", #mod)
--    for _,v in pairs(mod) do 
--      if not _contains_mod(v) then 
--        return false 
--      end 
--    end
--    print(string.format("Key: %s = %s -> %s", key, _key, tostring(key==_key)))
--    if key == _key then 
--      return true 
--    else return false 
--    end
--  end
--
--
--  -- Initiate the link
--  _self.key = _key
--  _self.mod = _mod
--  _self.fn = _fn
--  _self.add = _add
--  _self.chain = _chain
--
--  _self.match = _match
--  _self.contains_mod = _contains_mod
--  return _self
--end
--
--
---- GENERATE A NEW BINDS
--local _new_binds = function()
--  local _self = {}
--  local _chain = {} 
--  local _export = {}
--  
--  local _add = function(bindstring, fn)
--    print("Added FUNCTION: ", fn)
--    local _tail = utils.split(bindstring, " ")
--    local _first = nil
--
--    while true do
--      local _head = utils.head(_tail)
--      _tail = utils.tail(_tail) -- Update _tail
--      local _next = utils.head(_tail)
--
--      if _head == nil then break end
--
--      local _link = _gen_link(_head, _tail, fn)
--
--      local _hash  = utils.hash(_next)
--      print("HASH",_hash) 
--      if _chain[_hash] == nil then -- No previous entry into the hashtable 
--        print("NIL",_chain_hash)
--        _chain[_hash] = _link
--      else
--        print("NOT NIL", _chain[_hash])
--        _chain = _chain[_hash].chain  
--      end
--      if _first == nil then _first = _chain[_hash] end
--
--    end
--    for k,v in pairs(_first.chain) do
--      print("CHAIN: ",k,v)
--    end
--    if _first ~= nil then 
--      _export[utils.hash({{}, "r"})] = _first 
--
--    end
--  end
--
--  -- Function for going through chain
--  local _callback = function(link, chain)
--    local _mods = {} 
--    local _key = nil
--    local _link = nil
--    local _chain = nil
--    local _grabbing = false
--
--    local _init = function()
--      print("INIT")
--      while _grabbing == true do end
--      grabbing = true
--      print("\n------------------------------")
--      print("Chainz: Initiating a new chain")
--      print(string.format("LINK DATA: key = %s, fn = %s, mods = %s, %s, %s, %s",link.key, tostring(link.fn), tostring(link.mod[1]), tostring(link.mod[2]), tostring(link.mod[3]), tostring(link.mod[4])))
--      
--      -- Initial Setup
--      -- Give values to _link and _mod if this is a new call
--      if _link == nil then
--        
--        -- The link should be the first link in the key chain
--        _link = link 
--
--        -- The key should be the link key
--        _key = _link.key
--
--        _chain = chain
--
--        -- The mods from link should have true
--        for _, value in pairs(_link.mod) do 
--          if value ~= nil then 
--            _mods[value] = true
--          end
--        end
--
--      end
--      
--      -- private functions
--      local _active_mods = function()
--        print("Active Mods")
--        _tbl = {}
--        for key, val in pairs(_mods) do
--          if val then _tbl[#_tbl+1] = key end
--        end
--        return _tbl
--      end
--
--      -- Grabber
--      -- This local was needed to be able to stop the grabber from within
--      local _grabber = nil
--      _grabber = awful.keygrabber.run(function(g_mod, g_key, g_event)
--        local static_link = _link
--        print("\n----------------------START GRAB---------------------\n")
--
--        print("Chainz: An event has occured:", g_event, g_key)
--
--        if g_event == "press" then 
--
--          -- Update modifiers
--          print("\n-Updating active keys-")
--          local _tmp = utils.code2key[g_key]
--          print("Pressed key", g_key)
--          if _tmp ~= nil then 
--            _mods[_tmp] = true
--          else
--            _key = g_key
--          end
--          _act = _active_mods()
--          print("Key is: ", _key)
--          print("Modifiers are: ", _act[1], _act[2], _act[3], _act[4])
--
--        elseif g_event == "release" then  
--          
--          -- Update modifiers
--          print("\n-Updating active keys-")
--          local _tmp = utils.code2key[g_key]
--          print("Released key", g_key)
--          if _tmp ~= nil then 
--            print("Key was modifier")
--            _mods[_tmp] = false
--          else
--            _key = nil
--          end
--          _act = _active_mods()
--          print("Key is: ", _key)
--          print("Modifiers are: ", _act[1], _act[2], _act[3], _act[4])
--        end
--        if static_link ~= nil and static_link.fn ~= nil then -- A bind exists for the current caught bind
--          print("\n---START MATCH---\n")
--          -- Compare the aquired mod_list with _link
--          if static_link.match(_active_mods(), g_key) then
--            print("\nChainz: A bind has been matched")
--            static_link.fn()
--            awful.keygrabber.stop(_grabber)
--            _link = nil
--            _grabbing = false
--            -- Update the external _link
--          else
--            print("\nChainz: No match found")
--            awful.keygrabber.stop(_grabber)
--            _link = nil
--            _grabbing = false
--          end
--        elseif static_link ~= nil and static_link.fn == nil then 
--          -- Attempt to move to the next node
--          -- Convert Mods and Key to a hash
--          print("\n---START NEXT NODE---\n")
--          if _active_mods() ~= nil and _key ~= nil then
--            local hash = utils.hash({_active_mods(), _key})
--            print("HASH1: ",hash)
--            print("HASH2: ",utils.hash({{},"r"}))
--            print("HASH3: ",utils.hash({{},"f"}))
--            if _chain[hash] then
--              print("WOOT!")
--              _link = static_link.chain[hash]
--              print( _link.fn)
--              return
--            end
--          end
--          
--        else -- _link is nil
--          print("CAN THE GRABBER DIE ALREADY!!!")
--          awful.keygrabber.stop(_grabber)
--        end 
--      end)
--      -- Return the keygrabber
--      return _grabber
--    end
--    return _init
--  end
--
--  local _export_fn = function() return _export end
--
--  _self.add = _add
--  _self.chain = _get_chain
--  _self.callback = _callback
--  _self.export = _export_fn
--  return _self
--end
