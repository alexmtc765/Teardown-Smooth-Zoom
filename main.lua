--loads stuff

--the fov var is used for storing the camera FOV

function init()
    debugEnabled = true
    prevDefaultFov = GetInt("options.gfx.fov") --gets fov value from settings
    defaultFOV = GetInt("options.gfx.fov") --gets fov value from settings
    zoomedFov = GetInt("savegame.mod.zoomedFOV")
    timeToZoom = GetFloat("savegame.mod.zoomSpeed")
    zoomKey = GetString("savegame.mod.ZoomKey")
    bindSet = GetBool("savegame.mod.keybindSet")
    fov = GetInt("options.gfx.fov") --gets fov value from settings
    
    --checks for null values in mod settings and resets them to default
    resetSettings()
    --errors
    

    bindSet = GetBool("savegame.mod.keybindSet")
    
    if (bindSet == false) then
        DebugPrint("Teardown Zoom Mod: Please go to the mod options and set a keybind or the mod will not work")
    end
    
end

function resetSettings()

    -- old code should probably remove
    -- if (defaultFov == null or defaultFov == 0) then
    --     SetInt("savegame.mod.defaultFOV", defaultFOV)
    --     defaultFov = GetInt("savegame.mod.defaultFOV")
    --     fov = defaultFov
    --     DebugPrint("Teardown Zoom Mod: Default Fov reset, this may happen if its your first time using this mod.")
    -- end

    if (zoomedFov == null or zoomedFov == 0) then
        SetInt("savegame.mod.zoomedFOV", 30)
        zoomedFov = GetInt("savegame.mod.zoomedFOV")
        DebugPrint("Teardown Zoom Mod: Zoomed Fov reset, this may happen if its your first time using this mod.")
    end

    if (timeToZoom == null or timeToZoom == 0) then
        SetFloat("savegame.mod.zoomSpeed", 0.5)
        timeToZoom = GetFloat("savegame.mod.zoomSpeed")
        DebugPrint("Teardown Zoom Mod: Zoom Speed reset, this may happen if its your first time using this mod.")
    end

    if (zoomKey == null or zoomKey == 0 or zoomKey == "" or zoomKey == " ") then
        SetString("savegame.mod.zoomKey", "c")
        SetBool("savegame.mod.keybindSet", true)
        zoomKey = GetString("savegame.mod.ZoomKey")
        DebugPrint("Teardown Zoom Mod: Zoom Bind reset, this may happen if its your first time using this mod.")
    end

end

--checks if the zoomKey is pressed then zooms
function tick(dt)
    defaultFov = GetInt("options.gfx.fov") --gets fov value from settings
    if (defaultFov ~= prevDefaultFov) then
        fov = defaultFov
    end

    if InputPressed(zoomKey) then
        zoomIn()
    end
    
    if InputReleased(zoomKey) then
        zoomOut()
    end
    prevDefaultFov = GetInt("options.gfx.fov") --gets fov value from settings
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
        DebugWatch("options.gfx.fov", GetInt("options.gfx.fov"))
        
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
