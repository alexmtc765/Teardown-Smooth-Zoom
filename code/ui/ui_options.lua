function Opt_Init()
    bgPaths = {"ui/menu/slideshow/mall1.jpg","ui/menu/slideshow/mall2.jpg","ui/menu/slideshow/caveisland3.jpg","ui/menu/slideshow/caveisland4.jpg"}
    BgPathIndex = 1
    currentBgPath = bgPaths[BgPathIndex]
    bind_state = false
    zoomInAmount = 0 -- FIX
    zoomInTimes = 0
end

function Opt_DrawOptionsMenu()
    UiButtonHoverColor(0.8,0.8,0.8)
    UiTextShadow(0, 0, 0, 0.5, 2.0)

    Opt_DrawBG()
    Opt_DrawOptBox()
    Opt_DrawLogo()
    Opt_Draw_Layout()
    Opt_DrawOptions()
    
    if not debugMode then
        saveConfig()
    end

    if debugMode then
        Opt_debug()

        if not nuked then
            saveConfig()
        end
    end
end

function Opt_DrawBG()
    UiPush()
        UiTranslate(UiCenter(), UiMiddle())
        UiAlign("center middle")
        UiImage(currentBgPath)
    UiPop()
end

function Opt_DrawOptBox()
    UiAlign("center")
    UiTranslate(UiCenter(),40)
    UiDrawBox(800, 1000, -50)
end

function Opt_DrawLogo()
    Opt_BackButton(-355,43)
    UiPush() --Logo and Name
        UiFont("bold.ttf", 64) 
        UiTranslate(-30, 80)
        UiText("Smooth Zoom")
        UiPush()
            UiScale(0.2)
            UiTranslate(1128,-300)
            --debug toggle
            if UiImageButton("img/ui/icon.png") then
                debugMode = not debugMode
                DebugPrint("Debug: " .. tostring(debugMode))
                SetBool("savegame.mod.DebugModeEnabled", debugMode)
            end
        UiPop()
    UiPop()
end

function Opt_Draw_Layout()
    UiPush()
        UiTranslate(0, 115)
        UiColor(0.5, 0.5, 0.5, 0.1)
        UiRect(800, 5)
    UiPop()

    UiPush()
        UiTranslate(0, 120)
        
        UiFont("bold.ttf", 42)
        UiPush()
            UiTranslate(0, 45)
            UiPush()
                UiTranslate(-200, 0)
                UiText("Zoom Feel")
            UiPop()
            UiPush()
                UiTranslate(200, 0)
                UiText("Zoom Extras")
            UiPop()
        UiPop()
        
        UiColor(0.5, 0.5, 0.5, 0.1)
        UiRect(5, 885)
    UiPop() 
end


function Opt_DrawOptions()
    UiTranslate(0, 220)
    UiFont("regular.ttf", 32)

    --left side
    UiPush()
        UiTranslate(-200, 0)

        UiDrawOptionName("Zoomed Out FOV", 0)
        UiPush()
            UiDrawValue(gameFOV, "º")
        UiPop()

        UiDrawOptionName("Zoomed In FOV", 80)
        UiPush()
            UiDrawValue(zoomFOV, "º")
            zoomFOV = UiAdjustmentSlider(zoomFOV, 10, gameFOV-5)
        UiPop()

        UiDrawOptionName("Zoom Speed", 200)
        UiPush()
            UiDrawValue(zoomSpeed, "s")
            UiPush()
                UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
                UiTranslate(0,25)
                UiPush()
                    UiTranslate(-40, 0)
                    if UiTextButton("-0.01") then
                        zoomSpeed = zoomSpeed - 0.01
                    end
                UiPop()

                UiPush()
                    UiTranslate(40, 0)
                    if UiTextButton("+0.01") then
                        zoomSpeed = zoomSpeed + 0.01
                    end
                UiPop()
                zoomSpeed = round(zoomSpeed,2)
                zoomSpeed = clamp(zoomSpeed,0,2) 
            UiPop()
        UiPop()

        UiDrawOptionName("Zoom Keybind", 200)
        UiPush()
            UiDrawValue("Current Bind: " .. zoomKey, "", 20, 5)
            UiPush()
                UiPush()
                    UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
                    UiTranslate(0, 25)
                    local text 
                    if not bind_state then
                        text = "Change"
                    else
                        text = "Press Any Key"
                    end
                    if UiTextButton(text) then
                        bind_state = not bind_state
                    end

                    if bind_state then
                        zoomKey = InputLastPressedKey()
                        if InputDown(zoomKey) then
                            bind_state = false
                        end
                    end

                UiPop()
            UiPop()
        UiPop()
    UiPop()

    

    --right side
    UiPush()
        UiTranslate(200, 0)
        
        UiDrawOptionName("Zoom Mode", 0)
        UiPush()
            local text
            if toggleMode then
                text = "Press " .. tostring(zoomKey) .. " to zoom in -> Press " .. tostring(zoomKey) .. " again to zoom out."
            else   
                text = "Hold " .. tostring(zoomKey) .. " to zoom in -> Let go of " .. tostring(zoomKey) .. " to zoom out."
            end
            UiDescription("Change the way you zoom in.", 24, 35)
            toggleMode = UiSwitch(toggleMode, 35, "Toggle", "Hold Down")
            UiDescription(text, 15, 70)
        UiPop()

        UiDrawOptionName("Adjustable Zoom", 200)
        UiPush()
            UiDescription("Adjust the zoom with the Scroll Wheel.", 24, 35)
            allowAdjustableZoom = UiSwitch(allowAdjustableZoom, 35)
        UiPop()

        UiDrawOptionName("Zoom While in a Vehicle", 200)
        UiPush()
            UiDescription("Allow zoom while in a vehicle.", 24, 35)
            allowVehicleZoom = UiSwitch(allowVehicleZoom, 35)
        UiPop()

        UiPush()

        UiPop()

        if debugMode then
            UiTranslate(0, 100)
            UiText("Nuke Options")
            UiPush()
                UiTranslate(0,45)
                UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
                UiFont("regular.ttf", 25)     
                if UiTextButton("Nuke Config") then
                    debugClearConfig()
                end
            UiPop()
        end
    UiPop()
end

function Opt_debug()
    -- if InputPressed("r") then -- doing this while in the settings menu seems to load you into a chapter select level?
    --     Restart()
    -- end
end


function Opt_BackButton(x,y)
    UiPush()
        UiTranslate(x,y)
        UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
        UiFont("regular.ttf", 25)     
        if UiTextButton("Back") then
            saveConfig()
            Menu()
        end
    UiPop()
end

function Opt_ResetButton(x,y)
    UiTranslate(x,y)
    UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
    UiFont("regular.ttf", 25)     
    if UiTextButton("Reset") then
        resetConfig()
    end
end