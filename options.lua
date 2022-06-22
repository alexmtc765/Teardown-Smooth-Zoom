--this code is terrible I need to fix it
debugEnabled = false
keybindMode = false
bindText = "badcode"

function init()
    defaultFOV = GetInt("savegame.mod.defaultFOV")
    if defaultFOV == null or 0 then
        SetInt("savegame.mod.defaultFOV", 90)
    end
    zoomedFOV = GetInt("savegame.mod.zoomedFOV")
    if zoomedFOV == null or 0 then
        SetInt("savegame.mod.zoomedFOV", 30)
    end
    zoomSpeed = GetFloat("savegame.mod.zoomSpeed")
    if zoomSpeed == null or 0 then
        SetFloat("savegame.mod.zoomSpeed", 0.5)
    end
end

function draw()
    drawMenu()
    drawKeybindButton()
    debugUI()
end

function drawMenu()
    centerUI()
    UiFont("bold.ttf", 48)
    drawBottomButtons()
    UiTranslate(0,-100)
    UiTranslate(0,300)
    drawSliders()
    UiTranslate(0,-300)
    UiTranslate(0,345)
    drawZoomSpeed()
    UiTranslate(0,-345)
    drawText() 
end

--draws menu save and default button
function drawBottomButtons()
    UiTranslate(0,750)
    if UiTextButton("Menu") then
        Menu()
    end

    UiTranslate(800, 0)
    if UiTextButton("Default") then
        defaultFOV = 90
        zoomedFOV = 30
        zoomSpeed = 0.5
        SetInt("savegame.mod.defaultFOV", 90)
        SetInt("savegame.mod.zoomedFOV", 30)
        SetFloat("savegame.mod.zoomSpeed", 0.5)
        SetString("savegame.mod.ZoomKey", "c")
        SetBool("savegame.mod.keybindSet", true)
    end

    UiTranslate(-1600, 0)
    if UiTextButton("Save") then
        SetInt("savegame.mod.defaultFOV", defaultFOV)
        SetInt("savegame.mod.zoomedFOV", zoomedFOV)
        SetFloat("savegame.mod.zoomSpeed", zoomSpeed)
    end
    UiTranslate(800, -750) 
end

function drawSliders()
 
    defaultFOV = UiSlider("ui/common/dot.png", "x", defaultFOV, 0, 170)
    defaultFOV = round(defaultFOV)
    UiTranslate(-100, 0)
    UiText(defaultFOV,true)

    UiTranslate(0, 50)

    UiTranslate(100, 0)
    zoomedFOV = UiSlider("ui/common/dot.png", "x", zoomedFOV, 0, 170)
    zoomedFOV = round(zoomedFOV) 
    UiTranslate(-100, 0)
    UiText(zoomedFOV,true)
end

function drawZoomSpeed()
    zoomSpeed = roundDec(zoomSpeed)
    if UiTextButton("+0.1") then
        zoomSpeed = zoomSpeed + 0.1
    end
    UiTranslate(100, 0)
    if UiTextButton("-0.1") then
        zoomSpeed = zoomSpeed - 0.1 
        if (zoomSpeed < 0) then
            zoomSpeed = 0
        end
    end
    UiTranslate(100, 0)
    UiText(zoomSpeed,true)
    UiTranslate(-100, 0)
    UiTranslate(0, -100) 
    UiTranslate(0, 150)
end
--draws text inbetween buttons
function drawText()
    UiText("Default FOV")
    UiTranslate(0,100)
    UiText("Zoomed FOV")
    UiTranslate(0,100)
    UiText("Zoom Speed")
    UiTranslate(0,-200)
end

function drawKeybindButton()
    UiTranslate(0,-50)
    if UiTextButton(bindText) then 
        keybindMode = true
    end
    changeBind()
    UiTranslate(0,50)
end

function changeBind()
    if (keybindMode == true) then
        bindText = "Press a key"
        ZoomKey = InputLastPressedKey()
        SetString("savegame.mod.ZoomKey", ZoomKey)
        if InputDown(ZoomKey) then
            --DebugPrint(ZoomKey)
            keybindMode = false
            SetBool("savegame.mod.keybindSet", true)
            end
    else
        bindText = "Change Keybind"
    end
end

function centerUI()
    UiTranslate(UiCenter(), 250)
	UiAlign("center middle")
end

function roundDec(n)
    return math.floor(n * 100 + 0.5) / 100
end

function round(n)
    return math.floor(n + 0.5)
end



--draws debug ui
function debugUI()
    if InputDown("b") and InputDown("u") and InputDown("g") then
        debugEnabled = true
    end 
    if debugEnabled == true then
    UiTranslate(0, -100)
    local dfov = GetInt("savegame.mod.defaultFOV")
    UiText(dfov,true)
 
    UiTranslate(0, -100)
    local zfov = GetInt("savegame.mod.zoomedFOV")
    UiText(zfov,true)
 
    UiTranslate(0, -100)
    local zSpeed = GetFloat("savegame.mod.zoomSpeed")
    UiText(zSpeed,true)
    UiTranslate(0, -100)
    
    if UiTextButton("Bye Bye Mod Settings") then
    SetInt("savegame.mod.defaultFOV", 0)
    SetInt("savegame.mod.zoomedFOV", 0)
    SetFloat("savegame.mod.zoomSpeed", 0)
    SetString("savegame.mod.ZoomKey", " ")
    SetBool("savegame.mod.keybindSet", false)
    end
end

    if InputPressed("p") then
        --very true
        DebugPrint("This UI code is awful")
    end
end



