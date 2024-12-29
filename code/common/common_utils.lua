function loadConfig()
    debugMode = HasKey("savegame.mod.DebugModeEnabled") and GetBool("savegame.mod.DebugModeEnabled") or false
    gameFOV = GetInt("options.gfx.fov")
    zoomFOV = HasKey("savegame.mod.zoomedFOV") and GetInt("savegame.mod.zoomedFOV") or (gameFOV - 45)
    zoomSpeed = HasKey("savegame.mod.zoomSpeed") and GetFloat("savegame.mod.zoomSpeed") or 0.05
    zoomSpeed = round(zoomSpeed,2)

    zoomKey = HasKey("savegame.mod.ZoomKey") and GetString("savegame.mod.ZoomKey") or "Z"
    zoomType = "cosine"
    toggleMode = HasKey("savegame.mod.togglemode") and GetBool("savegame.mod.togglemode") or false

    if HasKey("savegame.mod.adjustableZoom") then --Lua
        allowAdjustableZoom = GetBool("savegame.mod.adjustableZoom")
    else
        allowAdjustableZoom = true
    end    

    allowVehicleZoom = HasKey("savegame.mod.allowVehicleZoom") and GetBool("savegame.mod.allowVehicleZoom") or false

    if debugMode then
        DebugPrint("Loaded Config! \n")
        debugLoadedVariables()
    end
end

function saveConfig()
    SetBool("savegame.mod.DebugModeEnabled",debugMode)
    SetFloat("savegame.mod.zoomedFOV", zoomFOV)
    zoomSpeed = round(zoomSpeed,2)
    SetFloat("savegame.mod.zoomSpeed", zoomSpeed)
    SetString("savegame.mod.ZoomKey", zoomKey)
    SetString("savegame.mod.ZoomType", zoomType)
    SetBool("savegame.mod.togglemode", toggleMode)
    SetBool("savegame.mod.adjustableZoom", allowAdjustableZoom)
    SetBool("savegame.mod.allowVehicleZoom", allowVehicleZoom)

    if debugMode then
        DebugWatch("Saved Config?", "yeah")
    end
end

function resetConfig()
    debugMode = false
    zoomFOV = (gameFOV - 45)
    zoomSpeed = 0.05
    zoomKey = "Z"
    zoomType = "cosine"
    toggleMode = false 
    allowAdjustableZoom = true
    allowVehicleZoom = false

    saveConfig()
    
    if debugMode then
        DebugPrint("Reset and Saved Config! \n")
    end

    loadConfig()
end

--Math Functions
function zoomFactor()
    zoomFOVrad = deg2rad(zoomFOV)
    gameFOVrad = deg2rad(gameFOV)

    factor = math.tan(gameFOVrad/2)/math.tan(zoomFOVrad/2)
    return round(factor,1)
end

function clamp(val,min,max) --Clamps a Value
    if val > max then
        val = max
    end
    if val < min then
        val = min
    end
    return val
end

function round(value, decimalPlaces)
    local multiplier = 10^(decimalPlaces or 0)
    return math.floor(value * multiplier + 0.5) / multiplier
end

function deg2rad(deg)
    local rad
    rad = deg * (math.pi / 180)

    return rad
end


--Debug Functions
function debugLoadedVariables()
    DebugPrint("~~Loaded Variables~~\n")

    DebugPrint("Debug Mode: " .. tostring(debugMode))
    DebugPrint("Game FOV: " .. gameFOV)
    DebugPrint("Zoom FOV: " .. zoomFOV)
    DebugPrint("Zoom Speed: " .. zoomSpeed)
    DebugPrint("Zoom Key: " .. zoomKey)
    DebugPrint("Toggle Mode: " .. tostring(toggleMode))
    DebugPrint("Adjustable Zoom: " .. tostring(allowAdjustableZoom))
    DebugPrint("Vehicle Zoom: " .. tostring(allowVehicleZoom))
end

function debugClearConfig()
    DebugPrint(ListKeys("savegame.mod"))
    ClearKey("savegame.mod")
    DebugPrint("Nuked!")
    DebugPrint(ListKeys("savegame.mod"))
    nuked = true
end

function global_debug()
    if InputPressed("r") then
        Restart()
    end
    if InputPressed("p") then
        Menu()
    end
end

