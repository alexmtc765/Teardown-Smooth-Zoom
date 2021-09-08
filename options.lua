--get saved fov
function init()
    defaultFOV = GetInt("savegame.mod.defaultFOV")
    zoomedFOV = GetInt("savegame.mod.zoomedFOV")
    zoomSpeed = GetFloat("savegame.mod.zoomSpeed")
end

--draws ui
function draw()
    centerUI()
    UiFont("bold.ttf", 48)
    
    UiTranslate(0, 550)
    defaultFOV = UiSlider("ui/common/dot.png", "x", defaultFOV, 0, 170)
    defaultFOV = round(defaultFOV)
    UiTranslate(-100, 0)
    UiText(defaultFOV,true)

    UiTranslate(100, 0)
    zoomedFOV = UiSlider("ui/common/dot.png", "x", zoomedFOV, 0, 170)
    zoomedFOV = round(zoomedFOV) 
    UiTranslate(-100, 0)
    UiText(zoomedFOV,true)
    
    zoomSpeed = roundDec(zoomSpeed)
    UiTranslate(100, 0)
    UiTranslate(-100, 0)
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
    --debugUI()
end

function round(n)
    return math.floor(n + 0.5)
end

function roundDec(n)
    	 return math.floor(n * 100 + 0.5) / 100
    	end
    

function centerUI()
    UiTranslate(UiCenter(), 250)
	UiAlign("center middle")
end

function debugUI()
    UiTranslate(0, -100)
    local dfov = GetInt("savegame.mod.defaultFOV")
    UiText(dfov,true)
    
    UiTranslate(0, -100)
    local zfov = GetInt("savegame.mod.zoomedFOV")
    UiText(zfov,true)
    
    UiTranslate(0, -100)
    local zSpeed = GetFloat("savegame.mod.zoomSpeed")
    UiText(zSpeed,true)
end