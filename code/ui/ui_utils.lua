function UiAdjustmentSlider(value,min,max) -- This is the only piece of code thats survived since version 1.0
    --UiTranslate(min)
    UiRect(max-min,2)
    UiTranslate(-((max)/2))
    UiAlign("center middle")
    value = UiSlider("ui/common/dot.png", "x", value, min, max)
    value = math.floor(value)
    return value
end

function UiDrawBox(w,h,r)
    UiPush()
        UiColor(0, 0, 0, 0.5)
        UiImageBox("ui/common/box-solid-shadow-50.png", w, h, r, r)
    UiPop()
end 

function UiDrawValue(value, prefix, textsize, vspacing)
    if prefix == nil then
        prefix = ""
    end

    if not vspacing then
        vspacing = 0
    end

    if not textsize then
        textsize = 24
    end

    UiTranslate(0,vspacing)
    UiFont("regular.ttf", textsize)
    UiTranslate(0, 25)
    UiText(tostring(value) .. prefix)
    UiTranslate(0, 25)
end

function UiDrawOptionName(name, vspacing, size)
    
    if size == nil then
        size = 32
    end

    UiFont("regular.ttf", size)
    UiTranslate(0, vspacing)
    UiText(name)
end

function UiDescription(text, fsize, vspace)
    UiFont("regular.ttf",fsize)
    UiTranslate(0,vspace)
    UiText(text)
end

function UiSwitch(value, vspace, disabled_text, enabled_text)
    if value == nil and debugMode then
        DebugPrint("UiSwitch is missing a value to change: Value:" .. tostring(value))
    end

    if not disabled_text then
        disabled_text = "Disabled"
    end

    if not enabled_text then
        enabled_text = "Enabled"
    end

    UiPush()
        UiTranslate(0,vspace)
        UiFont("regular.ttf",24)

        local text

        if value then
            text = enabled_text
        else
            text = disabled_text
        end

        UiText(text)
        UiPush()
            UiTranslate(0,-14)
            local arrow_hspace = 80
            UiPush()
                if not value then
                    UiTranslate(arrow_hspace,0)
                    if UiImageButton("img/ui/ui_right_arrow.png") then
                        value = true
                    end
                end
            UiPop()

            UiPush()
                if value then
                    UiTranslate(-arrow_hspace,0)
                    if UiImageButton("img/ui/ui_left_arrow.png") then
                        value = false
                    end
                end
            UiPop()
        UiPop()
    UiPop()

    return value
end

function UiClipUltrawide() -- Clip UI to 16:9 (tested on 21:9)
    tl_x, tl_y, br_x, br_y = UiGetCurrentWindow()
    UiTranslate(br_x/2-1920/2,0)
    UiClipRect(1920, 1080) 
    UiTranslate(-(br_x/2-1920/2),0)
end

function UiDrawToggle(value, vspacing, positive, negative, left_button_pos, right_button_pos)
    if not vspacing then
        vspacing = 35
    end
    if not positive then
        positive = "Yes"
    end
    if not negative then
        negative = "No"
    end
    if not left_button_pos then
        left_button_pos = -30
    end
    if not right_button_pos then
        right_button_pos = 30
    end

    UiPush()
        UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
        UiTranslate(0, vspacing)

        UiFont("regular.ttf", 24)

        UiPush()
            UiTranslate(left_button_pos, 0)
            if UiTextButton(positive) then
                value = true
            end
        UiPop()

        UiPush()
            UiTranslate(right_button_pos, 0)
            if UiTextButton(negative) then
                value = false
            end
        UiPop()
    UiPop()
    return value
end

function UiLayoutDivider(x,y,w,h)
    UiPush()
        UiTranslate(x, y)
        UiColor(0.5, 0.5, 0.5, 0.1)
        UiRect(w, h)
    UiPop()
end

function UiLayoutCategoryLabels(x, y, w, categorys)
    spacing = w/#categorys
    even = #categorys % 2 == 0
    if even then
        per_side = #categorys/2
    else
        per_side = (#categorys-1)/2
    end
    UiPush()
        UiFont("bold.ttf", 42)
        UiTranslate(x, y)
        UiTranslate(-spacing/2,0)

        for i, category in ipairs(categorys) do
            UiPush()
                if even then
                    if i <= per_side then
                        UiPush()
                            UiTranslate(-spacing*per_side,0)
                            UiTranslate(spacing*i,0)
                            UiText(category)
                        UiPop()
                    else
                        UiPush()
                            UiTranslate(spacing*(i-per_side),0)
                            UiText(category)
                        UiPop()
                    end
                end

            UiPop()
        end
    UiPop()
end

function UiCreateSlider(left_text, right_text, h_space, value, max, min, left_text_colour, right_text_colour)
    local slider = {
        left_text = left_text,
        right_text =  right_text,
        h_space = h_space,
        value = value,
        max = max,
        min = min,
        left_text_colour = left_text_colour,
        right_text_colour = right_text_colour
    }

    return slider
end

--function UiCreateKeybindOption() Eventually make this into something modular

function UiCreateOption(name, description, d_size, d_vspace, vspace, option_type, type_specific)
    local option = {
        name = name,
        description = description,
        d_size = d_size, -- Gotta find a better name for this ngl
        d_vspace = d_vspace,
        vspace = vspace,
        option_type =  option_type,
        type_specific = type_specific
    }

    return option
end

function UiZoomKeybindButton()
    UiPush()
        UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
        UiTranslate(0, 25)
        local text 
        if not bind_state then
            text = "Change"
        else
            text = "Press Any Key"
        end
        UiFont("regular.ttf",24)
        if UiTextButton(text) then
            bind_state = not bind_state
        end

        if bind_state then
            zoomKey = InputLastPressedKey()
            
            if InputDown(zoomKey) then
                bind_state = false
            end
            
            local mouseKey = InputPressed("mmb") and "mmb"
            if InputDown(mouseKey) then
                zoomKey = "mmb"
                toggleMode = true
                bind_state = false
            end

            if debugMode then
                DebugWatch("zoomKey", zoomKey)
            end
        end
    UiPop()
end


function UiSliderOption(slider)
    if slider.left_text_colour == nil then
        slider.left_text_colour = {1.0,1.0,1.0}
    end

    if slider.right_text_colour == nil then
        slider.right_text_colour = {1.0,1.0,1.0}
    end

    UiPush()
        UiTranslate(0,6) -- Work around for UiAdjustmentSlider

        UiPush() -- left Side
            UiTranslate(-slider.h_space)
            UiColor(slider.left_text_colour[1],slider.left_text_colour[2],slider.left_text_colour[3])
            UiDescription(slider.left_text, 20)
        UiPop()

        UiPush() -- Right Side
            UiTranslate(slider.h_space-5)
            UiColor(slider.right_text_colour[1],slider.right_text_colour[2],slider.right_text_colour[3])
            UiDescription(slider.right_text, 20)
        UiPop()
            slider.value = UiAdjustmentSlider(slider.value, slider.min, slider.max)
    UiPop()
    UiPop() -- closes the UiOption UiPush()
    return slider.value
end



function UiOption(option)
    UiTranslate(0, option.vspace)
    UiPush()
        UiDrawOptionName(option.name, 0)
        UiDescription(option.description, option.d_size, option.d_vspace)

        if option.option_type == "slider" then
            UiTranslate(0,15) -- UiAdjustmentSlider needs to be reworked
            return UiSliderOption(option.type_specific)
        end
    UiPop()
end