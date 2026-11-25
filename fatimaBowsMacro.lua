local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local snowButton = Enum.KeyCode.ButtonY
local comboButton = Enum.KeyCode.ButtonL3
local rpgButton = Enum.KeyCode.ButtonL1
local grenadeButton = Enum.KeyCode.DPadLeft
local taserButton = Enum.KeyCode.DPadRight
local rpgMacroButton = Enum.KeyCode.DPadDown

local snowCooldown = 0.15
local comboCooldown = 0.2
local rpgCooldown = 0.25
local grenadeCooldown = 0.25
local rpgMacroCooldown = 0.3

local canSnow = true
local canCombo = true
local canRPG = true
local canGrenade = true
local canTaser = true
local canRPGMacro = true

local function tapCenter()
    local camera = workspace.CurrentCamera
    if not camera then return end

    local size = camera.ViewportSize
    local x = size.X / 2
    local y = size.Y / 2

    VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
    VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

local function pressKey(key)
    VIM:SendKeyEvent(true, key, false, game)
    VIM:SendKeyEvent(false, key, false, game)
end

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- SNOW: GOLD -> BLUE -> BOARD
    if input.KeyCode == snowButton and canSnow then
        canSnow = false

        task.spawn(function()
            pressKey(Enum.KeyCode.Three)
            tapCenter()

            task.wait(0.06)

            pressKey(Enum.KeyCode.Four)
            tapCenter()

            task.wait(0.04)

            pressKey(Enum.KeyCode.Two)
            tapCenter()

            task.wait(snowCooldown)
            canSnow = true
        end)
    end

    -- COMBO: L3
    if input.KeyCode == comboButton and canCombo then
        canCombo = false
        task.spawn(function()
            pressKey(Enum.KeyCode.Five)
            tapCenter()
            task.wait(0.05)
            pressKey(Enum.KeyCode.Six)
            tapCenter()
            task.wait(0.05)
            pressKey(Enum.KeyCode.Seven)
            tapCenter()
            task.wait(0.05)
            pressKey(Enum.KeyCode.Eight)
            tapCenter()
            task.wait(0.05)
            pressKey(Enum.KeyCode.Two)
            tapCenter()
            task.wait(comboCooldown)
            canCombo = true
        end)
    end

    -- RPG: LB
    if input.KeyCode == rpgButton and canRPG then
        canRPG = false
        task.spawn(function()
            pressKey(Enum.KeyCode.One)
            tapCenter()
            task.wait(0.05)
            pressKey(Enum.KeyCode.Two)
            tapCenter()
            task.wait(rpgCooldown)
            canRPG = true
        end)
    end

    -- GRENADE: DPAD LEFT
    if input.KeyCode == grenadeButton and canGrenade then
        canGrenade = false
        task.spawn(function()
            pressKey(Enum.KeyCode.Nine)
            tapCenter()
            task.wait(0.05)
            tapCenter()
            pressKey(Enum.KeyCode.Two)
            tapCenter()
            task.wait(grenadeCooldown)
            canGrenade = true
        end)
    end

    -- TASER: DPAD RIGHT
    if input.KeyCode == taserButton and canTaser then
        canTaser = false
        task.spawn(function()
            pressKey(Enum.KeyCode.Zero)
            tapCenter()
            task.wait(0.05)
            tapCenter()
            pressKey(Enum.KeyCode.Two)
            tapCenter()
            task.wait(grenadeCooldown)
            canTaser = true
        end)
    end

    -- RPG MACRO: DPAD DOWN
    if input.KeyCode == rpgMacroButton and canRPGMacro then
        canRPGMacro = false
        task.spawn(function()
            pressKey(Enum.KeyCode.Zero)
            tapCenter()
            task.wait(0.1)
            pressKey(Enum.KeyCode.R)
            task.wait(0.1)
            pressKey(Enum.KeyCode.Two)
            tapCenter()
            task.wait(rpgMacroCooldown)
            canRPGMacro = true
        end)
    end
end)

print("Fatima Baddies Macro Loaded!")