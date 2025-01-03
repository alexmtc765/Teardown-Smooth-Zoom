#include "code/common/common_utils.lua"
#include "code/ui/ui_ingame.lua"
#include "code/zoom/zoom_utils.lua"

--TODO: Controller Support (For Steamdeck)

function init()
    loadConfig()
    initZoomVariables()
end

function tick(dt)
    zoomLogic()

    if PauseMenuButton("Zoom Options") then -- damn people actually used this
        showinGameOptions = true
    end

    if debugMode then
        global_debug()
    end
end

function draw()
    if showinGameOptions then
        inGameOptions()
    end

    if hideHUD then
        SetBool("hud.hide", true)
        SetBool("hud.aimdot", true)
    end
end


