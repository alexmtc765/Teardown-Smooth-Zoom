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
    
    --checks for null values in mod settings and resets them to default

   resetKeys()
    
    --errors
    
    bindSet = GetBool("savegame.mod.keybindSet")
    
    if (bindSet == false) then
        DebugPrint("Teardown Zoom Mod: Please go to the mod options and set a keybind or the mod will not work")
    end
    
    -- defaultFOV = GetInt("savegame.mod.defaultFOV")
    -- if defaultFov == 0 then
    --     if zoomedFov == 0 then
    --        if timeToZoom == 0 then
    --         DebugPrint("Teardown Zoom Mod: Please Set up the mod in mod settings or the game might be unplayable!")
    --        end 
    --     end 
    -- end
end

function resetKeys()
    if (defaultFOV == null or 0) then
        SetInt("savegame.mod.defaultFOV", 90)
        DebugPrint("Teardown Zoom Mod: Default Fov reset, this may happen if its your first time using this mod.")
    end

    zoomedFOV = GetInt("savegame.mod.zoomedFOV")

    if (zoomedFOV == null or 0) then
        SetInt("savegame.mod.zoomedFOV", 30)
        DebugPrint("Teardown Zoom Mod: Zoomed Fov reset, this may happen if its your first time using this mod.")
    end

    zoomSpeed = GetFloat("savegame.mod.zoomSpeed")

    if (zoomSpeed == null or 0) then
        SetFloat("savegame.mod.zoomSpeed", 0.5)
        DebugPrint("Teardown Zoom Mod: Zoom Speed reset, this may happen if its your first time using this mod.")
    end

    if (zoomKey == null or 0 or "" or " ") then
        SetString("savegame.mod.zoomKey", "c")
        SetBool("savegame.mod.keybindSet", true)
        DebugPrint("Teardown Zoom Mod: Zoom Bind reset, this may happen if its your first time using this mod.")
        DebugPrint("Teardown Zoom Mod: Please Restart the Level.")
    end
end

--checks if the zoomKey is pressed then zooms
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
        DebugWatch("debugEnabled", debugEnabled)
        DebugWatch("fov", fov)
        DebugWatch("defaultFov", defaultFov)
        DebugWatch("zoomedFov", zoomedFov)
        DebugWatch("timeToZoom", timeToZoom)
        DebugWatch("zoomedFov", zoomedFov)
        DebugWatch("zoomKey", zoomKey)
        
        --old code idk if ill use it prolly wont
        --UiText("Debug Menu", true)
        --UiText(fov)
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
