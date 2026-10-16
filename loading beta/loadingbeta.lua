-- ═══════════════════════════════════════════════
--   UNIVERSAL AIMBOT — MODERN LOADING SCREEN
-- ═══════════════════════════════════════════════

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Oude verwijderen
local old = playerGui:FindFirstChild("AimbotLoading")
if old then old:Destroy() end

-- ═══ GUI ═══
local gui = Instance.new("ScreenGui")
gui.Name = "AimbotLoading"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

-- ═══ ACHTERGROND (donker met blur feel) ═══
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
bg.BackgroundTransparency = 1
bg.BorderSizePixel = 0
bg.Parent = gui

local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 8, 25)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 10, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 15)),
}
bgGradient.Rotation = 90
bgGradient.Parent = bg

-- Fade in achtergrond
TweenService:Create(bg, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {
    BackgroundTransparency = 0
}):Play()

-- ═══ GLOW BLOB ACHTER DE BOX ═══
local glow = Instance.new("Frame")
glow.Size = UDim2.new(0, 500, 0, 320)
glow.Position = UDim2.new(0.5, 0, 0.5, 0)
glow.AnchorPoint = Vector2.new(0.5, 0.5)
glow.BackgroundColor3 = Color3.fromRGB(140, 80, 255)
glow.BackgroundTransparency = 1
glow.BorderSizePixel = 0
glow.ZIndex = 1
glow.Parent = bg

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 40)
glowCorner.Parent = glow

TweenService:Create(glow, TweenInfo.new(1, Enum.EasingStyle.Quad), {
    BackgroundTransparency = 0.85
}):Play()

-- Pulserende glow
task.spawn(function()
    while glow.Parent do
        TweenService:Create(glow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.7
        }):Play()
        task.wait(2)
        TweenService:Create(glow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.92
        }):Play()
        task.wait(2)
    end
end)

-- ═══ HOOFD BOX ═══
local box = Instance.new("Frame")
box.Name = "Box"
box.Size = UDim2.new(0, 420, 0, 240)
box.Position = UDim2.new(0.5, 0, 0.5, 0)
box.AnchorPoint = Vector2.new(0.5, 0.5)
box.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
box.BackgroundTransparency = 1
box.BorderSizePixel = 0
box.ZIndex = 5
box.Parent = bg

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 18)
boxCorner.Parent = box

-- Box border (stroke)
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(140, 80, 255)
stroke.Transparency = 1
stroke.Parent = box

local strokeGradient = Instance.new("UIGradient")
strokeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 100, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 180, 255)),
}
strokeGradient.Rotation = 45
strokeGradient.Parent = stroke

-- Box in animatie
TweenService:Create(box, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0.15
}):Play()
TweenService:Create(stroke, TweenInfo.new(0.5), { Transparency = 0.3 }):Play()

-- ═══ TITEL BOVEN DE BOX: "UNIVERSAL AIMBOT" ═══
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(0, 420, 0, 50)
title.Position = UDim2.new(0.5, 0, 0.5, -170)
title.AnchorPoint = Vector2.new(0.5, 0.5)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBlack
title.Text = "UNIVERSAL AIMBOT"
title.TextSize = 36
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextTransparency = 1
title.ZIndex = 10
title.Parent = bg

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 130, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 130, 230)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 200, 255)),
}
titleGradient.Parent = title

-- Titel fade + slide in
title.Position = UDim2.new(0.5, 0, 0.5, -140)
TweenService:Create(title, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    TextTransparency = 0,
    Position = UDim2.new(0.5, 0, 0.5, -170),
}):Play()

-- Subtitel onder de titel
local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(0, 420, 0, 20)
subtitle.Position = UDim2.new(0.5, 0, 0.5, -135)
subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "LOADING MODULES..."
subtitle.TextSize = 13
subtitle.TextColor3 = Color3.fromRGB(160, 160, 200)
subtitle.TextTransparency = 1
subtitle.ZIndex = 10
subtitle.Parent = bg

TweenService:Create(subtitle, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
    TextTransparency = 0
}):Play()

-- ═══ CONTENT IN DE BOX ═══
-- Status tekst
local status = Instance.new("TextLabel")
status.Name = "Status"
status.Size = UDim2.new(1, -40, 0, 20)
status.Position = UDim2.new(0, 20, 0, 30)
status.BackgroundTransparency = 1
status.Font = Enum.Font.GothamMedium
status.Text = "Initializing..."
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(220, 220, 240)
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextTransparency = 1
status.ZIndex = 6
status.Parent = box

TweenService:Create(status, TweenInfo.new(0.6), { TextTransparency = 0 }):Play()

-- Percentage
local percent = Instance.new("TextLabel")
percent.Name = "Percent"
percent.Size = UDim2.new(1, -40, 0, 20)
percent.Position = UDim2.new(0, 20, 0, 30)
percent.BackgroundTransparency = 1
percent.Font = Enum.Font.GothamBold
percent.Text = "0%"
percent.TextSize = 14
percent.TextColor3 = Color3.fromRGB(180, 130, 255)
percent.TextXAlignment = Enum.TextXAlignment.Right
percent.TextTransparency = 1
percent.ZIndex = 6
percent.Parent = box

TweenService:Create(percent, TweenInfo.new(0.6), { TextTransparency = 0 }):Play()

-- Loading bar achtergrond
local barBg = Instance.new("Frame")
barBg.Name = "BarBG"
barBg.Size = UDim2.new(1, -40, 0, 8)
barBg.Position = UDim2.new(0, 20, 0, 65)
barBg.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
barBg.BorderSizePixel = 0
barBg.BackgroundTransparency = 1
barBg.ZIndex = 6
barBg.Parent = box

local barBgCorner = Instance.new("UICorner")
barBgCorner.CornerRadius = UDim.new(1, 0)
barBgCorner.Parent = barBg

TweenService:Create(barBg, TweenInfo.new(0.5), { BackgroundTransparency = 0 }):Play()

-- Loading bar fill
local barFill = Instance.new("Frame")
barFill.Name = "BarFill"
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
barFill.BorderSizePixel = 0
barFill.ZIndex = 7
barFill.Parent = barBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(1, 0)
barFillCorner.Parent = barFill

local barFillGradient = Instance.new("UIGradient")
barFillGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 100, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 180, 255)),
}
barFillGradient.Parent = barFill

-- Glow op de bar fill
local barGlow = Instance.new("UIStroke")
barGlow.Thickness = 0
barGlow.Color = Color3.fromRGB(255, 130, 230)
barGlow.Transparency = 0.4
barGlow.Parent = barFill

-- Kleine info tekst onderaan de box
local info = Instance.new("TextLabel")
info.Name = "Info"
info.Size = UDim2.new(1, -40, 0, 16)
info.Position = UDim2.new(0, 20, 1, -35)
info.BackgroundTransparency = 1
info.Font = Enum.Font.Gotham
info.Text = "by  •  Universal  •  v1.0"
info.TextSize = 11
info.TextColor3 = Color3.fromRGB(110, 110, 140)
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextTransparency = 1
info.ZIndex = 6
info.Parent = box

TweenService:Create(info, TweenInfo.new(0.6), { TextTransparency = 0 }):Play()

-- Dot indicator rechtsonder
local dot = Instance.new("Frame")
dot.Size = UDim2.new(0, 6, 0, 6)
dot.Position = UDim2.new(1, -26, 1, -30)
dot.BackgroundColor3 = Color3.fromRGB(120, 255, 140)
dot.BorderSizePixel = 0
dot.ZIndex = 6
dot.Parent = box

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = dot

-- Pulserende dot
task.spawn(function()
    while dot.Parent do
        TweenService:Create(dot, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.7
        }):Play()
        task.wait(0.8)
        TweenService:Create(dot, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0
        }):Play()
        task.wait(0.8)
    end
end)

-- ═══ LOADING LOGICA (3.5 seconden) ═══
local LOAD_TIME = 3.5 -- seconden
local steps = {
    { time = 0.0,  percent = 0,   text = "Initializing..." },
    { time = 0.5,  percent = 15,  text = "Connecting to server..." },
    { time = 1.2,  percent = 35,  text = "Loading modules..." },
    { time = 1.8,  percent = 55,  text = "Injecting functions..." },
    { time = 2.4,  percent = 75,  text = "Setting up aimbot..." },
    { time = 3.0,  percent = 90,  text = "Almost ready..." },
    { time = 3.5,  percent = 100, text = "Ready!" },
}

-- Start alle stappen
task.spawn(function()
    local startTime = tick()
    for _, step in ipairs(steps) do
        task.wait(math.max(0, step.time - (tick() - startTime)))
        TweenService:Create(barFill, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
            Size = UDim2.new(step.percent / 100, 0, 1, 0)
        }):Play()
        status.Text = step.text
        percent.Text = step.percent .. "%"
    end
end)

-- ═══ NA 3.5s: FADE OUT + LOADSCRIPT ═══
task.delay(LOAD_TIME + 0.3, function()
    -- Flash effect
    local flash = Instance.new("Frame")
    flash.Size = UDim2.new(1, 0, 1, 0)
    flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    flash.BackgroundTransparency = 1
    flash.BorderSizePixel = 0
    flash.ZIndex = 100
    flash.Parent = gui
    
    TweenService:Create(flash, TweenInfo.new(0.15), { BackgroundTransparency = 0.8 }):Play()
    task.wait(0.15)
    
    -- Fade alles uit
    local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    TweenService:Create(box, fadeInfo, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(stroke, fadeInfo, { Transparency = 1 }):Play()
    TweenService:Create(title, fadeInfo, { TextTransparency = 1 }):Play()
    TweenService:Create(subtitle, fadeInfo, { TextTransparency = 1 }):Play()
    TweenService:Create(status, fadeInfo, { TextTransparency = 1 }):Play()
    TweenService:Create(percent, fadeInfo, { TextTransparency = 1 }):Play()
    TweenService:Create(barBg, fadeInfo, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(barFill, fadeInfo, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(info, fadeInfo, { TextTransparency = 1 }):Play()
    TweenService:Create(dot, fadeInfo, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(glow, fadeInfo, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(flash, fadeInfo, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(bg, fadeInfo, { BackgroundTransparency = 1 }):Play()
    
    task.wait(0.6)
    gui:Destroy()
    
    -- ═══════════════════════════════════════════
    --   🎯 HIER KOMT JOUW LOADSTRING
    -- ═══════════════════════════════════════════
    -- Voorbeeld:
    -- loadstring(game:HttpGet("https://raw.githubusercontent.com/coedymens/AI-Scripts-lol/refs/heads/main/aimbot.lua"))()
    -- ═══════════════════════════════════════════
end)
