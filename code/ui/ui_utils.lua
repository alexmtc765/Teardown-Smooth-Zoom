function UiAdjustmentSlider(value,min,max)
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

function UiDrawValue(value, prefix, textsize)
    if not textsize then
        textsize = 24
    end

    UiFont("regular.ttf", textsize)
    UiTranslate(0, 25)
    UiText(tostring(value) .. prefix)
    UiTranslate(0, 25)
end

function UiDrawOptionName(name, vspacing)
    UiTranslate(0, vspacing)
    UiText(name)
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