#include "code/common/common_utils.lua"
#include "code/ui/ui_utils.lua"
#include "code/ui/ui_options.lua"


function init()
    loadConfig()
    Opt_Init()
end

function draw()
    Opt_DrawOptionsMenu()
end