#include "ui_bg.lua"

--This code is much better then the old menu but its still a mess
--TODO: Make a whole dynamic Ui system (Like UMF) but make it look like the official TD Ui

function Opt_Init()
    bgPaths = {"ui/menu/slideshow/frustrum1.jpg","ui/menu/slideshow/frustrum2.jpg","ui/menu/slideshow/mall1.jpg","ui/menu/slideshow/mall2.jpg", "ui/menu/slideshow/caveisland3.jpg", "ui/menu/slideshow/caveisland4.jpg"} -- To many images will cause the game to crash, dk if its my fault or the game has a bug
    bg = Shuffle:new(bgPaths)
    bind_state = false

    Button = {
        back = UiCreateButton("Back",{x=-355, y=43},25,function(self) saveConfig() Menu() end),
        reset = UiCreateButton("Reset",{x=355, y=765},24,function(self) resetConfig() end),
        z_keybind = UiCreateButton("Reset",{x=0, y=25},24,function(self) bind_state = not bind_state end)
    }
    
end

function Opt_DrawOptionsMenu(dt)
    UiButtonHoverColor(0.8,0.8,0.8)
    UiTextShadow(0, 0, 0, 0.5, 2.0)

    UiClipUltrawide()
    if bg then
        bg:Logic(dt)
    else
        if debugMode then
            DebugPrint("Could not initialize background")
        end
    end

    Opt_DrawOptBox()
    Opt_DrawLogo()
    Opt_Draw_Layout()
    Opt_DrawOptions()
    
    if not debugMode then
        saveConfig()
    end

    if debugMode then
        if not nuked then
            saveConfig()
        end
    end
end

function emergency_drawbg()
    UiPush()
        UiTranslate(UiCenter(), UiMiddle())
        UiAlign("center middle")
        Opt_Bg(1, 1, TransitionBgPathIndex)
    UiPop()
end

function Opt_ZoomBG(dt)

end

function Opt_DrawOptBox()
    UiAlign("center")
    UiTranslate(UiCenter(),40)
    UiDrawBox(800, 1000, -50)
end

function Opt_DrawLogo()
    UiButton(Button.back)

    UiPush() --Logo and Mod Name
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
    UiLayoutDivider(0, 115, 800, 5)
    UiLayoutDivider(0,120,5,880)

    local categorys = {"Zoom Feel", "Zoom Extras"}
    UiLayoutCategoryLabels(0, 165, 800, categorys)
end


function Opt_DrawOptions()
    UiTranslate(0, 220)
    UiFont("regular.ttf", 32)
    UiButton(Button.reset)

    UiPush() --left side
        UiTranslate(-200, 0) --Move to left half
        --ZoomFOV
        zoomFOV = UiOption(UiCreateOption("Zoom in Amount",zoomFactor() .. "x", 24, 35, 0,"slider",UiCreateSlider("More Zoom","Less Zoom",115,zoomFOV,gameFOV-5,10,{62/255, 222/255, 89/255},{222/255, 73/255, 62/255})))
        UiTranslate(0,100)
        UiPush()
            local zoomed_hspace = 80
            UiPush()
                UiTranslate(zoomed_hspace,0)
                UiDescription("Zoomed Out FOV", 24)
                UiDrawValue(gameFOV, "º")
            UiPop()
            UiPush()
                UiTranslate(-zoomed_hspace,0)
                UiDescription("Zoomed In FOV", 24)
                UiDrawValue(zoomFOV, "º")
            UiPop()
        UiPop()

        --Zoom Speed
        local temp_zoomSpeed = zoomSpeed * 1000 --UiAdjustmentSlider work around
        temp_zoomSpeed = UiOption(UiCreateOption("Zoom Speed", zoomSpeed .. "s", 24, 35, 100,"slider",UiCreateSlider("Faster Zoom","Slower Zoom",115,temp_zoomSpeed,100,0,{250/255, 183/255, 82/255},{94/255, 199/255, 255/255})))
        zoomSpeed = temp_zoomSpeed/1000
        zoomSpeed = round(zoomSpeed,2)

        --Keybind
        UiOption(UiCreateOption("Zoom Keybind", "Current Bind: " .. zoomKey, 20, 25, 150))
        UiTranslate(0,50)
        local bind_text
        if not bind_state then
            bind_text = "Change"
        else
            bind_text = "Press Any Key"
        end
        Button.z_keybind.text = bind_text
        UiButton(Button.z_keybind)
        changeKeybind()
    UiPop()
    
    UiPush() --right side
        UiTranslate(200, 0)

        toggleMode = UiOption(UiCreateOption("Zoom Mode","Change the way you zoom in.", 24, 35, 0, "switch", UiCreateSwitch(toggleMode, 35, "Hold Down", "Toggle")))
        local instruct_text
        if toggleMode then
            instruct_text = "Press " .. tostring(zoomKey) .. " to zoom in -> Press " .. tostring(zoomKey) .. " again to zoom out."
        else   
            instruct_text = "Hold " .. tostring(zoomKey) .. " to zoom in -> Let go of " .. tostring(zoomKey) .. " to zoom out."
        end

        UiPush()
            UiDescription(instruct_text, 15, 70)
        UiPop()

        allowAdjustableZoom = UiOption(UiCreateOption("Adjustable Zoom", "Adjust the zoom with the Scroll Wheel.", 24, 35, 165 , "switch", UiCreateSwitch(allowAdjustableZoom, 35)))

        allowVehicleZoom = UiOption(UiCreateOption("Zoom While in a Vehicle", "Allow zoom while in a vehicle.", 24, 35, 115, "switch", UiCreateSwitch(allowVehicleZoom, 35)))

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