local defaultFov = GetInt("savegame.mod.defaultFOV")
local zoomedFov = GetInt("savegame.mod.zoomedFOV")
fov = 0
local timeToZoom = GetFloat("savegame.mod.zoomSpeed")
debugEnabled = false


function init()
    fov = defaultFov  
end

--check if c is pressed then zooms
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
    end    
    if debugEnabled == true then
    UiFont("bold.ttf", 24)
    UiText("The Fov is: ", true)
    UiText(fov)
    end
end

function draw(dt)
    debug()
end
