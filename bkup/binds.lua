local awful = require("awful")
local menubar = require("menubar")
local _module = {}

--{{{ Default keymapping
local _default = {}

_default.global = {
    {"M-Left", awful.tag.viewprev}, 
    {"M-Right", awful.tag.viewnext}, 
    {"C-x r a", function () print("AWESOME NOW HAS CHAINBINDS C-x r was pressed") end},
    {"C-x f a", function () print("AWESOME NOW HAS CHAINBINDS C-x r was pressed") end},
--  {"M-j", function () awful.client.focus.byidx( 1) if client.focus then client.focus:raise() end end}, 
--  {"M-k", function () awful.client.focus.byidx(-1) if client.focus then client.focus:raise() end end}, 
--  {"M-w", function () mymainmenu:show() end}, 
--  {"M-S-j", function () awful.client.swap.byidx(  1)    end},
--  {"M-S-k", function () awful.client.swap.byidx( -1)    end},
--  {"M-C-j", function () awful.screen.focus_relative( 1) end},
--  {"M-C-k", function () awful.screen.focus_relative(-1) end},
--  {"M-u", awful.client.urgent.jumpto},
--  {"M-Tab", function () awful.client.focus.history.previous() if client.focus then client.focus:raise() end end },
--  {"M-Return", function () awful.util.spawn(terminal) end},
--  {"M-C-r", awesome.restart},
--  {"M-S-q", awesome.quit},

--  {"M-l",     function () awful.tag.incmwfact( 0.05)    end},
--  {"M-h",     function () awful.tag.incmwfact(-0.05)    end},
--  {"M-S-h",     function () awful.tag.incnmaster( 1)      end},
--  {"M-S-l",     function () awful.tag.incnmaster(-1)      end},
--  {"M-C-h",     function () awful.tag.incncol( 1)         end},
--  {"M-C-l",     function () awful.tag.incncol(-1)         end},
--  {"M-space", function () awful.layout.inc(layouts,  1) end},
--  {"M-S-space", function () awful.layout.inc(layouts, -1) end},
--  {"M-C-n", awful.client.restore},
--  {"M-r",     function () mypromptbox[mouse.screen]:run() end},
--  {"M-x", function () awful.prompt.run({ prompt = "Run Lua code: " }, mypromptbox[mouse.screen].widget, awful.util.eval, nil, awful.util.getdir("cache") .. "/history_eval") end},
--  {"M-p", function() menubar.show() end}
}

_default.client = {}


--}}}
--{{{ Screen like keymapping
--}}}
--{{{ Vimish behaviour
--}}}

_module.default = _default
return _module
