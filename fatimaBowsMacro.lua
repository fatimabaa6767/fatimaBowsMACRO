--========================================
-- FATIMABOWSMACRO
-- CLEAR PANEL EDITION
--========================================

local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

-- SETTINGS
local Enabled = true
local Running = false
local Speed = 2
local SnowDelay = 0.09

-- COLORS
local PINK = Color3.fromRGB(255, 170, 220)
local PURPLE = Color3.fromRGB(190, 140, 255)
local WHITE = Color3.fromRGB(255, 255, 255)
local CLEAR = 0.30

--========================================
-- KEY INPUT
--========================================

local function PressKey(key)
    VIM:SendKeyEvent(true, key, false, game)
    VIM:SendKeyEvent(false, key, false, game)
end

local function WaitSpeed()
    task.wait(0.08 / Speed)
end

local function Equip(slot)
    local keys = {
        [0] = Enum.KeyCode.Zero,
        [1] = Enum.KeyCode.One,
        [2] = Enum.KeyCode.Two,
        [3] = Enum.KeyCode.Three,
        [4] = Enum.KeyCode.Four,
        [5] = Enum.KeyCode.Five,
        [6] = Enum.KeyCode.Six,
        [7] = Enum.KeyCode.Seven,
        [8] = Enum.KeyCode.Eight,
        [9] = Enum.KeyCode.Nine
    }

    if keys[slot] then
        PressKey(keys[slot])
        WaitSpeed()
    end
end

local function TapCenter()
    local camera = workspace.CurrentCamera
    if not camera then return end

    local size = camera.ViewportSize
    local x, y = size.X / 2, size.Y / 2

    VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
    VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

--========================================
-- GUI
--========================================

local gui = Instance.new("ScreenGui")
gui.Name = "FatimaBowsMacro"
gui.ResetOnSpawn = false
gui.Parent = Player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(310, 430)
Main.Position = UDim2.new(0.5, -155, 0.5, -215)
Main.BackgroundColor3 = Color3.fromRGB(35, 25, 45)
Main.BackgroundTransparency = CLEAR
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = Main

local stroke = Instance.new("UIStroke")
stroke.Color = PINK
stroke.Transparency = 0.15
stroke.Thickness = 1.5
stroke.Parent = Main

-- DRAGGING
local dragging = false
local dragStart
local startPos

Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- TITLE BAR
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -45, 0, 40)
Title.Position = UDim2.fromOffset(10, 0)
Title.BackgroundTransparency = 1
Title.Text = "FATIMA BOWS"
Title.TextColor3 = PINK
Title.Font = Enum.Font.GothamBold
Title.TextSize = 19
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(35, 35)
Close.Position = UDim2.new(1, -40, 0, 3)
Close.BackgroundTransparency = 1
Close.Text = "×"
Close.TextColor3 = WHITE
Close.TextSize = 27
Close.Parent = Main

-- REOPEN BUTTON
local Reopen = Instance.new("TextButton")
Reopen.Size = UDim2.fromOffset(55, 45)
Reopen.Position = UDim2.new(0, 15, 0.5, 0)
Reopen.BackgroundColor3 = Color3.fromRGB(35, 25, 45)
Reopen.BackgroundTransparency = 0.15
Reopen.Text = "FB"
Reopen.TextColor3 = PINK
Reopen.Font = Enum.Font.GothamBold
Reopen.TextSize = 18
Reopen.Visible = false
Reopen.Parent = gui

local reopenCorner = Instance.new("UICorner")
reopenCorner.CornerRadius = UDim.new(0, 12)
reopenCorner.Parent = Reopen

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
    Reopen.Visible = true
end)

Reopen.MouseButton1Click:Connect(function()
    Main.Visible = true
    Reopen.Visible = false
end)

-- STATUS
local Status = Instance.new("TextLabel")
Status.Position = UDim2.fromOffset(10, 42)
Status.Size = UDim2.new(1, -20, 0, 22)
Status.BackgroundTransparency = 1
Status.Text = "Status: Ready"
Status.TextColor3 = WHITE
Status.TextSize = 12
Status.Font = Enum.Font.Gotham
Status.Parent = Main

local function SetStatus(message)
    Status.Text = "Status: " .. message
end

-- SECTION
local function MakeSection(name, y, height)
    local section = Instance.new("Frame")
    section.Position = UDim2.fromOffset(10, y)
    section.Size = UDim2.new(1, -20, 0, height)
    section.BackgroundColor3 = Color3.fromRGB(70, 48, 85)
    section.BackgroundTransparency = 0.30
    section.BorderSizePixel = 0
    section.Parent = Main

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 9)
    c.Parent = section

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -12, 0, 22)
    label.Position = UDim2.fromOffset(8, 2)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = PINK
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = section

    return section
end

local function MakeButton(parent, name, x, y, width, callback)
    local button = Instance.new("TextButton")
    button.Position = UDim2.fromOffset(x, y)
    button.Size = UDim2.fromOffset(width, 29)
    button.BackgroundColor3 = Color3.fromRGB(105, 70, 125)
    button.BackgroundTransparency = 0.15
    button.Text = name
    button.TextColor3 = WHITE
    button.TextSize = 12
    button.Font = Enum.Font.GothamBold
    button.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 7)
    c.Parent = button

    button.MouseButton1Click:Connect(callback)
    return button
end

--========================================
-- ACTIONS
--========================================

local function SingleWeapon(slot)
    if not Enabled or Running then return end

    Running = true
    SetStatus("Using weapon")

    task.spawn(function()
        Equip(slot)
        task.wait(1)
        Equip(2)

        Running = false
        SetStatus("Loverboard ready")
    end)
end

local function RunCombo(slots, delay)
    if not Enabled or Running then return end

    Running = true
    SetStatus("Combo running")

    task.spawn(function()
        for _, slot in ipairs(slots) do
            Equip(slot)
            TapCenter()
            task.wait(delay)
        end

        Equip(2)

        Running = false
        SetStatus("Loverboard ready")
    end)
end

local function SnowMacro()
    if not Enabled or Running then return end

    Running = true
    SetStatus("Gold Snow")

    task.spawn(function()
        -- GOLD SNOW
        Equip(8)
        TapCenter()

        task.wait(SnowDelay)

        -- BLUE SNOW
        SetStatus("Blue Snow")
        Equip(9)
        TapCenter()

        -- QUICK LOVERBOARD RETURN
        Equip(2)

        Running = false
        SetStatus("Loverboard ready")
    end)
end

local function Loverboard()
    if not Enabled or Running then return end
    Equip(2)
    SetStatus("Loverboard equipped")
end

local function Brass()
    if not Enabled or Running then return end
    Equip(0)
    SetStatus("Brass equipped")
end

--========================================
-- SNOW SECTION
--========================================

local SnowSection = MakeSection("SNOW CONTROLS", 70, 78)

MakeButton(SnowSection, "GOLD 8", 8, 34, 85, function()
    if not Enabled or Running then return end
    Running = true
    Equip(8)
    Running = false
    SetStatus("Gold Snow equipped")
end)

MakeButton(SnowSection, "BLUE 9", 105, 34, 85, function()
    if not Enabled or Running then return end
    Running = true
    Equip(9)
    Running = false
    SetStatus("Blue Snow equipped")
end)

MakeButton(SnowSection, "SNOW MACRO", 202, 34, 85, SnowMacro)

-- WEAPON SECTION
local WeaponSection = MakeSection("WEAPONS", 155, 78)

MakeButton(WeaponSection, "RPG", 8, 34, 62, function()
    SingleWeapon(1)
end)

MakeButton(WeaponSection, "TASER", 77, 34, 62, function()
    SingleWeapon(3)
end)

MakeButton(WeaponSection, "COMBO", 146, 34, 62, function()
    RunCombo({4, 5, 6, 7}, 0.08 / Speed)
end)

MakeButton(WeaponSection, "BRASS", 215, 34, 62, Brass)

-- LOVERBOARD SECTION
local BoardSection = MakeSection("LOVERBOARD", 240, 48)

MakeButton(BoardSection, "EQUIP SLOT 2", 8, 25, 270, Loverboard)

-- RELOAD SECTION
local ReloadSection = MakeSection("RELOAD", 295, 48)

MakeButton(ReloadSection, "MANUAL RELOAD (X)", 8, 25, 270, function()
    PressKey(Enum.KeyCode.X)
    SetStatus("Reload pressed")
end)

-- SETTINGS SECTION
local Settings = MakeSection("SETTINGS", 350, 72)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Position = UDim2.fromOffset(90, 30)
SpeedLabel.Size = UDim2.fromOffset(100, 28)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed: 2"
SpeedLabel.TextColor3 = WHITE
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 14
SpeedLabel.Parent = Settings

MakeButton(Settings, "−", 25, 30, 45, function()
    Speed = math.max(1, Speed - 1)
    SpeedLabel.Text = "Speed: " .. Speed
end)

MakeButton(Settings, "+", 210, 30, 45, function()
    Speed = math.min(10, Speed + 1)
    SpeedLabel.Text = "Speed: " .. Speed
end)

-- ENABLE / DISABLE
local Toggle = MakeButton(Main, "DISABLE MACRO", 10, 426, 290, function()
    Enabled = not Enabled
    Toggle.Text = Enabled and "DISABLE MACRO" or "ENABLE MACRO"
    SetStatus(Enabled and "Ready" or "Disabled")
end)

--========================================
-- CONTROLLER INPUTS
--========================================

UIS.InputBegan:Connect(function(input, processed)
    if processed or not Enabled then return end

    if input.KeyCode == Enum.KeyCode.ButtonL1 then
        SingleWeapon(1)

    elseif input.KeyCode == Enum.KeyCode.DPadLeft then
        Loverboard()

    elseif input.KeyCode == Enum.KeyCode.ButtonR1 then
        SingleWeapon(3)

    elseif input.KeyCode == Enum.KeyCode.ButtonL3 then
        RunCombo({4, 5, 6, 7}, 0.08 / Speed)

    elseif input.KeyCode == Enum.KeyCode.ButtonY then
        SnowMacro()

    elseif input.KeyCode == Enum.KeyCode.DPadRight then
        Brass()
    end
end)

print("FatimaBowsMacro Clear Panel Loaded!")
