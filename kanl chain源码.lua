--hallo
if game.PlaceId == 13977939077 then
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/dream77239/china-ui/refs/heads/main/main%20(6).lua"))()
local Window = WindUI:CreateWindow({
    Title = "huggy牛逼",
    Icon = "eye",
    IconThemed = true,
    Author = "句号",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(500, 400),
    Transparent = true,
    Theme = "Dark",
    Background = nil,
    User = {
        Enabled = true,
        Callback = function() end,
        Anonymous = false
    },
    SideBarWidth = 200,
    ScrollBarEnabled = true
})
loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua", true))()
local Tab = Window:Tab({
    Title = "实用功能",
    Icon = "hammer",
    Locked = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local combatStaminaEnabled = false
local staminaEnabled = false

local combatLoop = nil
local staminaLoop = nil

local function setCombatStamina(value)
    pcall(function()
        local char = workspace:FindFirstChild(LocalPlayer.Name)
        if char and char:FindFirstChild("Stats") then
            local stat = char.Stats:FindFirstChild("CombatStamina")
            if stat then
                stat.Value = value
            end
        end
    end)
end

local function setStamina(value)
    pcall(function()
        local char = workspace:FindFirstChild(LocalPlayer.Name)
        if char and char:FindFirstChild("Stats") then
            local stat = char.Stats:FindFirstChild("Stamina")
            if stat then
                stat.Value = value
            end
        end
    end)
end

local RunService = game:GetService("RunService")

local function startCombatLoop()
    if combatLoop then return end
    combatLoop = RunService.Heartbeat:Connect(function()
        pcall(function()
            if combatStaminaEnabled then
                setCombatStamina(100)
            end
        end)
    end)
end

local function startStaminaLoop()
    if staminaLoop then return end
    staminaLoop = RunService.Heartbeat:Connect(function()
        pcall(function()
            if staminaEnabled then
                setStamina(100)
            end
        end)
    end)
end

local function stopCombatLoop()
    pcall(function()
        if combatLoop then
            combatLoop:Disconnect()
            combatLoop = nil
        end
    end)
end

local function stopStaminaLoop()
    pcall(function()
        if staminaLoop then
            staminaLoop:Disconnect()
            staminaLoop = nil
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    pcall(function()
        task.wait(1)
        if combatStaminaEnabled then
            setCombatStamina(100)
        end
        if staminaEnabled then
            setStamina(100)
        end
    end)
end)

Tab:Toggle({
    Title = "无限战斗体力",
    Value = false,
    Callback = function(state)
        pcall(function()
            combatStaminaEnabled = state
            if state then
                startCombatLoop()
            else
                stopCombatLoop()
            end
        end)
    end
})

Tab:Toggle({
    Title = "无限体力",
    Value = false,
    Callback = function(state)
        pcall(function()
            staminaEnabled = state
            if state then
                startStaminaLoop()
            else
                stopStaminaLoop()
            end
        end)
    end
})
local Lighting = game:GetService("Lighting")

local originalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ExposureCompensation = Lighting.ExposureCompensation,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    GlobalShadows = Lighting.GlobalShadows,
}

local highlightLoop

Tab:Toggle({
    Title = "高亮",
    Default = false,
    Callback = function(state)
        pcall(function()
            if state then
                highlightLoop = task.spawn(function()
                    while task.wait(0.5) do
                        pcall(function()
                            Lighting.Brightness = 2
                            Lighting.ClockTime = 13.5
                            Lighting.Ambient = Color3.new(0.6, 0.6, 0.6)
                            Lighting.OutdoorAmbient = Color3.new(0.6, 0.6, 0.6)
                            Lighting.ExposureCompensation = 0.5
                            Lighting.FogEnd = 100000
                            Lighting.FogStart = 0
                            Lighting.GlobalShadows = false
                        end)
                    end
                end)
            else
                if highlightLoop then
                    task.cancel(highlightLoop)
                    highlightLoop = nil
                end
                for k, v in pairs(originalLighting) do
                    pcall(function() Lighting[k] = v end)
                end
            end
        end)
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local NoclipEnabled = false
local NoclipConnection

local function setCharacterCollision(character, state)
    pcall(function()
        for _, v in ipairs(character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = state
            end
        end
    end)
end

local function enableNoclip()
    pcall(function()
        local character = LocalPlayer.Character
        if not character then return end

        setCharacterCollision(character, false)

        if NoclipConnection then
            NoclipConnection:Disconnect()
        end

        NoclipConnection = RunService.Stepped:Connect(function()
            pcall(function()
                if not NoclipEnabled then return end
                local char = LocalPlayer.Character
                if char then
                    for _, v in ipairs(char:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end
            end)
        end)
    end)
end

local function disableNoclip()
    pcall(function()
        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end

        local character = LocalPlayer.Character
        if character then
            setCharacterCollision(character, true)
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    pcall(function()
        if NoclipEnabled then
            task.wait(0.2)
            enableNoclip()
        end
    end)
end)

Tab:Toggle({
    Title = "穿墙",
    Value = false,
    Callback = function(state)
        pcall(function()
            NoclipEnabled = state
            if state then
                enableNoclip()
            else
                disableNoclip()
            end
        end)
    end
})
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local AutoRepairEnabled = false
local AutoRepairRunning = false

local function autoRepairLoop()
    if AutoRepairRunning then return end
    AutoRepairRunning = true
    task.spawn(function()
        while AutoRepairEnabled do
            pcall(function()
                local powerStation = Workspace:FindFirstChild("GameStuff", true) 
                    and Workspace.GameStuff:FindFirstChild("GameSections", true) 
                    and Workspace.GameStuff.GameSections:FindFirstChild("POWERSTATION")
                
                if powerStation then
                    local hitbox = powerStation:FindFirstChild("Hitbox")
                    local prompt = hitbox and hitbox:FindFirstChild("ProximityPrompt")
                    local alert = powerStation:FindFirstChild("AlertUI")
                    local gui = alert and alert:FindFirstChild("GUI")

                    if prompt and prompt.Enabled and gui and not gui.Enabled then
                        local isNearby = false
                        for _, p in ipairs(Players:GetPlayers()) do
                            local c = p.Character
                            local pp = c and c.PrimaryPart
                            if pp and (pp.Position - hitbox.Position).Magnitude <= 15 then
                                isNearby = true
                                break
                            end
                        end
                        
                        if isNearby then
                            pcall(function()
                                fireproximityprompt(prompt, 0)
                            end)
                        end
                    end
                end
            end)
            task.wait(0.3)
        end
        AutoRepairRunning = false
    end)
end

Tab:Toggle({
    Title = "自动修复电力系统",
    Desc = "这个功能你使用需要延迟低一点(大概140ping以下)不然的话你可能会被电",
    Value = false,
    Callback = function(v)
        pcall(function()
            AutoRepairEnabled = v
            if v then
                autoRepairLoop()
            end
        end)
    end
})

task.spawn(function()
    while task.wait(1) do
        local shouldBreak = false
        pcall(function()
            local powerStation = Workspace:FindFirstChild("GameStuff", true) 
                and Workspace.GameStuff:FindFirstChild("GameSections", true) 
                and Workspace.GameStuff.GameSections:FindFirstChild("POWERSTATION")
            
            if powerStation then
                local hitbox = powerStation:FindFirstChild("Hitbox")
                local prompt = hitbox and hitbox:FindFirstChild("ProximityPrompt")
                local alert = powerStation:FindFirstChild("AlertUI")
                local gui = alert and alert:FindFirstChild("GUI")

                if prompt and gui then
                    prompt:GetPropertyChangedSignal("Enabled"):Connect(function()
                        if AutoRepairEnabled then autoRepairLoop() end
                    end)
                    gui:GetPropertyChangedSignal("Enabled"):Connect(function()
                        if AutoRepairEnabled then autoRepairLoop() end
                    end)
                    shouldBreak = true
                end
            end
        end)
        if shouldBreak then break end
    end
end)
local enabled = false

local function setChatVisible(state)
    pcall(function()
        enabled = state
        local config = game:GetService("TextChatService"):FindFirstChild("ChatWindowConfiguration")
        if config and config:IsA("ChatWindowConfiguration") then
            config.Enabled = state
        end
    end)
end

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if enabled then
                setChatVisible(true)
            else
                setChatVisible(false)
            end
        end)
    end
end)

Tab:Toggle({
    Title = "显示聊天框",
    Value = false,
    Callback = function(state)
        pcall(function()
            enabled = state
        end)
    end,
})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local toggleState = false

local function applyCameraMode(state)
    pcall(function()
        if state then
            LocalPlayer.CameraMaxZoomDistance = 99999
            LocalPlayer.CameraMode = Enum.CameraMode.Classic
        else
            LocalPlayer.CameraMaxZoomDistance = 16
            LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    pcall(function()
        wait(1)
        if not toggleState then
            applyCameraMode(false)
        else
            applyCameraMode(true)
        end
    end)
end)

Tab:Toggle({
    Title = "强制第三人称",
    Value = false,
    Callback = function(state)
        pcall(function()
            toggleState = state
            applyCameraMode(state)
        end)
    end
})
Tab:Button({
    Title = "删除雾",
    Desc = nil,
    Locked = false,
    Callback = function()
        pcall(function()
            local lighting = game:GetService("Lighting")
            if lighting:FindFirstChild("Rainy") then
                lighting.Rainy:Destroy()
            end
        end)
    end
})
Tab:Toggle({
    Title = "绕过捕兽夹放置限制",
    Value = false,
    Callback = function(state)
        pcall(function()
            _G.BypassBearTrap = state
            if state then
                task.spawn(function()
                    while _G.BypassBearTrap do
                        pcall(function()
                            task.wait()
                            local stats = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerStats")
                            if stats then
                                stats:SetAttribute("BearTrapPlaced", false)
                            end
                        end)
                    end
                end)
            else
                local stats = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerStats")
                if stats then
                    stats:SetAttribute("BearTrapPlaced", true)
                end
            end
        end)
    end,
})

local v = game:GetService("ReplicatedStorage"):WaitForChild("Assets"):WaitForChild("Client"):WaitForChild("Movement"):WaitForChild("DisableSmoothness")

Tab:Toggle({
    Title = "取消走路/跑步惯性",
    Value = false,
    Callback = function(state)
        pcall(function()
            v.Value = state
        end)
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local tpwalking = false
local tpwalkSpeed = 5

Tab:Toggle({
    Title = "速度",
    Value = false,
    Callback = function(state)
        pcall(function()
            tpwalking = state
            if state then
                spawn(function()
                    while tpwalking do
                        pcall(function()
                            local chr = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                            local hrp = chr:FindFirstChild("HumanoidRootPart")
                            local hum = chr:FindFirstChildWhichIsA("Humanoid")
                            local delta = RunService.Heartbeat:Wait()
                            if hrp and hum and hum.MoveDirection.Magnitude > 0 then
                                hrp.CFrame = hrp.CFrame + (hum.MoveDirection * tpwalkSpeed * delta)
                            end
                        end)
                    end
                end)
            end
        end)
    end
})

Tab:Slider({
    Title = "速度调节",
    Value = {
        Min = 0,
        Max = 50,
        Default = tpwalkSpeed,
    },
    Callback = function(value)
        pcall(function()
            tpwalkSpeed = value
        end)
    end
})
local Tab = Window:Tab({  
    Title = "透视",  
    Icon = "eye",  
    Locked = false,
})
local RunService = game:GetService("RunService")

local chainESPEnabled = false
local chainESPConnection = nil
local currentChain = nil

local function createChainESP(chain)
    pcall(function()
        if not chain:FindFirstChild("Highlight") then
            local h = Instance.new("Highlight")
            h.Name = "Highlight"
            h.Adornee = chain
            h.FillColor = Color3.fromRGB(255, 0, 0)
            h.FillTransparency = 0.8
            h.OutlineColor = Color3.fromRGB(255, 60, 60)
            h.OutlineTransparency = 0
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            h.Parent = chain
        end

        if not chain:FindFirstChild("NameGui") then
            local gui = Instance.new("BillboardGui")
            gui.Name = "NameGui"
            gui.Size = UDim2.new(0, 150, 0, 30)
            gui.StudsOffset = Vector3.new(0, 5, 0)
            gui.Adornee = chain
            gui.AlwaysOnTop = true
            gui.LightInfluence = 0
            gui.Parent = chain

            local titleLabel = Instance.new("TextLabel")
            titleLabel.Name = "TitleLabel"
            titleLabel.Size = UDim2.new(1, 0, 0.5, 0)
            titleLabel.Position = UDim2.new(0, 0, 0, 0)
            titleLabel.Text = "CHAIN"
            titleLabel.TextColor3 = Color3.new(1, 0, 0)
            titleLabel.TextScaled = true
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.TextSize = 10
            titleLabel.BackgroundTransparency = 1
            titleLabel.Parent = gui

            local attrLabel = Instance.new("TextLabel")
            attrLabel.Name = "AttrLabel"
            attrLabel.Size = UDim2.new(1, 0, 0.5, 0)
            attrLabel.Position = UDim2.new(0, 0, 0.5, 0)
            attrLabel.RichText = true
            attrLabel.Text = ""
            attrLabel.TextColor3 = Color3.new(1, 1, 1)
            attrLabel.TextScaled = true
            attrLabel.Font = Enum.Font.Gotham
            attrLabel.TextSize = 8
            attrLabel.BackgroundTransparency = 1
            attrLabel.Parent = gui
        end
    end)
end

local function updateChainAttributes(chain)
    pcall(function()
        local gui = chain:FindFirstChild("NameGui")
        if gui then
            local attrLabel = gui:FindFirstChild("AttrLabel")
            if attrLabel then
                local anger = chain:GetAttribute("Anger") or 0
                local burst = chain:GetAttribute("Burst") or 0
                local choke = chain:GetAttribute("ChokeMeter") or 0
                attrLabel.Text = string.format(
                    '[血月度: <font color="rgb(255,255,255)">%.0f%%</font>] [捶地: <font color="rgb(255,255,255)">%.0f%%</font>] [掐脖: <font color="rgb(255,255,255)">%.0f%%</font>]',
                    anger, burst, choke
                )
            end
        end
    end)
end

local function removeChainESP(chain)
    pcall(function()
        if chain then
            local highlight = chain:FindFirstChild("Highlight")
            if highlight then highlight:Destroy() end
            local nameGui = chain:FindFirstChild("NameGui")
            if nameGui then nameGui:Destroy() end
        end
    end)
end

local function refreshChainESP()
    pcall(function()
        local chain = workspace:FindFirstChild("Misc")
            and workspace.Misc:FindFirstChild("AI")
            and workspace.Misc.AI:FindFirstChild("CHAIN")
        if chain then
            if currentChain ~= chain then
                if currentChain then removeChainESP(currentChain) end
                currentChain = chain
                createChainESP(chain)
            end
            if not chain:FindFirstChild("Highlight") or not chain:FindFirstChild("NameGui") then
                createChainESP(chain)
            end
            updateChainAttributes(chain)
        else
            if currentChain then
                removeChainESP(currentChain)
                currentChain = nil
            end
        end
    end)
end

local function startChainESP()
    if chainESPEnabled then return end
    chainESPEnabled = true
    chainESPConnection = RunService.Heartbeat:Connect(refreshChainESP)
end

local function stopChainESP()
    chainESPEnabled = false
    if chainESPConnection then
        chainESPConnection:Disconnect()
        chainESPConnection = nil
    end
    if currentChain then
        removeChainESP(currentChain)
        currentChain = nil
    end
end

Tab:Toggle({
    Title = "透视chain",
    Value = false,
    Callback = function(state)
        pcall(function()
            if state then
                startChainESP()
            else
                stopChainESP()
            end
        end)
    end
})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local playerESPEnabled = false
local playerESPConnections = {}
local trackedCharacters = {}

local function addESP(character, player)
    pcall(function()
        if not character or not player then return end

        if not character:FindFirstChild("Highlight") then
            local h = Instance.new("Highlight")
            h.Name = "Highlight"
            h.Adornee = character
            h.FillColor = Color3.fromRGB(0, 255, 0)
            h.FillTransparency = 0.7
            h.OutlineColor = Color3.fromRGB(0, 200, 0)
            h.OutlineTransparency = 0.1
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            h.Parent = character
        end

        if not character:FindFirstChild("NameGui") then
            local gui = Instance.new("BillboardGui")
            gui.Name = "NameGui"
            gui.Size = UDim2.new(0, 50, 0, 10)
            gui.StudsOffset = Vector3.new(0, 3.5, 0)
            local adornee = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChildWhichIsA("BasePart")
            gui.Adornee = adornee
            gui.AlwaysOnTop = true
            gui.LightInfluence = 0
            gui.Parent = character

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Text = player.Name
            label.TextColor3 = Color3.new(0, 1, 0)
            label.TextScaled = true
            label.Font = Enum.Font.Gotham
            label.BackgroundTransparency = 1
            label.TextSize = 10
            label.Parent = gui
        end
    end)
end

local function removeESP(character)
    pcall(function()
        if not character then return end
        local highlight = character:FindFirstChild("Highlight")
        if highlight then highlight:Destroy() end

        local nameGui = character:FindFirstChild("NameGui")
        if nameGui then nameGui:Destroy() end
    end)
end

local function onCharacterAdded(player, character)
    pcall(function()
        if not playerESPEnabled then return end
        task.delay(0.3, function()
            pcall(function()
                if playerESPEnabled and character and character.Parent then
                    addESP(character, player)
                end
            end)
        end)
    end)
end

local function trackPlayer(player)
    pcall(function()
        if player == LocalPlayer then return end
        if trackedCharacters[player] then return end
        trackedCharacters[player] = true

        if player.Character then
            onCharacterAdded(player, player.Character)
        end

        local conn = player.CharacterAdded:Connect(function(character)
            onCharacterAdded(player, character)
        end)
        table.insert(playerESPConnections, conn)

        local removeConn = player.AncestryChanged:Connect(function()
            if not player:IsDescendantOf(game) then
                trackedCharacters[player] = nil
            end
        end)
        table.insert(playerESPConnections, removeConn)
    end)
end

local function startPlayerESP()
    if playerESPEnabled then return end
    playerESPEnabled = true

    for _, player in ipairs(Players:GetPlayers()) do
        trackPlayer(player)
    end

    local conn = Players.PlayerAdded:Connect(trackPlayer)
    table.insert(playerESPConnections, conn)
end

local function stopPlayerESP()
    playerESPEnabled = false

    for _, conn in ipairs(playerESPConnections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(playerESPConnections)
    table.clear(trackedCharacters)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            removeESP(player.Character)
        end
    end
end

Tab:Toggle({
    Title = "透视玩家",
    Default = false,
    Callback = function(state)
        pcall(function()
            if state then
                startPlayerESP()
            else
                stopPlayerESP()
            end
        end)
    end
})
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local ScrapFolder = Workspace:WaitForChild("Misc"):WaitForChild("Zones"):WaitForChild("LootingItems"):WaitForChild("Scrap")
local ESPColor = Color3.fromRGB(191, 0, 255)
local ChildAddedConnection

local function ApplyESP(object)
    pcall(function()
        if not object:FindFirstChild("ScrapHighlight") then
            local Highlight = Instance.new("Highlight")
            Highlight.Name = "ScrapHighlight"
            Highlight.FillColor = ESPColor
            Highlight.OutlineColor = Color3.new(1, 1, 1)
            Highlight.FillTransparency = 0.5
            Highlight.OutlineTransparency = 0
            Highlight.Adornee = object
            Highlight.Parent = object
            Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        end
    end)
end

local function RemoveESP()
    pcall(function()
        for _, item in ipairs(ScrapFolder:GetChildren()) do
            local hl = item:FindFirstChild("ScrapHighlight")
            if hl then
                hl:Destroy()
            end
        end
    end)
end

Tab:Toggle({
    Title = "透视废铁",
    Value = false,
    Callback = function(state)
        pcall(function()
            if state then
                for _, item in ipairs(ScrapFolder:GetChildren()) do
                    ApplyESP(item)
                end
                
                ChildAddedConnection = ScrapFolder.ChildAdded:Connect(function(item)
                    pcall(function()
                        task.wait(0.1)
                        ApplyESP(item)
                    end)
                end)
            else
                if ChildAddedConnection then
                    ChildAddedConnection:Disconnect()
                    ChildAddedConnection = nil
                end
                RemoveESP()
            end
        end)
    end,
})
Tab:Button({
    Title = "查看晚上回合时间",
    Callback = function()
        pcall(function()
            local UIS = game:GetService("UserInputService")
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            local pGui = player:WaitForChild("PlayerGui")

            if pGui:FindFirstChild("MiniStatsGui") then
                pGui.MiniStatsGui:Destroy()
            end

            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "MiniStatsGui"
            screenGui.IgnoreGuiInset = true
            screenGui.ResetOnSpawn = false
            screenGui.Parent = pGui

            local mainFrame = Instance.new("Frame")
            mainFrame.Size = UDim2.new(0, 140, 0, 75)
            mainFrame.Position = UDim2.new(0.5, -70, 0.2, 0)
            mainFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 32)
            mainFrame.BorderSizePixel = 0
            mainFrame.ClipsDescendants = true
            mainFrame.Parent = screenGui

            local uiCorner = Instance.new("UICorner")
            uiCorner.CornerRadius = UDim.new(0, 6)
            uiCorner.Parent = mainFrame

            local uiStroke = Instance.new("UIStroke")
            uiStroke.Thickness = 1.5
            uiStroke.Color = Color3.fromRGB(120, 150, 255)
            uiStroke.Parent = mainFrame

            local titleBar = Instance.new("Frame")
            titleBar.Size = UDim2.new(1, 0, 0, 22)
            titleBar.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
            titleBar.BorderSizePixel = 0
            titleBar.Parent = mainFrame

            local titleLabel = Instance.new("TextLabel")
            titleLabel.Size = UDim2.new(1, -45, 1, 0)
            titleLabel.Position = UDim2.new(0, 8, 0, 0)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = "信息显示"
            titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
            titleLabel.TextSize = 11
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.Parent = titleBar

            local closeBtn = Instance.new("TextButton")
            closeBtn.Size = UDim2.new(0, 20, 0, 20)
            closeBtn.Position = UDim2.new(1, -22, 0, 1)
            closeBtn.BackgroundTransparency = 1
            closeBtn.Text = "×"
            closeBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
            closeBtn.TextSize = 18
            closeBtn.Font = Enum.Font.GothamBold
            closeBtn.Parent = titleBar

            local minBtn = Instance.new("TextButton")
            minBtn.Size = UDim2.new(0, 20, 0, 20)
            minBtn.Position = UDim2.new(1, -42, 0, 1)
            minBtn.BackgroundTransparency = 1
            minBtn.Text = "—"
            minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            minBtn.TextSize = 12
            minBtn.Font = Enum.Font.GothamBold
            minBtn.Parent = titleBar

            local content = Instance.new("Frame")
            content.Size = UDim2.new(1, 0, 1, -22)
            content.Position = UDim2.new(0, 0, 0, 22)
            content.BackgroundTransparency = 1
            content.Parent = mainFrame

            local layout = Instance.new("UIListLayout")
            layout.Padding = UDim.new(0, 2)
            layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            layout.VerticalAlignment = Enum.VerticalAlignment.Center
            layout.Parent = content

            local function CreateText()
                local t = Instance.new("TextLabel")
                t.Size = UDim2.new(0.9, 0, 0, 20)
                t.BackgroundTransparency = 1
                t.TextColor3 = Color3.fromRGB(255, 255, 255)
                t.TextSize = 11
                t.Font = Enum.Font.GothamMedium
                t.TextXAlignment = Enum.TextXAlignment.Left
                t.Parent = content
                return t
            end

            local rtLabel = CreateText()
            local pwLabel = CreateText()

            task.spawn(function()
                local folder = workspace:WaitForChild("GameStuff", 20):WaitForChild("Values", 20)
                
                local function Update()
                    pcall(function()
                        local rt = folder:GetAttribute("RoundTime")
                        if rt == nil and folder:FindFirstChild("RoundTime") then rt = folder.RoundTime.Value end
                        
                        local pw = folder:GetAttribute("Power")
                        if pw == nil and folder:FindFirstChild("Power") then pw = folder.Power.Value end
                        
                        rtLabel.Text = "晚上回合时间: " .. tostring(rt or "...")
                        
                        local formattedPower = "..."
                        if pw then
                            if type(pw) == "number" then
                                formattedPower = string.format("%.2f", pw)
                            else
                                formattedPower = tostring(pw)
                            end
                        end
                        pwLabel.Text = "发电站能量: " .. formattedPower
                    end)
                end

                folder.AttributeChanged:Connect(Update)
                for _, v in pairs(folder:GetChildren()) do
                    if v:IsA("ValueBase") then v.Changed:Connect(Update) end
                end
                Update()
            end)

            local dragStart, startPos, dragging
            titleBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragStart = input.Position
                    startPos = mainFrame.Position
                end
            end)

            UIS.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local delta = input.Position - dragStart
                    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)

            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            local isMin = false
            minBtn.MouseButton1Click:Connect(function()
                isMin = not isMin
                content.Visible = not isMin
                mainFrame:TweenSize(isMin and UDim2.new(0, 140, 0, 22) or UDim2.new(0, 140, 0, 75), "Out", "Quart", 0.2, true)
                minBtn.Text = isMin and "+" or "—"
            end)

            closeBtn.MouseButton1Click:Connect(function()
                screenGui:Destroy()
            end)
        end)
    end
})
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")

local chainESPEnabled = false
local chainESPConnection = nil
local currentChain = nil

local function createChainESP(chain)
    pcall(function()
        if not chain:FindFirstChild("Highlight") then
            local h = Instance.new("Highlight")
            h.Name = "Highlight"
            h.Adornee = chain
            h.FillColor = Color3.fromRGB(255, 0, 0)
            h.FillTransparency = 0.8
            h.OutlineColor = Color3.fromRGB(255, 60, 60)
            h.OutlineTransparency = 0
            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            h.Parent = chain
        end

        if not chain:FindFirstChild("NameGui") then
            local gui = Instance.new("BillboardGui")
            gui.Name = "NameGui"
            gui.Size = UDim2.new(0, 150, 0, 30)
            gui.StudsOffset = Vector3.new(0, 5, 0)
            gui.Adornee = chain
            gui.AlwaysOnTop = true
            gui.LightInfluence = 0
            gui.Parent = chain

            local titleLabel = Instance.new("TextLabel")
            titleLabel.Name = "TitleLabel"
            titleLabel.Size = UDim2.new(1, 0, 0.5, 0)
            titleLabel.Position = UDim2.new(0, 0, 0, 0)
            titleLabel.Text = "CHAIN"
            titleLabel.TextColor3 = Color3.new(1, 0, 0)
            titleLabel.TextScaled = true
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.TextSize = 10
            titleLabel.BackgroundTransparency = 1
            titleLabel.Parent = gui

            local attrLabel = Instance.new("TextLabel")
            attrLabel.Name = "AttrLabel"
            attrLabel.Size = UDim2.new(1, 0, 0.5, 0)
            attrLabel.Position = UDim2.new(0, 0, 0.5, 0)
            attrLabel.RichText = true
            attrLabel.Text = ""
            attrLabel.TextColor3 = Color3.new(1, 1, 1)
            attrLabel.TextScaled = true
            attrLabel.Font = Enum.Font.Gotham
            attrLabel.TextSize = 8
            attrLabel.BackgroundTransparency = 1
            attrLabel.Parent = gui
        end
    end)
end

local function updateChainAttributes(chain, screenLabels)
    pcall(function()
        local gui = chain:FindFirstChild("NameGui")
        if gui then
            local attrLabel = gui:FindFirstChild("AttrLabel")
            if attrLabel then
                local anger = chain:GetAttribute("Anger") or 0
                local burst = chain:GetAttribute("Burst") or 0
                local choke = chain:GetAttribute("ChokeMeter") or 0
                attrLabel.Text = string.format(
                    '[血月度: <font color="rgb(255,255,255)">%.0f%%</font>] [捶地: <font color="rgb(255,255,255)">%.0f%%</font>] [掐脖: <font color="rgb(255,255,255)">%.0f%%</font>]',
                    anger, burst, choke
                )

                if screenLabels then
                    screenLabels.anger.Text = string.format("血月度: %.0f%%", anger)
                    screenLabels.burst.Text = string.format("捶地: %.0f%%", burst)
                    screenLabels.choke.Text = string.format("掐脖: %.0f%%", choke)
                end
            end
        end
    end)
end

local function removeChainESP(chain)
    pcall(function()
        if chain then
            local highlight = chain:FindFirstChild("Highlight")
            if highlight then highlight:Destroy() end
            local nameGui = chain:FindFirstChild("NameGui")
            if nameGui then nameGui:Destroy() end
        end
    end)
end

local function refreshChainESP(screenLabels)
    pcall(function()
        local chain = workspace:FindFirstChild("Misc")
            and workspace.Misc:FindFirstChild("AI")
            and workspace.Misc.AI:FindFirstChild("CHAIN")
        if chain then
            if currentChain ~= chain then
                if currentChain then removeChainESP(currentChain) end
                currentChain = chain
                createChainESP(chain)
            end
            if not chain:FindFirstChild("Highlight") or not chain:FindFirstChild("NameGui") then
                createChainESP(chain)
            end
            updateChainAttributes(chain, screenLabels)
        else
            if currentChain then
                removeChainESP(currentChain)
                currentChain = nil
            end
        end
    end)
end

local function createScreenWindow()
    if pGui:FindFirstChild("ChainESPGui") then
        pGui.ChainESPGui:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ChainESPGui"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false
    screenGui.Parent = pGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 140, 0, 95)
    mainFrame.Position = UDim2.new(0.5, -70, 0.2, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 32)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 6)
    uiCorner.Parent = mainFrame

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Thickness = 1.5
    uiStroke.Color = Color3.fromRGB(120, 150, 255)
    uiStroke.Parent = mainFrame

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 22)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -45, 1, 0)
    titleLabel.Position = UDim2.new(0, 8, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "chain信息"
    titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    titleLabel.TextSize = 11
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(1, -22, 0, 1)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = titleBar

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 20, 0, 20)
    minBtn.Position = UDim2.new(1, -42, 0, 1)
    minBtn.BackgroundTransparency = 1
    minBtn.Text = "—"
    minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minBtn.TextSize = 12
    minBtn.Font = Enum.Font.GothamBold
    minBtn.Parent = titleBar

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, -22)
    content.Position = UDim2.new(0, 0, 0, 22)
    content.BackgroundTransparency = 1
    content.Parent = mainFrame

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 2)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Parent = content

    local function CreateText()
        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(0.9, 0, 0, 20)
        t.BackgroundTransparency = 1
        t.TextColor3 = Color3.fromRGB(255, 255, 255)
        t.TextSize = 11
        t.Font = Enum.Font.GothamMedium
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.Parent = content
        return t
    end

    local angerLabel = CreateText()
    local burstLabel = CreateText()
    local chokeLabel = CreateText()

    local screenLabels = {
        anger = angerLabel,
        burst = burstLabel,
        choke = chokeLabel
    }

    local dragStart, startPos, dragging
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local isMin = false
    minBtn.MouseButton1Click:Connect(function()
        isMin = not isMin
        content.Visible = not isMin
        mainFrame:TweenSize(isMin and UDim2.new(0, 140, 0, 22) or UDim2.new(0, 140, 0, 95), "Out", "Quart", 0.2, true)
        minBtn.Text = isMin and "+" or "—"
    end)

    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    return screenLabels
end

local function startChainESP()
    if chainESPEnabled then return end
    chainESPEnabled = true
    local screenLabels = createScreenWindow()
    chainESPConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            refreshChainESP(screenLabels)
        end)
    end)
end

local function stopChainESP()
    chainESPEnabled = false
    if chainESPConnection then
        chainESPConnection:Disconnect()
        chainESPConnection = nil
    end
    if currentChain then
        removeChainESP(currentChain)
        currentChain = nil
    end
    if pGui:FindFirstChild("ChainESPGui") then
        pGui.ChainESPGui:Destroy()
    end
end

Tab:Button({
    Title = "悬浮窗式查看chain信息",
    Callback = function()
        pcall(function()
            local screenLabels = createScreenWindow()
            
            task.spawn(function()
                while screenLabels and pGui:FindFirstChild("ChainESPGui") do
                    pcall(function()
                        local chain = workspace:FindFirstChild("Misc")
                            and workspace.Misc:FindFirstChild("AI")
                            and workspace.Misc.AI:FindFirstChild("CHAIN")
                        if chain then
                            updateChainAttributes(chain, screenLabels)
                        else
                            screenLabels.anger.Text = "血月度: ..."
                            screenLabels.burst.Text = "捶地: ..."
                            screenLabels.choke.Text = "掐脖: ..."
                        end
                    end)
                    task.wait(0.05)
                end
            end)
        end)
    end
})
local trashTab = Window:Tab({  
    Title = "自动农场",  
    Icon = "trash",  
    Locked = false,
})
local ScrapFolder = workspace:WaitForChild("Misc"):WaitForChild("Zones"):WaitForChild("LootingItems"):WaitForChild("Scrap")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local autoFarmEnabled = false
local currentTween = nil
local moveSpeed = 10
local lastMoveTime = 0

local lastFireTime = 0
local fireTimestamps = {}
local cooldownUntil = 0

local FIRE_INTERVAL = 3
local DOUBLE_FIRE_WINDOW = 6
local DOUBLE_FIRE_COOLDOWN = 5
local IDLE_TIMEOUT = 5

local targetPositions = {
    Vector3.new(-26.879013061523438, -107.01750183105469, -204.7770538330078),
    Vector3.new(-110.85892486572266, -86.33830261230469, 211.8588409423828),
    Vector3.new(43.30422592163086, -97.9687728881836, 349.1531982421875),
    Vector3.new(164.49859619140625, -103.65132141113281, -35.76066207885742),
    Vector3.new(308.97198486328125, -113.4938735961914, -250.46066284179688),
    Vector3.new(-203.81826782226562, -110.8906478881836, -108.90457916259766),
    Vector3.new(-381.873046875, -115.02182006835938, 42.071022033691406),
}
local tpIndex = 1

local function getRootPart()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function stopMovement()
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
end

local function getGroundY(pos)
    local char = LocalPlayer.Character
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    if char then params.FilterDescendantsInstances = {char} end

    local offsets = {0, 5, 15, 30, 60}
    for _, yOff in ipairs(offsets) do
        local origin = Vector3.new(pos.X, pos.Y + yOff, pos.Z)
        local result = workspace:Raycast(origin, Vector3.new(0, -(yOff + 40), 0), params)
        if result then
            return result.Position.Y
        end
    end

    local fallback = workspace:Raycast(
        Vector3.new(pos.X, 10000, pos.Z),
        Vector3.new(0, -20000, 0),
        params
    )
    if fallback then
        return fallback.Position.Y
    end

    return pos.Y
end

local function safeStandY(pos)
    local groundY = getGroundY(pos)
    local hrp = getRootPart()
    local currentY = hrp and hrp.Position.Y or groundY
    local resultY = groundY + 3
    if resultY > currentY + 20 then
        resultY = currentY
    end
    return resultY
end

local function isAvailable(scrapChild)
    local valuesFolder = scrapChild:FindFirstChild("Values")
    if not valuesFolder then return false end
    local av = valuesFolder:GetAttribute("Available")
    return av == true
end

local function hasLineOfSight(from, to)
    local dir = to - from
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local char = LocalPlayer.Character
    if char then params.FilterDescendantsInstances = {char} end
    local result = workspace:Raycast(from, dir * 0.95, params)
    return result == nil
end

local function getBypassPos(from, to)
    local dir = to - from
    local right = Vector3.new(-dir.Z, 0, dir.X).Unit * 7
    local c1 = from + right + dir * 0.4
    local c2 = from - right + dir * 0.4
    c1 = Vector3.new(c1.X, safeStandY(c1), c1.Z)
    c2 = Vector3.new(c2.X, safeStandY(c2), c2.Z)
    if hasLineOfSight(c1, to) then return c1 end
    if hasLineOfSight(c2, to) then return c2 end
    return c1
end

local function smoothMoveTo(targetPos)
    pcall(function()
        local hrp = getRootPart()
        if not hrp then return end

        local safeY = safeStandY(targetPos)
        local safePos = Vector3.new(targetPos.X, safeY, targetPos.Z)

        lastMoveTime = tick()

        local from = hrp.Position
        if not hasLineOfSight(from, safePos) then
            local bypass = getBypassPos(from, safePos)
            local d1 = (from - bypass).Magnitude
            local t1 = TweenService:Create(hrp, TweenInfo.new(math.max(d1 / moveSpeed, 0.1), Enum.EasingStyle.Linear), {
                CFrame = CFrame.new(bypass)
            })
            currentTween = t1
            t1:Play()
            t1.Completed:Wait()
            if not autoFarmEnabled then return end
            lastMoveTime = tick()
        end

        hrp = getRootPart()
        if not hrp then return end

        local finalY = safeStandY(safePos)
        local finalPos = Vector3.new(safePos.X, finalY, safePos.Z)
        local d2 = (hrp.Position - finalPos).Magnitude
        local t2 = TweenService:Create(hrp, TweenInfo.new(math.max(d2 / moveSpeed, 0.1), Enum.EasingStyle.Linear), {
            CFrame = CFrame.new(finalPos)
        })
        currentTween = t2
        t2:Play()
        t2.Completed:Wait()
        currentTween = nil
        lastMoveTime = tick()
    end)
end

local function getAllPrompts()
    local results = {}
    for _, scrapChild in ipairs(ScrapFolder:GetChildren()) do
        if isAvailable(scrapChild) then
            local function recurse(obj)
                for _, child in ipairs(obj:GetChildren()) do
                    if child:IsA("ProximityPrompt") then
                        table.insert(results, { prompt = child, scrapChild = scrapChild })
                    else
                        recurse(child)
                    end
                end
            end
            recurse(scrapChild)
        end
    end
    return results
end

local function canFire()
    local now = tick()
    if now < cooldownUntil then return false end
    if (now - lastFireTime) < FIRE_INTERVAL then return false end
    return true
end

local function recordFire()
    local now = tick()
    lastFireTime = now
    table.insert(fireTimestamps, now)
    local recent = {}
    for _, t in ipairs(fireTimestamps) do
        if (now - t) <= DOUBLE_FIRE_WINDOW then
            table.insert(recent, t)
        end
    end
    fireTimestamps = recent
    if #fireTimestamps >= 2 then
        cooldownUntil = now + DOUBLE_FIRE_COOLDOWN
        fireTimestamps = {}
    end
end

local function doFirePrompt(prompt)
    if prompt and prompt:IsA("ProximityPrompt") then
        pcall(function()
            fireproximityprompt(prompt)
        end)
        recordFire()
    end
end

local function getStandPos(part, hrpPos)
    local dir = Vector3.new(hrpPos.X - part.Position.X, 0, hrpPos.Z - part.Position.Z)
    if dir.Magnitude < 0.1 then dir = Vector3.new(0, 0, 1) end
    return part.Position + dir.Unit * 3
end

local function idleWatchLoop()
    lastMoveTime = tick()
    while autoFarmEnabled do
        task.wait(0.5)
        if autoFarmEnabled and (tick() - lastMoveTime) >= IDLE_TIMEOUT then
            pcall(function()
                local hrp = getRootPart()
                if hrp then
                    hrp.CFrame = CFrame.new(targetPositions[tpIndex] + Vector3.new(0, 3, 0))
                    tpIndex = (tpIndex % #targetPositions) + 1
                    lastMoveTime = tick()
                end
            end)
        end
    end
end

local function isChainTooClose()
    if not repelEnabled then return false end
    local hrp = getRootPart()
    if not hrp then return false end
    local chainPos = getChainPos()
    if not chainPos then return false end
    local diff = Vector3.new(hrp.Position.X - chainPos.X, 0, hrp.Position.Z - chainPos.Z)
    return diff.Magnitude < repelRange
end

local function farmLoop()
    while autoFarmEnabled do
        pcall(function()
            if isChainTooClose() then
                task.wait(0.1)
                return
            end

            local hrp = getRootPart()
            local entries = getAllPrompts()

            if #entries == 0 then
                task.wait(2)
                return
            end

            local nearest, nearestDist, nearestPart = nil, math.huge, nil
            for _, entry in ipairs(entries) do
                local part = entry.prompt.Parent
                while part and not part:IsA("BasePart") do
                    part = part.Parent
                end
                if part then
                    local dist = (hrp.Position - part.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearest = entry.prompt
                        nearestPart = part
                    end
                end
            end

            if not nearest or not nearestPart then
                task.wait(1)
                return
            end

            local standPos = getStandPos(nearestPart, hrp.Position)
            smoothMoveTo(standPos)
            if not autoFarmEnabled then return end

            task.wait(0.2)

            if not canFire() then
                local waitNeeded = math.max(cooldownUntil - tick(), lastFireTime + FIRE_INTERVAL - tick())
                if waitNeeded > 0 then
                    local waited = 0
                    while waited < waitNeeded and autoFarmEnabled do
                        task.wait(0.1)
                        waited += 0.1
                    end
                end
            end

            if autoFarmEnabled and canFire() then
                doFirePrompt(nearest)
            end

            task.wait(0.3)
        end)
    end
end

trashTab:Slider({
    Title = "捡废铁速度",
    Value = {
        Min = 5,
        Max = 20,
        Default = 10,
    },
    Callback = function(val)
        pcall(function()
            moveSpeed = val
        end)
    end,
})

trashTab:Toggle({
    Title = "自动捡废铁",
    Value = false,
    Callback = function(state)
        pcall(function()
            autoFarmEnabled = state
            if not state then
                stopMovement()
                fireTimestamps = {}
                lastFireTime = 0
                cooldownUntil = 0
            else
                lastMoveTime = tick()
                tpIndex = 1
                task.spawn(farmLoop)
                task.spawn(idleWatchLoop)
            end
        end)
    end,
})
local G = {}

G.ScrapFolder = workspace:WaitForChild("Misc"):WaitForChild("Zones"):WaitForChild("LootingItems"):WaitForChild("Scrap")
G.Players = game:GetService("Players")
G.RunService = game:GetService("RunService")
G.LocalPlayer = G.Players.LocalPlayer
G.auraEnabled = false
G.auraRange = 10
G.auraConnection = nil

function G.getHRP()
    local char = G.LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

function G.isAvailable(scrapChild)
    local vf = scrapChild:FindFirstChild("Values")
    if not vf then return false end
    return vf:GetAttribute("Available") == true
end

function G.getPrompt(obj)
    local function recurse(o)
        for _, child in ipairs(o:GetChildren()) do
            if child:IsA("ProximityPrompt") then return child end
            local found = recurse(child)
            if found then return found end
        end
        return nil
    end
    return recurse(obj)
end

function G.getPartPos(obj)
    if obj:IsA("BasePart") then return obj.Position end
    for _, d in ipairs(obj:GetDescendants()) do
        if d:IsA("BasePart") then return d.Position end
    end
    return nil
end

trashTab:Toggle({
    Title = "捡废铁光环",
    Desc = "如果你想自己跑过去捡的话你也可以开一下这个功能 这可以不用你一直手动点那个按钮去捡",
    Value = false,
    Callback = function(state)
        pcall(function()
            G.auraEnabled = state
            if G.auraConnection then
                G.auraConnection:Disconnect()
                G.auraConnection = nil
            end
            if not state then return end
            G.auraConnection = G.RunService.Heartbeat:Connect(function()
                pcall(function()
                    local hrp = G.getHRP()
                    if not hrp then return end
                    for _, scrapChild in ipairs(G.ScrapFolder:GetChildren()) do
                        if G.isAvailable(scrapChild) then
                            local pos = G.getPartPos(scrapChild)
                            if pos then
                                local dist = (hrp.Position - pos).Magnitude
                                if dist <= G.auraRange then
                                    local prompt = G.getPrompt(scrapChild)
                                    if prompt then
                                        pcall(function()
                                            fireproximityprompt(prompt)
                                        end)
                                    end
                                end
                            end
                        end
                    end
                end)
            end)
        end)
    end,
})

local Tab = Window:Tab({
    Title = "暴力功能",
    Icon = "hand",
    Locked = false,
})
Tab:Paragraph({
    Title = "注意事项",
    Desc = "开启无限闪避之后再点一下闪避键自动无限闪避就有用了，自动挥刀滥用也是一样的,然后开了无敌就不能用自动挥刀滥用",
    Image = "circle-alert",
    Color = "Red",
    ImageSize = 40, 
    ThumbnailSize = 120
})
Tab:Toggle({
    Title = "检测管理员/经常举报者",
    Value = false,
    Callback = function(state)
        pcall(function()
            _G.AdminCheckEnabled = state

            if _G.AdminConnection then
                _G.AdminConnection:Disconnect()
                _G.AdminConnection = nil
            end

            if not _G.AdminCheckEnabled then
                _G.AdminNotified = nil
                return
            end

            local Players = game:GetService("Players")
            local targetUsers = {
                "Mylezeezz","Sir_Mason13","jasper_creations","ItzRoboMaggot","CyroTr00per",
                "JankCorp","JakeDravioli","1Boomah",
                "MikoSfx","Lgl_frijol","xF_alse","FluxedThoughts","Blackcoolia","Crinsikle",
                "HolyBlanks","mightyasher","ROV3RRO","Oce1rosTheConsum3d","Tsunantt",
                "Shark_bossx007","AgentCatto","ashinvy","roblox_user_841257226",
                "As3tra1","GetRightDawg","N0XMANIAC","Benthesoccerone","Megamind184",
                "OrekLus1","maravilye2312","euphoria4830","XHttpkeVin","ddelus1",
                "Chromixx_WasTaken","fraudTheSecond","IAmUnderAMask",
                "Yurixzaaa","SSpreezzy"
            }

            local targetSet = {}
            for _, userName in ipairs(targetUsers) do
                targetSet[userName] = true
            end

            _G.AdminNotified = {}

            local function sendNotify(playerName)
                if not _G.AdminCheckEnabled then return end
                if _G.AdminNotified[playerName] then return end
                _G.AdminNotified[playerName] = true

                local notifyData = {
                    Title = "危险",
                    Content = "此服务器上有傻逼管理员或者经常给脚本挂dc的，请你小心此服务器上的这些人：" .. playerName,
                    Duration = 17.5
                }

                if WindUI.Notify then
                    WindUI:Notify(notifyData)
                elseif WindUI.AddNotification then
                    WindUI:AddNotification(notifyData)
                end
            end

            local function checkPlayer(player)
                if targetSet[player.Name] then
                    sendNotify(player.Name)
                end
            end

            _G.AdminConnection = Players.PlayerAdded:Connect(function(player)
                if _G.AdminCheckEnabled then
                    checkPlayer(player)
                end
            end)

            for _, player in ipairs(Players:GetPlayers()) do
                checkPlayer(player)
            end
        end)
    end
})

Tab:Toggle({
    Title = "chain爆炸自动躲v1",
    Value = false,
    Callback = function(state)
        pcall(function()
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local LocalPlayer = Players.LocalPlayer
            local animationIdToCheck = "rbxassetid://14875631059"
            local TELEPORT_DISTANCE = 100
            local DETECT_RANGE = 12
            local RETURN_DISTANCE = 30
            local AIR_ANGLE = math.rad(45)
            local AIR_DURATION = 4

            local targetModel
            local animationAOE
            local originalCFrame
            local teleporting = false

            local function updateTarget()
                local misc = workspace:FindFirstChild("Misc")
                if misc and misc:FindFirstChild("AI") and misc.AI:FindFirstChild("CHAIN") then
                    targetModel = misc.AI.CHAIN
                    local aiFolder = targetModel:FindFirstChild("AI")
                    if aiFolder and aiFolder:FindFirstChild("Animations") and aiFolder.Animations:FindFirstChild("AOE") then
                        animationAOE = aiFolder.Animations.AOE
                    else
                        animationAOE = nil
                    end
                else
                    targetModel = nil
                    animationAOE = nil
                end
            end

            local function getRoot()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                return char:WaitForChild("HumanoidRootPart")
            end

            local function isAnimationPlaying()
                if not targetModel then return false end
                local humanoid = targetModel:FindFirstChildWhichIsA("Humanoid", true)
                if humanoid then
                    local animator = humanoid:FindFirstChildOfClass("Animator")
                    if animator then
                        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                            local animId = track.Animation.AnimationId
                            if animationAOE and (animId == animationAOE.AnimationId or animId == animationIdToCheck) then
                                return true
                            end
                        end
                    end
                end
                return false
            end

            local function teleportAboveTarget()
                if not targetModel or teleporting then return end
                local root = getRoot()
                local distance = (root.Position - targetModel:GetPivot().Position).Magnitude
                if distance > DETECT_RANGE then return end
                teleporting = true
                originalCFrame = root.CFrame

                local targetPos = targetModel:GetPivot().Position + Vector3.new(0, TELEPORT_DISTANCE * math.sin(AIR_ANGLE), 0)
                local lookVector = targetModel:GetPivot().LookVector
                root.CFrame = CFrame.new(targetPos, targetPos + lookVector)

                local startTime = tick()
                while tick() - startTime < AIR_DURATION do
                    root.CFrame = CFrame.new(targetPos, targetPos + lookVector)
                    task.wait(0.03)
                end

                local returnPos = targetModel:GetPivot().Position + Vector3.new(0, 3, 0) + (lookVector * RETURN_DISTANCE)
                root.CFrame = CFrame.new(returnPos, targetModel:GetPivot().Position)
                teleporting = false
            end

            local lastPlaying = false

            if state then
                updateTarget()

                if not _G.chainDodgeAutoUpdate then
                    _G.chainDodgeAutoUpdate = workspace.DescendantAdded:Connect(function(obj)
                        if obj.Name == "CHAIN" or obj.Name == "AOE" then
                            task.wait(0.1)
                            updateTarget()
                        end
                    end)
                end

                if not _G.chainDodgeCharAdded then
                    _G.chainDodgeCharAdded = LocalPlayer.CharacterAdded:Connect(function()
                        task.wait(1)
                        updateTarget()
                    end)
                end

                _G.chainDodgeConn = RunService.Heartbeat:Connect(function()
                    pcall(function()
                        if not targetModel then
                            updateTarget()
                        end
                        local playing = isAnimationPlaying()
                        if playing and not lastPlaying then
                            task.spawn(teleportAboveTarget)
                        end
                        lastPlaying = playing
                    end)
                end)
            else
                if _G.chainDodgeConn then
                    _G.chainDodgeConn:Disconnect()
                    _G.chainDodgeConn = nil
                end
                if _G.chainDodgeAutoUpdate then
                    _G.chainDodgeAutoUpdate:Disconnect()
                    _G.chainDodgeAutoUpdate = nil
                end
                if _G.chainDodgeCharAdded then
                    _G.chainDodgeCharAdded:Disconnect()
                    _G.chainDodgeCharAdded = nil
                end
            end
        end)
    end
})
Tab:Toggle({
    Title = "chain爆炸自动躲v2",
    Value = false,
    Callback = function(state)
        pcall(function()
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local LocalPlayer = Players.LocalPlayer
            local animationIdToCheck = "rbxassetid://14875631059"
            local DETECT_RANGE = 12
            local TELEPORT_DISTANCE = 70

            local targetModel
            local animationAOE
            local teleporting = false

            local function updateTarget()
                local misc = workspace:FindFirstChild("Misc")
                if misc and misc:FindFirstChild("AI") and misc.AI:FindFirstChild("CHAIN") then
                    targetModel = misc.AI.CHAIN
                    local aiFolder = targetModel:FindFirstChild("AI")
                    if aiFolder and aiFolder:FindFirstChild("Animations") and aiFolder.Animations:FindFirstChild("AOE") then
                        animationAOE = aiFolder.Animations.AOE
                    else
                        animationAOE = nil
                    end
                else
                    targetModel = nil
                    animationAOE = nil
                end
            end

            local function getRoot()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                return char:WaitForChild("HumanoidRootPart")
            end

            local function isAnimationPlaying()
                if not targetModel then return false end
                local humanoid = targetModel:FindFirstChildWhichIsA("Humanoid", true)
                if humanoid then
                    local animator = humanoid:FindFirstChildOfClass("Animator")
                    if animator then
                        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                            local animId = track.Animation.AnimationId
                            if animationAOE and (animId == animationAOE.AnimationId or animId == animationIdToCheck) then
                                return true
                            end
                        end
                    end
                end
                return false
            end

            local function teleportFront()
                if not targetModel or teleporting then return end
                local root = getRoot()
                local distance = (root.Position - targetModel:GetPivot().Position).Magnitude
                if distance > DETECT_RANGE then return end
                teleporting = true
                local lookVector = targetModel:GetPivot().LookVector
                local frontPos = targetModel:GetPivot().Position + (lookVector * TELEPORT_DISTANCE) + Vector3.new(0, 10, 0)
                root.CFrame = CFrame.new(frontPos, targetModel:GetPivot().Position + Vector3.new(0, 10, 0))
                teleporting = false
            end

            local lastPlaying = false

            if state then
                updateTarget()

                if not _G.chainDodgeAutoUpdateV2 then
                    _G.chainDodgeAutoUpdateV2 = workspace.DescendantAdded:Connect(function(obj)
                        if obj.Name == "CHAIN" or obj.Name == "AOE" then
                            task.wait(0.1)
                            updateTarget()
                        end
                    end)
                end

                if not _G.chainDodgeCharAddedV2 then
                    _G.chainDodgeCharAddedV2 = LocalPlayer.CharacterAdded:Connect(function()
                        task.wait(1)
                        updateTarget()
                    end)
                end

                _G.chainDodgeConnV2 = RunService.Heartbeat:Connect(function()
                    pcall(function()
                        if not targetModel then
                            updateTarget()
                        end
                        local playing = isAnimationPlaying()
                        if playing and not lastPlaying then
                            task.spawn(teleportFront)
                        end
                        lastPlaying = playing
                    end)
                end)
            else
                if _G.chainDodgeConnV2 then
                    _G.chainDodgeConnV2:Disconnect()
                    _G.chainDodgeConnV2 = nil
                end
                if _G.chainDodgeAutoUpdateV2 then
                    _G.chainDodgeAutoUpdateV2:Disconnect()
                    _G.chainDodgeAutoUpdateV2 = nil
                end
                if _G.chainDodgeCharAddedV2 then
                    _G.chainDodgeCharAddedV2:Disconnect()
                    _G.chainDodgeCharAddedV2 = nil
                end
            end
        end)
    end
})
local repelEnabled = false
local repelRange = 50
local repelKeepDist = 50
local repelConnection = nil

local CHAIN_PATH = {"Misc", "AI", "CHAIN"}

local function getChain()
    local obj = workspace
    for _, name in ipairs(CHAIN_PATH) do
        obj = obj:FindFirstChild(name)
        if not obj then return nil end
    end
    return obj
end

local function getChainPos()
    local chain = getChain()
    if not chain then return nil end
    if chain:IsA("BasePart") then return chain.Position end
    local hrp = chain:FindFirstChild("HumanoidRootPart")
    if hrp then return hrp.Position end
    for _, d in ipairs(chain:GetDescendants()) do
        if d:IsA("BasePart") then return d.Position end
    end
    return nil
end
Tab:Toggle({
    Title = "自动远离chain",
    Value = false,
    Callback = function(state)
        pcall(function()
            repelEnabled = state
            if repelConnection then
                repelConnection:Disconnect()
                repelConnection = nil
            end
            if not state then return end
            local RunService = game:GetService("RunService")
            repelConnection = RunService.Heartbeat:Connect(function()
                pcall(function()
                    if not repelEnabled then return end
                    local hrp = getRootPart()
                    if not hrp then return end
                    local chainPos = getChainPos()
                    if not chainPos then return end
                    local myPos = hrp.Position
                    local diff = Vector3.new(myPos.X - chainPos.X, 0, myPos.Z - chainPos.Z)
                    local dist = diff.Magnitude
                    if dist < repelRange then
                        local pushDir = diff.Magnitude > 0.1 and diff.Unit or Vector3.new(1, 0, 0)
                        local targetPos = chainPos + pushDir * repelKeepDist
                        local groundY = getGroundY(targetPos)
                        local safeY = math.min(groundY + 3, myPos.Y + 10)
                        hrp.CFrame = CFrame.new(Vector3.new(targetPos.X, safeY, targetPos.Z))
                    end
                end)
            end)
        end)
    end,
})
Tab:Slider({
    Title = "chain隔离距离",
    Value = {
        Min = 20,
        Max = 200,
        Default = 50,
    },
    Callback = function(val)
        pcall(function()
            repelKeepDist = val
            repelRange = val
        end)
    end,
})
Tab:Toggle({
    Title = "无限油",
    Desc = "不能无限特殊技能，除非你一直买油",
    Value = false,
    Callback = function(state)
        pcall(function()
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local running = false
            local taskConnection

            if state then
                running = true
                taskConnection = task.spawn(function()
                    while running do
                        pcall(function()
                            local char = LocalPlayer.Character
                            if char and char:FindFirstChild("Items") and char.Items:FindFirstChild("XSaw") then
                                char.Items.XSaw:SetAttribute("Gas", 100)
                            end
                            task.wait(0.01)
                        end)
                    end
                end)
            else
                running = false
                if taskConnection then
                    taskConnection = nil
                end
            end
        end)
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local CTS
local capturingCTS = false
local LastCTSArgs
local loop

local function refreshCTS()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        CTS = char:WaitForChild("CharacterMobility"):WaitForChild("CTS")
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    pcall(function()
        task.wait(1)
        refreshCTS()
        LastCTSArgs = nil
        if capturingCTS then
            capturingCTS = true
        end
    end)
end)

refreshCTS()

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" and self == CTS then
        local args = {...}
        if capturingCTS and not LastCTSArgs then
            LastCTSArgs = args
        end
    end
    return old(self, ...)
end
setreadonly(mt, true)

Tab:Toggle({
    Title = "自动无限闪避",
    Desc = "开启功能之后需要你手动点一下闪避键(注意:多次闪避会被踢)",
    Value = false,
    Callback = function(state)
        pcall(function()
            if state then
                capturingCTS = true
                LastCTSArgs = nil
                if loop then
                    loop:Disconnect()
                    loop = nil
                end
                loop = RunService.Heartbeat:Connect(function(dt)
                    pcall(function()
                        if not CTS or not CTS.Parent then
                            refreshCTS()
                        end
                        if CTS and LastCTSArgs then
                            if tick() % 0.7 < dt then
                                CTS:FireServer(unpack(LastCTSArgs))
                            end
                        end
                    end)
                end)
            else
                capturingCTS = false
                if loop then
                    loop:Disconnect()
                    loop = nil
                end
            end
        end)
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Interact
local capturingInteract = false
local LastInteractArgs
local loop
local swingDelay = 0.7

local function refreshInteract()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        Interact = char:WaitForChild("CharacterHandler"):WaitForChild("Contents"):WaitForChild("Remotes"):WaitForChild("Interact")
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    pcall(function()
        task.wait(1)
        refreshInteract()
        LastInteractArgs = nil
        if capturingInteract then
            capturingInteract = true
        end
    end)
end)

refreshInteract()

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" and self == Interact then
        local args = {...}
        if capturingInteract and not LastInteractArgs then
            LastInteractArgs = args
        end
    end
    return old(self, ...)
end
setreadonly(mt, true)

Tab:Input({
    Title = "自动挥刀间隔(最高1最低0.7)",
    Value = "0.7",
    Placeholder = "0.7-1",
    Callback = function(input)
        pcall(function()
            local num = tonumber(input)
            if num then
                if num > 1 then
                    num = 1
                elseif num < 0.01 then
                    num = 0.01
                end
                swingDelay = num
            end
        end)
    end
})

Tab:Toggle({
    Title = "自动挥刀滥用",
    Desc = "速度调低了也会被踢",
    Value = false,
    Callback = function(state)
        pcall(function()
            if state then
                capturingInteract = true
                LastInteractArgs = nil
                if loop then
                    loop:Disconnect()
                    loop = nil
                end
                loop = RunService.Heartbeat:Connect(function(dt)
                    pcall(function()
                        if not Interact or not Interact.Parent then
                            refreshInteract()
                        end
                        if Interact and LastInteractArgs then
                            if tick() % swingDelay < dt then
                                Interact:FireServer(unpack(LastInteractArgs))
                            end
                        end
                    end)
                end)
            else
                capturingInteract = false
                if loop then
                    loop:Disconnect()
                    loop = nil
                end
            end
        end)
    end
})
local G = {}

G.Players = game:GetService("Players")
G.RunService = game:GetService("RunService")
G.Workspace = game:GetService("Workspace")
G.LocalPlayer = G.Players.LocalPlayer

G.CTS = nil
G.StoredCTSArgs = nil
G.CapturedThisLife = false

G.ChokeEnabled = false
G.ScreamEnabled = false

G.DetectRange = 14
G.LastDodgeTime = 0

G.ChokeAnimId = "16214202640"
G.ScreamAnimIds = { "14401168075", "15943264089" }

G.LastKnownTracks = {}
G.boundChain = nil

function G.refreshCTS()
    pcall(function()
        local char = G.LocalPlayer.Character
        if not char then return end
        local mob = char:FindFirstChild("CharacterMobility")
        if mob then
            local cts = mob:FindFirstChild("CTS")
            if cts then G.CTS = cts end
        end
    end)
end

function G.resetLifeState()
    pcall(function()
        G.CTS = nil
        G.StoredCTSArgs = nil
        G.CapturedThisLife = false
        G.LastKnownTracks = {}
        task.wait(1)
        G.refreshCTS()
    end)
end

G.LocalPlayer.CharacterAdded:Connect(G.resetLifeState)
G.refreshCTS()

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)

mt.__namecall = function(self, ...)
    local method = getnamecallmethod()
    local args = { ... }
    if method == "FireServer" and self == G.CTS and not G.CapturedThisLife then
        if args[1] == "Dodge1" then
            G.StoredCTSArgs = args
            G.CapturedThisLife = true
        end
    end
    return old(self, ...)
end

setreadonly(mt, true)

function G.AttemptDodge()
    pcall(function()
        if G.CTS and G.StoredCTSArgs and G.CapturedThisLife then
            local now = os.clock()
            if now - G.LastDodgeTime >= 0.05 then
                G.LastDodgeTime = now
                G.CTS:FireServer(unpack(G.StoredCTSArgs))
            end
        end
    end)
end

function G.getChain()
    local misc = G.Workspace:FindFirstChild("Misc")
    if not misc then return nil end
    local ai = misc:FindFirstChild("AI")
    if not ai then return nil end
    return ai:FindFirstChild("CHAIN")
end

function G.checkAnimId(id)
    if G.ChokeEnabled and id:find(G.ChokeAnimId) then
        return true
    end
    if G.ScreamEnabled then
        for _, sid in ipairs(G.ScreamAnimIds) do
            if id:find(sid) then return true end
        end
    end
    return false
end

function G.bindChainAnimEvents(chain)
    pcall(function()
        local humanoid = chain:FindFirstChild("Humanoid")
        if not humanoid then return end

        humanoid.AnimationPlayed:Connect(function(track)
            pcall(function()
                if not G.CapturedThisLife then return end
                local char = G.LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local chainHrp = chain:FindFirstChild("HumanoidRootPart")
                if not chainHrp then return end
                local dist = (hrp.Position - chainHrp.Position).Magnitude
                if dist > G.DetectRange then return end
                local anim = track.Animation
                if not anim then return end
                local id = tostring(anim.AnimationId)
                if G.checkAnimId(id) then
                    G.AttemptDodge()
                end
            end)
        end)
    end)
end

G.RunService.Heartbeat:Connect(function()
    pcall(function()
        local chain = G.getChain()
        if chain and chain ~= G.boundChain then
            G.boundChain = chain
            G.bindChainAnimEvents(chain)
        end

        if not G.ChokeEnabled and not G.ScreamEnabled then return end
        if not G.CapturedThisLife then return end

        local char = G.LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if not chain then return end

        local chainHrp = chain:FindFirstChild("HumanoidRootPart")
        local humanoid = chain:FindFirstChild("Humanoid")
        if not chainHrp or not humanoid then return end

        local dist = (hrp.Position - chainHrp.Position).Magnitude
        if dist > G.DetectRange then return end

        local currentTracks = humanoid:GetPlayingAnimationTracks()
        local currentSet = {}

        for i = 1, #currentTracks do
            local track = currentTracks[i]
            local anim = track.Animation
            if anim then
                local id = tostring(anim.AnimationId)
                currentSet[id] = true
                if not G.LastKnownTracks[id] then
                    if G.checkAnimId(id) then
                        G.AttemptDodge()
                    end
                end
            end
        end

        G.LastKnownTracks = currentSet
    end)
end)

Tab:Toggle({
    Title = "自动躲掐脖",
    Desc = "开启后点一次闪避键",
    Value = false,
    Callback = function(state)
        pcall(function()
            G.ChokeEnabled = state
            if state and not G.CTS then G.refreshCTS() end
        end)
    end,
})

Tab:Toggle({
    Title = "自动躲尖叫斩",
    Desc = "开启后点一次闪避键",
    Value = false,
    Callback = function(state)
        pcall(function()
            G.ScreamEnabled = state
            if state and not G.CTS then G.refreshCTS() end
        end)
    end,
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Interact
local capturingInteract = false
local LastInteractArgs
local loop
local swingDelay = 1
local lastFire = 0

local function refreshInteract()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        Interact = char:WaitForChild("CharacterHandler"):WaitForChild("Contents"):WaitForChild("Remotes"):WaitForChild("Interact")
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    pcall(function()
        task.wait(1)
        refreshInteract()
        LastInteractArgs = nil
        if capturingInteract then
            capturingInteract = true
        end
    end)
end)

refreshInteract()

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" and self == Interact then
        local args = {...}
        if capturingInteract and not LastInteractArgs then
            LastInteractArgs = args
        end
    end
    return old(self, ...)
end
setreadonly(mt, true)

Tab:Toggle({
    Title = "无敌",
    Desc = "开启功能后需要点一下qte键，比如斧头、电锯的qte按键",
    Value = false,
    Callback = function(state)
        pcall(function()
            if state then
                capturingInteract = true
                LastInteractArgs = nil
                if loop then
                    loop:Disconnect()
                    loop = nil
                end
                loop = RunService.Heartbeat:Connect(function(dt)
                    pcall(function()
                        if not Interact or not Interact.Parent then
                            refreshInteract()
                        end
                        if Interact and LastInteractArgs and (tick() - lastFire >= 1) then
                            lastFire = tick()
                            Interact:FireServer(unpack(LastInteractArgs))
                        end
                    end)
                end)
            else
                capturingInteract = false
                if loop then
                    loop:Disconnect()
                    loop = nil
                end
            end
        end)
    end
})
local G = {}

G.Players = game:GetService("Players")
G.RunService = game:GetService("RunService")
G.LocalPlayer = G.Players.LocalPlayer

G.Interact = nil
G.capturingInteract = false
G.LastInteractArgs = nil
G.loop = nil
G.lastFire = 0

G.xSawClashLoop = nil

function G.refreshInteract()
    pcall(function()
        local char = G.LocalPlayer.Character
        if not char then return end
        G.Interact = char:WaitForChild("CharacterHandler"):WaitForChild("Contents"):WaitForChild("Remotes"):WaitForChild("Interact")
    end)
end

G.LocalPlayer.CharacterAdded:Connect(function()
    pcall(function()
        task.wait(1)
        G.refreshInteract()
        G.LastInteractArgs = nil
    end)
end)

G.refreshInteract()

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" and self == G.Interact then
        local args = {...}
        if G.capturingInteract and not G.LastInteractArgs then
            G.LastInteractArgs = args
        end
    end
    return old(self, ...)
end
setreadonly(mt, true)

Tab:Toggle({
    Title = "让chain一直减速",
    Desc = "开启功能后需要用一次十字架(开启这个功能就不要开自动挥刀滥用)",
    Value = false,
    Callback = function(state)
        pcall(function()
            if state then
                G.capturingInteract = true
                G.LastInteractArgs = nil
                if G.loop then
                    G.loop:Disconnect()
                    G.loop = nil
                end
                G.loop = G.RunService.Heartbeat:Connect(function()
                    pcall(function()
                        if not G.Interact or not G.Interact.Parent then
                            G.refreshInteract()
                        end
                        if G.Interact and G.LastInteractArgs and (tick() - G.lastFire >= 1) then
                            G.lastFire = tick()
                            G.Interact:FireServer(unpack(G.LastInteractArgs))
                        end
                    end)
                end)
            else
                G.capturingInteract = false
                if G.loop then
                    G.loop:Disconnect()
                    G.loop = nil
                end
            end
        end)
    end,
})

Tab:Toggle({
    Title = "拼刀力量保持100%",
    Value = false,
    Callback = function(state)
        pcall(function()
            if state then
                G.xSawClashLoop = G.RunService.Heartbeat:Connect(function()
                    pcall(function()
                        local char = G.LocalPlayer.Character
                        if char then
                            local stats = char:FindFirstChild("Stats")
                            if stats then
                                local cs = stats:FindFirstChild("ClashStrength")
                                if cs then
                                    cs.Value = 100
                                end
                            end
                        end
                    end)
                end)
            else
                if G.xSawClashLoop then
                    G.xSawClashLoop:Disconnect()
                    G.xSawClashLoop = nil
                end
            end
        end)
    end,
})
local character = game:GetService("Players").LocalPlayer.Character or game:GetService("Players").LocalPlayer.CharacterAdded:Wait()
local interactRemote = character:WaitForChild("CharacterHandler"):WaitForChild("Contents"):WaitForChild("Remotes"):WaitForChild("Interact")

local autoSealEnabled = false

local metatable = getrawmetatable(game)
local oldNamecall = metatable.__namecall
setreadonly(metatable, false)

metatable.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if autoSealEnabled and self == interactRemote and (method == "FireServer" or method == "fireServer") then
        if args[1] == "SpellBookBegin" then
            local currentId = args[3]
            task.spawn(function()
                pcall(function()
                    interactRemote.FireServer(interactRemote, "SpellBookSuccess", nil, currentId)
                end)
            end)
        end
    end
    
    return oldNamecall(self, ...)
end)

setreadonly(metatable, true)

Tab:Toggle({
    Title = "秒封印",
    Value = false,
    Callback = function(state)
        pcall(function()
            autoSealEnabled = state
        end)
    end
})

local Config = {
    Players = game:GetService("Players"),
    InflictTarget = nil,
    capturing = false,
    capturedArgs = nil,
    isLooping = false,
    WEAPONS = {"AK47", "DesertEagle", "DoubleBarrel"},
    mt = getrawmetatable(game),
    old = nil
}

Config.LocalPlayer = Config.Players.LocalPlayer

local Functions = {}

Functions.getWeaponFolder = function()
    local char = workspace:FindFirstChild(Config.LocalPlayer.Name)
    if not char then return nil end
    for _, name in ipairs({"STRG_", "STRG"}) do
        local f = char:FindFirstChild(name)
        if f then return f end
    end
    return nil
end

Functions.hasWeaponEquipped = function()
    local folder = Functions.getWeaponFolder()
    if not folder then return false end
    for _, weaponName in ipairs(Config.WEAPONS) do
        if folder:FindFirstChild(weaponName) then
            return true
        end
    end
    return false
end

Functions.refreshRemote = function()
    local success, remote = pcall(function()
        return game:GetService("ReplicatedStorage"):WaitForChild("GameStuff"):WaitForChild("Remotes"):WaitForChild("InflictTarget")
    end)
    if success then
        Config.InflictTarget = remote
    end
end

Config.LocalPlayer.CharacterAdded:Connect(function()
    pcall(function()
        task.wait(1)
        Functions.refreshRemote()
        Config.capturedArgs = nil
    end)
end)

Functions.refreshRemote()

Config.old = Config.mt.__namecall
setreadonly(Config.mt, false)
Config.mt.__namecall = function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if method == "InvokeServer" and self == Config.InflictTarget then
        if Config.capturing then
            Config.capturedArgs = args
        end
    end

    return Config.old(self, unpack(args))
end
setreadonly(Config.mt, true)

Tab:Toggle({
    Title = "枪械光环",
    Value = false,
    Callback = function(state)
        pcall(function()
            Config.capturing = state

            if state then
                Config.capturedArgs = nil
                Config.isLooping = true

                task.spawn(function()
                    local wasSending = false

                    while Config.isLooping do
                        pcall(function()
                            if not Config.InflictTarget or not Config.InflictTarget.Parent then
                                Functions.refreshRemote()
                            end

                            local equipped = Functions.hasWeaponEquipped()

                            if Config.InflictTarget and Config.capturedArgs and equipped then
                                wasSending = true
                                task.spawn(function()
                                    pcall(function()
                                        Config.InflictTarget:InvokeServer(unpack(Config.capturedArgs))
                                    end)
                                end)
                                task.wait(0.1)
                            else
                                if wasSending and not equipped then
                                    wasSending = false
                                    Config.capturedArgs = nil
                                end
                                task.wait()
                            end
                        end)
                    end
                end)
            else
                Config.isLooping = false
                Config.capturedArgs = nil
            end
        end)
    end
})

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local cachedWeaponTable = nil
local noRecoilHooked = false
local ammoActive = false
local silentAimActive = false
local silentAimHooked = false

local function hookRecoil()
    if noRecoilHooked then return end
    pcall(function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "AKRecoil") then
                for _, fname in ipairs({"AKRecoil", "DeagleRecoil", "M1911Recoil", "DBRecoil", "CamShake1", "Shake"}) do
                    if rawget(v, fname) and type(rawget(v, fname)) == "function" then
                        rawset(v, fname, function() end)
                    end
                end
                noRecoilHooked = true
                break
            end
        end
    end)
end

local function getTarget()
    local misc = Workspace:FindFirstChild("Misc")
    if misc then
        local ai = misc:FindFirstChild("AI")
        if ai then
            local chain = ai:FindFirstChild("CHAIN")
            if chain and chain:FindFirstChild("HumanoidRootPart") then
                local hum = chain:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    return chain.HumanoidRootPart
                end
            end
        end
    end
    return nil
end

local function spawnBeam(p1, p2)
    pcall(function()
        local part1 = Instance.new("Part")
        part1.Anchored = true
        part1.CanCollide = false
        part1.Transparency = 1
        part1.Position = p1
        part1.Parent = Workspace.Terrain

        local part2 = Instance.new("Part")  
        part2.Anchored = true  
        part2.CanCollide = false  
        part2.Transparency = 1  
        part2.Position = p2  
        part2.Parent = Workspace.Terrain  

        local att1 = Instance.new("Attachment")  
        att1.Parent = part1  

        local att2 = Instance.new("Attachment")  
        att2.Parent = part2  

        local beam = Instance.new("Beam")  
        beam.Attachment0 = att1  
        beam.Attachment1 = att2  
        beam.Texture = "rbxassetid://446111271"  
        beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))  
        beam.Width0 = 0.3  
        beam.Width1 = 0.3  
        beam.TextureSpeed = 0  
        beam.LightEmission = 1  
        beam.FaceCamera = true  
        beam.Transparency = NumberSequence.new(0)  
        beam.Parent = Workspace.Terrain  

        local sound = Instance.new("Sound")  
        sound.SoundId = "rbxassetid://5633695679"  
        sound.Volume = 0.3  
        sound.Parent = part1  
        sound:Play()  

        task.spawn(function()  
            task.wait(2)  
            local steps = 30  
            for i = 1, steps do  
                if beam and beam.Parent then  
                    beam.Transparency = NumberSequence.new(i / steps)  
                    task.wait(1 / steps)  
                else  
                    break  
                end  
            end  
            part1:Destroy()  
            part2:Destroy()  
        end)
    end)
end

local function hookSilentAim()
    if silentAimHooked then return end
    pcall(function()
        for _, v in pairs(getgc(true)) do
            if type(v) == "table" and rawget(v, "SimulateProjectile") and type(v.SimulateProjectile) == "function" then
                local origSim = v.SimulateProjectile
                v.SimulateProjectile = function(self, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55)
                    if silentAimActive then
                        local target = getTarget()
                        if target and p48 then
                            local originPos = p48.WorldPosition
                            local newDirs = {}
                            for i = 1, #p47 do
                                newDirs[i] = (target.Position - originPos).Unit
                            end
                            spawnBeam(originPos, target.Position)
                            return origSim(self, p44, p45, p46, newDirs, p48, p49, p50, p51, p52, p53, p54, p55)
                        end
                    end
                    return origSim(self, p44, p45, p46, p47, p48, p49, p50, p51, p52, p53, p54, p55)
                end
                silentAimHooked = true
                break
            end
        end
    end)
end

task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if ammoActive then
                pcall(function()
                    local targetItems = Workspace:FindFirstChild(LocalPlayer.Name):FindFirstChild("Items")
                    if targetItems then
                        local ak = targetItems:FindFirstChild("AK47")
                        if ak then
                            if ak:GetAttribute("Ammo") ~= 20 then ak:SetAttribute("Ammo", 20) end
                            if ak:GetAttribute("Reserve") ~= 999 then ak:SetAttribute("Reserve", 999) end
                        end
                        local db = targetItems:FindFirstChild("DoubleBarrel")
                        if db then
                            if db:GetAttribute("Ammo") ~= 2 then db:SetAttribute("Ammo", 2) end
                            if db:GetAttribute("Reserve") ~= 999 then db:SetAttribute("Reserve", 999) end
                        end
                        local deagle = targetItems:FindFirstChild("Deagle")
                        if deagle then
                            if deagle:GetAttribute("Ammo") ~= 7 then deagle:SetAttribute("Ammo", 7) end
                            if deagle:GetAttribute("Reserve") ~= 999 then deagle:SetAttribute("Reserve", 999) end
                        end
                        local m1911 = targetItems:FindFirstChild("M1911")
                        if m1911 then
                            if m1911:GetAttribute("Reserve") ~= 999 then m1911:SetAttribute("Reserve", 999) end
                        end
                    end
                end)

                if cachedWeaponTable then  
                    pcall(function()  
                        if cachedWeaponTable["AK47"] then  
                            if cachedWeaponTable["AK47"].Ammo ~= 20 then cachedWeaponTable["AK47"].Ammo = 20 end  
                            if cachedWeaponTable["AK47"].Reserve ~= 999 then cachedWeaponTable["AK47"].Reserve = 999 end  
                        end  
                        if cachedWeaponTable["DoubleBarrel"] then  
                            if cachedWeaponTable["DoubleBarrel"].Ammo ~= 2 then cachedWeaponTable["DoubleBarrel"].Ammo = 2 end  
                            if cachedWeaponTable["DoubleBarrel"].Reserve ~= 999 then cachedWeaponTable["DoubleBarrel"].Reserve = 999 end  
                        end  
                        if cachedWeaponTable["Deagle"] then  
                            if cachedWeaponTable["Deagle"].Ammo ~= 7 then cachedWeaponTable["Deagle"].Ammo = 7 end  
                            if cachedWeaponTable["Deagle"].Reserve ~= 999 then cachedWeaponTable["Deagle"].Reserve = 999 end  
                        end  
                        if cachedWeaponTable["M1911"] then  
                            if cachedWeaponTable["M1911"].Reserve ~= 999 then cachedWeaponTable["M1911"].Reserve = 999 end  
                        end  
                    end)  
                end  
            end  
        end)
    end
end)

Tab:Toggle({
    Title = "无限子弹",
    Value = false,
    Callback = function(state)
        pcall(function()
            ammoActive = state
            if ammoActive and not cachedWeaponTable then
                pcall(function()  
                    for _, v in pairs(getgc(true)) do  
                        if typeof(v) == "table" and rawget(v, "AK47") and rawget(v, "DoubleBarrel") then  
                            cachedWeaponTable = v  
                            break  
                        end  
                    end  
                end)
            end
        end)
    end
})

Tab:Toggle({
    Title = "无后坐力",
    Value = false,
    Callback = function(state)
        pcall(function()
            if state then
                hookRecoil()
            end
        end)
    end
})

Tab:Toggle({
    Title = "子弹追踪",
    Value = false,
    Callback = function(state)
        pcall(function()
            silentAimActive = state
            if silentAimActive then
                hookSilentAim()
            end
        end)
    end
})

Tab:Section({Title = "给予物品", TextXAlignment = "Left", TextSize = 18})
Tab:Paragraph({
    Title = "注意事项",
    Desc = "你需要拥有一个物品才能给你物品(任何物品都可以) ‖ 由于chain自己本身的问题，手机端用给予物品时会不能移动，要过个5秒才能正常移动，电脑端一切正常，所以用给予物品时要离chain那个逼远一点，不然几秒钟给你骨灰杨了(如果不建议的话你也可以用键盘脚本来控制移动)",
    Image = "triangle-alert",
    Color = "White",
    ImageSize = 40, 
    ThumbnailSize = 120
})
local G = {}

G.Players = game:GetService("Players")
G.VirtualInputManager = game:GetService("VirtualInputManager")
G.LocalPlayer = G.Players.LocalPlayer
G.autoCrucifixEnabled = false

G.slotIds = { "1","2","3","4","5","6","7","8","9","0" }

G.keyMap = {
    ["1"] = Enum.KeyCode.One,
    ["2"] = Enum.KeyCode.Two,
    ["3"] = Enum.KeyCode.Three,
    ["4"] = Enum.KeyCode.Four,
    ["5"] = Enum.KeyCode.Five,
    ["6"] = Enum.KeyCode.Six,
    ["7"] = Enum.KeyCode.Seven,
    ["8"] = Enum.KeyCode.Eight,
    ["9"] = Enum.KeyCode.Nine,
    ["0"] = Enum.KeyCode.Zero
}

function G.getInventory()
    local pg = G.LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local ig = pg:FindFirstChild("Ingame")
    if not ig then return nil end
    return ig:FindFirstChild("Inventory")
end

function G.equipSlot(slotName)
    pcall(function()
        local key = G.keyMap[slotName]
        if key then
            G.VirtualInputManager:SendKeyEvent(true, key, false, game)
            task.wait(0.05)
            G.VirtualInputManager:SendKeyEvent(false, key, false, game)
        end
    end)
end

function G.isSlotValid(slot)
    if not slot then return false end
    local v = slot:FindFirstChild("Values")
    if not v then return false end
    local n = v:FindFirstChild("ItemName")
    if not n or n.Value == "" then return false end
    local count = v:FindFirstChild("Count")
    if count and count.Value <= 0 then return false end
    return true
end

function G.findItemSlot(inventory, itemName)
    for _, slotName in ipairs(G.slotIds) do
        local slot = inventory:FindFirstChild(slotName)
        if slot and G.isSlotValid(slot) then
            local v = slot:FindFirstChild("Values")
            local n = v:FindFirstChild("ItemName")
            if n and n.Value == itemName then
                return slotName
            end
        end
    end
    return nil
end

function G.findEmptySlot(inventory)
    for _, slotName in ipairs(G.slotIds) do
        local slot = inventory:FindFirstChild(slotName)
        if not slot or not G.isSlotValid(slot) then
            return slotName
        end
    end
    return nil
end

function G.giveItem(itemName, itemImage)
    pcall(function()
        local inventory = G.getInventory()
        if not inventory then return end

        local existing = G.findItemSlot(inventory, itemName)
        if existing then
            G.equipSlot(existing)
            vu141:Notify(itemName .. " is already in your inventory!", 3)
            return
        end

        local emptySlot = G.findEmptySlot(inventory)
        if not emptySlot then
            vu141:Notify("No free slots in inventory!", 3)
            return
        end

        local template = nil
        for _, slotName in ipairs(G.slotIds) do
            local slot = inventory:FindFirstChild(slotName)
            if slot and G.isSlotValid(slot) then
                template = slot:Clone()
                break
            end
        end

        if not template then
            vu141:Notify("Item issuance failed!", 3)
            return
        end

        local existing_slot = inventory:FindFirstChild(emptySlot)
        if existing_slot then
            existing_slot:Destroy()
        end

        template.Parent = inventory
        template.Name = emptySlot
        template.Values.ItemName.Value = itemName
        template.Icon.Image = itemImage
        template.Number.Text = emptySlot

        task.wait(0.1)
        G.equipSlot(emptySlot)
        vu141:Notify(itemName .. " added to your inventory!", 3)
    end)
end

Tab:Button({
    Title = "给十字架",
    Callback = function()
        pcall(function()
            G.giveItem("Crucifix", "rbxassetid://15903361925")
        end)
    end,
})

Tab:Toggle({
    Title = "自动给与十字架",
    Default = false,
    Callback = function(Value)
        pcall(function()
            G.autoCrucifixEnabled = Value
        end)
    end,
})

task.spawn(function()
    while true do
        pcall(function()
            task.wait(0.5)
            if G.autoCrucifixEnabled then
                local inventory = G.getInventory()
                if inventory then
                    local found = G.findItemSlot(inventory, "Crucifix")
                    if not found then
                        G.giveItem("Crucifix", "rbxassetid://15903361925")
                    end
                end
            end
        end)
    end
end)

Tab:Button({
    Title = "给双喷",
    Callback = function()
        pcall(function()
            G.giveItem("DoubleBarrel", "rbxassetid://16190395023")
        end)
    end,
})

Tab:Button({
    Title = "给魔法书",
    Callback = function()
        pcall(function()
            G.giveItem("SpellBook", "rbxassetid://15410543290")
        end)
    end,
})

Tab:Button({
    Title = "给ak47",
    Callback = function()
        pcall(function()
            G.giveItem("AK47", "rbxassetid://17812936812")
        end)
    end,
})
local G = {}
G.Players = game:GetService("Players")
G.VirtualInputManager = game:GetService("VirtualInputManager")
G.LocalPlayer = G.Players.LocalPlayer
G.targetItem = "Deagle"
G.targetID = "rbxassetid://15410404828"

G.slotIds = { "1","2","3","4","5","6","7","8","9","0" }
G.keyMap = { ["1"]=Enum.KeyCode.One, ["2"]=Enum.KeyCode.Two, ["3"]=Enum.KeyCode.Three, ["4"]=Enum.KeyCode.Four, ["5"]=Enum.KeyCode.Five, ["6"]=Enum.KeyCode.Six, ["7"]=Enum.KeyCode.Seven, ["8"]=Enum.KeyCode.Eight, ["9"]=Enum.KeyCode.Nine, ["0"]=Enum.KeyCode.Zero }

function G.getInventory()
    local pg = G.LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local ig = pg:FindFirstChild("Ingame")
    if not ig then return nil end
    return ig:FindFirstChild("Inventory")
end

function G.equipSlot(slotName)
    pcall(function()
        local key = G.keyMap[slotName]
        if key then
            G.VirtualInputManager:SendKeyEvent(true, key, false, game)
            task.wait(0.05)
            G.VirtualInputManager:SendKeyEvent(false, key, false, game)
        end
    end)
end

function G.isSlotValid(slot)
    if not slot or not slot:FindFirstChild("Values") or not slot.Values:FindFirstChild("ItemName") then return false end
    if slot.Values.ItemName.Value == "" then return false end
    return true
end

function G.findItemSlot(inventory, itemName)
    for _, slotName in ipairs(G.slotIds) do
        local slot = inventory:FindFirstChild(slotName)
        if slot and G.isSlotValid(slot) and slot.Values.ItemName.Value == itemName then
            return slotName
        end
    end
    return nil
end

function G.findEmptySlot(inventory)
    for _, slotName in ipairs(G.slotIds) do
        local slot = inventory:FindFirstChild(slotName)
        if not slot or not G.isSlotValid(slot) then return slotName end
    end
    return nil
end

function G.giveItem()
    pcall(function()
        local inventory = G.getInventory()
        if not inventory then return end
        
        if G.findItemSlot(inventory, G.targetItem) then return end

        local emptySlot = G.findEmptySlot(inventory)
        local template = nil
        for _, slotName in ipairs(G.slotIds) do
            local s = inventory:FindFirstChild(slotName)
            if s and G.isSlotValid(s) then template = s:Clone(); break end
        end

        if template and emptySlot then
            local old = inventory:FindFirstChild(emptySlot)
            if old then old:Destroy() end
            template.Parent = inventory
            template.Name = emptySlot
            template.Values.ItemName.Value = G.targetItem
            template.Icon.Image = G.targetID
            template.Number.Text = emptySlot
            G.equipSlot(emptySlot)
        end
    end)
end

Tab:Button({
    Title = "给与沙鹰",
    Callback = function()
        pcall(function()
            G.giveItem()
        end)
    end
})

local G = {}

G.BlueprintTab = Window:Tab({
    Title = "蓝图解锁",
    Icon = "file-check",
    Locked = false,
})

G.LocalPlayer = game:GetService("Players").LocalPlayer

function G.unlockBlueprint(attributeName)
    pcall(function()
        local blueprints = G.LocalPlayer:WaitForChild("PlayerStats"):WaitForChild("Blueprints")
        blueprints:SetAttribute(attributeName, true)
    end)
end

G.BlueprintTab:Button({
    Title = "解锁小刀",
    Callback = function()
        pcall(function()
            G.unlockBlueprint("CombatKnife")
        end)
    end,
})

G.BlueprintTab:Button({
    Title = "解锁喷子",
    Callback = function()
        pcall(function()
            G.unlockBlueprint("DoubleBarrel")
        end)
    end,
})

G.BlueprintTab:Button({
    Title = "解锁m1911",
    Callback = function()
        pcall(function()
            G.unlockBlueprint("M1911")
        end)
    end,
})

G.BlueprintTab:Button({
    Title = "解锁马切特",
    Callback = function()
        pcall(function()
            G.unlockBlueprint("Machete")
        end)
    end,
})

G.BlueprintTab:Button({
    Title = "解锁魔法书",
    Callback = function()
        pcall(function()
            G.unlockBlueprint("SpellBook")
        end)
    end,
})

G.BlueprintTab:Button({
    Title = "解锁沙鹰蓝图",
    Callback = function()
        pcall(function()
            G.unlockBlueprint("Deagle")
        end)
    end,
})

G.BlueprintTab:Button({
    Title = "允许你锻造沙鹰手枪",
    Callback = function()
        pcall(function()
            local deagleFrame = G.LocalPlayer.PlayerGui.Ingame.Workbench.MainFrame.Frame.Menu.Blueprints.Deagle
            deagleFrame.Visible = true
        end)
    end,
})

G.BlueprintTab:Button({
    Title = "解锁神器任务",
    Callback = function()
        pcall(function()
            local quests = G.LocalPlayer:WaitForChild("PlayerStats"):WaitForChild("Quests")
            quests:SetAttribute("ArtifactQuest", true)
        end)
    end,
})

local Tab = Window:Tab({
    Title = "传送",
    Icon = "zap",
    Locked = false,
})
local G = {}

G.Players = game:GetService("Players")
G.LocalPlayer = G.Players.LocalPlayer

G.targets = {
    { name = "chain出生地", pos = Vector3.new(-26.879013061523438, -107.01750183105469, -204.7770538330078) },
    { name = "商店",        pos = Vector3.new(-110.85892486572266, -86.33830261230469, 211.8588409423828) },
    { name = "排行榜",      pos = Vector3.new(43.30422592163086, -97.9687728881836, 349.1531982421875) },
    { name = "工作间",      pos = Vector3.new(164.49859619140625, -103.65132141113281, -35.76066207885742) },
    { name = "仓库",        pos = Vector3.new(308.97198486328125, -113.4938735961914, -250.46066284179688) },
    { name = "发电站",      pos = Vector3.new(-203.81826782226562, -110.8906478881836, -108.90457916259766) },
    { name = "收音机站",    pos = Vector3.new(-381.873046875, -115.02182006835938, 42.071022033691406) },
}

function G.getRootPart()
    local char = G.LocalPlayer.Character or G.LocalPlayer.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

function G.teleportTo(pos)
    pcall(function()
        local root = G.getRootPart()
        if root then
            root.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
        end
    end)
end

for _, t in ipairs(G.targets) do
    local pos = t.pos
    Tab:Button({
        Title = t.name,
        Callback = function()
            pcall(function()
                G.teleportTo(pos)
            end)
        end,
    })
end

local Tab = Window:Tab({
    Title = "商店",
    Icon = "store",
    Locked = false,
})
Tab:Button({
    Title = "打开商店界面",
    Desc = "晚上别打开商店买卖东西 不然会被踢",
    Callback = function()
        pcall(function()
            local shopGui = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Ingame"):WaitForChild("Shop")
            shopGui.Visible = true
        end)
    end
})
Tab:Button({
    Title = "解锁商店隐藏物品",
    Desc = "运行了这个功能后你可以在里面买到小刀和喷子 所以你可以不用去制作间做了",
    Callback = function()
        pcall(function()
            local buyFrame = game:GetService("Players").LocalPlayer.PlayerGui.Ingame.Shop.MainFrame.SubSections.BuyFrame
            for _, child in ipairs(buyFrame:GetChildren()) do
                if child:IsA("GuiObject") then
                    if child.Visible ~= true then
                        child.Visible = true
                    end
                end
            end
        end)
    end,
})
local Tab = Window:Tab({
    Title = "设置",
    Icon = "settings",
    Locked = false,
})
local themeValues = {}
for name, _ in pairs(WindUI:GetThemes()) do
    table.insert(themeValues, name)
end

Tab:Dropdown({
    Title = "更改ui颜色",
    Multi = false,
    AllowNone = false,
    Value = nil,
    Values = themeValues,
    Callback = function(theme)
        pcall(function()
            WindUI:SetTheme(theme)
        end)
    end
})
end