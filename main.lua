
local defaultFov = GetInt("savegame.mod.defaultFOV")
local zoomedFov = GetInt("savegame.mod.zoomedFOV")
fov = 0
local timeToZoom = GetFloat("savegame.mod.zoomSpeed")
debugEnabled = false
--the fov var is used for storing the camera FOV

function init()
    fov = defaultFov  
end

--checks if c is pressed then zooms
function tick(dt)
    if InputPressed("c") then
        zoomIn()
    end
    
    if InputReleased("c") then
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
