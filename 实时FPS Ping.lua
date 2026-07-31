--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- [[ CONFIGURATION ]] --
local TARGET_AUDIO_ID = "16214979367"
local COOLDOWN = 0.65

-- [[ SERVICES ]] --
local VirtualInputManager = game:GetService("VirtualInputManager")
local lastTrigger = 0

-- [[ FUNCTION TO PRESS Q ]] --
local function pressQKey()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
    task.wait(0.05)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
end

-- [[ PROCESS SOUND ]] --
local function hookSound(sound)
    if not sound:IsA("Sound") then return end

    -- 
    local function checkAndTrigger()
        local soundId = tostring(sound.SoundId)
        if soundId:find(TARGET_AUDIO_ID) then
            local now = os.clock()
            if (now - lastTrigger) >= COOLDOWN then
                lastTrigger = now
                pressQKey()
            end
        end
    end

    -- 
    sound.Played:Connect(checkAndTrigger)

    --
    sound:GetPropertyChangedSignal("IsPlaying"):Connect(function()
        if sound.IsPlaying then
            checkAndTrigger()
        end
    end)
end

-- [[ HOOK ALL SOUNDS IN GAME ]] --
--
for _, desc in pairs(game:GetDescendants()) do
    pcall(function()
        hookSound(desc)
    end)
end

--
game.DescendantAdded:Connect(function(desc)
    pcall(function()
        hookSound(desc)
    end)
end)

print("Absolute Audio Detector Loaded! Standing by...")