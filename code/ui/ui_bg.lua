-- This is probably the best written part of this mod but it's also way overcomplicated
-- All this code is used for the shuffled background in the Options menu
-- TODO UiUnloadImage() <- if you dont do that, the game will crash with too many images

function UiDrawBackground(path,scale,opacity)
    UiPush()
        UiTranslate(UiCenter(), UiMiddle())
        UiAlign("center middle")
        UiScale(scale)
        UiColorFilter(1,1,1,opacity)
        UiImage(path)
    UiPop()
    if debugMode then
        DebugWatch("UiDrawBackground() Background", path)
    end
end

Shuffle = {}
Shuffle.__index = Shuffle

function Shuffle:new(bgPaths)
    local self = setmetatable({}, Shuffle)

    self.state = 1 
    self.time = 0
    self.bgHoldTime = 10
    self.max_index = #bgPaths

    self.bgZoom = 1.2
    
    self.time_tr = 0
    self.tr_length = 1.0

    self.bgPaths = bgPaths
    self.max_index = #bgPaths

    self.reset = false

    -- Active Background
    self.bgIndex = math.random(1, self.max_index)
    self.bg = Shuffle:createBg(self.bgIndex, 1, 1, self.bgPaths[self.bgIndex])

    -- Transition Background
    local bgTrIndex = Shuffle:NextBgIndex(self.bgIndex, self.max_index)
    self.bgTr = Shuffle:createBg(bgTrIndex, 1, 0, self.bgPaths[bgTrIndex])
    
    return self
end

function Shuffle:ResetTimings()
    self.time = self.time_tr
    self.time_tr = 0
end

function Shuffle:createBg(index, scale, opacity, path)
    return {
        index     = index     or 1,
        scale     = scale     or 1,
        opacity   = opacity   or 1,
        path = path or nil
    }
end

function Shuffle:ZoomActiveBackgroundState(dt) -- State 1
    self.bg.scale = self:lerp(self.time,self.bgHoldTime, 1 ,self.bgZoom)
end

function Shuffle:TransitionFromActiveBackgroundState(dt) -- State 2
    local zoomSpeed = (self.bgZoom - 1) / self.bgHoldTime -- Keep zooming in at the same speed during a transition
    self.bg.scale = self.bg.scale + zoomSpeed * dt
    self.time_tr = self:UpdateTime(self.time_tr, dt)
    self.bgTr.opacity = self:lerp(self.time_tr, self.tr_length, 0, 1)
    self.bgTr.scale = self:lerp(self.time_tr,self.bgHoldTime,1,self.bgZoom)
end

function Shuffle:ReturnToActiveBackgroudState(dt) -- State 3
    local current_index = self.bgTr.index
    self.bg = Shuffle:createBg(current_index, self.bgTr.scale, 1, self.bgTr.path)
    local next_index = self:NextBgIndex(current_index, self.max_index)
    self.bgTr = Shuffle:createBg(next_index, 1, 0, self.bgPaths[next_index])
    self:ResetTimings()
    self.reset = true

    if debugMode then
        DebugPrint(self.bg.path)
        DebugPrint(self.bgTr.path)
    end
end

function Shuffle:scaleBg(time)
    self.bg.scale = self:lerp(time,self.bgHoldTime, 1 ,self.bgZoom)
end

function Shuffle:lerp(time, tr_time, startValue, endValue) --This lerp function isn't exactly right, consider switching the the one used in Teardown's files (ui/helpers/math.lua)
    local t = math.min(time/tr_time, 1)
    return startValue + t* (endValue-startValue)
end

function Shuffle:DisplayShuffle()
    UiDrawBackground(self.bg.path,self.bg.scale,self.bg.opacity)
    UiDrawBackground(self.bgTr.path,self.bgTr.scale,self.bgTr.opacity)
end

function Shuffle:Logic(dt)
    self:StateMachine()
    self.time = self:UpdateTime(self.time, dt)

    if self.state == 1 then
        self:ZoomActiveBackgroundState(dt)
    elseif self.state == 2 then
        self:TransitionFromActiveBackgroundState(dt)
    elseif self.state == 3 then
        self:ReturnToActiveBackgroudState(dt)
    else
        if debugMode then
            DebugWatch("Shuffle State", "Invalid") -- This should never happen
        end
    end

    self:DisplayShuffle()
end

function Shuffle:StateMachine()
    if self.state == 1 and self.time > self.bgHoldTime then
        self.state = 2
    elseif self.state == 2 and self.time_tr > self.tr_length then
        self.state = 3
    elseif self.state == 3 and self.reset then
        self.state = 1
    end

    self:Debug()
end

function Shuffle:UpdateTime(time, dt)
    time = time + dt
    return time
end

function Shuffle:NextBgIndex(bg_index, max_index)
    if (bg_index + 1) <= max_index then
        return (bg_index + 1)
    else
        return 1
    end
end

function Shuffle:Debug()
    if debugMode then
        DebugWatch("Shuffle Time", self.time)
        DebugWatch("Transition Time", self.time_tr)
        DebugWatch("State", self.state)
        DebugWatch("bg", self.bg)
        DebugWatch("bgTr", self.bgTr)
    end
end
