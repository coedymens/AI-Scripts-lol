-- ═══════════════════════════════════════════════
--   UNIVERSAL AIMBOT — GLASSMORPHISM EDITION
-- ═══════════════════════════════════════════════

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Oude verwijderen
local old = playerGui:FindFirstChild("AimbotLoading")
if old then old:Destroy() end

-- ═══ HOOFD GUI ═══
local gui = Instance.new("ScreenGui")
gui.Name = "AimbotLoading"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

-- ═══════════════════════════════════════════════
--   ACHTERGROND
-- ═══════════════════════════════════════════════
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(6, 6, 12)
bg.BackgroundTransparency = 1
bg.BorderSizePixel = 0
bg.Parent = gui

local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 6, 22)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(14, 8, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 4, 12)),
}
bgGradient.Rotation = 135
bgGradient.Parent = bg

TweenService:Create(bg, TweenInfo.new(0.7, Enum.EasingStyle.Quad), {
    BackgroundTransparency = 0
}):Play()

-- ═══════════════════════════════════════════════
--   ZWEVENDE BLOBS (achtergrond glow)
-- ═══════════════════════════════════════════════
local function makeBlob(pos, size, color)
    local blob = Instance.new("Frame")
    blob.Size = UDim2.new(0, size, 0, size)
    blob.Position = pos
    blob.AnchorPoint = Vector2.new(0.5, 0.5)
    blob.BackgroundColor3 = color
    blob.BackgroundTransparency = 1
    blob.BorderSizePixel = 0
    blob.ZIndex = 1
    blob.Parent = bg

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = blob

    local grad = Instance.new("UIGradient")
    grad.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(0.7, 0.7),
        NumberSequenceKeypoint.new(1, 1),
    }
    grad.Parent = blob

    TweenService:Create(blob, TweenInfo.new(1.2), { BackgroundTransparency = 0.85 }):Play()
    return blob
end

local blob1 = makeBlob(UDim2.new(0.15, 0, 0.25, 0), 500, Color3.fromRGB(130, 60, 255))
local blob2 = makeBlob(UDim2.new(0.85, 0, 0.75, 0), 550, Color3.fromRGB(255, 60, 180))
local blob3 = makeBlob(UDim2.new(0.5, 0, 0.15, 0), 400, Color3.fromRGB(60, 180, 255))

-- Blobs zweven
task.spawn(function()
    while blob1.Parent do
        TweenService:Create(blob1, TweenInfo.new(6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Position = UDim2.new(0.2, 0, 0.3, 0)
        }):Play()
        task.wait(6)
        TweenService:Create(blob1, TweenInfo.new(6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Position = UDim2.new(0.15, 0, 0.25, 0)
        }):Play()
        task.wait(6)
    end
end)
task.spawn(function()
    while blob2.Parent do
        TweenService:Create(blob2, TweenInfo.new(7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Position = UDim2.new(0.8, 0, 0.7, 0)
        }):Play()
        task.wait(7)
        TweenService:Create(blob2, TweenInfo.new(7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Position = UDim2.new(0.85, 0, 0.75, 0)
        }):Play()
        task.wait(7)
    end
end)
task.spawn(function()
    while blob3.Parent do
        TweenService:Create(blob3, TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Position = UDim2.new(0.55, 0, 0.2, 0)
        }):Play()
        task.wait(5)
        TweenService:Create(blob3, TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Position = UDim2.new(0.5, 0, 0.15, 0)
        }):Play()
        task.wait(5)
    end
end)

-- ═══════════════════════════════════════════════
--   GLASS BOX (morphism)
-- ═══════════════════════════════════════════════
local glassContainer = Instance.new("Frame")
glassContainer.Name = "GlassContainer"
glassContainer.Size = UDim2.new(0, 440, 0, 260)
glassContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
glassContainer.AnchorPoint = Vector2.new(0.5, 0.5)
glassContainer.BackgroundTransparency = 1
glassContainer.ZIndex = 5
glassContainer.Parent = bg

-- Glass box zelf
local glass = Instance.new("Frame")
glass.Name = "Glass"
glass.Size = UDim2.new(1, 0, 1, 0)
glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glass.BackgroundTransparency = 1
glass.BorderSizePixel = 0
glass.ZIndex = 5
glass.Parent = glassContainer

local glassCorner = Instance.new("UICorner")
glassCorner.CornerRadius = UDim.new(0, 24)
glassCorner.Parent = glass

-- Gradient voor glass feel (subtiel wit naar transparant)
local glassGrad = Instance.new("UIGradient")
glassGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 220, 240)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 230)),
}
glassGrad.Rotation = 135
glassGrad.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0.88),
    NumberSequenceKeypoint.new(0.5, 0.93),
    NumberSequenceKeypoint.new(1, 0.9),
}
glassGrad.Parent = glass

-- Glass border (dun, gradient)
local glassStroke = Instance.new("UIStroke")
glassStroke.Thickness = 1.2
glassStroke.Color = Color3.fromRGB(255, 255, 255)
glassStroke.Transparency = 1
glassStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
glassStroke.Parent = glass

local glassStrokeGrad = Instance.new("UIGradient")
glassStrokeGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 160, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 160, 230)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 200, 255)),
}
glassStrokeGrad.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0.2),
    NumberSequenceKeypoint.new(0.5, 0.5),
    NumberSequenceKeypoint.new(1, 0.7),
}
glassStrokeGrad.Rotation = 45
glassStrokeGrad.Parent = glassStroke

-- Box scale + fade in (bounce)
glassContainer.Size = UDim2.new(0, 380, 0, 220)
TweenService:Create(glassContainer, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 440, 0, 260)
}):Play()
TweenService:Create(glass, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {
    BackgroundTransparency = 0
}):Play()
TweenService:Create(glassStroke, TweenInfo.new(0.8), {
    Transparency = 0
}):Play()

-- ═══════════════════════════════════════════════
--   SHINE / GLARE animatie over de glass
-- ═══════════════════════════════════════════════
local shine = Instance.new("Frame")
shine.Size = UDim2.new(0, 100, 1.5, 0)
shine.Position = UDim2.new(-0.3, 0, -0.25, 0)
shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
shine.BackgroundTransparency = 0.85
shine.BorderSizePixel = 0
shine.Rotation = 20
shine.ZIndex = 6
shine.Parent = glass

local shineGrad = Instance.new("UIGradient")
shineGrad.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1, 1),
}
shineGrad.Parent = shine

-- Shine loop elke paar seconden
task.spawn(function()
    task.wait(1.2)
    while glass.Parent do
        shine.Position = UDim2.new(-0.3, 0, -0.25, 0)
        TweenService:Create(shine, TweenInfo.new(1.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
            Position = UDim2.new(1.3, 0, -0.25, 0)
        }):Play()
        task.wait(3.5)
    end
end)

-- ═══════════════════════════════════════════════
--   TITEL — UNIVERSAL AIMBOT
-- ═══════════════════════════════════════════════
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 55)
title.Position = UDim2.new(0.5, 0, 0.5, -155)
title.AnchorPoint = Vector2.new(0.5, 0.5)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBlack
title.Text = "UNIVERSAL AIMBOT"
title.TextSize = 40
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextTransparency = 1
title.TextStrokeTransparency = 1
title.ZIndex = 20
title.Parent = bg

local titleGrad = Instance.new("UIGradient")
titleGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 160, 255)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 160, 230)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(160, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 160, 255)),
}
titleGrad.Rotation = 0
titleGrad.Parent = title

-- Titel animatie: fade in + omhoog schuiven + gradient scroll
title.Position = UDim2.new(0.5, 0, 0.5, -120)
TweenService:Create(title, TweenInfo.new(0.9, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    TextTransparency = 0,
    Position = UDim2.new(0.5, 0, 0.5, -155),
}):Play()

-- Gradient roteert continu voor een levend effect
task.spawn(function()
    while title.Parent do
        local tween = TweenService:Create(titleGrad, TweenInfo.new(3, Enum.EasingStyle.Linear), {
            Rotation = titleGrad.Rotation + 360
        })
        tween:Play()
        tween.Completed:Wait()
    end
end)

-- Subtitel
local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0.5, 0, 0.5, -118)
subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "◆  LOADING MODULES  ◆"
subtitle.TextSize = 12
subtitle.TextColor3 = Color3.fromRGB(170, 170, 210)
subtitle.TextTransparency = 1
subtitle.ZIndex = 20
subtitle.Parent = bg

TweenService:Create(subtitle, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
    TextTransparency = 0
}):Play()

-- ═══════════════════════════════════════════════
--   CONTENT IN DE GLASS BOX
-- ═══════════════════════════════════════════════

-- Status
local status = Instance.new("TextLabel")
status.Name = "Status"
status.Size = UDim2.new(1, -50, 0, 20)
status.Position = UDim2.new(0, 25, 0, 60)
status.BackgroundTransparency = 1
status.Font = Enum.Font.GothamMedium
status.Text = "Initializing..."
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(230, 230, 245)
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextTransparency = 1
status.ZIndex = 10
status.Parent = glass

TweenService:Create(status, TweenInfo.new(0.6), { TextTransparency = 0 }):Play()

-- Percentage
local percent = Instance.new("TextLabel")
percent.Name = "Percent"
percent.Size = UDim2.new(1, -50, 0, 20)
percent.Position = UDim2.new(0, 25, 0, 60)
percent.BackgroundTransparency = 1
percent.Font = Enum.Font.GothamBold
percent.Text = "0%"
percent.TextSize = 14
percent.TextColor3 = Color3.fromRGB(200, 160, 255)
percent.TextXAlignment = Enum.TextXAlignment.Right
percent.TextTransparency = 1
percent.ZIndex = 10
percent.Parent = glass

TweenService:Create(percent, TweenInfo.new(0.6), { TextTransparency = 0 }):Play()

-- Loading bar achtergrond
local barBg = Instance.new("Frame")
barBg.Name = "BarBG"
barBg.Size = UDim2.new(1, -50, 0, 6)
barBg.Position = UDim2.new(0, 25, 0, 100)
barBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
barBg.BackgroundTransparency = 1
barBg.BorderSizePixel = 0
barBg.ZIndex = 10
barBg.Parent = glass

local barBgCorner = Instance.new("UICorner")
barBgCorner.CornerRadius = UDim.new(1, 0)
barBgCorner.Parent = barBg

TweenService:Create(barBg, TweenInfo.new(0.6), { BackgroundTransparency = 0.88 }):Play()

-- Loading bar fill
local barFill = Instance.new("Frame")
barFill.Name = "BarFill"
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
barFill.BorderSizePixel = 0
barFill.ZIndex = 11
barFill.Parent = barBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(1, 0)
barFillCorner.Parent = barFill

local barFillGrad = Instance.new("UIGradient")
barFillGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 130, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 130, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 200, 255)),
}
barFillGrad.Parent = barFill

-- Kleine glow onder de bar
local barGlow = Instance.new("Frame")
barGlow.Name = "BarGlow"
barGlow.Size = UDim2.new(0, 0, 1, 0)
barGlow.Position = UDim2.new(0, 0, 0, 0)
barGlow.BackgroundColor3 = Color3.fromRGB(255, 130, 220)
barGlow.BackgroundTransparency = 0.4
barGlow.BorderSizePixel = 0
barGlow.ZIndex = 9
barGlow.Parent = barBg

local barGlowCorner = Instance.new("UICorner")
barGlowCorner.CornerRadius = UDim.new(1, 0)
barGlowCorner.Parent = barGlow

-- Info tekst
local info = Instance.new("TextLabel")
info.Name = "Info"
info.Size = UDim2.new(1, -50, 0, 16)
info.Position = UDim2.new(0, 25, 1, -45)
info.BackgroundTransparency = 1
info.Font = Enum.Font.Gotham
info.Text = "by Universal  •  v1.0"
info.TextSize = 11
info.TextColor3 = Color3.fromRGB(150, 150, 190)
info.TextXAlignment = Enum.TextXAlignment.Left
info.TextTransparency = 1
info.ZIndex = 10
info.Parent = glass

TweenService:Create(info, TweenInfo.new(0.6), { TextTransparency = 0 }):Play()

-- Groene dot (rechtsonder in glass)
local dotContainer = Instance.new("Frame")
dotContainer.Size = UDim2.new(0, 100, 0, 16)
dotContainer.Position = UDim2.new(1, -125, 1, -45)
dotContainer.BackgroundTransparency = 1
dotContainer.ZIndex = 10
dotContainer.Parent = glass

local dot = Instance.new("Frame")
dot.Size = UDim2.new(0, 6, 0, 6)
dot.Position = UDim2.new(1, -6, 0.5, -3)
dot.AnchorPoint = Vector2.new(1, 0.5)
dot.BackgroundColor3 = Color3.fromRGB(120, 255, 140)
dot.BorderSizePixel = 0
dot.ZIndex = 11
dot.Parent = dotContainer

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = dot

local dotGlow = Instance.new("Frame")
dotGlow.Size = UDim2.new(0, 6, 0, 6)
dotGlow.Position = UDim2.new(1, -6, 0.5, -3)
dotGlow.AnchorPoint = Vector2.new(1, 0.5)
dotGlow.BackgroundColor3 = Color3.fromRGB(120, 255, 140)
dotGlow.BackgroundTransparency = 0.5
dotGlow.BorderSizePixel = 0
dotGlow.ZIndex = 10
dotGlow.Parent = dotContainer

local dotGlowCorner = Instance.new("UICorner")
dotGlowCorner.CornerRadius = UDim.new(1, 0)
dotGlowCorner.Parent = dotGlow

local dotText = Instance.new("TextLabel")
dotText.Size = UDim2.new(1, -14, 1, 0)
dotText.BackgroundTransparency = 1
dotText.Font = Enum.Font.GothamMedium
dotText.Text = "SECURE"
dotText.TextSize = 10
dotText.TextColor3 = Color3.fromRGB(150, 255, 170)
dotText.TextXAlignment = Enum.TextXAlignment.Right
dotText.TextTransparency = 1
dotText.ZIndex = 11
dotText.Parent = dotContainer

TweenService:Create(dotText, TweenInfo.new(0.6), { TextTransparency = 0 }):Play()

-- Pulsing dot + glow
task.spawn(function()
    while dot.Parent do
        TweenService:Create(dot, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0.7
        }):Play()
        TweenService:Create(dotGlow, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 14, 0, 14)
        }):Play()
        task.wait(0.9)
        TweenService:Create(dot, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundTransparency = 0
        }):Play()
        TweenService:Create(dotGlow, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Size = UDim2.new(0, 6, 0, 6)
        }):Play()
        task.wait(0.9)
    end
end)

-- ═══════════════════════════════════════════════
--   LOADING LOGICA
-- ═══════════════════════════════════════════════
local steps = {
    { time = 0.0,  percent = 0,   text = "Initializing..." },
    { time = 0.5,  percent = 15,  text = "Connecting to server..." },
    { time = 1.1,  percent = 32,  text = "Loading modules..." },
    { time = 1.7,  percent = 52,  text = "Injecting functions..." },
    { time = 2.3,  percent = 72,  text = "Setting up aimbot..." },
    { time = 2.9,  percent = 90,  text = "Almost ready..." },
    { time = 3.5,  percent = 100, text = "Ready!" },
}

task.spawn(function()
    local startTime = tick()
    for _, step in ipairs(steps) do
        task.wait(math.max(0, step.time - (tick() - startTime)))
        TweenService:Create(barFill, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(step.percent / 100, 0, 1, 0)
        }):Play()
        TweenService:Create(barGlow, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(step.percent / 100, 0, 1, 0)
        }):Play()
        status.Text = step.text
        percent.Text = step.percent .. "%"
    end
end)

-- ═══════════════════════════════════════════════
--   NA 3.5s: FADE OUT + LOADSTRING
-- ═══════════════════════════════════════════════
task.delay(3.8, function()
    -- Witte flash
    local flash = Instance.new("Frame")
    flash.Size = UDim2.new(1, 0, 1, 0)
    flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    flash.BackgroundTransparency = 1
    flash.BorderSizePixel = 0
    flash.ZIndex = 100
    flash.Parent = gui

    TweenService:Create(flash, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 0.75
    }):Play()

    task.wait(0.2)

    -- Alles smooth weg faden
    local fadeOut = TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    TweenService:Create(bg, fadeOut, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(glass, fadeOut, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(glassStroke, fadeOut, { Transparency = 1 }):Play()
    TweenService:Create(title, fadeOut, { TextTransparency = 1 }):Play()
    TweenService:Create(subtitle, fadeOut, { TextTransparency = 1 }):Play()
    TweenService:Create(status, fadeOut, { TextTransparency = 1 }):Play()
    TweenService:Create(percent, fadeOut, { TextTransparency = 1 }):Play()
    TweenService:Create(barBg, fadeOut, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(barFill, fadeOut, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(barGlow, fadeOut, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(info, fadeOut, { TextTransparency = 1 }):Play()
    TweenService:Create(dot, fadeOut, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(dotGlow, fadeOut, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(dotText, fadeOut, { TextTransparency = 1 }):Play()
    TweenService:Create(blob1, fadeOut, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(blob2, fadeOut, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(blob3, fadeOut, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(shine, fadeOut, { BackgroundTransparency = 1 }):Play()
    TweenService:Create(flash, fadeOut, { BackgroundTransparency = 1 }):Play()

    task.wait(0.65)
    gui:Destroy()

    -- ═══════════════════════════════════════════
    --   🎯 JOUW LOADSTRING
    -- ═══════════════════════════════════════════
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/coedymens/AI-Scripts-lol/refs/heads/main/aimbot.lua"))()
    end)

    if not success then
        warn("[Aimbot] Loadstring error: " .. tostring(err))
    end
end)
