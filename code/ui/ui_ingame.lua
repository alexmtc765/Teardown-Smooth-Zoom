-- InGame UI

-- Reimplement Someday
-- Copy and pasted the code, probably really buggy

--In Game UI Logic
Dragging = false
UIpos = {30,60} --x,y
UISize = {300,285} --x,y
clickOut = false

function windowLogic(mx,my) -- Makes the in-game options menu act like an actual window, why did I spend time adding this? idk its nice
    
    tl_x, tl_y, br_x, br_y = UiGetCurrentWindow() -- get game window positons 

    if Dragging == false then --without this relative position it would be hard to update the window position without it snapping to the mouse
        relMousePos = {x-UIpos[1],y-UIpos[2]}
    end

    --the "hitbox" looks like this for the below code looks like this **** is hit the window the x is the hitbox
    --xxxxx*****xxxxx
    --xxxxx*****xxxxx
    --xxxxx*****xxxxx

    if mx < WindowTopPos[1] or mx > WindowBottomPos[1] or my < WindowTopPos[2] or my > WindowBottomPos[2] then --check if mouse is out of the menu box
        clickOut = true
    else
        clickOut = false
    end
  
    if mx < WindowTopPos[1] or mx > WindowBarBottomPos[1] or my < WindowTopPos[2] or my > WindowBarBottomPos[2] then -- TODO: Logic is flipped, fix this 
        --not allowed to drag
    else
        --allowed to drag
        if InputDown("lmb") then
            Dragging = true
        else
            Dragging = false
        end
    
    end

    if InputPressed("lmb") and clickOut == true then
        showinGameOptions = false
    end

    if Dragging then --used for updating window pos when dragging
        
        --these two lines update the positon
        UIpos[1] = x - relMousePos[1]
        UIpos[2] = y - relMousePos[2]

        --This code below limits the window to inside the game window
        if UIpos[1] < 10 then
            UIpos[1] = 10
        end

        if UIpos[2] < 10 then
            UIpos[2] = 10
        end
        
        if UIpos[1] > br_x-UISize[1]-10 then -- its using the game window bottom position and sub 10 because the window in game has 10px padding
            UIpos[1] = br_x-UISize[1]-10 
        end
        
        if UIpos[2] > br_y-UISize[2]-10 then
            UIpos[2] = br_y-UISize[2]-10
        end
    end
end

function inGameOptions()
    if debugEnabled == true then --debug stuff
        DebugWatch("Mouse x", x)
        DebugWatch("Mouse y", y)
        DebugWatch("WindowTopPos", WindowTopPos)
        DebugWatch("WindowBarBottomPos", WindowBarBottomPos)
        DebugWatch("WindowBottomPos", WindowBottomPos)
        DebugWatch("relMousePos", relMousePos)
        DebugWatch("ClickOut",clickOut)
    end
    
    --positions for a "hitbox" for the window and window bar
    WindowTopPos = {UIpos[1]-10,UIpos[2]-10}
    WindowBarBottomPos = {UIpos[1]+UISize[1]+10,UIpos[2]+40} 
    WindowBottomPos = {UIpos[1]+UISize[1]+10,UIpos[2]+UISize[2]+10}
    
    x, y = UiGetMousePos() --gets mouse pos at 0,0 (where the cursor is rn)
    
    UiMakeInteractive()
    UiAlign("left top")
    UiFont("regular.ttf", 24)
    
    windowLogic(x,y) --click out window and dragging logic

    UiTranslate(UIpos[1],UIpos[2])
    
    UiButtonHoverColor(0.8, 0.8, 0.8)
    
    --Background
    UiPush()
        UiColor(0, 0, 0, 0.5)
        UiImageBox("ui/common/box-solid-shadow-50.png", UISize[1], UISize[2], -50, -50)
    UiPop()
    
    --Close button
    UiPush() 
        UiButtonHoverColor(0.6, 0.6, 0.6)    
        UiTranslate(UISize[1]-30,5)
        UiScale(0.1)
        if UiImageButton("img/ui/close-window.png") then
            showinGameOptions = false
        end
    UiPop()

    --Smooth Zoom Title
    UiPush()
        UiColor(255, 255, 255, 1)
        UiFont("bold.ttf", 24)
        UiAlign("center middle")
        UiTranslate(150,20)
        
        UiText("Smooth Zoom") --when u click the smooth zoom text u can drag the window! nice

        UiTranslate(0,20)
        UiColor(255, 255, 255, 0.8)
        UiRect(296,2)
    UiPop()
    
    --Adjustment Fov 
    --TODO: add preview option check
    UiPush()
        UiTranslate(10,50)
        UiAdjustment("Zoomed Fov: ", zoomFOV)
        UiTranslate(160,13)
        zoomFOV = UiAdjustmentSlider(zoomFOV,10,gameFOV-5)   
        zoomFOV = clamp(zoomFOV,10,gameFOV)
        configZoomFOV = zoomFOV
    UiPop()
    
    --Adjust zoom speed
    UiTranslate(0,75)
    UiPush()
        UiTranslate(10,20)
        UiAdjustment("Zoom Speed: ", zoomSpeed)
        UiTranslate(160,-1)
        UiButtonImageBox("ui/common/box-outline-6.png", 4, 4)
        UiTranslate(5,0)
        zoomSpeed = round(zoomSpeed, 2)
        if UiTextButton("-.01") then
            zoomSpeed = zoomSpeed - 0.01
            zoomSpeed = round(zoomSpeed,2)
        end

        UiTranslate(60,0)
        if UiTextButton("+.01") then
            zoomSpeed = zoomSpeed + 0.01
            zoomSpeed = round(zoomSpeed,2)
        end

        if zoomSpeed < 0 then
            zoomSpeed = 0
        end
        UiTranslate(-5,0)
    UiPop()
    
    --toggle zoom
    UiTranslate(0,45)
    UiPush() -- This is done this way so the button has the opposite of the text ex button would say hold while Zoom Mode: Toggle
        local text
        
        if toggleMode == true then
            text = "Toggle"
        else
            text = "Hold"
        end
        
        local buttonText

        if toggleMode == true then
            buttonText = "Hold"
        else
            buttonText = "Toggle"
        end

        UiTranslate(10,20)
        UiAdjustment("Zoom Mode: ", text)
        UiTranslate(180,-1)
        UiButtonImageBox("ui/common/box-outline-6.png", 4, 4)
        if UiTextButton(buttonText) then
            if not toggleMode then
                toggleMode = true
            else
                toggleMode = false
            end
        end
    UiPop()

    --adjustable zoom
    UiTranslate(0,45)
    UiPush()
        local text
        if allowAdjustableZoom == true then
            text = "On"
        else
            text = "Off"
        end
        local buttonText
        if allowAdjustableZoom == true then
            buttonText = "Off"
        else
            buttonText = "On"
        end
        UiTranslate(10,20)
        UiAdjustment("Adjustable Zoom: ", text)
        UiTranslate(195,-1)
        UiButtonImageBox("ui/common/box-outline-6.png", 4, 4)
        if UiTextButton(buttonText) then
            if not allowAdjustableZoom then
                allowAdjustableZoom = true
            else
                allowAdjustableZoom = false
            end
        end
    UiPop()
    
    --Save and exit buttons
    UiTranslate(0,95)
    UiPush()
        UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
        UiAlign("center")
        UiTranslate(40,0)
        UiTranslate(0,0)
        saveConfig()
        UiColor(180, 180, 180, 1)
        UiTranslate(50,0)
        local zoomKeyLetter = tostring(zoomKey)
        zoomKeyLetter = zoomKeyLetter.upper(zoomKeyLetter)
        local pressText = "Press " .. zoomKeyLetter .. " to zoom in."
        UiColor(0.8, 0.8, 0.8, 1)
        UiText(pressText)
        UiTranslate(150,0)
        --UiText(" (menu is w.i.p)")
    UiPop()
end

function UiAdjustmentSlider(value,min,max)
    UiRect(max,3)
    UiAlign("center middle")
    value = UiSlider("ui/common/dot.png", "x", value, min, max)
    value = math.floor(value)
    return value
end

function UiAdjustment(name,value)
    text = name .. tostring(value)
    UiText(text)
end