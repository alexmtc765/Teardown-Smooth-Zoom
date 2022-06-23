--functions for rounding
function roundDec(n)
    return math.floor(n * 100 + 0.5) / 100
end

function round(n)
    return math.floor(n + 0.5)
end

zoomedFov = GetInt("savegame.mod.zoomedFOV")
zoomSpeed = GetFloat("savegame.mod.zoomSpeed")
zoomSpeed = roundDec(zoomSpeed)
zoomKey = GetString("savegame.mod.ZoomKey")
changeButtonText = "Change Bind"
bindMode = false

debug = true
if (debug == true) then
    DebugWatch("Debug Enabled", true)
end

function draw()
    UiTranslate(UiCenter(), 150)
    UiAlign("center middle")

    --Title
    UiFont("bold.ttf", 48)
    UiText("Zoom Mod Options")

    --Draw Logo
    UiTranslate(0, 80)
    UiPush()
    UiScale(0.5)
    UiImage("mod-ui/icon.png")
    UiPop()

    --Draw Buttons
    UiTranslate(0, 80)
    UiFont("regular.ttf", 26)

    --Zoom Speed Buttons and text
    UiPush()
    UiText("Change Zoom Speed", true)
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
    UiPop()

    --Zoomed Fov Slider and text
    UiTranslate(0, 90)
    UiPush()
    UiText("Change Zoomed Fov", true)
    UiTranslate(-70, 20)
    UiText(zoomedFov, false)
    UiTranslate(40, 0)
    zoomedFov = UiSlider("ui/common/dot.png", "x", zoomedFov, 0, 120)
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
    UiTranslate(0, 90)
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

    --reset button , if statement used to hide the button
    UiTranslate(0, 90)
    if (zoomedFov ~= 30 or zoomSpeed ~= 0.5 or zoomKey ~= "C") then
        UiPush()

        UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
        if UiTextButton("Reset Settings") then
            zoomedFov = 30
            zoomSpeed = 0.5
            zoomKey = "C"
            
            SetFloat("savegame.mod.zoomSpeed", zoomSpeed)
            SetString("savegame.mod.ZoomKey", zoomKey)
            SetInt("savegame.mod.zoomedFOV", zoomedFov)
            
            if (debug == true) then
                DebugPrint("Reset Setttings")
            end
        end

        UiPop()
    end
end
