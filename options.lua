#include "mod_utils.lua"
#include "ui_utils.lua"

function init()
    loadConfig()
    Opt_Init()
end

function draw()
    Opt_DrawOptionsMenu()
end