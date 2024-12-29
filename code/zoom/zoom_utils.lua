function initZoomVariables()
    toggleState = false
    scrollWheelPosition = 0
    canAdjustZoom = false
    zooming = false
    playerFOV = gameFOV
    configZoomFOV = zoomFOV -- used for adjustable zoom, resets the zoomFOV after
    hideHUD = false
end

function zoomIn()
    if debugMode then
        debugZoomState = "in"
    end

    SetValue("playerFOV", zoomFOV, zoomType, zoomSpeed)
end

function zoomOut()
    if debugMode then
        debugZoomState = "out"
    end

    SetValue("playerFOV", gameFOV, zoomType, zoomSpeed)
end

function smoothZoom()
    if InputPressed(zoomKey) then
        zooming = true
        hideHUD = true
    elseif InputReleased(zoomKey) then
        zooming = false
    end
end

function toggleZoom()
    if not zooming then
        if InputPressed(zoomKey) then
            zooming = true
            hideHUD = true
        end
    else if zooming then
        if InputPressed(zoomKey) then
            zooming = false
        end
    end
end
end

function adjustPlayerFOV() --Only change player FOV when needed otherwise don't, hopefully will fix conflicts with other mods
    playerFOV = round(playerFOV,2)   
    if zooming then
        SetCameraFov(playerFOV)
    else
        if not (round((gameFOV - playerFOV),2) <= 0.01) then
            SetCameraFov(playerFOV)
        end
    end
end

function adjustZoom()
    if zooming then
        if allowAdjustableZoom then
            SetBool("game.input.locktool", true) -- Why isn't this in the api?
        end

        mouseWheelPosition = -InputValue("mousewheel")
        zoomFOV = clamp(zoomFOV + mouseWheelPosition*10, 10, gameFOV)
    else
        zoomFOV = configZoomFOV
        if allowAdjustableZoom then
            SetBool("game.input.locktool", false)
        end
    end
end

function zoomLogic()
    gameFOV = GetInt("options.gfx.fov") -- gameFOV stores the FOV set in the options of the game, always update it incase its change
    if checkIfInVehicle() then 
        if not toggleMode then
            smoothZoom()
        else
            toggleZoom()
        end

        if allowAdjustableZoom then
            adjustZoom()
        end

        if zooming then
            zoomIn()
        else
            if not (round((gameFOV - playerFOV),2) <= 0.01) then
                zoomOut()
            else 
                if debugMode then
                    debugZoomState = "none"
                end
            end
            hideHUD = false
        end

        adjustPlayerFOV()
    end

    if debugMode then
        debugWatchZoomVars()
    end
end

function checkIfInVehicle()
    if not allowVehicleZoom then
        local playerVehicle = GetPlayerVehicle()
        if playerVehicle ~= 0 then
            return false
        else
            return true
        end
    else
        return true
    end
end

--Debug 
function debugWatchZoomVars()
    local zoomVars = {
        "Zoom Variables",
        {
            debugMode = debugMode,
            gameFOV = gameFOV,
            zooming  = zooming,
            zoomSpeed = zoomSpeed,
            playerFOV = playerFOV,
            zoomState = debugZoomState,
            toggleMode = toggleMode,
            allowAdjustableZoom = allowAdjustableZoom
        }
    }
    DebugWatch("Zoom Variables", zoomVars)
end
