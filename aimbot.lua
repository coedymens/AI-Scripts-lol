-- ============================================
-- CHEAT MENU v4.2 - F = Vliegen | T = Muis Unlock
-- Plaats in: StarterPlayer > StarterPlayerScripts
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local hasDrawing = pcall(function() return Drawing.new("Line") end)
local hasFileAPI = pcall(function()
    return writefile and readfile and isfile and isfolder and makefolder and listfiles and delfile
end)

local VirtualInputManager = nil
pcall(function()
    VirtualInputManager = game:GetService("VirtualInputManager")
end)

local CONFIG_FOLDER = "CheatMenuConfigs"
local AUTOLOAD_FILE = CONFIG_FOLDER .. "/autoload.txt"

-- ============================================
-- TAAL SYSTEEM
-- ============================================
local CurrentLang = "nl"

local Translations = {
    nl = {
        tab_aimbot    = "Aimbot",
        tab_esp       = "ESP",
        tab_player    = "Speler",
        tab_config    = "Config",
        tab_settings  = "Opties",

        aim_on        = "Aimbot: AAN  [X]",
        aim_off       = "Aimbot: UIT  [X]",
        aim_mode      = "Aim Mode:",
        aim_mouse     = "Dichtst bij muis",
        aim_distance  = "Dichtstbijzijnde",
        aim_health    = "Laagste HP",
        team_check    = "Team Check",
        wall_check    = "Wall Check",
        show_fov      = "FOV Cirkel tonen",
        smoothness    = "Smoothness: %.2f",
        fov_radius    = "FOV radius: %d px",
        autoshoot     = "🔫 Auto Schiet (bij target)",
        shoot_cd      = "Schiet cooldown: %.2fs",

        esp_on        = "ESP: AAN",
        esp_off       = "ESP: UIT",
        esp_2dbox     = "2D Box",
        esp_skeleton  = "Skelet",
        esp_name      = "Naam",
        esp_health    = "Health Bar",
        esp_distance  = "Afstand",
        esp_tracer    = "Tracer",
        esp_color     = "ESP + FOV Kleur:",

        walk_speed    = "Loopsnelheid: %d",
        jump_power    = "Springkracht: %d",
        fly           = "✈️ Vliegen  [F]",
        fly_speed     = "Vliegsnelheid: %d",
        infjump       = "🦘 Oneindig Springen",
        reset_player  = "🔄 Speler Reset",

        cfg_ph        = "Config naam (bijv. 'default')",
        cfg_save      = "💾 OPSLAAN Config",
        cfg_load      = "📂 LADEN Config",
        cfg_delete    = "🗑️ VERWIJDEREN Config",
        cfg_refresh   = "🔄 Lijst Vernieuwen",
        cfg_autoload  = "Auto Laden bij join",
        cfg_empty     = "Configs: (nog geen)",
        cfg_nofile    = "Configs: File API niet beschikbaar",
        cfg_header    = "Configs:",

        set_mouse     = "🖱️ Muis Ontgrendelen  [T]",
        set_mouse_info= "Druk op T om de muis te ontgrendelen\nzodat je op de GUI kunt klikken.",
        set_mouse_btn = "🖱️ Muis Lock Togglen",
        set_lang      = "Taal:",

        notif_unlock  = "🖱️ Muis ONTGRENDELD - druk T om te locken",
        notif_lock    = "🔒 Muis LOCKED",
        notif_fly_on  = "✈️ Vliegen AAN",
        notif_fly_off = "✈️ Vliegen UIT",
        notif_loaded  = "Cheat Menu v4.2",
        notif_hint    = "X = aimbot | T = muis | F = vliegen",
    },
    en = {
        tab_aimbot    = "Aimbot",
        tab_esp       = "ESP",
        tab_player    = "Player",
        tab_config    = "Config",
        tab_settings  = "Settings",

        aim_on        = "Aimbot: ON  [X]",
        aim_off       = "Aimbot: OFF  [X]",
        aim_mode      = "Aim Mode:",
        aim_mouse     = "Closest to Mouse",
        aim_distance  = "Closest Distance",
        aim_health    = "Lowest Health",
        team_check    = "Team Check",
        wall_check    = "Wall Check",
        show_fov      = "Show FOV Circle",
        smoothness    = "Smoothness: %.2f",
        fov_radius    = "FOV radius: %d px",
        autoshoot     = "🔫 Auto Shoot (on target)",
        shoot_cd      = "Shoot cooldown: %.2fs",

        esp_on        = "ESP: ON",
        esp_off       = "ESP: OFF",
        esp_2dbox     = "2D Box",
        esp_skeleton  = "Skeleton",
        esp_name      = "Name",
        esp_health    = "Health Bar",
        esp_distance  = "Distance",
        esp_tracer    = "Tracer",
        esp_color     = "ESP + FOV Color:",

        walk_speed    = "WalkSpeed: %d",
        jump_power    = "JumpPower: %d",
        fly           = "✈️ Fly  [F]",
        fly_speed     = "Fly speed: %d",
        infjump       = "🦘 Infinite Jump",
        reset_player  = "🔄 Reset Player",

        cfg_ph        = "Config name (e.g. 'default')",
        cfg_save      = "💾 SAVE Config",
        cfg_load      = "📂 LOAD Config",
        cfg_delete    = "🗑️ DELETE Config",
        cfg_refresh   = "🔄 Refresh List",
        cfg_autoload  = "Auto Load on join",
        cfg_empty     = "Configs: (none yet)",
        cfg_nofile    = "Configs: File API not available",
        cfg_header    = "Configs:",

        set_mouse     = "🖱️ Unlock Mouse  [T]",
        set_mouse_info= "Press T to unlock the mouse\nso you can click on the GUI.",
        set_mouse_btn = "🖱️ Toggle Mouse Lock",
        set_lang      = "Language:",

        notif_unlock  = "🖱️ Mouse UNLOCKED - press T to lock",
        notif_lock    = "🔒 Mouse LOCKED",
        notif_fly_on  = "✈️ Fly ON",
        notif_fly_off = "✈️ Fly OFF",
        notif_loaded  = "Cheat Menu v4.2",
        notif_hint    = "X = aimbot | T = mouse | F = fly",
    },
}

local function T(key)
    local lang = Translations[CurrentLang] or Translations.en
    return lang[key] or key
end

local LangRefs = {}
local LangRefreshers = {}

local function reg(el, key)
    table.insert(LangRefs, {el = el, key = key})
end

local function refreshLang()
    for _, r in ipairs(LangRefs) do
        if r.el and r.el.Parent then
            r.el.Text = T(r.key)
        end
    end
    for _, fn in ipairs(LangRefreshers) do
        pcall(fn)
    end
end

-- ============================================
-- AIM MODES
-- ============================================
local AimModes = {
    {id = "mouse",    key = "aim_mouse"},
    {id = "distance", key = "aim_distance"},
    {id = "health",   key = "aim_health"},
}

local function findAimMode(id)
    for _, m in ipairs(AimModes) do
        if m.id == id then return m end
    end
    return AimModes[1]
end

local Languages = {
    {id = "nl", name = "Nederlands"},
    {id = "en", name = "English"},
}

local function findLang(id)
    for _, l in ipairs(Languages) do
        if l.id == id then return l end
    end
    return Languages[1]
end

-- ============================================
-- SETTINGS
-- ============================================
local AimSettings = {
    Enabled = false,
    Keybind = Enum.KeyCode.X,
    TeamCheck = true,
    WallCheck = true,
    FOV = 150,
    Smoothness = 0.25,
    TargetPart = "Head",
    ShowFOV = true,
    AimMode = "mouse",
    AutoShoot = false,
    ShootCooldown = 0.10,
}

local ESPSettings = {
    Enabled = false,
    TeamCheck = true,
    Box2D = true,
    Skeleton = false,
    Name = true,
    Health = true,
    Distance = false,
    Tracer = false,
    MaxDistance = 500,
    BoxColor = Color3.fromRGB(0, 255, 100),
}

local PlayerSettings = {
    Speed = 16,
    JumpPower = 50,
    Fly = false,
    FlySpeed = 80,
    InfJump = false,
}

local MiscSettings = {
    MouseUnlockKey = Enum.KeyCode.T,
    MouseUnlocked = false,
}

-- ============================================
-- GUI OPBOUW
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CheatGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 520)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = false
MainFrame.Draggable = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 60, 70)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local function isMouseOverGui()
    if not ScreenGui.Enabled then return false end
    local mousePos = UserInputService:GetMouseLocation()
    local framePos = MainFrame.AbsolutePosition
    local frameSize = MainFrame.AbsoluteSize
    return mousePos.X >= framePos.X
       and mousePos.X <= framePos.X + frameSize.X
       and mousePos.Y >= framePos.Y
       and mousePos.Y <= framePos.Y + frameSize.Y
end

-- ============================================
-- TOP BAR
-- ============================================
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, -70, 0, 30)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundTransparency = 1
TopBar.Active = true
TopBar.ZIndex = 5
TopBar.Parent = MainFrame
local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

do
    local dragging = false
    local dragStart = nil
    local startPos = nil

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
           or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
           or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ Cheat Menu v4.2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 6
Title.Parent = TopBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 26, 0, 22)
MinimizeBtn.Position = UDim2.new(1, -62, 0, 3)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 14
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.ZIndex = 10
MinimizeBtn.Parent = MainFrame
local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 4)
MinCorner.Parent = MinimizeBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 22)
CloseBtn.Position = UDim2.new(1, -32, 0, 3)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 10
CloseBtn.Parent = MainFrame
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseBtn

-- ============================================
-- TAB BAR
-- ============================================
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -16, 0, 30)
TabBar.Position = UDim2.new(0, 8, 0, 30)
TabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame
local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 6)
TabBarCorner.Parent = TabBar

local TAB_ACTIVE = Color3.fromRGB(0, 120, 200)
local TAB_INACTIVE = Color3.fromRGB(30, 30, 38)

local function makeTabBtn(langKey, xPos, xSize)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(xSize, 0, 1, 0)
    b.Position = UDim2.new(xPos, 0, 0, 0)
    b.BackgroundColor3 = TAB_INACTIVE
    b.Text = T(langKey)
    b.TextColor3 = Color3.fromRGB(200, 200, 200)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.BorderSizePixel = 0
    b.Parent = TabBar
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = b
    reg(b, langKey)
    return b
end

local AimbotTabBtn   = makeTabBtn("tab_aimbot",   0.0, 0.2)
local ESPTabBtn      = makeTabBtn("tab_esp",      0.2, 0.2)
local PlayerTabBtn   = makeTabBtn("tab_player",   0.4, 0.2)
local ConfigTabBtn   = makeTabBtn("tab_config",   0.6, 0.2)
local SettingsTabBtn = makeTabBtn("tab_settings", 0.8, 0.2)

local PageHolder = Instance.new("Frame")
PageHolder.Size = UDim2.new(1, -16, 1, -78)
PageHolder.Position = UDim2.new(0, 8, 0, 68)
PageHolder.BackgroundTransparency = 1
PageHolder.Parent = MainFrame

local function makePage()
    local p = Instance.new("Frame")
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.Parent = PageHolder
    return p
end

local AimbotPage   = makePage(); AimbotPage.Visible = true
local ESPPage      = makePage()
local PlayerPage   = makePage()
local ConfigPage   = makePage()
local SettingsPage = makePage()

local function switchTab(tab)
    AimbotPage.Visible   = (tab == "aimbot")
    ESPPage.Visible      = (tab == "esp")
    PlayerPage.Visible   = (tab == "player")
    ConfigPage.Visible   = (tab == "config")
    SettingsPage.Visible = (tab == "settings")
    AimbotTabBtn.BackgroundColor3   = (tab == "aimbot")   and TAB_ACTIVE or TAB_INACTIVE
    ESPTabBtn.BackgroundColor3      = (tab == "esp")      and TAB_ACTIVE or TAB_INACTIVE
    PlayerTabBtn.BackgroundColor3   = (tab == "player")   and TAB_ACTIVE or TAB_INACTIVE
    ConfigTabBtn.BackgroundColor3   = (tab == "config")   and TAB_ACTIVE or TAB_INACTIVE
    SettingsTabBtn.BackgroundColor3 = (tab == "settings") and TAB_ACTIVE or TAB_INACTIVE
end

AimbotTabBtn.MouseButton1Click:Connect(function() switchTab("aimbot") end)
ESPTabBtn.MouseButton1Click:Connect(function() switchTab("esp") end)
PlayerTabBtn.MouseButton1Click:Connect(function() switchTab("player") end)
ConfigTabBtn.MouseButton1Click:Connect(function() switchTab("config") end)
SettingsTabBtn.MouseButton1Click:Connect(function() switchTab("settings") end)
switchTab("aimbot")

-- ============================================
-- UI HELPERS
-- ============================================
local function createToggle(parent, langKey, yPos, defaultValue, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 26)
    Container.Position = UDim2.new(0, 0, 0, yPos)
    Container.BackgroundTransparency = 1
    Container.Parent = parent

    local Box = Instance.new("TextButton")
    Box.Size = UDim2.new(0, 18, 0, 18)
    Box.Position = UDim2.new(0, 0, 0.5, -9)
    Box.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 60)
    Box.Text = ""
    Box.BorderSizePixel = 0
    Box.Parent = Container
    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(0, 4)
    BC.Parent = Box

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -26, 1, 0)
    Label.Position = UDim2.new(0, 26, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = T(langKey)
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container
    reg(Label, langKey)

    local state = defaultValue
    Box.MouseButton1Click:Connect(function()
        state = not state
        Box.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 60)
        callback(state)
    end)

    local function setter(v)
        state = v
        Box.BackgroundColor3 = v and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 60)
    end
    return Box, setter
end

local function createButton(parent, langKey, yPos, callback, color)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.Position = UDim2.new(0, 0, 0, yPos)
    Btn.BackgroundColor3 = color or Color3.fromRGB(50, 50, 60)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Btn.Text = T(langKey)
    Btn.BorderSizePixel = 0
    Btn.Parent = parent
    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(0, 6)
    BC.Parent = Btn
    Btn.MouseButton1Click:Connect(callback)
    reg(Btn, langKey)
    return Btn
end

local function createTextbox(parent, langKey, yPos)
    local tb = Instance.new("TextBox")
    tb.Size = UDim2.new(1, 0, 0, 30)
    tb.Position = UDim2.new(0, 0, 0, yPos)
    tb.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    tb.TextColor3 = Color3.fromRGB(255, 255, 255)
    tb.Font = Enum.Font.Gotham
    tb.TextSize = 12
    tb.Text = ""
    tb.PlaceholderText = T(langKey)
    tb.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    tb.BorderSizePixel = 0
    tb.ClearTextOnFocus = false
    tb.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = tb
    table.insert(LangRefreshers, function()
        tb.PlaceholderText = T(langKey)
    end)
    return tb
end

local function createDropdown(parent, labelKey, yPos, options, defaultOption, getOptionName, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 26)
    Container.Position = UDim2.new(0, 0, 0, yPos)
    Container.BackgroundTransparency = 1
    Container.ZIndex = 10
    Container.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.45, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = T(labelKey)
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 11
    Label.Parent = Container
    if labelKey then reg(Label, labelKey) end

    local SelectBtn = Instance.new("TextButton")
    SelectBtn.Size = UDim2.new(0.55, 0, 1, 0)
    SelectBtn.Position = UDim2.new(0.45, 0, 0, 0)
    SelectBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
    SelectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SelectBtn.Font = Enum.Font.Gotham
    SelectBtn.TextSize = 12
    SelectBtn.Text = getOptionName(defaultOption) .. "  ▾"
    SelectBtn.BorderSizePixel = 0
    SelectBtn.ZIndex = 11
    SelectBtn.Parent = Container
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(0, 4)
    sc.Parent = SelectBtn
    local ss = Instance.new("UIStroke")
    ss.Color = Color3.fromRGB(80, 80, 95)
    ss.Thickness = 1
    ss.Parent = SelectBtn

    local ListFrame = Instance.new("Frame")
    ListFrame.Size = UDim2.new(0.55, 0, 0, #options * 24)
    ListFrame.Position = UDim2.new(0.45, 0, 1, 2)
    ListFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    ListFrame.BorderSizePixel = 0
    ListFrame.Visible = false
    ListFrame.ZIndex = 12
    ListFrame.Parent = Container
    local lc = Instance.new("UICorner")
    lc.CornerRadius = UDim.new(0, 4)
    lc.Parent = ListFrame
    local ls = Instance.new("UIStroke")
    ls.Color = Color3.fromRGB(80, 80, 95)
    ls.Thickness = 1
    ls.Parent = ListFrame

    local currentOption = defaultOption
    local optionButtons = {}

    for i, opt in ipairs(options) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 24)
        b.Position = UDim2.new(0, 0, 0, (i-1)*24)
        b.BackgroundTransparency = 1
        b.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        b.Text = getOptionName(opt)
        b.TextColor3 = Color3.fromRGB(220, 220, 220)
        b.Font = Enum.Font.Gotham
        b.TextSize = 12
        b.BorderSizePixel = 0
        b.ZIndex = 13
        b.Parent = ListFrame
        optionButtons[opt] = b

        b.MouseEnter:Connect(function() b.BackgroundTransparency = 0.7 end)
        b.MouseLeave:Connect(function() b.BackgroundTransparency = 1 end)
        b.MouseButton1Click:Connect(function()
            currentOption = opt
            SelectBtn.Text = getOptionName(opt) .. "  ▾"
            ListFrame.Visible = false
            callback(opt)
        end)
    end

    SelectBtn.MouseButton1Click:Connect(function()
        ListFrame.Visible = not ListFrame.Visible
    end)

    local function setter(opt)
        currentOption = opt
        SelectBtn.Text = getOptionName(opt) .. "  ▾"
    end

    table.insert(LangRefreshers, function()
        SelectBtn.Text = getOptionName(currentOption) .. "  ▾"
        for opt, btn in pairs(optionButtons) do
            btn.Text = getOptionName(opt)
        end
    end)

    return setter
end

local function createSlider(parent, yPos, min, max, defaultValue, isInt, formatFn, onChange)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 16)
    Label.Position = UDim2.new(0, 0, 0, yPos)
    Label.BackgroundTransparency = 1
    Label.Text = formatFn(defaultValue)
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = parent

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, 0, 0, 6)
    Track.Position = UDim2.new(0, 0, 0, yPos + 20)
    Track.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Track.BorderSizePixel = 0
    Track.Parent = parent
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(1, 0)
    tc.Parent = Track

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = Track
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(1, 0)
    fc.Parent = Fill

    local currentValue = defaultValue

    local function applyValue(v)
        currentValue = v
        local pct = math.clamp((v - min) / (max - min), 0, 1)
        Fill.Size = UDim2.new(pct, 0, 1, 0)
        Label.Text = formatFn(v)
        onChange(v)
    end

    table.insert(LangRefreshers, function()
        Label.Text = formatFn(currentValue)
    end)

    local dragging = false
    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local mouseX = UserInputService:GetMouseLocation().X
            local relX = math.clamp((mouseX - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
            local val = min + relX * (max - min)
            if isInt then val = math.floor(val + 0.5) end
            applyValue(val)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouseX = UserInputService:GetMouseLocation().X
            local relX = math.clamp((mouseX - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
            local val = min + relX * (max - min)
            if isInt then val = math.floor(val + 0.5) end
            applyValue(val)
        end
    end)

    return function(v) applyValue(v) end
end

-- ============================================
-- AIMBOT PAGE
-- ============================================
local AimbotToggleRef = createButton(AimbotPage, "aim_off", 0, function() toggleAimbot() end, Color3.fromRGB(50, 50, 60))

local setAimModeDropdown = createDropdown(AimbotPage, "aim_mode", 40, AimModes,
    findAimMode(AimSettings.AimMode),
    function(m) return T(m.key) end,
    function(opt) AimSettings.AimMode = opt.id end)

local _, setAimTeam    = createToggle(AimbotPage, "team_check", 72, AimSettings.TeamCheck, function(v) AimSettings.TeamCheck = v end)
local _, setAimWall    = createToggle(AimbotPage, "wall_check", 98, AimSettings.WallCheck, function(v) AimSettings.WallCheck = v end)
local _, setAimFOVShow = createToggle(AimbotPage, "show_fov", 124, AimSettings.ShowFOV, function(v) AimSettings.ShowFOV = v end)

local setSmoothSlider = createSlider(AimbotPage, 154, 0, 1, AimSettings.Smoothness, false,
    function(v) return string.format(T("smoothness"), v) end,
    function(v) AimSettings.Smoothness = v end)

local setFOVSlider = createSlider(AimbotPage, 206, 30, 600, AimSettings.FOV, true,
    function(v) return string.format(T("fov_radius"), math.floor(v)) end,
    function(v) AimSettings.FOV = v end)

local _, setAutoShootUI = createToggle(AimbotPage, "autoshoot", 258, AimSettings.AutoShoot, function(v)
    AimSettings.AutoShoot = v
end)

local setShootCooldown = createSlider(AimbotPage, 290, 0.05, 1.0, AimSettings.ShootCooldown, false,
    function(v) return string.format(T("shoot_cd"), v) end,
    function(v) AimSettings.ShootCooldown = v end)

-- ============================================
-- ESP PAGE
-- ============================================
local ESPToggleRef = createButton(ESPPage, "esp_off", 0, function() toggleESP() end, Color3.fromRGB(50, 50, 60))
local _, setESPBTeam  = createToggle(ESPPage, "team_check", 40, ESPSettings.TeamCheck, function(v) ESPSettings.TeamCheck = v end)
local _, setESPBox2D  = createToggle(ESPPage, "esp_2dbox", 66, ESPSettings.Box2D, function(v) ESPSettings.Box2D = v end)
local _, setESPSkel   = createToggle(ESPPage, "esp_skeleton", 92, ESPSettings.Skeleton, function(v) ESPSettings.Skeleton = v end)
local _, setESPName   = createToggle(ESPPage, "esp_name", 118, ESPSettings.Name, function(v) ESPSettings.Name = v end)
local _, setESPHealth = createToggle(ESPPage, "esp_health", 144, ESPSettings.Health, function(v) ESPSettings.Health = v end)
local _, setESPDist   = createToggle(ESPPage, "esp_distance", 170, ESPSettings.Distance, function(v) ESPSettings.Distance = v end)
local _, setESPTracer = createToggle(ESPPage, "esp_tracer", 196, ESPSettings.Tracer, function(v) ESPSettings.Tracer = v end)

local ColorHeader = Instance.new("TextLabel")
ColorHeader.Size = UDim2.new(0.5, 0, 0, 16)
ColorHeader.Position = UDim2.new(0, 0, 0, 226)
ColorHeader.BackgroundTransparency = 1
ColorHeader.Text = T("esp_color")
ColorHeader.TextColor3 = Color3.fromRGB(220, 220, 220)
ColorHeader.Font = Enum.Font.GothamBold
ColorHeader.TextSize = 12
ColorHeader.TextXAlignment = Enum.TextXAlignment.Left
ColorHeader.Parent = ESPPage
reg(ColorHeader, "esp_color")

local ColorPreview = Instance.new("Frame")
ColorPreview.Size = UDim2.new(0, 80, 0, 16)
ColorPreview.Position = UDim2.new(1, -80, 0, 226)
ColorPreview.BackgroundColor3 = ESPSettings.BoxColor
ColorPreview.BorderSizePixel = 0
ColorPreview.Parent = ESPPage
local CPc = Instance.new("UICorner")
CPc.CornerRadius = UDim.new(0, 4)
CPc.Parent = ColorPreview
local CPstroke = Instance.new("UIStroke")
CPstroke.Color = Color3.fromRGB(80, 80, 90)
CPstroke.Thickness = 1
CPstroke.Parent = ColorPreview

local espR = math.floor(ESPSettings.BoxColor.R * 255 + 0.5)
local espG = math.floor(ESPSettings.BoxColor.G * 255 + 0.5)
local espB = math.floor(ESPSettings.BoxColor.B * 255 + 0.5)

local function updateBoxColor()
    ESPSettings.BoxColor = Color3.fromRGB(espR, espG, espB)
    ColorPreview.BackgroundColor3 = ESPSettings.BoxColor
    if FOVStroke then FOVStroke.Color = ESPSettings.BoxColor end
end

local setRSlider = createSlider(ESPPage, 250, 0, 255, espR, true,
    function(v) return "R: " .. math.floor(v) end,
    function(v) espR = math.floor(v); updateBoxColor() end)
local setGSlider = createSlider(ESPPage, 282, 0, 255, espG, true,
    function(v) return "G: " .. math.floor(v) end,
    function(v) espG = math.floor(v); updateBoxColor() end)
local setBSlider = createSlider(ESPPage, 314, 0, 255, espB, true,
    function(v) return "B: " .. math.floor(v) end,
    function(v) espB = math.floor(v); updateBoxColor() end)

local presets = {
    {name="Green",  color=Color3.fromRGB(0, 255, 100)},
    {name="Red",    color=Color3.fromRGB(255, 50, 50)},
    {name="Blue",   color=Color3.fromRGB(50, 150, 255)},
    {name="Yellow", color=Color3.fromRGB(255, 220, 0)},
    {name="Purple", color=Color3.fromRGB(200, 80, 255)},
    {name="White",  color=Color3.fromRGB(255, 255, 255)},
}

local presetRow = Instance.new("Frame")
presetRow.Size = UDim2.new(1, 0, 0, 20)
presetRow.Position = UDim2.new(0, 0, 0, 348)
presetRow.BackgroundTransparency = 1
presetRow.Parent = ESPPage

for i, p in ipairs(presets) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 36, 0, 20)
    b.Position = UDim2.new(0, (i-1)*40, 0, 0)
    b.BackgroundColor3 = p.color
    b.Text = ""
    b.BorderSizePixel = 0
    b.Parent = presetRow
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = b
    b.MouseButton1Click:Connect(function()
        espR = math.floor(p.color.R * 255 + 0.5)
        espG = math.floor(p.color.G * 255 + 0.5)
        espB = math.floor(p.color.B * 255 + 0.5)
        ESPSettings.BoxColor = p.color
        ColorPreview.BackgroundColor3 = p.color
        if FOVStroke then FOVStroke.Color = p.color end
        setRSlider(espR); setGSlider(espG); setBSlider(espB)
    end)
end

-- ============================================
-- PLAYER PAGE
-- ============================================
local function applySpeed()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    hum.WalkSpeed = PlayerSettings.Speed
end

local function applyJumpPower()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    hum.UseJumpPower = true
    hum.JumpPower = PlayerSettings.JumpPower
end

local setSpeedSlider = createSlider(PlayerPage, 0, 16, 250, PlayerSettings.Speed, true,
    function(v) return string.format(T("walk_speed"), math.floor(v)) end,
    function(v) PlayerSettings.Speed = math.floor(v); applySpeed() end)

local setJumpSlider = createSlider(PlayerPage, 40, 50, 500, PlayerSettings.JumpPower, true,
    function(v) return string.format(T("jump_power"), math.floor(v)) end,
    function(v) PlayerSettings.JumpPower = math.floor(v); applyJumpPower() end)

local FlyRefs = { bv = nil, bg = nil }

function setFly(enabled)
    PlayerSettings.Fly = enabled
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    if FlyRefs.bv then FlyRefs.bv:Destroy(); FlyRefs.bv = nil end
    if FlyRefs.bg then FlyRefs.bg:Destroy(); FlyRefs.bg = nil end

    if enabled and hrp and hum then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "CheatMenuFly"
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.zero
        bv.Parent = hrp

        local bg = Instance.new("BodyGyro")
        bg.Name = "CheatMenuFlyGyro"
        bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        bg.P = 1000
        bg.D = 50
        bg.CFrame = hrp.CFrame
        bg.Parent = hrp

        FlyRefs.bv = bv
        FlyRefs.bg = bg
        hum.PlatformStand = true
    else
        if hum then hum.PlatformStand = false end
    end
end

local _, setFlyUI = createToggle(PlayerPage, "fly", 80, PlayerSettings.Fly, function(v)
    setFly(v)
end)

local setFlySpeedSlider = createSlider(PlayerPage, 116, 20, 400, PlayerSettings.FlySpeed, true,
    function(v) return string.format(T("fly_speed"), math.floor(v)) end,
    function(v) PlayerSettings.FlySpeed = math.floor(v) end)

local _, setInfJumpUI = createToggle(PlayerPage, "infjump", 156, PlayerSettings.InfJump, function(v)
    PlayerSettings.InfJump = v
end)

createButton(PlayerPage, "reset_player", 196, function()
    PlayerSettings.Speed = 16
    PlayerSettings.JumpPower = 50
    PlayerSettings.FlySpeed = 80
    PlayerSettings.InfJump = false
    setSpeedSlider(16)
    setJumpSlider(50)
    setFlySpeedSlider(80)
    setInfJumpUI(false)
    setFly(false)
    setFlyUI(false)
    applySpeed()
    applyJumpPower()
end, Color3.fromRGB(120, 80, 40))

UserInputService.JumpRequest:Connect(function()
    if PlayerSettings.InfJump then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.4)
    applySpeed()
    applyJumpPower()
    if PlayerSettings.Fly then setFly(true) end
end)

task.spawn(function()
    task.wait(1)
    applySpeed()
    applyJumpPower()
end)

-- ============================================
-- CONFIG PAGE
-- ============================================
local ConfigNameBox = createTextbox(ConfigPage, "cfg_ph", 0)
createButton(ConfigPage, "cfg_save", 40, function() saveConfig(ConfigNameBox.Text) end, Color3.fromRGB(0, 140, 60))
createButton(ConfigPage, "cfg_load", 78, function() loadConfig(ConfigNameBox.Text) end, Color3.fromRGB(0, 120, 200))
createButton(ConfigPage, "cfg_delete", 116, function() deleteConfig(ConfigNameBox.Text) end, Color3.fromRGB(180, 40, 40))
createButton(ConfigPage, "cfg_refresh", 154, function() updateConfigList() end, Color3.fromRGB(80, 80, 90))

local ConfigListLabel = Instance.new("TextLabel")
ConfigListLabel.Size = UDim2.new(1, 0, 0, 80)
ConfigListLabel.Position = UDim2.new(0, 0, 0, 228)
ConfigListLabel.BackgroundTransparency = 1
ConfigListLabel.Text = T("cfg_empty")
ConfigListLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
ConfigListLabel.Font = Enum.Font.Gotham
ConfigListLabel.TextSize = 11
ConfigListLabel.TextXAlignment = Enum.TextXAlignment.Left
ConfigListLabel.TextYAlignment = Enum.TextYAlignment.Top
ConfigListLabel.TextWrapped = true
ConfigListLabel.Parent = ConfigPage

-- ============================================
-- SETTINGS PAGE
-- ============================================
local function setMouseUnlocked(unlocked)
    MiscSettings.MouseUnlocked = unlocked
    if unlocked then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "CheatMenu",
                Text = T("notif_unlock"),
                Duration = 2,
            })
        end)
    else
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        UserInputService.MouseIconEnabled = false
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "CheatMenu",
                Text = T("notif_lock"),
                Duration = 2,
            })
        end)
    end
end

local _, setMouseUnlockUI = createToggle(SettingsPage, "set_mouse", 0, MiscSettings.MouseUnlocked, function(v)
    setMouseUnlocked(v)
end)

local MouseInfoLabel = Instance.new("TextLabel")
MouseInfoLabel.Size = UDim2.new(1, 0, 0, 40)
MouseInfoLabel.Position = UDim2.new(0, 0, 0, 34)
MouseInfoLabel.BackgroundTransparency = 1
MouseInfoLabel.Text = T("set_mouse_info")
MouseInfoLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
MouseInfoLabel.Font = Enum.Font.Gotham
MouseInfoLabel.TextSize = 11
MouseInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
MouseInfoLabel.TextYAlignment = Enum.TextYAlignment.Top
MouseInfoLabel.TextWrapped = true
MouseInfoLabel.Parent = SettingsPage
reg(MouseInfoLabel, "set_mouse_info")

createButton(SettingsPage, "set_mouse_btn", 80, function()
    setMouseUnlocked(not MiscSettings.MouseUnlocked)
    setMouseUnlockUI(MiscSettings.MouseUnlocked)
end, Color3.fromRGB(0, 120, 200))

local setLangDropdown = createDropdown(SettingsPage, "set_lang", 124, Languages,
    findLang(CurrentLang),
    function(l) return l.name end,
    function(opt)
        CurrentLang = opt.id
        refreshLang()
    end)

-- ============================================
-- KEYBINDS (T = muis, F = vliegen)
-- ============================================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end

    -- T: muis unlock
    if input.KeyCode == MiscSettings.MouseUnlockKey then
        setMouseUnlocked(not MiscSettings.MouseUnlocked)
        setMouseUnlockUI(MiscSettings.MouseUnlocked)
    end

    -- F: vliegen toggle
    if input.KeyCode == Enum.KeyCode.F then
        setFly(not PlayerSettings.Fly)
        setFlyUI(PlayerSettings.Fly)
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "CheatMenu",
                Text = PlayerSettings.Fly and T("notif_fly_on") or T("notif_fly_off"),
                Duration = 2,
            })
        end)
    end
end)

-- ============================================
-- FOV CIRCLE
-- ============================================
local FOVCircle = Instance.new("Frame")
FOVCircle.Size = UDim2.new(0, AimSettings.FOV * 2, 0, AimSettings.FOV * 2)
FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
FOVCircle.BackgroundTransparency = 1
FOVCircle.BorderSizePixel = 0
FOVCircle.Visible = false
FOVCircle.ZIndex = 0
FOVCircle.Parent = ScreenGui

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVCircle

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Color = ESPSettings.BoxColor
FOVStroke.Thickness = 1.5
FOVStroke.Transparency = 0.3
FOVStroke.Parent = FOVCircle

-- ============================================
-- AIMBOT LOGICA
-- ============================================
function toggleAimbot()
    AimSettings.Enabled = not AimSettings.Enabled
    if AimSettings.Enabled then
        AimbotToggleRef.Text = T("aim_on")
        AimbotToggleRef.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        AimbotToggleRef.Text = T("aim_off")
        AimbotToggleRef.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    end
end

table.insert(LangRefreshers, function()
    if AimSettings.Enabled then
        AimbotToggleRef.Text = T("aim_on")
    else
        AimbotToggleRef.Text = T("aim_off")
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == AimSettings.Keybind then toggleAimbot() end
end)

local function isSameTeamAim(player)
    if not AimSettings.TeamCheck then return false end
    if not LocalPlayer.Team or not player.Team then return false end
    return player.Team == LocalPlayer.Team
end

local function isVisible(targetPart)
    if not AimSettings.WallCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local result = Workspace:Raycast(origin, direction, rayParams)
    if result then
        local hitModel = result.Instance:FindFirstAncestorOfClass("Model")
        local targetChar = targetPart:FindFirstAncestorOfClass("Model")
        return hitModel == targetChar
    end
    return true
end

local function getCandidates()
    local candidates = {}
    local mousePos = UserInputService:GetMouseLocation()
    local camPos = Camera.CFrame.Position

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if isSameTeamAim(player) then continue end

        local char = player.Character
        if not char then continue end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end

        local part = char:FindFirstChild(AimSettings.TargetPart) or char:FindFirstChild("HumanoidRootPart")
        if not part then continue end

        local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
        if not onScreen then continue end

        local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
        local worldDist = (camPos - part.Position).Magnitude

        table.insert(candidates, {
            part = part,
            screenDist = screenDist,
            worldDist = worldDist,
            health = hum.Health,
        })
    end
    return candidates
end

function getClosestTarget()
    local candidates = getCandidates()
    if #candidates == 0 then return nil end

    local mode = AimSettings.AimMode

    if mode == "mouse" then
        local best, bestDist = nil, AimSettings.FOV
        for _, c in ipairs(candidates) do
            if c.screenDist < bestDist then
                if isVisible(c.part) then
                    bestDist = c.screenDist
                    best = c.part
                end
            end
        end
        return best
    end

    if mode == "distance" then
        local best, bestDist = nil, math.huge
        for _, c in ipairs(candidates) do
            if c.worldDist < bestDist then
                if isVisible(c.part) then
                    bestDist = c.worldDist
                    best = c.part
                end
            end
        end
        return best
    end

    if mode == "health" then
        local best, bestHp = nil, math.huge
        for _, c in ipairs(candidates) do
            if c.health < bestHp then
                if isVisible(c.part) then
                    bestHp = c.health
                    best = c.part
                end
            end
        end
        return best
    end

    return nil
end

-- ============================================
-- AUTO SHOOT
-- ============================================
local lastShotTime = 0

local function fireMouseClick()
    if not VirtualInputManager then return false end
    local ok = pcall(function()
        local pos = UserInputService:GetMouseLocation()
        VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1)
        task.delay(0.03, function()
            pcall(function()
                local p2 = UserInputService:GetMouseLocation()
                VirtualInputManager:SendMouseButtonEvent(p2.X, p2.Y, 0, false, game, 1)
            end)
        end)
    end)
    return ok
end

-- ============================================
-- ESP LOGICA
-- ============================================
local ESPObjects = {}

local function createESP(player)
    if not hasDrawing then return end
    if ESPObjects[player] then return end

    local esp = {
        box2D = Drawing.new("Square"),
        name = Drawing.new("Text"),
        healthOutline = Drawing.new("Square"),
        healthFill = Drawing.new("Square"),
        distance = Drawing.new("Text"),
        tracer = Drawing.new("Line"),
        skeleton = {},
    }

    esp.box2D.Thickness = 1.5
    esp.box2D.Filled = false
    esp.box2D.Transparency = 1
    esp.box2D.Visible = false

    esp.name.Size = 14
    esp.name.Center = true
    esp.name.Outline = true
    esp.name.Font = 2
    esp.name.Visible = false

    esp.healthOutline.Thickness = 1
    esp.healthOutline.Filled = false
    esp.healthOutline.Transparency = 1
    esp.healthOutline.Visible = false

    esp.healthFill.Filled = true
    esp.healthFill.Transparency = 1
    esp.healthFill.Visible = false

    esp.distance.Size = 12
    esp.distance.Center = true
    esp.distance.Outline = true
    esp.distance.Font = 2
    esp.distance.Visible = false

    esp.tracer.Thickness = 1
    esp.tracer.Transparency = 1
    esp.tracer.Visible = false

    for i = 1, 14 do
        local line = Drawing.new("Line")
        line.Thickness = 1.5
        line.Transparency = 1
        line.Visible = false
        table.insert(esp.skeleton, line)
    end

    ESPObjects[player] = esp
end

local function removeESP(player)
    local esp = ESPObjects[player]
    if not esp then return end
    for k, v in pairs(esp) do
        if k == "skeleton" then
            for _, line in ipairs(v) do pcall(function() line:Remove() end) end
        else
            if v and v.Remove then pcall(function() v:Remove() end) end
        end
    end
    ESPObjects[player] = nil
end

Players.PlayerRemoving:Connect(removeESP)

local function updateESP()
    if not hasDrawing then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end

        local esp = ESPObjects[player]
        if not esp then continue end

        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")

        local isTeammate = false
        if ESPSettings.TeamCheck and LocalPlayer.Team and player.Team then
            isTeammate = player.Team == LocalPlayer.Team
        end

        local shouldDraw = ESPSettings.Enabled and char and hum and hum.Health > 0 and hrp and head and not isTeammate
        if shouldDraw then
            local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
            if dist > ESPSettings.MaxDistance then shouldDraw = false end
        end

        local headScreen, headOn = Camera:WorldToViewportPoint(head and head.Position or Vector3.zero)
        local feetPos = hrp and hrp.Position or Vector3.zero
        local feetScreen, feetOn = Camera:WorldToViewportPoint(feetPos)

        if not (headOn and feetOn) then shouldDraw = false end

        if not shouldDraw then
            esp.box2D.Visible = false
            esp.name.Visible = false
            esp.healthOutline.Visible = false
            esp.healthFill.Visible = false
            esp.distance.Visible = false
            esp.tracer.Visible = false
            for _, line in ipairs(esp.skeleton) do line.Visible = false end
            continue
        end

        local color = ESPSettings.BoxColor

        local topY = headScreen.Y - 8
        local bottomY = feetScreen.Y + 8
        local centerX = (headScreen.X + feetScreen.X) / 2
        local boxW = math.abs(headScreen.Y - feetScreen.Y) * 0.55 + 10
        local topLeft = Vector2.new(centerX - boxW/2, topY)
        local boxH = bottomY - topY

        esp.box2D.Visible = ESPSettings.Box2D
        esp.box2D.Color = color
        esp.box2D.Position = topLeft
        esp.box2D.Size = Vector2.new(boxW, boxH)

        if ESPSettings.Health then
            local barX = topLeft.X - 6
            local barY = topLeft.Y
            local barW = 3
            local barH = boxH
            local healthPct = hum.Health / hum.MaxHealth

            esp.healthOutline.Visible = true
            esp.healthOutline.Color = Color3.fromRGB(0, 0, 0)
            esp.healthOutline.Position = Vector2.new(barX - 1, barY - 1)
            esp.healthOutline.Size = Vector2.new(barW + 2, barH + 2)

            esp.healthFill.Visible = true
            esp.healthFill.Color = Color3.fromRGB(math.floor(255*(1-healthPct)), math.floor(255*healthPct), 0)
            local fillH = barH * healthPct
            esp.healthFill.Position = Vector2.new(barX, barY + (barH - fillH))
            esp.healthFill.Size = Vector2.new(barW, fillH)
        else
            esp.healthOutline.Visible = false
            esp.healthFill.Visible = false
        end

        if ESPSettings.Name then
            esp.name.Visible = true
            esp.name.Color = color
            esp.name.Text = player.Name
            esp.name.Position = Vector2.new(centerX, topLeft.Y - 16)
        else
            esp.name.Visible = false
        end

        if ESPSettings.Distance then
            local dist = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
            esp.distance.Visible = true
            esp.distance.Color = color
            esp.distance.Text = tostring(dist) .. "m"
            esp.distance.Position = Vector2.new(centerX, bottomY + 2)
        else
            esp.distance.Visible = false
        end

        if ESPSettings.Tracer then
            esp.tracer.Visible = true
            esp.tracer.Color = color
            esp.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            esp.tracer.To = Vector2.new(centerX, bottomY)
        else
            esp.tracer.Visible = false
        end

        if ESPSettings.Skeleton then
            local bones = {
                {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
                {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},
                {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},
                {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},
                {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},
                {"LeftLowerArm","LeftHand"},{"RightLowerArm","RightHand"},
                {"LeftLowerLeg","LeftFoot"},{"RightLowerLeg","RightFoot"},
            }
            for i, bp in ipairs(bones) do
                local line = esp.skeleton[i]
                if not line then continue end
                local p1 = char:FindFirstChild(bp[1])
                local p2 = char:FindFirstChild(bp[2])
                if p1 and p2 then
                    local s1, on1 = Camera:WorldToViewportPoint(p1.Position)
                    local s2, on2 = Camera:WorldToViewportPoint(p2.Position)
                    if on1 and on2 then
                        line.Visible = true
                        line.Color = color
                        line.From = Vector2.new(s1.X, s1.Y)
                        line.To = Vector2.new(s2.X, s2.Y)
                    else
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
            end
        else
            for _, line in ipairs(esp.skeleton) do line.Visible = false end
        end
    end

    for player, _ in pairs(ESPObjects) do
        if not player.Parent then removeESP(player) end
    end
end

function toggleESP()
    ESPSettings.Enabled = not ESPSettings.Enabled
    if ESPSettings.Enabled then
        ESPToggleRef.Text = T("esp_on")
        ESPToggleRef.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then createESP(p) end
        end
    else
        ESPToggleRef.Text = T("esp_off")
        ESPToggleRef.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then removeESP(p) end
        end
    end
end

table.insert(LangRefreshers, function()
    if ESPSettings.Enabled then
        ESPToggleRef.Text = T("esp_on")
    else
        ESPToggleRef.Text = T("esp_off")
    end
end)

Players.PlayerAdded:Connect(function(p)
    if ESPSettings.Enabled and p ~= LocalPlayer then createESP(p) end
end)

-- ============================================
-- CONFIG SYSTEEM
-- ============================================
local function serialize(tbl)
    local parts = {}
    for k, v in pairs(tbl) do
        if type(v) == "boolean" or type(v) == "number" or type(v) == "string" then
            table.insert(parts, k .. "=" .. tostring(v))
        end
    end
    return table.concat(parts, "\n")
end

local function deserialize(str, targetTable)
    for line in str:gmatch("[^\n]+") do
        local key, val = line:match("^([^=]+)=(.+)$")
        if key and val then
            local current = targetTable[key]
            if type(current) == "boolean" then
                targetTable[key] = (val == "true")
            elseif type(current) == "number" then
                targetTable[key] = tonumber(val) or current
            elseif type(current) == "string" then
                targetTable[key] = val
            end
        end
    end
end

function saveConfig(name)
    if not hasFileAPI then warn("[CheatMenu] File API niet beschikbaar.") return end
    if not name or name == "" then name = "default" end
    if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end

    local data = {
        AimEnabled=AimSettings.Enabled, AimTeam=AimSettings.TeamCheck, AimWall=AimSettings.WallCheck,
        AimFOV=AimSettings.FOV, AimSmooth=AimSettings.Smoothness, AimShowFOV=AimSettings.ShowFOV,
        AimKey=AimSettings.Keybind.Name, AimMode=AimSettings.AimMode,
        AimAutoShoot=AimSettings.AutoShoot, AimShootCd=AimSettings.ShootCooldown,
        ESPEnabled=ESPSettings.Enabled, ESPTeam=ESPSettings.TeamCheck, ESPBox2D=ESPSettings.Box2D,
        ESPSkel=ESPSettings.Skeleton, ESPName=ESPSettings.Name, ESPHealth=ESPSettings.Health,
        ESPDist=ESPSettings.Distance, ESPTracer=ESPSettings.Tracer, ESPMaxDist=ESPSettings.MaxDistance,
        ESPColorR=espR, ESPColorG=espG, ESPColorB=espB,
        PSpeed=PlayerSettings.Speed, PJump=PlayerSettings.JumpPower,
        PFly=PlayerSettings.Fly, PFlySpeed=PlayerSettings.FlySpeed, PInfJump=PlayerSettings.InfJump,
        Lang=CurrentLang,
    }

    writefile(CONFIG_FOLDER .. "/" .. name .. ".cfg", serialize(data))
    updateConfigList()
    print("[CheatMenu] Config opgeslagen: " .. name)
end

function loadConfig(name)
    if not hasFileAPI then return end
    if not name or name == "" then name = "default" end
    local path = CONFIG_FOLDER .. "/" .. name .. ".cfg"
    if not isfile(path) then warn("[CheatMenu] Config niet gevonden: " .. name) return end

    local data = readfile(path)
    local tbl = {
        AimEnabled=false, AimTeam=false, AimWall=false, AimFOV=150,
        AimSmooth=0.25, AimShowFOV=true, AimKey="X", AimMode="mouse",
        AimAutoShoot=false, AimShootCd=0.10,
        ESPEnabled=false, ESPTeam=true, ESPBox2D=true, ESPSkel=false,
        ESPName=true, ESPHealth=true, ESPDist=false, ESPTracer=false, ESPMaxDist=500,
        ESPColorR=0, ESPColorG=255, ESPColorB=100,
        PSpeed=16, PJump=50, PFly=false, PFlySpeed=80, PInfJump=false,
        Lang="nl",
    }
    deserialize(data, tbl)

    AimSettings.TeamCheck = tbl.AimTeam
    AimSettings.WallCheck = tbl.AimWall
    AimSettings.FOV = tbl.AimFOV
    AimSettings.Smoothness = tbl.AimSmooth
    AimSettings.ShowFOV = tbl.AimShowFOV
    AimSettings.AimMode = tbl.AimMode
    AimSettings.AutoShoot = tbl.AimAutoShoot
    AimSettings.ShootCooldown = tbl.AimShootCd
    pcall(function() AimSettings.Keybind = Enum.KeyCode[tbl.AimKey] end)

    setAimTeam(tbl.AimTeam)
    setAimWall(tbl.AimWall)
    setAimFOVShow(tbl.AimShowFOV)
    setSmoothSlider(tbl.AimSmooth)
    setFOVSlider(tbl.AimFOV)
    setAimModeDropdown(findAimMode(tbl.AimMode))
    setAutoShootUI(tbl.AimAutoShoot)
    setShootCooldown(tbl.AimShootCd)

    ESPSettings.TeamCheck = tbl.ESPTeam
    ESPSettings.Box2D = tbl.ESPBox2D
    ESPSettings.Skeleton = tbl.ESPSkel
    ESPSettings.Name = tbl.ESPName
    ESPSettings.Health = tbl.ESPHealth
    ESPSettings.Distance = tbl.ESPDist
    ESPSettings.Tracer = tbl.ESPTracer
    ESPSettings.MaxDistance = tbl.ESPMaxDist

    setESPBTeam(tbl.ESPTeam)
    setESPBox2D(tbl.ESPBox2D)
    setESPSkel(tbl.ESPSkel)
    setESPName(tbl.ESPName)
    setESPHealth(tbl.ESPHealth)
    setESPDist(tbl.ESPDist)
    setESPTracer(tbl.ESPTracer)

    espR = tbl.ESPColorR
    espG = tbl.ESPColorG
    espB = tbl.ESPColorB
    ESPSettings.BoxColor = Color3.fromRGB(espR, espG, espB)
    ColorPreview.BackgroundColor3 = ESPSettings.BoxColor
    if FOVStroke then FOVStroke.Color = ESPSettings.BoxColor end
    setRSlider(espR)
    setGSlider(espG)
    setBSlider(espB)

    PlayerSettings.Speed = tbl.PSpeed
    PlayerSettings.JumpPower = tbl.PJump
    PlayerSettings.FlySpeed = tbl.PFlySpeed
    PlayerSettings.InfJump = tbl.PInfJump
    setSpeedSlider(tbl.PSpeed)
    setJumpSlider(tbl.PJump)
    setFlySpeedSlider(tbl.PFlySpeed)
    setInfJumpUI(tbl.PInfJump)
    applySpeed()
    applyJumpPower()
    if tbl.PFly ~= PlayerSettings.Fly then
        setFly(tbl.PFly)
        setFlyUI(tbl.PFly)
    end

    if tbl.Lang and (tbl.Lang == "nl" or tbl.Lang == "en") then
        CurrentLang = tbl.Lang
        setLangDropdown(findLang(CurrentLang))
        refreshLang()
    end

    if tbl.AimEnabled ~= AimSettings.Enabled then toggleAimbot() end
    if tbl.ESPEnabled ~= ESPSettings.Enabled then toggleESP() end

    print("[CheatMenu] Config geladen: " .. name)
end

function deleteConfig(name)
    if not hasFileAPI then return end
    if not name or name == "" then name = "default" end
    local path = CONFIG_FOLDER .. "/" .. name .. ".cfg"
    if isfile(path) then
        delfile(path)
        updateConfigList()
        print("[CheatMenu] Config verwijderd: " .. name)
    end
end

function updateConfigList()
    if not hasFileAPI then
        ConfigListLabel.Text = T("cfg_nofile")
        return
    end
    if not isfolder(CONFIG_FOLDER) then
        ConfigListLabel.Text = T("cfg_empty")
        return
    end
    local list = listfiles(CONFIG_FOLDER)
    local names = {}
    for _, f in ipairs(list) do
        local n = f:match("([^/\\]+)%.cfg$")
        if n then table.insert(names, n) end
    end
    if #names == 0 then
        ConfigListLabel.Text = T("cfg_empty")
    else
        ConfigListLabel.Text = T("cfg_header") .. "\n  • " .. table.concat(names, "\n  • ")
    end
end

table.insert(LangRefreshers, function()
    updateConfigList()
end)

local function isAutoLoadEnabled()
    if not hasFileAPI then return false, nil end
    if not isfile(AUTOLOAD_FILE) then return false, nil end
    local name = readfile(AUTOLOAD_FILE)
    if name == "" then return false, nil end
    return true, name
end

local function setAutoLoad(enabled, name)
    if not hasFileAPI then return end
    if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
    if enabled then
        if not name or name == "" then name = "default" end
        writefile(AUTOLOAD_FILE, name)
    else
        if isfile(AUTOLOAD_FILE) then delfile(AUTOLOAD_FILE) end
    end
end

local _, setAutoLoadUI = createToggle(ConfigPage, "cfg_autoload", 192, false, function(v)
    if v then
        local name = ConfigNameBox.Text
        if name == "" then name = "default" end
        setAutoLoad(true, name)
    else
        setAutoLoad(false)
    end
end)

do
    local alEnabled, alName = isAutoLoadEnabled()
    if alEnabled then
        setAutoLoadUI(true)
        if alName then ConfigNameBox.Text = alName end
        task.spawn(function()
            task.wait(1)
            loadConfig(alName)
            print("[CheatMenu] Autoload uitgevoerd: " .. alName)
        end)
    end
end

updateConfigList()

-- ============================================
-- CLOSE & MINIMIZE
-- ============================================
local minimized = false
local originalSize = UDim2.new(0, 320, 0, 520)

local function turnEverythingOff()
    if AimSettings.Enabled then toggleAimbot() end
    if ESPSettings.Enabled then toggleESP() end
    if PlayerSettings.Fly then setFly(false); setFlyUI(false) end
    PlayerSettings.InfJump = false
    setInfJumpUI(false)
end

MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 320, 0, 30)
        TabBar.Visible = false
        PageHolder.Visible = false
        MinimizeBtn.Text = "+"
    else
        MainFrame.Size = originalSize
        TabBar.Visible = true
        PageHolder.Visible = true
        MinimizeBtn.Text = "—"
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    turnEverythingOff()
    ScreenGui.Enabled = false
end)

-- ============================================
-- MOUSE UNLOCK FORCE (na camera priority!)
-- ============================================
RunService:BindToRenderStep("CheatMenu_MouseUnlock", Enum.RenderPriority.Camera.Value + 1, function()
    if MiscSettings.MouseUnlocked then
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    end
end)

-- ============================================
-- RENDER LOOP
-- ============================================
RunService.RenderStepped:Connect(function()
    FOVStroke.Color = ESPSettings.BoxColor

    if PlayerSettings.Fly and FlyRefs.bv and FlyRefs.bg then
        local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * PlayerSettings.FlySpeed
        end
        FlyRefs.bv.Velocity = moveDir
        FlyRefs.bg.CFrame = Camera.CFrame
    end

    local aimTarget = nil
    if AimSettings.Enabled then
        aimTarget = getClosestTarget()
    end

    if AimSettings.ShowFOV and AimSettings.Enabled and ScreenGui.Enabled then
        FOVCircle.Visible = true
        local mousePos = UserInputService:GetMouseLocation()
        FOVCircle.Position = UDim2.fromOffset(mousePos.X, mousePos.Y)
        FOVCircle.Size = UDim2.new(0, AimSettings.FOV * 2, 0, AimSettings.FOV * 2)
    else
        FOVCircle.Visible = false
    end

    if AimSettings.Enabled and aimTarget then
        local targetPos = aimTarget.Position
        local cameraPos = Camera.CFrame.Position
        local newCFrame = CFrame.new(cameraPos, targetPos)
        if AimSettings.Smoothness > 0 then
            Camera.CFrame = Camera.CFrame:Lerp(newCFrame, 1 - AimSettings.Smoothness)
        else
            Camera.CFrame = newCFrame
        end
    end

    if AimSettings.AutoShoot and AimSettings.Enabled and aimTarget and not isMouseOverGui() then
        local now = tick()
        if (now - lastShotTime) >= AimSettings.ShootCooldown then
            lastShotTime = now
            fireMouseClick()
        end
    end

    if ScreenGui.Enabled then updateESP() end
end)

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = T("notif_loaded"),
        Text = T("notif_hint"),
        Duration = 6,
    })
end)
