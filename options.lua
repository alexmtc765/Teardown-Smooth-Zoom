#include "code/ui/ui_options.lua"

function init()
    loadConfig()
    Opt_Init()
end

function draw(dt)
    print("hello world")
    Opt_DrawOptionsMenu(dt)
end