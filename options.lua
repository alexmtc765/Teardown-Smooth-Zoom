debugEnabled = false
keybindMode = false
function init()
    defaultFOV = GetInt("savegame.mod.defaultFOV")
    zoomedFOV = GetInt("savegame.mod.zoomedFOV")
    zoomSpeed = GetFloat("savegame.mod.zoomSpeed")
end

function draw()
    drawMenu()
    debugUI()
    if (keybindMode == true) then
        ZoomKey = InputLastPressedKey()
        SetString("savegame.mod.ZoomKey", ZoomKey)
        if InputDown(ZoomKey) then
            DebugPrint(ZoomKey)
            keybindMode = false
            end
    end
   
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

function drawText()
    UiText("Default FOV")
    UiTranslate(0,100)
    UiText("Zoomed FOV")
    UiTranslate(0,100)
    UiText("Zoom Speed")
    UiTranslate(0,-200)
end

function centerUI()
    UiTranslate(UiCenter(), 250)
	UiAlign("center middle")
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
    if UiTextButton("Key Bind Work") then   
        keybindMode = true
        end
    end
    
    end

    if InputPressed("p") then
        --very true
        DebugPrint("This UI code is awful")
    end


function roundDec(n)
    return math.floor(n * 100 + 0.5) / 100
end

function keybindTest()
    if InputPressed("p") then
        ZoomKey = InputLastPressedKey()
        SetString("savegame.mod.ZoomKey", ZoomKey)
        DebugPrint(ZoomKey)
    end
end

function drawMenu()
    centerUI()
    UiFont("bold.ttf", 48)
    keybindTest()
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

function update()
    
end
    