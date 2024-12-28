#include "mod_utils.lua"
#include "zoom_utils.lua"

function init()
    loadConfig()
    initZoomVariables()
end

function tick(dt)
    zoomLogic()

    if debugMode then
        global_debug()
    end
end

function draw()
    if hideHUD then
        SetBool("hud.hide", true)
        SetBool("hud.aimdot", true)
    end
end


