-- FATIMABOWSMACRO
-- Original Controller Setup + Gold/Blue Snow

local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

local snowButton = Enum.KeyCode.ButtonY
local comboButton = Enum.KeyCode.ButtonL3
local rpgButton = Enum.KeyCode.ButtonL1
local taserButton = Enum.KeyCode.ButtonR1
local boardButton = Enum.KeyCode.DPadLeft
local brassButton = Enum.KeyCode.DPadRight

local snowCooldown = 0.2
local comboCooldown = 0.2
local rpgCooldown = 0.25
local taserCooldown = 0.25
local boardCooldown = 0.2
local brassCooldown = 0.2

local canSnow = true
local canCombo = true
local canRPG = true
local canTaser = true
local canBoard = true
local canBrass = true

local function tapCenter()
    local camera = workspace.CurrentCamera
    if not camera then return end

    local size = camera.ViewportSize
    local tapX = size.X / 2
    local tapY = size.Y / 2

    VIM:SendMouseButtonEvent(tapX, tapY, 0, true, game, 0)
    VIM:SendMouseButtonEvent(tapX, tapY, 0, false, game, 0)
end

local function pressKey(key)
    VIM:SendKeyEvent(true, key, false, game)
    VIM:SendKeyEvent(false, key, false, game)
end

local function equip(slot)
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
    if key then
        pressKey(key)
    end
end

local function returnToBoard()
    equip(2)
    tapCenter()
end

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Y = GOLD SNOW THEN BLUE SNOW
    if input.KeyCode == snowButton and canSnow then
        canSnow = false

        task.spawn(function()
            -- Gold Snow
            equip(8)
            tapCenter()

            task.wait(0.05)

            -- Blue Snow
            equip(9)
            tapCenter()

            task.wait(0.05)

            -- Return to Loverboard
            returnToBoard()

            task.wait(snowCooldown)
            canSnow = true
        end)
    end

    -- L3 = WEAPON COMBO
    if input.KeyCode == comboButton and canCombo then
        canCombo = false

        task.spawn(function()
            for slot = 4, 7 do
                equip(slot)
                tapCenter()
                task.wait(0.05)
            end

            returnToBoard()

            task.wait(comboCooldown)
            canCombo = true
        end)
    end

    -- LB = RPG
    if input.KeyCode == rpgButton and canRPG then
        canRPG = false

        task.spawn(function()
            equip(1)
            tapCenter()

            task.wait(0.05)

            returnToBoard()

            task.wait(rpgCooldown)
            canRPG = true
        end)
    end

    -- RB = TASER
    if input.KeyCode == taserButton and canTaser then
        canTaser = false

        task.spawn(function()
            equip(3)
            tapCenter()

            task.wait(0.05)

            returnToBoard()

            task.wait(taserCooldown)
            canTaser = true
        end)
    end

    -- D-PAD LEFT = LOVERBOARD
    if input.KeyCode == boardButton and canBoard then
        canBoard = false

        task.spawn(function()
            returnToBoard()

            task.wait(boardCooldown)
            canBoard = true
        end)
    end

    -- D-PAD RIGHT = BRASS
    if input.KeyCode == brassButton and canBrass then
        canBrass = false

        task.spawn(function()
            equip(0)

            task.wait(brassCooldown)
            canBrass = true
        end)
    end
end)

print("FatimaBowsMacro loaded!")
