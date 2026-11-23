 --====================================
-- FATIMABOWSMACRO
-- BADDIES PANEL EDITION
--====================================

local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

-- SETTINGS
local Enabled = true
local Running = false
local Speed = 2

-- SPEED
local function WaitSpeed()
    task.wait(0.08 / Speed)
end

-- PRESS KEY
local function PressKey(key)
    VIM:SendKeyEvent(true, key, false, game)
    VIM:SendKeyEvent(false, key, false, game)
end

-- EQUIP SLOT
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

-- TAP CENTER
local function TapCenter()
    local camera = workspace.CurrentCamera
    if not camera then return end

    local size = camera.ViewportSize
    local x, y = size.X / 2, size.Y / 2

    VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
    VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FatimaBowsPanel"
gui.ResetOnSpawn = false
gui.Parent = Player:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 260, 0, 390)
Main.Position = UDim2.new(0.5, -130, 0.5, -195)
Main.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = Main

-- DRAG PANEL
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

-- TITLE
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 38)
Title.BackgroundTransparency = 1
Title.Text = "FATIMABOWSMACRO"
Title.TextColor3 = Color3.fromRGB(255, 180, 220)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

-- STATUS
local Status = Instance.new("TextLabel")
Status.Position = UDim2.new(0, 10, 0, 40)
Status.Size = UDim2.new(1, -20, 0, 22)
Status.BackgroundTransparency = 1
Status.Text = "Status: Ready"
Status.TextColor3 = Color3.fromRGB(220, 220, 220)
Status.TextSize = 13
Status.Parent = Main

local function SetStatus(msg)
    Status.Text = "Status: " .. msg
end

-- BUTTON CREATOR
local function MakeButton(name, y, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0, y)
    button.BackgroundColor3 = Color3.fromRGB(65, 48, 75)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = name
    button.TextSize = 13
    button.Font = Enum.Font.GothamBold
    button.Parent = Main

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 7)
    c.Parent = button

    button.MouseButton1Click:Connect(callback)
    return button
end

-- ACTIONS
local function SingleWeapon(slot)
    if not Enabled or Running then return end

    Running = true
    SetStatus("Using weapon")

    task.spawn(function()
        Equip(slot)
        task.wait(1)
        Equip(2)

        Running = false
        SetStatus("Ready")
    end)
end

local function RunCombo(slots, doubleTap)
    if not Enabled or Running then return end

    Running = true
    SetStatus("Combo running")

    task.spawn(function()
        for _, slot in ipairs(slots) do
            Equip(slot)
            TapCenter()

            if doubleTap then
                WaitSpeed()
                TapCenter()
            end

            WaitSpeed()
        end

        Equip(2)

        Running = false
        SetStatus("Ready")
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

-- PANEL BUTTONS
MakeButton("RPG", 70, function()
    SingleWeapon(1)
end)

MakeButton("Loverboard", 104, Loverboard)

MakeButton("Taser", 138, function()
    SingleWeapon(3)
end)

MakeButton("Weapon Combo", 172, function()
    RunCombo({4, 5, 6, 7}, true)
end)

MakeButton("Snows", 206, function()
    RunCombo({8, 9}, true)
end)

MakeButton("Brass", 240, Brass)

MakeButton("Reload (X)", 274, function()
    PressKey(Enum.KeyCode.X)
    SetStatus("Reload pressed")
end)

-- SPEED CONTROLS
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Position = UDim2.new(0, 10, 0, 310)
SpeedLabel.Size = UDim2.new(1, -20, 0, 24)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.fromRGB(255, 180, 220)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 14
SpeedLabel.Text = "Speed: 2"
SpeedLabel.Parent = Main

MakeButton("Speed +", 336, function()
    Speed = math.min(10, Speed + 1)
    SpeedLabel.Text = "Speed: " .. Speed
end)

MakeButton("Speed -", 370, function()
    Speed = math.max(1, Speed - 1)
    SpeedLabel.Text = "Speed: " .. Speed
end)

-- ENABLE / DISABLE
local Toggle = Instance.new("TextButton")
Toggle.Position = UDim2.new(0, 10, 0, 404)
Toggle.Size = UDim2.new(1, -20, 0, 30)
Toggle.BackgroundColor3 = Color3.fromRGB(120, 55, 85)
Toggle.TextColor3 = Color3.new(1, 1, 1)
Toggle.Text = "Disable Macro"
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 13
Toggle.Parent = Main

Toggle.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    Toggle.Text = Enabled and "Disable Macro" or "Enable Macro"
    SetStatus(Enabled and "Ready" or "Disabled")
end)

-- CONTROLLER INPUTS
UIS.InputBegan:Connect(function(input, processed)
    if processed or not Enabled then return end

    if input.KeyCode == Enum.KeyCode.ButtonL1 then
        SingleWeapon(1)

    elseif input.KeyCode == Enum.KeyCode.DPadLeft then
        Loverboard()

    elseif input.KeyCode == Enum.KeyCode.ButtonR1 then
        SingleWeapon(3)

    elseif input.KeyCode == Enum.KeyCode.ButtonL3 then
        RunCombo({4, 5, 6, 7}, true)

    elseif input.KeyCode == Enum.KeyCode.ButtonY then
        RunCombo({8, 9}, true)

    elseif input.KeyCode == Enum.KeyCode.DPadRight then
        Brass()
    end
end)

print("FatimaBowsMacro Panel Loaded!")
