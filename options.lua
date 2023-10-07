--functions for rounding
--rounds decimals
function roundDec(n)
    return math.floor(n * 100 + 0.5) / 100
end
--rounds up
function round(n)
    return math.floor(n + 0.5)
end

zoomedFov = GetInt("savegame.mod.zoomedFOV")
zoomSpeed = GetFloat("savegame.mod.zoomSpeed")
zoomSpeed = roundDec(zoomSpeed)
zoomKey = GetString("savegame.mod.ZoomKey")
changeButtonText = "Change Bind"
bindMode = false
rotation = 0
GlobalDebug = GetBool("savegame.mod.DebugModeEnabled")
togglemode = GetBool("savegame.mod.togglemode")

debug =  GetBool("savegame.mod.DebugModeEnabled")


function tick(dt)
    -- every frame
end

function draw()
    if (debug == true) then
        DebugWatch("Debug Enabled", true)
    end

    ScreenH = UiHeight()
    ScreenW = UiWidth()
    --Draw Logo in corner
  

    UiPush()
    -- puts the icon in the bottom corner, only way i found to do this, im probably stupid.
        UiTranslate(UiCenter(), ScreenH - 50)
        UiTranslate(ScreenW/2 -50, 0)
        UiRotate(rotation)
        if (rotation > 359.99) then
            rotation = 0
        end
        UiScale(0.1)
        if UiImageButton("mod-ui/icon.png") then
            --easter egg, rotates the glass smoothly and turns on debug mode!
            rotation = 0
            SetValue("rotation", 360, "cosine", 2)
            
            if (debug == false) then
                GlobalDebug = GetBool("savegame.mod.DebugModeEnabled")
                SetBool("savegame.mod.DebugModeEnabled", true)
                debug = true
                DebugPrint("Debug Enabled!")
                DebugPrint("Click the magnifying glass again to turn off debug")
            else 
                GlobalDebug = GetBool("savegame.mod.DebugModeEnabled")
                SetBool("savegame.mod.DebugModeEnabled", false)
                debug = false
                DebugPrint("Debug Disabled!")
                DebugPrint("Click the magnifying glass again to turn on debug")
            end
        end
        if (debug == true) then
            DebugWatch("rotation", rotation)
        end
       
    UiPop()

    UiTranslate(UiCenter(), 150)
    UiAlign("center middle")

    --Title
    UiFont("bold.ttf", 48)
    UiText("Zoom Mod Options")

    --Draw Buttons
    UiTranslate(0, 80)
    UiFont("regular.ttf", 26)

    --Zoom Speed Buttons and text
    UiPush()
        UiText("Zoom Speed", true)
        UiTranslate(0, 20)
        UiText(zoomSpeed, false)
        UiTranslate(-60, 0)
        UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
        if UiTextButton("-0.1") then
            zoomSpeed = zoomSpeed - 0.1
            SetFloat("savegame.mod.zoomSpeed", zoomSpeed)
        end
        UiTranslate(120, 0)
        UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
        if UiTextButton("+0.1") then
            zoomSpeed = zoomSpeed + 0.1
            SetFloat("savegame.mod.zoomSpeed", zoomSpeed)
        end
        if (zoomSpeed < 0.1) then
            zoomSpeed = 0
        end

        --save the value

        if (debug == true) then
            DebugWatch("zoomSpeed", zoomSpeed)
        end
        UiTranslate(-980,-225)
        UiAlign(top)
        --Back Button
        if UiTextButton("Back") then
            Menu()
        end
    UiPop()

    --Zoomed Fov Slider and text
    UiTranslate(0, 140)
    UiPush()
        UiText("Zoomed FOV", true)
        UiTranslate(-70, 20)
        UiText(zoomedFov, false)
        UiTranslate(40, 0)
        zoomedFov = UiSlider("ui/common/dot.png", "x", zoomedFov, 1, 120)
        zoomedFov = round(zoomedFov)

        if UiSlider then
            SetInt("savegame.mod.zoomedFOV", zoomedFov)
            if (debug == true) then
                DebugWatch("Slider Value", zoomedFov)
            end
        --save the value
        end

    UiPop()

    --Change Zoom Bind Button
    UiTranslate(0, 130)
    UiPush()
        UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
        if UiTextButton(changeButtonText) then
            bindMode = true
        end
        --checks for button then saves the last button pressed
        if (bindMode == true) then
            changeButtonText = "Press Any Key"
            zoomKey = InputLastPressedKey()
            SetString("savegame.mod.ZoomKey", zoomKey)
            if InputDown(zoomKey) then
                bindMode = false
            end
        else
            changeButtonText = "Change Bind"
        end
        UiTranslate(0, 45)
        bindCurrentText = "Current Bind: " .. zoomKey
        UiText(bindCurrentText, false)

        if (debug == true) then
            DebugWatch("zoomBind", zoomKey)
        end
    UiPop()

    --Toggle Button
    UiPush()
    UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
    UiTranslate(0, 135)
    if UiTextButton("Toggle Zoom Mode") then
        togglemode = not togglemode
        SetBool("savegame.mod.togglemode", togglemode)
        --DebugPrint(GetBool("savegame.mod.togglemode"))
        --DebugPrint(togglemode)
    end
    UiTranslate(0, 45)
    toggleText = "Toggle Zoom: " .. tostring(GetBool("savegame.mod.togglemode"))
    UiText(toggleText, false)
    UiPop()

    --reset button , if statement used to hide the button
    UiTranslate(0, 530)
    if (zoomedFov ~= 30 or zoomSpeed ~= 0.5 or zoomKey ~= "C" or togglemode ~= false) then
        UiPush()
            UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
            if UiTextButton("Reset Settings") then
                zoomedFov = 30
                zoomSpeed = 0.5
                zoomKey = "C"
                togglemode = false
                
                SetFloat("savegame.mod.zoomSpeed", zoomSpeed)
                SetString("savegame.mod.ZoomKey", zoomKey)
                SetInt("savegame.mod.zoomedFOV", zoomedFov)
                SetBool("savegame.mod.togglemode", togglemode)
                if (debug == true) then
                    DebugPrint("Reset Setttings")
                end
            end

        UiPop()
    end
end
