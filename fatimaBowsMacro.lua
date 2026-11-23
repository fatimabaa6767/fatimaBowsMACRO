
-- FATIMABOWSMACRO
-- Snow + Loverboard + Brass Edition

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local Player = Players.LocalPlayer
local Enabled = true
local Busy = false
local Speed = 2

local LB = Enum.KeyCode.ButtonL1
local RB = Enum.KeyCode.ButtonR1
local L3 = Enum.KeyCode.ButtonL3
local Y = Enum.KeyCode.ButtonY
local DPadLeft = Enum.KeyCode.DPadLeft
local DPadRight = Enum.KeyCode.DPadRight
local RT = Enum.KeyCode.ButtonR2

local SlotKeys = {
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

local function PressKey(key, duration)
    duration = duration or 0.08
    pcall(function()
        VIM:SendKeyEvent(true, key, false, game)
        task.wait(duration)
        VIM:SendKeyEvent(false, key, false, game)
    end)
end

local function Equip(slot)
    local key = SlotKeys[slot]
    if key then
        PressKey(key)
    end
end

local function WaitSpeed()
    task.wait(0.08 / math.max(Speed, 1))
end

-- Equip Loverboard and press RT to mount
local function ReturnToBoard()
    Equip(2)
    task.wait(0.18)
    PressKey(RT, 0.12)
end

local function RunMacro(callback)
    if not Enabled or Busy then return end

    Busy = true
    task.spawn(function()
        local success, err = pcall(callback)
        if not success then
            warn("[FatimaBowsMacro] " .. tostring(err))
        end
        Busy = false
    end)
end

-- RPG
local function RPGMacro()
    Equip(1)
    task.wait(0.25)
    ReturnToBoard()
end

-- Taser
local function TaserMacro()
    Equip(3)
    task.wait(0.25)
    ReturnToBoard()
end

-- Gold Snow then Blue Snow, no 0.09 delay
local function SnowMacro()
    Equip(8)
    PressKey(Y, 0.08)

    Equip(9)
    PressKey(Y, 0.08)

    ReturnToBoard()
end

-- Weapon combo
local function WeaponMacro()
    for slot = 4, 7 do
        Equip(slot)
        WaitSpeed()
    end
    ReturnToBoard()
end

-- Loverboard
local function LoverboardMacro()
    ReturnToBoard()
end

-- Brass
local function BrassMacro()
    Equip(0)
end

-- Reload
local function ReloadMacro()
    PressKey(Enum.KeyCode.X, 0.08)
end

-- GUI
local PlayerGui = Player:WaitForChild("PlayerGui")

local OldGui = PlayerGui:FindFirstChild("FatimaBowsMacro")
if OldGui then
    OldGui:Destroy()
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "FatimaBowsMacro"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(300, 390)
Main.Position = UDim2.new(0.5, -150, 0.5, -195)
Main.BackgroundColor3 = Color3.fromRGB(220, 190, 255)
Main.BackgroundTransparency = 0.35
Main.BorderSizePixel = 0
Main.Parent = Gui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 16)
Corner.Parent = Main

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(255, 220, 255)
Stroke.Transparency = 0.15
Stroke.Thickness = 1.5
Stroke.Parent = Main

local function MakeButton(parent, text, position, size)
    local button = Instance.new("TextButton")
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(245, 220, 255)
    button.BackgroundTransparency = 0.2
    button.TextColor3 = Color3.fromRGB(65, 35, 85)
    button.Text = text
    button.TextSize = 14
    button.Font = Enum.Font.GothamSemibold
    button.BorderSizePixel = 0
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = button

    return button
end

local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, -55, 0, 38)
Header.Position = UDim2.fromOffset(12, 5)
Header.BackgroundTransparency = 1
Header.Text = "♡ FatimaBowsMacro ♡"
Header.TextColor3 = Color3.fromRGB(75, 35, 100)
Header.TextSize = 17
Header.Font = Enum.Font.GothamBold
Header.Parent = Main

local Close = MakeButton(
    Main, "X",
    UDim2.new(1, -42, 0, 7),
    UDim2.fromOffset(32, 28)
)

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 24)
Status.Position = UDim2.fromOffset(10, 42)
Status.BackgroundTransparency = 1
Status.Text = "Status: Enabled"
Status.TextColor3 = Color3.fromRGB(75, 35, 100)
Status.TextSize = 13
Status.Font = Enum.Font.Gotham
Status.Parent = Main

local RPGButton = MakeButton(
    Main, "RPG  •  LB",
    UDim2.fromOffset(12, 75),
    UDim2.fromOffset(132, 42)
)

local TaserButton = MakeButton(
    Main, "Taser  •  RB",
    UDim2.fromOffset(156, 75),
    UDim2.fromOffset(132, 42)
)

local SnowButton = MakeButton(
    Main, "Gold Snow → Blue Snow",
    UDim2.fromOffset(12, 125),
    UDim2.fromOffset(276, 42)
)

local WeaponButton = MakeButton(
    Main, "Weapon Combo  •  L3",
    UDim2.fromOffset(12, 175),
    UDim2.fromOffset(276, 42)
)

local BoardButton = MakeButton(
    Main, "Loverboard  •  D-pad Left",
    UDim2.fromOffset(12, 225),
    UDim2.fromOffset(276, 42)
)

local ReloadButton = MakeButton(
    Main, "Reload  •  X",
    UDim2.fromOffset(12, 275),
    UDim2.fromOffset(276, 38)
)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.fromOffset(110, 30)
SpeedLabel.Position = UDim2.fromOffset(95, 330)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed: " .. Speed
SpeedLabel.TextColor3 = Color3.fromRGB(75, 35, 100)
SpeedLabel.TextSize = 14
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.Parent = Main

local Minus = MakeButton(
    Main, "−",
    UDim2.fromOffset(45, 328),
    UDim2.fromOffset(40, 32)
)

local Plus = MakeButton(
    Main, "+",
    UDim2.fromOffset(215, 328),
    UDim2.fromOffset(40, 32)
)

local Toggle = MakeButton(
    Main, "Disable Macro",
    UDim2.fromOffset(12, 365),
    UDim2.fromOffset(276, 25)
)

local Reopen = MakeButton(
    Gui, "♡",
    UDim2.new(0, 20, 0.5, -22),
    UDim2.fromOffset(48, 44)
)
Reopen.Visible = false
Reopen.TextSize = 22

RPGButton.MouseButton1Click:Connect(function()
    RunMacro(RPGMacro)
end)

TaserButton.MouseButton1Click:Connect(function()
    RunMacro(TaserMacro)
end)

SnowButton.MouseButton1Click:Connect(function()
    RunMacro(SnowMacro)
end)

WeaponButton.MouseButton1Click:Connect(function()
    RunMacro(WeaponMacro)
end)

BoardButton.MouseButton1Click:Connect(function()
    RunMacro(LoverboardMacro)
end)

ReloadButton.MouseButton1Click:Connect(function()
    RunMacro(ReloadMacro)
end)

Minus.MouseButton1Click:Connect(function()
    Speed = math.max(1, Speed - 1)
    SpeedLabel.Text = "Speed: " .. Speed
end)

Plus.MouseButton1Click:Connect(function()
    Speed = math.min(10, Speed + 1)
    SpeedLabel.Text = "Speed: " .. Speed
end)

Toggle.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    Status.Text = Enabled and "Status: Enabled" or "Status: Disabled"
    Toggle.Text = Enabled and "Disable Macro" or "Enable Macro"
end)

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
    Reopen.Visible = true
end)

Reopen.MouseButton1Click:Connect(function()
    Main.Visible = true
    Reopen.Visible = false
end)

-- Drag panel using header only
local Dragging = false
local DragInput
local DragStart
local StartPosition

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPosition = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        DragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if Dragging and input == DragInput then
        local delta = input.Position - DragStart
        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + delta.Y
        )
    end
end)

-- Controller shortcuts
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not Enabled then return end

    local key = input.KeyCode

    if key == LB then
        RunMacro(RPGMacro)
    elseif key == RB then
        RunMacro(TaserMacro)
    elseif key == Y then
        RunMacro(SnowMacro)
    elseif key == L3 then
        RunMacro(WeaponMacro)
    elseif key == DPadLeft then
        RunMacro(LoverboardMacro)
    elseif key == DPadRight then
        RunMacro(BrassMacro)
    elseif key == Enum.KeyCode.X
    or key == Enum.KeyCode.ButtonX then
        RunMacro(ReloadMacro)
    end
end)

print("FatimaBowsMacro loaded!")
