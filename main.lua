--loads stuff
local defaultFov = GetInt("savegame.mod.defaultFOV")
local zoomedFov = GetInt("savegame.mod.zoomedFOV")
fov = 0
local timeToZoom = GetFloat("savegame.mod.zoomSpeed")
local zoomKey = GetString("savegame.mod.ZoomKey")
local bindSet = GetBool("savegame.mod.keybindSet")
debugEnabled = false
--the fov var is used for storing the camera FOV

function init()
    fov = defaultFov 
    if defaultFov == 0 then
        if zoomedFov == 0 then
           if timeToZoom == 0 then
            DebugPrint("Teardown Zoom Mod: Please go to the mod options and change the default fov to the one you use or the mod will not work")
           end 
        end 
    end
    if (bindSet == false) then
        DebugPrint("Teardown Zoom Mod: Please go to the mod options and set a keybind or the mod will not work")
    end
end

--checks if c is pressed then zooms
function tick(dt)
    if InputPressed(zoomKey) then
        zoomIn()
    end
    
    if InputReleased(zoomKey) then
        zoomOut()
    end
    SetCameraFov(fov) 
    draw()
end

function zoomIn()
    SetValue("fov", zoomedFov, "cosine", timeToZoom)   
end

function zoomOut()
    SetValue("fov", defaultFov, "cosine", timeToZoom)
end




--draws debug
function debug()
    if InputDown("b") and InputDown("u") and InputDown("g") then
        debugEnabled = true
        stupid = false
    end    
    if debugEnabled == true then
        UiFont("bold.ttf", 24)
        UiTranslate(0,20)
        UiText("Debug Menu", true)
        UiText(fov)
        if stupid == true then
            UiTranslate(0,20)
            UiText("Ultra FOV Mode Enabled", true)
        end
        if InputPressed("p") then
            stupid = true
            zoomedFov = 170;
        end
    end
end

function draw(dt)
    debug()
end
