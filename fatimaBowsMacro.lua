--====================================
-- FATIMABOWSMACRO
-- BADDIES CONTROLLER MACRO
--====================================

local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

-- SETTINGS
local Enabled = true
local Running = false
local Speed = 1
local ShiftLocked = false

-- ADJUST SPEED HERE
local function WaitSpeed()
    task.wait(0.08 / Speed)
end

-- EQUIP WEAPON SLOT
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

    local key = keys[slot]
    if not key then return end

    VIM:SendKeyEvent(true, key, false, game)
    VIM:SendKeyEvent(false, key, false, game)

    WaitSpeed()
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

-- COMBO
local function RunCombo(slots, doubleTap)
    if not Enabled or Running then return end

    Running = true

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

        Running = false
    end)
end

-- SHIFT LOCK
local function ToggleShiftLock()
    ShiftLocked = not ShiftLocked

    UIS.MouseBehavior = ShiftLocked
        and Enum.MouseBehavior.LockCenter
        or Enum.MouseBehavior.Default
end

-- CONTROLLER INPUTS
UIS.InputBegan:Connect(function(input, processed)

    if input.KeyCode == Enum.KeyCode.ButtonL2 then
        ToggleShiftLock()
        return
    end

    if not Enabled or processed then return end

    -- RPG
    if input.KeyCode == Enum.KeyCode.ButtonL1 then
        Equip(1)

    -- LOVERBOARD
    elseif input.KeyCode == Enum.KeyCode.DPadLeft then
        Equip(2)

    -- TASER
    elseif input.KeyCode == Enum.KeyCode.ButtonR1 then
        Equip(3)

    -- WEAPON COMBO
    elseif input.KeyCode == Enum.KeyCode.ButtonL3 then
        RunCombo({4, 5, 6, 7}, true)

    -- SNOWS
    elseif input.KeyCode == Enum.KeyCode.ButtonY then
        RunCombo({8, 9}, true)

    -- BRASS
    elseif input.KeyCode == Enum.KeyCode.DPadRight then
        Equip(0)
    end
end)

print("FatimaBowsMacro Loaded!")