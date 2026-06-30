local StarterGui = game:GetService("StarterGui")
StarterGui:SetCore("SendNotification", {
    Title = "Chain",
    Text = "脚本正在加载中",
    Duration = 3
})

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

if not WindUI then
    StarterGui:SetCore("SendNotification", {
        Title = "Chain",
        Text = "脚本加载失败",
        Duration = 5
    })
    return
end

local P = game:GetService("Players")
local RS = game:GetService("RunService")
local L = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local W = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local lp = P.LocalPlayer
local Cam = W.CurrentCamera

local AutoBuy = {}
AutoBuy.Enabled = false
AutoBuy.SelectedItem = "Scrap"
AutoBuy.ItemsList = {
    "AK47", "AKAmmo", "BearTrap", "BlueprintCombatKnife", "BlueprintDoubleBarrel",
    "BlueprintM1911", "BlueprintMachete", "BodyFlashLight", "CombatKnife", "Crucifix",
    "Deagle", "DoubleBarrel", "EMF", "EnergyDrink", "FlareStick",
    "Gas", "Grenade", "JackOMine", "Lantern", "M1911", "Machete",
    "MacheteUpgraded", "Medkit", "Present", "Radio", "Scrap", "StunGrenade",
    "Tablet", "Tomahawk", "Vest", "Watch", "XSaw"
}

AutoBuy.ItemNames = {
    ["AK47"] = "AK47",
    ["AKAmmo"] = "AK弹药",
    ["BearTrap"] = "捕熊夹",
    ["BlueprintCombatKnife"] = "战斗刀蓝图",
    ["BlueprintDoubleBarrel"] = "双管猎枪蓝图",
    ["BlueprintM1911"] = "M1911蓝图",
    ["BlueprintMachete"] = "大砍刀蓝图",
    ["BodyFlashLight"] = "手电筒",
    ["CombatKnife"] = "战斗刀",
    ["Crucifix"] = "十字架",
    ["Deagle"] = "沙漠之鹰",
    ["DoubleBarrel"] = "双管猎枪",
    ["EMF"] = "EMF探测器",
    ["EnergyDrink"] = "能量饮料",
    ["FlareStick"] = "信号棒",
    ["Gas"] = "瓦斯罐",
    ["Grenade"] = "手榴弹",
    ["JackOMine"] = "南瓜雷",
    ["Lantern"] = "灯笼",
    ["M1911"] = "M1911",
    ["Machete"] = "大砍刀",
    ["MacheteUpgraded"] = "升级大砍刀",
    ["Medkit"] = "医疗包",
    ["Present"] = "礼物",
    ["Radio"] = "收音机",
    ["Scrap"] = "废料",
    ["StunGrenade"] = "震撼弹",
    ["Tablet"] = "平板",
    ["Tomahawk"] = "战斧",
    ["Vest"] = "防弹衣",
    ["Watch"] = "手表",
    ["XSaw"] = "X锯"
}

function AutoBuy:SetItem(itemName)
    if table.find(self.ItemsList, itemName) then
        self.SelectedItem = itemName
        return true
    end
    return false
end

function AutoBuy:Start()
    if self.Thread then return end
    
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    self.Thread = task.spawn(function()
        local remote = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Ingame"):WaitForChild("MainUIHandler"):WaitForChild("Remote")
        
        while self.Enabled do
            if self.SelectedItem then
                remote:FireServer("Buy", self.SelectedItem)
            end
            task.wait(1)
        end
    end)
end

function AutoBuy:Stop()
    self.Enabled = false
    if self.Thread then
        task.cancel(self.Thread)
        self.Thread = nil
    end
end

function AutoBuy:Toggle(state)
    self.Enabled = state
    if state then
        self:Start()
    else
        self:Stop()
    end
end

function AutoBuy:GetChineseName(itemName)
    return self.ItemNames[itemName] or itemName
end

local StaffCheck = {}
StaffCheck.Enabled = false
StaffCheck.StaffIds = {
    325976, 51471323, 632886139, 1160588692, 96783330,
    4012679721, 520158435, 121395644, 1517131734
}

function StaffCheck:Start()
    if self.Connection then return end
    
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    for _, player in ipairs(Players:GetPlayers()) do
        if table.find(self.StaffIds, player.UserId) then
            LocalPlayer:Kick("检测到游戏管理员: " .. player.Name .. " 已加入服务器，已自动踢出保护")
            return
        end
    end
    
    self.Connection = Players.PlayerAdded:Connect(function(player)
        if table.find(self.StaffIds, player.UserId) then
            LocalPlayer:Kick("检测到游戏管理员: " .. player.Name .. " 已加入服务器，已自动踢出保护")
        end
    end)
end

function StaffCheck:Stop()
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
end

function StaffCheck:Toggle(state)
    self.Enabled = state
    if state then
        self:Start()
    else
        self:Stop()
    end
end

local function createFakeFolder()
	local fake = {}
	fake.GetChildren = function() return {} end
	fake.GetDescendants = function() return {} end
	fake.FindFirstChild = function() return nil end
	fake.FindFirstChildOfClass = function() return nil end
	fake.FindFirstAncestor = function() return nil end
	fake.GetAttribute = function() return nil end
	fake.GetAttributes = function() return nil end
	fake.IsA = function() return false end
	fake.IsDescendantOf = function() return false end
	fake.IsAncestorOf = function() return false end
	fake.ChildAdded = { Connect = function() return { Disconnect = function() end } end }
	fake.ChildRemoved = { Connect = function() return { Disconnect = function() end } end }
	fake.AncestryChanged = { Connect = function() return { Disconnect = function() end } end }
	return fake
end

local aiFolder = W:FindFirstChild("Misc") and W.Misc:FindFirstChild("AI") or createFakeFolder()
local ScrapFolder = nil
if W:FindFirstChild("Misc") and W.Misc:FindFirstChild("Zones") and W.Misc.Zones:FindFirstChild("LootingItems") then
	ScrapFolder = W.Misc.Zones.LootingItems:FindFirstChild("Scrap")
end
if not ScrapFolder then ScrapFolder = createFakeFolder() end

local MechanicsFrame = nil
if lp:FindFirstChild("PlayerGui") and lp.PlayerGui:FindFirstChild("Ingame") then
	MechanicsFrame = lp.PlayerGui.Ingame:FindFirstChild("MechanicsFrame")
end
if not MechanicsFrame then MechanicsFrame = createFakeFolder() end

local GameSections = W:FindFirstChild("GameStuff") and W.GameStuff:FindFirstChild("GameSections") or createFakeFolder()
local valuesFolder = W:FindFirstChild("GameStuff") and W.GameStuff:FindFirstChild("Values") or createFakeFolder()

local noclipConn = nil
local noclipCache = {}

local function Noclip()
	if State.Noclip then
		if noclipConn then noclipConn:Disconnect() end
		noclipConn = RS.Heartbeat:Connect(function()
			local char = lp.Character
			if not char then return end
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					if noclipCache[part] == nil then
						noclipCache[part] = part.CanCollide
					end
					part.CanCollide = false
				end
			end
		end)
	else
		if noclipConn then
			noclipConn:Disconnect()
			noclipConn = nil
		end
		for part, orig in pairs(noclipCache) do
			if part and part.Parent then
				part.CanCollide = orig
			end
		end
		noclipCache = {}
	end
end

local function isStationElectrified(station)
	local powerStation = station:FindFirstChild("PowerStation")
	if not powerStation then return false end
	local electricZone = powerStation:FindFirstChild("ElectricZone")
	if not electricZone then return false end
	local danger = electricZone:FindFirstChild("Danger")
	if not danger then return false end
	return danger.Transparency < 0.99 and danger.Visible
end

task.spawn(function()
    pcall(function()
        local PlayerStats = lp:FindFirstChild("PlayerStats")
        if not PlayerStats then return end
        local blueprints = PlayerStats:FindFirstChild("Blueprints")
        if not blueprints then return end
        local bpDisplay = {
            CombatKnife = "战斗小刀",
            DoubleBarrel = "双管霰弹枪",
            M1911 = "M1911手枪",
            Machete = "砍刀",
            Deagle = "沙漠之鹰",
        }
        for _, name in ipairs({"CombatKnife", "DoubleBarrel", "M1911", "Machete", "Deagle"}) do
            pcall(function()
                if blueprints:GetAttribute(name) ~= nil then
                    blueprints:SetAttribute(name, true)
                    WindUI:Notify({
                        Title = "蓝图解锁",
                        Content = (bpDisplay[name] or name) .. " 已解锁",
                        Duration = 10,
                        Icon = "check-circle"
                    })
                    task.wait(0.3)
                end
            end)
        end
        
        local pg = lp:FindFirstChild("PlayerGui")
        if not pg then return end
        local ingame = pg:FindFirstChild("Ingame")
        if not ingame then return end
        local wb = nil
        local workbench = ingame:FindFirstChild("Workbench")
        if workbench then
            local mainFrame = workbench:FindFirstChild("MainFrame")
            if mainFrame then
                local frame = mainFrame:FindFirstChild("Frame")
                if frame then
                    local menu = frame:FindFirstChild("Menu")
                    if menu then
                        wb = menu:FindFirstChild("Blueprints")
                    end
                end
            end
        end
        if not wb then return end
        local bpNames = {"Deagle", "CombatKnife", "DoubleBarrel", "M1911", "Machete"}
        
        local function showBlueprints()
            for _, name in ipairs(bpNames) do
                pcall(function()
                    local frame = wb:FindFirstChild(name)
                    if frame then
                        frame.Visible = true
                        local lock = frame:FindFirstChild("LockGradient")
                        if lock then lock.Visible = false end
                    end
                end)
            end
        end
        
        showBlueprints()
        pcall(function()
            wb.DescendantAdded:Connect(function(child)
                task.wait(0.1)
                showBlueprints()
            end)
        end)
    end)
end)

local confirmed = false
local popupSuccess = pcall(function()
    WindUI:Popup({
        Title = "Chain",
        IconThemed = true,
        Content = "全缝合仅私人使用",
        Buttons = {
            {
                Title = "关闭脚本",
                Variant = "Secondary",
                Callback = function() end
            },
            {
                Title = "启动",
                Icon = "check",
                Variant = "Primary",
                Callback = function()
                    confirmed = true
                end
            }
        }
    })
end)

if not popupSuccess then
    warn("Popup 拉取错误，已跳过")
    confirmed = true
end

repeat task.wait() until confirmed

local CTS
local capturingCTS = false
local LastCTSArgs
local dodgeLoop

local hookedRemotes = {}

local function hookFireServer(remote)
    if not remote then return end
    if hookedRemotes[remote] then return end
    pcall(function()
        local oldFire = remote.FireServer
        if type(oldFire) ~= "function" then return end
        remote.FireServer = function(self, ...)
            local args = {...}
            if self == CTS and capturingCTS and not LastCTSArgs then
                LastCTSArgs = args
            elseif self == Interact and capturingInteract and not LastInteractArgs then
                LastInteractArgs = args
            end
            return oldFire(self, ...)
        end
        hookedRemotes[remote] = true
    end)
end

local function refreshCTS()
    pcall(function()
        local char = lp.Character
        if not char then return end
        local mobility = char:FindFirstChild("CharacterMobility")
        if mobility then
            local newCTS = mobility:FindFirstChild("CTS")
            if newCTS and newCTS ~= CTS then
                CTS = newCTS
                hookFireServer(CTS)
            end
        end
    end)
end

lp.CharacterAdded:Connect(function()
    task.wait(1)
    refreshCTS()
    LastCTSArgs = nil
    if capturingCTS then
        capturingCTS = true
    end
end)

refreshCTS()

local Interact
local capturingInteract = false
local LastInteractArgs
local godLoop
local lastFire = 0

local function refreshInteract()
    pcall(function()
        local char = lp.Character
        if not char then return end
        local handler = char:FindFirstChild("CharacterHandler")
        if handler then
            local contents = handler:FindFirstChild("Contents")
            if contents then
                local remotes = contents:FindFirstChild("Remotes")
                if remotes then
                    local newInteract = remotes:FindFirstChild("Interact")
                    if newInteract and newInteract ~= Interact then
                        Interact = newInteract
                        hookFireServer(Interact)
                    end
                end
            end
        end
    end)
end

lp.CharacterAdded:Connect(function()
    task.wait(1)
    refreshInteract()
    LastInteractArgs = nil
    if capturingInteract then
        capturingInteract = true
    end
end)

refreshInteract()


local Window = WindUI:CreateWindow({
	Title = "Chain BK",
	Icon = "rbxassetid://75060495367982",
	IconThemed = false,
	Author = "V3.0 作者:霞沢",
	Folder = "ChainBX",
	Size = UDim2.fromOffset(800, 700),
	Transparent = true,
	Theme = "Dark",
	Background = "rbxassetid://75060495367982",
	BackgroundImageTransparency = 0.5,
	User = {
		Enabled = true,
		Callback = function() end,
		Anonymous = false
	},
	SideBarWidth = 200,
	ScrollBarEnabled = true,
})

Window:SetToggleKey(Enum.KeyCode.T)

local Tabs = {}

Tabs.FuncTab = Window:Tab({
	Title = "功能",
	Icon = "zap"
})

Tabs.VisualTab = Window:Tab({
	Title = "视觉效果",
	Icon = "eye"
})

Tabs.RemoteTab = Window:Tab({
	Title = "远程UI & 快捷键",
	Icon = "monitor"
})

Tabs.TeleportTab = Window:Tab({
	Title = "传送",
	Icon = "map-pin"
})

Tabs.ServerTab = Window:Tab({
	Title = "转服务器",
	Icon = "server"
})

Tabs.AutoBuyTab = Window:Tab({
	Title = "自动购买",
	Icon = "shopping-cart"
})

local TeleportSection = Tabs.TeleportTab:Section({
	Title = "点击传送",
	Opened = true
})

local teleportLocations = {
	{Name = "天上", Pos = Vector3.new(-25.95, 84, 3537.55)},
	{Name = "偏远房子", Pos = Vector3.new(-312.85406494140625, -89.67484283447266, 274.7098388671875)},
	{Name = "仓库", Pos = Vector3.new(316.2673645019531, -117.15931701660156, -216.89208984375)},
	{Name = "小屋", Pos = Vector3.new(158.31149291992188, -94.2305679321289, 206.0210418701172)},
	{Name = "祭坛", Pos = Vector3.new(-34.74468231201172, -106.63446807861328, -182.37461853027344)},
	{Name = "帐篷", Pos = Vector3.new(-196.43980407714844, -97.0508041381836, -230.5570831298828)},
	{Name = "发电站", Pos = Vector3.new(-209.9872589111328, -110.8906478881836, -106.05029296875)},
	{Name = "无线电塔", Pos = Vector3.new(-376.64971923828125, -115.0693359375, 37.89384460449219)},
	{Name = "商店", Pos = Vector3.new(-108.72883605957031, -86.32909393310547, 212.69923400878906)},
	{Name = "工作间", Pos = Vector3.new(161.29835510253906, -103.65132904052734, -19.295833587646484)}
}

for _, loc in ipairs(teleportLocations) do
	TeleportSection:Button({
		Title = loc.Name,
		Callback = function()
			pcall(function()
				local char = lp.Character
				if not char then
					char = lp.CharacterAdded:Wait()
				end
				local hrp = char:FindFirstChild("HumanoidRootPart")
				if not hrp then
					task.wait(1)
					hrp = char:FindFirstChild("HumanoidRootPart")
				end
				if hrp then
					hrp.CFrame = CFrame.new(loc.Pos)
					WindUI:Notify({
						Title = "传送完成",
						Content = "已传送到 " .. loc.Name,
						Duration = 3,
						Icon = "check-circle"
					})
				end
			end)
		end
	})
end

Tabs.SettingsTab = Window:Tab({
	Title = "设置",
	Icon = "settings"
})

Window:SelectTab(1)

local State = {
	AutoQTE = false,
	WinClash = false,
	InfGas = false,
	InfAmmo = false,
	BulletTrack = false,
	BulletTrail = false,
	NoRecoil = false,
	
	InfStamina = false,
	InfCombatStamina = false,
	PseudoGod = false,
	PseudoGodReturnPos = nil,
	Fullbright = false,
	FaceChain = false,
	
	AutoScrap = false,
	ScrapRange = 50,
	ScrapInterval = 6,
	AutoPower = false,
	
	ChainAlert = false,
	ChainDodge = false,
	ChainRing = true,
	ChainRotate = true,
	ChainRingRadius = 55,
	
	SpeedBoost = false,
	SpeedValue = 1,
	ThirdPerson = false,
	ThirdPersonCamLock = false,
	NoFog = false,
	Noclip = false,
	Fly = false,
	FlySpeed = 1,
	
	PlayerESP_Text = true,
	PlayerESP_Box = true,
	PlayerESP_Color = Color3.fromRGB(0, 120, 255),
	
	ChainESP_Text = true,
	ChainESP_Box = true,
	ChainESP_Color = Color3.fromRGB(255, 21, 21),
	
	BuildingESP_Text = true,
	BuildingESP_Box = true,
	BuildingESP_Color = Color3.fromRGB(255, 255, 0),
	
	ScrapESP_Text = true,
	ScrapESP_Box = true,
	ScrapESP_Color = Color3.fromRGB(255, 200, 0),
	
	AirDropESP_Text = true,
	AirDropESP_Box = true,
	AirDropESP_Color = Color3.fromRGB(170, 0, 255),
	
	ArtifactESP_Text = true,
	ArtifactESP_Box = true,
	ArtifactESP_Color = Color3.fromRGB(255, 105, 180),
	
	ServerMonitor = false,
	ServerMonitor_Interval = 30,
	ServerMonitor_MaxServers = 20,
	ServerMonitor_SortBy = "ping",
	ServerMonitor_ShowEmpty = false,
	ServerMonitor_ShowFull = false,
	ServerMonitor_AutoRefresh = true,
	
	PerformanceDisplay = false,
	HUD_Display = true,
	TeleportDelay = 0.2,
	
	AutoDodge = false,
	GodMode = false,
	StaffCheck = false,
}

local RemoteGUIs = { Shop = false, Deconstructor = false, Workbench = false }
local Mouse = lp:GetMouse()

local function UpdateMouseLock()
	local anyActive = RemoteGUIs.Shop or RemoteGUIs.Deconstructor or RemoteGUIs.Workbench
	local uiVisible = Window and Window.Signal and Window.Signal:GetValue()
	if anyActive or uiVisible then
		UIS.MouseBehavior = Enum.MouseBehavior.Default
		UIS.MouseIconEnabled = true
		Mouse.Icon = ""
	end
end

local function isDaytime()
	if not valuesFolder then return true end
	local t = valuesFolder:GetAttribute("RoundTime")
	return not (type(t) == "number" and t > 0)
end

local function SetRemoteGui(name, visible)
	if visible and name == "Shop" and not isDaytime() then
		WindUI:Notify({
			Title = "无法开启",
			Content = "商店只能在白天打开",
			Duration = 3,
			Icon = "xmark"
		})
		return false
	end
	
	RemoteGUIs[name] = visible
	local sg = lp.PlayerGui:FindFirstChild("Ingame")
	if sg then 
		local gui = sg:FindFirstChild(name) 
		if gui then gui.Visible = visible end 
	end
	UpdateMouseLock()
	return true
end

local pseudoGodData = {
	Enabled = false,
	SavedPosition = nil,
	Seat = nil
}

local bullet = { 
	TrackActive = false, 
	TrailActive = false, 
	TrailColor = Color3.fromRGB(0, 120, 255), 
	TrailLinger = 0.5 
}

local function getNearestEnemyPos()
	local char = lp.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp or not aiFolder then return nil end
	local nearDist = math.huge
	local nearPos = nil
	for _, chain in ipairs(aiFolder:GetChildren()) do
		if chain:IsA("Model") then
			local cHRP = chain:FindFirstChild("HumanoidRootPart")
			local cHum = chain:FindFirstChild("Humanoid")
			if cHRP and cHum and cHum.Health > 0 then
				local dist = (hrp.Position - cHRP.Position).Magnitude
				if dist < nearDist then
					nearDist = dist
					nearPos = cHRP.Position
				end
			end
		end
	end
	return nearPos
end

local function createBulletTrail(from, to)
	local linger = bullet.TrailLinger or 0.5
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.Material = Enum.Material.Neon
	part.Color = bullet.TrailColor
	part.Size = Vector3.new(0.05, 0.05, (to - from).Magnitude)
	part.CFrame = CFrame.new(from, to) * CFrame.new(0, 0, -part.Size.Z / 2)
	part.Transparency = 0
	part.Parent = W
	task.spawn(function()
		local steps = 20
		local stepTime = linger / steps
		for i = 1, steps do
			task.wait(stepTime)
			part.Transparency = i / steps
		end
		part:Destroy()
	end)
end

local function setupBulletTrack()
	local success, ProjectileHandler = pcall(function()
		return require(game:GetService("ReplicatedStorage").GameStuff.Modules.ProjectileHandler)
	end)
	
	if not success or not ProjectileHandler or not ProjectileHandler.SimulateProjectile then
		WindUI:Notify({
			Title = "子弹追踪",
			Content = "无法找到ProjectileHandler模块",
			Duration = 3,
			Icon = "xmark"
		})
		return false
	end
	
	local originalSimulate = ProjectileHandler.SimulateProjectile
	local hookFunc = function(self, p135, p136, p137, p138, p139, p140, p141, p142, p143, p144, p145, p146)
		if bullet.TrackActive and p138 and p139 then
			local enemyPos = getNearestEnemyPos()
			if enemyPos then
				local firePos = p139.WorldPosition
				if bullet.TrailActive then
					createBulletTrail(firePos, enemyPos)
				end
				local newDir = (enemyPos - firePos).Unit
				local newDirs = {}
				for i = 1, #p138 do
					newDirs[i] = newDir
				end
				p138 = newDirs
			end
		end
		return originalSimulate(self, p135, p136, p137, p138, p139, p140, p141, p142, p143, p144, p145, p146)
	end
	
	if newcclosure then
		ProjectileHandler.SimulateProjectile = newcclosure(hookFunc)
	else
		ProjectileHandler.SimulateProjectile = hookFunc
	end
	return true
end

local noRecoilData = {
	Hooked = false,
	OriginalFunctions = {},
	TableRef = nil
}

local function hookRecoil()
	if noRecoilData.Hooked then return end
	pcall(function()
		for _, v in pairs(getgc(true)) do
			if type(v) == "table" and rawget(v, "AKRecoil") then
				noRecoilData.TableRef = v
				for _, fname in ipairs({"AKRecoil", "DeagleRecoil", "M1911Recoil", "DBRecoil", "CamShake1", "Shake"}) do
					if rawget(v, fname) and type(rawget(v, fname)) == "function" then
						noRecoilData.OriginalFunctions[fname] = rawget(v, fname)
						rawset(v, fname, function() end)
					end
				end
				noRecoilData.Hooked = true
				break
			end
		end
	end)
end

local function restoreRecoil()
	if not noRecoilData.TableRef then return end
	pcall(function()
		for fname, origFunc in pairs(noRecoilData.OriginalFunctions) do
			rawset(noRecoilData.TableRef, fname, origFunc)
		end
		noRecoilData.OriginalFunctions = {}
		noRecoilData.Hooked = false
		noRecoilData.TableRef = nil
	end)
end

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESP"
ESPFolder.Parent = game:GetService("CoreGui")

local ESPList = {}
local ESP = {}

function ESP:Add(config)
	local entity = config.Entity
	if not entity then return nil end
	
	local part = config.Part
	if not part then
		if entity:IsA("Player") then
			local char = entity.Character
			part = char and char:FindFirstChild("HumanoidRootPart")
		elseif entity:IsA("Model") then
			part = entity:FindFirstChild("HumanoidRootPart") or entity.PrimaryPart
			if not part then part = entity:FindFirstChildWhichIsA("BasePart", true) end
		elseif entity:IsA("BasePart") then
			part = entity
		end
	end
	if not part then return nil end
	
	local cfg = {
		Name = config.Name or entity.Name,
		Color = config.Color or Color3.fromRGB(255, 255, 255),
		Highlight = config.Highlight ~= false,
		Box = config.Box == true,
		Text = config.Text ~= false,
		Distance = config.Distance ~= false,
		Info = config.Info or nil,
		TextSize = config.TextSize or 14,
		AlwaysOnTop = config.AlwaysOnTop ~= false,
		StudsOffset = config.StudsOffset or Vector3.new(0, 3, 0),
		BillboardSize = config.BillboardSize or UDim2.new(0, 200, 0, 40),
	}
	
	local d = {
		Entity = entity, Part = part, Config = cfg, Enabled = true,
		HL = nil, Box = nil, Gui = nil, NL = nil, DL = nil, IL = nil
	}
	
	if cfg.Highlight then
		local hlTarget = entity
		if entity:IsA("Player") and entity.Character then hlTarget = entity.Character end
		pcall(function() 
			local old = hlTarget:FindFirstChildOfClass("Highlight") 
			if old then old:Destroy() end 
		end)
		local hl = Instance.new("Highlight")
		hl.FillColor = cfg.Color
		hl.OutlineColor = cfg.Color
		hl.FillTransparency = 0.6
		hl.OutlineTransparency = 0.1
		if cfg.AlwaysOnTop then hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop end
		hl.Parent = hlTarget
		d.HL = hl
	end

	if Drawing then
		d.Box = Drawing.new("Square")
		d.Box.Thickness = 1
		d.Box.Filled = false
		d.Box.Visible = false
	end

	local ap = part
	if entity:IsA("Player") and entity.Character then
		local hd = entity.Character:FindFirstChild("Head")
		if hd then ap = hd end
	end

	local gui = Instance.new("BillboardGui")
	gui.Size = cfg.BillboardSize
	gui.StudsOffset = cfg.StudsOffset
	gui.AlwaysOnTop = true
	gui.Adornee = ap
	gui.Parent = ESPFolder
	
	local nl = Instance.new("TextLabel")
	nl.Size = UDim2.new(1, 0, 0, cfg.TextSize + 4)
	nl.BackgroundTransparency = 1
	nl.Text = cfg.Name
	nl.TextColor3 = cfg.Color
	nl.TextStrokeTransparency = 0
	nl.TextSize = cfg.TextSize
	nl.Font = Enum.Font.SourceSansBold
	nl.Parent = gui
	
	local dl = Instance.new("TextLabel")
	dl.Size = UDim2.new(1, 0, 0, cfg.TextSize)
	dl.Position = UDim2.new(0, 0, 0, cfg.TextSize + 2)
	dl.BackgroundTransparency = 1
	dl.Text = "0m"
	dl.TextColor3 = cfg.Color
	dl.TextStrokeTransparency = 0
	dl.TextSize = cfg.TextSize - 2
	dl.Font = Enum.Font.SourceSans
	dl.Parent = gui
	
	local il = Instance.new("TextLabel")
	il.Size = UDim2.new(1, 0, 0, cfg.TextSize)
	il.Position = UDim2.new(0, 0, 0, cfg.TextSize * 2 + 2)
	il.BackgroundTransparency = 1
	il.Text = ""
	il.TextColor3 = Color3.new(1, 1, 1)
	il.TextStrokeTransparency = 0
	il.TextSize = cfg.TextSize - 2
	il.Font = Enum.Font.SourceSans
	il.Visible = false
	il.Parent = gui
	
	d.Gui = gui
	d.NL = nl
	d.DL = dl
	d.IL = il
	
	function d:SetText(t) 
		cfg.Name = t 
		if d.NL then d.NL.Text = t end 
	end
	
	function d:SetColor(c)
		cfg.Color = c
		if d.HL then d.HL.FillColor = c; d.HL.OutlineColor = c end
		if d.NL then d.NL.TextColor3 = c end
		if d.DL then d.DL.TextColor3 = c end
		if d.Box then d.Box.Color = c end
	end
	
	function d:SetEnabled(v)
		d.Enabled = v
		if not v then
			if d.HL then d.HL.Enabled = false end
			if d.Gui then d.Gui.Enabled = false end
			if d.Box then d.Box.Visible = false end
		end
	end
	
	function d:SetInfo(t)
		cfg.Info = t
		if d.IL then
			if t and t ~= "" then 
				d.IL.Text = t
				d.IL.Visible = true
			else 
				d.IL.Visible = false 
			end
		end
	end
	
	function d:SetPart(p) d.Part = p end
	function d:SetConfig(key, val) cfg[key] = val end
	function d:Remove()
		if d.HL then pcall(function() d.HL:Destroy() end) end
		if d.Gui then pcall(function() d.Gui:Destroy() end) end
		if d.Box then pcall(function() d.Box:Remove() end) end
		ESPList[d] = nil
	end
	
	ESPList[d] = true
	return d
end

function ESP:RemoveAll()
	for d in pairs(ESPList) do
		if d.HL then pcall(function() d.HL:Destroy() end) end
		if d.Gui then pcall(function() d.Gui:Destroy() end) end
		if d.Box then pcall(function() d.Box:Remove() end) end
		ESPList[d] = nil
	end
end

function ESP:SetColor(c)
	for d in pairs(ESPList) do
		if d.Config then d.Config.Color = c end
		if d.HL then d.HL.FillColor = c; d.HL.OutlineColor = c end
		if d.NL then d.NL.TextColor3 = c end
		if d.DL then d.DL.TextColor3 = c end
		if d.Box then d.Box.Color = c end
	end
end

local espObjects = {
	Players = {},
	Chains = {},
	Buildings = {},
	Scraps = {},
	AirDrops = {},
	Artifacts = {}
}

local function findArtifacts()
	local artifacts = {}
	for _, obj in ipairs(W:GetDescendants()) do
		if obj:IsA("BasePart") or obj:IsA("Model") then
			local name = string.lower(obj.Name)
			if string.find(name, "神器") or string.find(name, "文物") 
			   or string.find(name, "artifact") or string.find(name, "relic") then
				table.insert(artifacts, obj)
			end
		end
	end
	return artifacts
end

RS.RenderStepped:Connect(function()
	Cam = W.CurrentCamera
	local lc = lp.Character
	local lhrp = lc and lc:FindFirstChild("HumanoidRootPart")
	
	local toRemove = {}
	for d in pairs(ESPList) do
		local e = d.Entity
		if not e or not e.Parent then
			table.insert(toRemove, d)
		end
	end
	for _, d in ipairs(toRemove) do
		d:Remove()
	end
	
	if State.ChainESP then
		for _, chain in ipairs(aiFolder:GetChildren()) do
			if chain:IsA("Model") and chain:FindFirstChild("Humanoid") then
				if not espObjects.Chains[chain] then
					local hrp = chain:FindFirstChild("HumanoidRootPart")
					if hrp then
						espObjects.Chains[chain] = ESP:Add({
							Entity = chain,
							Part = hrp,
							Name = chain.Name,
							Color = State.ChainESP_Color,
							Highlight = true,
							Box = true,
							Text = true,
							Distance = true,
							AlwaysOnTop = true,
							StudsOffset = Vector3.new(0, 3.5, 0),
							BillboardSize = UDim2.new(0, 300, 0, 60),
						})
					end
				end
			end
		end
	end
	
	if State.ScrapESP then
		for _, scrap in ipairs(ScrapFolder:GetChildren()) do
			if scrap:IsA("Model") and scrap:GetAttribute("Scrap") then
				local hasPart = false
				for _, descendant in ipairs(scrap:GetDescendants()) do
					if descendant:IsA("BasePart") then
						hasPart = true
						break
					end
				end
				if hasPart and not espObjects.Scraps[scrap] then
					local pivot = scrap:GetPivot()
					local _, bsize = scrap:GetBoundingBox()
					
					local anchorPart = Instance.new("Part")
					anchorPart.Anchored = true
					anchorPart.CanCollide = false
					anchorPart.CanTouch = false
					anchorPart.CanQuery = false
					anchorPart.Transparency = 1
					anchorPart.Size = bsize
					anchorPart.CFrame = pivot
					anchorPart.Parent = W
					
					espObjects.Scraps[scrap] = {
						Obj = ESP:Add({
							Entity = scrap,
							Part = anchorPart,
							Name = "废料",
							Color = State.ScrapESP_Color,
							Highlight = true,
							Box = true,
							Text = true,
							Distance = true,
							AlwaysOnTop = true,
							StudsOffset = Vector3.new(0, 2.5, 0),
						}),
						Part = anchorPart
					}
				end
			end
		end
	end
	
	if State.PlayerESP then
		for _, player in ipairs(P:GetPlayers()) do
			if player ~= lp then
				if not espObjects.Players[player] then
					pcall(function()
						local char = player.Character or player.CharacterAdded:Wait()
						local hrp = char:WaitForChild("HumanoidRootPart", 5)
						if hrp then
							espObjects.Players[player] = ESP:Add({
								Entity = player,
								Part = hrp,
								Name = player.Name,
								Color = State.PlayerESP_Color,
								Highlight = true,
								Box = true,
								Text = true,
								Distance = true,
								AlwaysOnTop = false,
							})
						end
					end)
				end
			end
		end
	end
	
	if State.BuildingESP then
		local buildings = {
			{Name = "发电站", Model = GameSections:FindFirstChild("POWERSTATION")},
			{Name = "仓库", Model = GameSections:FindFirstChild("WAREHOUSE")},
			{Name = "工作区", Model = GameSections:FindFirstChild("WORKSHOP")}
		}
		for _, building in ipairs(buildings) do
			if building.Model and not espObjects.Buildings[building.Model] then
				local pivot = building.Model:GetPivot()
				local _, bsize = building.Model:GetBoundingBox()
				
				local anchorPart = Instance.new("Part")
				anchorPart.Anchored = true
				anchorPart.CanCollide = false
				anchorPart.CanTouch = false
				anchorPart.CanQuery = false
				anchorPart.Transparency = 1
				anchorPart.Size = bsize
				anchorPart.CFrame = pivot
				anchorPart.Parent = W
				
				espObjects.Buildings[building.Model] = {
					Obj = ESP:Add({
						Entity = building.Model,
						Part = anchorPart,
						Name = building.Name,
						Color = State.BuildingESP_Color,
						Highlight = true,
						Box = true,
						Text = true,
						Distance = true,
						AlwaysOnTop = true,
						StudsOffset = Vector3.new(0, 5, 0),
						BillboardSize = UDim2.new(0, 300, 0, 50),
					}),
					Part = anchorPart
				}
			end
		end
	end
	
	if State.AirDropESP then
		local AirDropsFolder = GameSections:FindFirstChild("AirDrops")
		if AirDropsFolder then
			for _, heli in ipairs(AirDropsFolder:GetChildren()) do
				if heli.Name == "AirDropHeli" then
					local airdrop = heli:FindFirstChildWhichIsA("Model", true) or heli
					if not espObjects.AirDrops[airdrop] then
						local hrp = airdrop:FindFirstChild("HumanoidRootPart") or airdrop.PrimaryPart
						if hrp then
							espObjects.AirDrops[airdrop] = ESP:Add({
								Entity = airdrop,
								Part = hrp,
								Name = "空投",
								Color = State.AirDropESP_Color,
								Highlight = true,
								Box = true,
								Text = true,
								Distance = true,
								AlwaysOnTop = true,
								StudsOffset = Vector3.new(0, 5, 0),
							})
						end
					end
				end
			end
		end
	end
	
	for d in pairs(ESPList) do
		local e = d.Entity
		local p = d.Part
		local c = d.Config
		
		if not p or not p.Parent then
			d:SetEnabled(false)
		else
			local alive = true
			if e:IsA("Player") then
				local hum = e.Character and e.Character:FindFirstChild("Humanoid")
				alive = hum and hum.Health > 0
			elseif e:IsA("Model") then
				local hum = e:FindFirstChild("Humanoid")
				if hum then alive = hum.Health > 0 end
			end
			
			if not d.Enabled or not alive then
				d:SetEnabled(false)
			else
				if c.Highlight and not d.HL then
					local hlTarget = e
					if e:IsA("Player") and e.Character then hlTarget = e.Character end
					pcall(function()
						local hl = Instance.new("Highlight")
						hl.FillColor = c.Color
						hl.OutlineColor = c.Color
						hl.FillTransparency = 0.6
						hl.OutlineTransparency = 0.1
						if c.AlwaysOnTop then hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop end
						hl.Parent = hlTarget
						d.HL = hl
					end)
				end
				
				local sp, onScr = Cam:WorldToViewportPoint(p.Position)
				
				if d.NL and d.DL then
					d.NL.Text = c.Name
					d.NL.TextColor3 = c.Color
					d.DL.TextColor3 = c.Color
					
					if c.Distance and lhrp then
						local dist = math.floor((lhrp.Position - p.Position).Magnitude)
						d.DL.Text = tostring(dist) .. "m"
						d.DL.Visible = true
					else
						d.DL.Visible = false
					end
				end
				
				if e:IsA("Model") and e:FindFirstChild("Humanoid") then
					local attrs = e:GetAttributes()
					local infoStr = ""
					if attrs.Anger then infoStr = infoStr .. "怒气:" .. string.format("%.1f", attrs.Anger) .. " " end
					if attrs.ChokeMeter then infoStr = infoStr .. "窒息:" .. string.format("%.1f", attrs.ChokeMeter) .. "% " end
					if attrs.Burst then infoStr = infoStr .. "重击:" .. string.format("%.1f", attrs.Burst) end
					d:SetInfo(infoStr)
				end
				
				if c.Box and d.Box then
					local cf, sz
					local char = e:IsA("Player") and e.Character or e
					
					if e:IsA("Model") and e.Name:lower():find("chain") then
						local hrp = e:FindFirstChild("HumanoidRootPart")
						if hrp then
							cf = hrp.CFrame
							sz = Vector3.new(4, 6, 4)
						end
					elseif char and char:IsA("Model") then
						local okBB, rcf, rsz = pcall(char.GetBoundingBox, char)
						if okBB and rcf then cf, sz = rcf, rsz end
					end
					
					if not cf then cf = p.CFrame; sz = p.Size end
					
					local corners = {
						cf * CFrame.new(-sz.X/2, -sz.Y/2, -sz.Z/2),
						cf * CFrame.new(sz.X/2, -sz.Y/2, -sz.Z/2),
						cf * CFrame.new(sz.X/2, sz.Y/2, -sz.Z/2),
						cf * CFrame.new(-sz.X/2, sz.Y/2, -sz.Z/2),
						cf * CFrame.new(-sz.X/2, -sz.Y/2, sz.Z/2),
						cf * CFrame.new(sz.X/2, -sz.Y/2, sz.Z/2),
						cf * CFrame.new(sz.X/2, sz.Y/2, sz.Z/2),
						cf * CFrame.new(-sz.X/2, sz.Y/2, sz.Z/2),
					}
					
					local x1, y1 = math.huge, math.huge
					local x2, y2 = -math.huge, -math.huge
					local boxVis = false
					
					for _, cn in ipairs(corners) do
						local s, o = Cam:WorldToViewportPoint(cn.Position)
						if o then 
							boxVis = true
							x1 = math.min(x1, s.X)
							y1 = math.min(y1, s.Y)
							x2 = math.max(x2, s.X)
							y2 = math.max(y2, s.Y)
						end
					end
					
					if boxVis then
						d.Box.Position = Vector2.new(x1, y1)
						d.Box.Size = Vector2.new(x2 - x1, y2 - y1)
						d.Box.Color = c.Color
						d.Box.Visible = true
					else
						d.Box.Visible = false
					end
				elseif d.Box then
					d.Box.Visible = false
				end
			end
		end
	end
end)

P.PlayerAdded:Connect(function(player)
	if State.PlayerESP and player ~= lp then
		pcall(function()
			local char = player.Character or player.CharacterAdded:Wait()
			local hrp = char:WaitForChild("HumanoidRootPart", 5)
			if hrp then
				if espObjects.Players[player] then
					espObjects.Players[player]:Remove()
				end
				espObjects.Players[player] = ESP:Add({
					Entity = player,
					Part = hrp,
					Name = player.Name,
					Color = State.PlayerESP_Color,
					Highlight = true,
					Box = true,
					Text = true,
					Distance = true,
					AlwaysOnTop = false,
				})
			end
		end)
	end
end)

P.PlayerRemoving:Connect(function(player)
	if espObjects.Players[player] then
		espObjects.Players[player]:Remove()
		espObjects.Players[player] = nil
	end
end)

local cAlert = { 
	Active = false, 
	Notify = true, 
	Dodge = false, 
	ShowRing = true, 
	RingRotating = true, 
	RingColor = Color3.fromRGB(255, 50, 50),
	RingRadius = 55
}

local chainAlertAnims = {
	["rbxassetid://11545349261"] = "连击1",
	["rbxassetid://14123467583"] = "连击2",
	["rbxassetid://14101304975"] = "连击3",
	["rbxassetid://14101956641"] = "背后攻击",
	["rbxassetid://15943264089"] = "蓄力斩击",
	["rbxassetid://14401168075"] = "蓄力冲锋",
	["rbxassetid://14875631059"] = "范围攻击",
	["rbxassetid://11987922371"] = "闪避",
	["rbxassetid://14255769487"] = "破门",
	["rbxassetid://15408077041"] = "倒地处决1",
	["rbxassetid://15409393739"] = "倒地处决2",
	["rbxassetid://11442109170"] = "警觉",
	["rbxassetid://123029648649398"] = "空洞警觉",
	["rbxassetid://78440647847406"] = "蓄力",
	["rbxassetid://88813113168837"] = "蓄力跳斩",
	["rbxassetid://135099305543293"] = "暴怒",
	["rbxassetid://140464711815827"] = "暴怒反击",
	["rbxassetid://16214202640"] = "突刺",
}

local chainStateAnims = {
	["rbxassetid://11442109170"] = true,
	["rbxassetid://123029648649398"] = true,
	["rbxassetid://135099305543293"] = true,
}

local chainAlertSounds = {
	["CurbStomp1"] = "踩踏反击",
	["CurbStomp2"] = "踩踏反击",
	["Charging"] = "蓄力",
	["ChainsawSwing"] = "电锯挥砍",
	["ChainsawCharge"] = "电锯蓄力",
	["ChainsawSpot"] = "电锯突刺",
	["ChokeSwing"] = "突刺",
}

local chainRings = {}
local chainRingConn = nil
local RING_POINTS = 36
local WALL_HEIGHT = 50
local ringRotAngle = 0
local activeDodgeChains = {}

local function makeRingParts(radius)
	local data = { Balls = {}, Walls = {} }
	
	for i = 1, RING_POINTS do
		local ball = Instance.new("Part")
		ball.Shape = Enum.PartType.Ball
		ball.Size = Vector3.new(0.5, 0.5, 0.5)
		ball.Anchored = true
		ball.CanCollide = false
		ball.Material = Enum.Material.Neon
		ball.Color = cAlert.RingColor
		ball.Transparency = cAlert.ShowRing and 0.3 or 1
		ball.Parent = W
		table.insert(data.Balls, ball)
	end
	
	for i = 1, RING_POINTS do
		local wall = Instance.new("Part")
		wall.Size = Vector3.new(2, WALL_HEIGHT, 1)
		wall.Anchored = true
		wall.CanCollide = false
		wall.Material = Enum.Material.ForceField
		wall.Color = cAlert.RingColor
		wall.Transparency = cAlert.ShowRing and 0.85 or 1
		wall.Parent = W
		table.insert(data.Walls, wall)
	end
	
	return data
end

local function updateRingPositions(ringData, chain, radius)
	local hrp = chain:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	
	local center = hrp.Position
	
	for i, ball in ipairs(ringData.Balls) do
		local angle = (i / RING_POINTS) * math.pi * 2 + ringRotAngle
		ball.Position = Vector3.new(
			center.X + math.cos(angle) * radius,
			center.Y - 2.5,
			center.Z + math.sin(angle) * radius
		)
	end
	
	for i, wall in ipairs(ringData.Walls) do
		local angle = (i / RING_POINTS) * math.pi * 2 + ringRotAngle
		wall.Position = Vector3.new(
			center.X + math.cos(angle) * radius,
			center.Y + WALL_HEIGHT / 2 - 15,
			center.Z + math.sin(angle) * radius
		)
		wall.CFrame = CFrame.new(wall.Position, center)
	end
end

local function clearSingleChainRing(chain)
	for i = #chainRings, 1, -1 do
		local d = chainRings[i]
		if d.Chain == chain then
			for _, p in ipairs(d.Parts.Balls) do pcall(function() p:Destroy() end) end
			for _, p in ipairs(d.Parts.Walls) do pcall(function() p:Destroy() end) end
			table.remove(chainRings, i)
			activeDodgeChains[chain] = nil
			break
		end
	end
end

local function clearChainRings()
	for _, d in ipairs(chainRings) do
		for _, p in ipairs(d.Parts.Balls) do pcall(function() p:Destroy() end) end
		for _, p in ipairs(d.Parts.Walls) do pcall(function() p:Destroy() end) end
	end
	chainRings = {}
	activeDodgeChains = {}
	if chainRingConn then chainRingConn:Disconnect(); chainRingConn = nil end
end

local function createChainRings()
	clearChainRings()
	
	for _, chain in ipairs(aiFolder:GetChildren()) do
		if chain:IsA("Model") then
			table.insert(chainRings, {
				Chain = chain,
				Parts = makeRingParts(cAlert.RingRadius)
			})
		end
	end
	
	ringRotAngle = 0
	chainRingConn = RS.RenderStepped:Connect(function(dt)
		if cAlert.RingRotating then 
			ringRotAngle = ringRotAngle + dt * 0.5 
		end
		
		local toRemove = {}
		for idx, d in ipairs(chainRings) do
			local chain = d.Chain
			if not chain or not chain.Parent then
				table.insert(toRemove, idx)
			else
				updateRingPositions(d.Parts, chain, cAlert.RingRadius)
				
				local hrp = chain:FindFirstChild("HumanoidRootPart")
				if hrp and cAlert.Dodge then
					local myHRP = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
					if myHRP then
						local dist = (myHRP.Position - hrp.Position).Magnitude
						if dist < cAlert.RingRadius then
							local dir = (myHRP.Position - hrp.Position).Unit
							myHRP.CFrame = CFrame.new(hrp.Position + dir * (cAlert.RingRadius + 10))
						end
					end
				end
			end
		end
		
		for i = #toRemove, 1, -1 do 
			local d = chainRings[toRemove[i]]
			for _, p in ipairs(d.Parts.Balls) do pcall(function() p:Destroy() end) end
			for _, p in ipairs(d.Parts.Walls) do pcall(function() p:Destroy() end) end
			table.remove(chainRings, toRemove[i])
		end
	end)
end

local function triggerChainAlert(chain, skillName)
	if cAlert.Notify then
		WindUI:Notify({
			Title = "Chain 预警",
			Content = chain.Name .. " 使用 " .. skillName,
			Duration = 2,
			Icon = "alert-triangle"
		})
	end
	activeDodgeChains[chain] = tick()
	if cAlert.Dodge then
		local myHRP = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
		local chainHRP = chain:FindFirstChild("HumanoidRootPart")
		if myHRP and chainHRP then
			local dir = (myHRP.Position - chainHRP.Position).Unit
			myHRP.CFrame = CFrame.new(chainHRP.Position + dir * (cAlert.RingRadius + 10))
		end
	end
end

local chainAlertConns = {}

local function hookChainAnim(chain)
	if not chain:IsA("Model") then return end
	local isInState = false
	local hum = chain:FindFirstChild("Humanoid")
	local animator = hum and hum:FindFirstChild("Animator")
	if animator then
		table.insert(chainAlertConns, animator.AnimationPlayed:Connect(function(track)
			local animId = track.Animation and track.Animation.AnimationId or ""
			local cleanId = animId:match("%d+")
			local fullId = "rbxassetid://" .. (cleanId or "")
			local skillName = chainAlertAnims[fullId]
			if skillName then
				if chainStateAnims[fullId] then
					isInState = true
					track.Stopped:Connect(function() isInState = false end)
				else
					triggerChainAlert(chain, skillName)
					track.Stopped:Connect(function() activeDodgeChains[chain] = nil end)
				end
			end
		end))
	end
	for _, desc in ipairs(chain:GetDescendants()) do
		if desc:IsA("Sound") and chainAlertSounds[desc.Name] then
			table.insert(chainAlertConns, desc.Played:Connect(function()
				if not isInState then
					triggerChainAlert(chain, chainAlertSounds[desc.Name])
				end
			end))
		end
	end
end

local function setupChainAlert()
	for _, conn in ipairs(chainAlertConns) do conn:Disconnect() end
	chainAlertConns = {}
	clearChainRings()
	
	if cAlert.Active then
		createChainRings()
		for _, chain in ipairs(aiFolder:GetChildren()) do hookChainAnim(chain) end
		table.insert(chainAlertConns, aiFolder.ChildAdded:Connect(function(child)
			hookChainAnim(child)
			if child:IsA("Model") then
				table.insert(chainRings, {
					Chain = child,
					Parts = makeRingParts(cAlert.RingRadius)
				})
			end
		end))
		table.insert(chainAlertConns, aiFolder.ChildRemoved:Connect(function(child)
			clearSingleChainRing(child)
		end))
	end
end

local speedData = { Active = false, Speed = 1, Conn = nil, CharConn = nil }

local function startSpeedBoost()
	if speedData.Conn then speedData.Conn:Disconnect() end
	speedData.Conn = RS.RenderStepped:Connect(function(delta)
		if not speedData.Active then return end
		local char = lp.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildWhichIsA("Humanoid")
		if not hrp or not hum then return end
		if hum.MoveDirection.Magnitude > 0 then
			hrp.CFrame = hrp.CFrame + hum.MoveDirection * speedData.Speed * delta * 20
		end
	end)
end

local function setupSpeedBoost()
	if speedData.CharConn then speedData.CharConn:Disconnect() end
	speedData.CharConn = lp.CharacterAdded:Connect(function(char)
		task.wait(0.5)
		if speedData.Active then startSpeedBoost() end
	end)
	if speedData.Active then startSpeedBoost() end
end

local tp3 = { Active = false, CamLock = false, CamLockConn = nil, Conn = nil, CharConn = nil, SavedMax = nil, SavedMin = nil }

local function enforceThirdPerson()
	if tp3.Conn then tp3.Conn:Disconnect() end
	tp3.Conn = RS.RenderStepped:Connect(function()
		if not tp3.Active then return end
		pcall(function()
			if lp.CameraMode ~= Enum.CameraMode.Classic then lp.CameraMode = Enum.CameraMode.Classic end
			if lp.CameraMaxZoomDistance ~= 20 then lp.CameraMaxZoomDistance = 20 end
			if lp.CameraMinZoomDistance ~= 5 then lp.CameraMinZoomDistance = 5 end
		end)
	end)
	if tp3.CharConn then tp3.CharConn:Disconnect() end
	tp3.CharConn = lp.CharacterAdded:Connect(function(char)
		task.wait(0.5)
		if tp3.Active then
			pcall(function()
				lp.CameraMode = Enum.CameraMode.Classic
				lp.CameraMaxZoomDistance = 20
				lp.CameraMinZoomDistance = 5
			end)
		end
	end)
end

local function updateCameraLock()
	if tp3.CamLockConn then tp3.CamLockConn:Disconnect(); tp3.CamLockConn = nil end
	if tp3.Active and tp3.CamLock then
		tp3.CamLockConn = RS.RenderStepped:Connect(function()
			local char = lp.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hrp then
				local camCF = Cam.CFrame
				local lookDir = camCF.LookVector
				hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + Vector3.new(lookDir.X, 0, lookDir.Z))
			end
		end)
	end
end

local nofogConns = {}
local nofogSaved = {}
local fullbrightConn = nil
local fullbrightSaved = nil

local HUD = Instance.new("ScreenGui")
HUD.Name = "StatusHUD"
HUD.ResetOnSpawn = false
HUD.IgnoreGuiInset = true
HUD.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 180, 0, 75)
Frame.Position = UDim2.new(1, -190, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.7
Frame.BorderSizePixel = 0
Frame.Parent = HUD

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 6)
Corner.Parent = Frame

local TimeLabel = Instance.new("TextLabel")
TimeLabel.Size = UDim2.new(1, -15, 0, 22)
TimeLabel.Position = UDim2.new(0, 10, 0, 5)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "时间: 加载中..."
TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimeLabel.TextStrokeTransparency = 0.5
TimeLabel.TextSize = 13
TimeLabel.Font = Enum.Font.SourceSansBold
TimeLabel.TextXAlignment = Enum.TextXAlignment.Left
TimeLabel.Parent = Frame

local PowerLabel = Instance.new("TextLabel")
PowerLabel.Size = UDim2.new(1, -15, 0, 22)
PowerLabel.Position = UDim2.new(0, 10, 0, 26)
PowerLabel.BackgroundTransparency = 1
PowerLabel.Text = "电力: 加载中..."
PowerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PowerLabel.TextStrokeTransparency = 0.5
PowerLabel.TextSize = 13
PowerLabel.Font = Enum.Font.SourceSansBold
PowerLabel.TextXAlignment = Enum.TextXAlignment.Left
PowerLabel.Parent = Frame

local PseudoLabel = Instance.new("TextLabel")
PseudoLabel.Size = UDim2.new(1, -15, 0, 22)
PseudoLabel.Position = UDim2.new(0, 10, 0, 47)
PseudoLabel.BackgroundTransparency = 1
PseudoLabel.Text = "无敌: 关闭"
PseudoLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
PseudoLabel.TextStrokeTransparency = 0.5
PseudoLabel.TextSize = 13
PseudoLabel.Font = Enum.Font.SourceSansBold
PseudoLabel.TextXAlignment = Enum.TextXAlignment.Left
PseudoLabel.Parent = Frame

local function UpdateHUD()
	if not State.HUD_Display then
		HUD.Enabled = false
		return
	end
	HUD.Enabled = true
	
	pcall(function()
		local t = valuesFolder:GetAttribute("RoundTime")
		local p = valuesFolder:GetAttribute("Power")
		
		if t ~= nil then
			if type(t) == "number" and t > 0 then
				TimeLabel.Text = "时间: " .. tostring(math.floor(t)) .. "s"
				TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			else
				TimeLabel.Text = "时间: 白天"
				TimeLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
			end
		else
			TimeLabel.Text = "时间: 未知"
			TimeLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		end
		
		if p ~= nil then
			if type(p) == "number" then
				PowerLabel.Text = "电力: " .. string.format("%.1f", p) .. "%"
				if p <= 10 then
					PowerLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
				elseif p <= 30 then
					PowerLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
				else
					PowerLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
				end
			else
				PowerLabel.Text = "电力: 未知"
				PowerLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
			end
		else
			PowerLabel.Text = "电力: 未知"
			PowerLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		end
		
		if State.PseudoGod then
			PseudoLabel.Text = "无敌: 开启"
			PseudoLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
		else
			PseudoLabel.Text = "无敌: 关闭"
			PseudoLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
		end
	end)
end

Tabs.VisualTab:Toggle({
    Title = "除雾",
    Value = false,
    Callback = function(v)
        for _, conn in ipairs(nofogConns) do pcall(function() conn:Disconnect() end) end
        nofogConns = {}
        
        if v then
            nofogSaved.FogEnd = L.FogEnd
            nofogSaved.Atmospheres = {}
            L.FogEnd = 100000
            
            table.insert(nofogConns, L:GetPropertyChangedSignal("FogEnd"):Connect(function()
                L.FogEnd = 100000
            end))
            
            for _, atm in ipairs(L:GetDescendants()) do
                if atm:IsA("Atmosphere") then
                    nofogSaved.Atmospheres[atm] = atm.Density
                    atm.Density = 0
                    table.insert(nofogConns, atm:GetPropertyChangedSignal("Density"):Connect(function()
                        atm.Density = 0
                    end))
                end
            end
            
            table.insert(nofogConns, L.DescendantAdded:Connect(function(v)
                if v:IsA("Atmosphere") then
                    nofogSaved.Atmospheres[v] = v.Density
                    v.Density = 0
                    table.insert(nofogConns, v:GetPropertyChangedSignal("Density"):Connect(function()
                        v.Density = 0
                    end))
                end
            end))
        else
            if nofogSaved.FogEnd then L.FogEnd = nofogSaved.FogEnd end
            for atm, density in pairs(nofogSaved.Atmospheres or {}) do
                pcall(function() atm.Density = density end)
            end
            nofogSaved = {}
        end
    end,
})

Tabs.VisualTab:Toggle({
    Title = "高亮",
    Value = false,
    Callback = function(v)
        if fullbrightConn then pcall(function() fullbrightConn:Disconnect() end) fullbrightConn = nil end
        
        if v then
            fullbrightSaved = {
                Brightness = L.Brightness,
                ClockTime = L.ClockTime,
                FogEnd = L.FogEnd,
                GlobalShadows = L.GlobalShadows,
                OutdoorAmbient = L.OutdoorAmbient,
            }
            
            local function fb()
                L.Brightness = 2
                L.ClockTime = 14
                L.FogEnd = 100000
                L.GlobalShadows = false
                L.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            end
            
            fb()
            fullbrightConn = RS.RenderStepped:Connect(fb)
        else
            if fullbrightSaved then
                L.Brightness = fullbrightSaved.Brightness
                L.ClockTime = fullbrightSaved.ClockTime
                L.FogEnd = fullbrightSaved.FogEnd
                L.GlobalShadows = fullbrightSaved.GlobalShadows
                L.OutdoorAmbient = fullbrightSaved.OutdoorAmbient
                fullbrightSaved = nil
            end
        end
    end,
})

Tabs.VisualTab:Toggle({
    Title = "显示聊天框",
    Value = false,
    Callback = function(v)
        State.ForceChat = v
        if v then
            pcall(function()
                local TextChatService = game:GetService("TextChatService")
                local ok, chatWinCfg = pcall(function()
                    return TextChatService.ChatWindowConfiguration
                end)
                
                if ok and chatWinCfg then
                    chatWinCfg.Enabled = true
                    WindUI:Notify({
                        Title = "聊天框已启用",
                        Content = "聊天窗口已强制显示",
                        Duration = 3,
                        Icon = "check-circle"
                    })
                else
                    WindUI:Notify({
                        Title = "聊天框启用失败",
                        Content = "请确保聊天类型是 TextChatService",
                        Duration = 3,
                        Icon = "alert-triangle"
                    })
                end
            end)
        end
    end,
})

Tabs.VisualTab:Section({ Title = "ESP 颜色设置" })

Tabs.VisualTab:Colorpicker({
    Title = "玩家ESP颜色",
    Default = State.PlayerESP_Color,
    Callback = function(c)
        State.PlayerESP_Color = c
        for _, obj in pairs(espObjects.Players) do
            if obj.SetColor then obj:SetColor(c) end
        end
    end,
})

Tabs.VisualTab:Colorpicker({
    Title = "ChainESP颜色",
    Default = State.ChainESP_Color,
    Callback = function(c)
        State.ChainESP_Color = c
        for _, obj in pairs(espObjects.Chains) do
            if obj.SetColor then obj:SetColor(c) end
        end
    end,
})

Tabs.VisualTab:Colorpicker({
    Title = "建筑ESP颜色",
    Default = State.BuildingESP_Color,
    Callback = function(c)
        State.BuildingESP_Color = c
        for _, data in pairs(espObjects.Buildings) do
            if data.Obj and data.Obj.SetColor then data.Obj:SetColor(c) end
        end
    end,
})

Tabs.VisualTab:Colorpicker({
    Title = "废料ESP颜色",
    Default = State.ScrapESP_Color,
    Callback = function(c)
        State.ScrapESP_Color = c
        for _, data in pairs(espObjects.Scraps) do
            if data.Obj and data.Obj.SetColor then data.Obj:SetColor(c) end
        end
    end,
})

Tabs.VisualTab:Colorpicker({
    Title = "空投ESP颜色",
    Default = State.AirDropESP_Color,
    Callback = function(c)
        State.AirDropESP_Color = c
        for _, obj in pairs(espObjects.AirDrops) do
            if obj.SetColor then obj:SetColor(c) end
        end
    end,
})

Tabs.VisualTab:Colorpicker({
    Title = "神器ESP颜色",
    Default = State.ArtifactESP_Color,
    Callback = function(c)
        State.ArtifactESP_Color = c
        for _, obj in pairs(espObjects.Artifacts) do
            if obj.SetColor then obj:SetColor(c) end
        end
    end,
})

Tabs.VisualTab:Section({ Title = "ESP 透视" })

Tabs.VisualTab:Toggle({
    Title = "玩家 ESP",
    Value = false,
    Callback = function(v)
        State.PlayerESP = v
        if not v then
            for _, obj in pairs(espObjects.Players) do
                if obj.Remove then obj:Remove() end
            end
            espObjects.Players = {}
            return
        end
        
        for _, player in ipairs(P:GetPlayers()) do
            if player ~= lp then
                pcall(function()
                    local char = player.Character or player.CharacterAdded:Wait()
                    local hrp = char:WaitForChild("HumanoidRootPart", 5)
                    if hrp and not espObjects.Players[player] then
                        espObjects.Players[player] = ESP:Add({
                            Entity = player,
                            Part = hrp,
                            Name = player.Name,
                            Color = State.PlayerESP_Color,
                            Highlight = true,
                            Box = true,
                            Text = true,
                            Distance = true,
                            AlwaysOnTop = false,
                        })
                    end
                end)
            end
        end
    end,
})

Tabs.VisualTab:Toggle({
    Title = "Chain ESP",
    Value = false,
    Callback = function(v)
        State.ChainESP = v
        if not v then
            for _, obj in pairs(espObjects.Chains) do
                if obj.Remove then obj:Remove() end
            end
            espObjects.Chains = {}
            return
        end
        
        for _, chain in ipairs(aiFolder:GetChildren()) do
            if chain:IsA("Model") and chain:FindFirstChild("Humanoid") then
                local hrp = chain:FindFirstChild("HumanoidRootPart")
                if hrp then
                    espObjects.Chains[chain] = ESP:Add({
                        Entity = chain,
                        Part = hrp,
                        Name = chain.Name,
                        Color = State.ChainESP_Color,
                        Highlight = true,
                        Box = true,
                        Text = true,
                        Distance = true,
                        AlwaysOnTop = true,
                        StudsOffset = Vector3.new(0, 3.5, 0),
                        BillboardSize = UDim2.new(0, 300, 0, 60),
                    })
                end
            end
        end
    end,
})

Tabs.VisualTab:Toggle({
    Title = "建筑 ESP",
    Value = false,
    Callback = function(v)
        State.BuildingESP = v
        if not v then
            for _, data in pairs(espObjects.Buildings) do
                if data.Obj then data.Obj:Remove() end
                if data.Part then data.Part:Destroy() end
            end
            espObjects.Buildings = {}
            return
        end
        
        local buildings = {
            {Name = "发电站", Model = GameSections:FindFirstChild("POWERSTATION")},
            {Name = "仓库", Model = GameSections:FindFirstChild("WAREHOUSE")},
            {Name = "工作区", Model = GameSections:FindFirstChild("WORKSHOP")}
        }
        for _, building in ipairs(buildings) do
            if building.Model and not espObjects.Buildings[building.Model] then
                local pivot = building.Model:GetPivot()
                local _, bsize = building.Model:GetBoundingBox()
                
                local anchorPart = Instance.new("Part")
                anchorPart.Anchored = true
                anchorPart.CanCollide = false
                anchorPart.CanTouch = false
                anchorPart.CanQuery = false
                anchorPart.Transparency = 1
                anchorPart.Size = bsize
                anchorPart.CFrame = pivot
                anchorPart.Parent = W
                
                espObjects.Buildings[building.Model] = {
                    Obj = ESP:Add({
                        Entity = building.Model,
                        Part = anchorPart,
                        Name = building.Name,
                        Color = State.BuildingESP_Color,
                        Highlight = true,
                        Box = true,
                        Text = true,
                        Distance = true,
                        AlwaysOnTop = true,
                        StudsOffset = Vector3.new(0, 5, 0),
                        BillboardSize = UDim2.new(0, 300, 0, 50),
                    }),
                    Part = anchorPart
                }
            end
        end
    end,
})

Tabs.VisualTab:Toggle({
    Title = "废料 ESP",
    Value = false,
    Callback = function(v)
        State.ScrapESP = v
        if not v then
            for _, data in pairs(espObjects.Scraps) do
                if data.Obj then data.Obj:Remove() end
                if data.Part then data.Part:Destroy() end
            end
            espObjects.Scraps = {}
            return
        end
        
        for _, scrap in ipairs(ScrapFolder:GetChildren()) do
            if scrap:IsA("Model") and scrap:GetAttribute("Scrap") then
                local hasPart = false
                for _, descendant in ipairs(scrap:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        hasPart = true
                        break
                    end
                end
                if hasPart and not espObjects.Scraps[scrap] then
                    local pivot = scrap:GetPivot()
                    local _, bsize = scrap:GetBoundingBox()
                    
                    local anchorPart = Instance.new("Part")
                    anchorPart.Anchored = true
                    anchorPart.CanCollide = false
                    anchorPart.CanTouch = false
                    anchorPart.CanQuery = false
                    anchorPart.Transparency = 1
                    anchorPart.Size = bsize
                    anchorPart.CFrame = pivot
                    anchorPart.Parent = W
                    
                    espObjects.Scraps[scrap] = {
                        Obj = ESP:Add({
                            Entity = scrap,
                            Part = anchorPart,
                            Name = "废料",
                            Color = State.ScrapESP_Color,
                            Highlight = true,
                            Box = true,
                            Text = true,
                            Distance = true,
                            AlwaysOnTop = true,
                            StudsOffset = Vector3.new(0, 2.5, 0),
                        }),
                        Part = anchorPart
                    }
                end
            end
        end
    end,
})

Tabs.VisualTab:Toggle({
    Title = "空投 ESP",
    Value = false,
    Callback = function(v)
        State.AirDropESP = v
        if not v then
            for _, obj in pairs(espObjects.AirDrops) do
                if obj.Remove then obj:Remove() end
            end
            espObjects.AirDrops = {}
            return
        end
        
        local AirDropsFolder = GameSections:FindFirstChild("AirDrops")
        if AirDropsFolder then
            for _, heli in ipairs(AirDropsFolder:GetChildren()) do
                if heli.Name == "AirDropHeli" then
                    local airdrop = heli:FindFirstChildWhichIsA("Model", true) or heli
                    if not espObjects.AirDrops[airdrop] then
                        local hrp = airdrop:FindFirstChild("HumanoidRootPart") or airdrop.PrimaryPart
                        if hrp then
                            espObjects.AirDrops[airdrop] = ESP:Add({
                                Entity = airdrop,
                                Part = hrp,
                                Name = "空投",
                                Color = State.AirDropESP_Color,
                                Highlight = true,
                                Box = true,
                                Text = true,
                                Distance = true,
                                AlwaysOnTop = true,
                                StudsOffset = Vector3.new(0, 5, 0),
                            })
                        end
                    end
                end
            end
        end
    end,
})

Tabs.VisualTab:Section({ Title = "神器/文物 ESP" })

Tabs.VisualTab:Toggle({
    Title = "神器 ESP",
    Value = false,
    Callback = function(v)
        State.ArtifactESP = v
        if v then
            for _, obj in pairs(espObjects.Artifacts) do
                if obj.Remove then obj:Remove() end
            end
            espObjects.Artifacts = {}
            
            local artifacts = findArtifacts()
            for _, artifact in ipairs(artifacts) do
                if not espObjects.Artifacts[artifact] then
                    local part = artifact
                    if artifact:IsA("Model") then
                        part = artifact:FindFirstChildWhichIsA("BasePart", true) or artifact.PrimaryPart
                        if not part then continue end
                    end
                    
                    espObjects.Artifacts[artifact] = ESP:Add({
                        Entity = artifact,
                        Part = part,
                        Name = "神器",
                        Color = State.ArtifactESP_Color,
                        Highlight = true,
                        Box = true,
                        Text = true,
                        Distance = true,
                        AlwaysOnTop = true,
                        StudsOffset = Vector3.new(0, 3, 0),
                        BillboardSize = UDim2.new(0, 200, 0, 50),
                    })
                end
            end
            
            if not espObjects.Artifacts.Connection then
                espObjects.Artifacts.Connection = W.DescendantAdded:Connect(function(obj)
                    if obj:IsA("BasePart") or obj:IsA("Model") then
                        local name = string.lower(obj.Name)
                        if string.find(name, "神器") or string.find(name, "文物") 
                           or string.find(name, "artifact") or string.find(name, "relic") then
                            if not espObjects.Artifacts[obj] then
                                local part = obj
                                if obj:IsA("Model") then
                                    part = obj:FindFirstChildWhichIsA("BasePart", true) or obj.PrimaryPart
                                    if not part then return end
                                end
                                espObjects.Artifacts[obj] = ESP:Add({
                                    Entity = obj,
                                    Part = part,
                                    Name = "神器",
                                    Color = State.ArtifactESP_Color,
                                    Highlight = true,
                                    Box = true,
                                    Text = true,
                                    Distance = true,
                                    AlwaysOnTop = true,
                                    StudsOffset = Vector3.new(0, 3, 0),
                                    BillboardSize = UDim2.new(0, 200, 0, 50),
                                })
                            end
                        end
                    end
                end)
            end
            
            WindUI:Notify({
                Title = "神器ESP",
                Content = "神器 (" .. #artifacts .. " 个)",
                Duration = 2,
                Icon = "check-circle"
            })
        else
            if espObjects.Artifacts.Connection then
                espObjects.Artifacts.Connection:Disconnect()
                espObjects.Artifacts.Connection = nil
            end
            for _, obj in pairs(espObjects.Artifacts) do
                if obj.Remove then obj:Remove() end
            end
            espObjects.Artifacts = {}
        end
    end,
})

local HUDEnabledSection = Tabs.VisualTab:Section({
    Title = "状态显示器",
    Opened = true
})

HUDEnabledSection:Toggle({
    Title = "显示游戏状态",
    Value = true,
    Callback = function(v)
        State.HUD_Display = v
        UpdateHUD()
        WindUI:Notify({
            Title = "状态HUD",
            Content = v and "已开启" or "已关闭",
            Duration = 2,
            Icon = v and "check-circle" or "xmark"
        })
    end,
})

task.spawn(function()
    while true do
        UpdateHUD()
        task.wait(0.5)
    end
end)

local ServerSection = Tabs.ServerTab:Section({
    Title = "转服务器",
    Opened = true
})

local serverMonitorData = {
    servers = {},
    lastUpdate = 0,
    isUpdating = false,
    serverListSection = nil,
    refreshConnection = nil
}

local function getServerListForMonitor()
    local placeId = game.PlaceId
    local servers = {}
    local cursor = ""
    local pageCount = 0
    local maxPages = math.ceil(State.ServerMonitor_MaxServers / 100)
    
    repeat
        local url = string.format(
            "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100&cursor=%s",
            placeId, cursor
        )
        
        local success, response = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        
        if success and response and response.data then
            for _, server in ipairs(response.data) do
                if server.playing >= 0 and 
                   server.playing <= server.maxPlayers and
                   (State.ServerMonitor_ShowEmpty or server.playing > 0) and
                   (State.ServerMonitor_ShowFull or server.playing < server.maxPlayers) then
                    
                    table.insert(servers, {
                        id = server.id,
                        playing = server.playing,
                        maxPlayers = server.maxPlayers,
                        ping = server.ping or 0,
                        fps = server.fps or 0,
                        voteData = server.voteData or {},
                        name = server.name or "Unknown"
                    })
                end
            end
            cursor = response.nextPageCursor
            pageCount = pageCount + 1
        else
            break
        end
    until not cursor or pageCount >= maxPages or #servers >= State.ServerMonitor_MaxServers
    
    if State.ServerMonitor_SortBy == "ping" then
        table.sort(servers, function(a, b)
            return a.ping < b.ping
        end)
    elseif State.ServerMonitor_SortBy == "players" then
        table.sort(servers, function(a, b)
            return a.playing > b.playing
        end)
    elseif State.ServerMonitor_SortBy == "fps" then
        table.sort(servers, function(a, b)
            return a.fps > b.fps
        end)
    end
    
    return servers
end

local function updateServerListDisplay()
    if serverMonitorData.isUpdating then return end
    serverMonitorData.isUpdating = true
    
    WindUI:Notify({
        Title = "服务器监测",
        Content = "正在刷新服务器列表...",
        Duration = 2,
        Icon = "refresh"
    })
    
    serverMonitorData.servers = getServerListForMonitor()
    serverMonitorData.lastUpdate = tick()
    
    if serverMonitorData.serverListSection then
        serverMonitorData.serverListSection:Destroy()
    end
    
    serverMonitorData.serverListSection = Tabs.ServerTab:Section({
        Title = "服务器列表 (" .. #serverMonitorData.servers .. " 个)",
        Opened = true
    })
    
    for i, server in ipairs(serverMonitorData.servers) do
        local pingColor = "Green"
        if server.ping > 150 then
            pingColor = "Red"
        elseif server.ping > 80 then
            pingColor = "Yellow"
        end
        
        serverMonitorData.serverListSection:Paragraph({
            Title = string.format("服务器 #%d", i),
            Desc = string.format("延迟: %dms | 玩家: %d/%d | FPS: %d", 
                server.ping, server.playing, server.maxPlayers, server.fps),
            Color = pingColor,
            Icon = "server"
        })
        
        serverMonitorData.serverListSection:Button({
            Title = string.format("加入服务器 #%d", i),
            Callback = function()
                WindUI:Notify({
                    Title = "正在加入",
                    Content = string.format("延迟: %dms | 玩家: %d/%d", server.ping, server.playing, server.maxPlayers),
                    Duration = 3,
                    Icon = "server"
                })
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, lp)
            end
        })
        
        serverMonitorData.serverListSection:Divider()
    end
    
    serverMonitorData.isUpdating = false
    
    WindUI:Notify({
        Title = "服务器监测",
        Content = "刷新完成，找到 " .. #serverMonitorData.servers .. " 个服务器",
        Duration = 2,
        Icon = "check-circle"
    })
end

local function startAutoRefresh()
    if serverMonitorData.refreshConnection then
        serverMonitorData.refreshConnection:Disconnect()
    end
    
    serverMonitorData.refreshConnection = RS.Heartbeat:Connect(function()
        if not State.ServerMonitor then return end
        if not State.ServerMonitor_AutoRefresh then return end
        
        local currentTime = tick()
        if currentTime - serverMonitorData.lastUpdate >= State.ServerMonitor_Interval then
            updateServerListDisplay()
        end
    end)
end

ServerSection:Toggle({
    Title = "实时服务器监测",
    Value = false,
    Callback = function(v)
        State.ServerMonitor = v
        if v then
            updateServerListDisplay()
            startAutoRefresh()
            WindUI:Notify({
                Title = "服务器监测",
                Content = "已开始实时监测服务器状态",
                Duration = 3,
                Icon = "check-circle"
            })
        else
            if serverMonitorData.serverListSection then
                serverMonitorData.serverListSection:Destroy()
                serverMonitorData.serverListSection = nil
            end
            if serverMonitorData.refreshConnection then
                serverMonitorData.refreshConnection:Disconnect()
                serverMonitorData.refreshConnection = nil
            end
            WindUI:Notify({
                Title = "服务器监测",
                Content = "已停止实时监测",
                Duration = 3,
                Icon = "xmark"
            })
        end
    end,
})

ServerSection:Toggle({
    Title = "自动刷新服务器列表",
    Value = true,
    Callback = function(v)
        State.ServerMonitor_AutoRefresh = v
        if v and State.ServerMonitor then
            startAutoRefresh()
        end
    end,
})

ServerSection:Slider({
    Title = "刷新间隔 (秒)",
    Value = {
        Min = 10,
        Max = 120,
        Default = 30
    },
    Callback = function(v)
        State.ServerMonitor_Interval = v
    end,
})

ServerSection:Slider({
    Title = "显示服务器数量",
    Value = {
        Min = 5,
        Max = 50,
        Default = 20
    },
    Callback = function(v)
        State.ServerMonitor_MaxServers = v
    end,
})

ServerSection:Dropdown({
    Title = "排序方式",
    Multi = false,
    AllowNone = false,
    Value = "ping",
    Values = {"ping", "players", "fps"},
    Callback = function(sortBy)
        State.ServerMonitor_SortBy = sortBy
        if State.ServerMonitor then
            updateServerListDisplay()
        end
    end,
})

ServerSection:Toggle({
    Title = "显示空服务器",
    Value = false,
    Callback = function(v)
        State.ServerMonitor_ShowEmpty = v
        if State.ServerMonitor then
            updateServerListDisplay()
        end
    end,
})

ServerSection:Toggle({
    Title = "显示满服务器",
    Value = false,
    Callback = function(v)
        State.ServerMonitor_ShowFull = v
        if State.ServerMonitor then
            updateServerListDisplay()
        end
    end,
})

ServerSection:Button({
    Title = "立即刷新服务器列表",
    Callback = function()
        updateServerListDisplay()
    end,
})

local AutoPowerSection = Tabs.FuncTab:Section({
    Title = "自动发电机",
    Opened = true
})

AutoPowerSection:Toggle({
    Title = "自动发电机",
    Value = false,
    Callback = function(v)
        State.AutoPower = v
        if v then
            task.spawn(function()
                while State.AutoPower do
                    pcall(function()
                        local power = valuesFolder:GetAttribute("Power")
                        if type(power) == "number" and power <= 0 then
                            local char = lp.Character
                            local hrp = char and char:FindFirstChild("HumanoidRootPart")
                            local station = GameSections:FindFirstChild("POWERSTATION")
                            
                            if hrp and station then
                                local savedCF = hrp.CFrame
                                hrp.CFrame = CFrame.new(-208.299744, -110.604126, -120.227615)
                                task.wait(0.2)
                                
                                local startTime = tick()
                                while State.AutoPower and tick() - startTime < 60 do
                                    local curPower = valuesFolder:GetAttribute("Power")
                                    if type(curPower) == "number" and curPower > 0 then
                                        break
                                    end
                                    
                                    if isStationElectrified(station) then
                                        task.wait(0.5)
                                        continue
                                    end
                                    
                                    local alertUI = station:FindFirstChild("AlertUI")
                                    if alertUI then
                                        local gui = alertUI:FindFirstChild("GUI")
                                        if gui and not gui.Enabled then
                                            local prompt = station:FindFirstChildWhichIsA("ProximityPrompt", true)
                                            if prompt then
                                                fireproximityprompt(prompt)
                                            end
                                        end
                                    end
                                    
                                    task.wait(0.1)
                                end
                                
                                if hrp then
                                    hrp.CFrame = savedCF
                                end
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
        WindUI:Notify({
            Title = "自动发电机",
            Content = v and "已开启" or "已关闭",
            Duration = 2,
            Icon = v and "check" or "xmark"
        })
    end,
})

local AutoScrapSection = Tabs.FuncTab:Section({
    Title = "自动捡废料",
    Opened = true
})

AutoScrapSection:Toggle({
    Title = "自动捡废料",
    Value = false,
    Callback = function(v)
        State.AutoScrap = v
        if v then
            task.spawn(function()
                while State.AutoScrap do
                    pcall(function()
                        local char = lp.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        
                        if hrp then
                            for _, scrap in ipairs(ScrapFolder:GetChildren()) do
                                if scrap:IsA("Model") and scrap:GetAttribute("Scrap") then
                                    local vals = scrap:FindFirstChild("Values")
                                    if vals and vals:GetAttribute("Available") == true then
                                        local hasPart = false
                                        for _, descendant in ipairs(scrap:GetDescendants()) do
                                            if descendant:IsA("BasePart") then
                                                hasPart = true
                                                break
                                            end
                                        end
                                        if hasPart then
                                            local dist = (hrp.Position - scrap:GetPivot().Position).Magnitude
                                            if dist <= State.ScrapRange then
                                                local prompt = scrap:FindFirstChildWhichIsA("ProximityPrompt", true)
                                                if prompt then
                                                    fireproximityprompt(prompt)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(State.ScrapInterval)
                end
            end)
        end
        WindUI:Notify({
            Title = "自动捡废料",
            Content = v and "已开启" or "已关闭",
            Duration = 2,
            Icon = v and "check" or "xmark"
        })
    end,
})

AutoScrapSection:Slider({
    Title = "收集范围",
    Desc = "六秒内不要拾取太多否则会踢",
    Value = {
        Min = 10,
        Max = 200,
        Default = 50
    },
    Callback = function(v)
        State.ScrapRange = v
    end,
})

AutoScrapSection:Slider({
    Title = "收集间隔(秒)",
    Value = {
        Min = 1,
        Max = 6,
        Default = 6
    },
    Callback = function(v)
        State.ScrapInterval = v
    end,
})

Tabs.FuncTab:Section({ Title = "战斗功能" })

Tabs.FuncTab:Toggle({
    Title = "自动 QTE",
    Desc = "可能无效需要自行点击屏幕中间的按钮",
    Value = false,
    Callback = function(v)
        State.AutoQTE = v
        WindUI:Notify({
            Title = "自动 QTE",
            Content = v and "已开启" or "已关闭",
            Duration = 3,
            Icon = v and "alert-triangle" or "xmark"
        })
    end,
})

Tabs.FuncTab:Toggle({
    Title = "拼刀必胜",
    Value = false,
    Callback = function(v)
        State.WinClash = v
    end,
})

Tabs.FuncTab:Toggle({
    Title = "X锯无限燃油",
    Value = false,
    Callback = function(v)
        State.InfGas = v
    end,
})

local InfAmmoToggle = Tabs.FuncTab:Toggle({
    Title = "无限弹药",
    Value = false,
    Callback = function(v)
        State.InfAmmo = v
        toggleInfAmmo()
    end,
})

Tabs.FuncTab:Section({ Title = "子弹" })

Tabs.FuncTab:Toggle({
    Title = "子弹追踪",
    Value = false,
    Callback = function(v)
        State.BulletTrack = v
        bullet.TrackActive = v
        if v then
            setupBulletTrack()
            WindUI:Notify({
                Title = "子弹追踪",
                Content = "已开启",
                Duration = 2
            })
        else
            WindUI:Notify({
                Title = "子弹追踪",
                Content = "已关闭",
                Duration = 2
            })
        end
    end,
})

Tabs.FuncTab:Toggle({
    Title = "子弹轨迹",
    Value = false,
    Callback = function(v)
        State.BulletTrail = v
        bullet.TrailActive = v
        WindUI:Notify({
            Title = "子弹轨迹",
            Content = v and "已开启" or "已关闭",
            Duration = 2
        })
    end,
})

Tabs.FuncTab:Section({ Title = "枪械" })

Tabs.FuncTab:Toggle({
    Title = "无后坐力",
    Value = false,
    Callback = function(v)
        State.NoRecoil = v
        if v then
            hookRecoil()
            WindUI:Notify({
                Title = "无后坐力",
                Content = "已开启",
                Duration = 2
            })
        else
            restoreRecoil()
            WindUI:Notify({
                Title = "无后坐力",
                Content = "已关闭",
                Duration = 2
            })
        end
    end,
})

Tabs.FuncTab:Section({ Title = "生存" })

Tabs.FuncTab:Toggle({
    Title = "无限体力",
    Value = false,
    Callback = function(v)
        State.InfStamina = v
    end,
})

Tabs.FuncTab:Toggle({
    Title = "无限战斗体力",
    Value = false,
    Callback = function(v)
        State.InfCombatStamina = v
    end,
})

local PseudoGodToggle = Tabs.FuncTab:Toggle({
    Title = "伪无敌",
    Desc = "开启前请将本体藏在安全的地方",
    Value = false,
    Callback = function(v)
        State.PseudoGod = v
        if v then
            State.ChainDodge = false
            cAlert.Dodge = false
            
            local char = lp.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local torso = char and (char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
            
            if hrp and torso then
                State.PseudoGodReturnPos = hrp.CFrame
                
                local blackGui = Instance.new("ScreenGui")
                blackGui.Name = "_BlackScreen"
                blackGui.IgnoreGuiInset = true
                blackGui.DisplayOrder = 999
                blackGui.Parent = lp.PlayerGui
                
                local blackFrame = Instance.new("Frame")
                blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
                blackFrame.Size = UDim2.new(1, 0, 1, 0)
                blackFrame.BorderSizePixel = 0
                blackFrame.Parent = blackGui
                
                hrp.CFrame = CFrame.new(-25.95, 84, 3537.55)
                task.wait(0.15)
                
                local seat = Instance.new("Seat")
                seat.Name = ""
                seat.Anchored = false
                seat.CanCollide = false
                seat.Transparency = 1
                seat.Position = Vector3.new(95, 84, 37.55)
                seat.Parent = workspace
                
                local weld = Instance.new("Weld")
                weld.Part0 = seat
                weld.Part1 = torso
                weld.Parent = seat
                
                task.wait()
                seat.CFrame = State.PseudoGodReturnPos
                pseudoGodData.Seat = seat
                
                task.wait(0.5)
                blackGui:Destroy()
                
                WindUI:Notify({
                    Title = "伪无敌",
                    Content = "已开启-请确保本体在安全位置",
                    Duration = 4,
                    Icon = "alert-triangle"
                })
            end
        else
            if pseudoGodData.Seat then
                local char = lp.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp and State.PseudoGodReturnPos then
                        local blackGui = Instance.new("ScreenGui")
                        blackGui.Name = "_BlackScreen"
                        blackGui.IgnoreGuiInset = true
                        blackGui.DisplayOrder = 999
                        blackGui.Parent = lp.PlayerGui
                        
                        local blackFrame = Instance.new("Frame")
                        blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
                        blackFrame.Size = UDim2.new(1, 0, 1, 0)
                        blackFrame.BorderSizePixel = 0
                        blackFrame.Parent = blackGui
                        
                        hrp.CFrame = State.PseudoGodReturnPos
                        
                        task.wait(0.5)
                        blackGui:Destroy()
                    end
                end
                pseudoGodData.Seat:Destroy()
                pseudoGodData.Seat = nil
            end
            WindUI:Notify({
                Title = "伪无敌",
                Content = "已关闭",
                Duration = 2,
                Icon = "xmark"
            })
        end
        PseudoGodToggle:SetValue(v)
    end,
})

local moveGodConn = nil
local moveGodTick = 0

Tabs.FuncTab:Toggle({
    Title = "可移动伪无敌",
    Desc = "可以移动和攻击，高频传送躲伤害",
    Value = false,
    Callback = function(v)
        if v then
            if moveGodConn then moveGodConn:Disconnect() end
            moveGodTick = 0
            moveGodConn = RS.Heartbeat:Connect(function(dt)
                moveGodTick = moveGodTick + dt
                if moveGodTick >= 0.3 then
                    moveGodTick = 0
                    pcall(function()
                        local char = lp.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local cur = hrp.CFrame
                            hrp.CFrame = CFrame.new(0, 500, 0)
                            task.wait()
                            hrp.CFrame = cur
                        end
                    end)
                end
            end)
            WindUI:Notify({
                Title = "可移动伪无敌",
                Content = "已开启 - 可正常移动攻击",
                Duration = 3,
                Icon = "check-circle"
            })
        else
            if moveGodConn then
                moveGodConn:Disconnect()
                moveGodConn = nil
            end
            WindUI:Notify({
                Title = "可移动伪无敌",
                Content = "已关闭",
                Duration = 2,
                Icon = "xmark"
            })
        end
    end,
})

Tabs.FuncTab:Toggle({
    Title = "朝向 Chain",
    Value = false,
    Callback = function(v)
        State.FaceChain = v
    end,
})

Tabs.FuncTab:Section({ Title = "速度 & 视野" })

Tabs.FuncTab:Toggle({
    Title = "速度",
    Value = false,
    Callback = function(v)
        State.SpeedBoost = v
        speedData.Active = v
        setupSpeedBoost()
        WindUI:Notify({
            Title = "速度",
            Content = v and "已开启" or "已关闭",
            Duration = 2
        })
    end,
})

Tabs.FuncTab:Slider({
    Title = "速度倍率",
    Value = {
        Min = 0.5,
        Max = 20,
        Default = 1
    },
    Callback = function(v)
        State.SpeedValue = v
        speedData.Speed = v
    end,
})

Tabs.FuncTab:Toggle({
    Title = "第三人称",
    Value = false,
    Callback = function(v)
        State.ThirdPerson = v
        tp3.Active = v
        if v then
            enforceThirdPerson()
        else
            pcall(function()
                lp.CameraMode = Enum.CameraMode.LockFirstPerson
            end)
            if tp3.Conn then tp3.Conn:Disconnect() end
        end
    end,
})

Tabs.FuncTab:Toggle({
    Title = "穿墙",
    Desc = "已失效后续修复",
    Value = false,
    Callback = function(v)
        State.Noclip = v
        Noclip()
        WindUI:Notify({
            Title = "穿墙",
            Content = v and "已开启" or "已关闭",
            Duration = 3,
            Icon = v and "check-circle" or "xmark"
        })
    end,
})

Tabs.FuncTab:Section({ Title = "Chain 预警" })

Tabs.FuncTab:Toggle({
    Title = "启用 Chain 预警",
    Value = false,
    Callback = function(v)
        State.ChainAlert = v
        cAlert.Active = v
        setupChainAlert()
    end,
})

Tabs.FuncTab:Toggle({
    Title = "自动躲避",
    Desc = "有致命bug，无论多远都会传送，请勿常开",
    Value = false,
    Callback = function(v)
        if State.PseudoGod and v then
            WindUI:Notify({
                Title = "无法开启",
                Content = "伪无敌期间无法使用自动躲避",
                Duration = 3,
                Icon = "alert-triangle"
            })
            return
        end
        State.ChainDodge = v
        cAlert.Dodge = v
        WindUI:Notify({
            Title = "自动躲避",
            Content = v and "已开启" or "已关闭",
            Duration = 4,
            Icon = v and "alert-triangle" or "xmark"
        })
    end,
})

Tabs.FuncTab:Toggle({
    Title = "显示光环",
    Value = true,
    Callback = function(v)
        State.ChainRing = v
        cAlert.ShowRing = v
        setupChainAlert()
    end,
})

Tabs.FuncTab:Toggle({
    Title = "旋转光环",
    Value = true,
    Callback = function(v)
        State.ChainRotate = v
        cAlert.RingRotating = v
    end,
})

Tabs.FuncTab:Slider({
    Title = "预警范围大小",
    Value = {
        Min = 30,
        Max = 100,
        Default = 55
    },
    Callback = function(v)
        State.ChainRingRadius = v
        cAlert.RingRadius = v
        setupChainAlert()
    end,
})

Tabs.FuncTab:Section({ Title = "自动闪避与无敌" })

local dodgeToggle = Tabs.FuncTab:Toggle({
    Title = "自动无限闪避",
    Desc = "开启后先放一次闪避",
    Value = false,
    Callback = function(v)
        State.AutoDodge = v
        if v then
            capturingCTS = true
            LastCTSArgs = nil
            if dodgeLoop then dodgeLoop:Disconnect() end
            dodgeLoop = RS.Heartbeat:Connect(function(dt)
                if not CTS or not CTS.Parent then
                    refreshCTS()
                end
                if CTS and LastCTSArgs then
                    if tick() % 0.7 < dt then
                        CTS:FireServer(unpack(LastCTSArgs))
                    end
                end
            end)
        else
            capturingCTS = false
            if dodgeLoop then dodgeLoop:Disconnect(); dodgeLoop = nil end
        end
    end,
})

local godToggle = Tabs.FuncTab:Toggle({
    Title = "无敌",
    Desc = "开启后先空放一次特殊攻击",
    Value = false,
    Callback = function(v)
        State.GodMode = v
        if v then
            capturingInteract = true
            LastInteractArgs = nil
            lastFire = 0
            if godLoop then godLoop:Disconnect() end
            godLoop = RS.Heartbeat:Connect(function(dt)
                if not Interact or not Interact.Parent then
                    refreshInteract()
                end
                if Interact and LastInteractArgs and (tick() - lastFire >= 1) then
                    lastFire = tick()
                    Interact:FireServer(unpack(LastInteractArgs))
                end
            end)
        else
            capturingInteract = false
            if godLoop then godLoop:Disconnect(); godLoop = nil end
        end
    end,
})

-- 员工检测开关
Tabs.FuncTab:Toggle({
    Title = "员工检测保护",
    Value = false,
    Callback = function(v)
        State.StaffCheck = v
        StaffCheck:Toggle(v)
    end,
})

local RemoteSection = Tabs.RemoteTab:Section({
    Title = "远程UI & 快捷键",
    Opened = true
})

RemoteSection:Toggle({
    Title = "商店界面",
    Value = false,
    Callback = function(v)
        if v and not isDaytime() then
            WindUI:Notify({
                Title = "无法开启",
                Content = "商店只能在白天打开",
                Duration = 2,
                Icon = "xmark"
            })
            return
        end
        SetRemoteGui("Shop", v)
    end,
})

RemoteSection:Paragraph({
    Title = "警告",
    Desc = "黑夜不能买商店物品，否则会被踢出游戏",
    Color = "Red"
})

RemoteSection:Keybind({
    Title = "商店快捷键",
    Value = Enum.KeyCode.V,
    Callback = function(v)
        if v and not isDaytime() then
            WindUI:Notify({
                Title = "无法开启",
                Content = "商店只能在白天打开",
                Duration = 2,
                Icon = "xmark"
            })
            return
        end
        SetRemoteGui("Shop", v)
    end,
})

RemoteSection:Toggle({
    Title = "分解机界面",
    Value = false,
    Callback = function(v)
        SetRemoteGui("Deconstructor", v)
    end,
})

RemoteSection:Paragraph({
    Title = "警告",
    Desc = "会吃材料请前往工作间",
    Color = "Red"
})

RemoteSection:Keybind({
    Title = "分解机快捷键",
    Value = Enum.KeyCode.B,
    Callback = function(v)
        SetRemoteGui("Deconstructor", v)
    end,
})

RemoteSection:Toggle({
    Title = "工作台界面",
    Value = false,
    Callback = function(v)
        SetRemoteGui("Workbench", v)
    end,
})

RemoteSection:Paragraph({
    Title = "警告",
    Desc = "会吃材料请前往工作间",
    Color = "Red"
})

RemoteSection:Keybind({
    Title = "工作台快捷键",
    Value = Enum.KeyCode.N,
    Callback = function(v)
        SetRemoteGui("Workbench", v)
    end,
})

RemoteSection:Section({ Title = "伪无敌快捷键" })

RemoteSection:Keybind({
    Title = "伪无敌快捷键",
    Value = Enum.KeyCode.F4,
    Callback = function(v)
        State.PseudoGod = not State.PseudoGod
        if State.PseudoGod then
            State.ChainDodge = false
            cAlert.Dodge = false
            
            local char = lp.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local torso = char and (char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
            
            if hrp and torso then
                State.PseudoGodReturnPos = hrp.CFrame
                
                local blackGui = Instance.new("ScreenGui")
                blackGui.Name = "_BlackScreen"
                blackGui.IgnoreGuiInset = true
                blackGui.DisplayOrder = 999
                blackGui.Parent = lp.PlayerGui
                
                local blackFrame = Instance.new("Frame")
                blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
                blackFrame.Size = UDim2.new(1, 0, 1, 0)
                blackFrame.BorderSizePixel = 0
                blackFrame.Parent = blackGui
                
                hrp.CFrame = CFrame.new(-25.95, 84, 3537.55)
                task.wait(0.15)
                
                local seat = Instance.new("Seat")
                seat.Name = ""
                seat.Anchored = false
                seat.CanCollide = false
                seat.Transparency = 1
                seat.Position = Vector3.new(95, 84, 37.55)
                seat.Parent = workspace
                
                local weld = Instance.new("Weld")
                weld.Part0 = seat
                weld.Part1 = torso
                weld.Parent = seat
                
                task.wait()
                seat.CFrame = State.PseudoGodReturnPos
                pseudoGodData.Seat = seat
                
                task.wait(0.5)
                blackGui:Destroy()
                
                WindUI:Notify({
                    Title = "伪无敌",
                    Content = "已开启",
                    Duration = 2,
                    Icon = "check"
                })
            end
        else
            if pseudoGodData.Seat then
                local char = lp.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp and State.PseudoGodReturnPos then
                        local blackGui = Instance.new("ScreenGui")
                        blackGui.Name = "_BlackScreen"
                        blackGui.IgnoreGuiInset = true
                        blackGui.DisplayOrder = 999
                        blackGui.Parent = lp.PlayerGui
                        
                        local blackFrame = Instance.new("Frame")
                        blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
                        blackFrame.Size = UDim2.new(1, 0, 1, 0)
                        blackFrame.BorderSizePixel = 0
                        blackFrame.Parent = blackGui
                        
                        hrp.CFrame = State.PseudoGodReturnPos
                        
                        task.wait(0.5)
                        blackGui:Destroy()
                    end
                end
                pseudoGodData.Seat:Destroy()
                pseudoGodData.Seat = nil
            end
            WindUI:Notify({
                Title = "伪无敌",
                Content = "已关闭",
                Duration = 2,
                Icon = "xmark"
            })
        end
        PseudoGodToggle:SetValue(State.PseudoGod)
    end,
})

RemoteSection:Section({ Title = "无限子弹快捷键" })

RemoteSection:Keybind({
    Title = "无限子弹快捷键",
    Value = Enum.KeyCode.F5,
    Callback = function(v)
        State.InfAmmo = not State.InfAmmo
        toggleInfAmmo()
        WindUI:Notify({
            Title = "无限弹药",
            Content = State.InfAmmo and "已开启" or "已关闭",
            Duration = 2,
            Icon = State.InfAmmo and "check" or "xmark"
        })
        InfAmmoToggle:SetValue(State.InfAmmo)
    end,
})

RemoteSection:Section({ Title = "特殊功能" })

local bypassAK_original = nil
RemoteSection:Toggle({
    Title = "绕过AK购买徽章",
    Value = false,
    Callback = function(v)
        if v then
            task.spawn(function()
                local BadgeService = game:GetService("BadgeService")
                bypassAK_original = BadgeService.UserHasBadgeAsync
                local old = hookfunction(BadgeService.UserHasBadgeAsync, function(self, userId, badgeId)
                    if badgeId == 1224768178420330 then
                        return true
                    end
                    return bypassAK_original(self, userId, badgeId)
                end)
                WindUI:Notify({
                    Title = "绕过成功",
                    Content = "AK47购买徽章已绕过",
                    Duration = 10,
                    Icon = "check-circle"
                })
            end)
        else
            if bypassAK_original then
                hookfunction(game:GetService("BadgeService").UserHasBadgeAsync, bypassAK_original)
                bypassAK_original = nil
                WindUI:Notify({
                    Title = "绕过关闭",
                    Content = "AK购买徽章绕过已关闭",
                    Duration = 3,
                    Icon = "xmark"
                })
            end
        end
    end,
})

-- 自动购买标签页UI
Tabs.AutoBuyTab:Section({ Title = "自动购买设置" })

Tabs.AutoBuyTab:Dropdown({
    Title = "选择要购买的物品",
    Values = AutoBuy.ItemsList,
    Value = "Scrap",
    Callback = function(v)
        AutoBuy:SetItem(v)
        WindUI:Notify({
            Title = "已选择",
            Content = "物品: " .. AutoBuy:GetChineseName(v),
            Duration = 2
        })
    end,
})

Tabs.AutoBuyTab:Toggle({
    Title = "启用自动购买",
    Value = false,
    Callback = function(v)
        AutoBuy:Toggle(v)
        if v then
            WindUI:Notify({
                Title = "自动购买已开启",
                Content = "正在自动购买: " .. AutoBuy:GetChineseName(AutoBuy.SelectedItem),
                Duration = 3
            })
        else
            WindUI:Notify({
                Title = "自动购买已关闭",
                Duration = 2
            })
        end
    end,
})

Tabs.AutoBuyTab:Button({
    Title = "立即购买一次",
    Callback = function()
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local remote = LocalPlayer.PlayerGui.Ingame.MainUIHandler.Remote
        remote:FireServer("Buy", AutoBuy.SelectedItem)
        WindUI:Notify({
            Title = "购买成功",
            Content = "已购买: " .. AutoBuy:GetChineseName(AutoBuy.SelectedItem),
            Duration = 2
        })
    end,
})

Tabs.AutoBuyTab:Paragraph({
    Title = "提示",
    Desc = "自动购买每1秒执行一次，可能会被反作弊检测",
    Color = "Yellow"
})

local themes = WindUI:GetThemes()
local themeValues = {}
for name in pairs(themes) do table.insert(themeValues, name) end

Tabs.SettingsTab:Dropdown({
    Title = "选择主题",
    Multi = false,
    AllowNone = false,
    Value = WindUI:GetCurrentTheme(),
    Values = themeValues,
    Callback = function(theme)
        WindUI:SetTheme(theme)
    end,
})

Tabs.SettingsTab:Toggle({
    Title = "窗口透明",
    Value = WindUI:GetTransparency(),
    Callback = function(v)
        Window:ToggleTransparency(v)
    end,
})

local infAmmoActive = false
local ammoConns = {}

local gunMax = {
    AK47 = 20,
    Deagle = 7,
    DoubleBarrel = 2,
    M1911 = 7
}

local origSyncFunc = nil

local function setupAmmoHooks()
    for _, c in ipairs(ammoConns) do pcall(function() c:Disconnect() end) end
    ammoConns = {}
    
    local char = lp.Character
    if not char then return end
    
    local items = char:FindFirstChild("Items")
    if not items then return end
    
    local ch = char:FindFirstChild("CharacterHandler")
    if not ch then return end
    
    local remotes = ch:FindFirstChild("Contents") and ch.Contents:FindFirstChild("Remotes")
    if not remotes then return end
    
    local interact = remotes:FindFirstChild("Interact")
    if not interact then return end
    
    local conns = getconnections(interact.OnClientEvent)
    if conns and #conns > 0 then
        local origConn = conns[1]
        origSyncFunc = origConn.Function
        origConn:Disable()
        
        local newConn = interact.OnClientEvent:Connect(function(action, gunName, ammoData)
            if infAmmoActive and action == "Sync" and gunMax[gunName] then
                ammoData = {gunMax[gunName], 999}
            end
            pcall(origSyncFunc, action, gunName, ammoData)
        end)
        table.insert(ammoConns, newConn)
    end
    
    for gunName, maxAmmo in pairs(gunMax) do
        local gun = items:FindFirstChild(gunName)
        if gun then
            local c1 = gun:GetAttributeChangedSignal("Ammo"):Connect(function()
                if not infAmmoActive then return end
                local val = gun:GetAttribute("Ammo")
                if val and val < maxAmmo then
                    gun:SetAttribute("Ammo", maxAmmo)
                end
            end)
            
            local c2 = gun:GetAttributeChangedSignal("Reserve"):Connect(function()
                if not infAmmoActive then return end
                local val = gun:GetAttribute("Reserve")
                if val and val < 999 then
                    gun:SetAttribute("Reserve", 999)
                end
            end)
            
            table.insert(ammoConns, c1)
            table.insert(ammoConns, c2)
            
            gun:SetAttribute("Ammo", maxAmmo)
            gun:SetAttribute("Reserve", 999)
        end
    end

    pcall(function()
        local playerGui = lp:FindFirstChild("PlayerGui")
        local ingame = playerGui and playerGui:FindFirstChild("Ingame")
        local mechanics = ingame and ingame:FindFirstChild("MechanicsFrame")
        local gunUI = mechanics and mechanics:FindFirstChild("GunUI")
        if gunUI then
            local ammoText = gunUI:FindFirstChild("Ammo")
            local reserveText = gunUI:FindFirstChild("AmmoInStore")
            if ammoText then
                local c = ammoText:GetPropertyChangedSignal("Text"):Connect(function()
                    if not infAmmoActive then return end
                    for gunName, maxAmmo in pairs(gunMax) do
                        local gun = items:FindFirstChild(gunName)
                        if gun and gun:GetAttribute("Equipped") then
                            ammoText.Text = tostring(maxAmmo)
                            return
                        end
                    end
                end)
                table.insert(ammoConns, c)
            end
            if reserveText then
                local c = reserveText:GetPropertyChangedSignal("Text"):Connect(function()
                    if not infAmmoActive then return end
                    reserveText.Text = "999"
                end)
                table.insert(ammoConns, c)
            end
        end
    end)
end

local function startInfAmmoLoop()
    task.spawn(function()
        while infAmmoActive do
            pcall(function()
                local char = lp.Character
                local items = char and char:FindFirstChild("Items")
                if items then
                    for gunName, maxAmmo in pairs(gunMax) do
                        local gun = items:FindFirstChild(gunName)
                        if gun then
                            gun:SetAttribute("Ammo", maxAmmo)
                            gun:SetAttribute("Reserve", 999)
                            if origSyncFunc then
                                pcall(origSyncFunc, "Sync", gunName, {maxAmmo, 999})
                            end
                        end
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end

function toggleInfAmmo()
    infAmmoActive = not infAmmoActive
    if infAmmoActive then
        setupAmmoHooks()
        startInfAmmoLoop()
        pcall(function()
            local char = lp.Character
            local items = char and char:FindFirstChild("Items")
            if items then
                for gunName, maxAmmo in pairs(gunMax) do
                    local gun = items:FindFirstChild(gunName)
                    if gun then
                        gun:SetAttribute("Ammo", maxAmmo)
                        gun:SetAttribute("Reserve", 999)
                    end
                end
            end
        end)
    else
        for _, c in ipairs(ammoConns) do pcall(function() c:Disconnect() end) end
        ammoConns = {}
    end
end

task.spawn(function()
    while task.wait(0.1) do
        if State.InfStamina and lp.Character then
            pcall(function()
                lp.Character:FindFirstChild("Stats").Stamina.Value = 100
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if State.InfCombatStamina and lp.Character then
            pcall(function()
                lp.Character:FindFirstChild("Stats").CombatStamina.Value = 100
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if State.InfGas and lp.Character then
            pcall(function()
                local XSaw = lp.Character:FindFirstChild("Items") and lp.Character.Items:FindFirstChild("XSaw")
                if XSaw then
                    XSaw:SetAttribute("Gas", 100)
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.005) do
        if State.WinClash and lp.Character then
            pcall(function()
                lp.Character:FindFirstChild("Stats").ClashStrength.Value = 100
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.03) do
        if State.FaceChain then
            pcall(function()
                local nearest, nearDist = nil, math.huge
                for _, chain in ipairs(aiFolder:GetChildren()) do
                    if chain:IsA("Model") then
                        local cHRP = chain:FindFirstChild("HumanoidRootPart")
                        local cHum = chain:FindFirstChild("Humanoid")
                        if cHRP and cHum and cHum.Health > 0 then
                            local dist = (Cam.CFrame.Position - cHRP.Position).Magnitude
                            if dist < nearDist then
                                nearDist = dist
                                nearest = cHRP
                            end
                        end
                    end
                end
                if nearest then
                    Cam.CFrame = CFrame.lookAt(Cam.CFrame.Position, nearest.Position)
                end
            end)
        end
    end
end)

lp.CharacterAdded:Connect(function()
    if infAmmoActive then
        task.wait(1)
        setupAmmoHooks()
    end
    if State.NoRecoil then
        task.wait(1)
        hookRecoil()
    end
end)

WindUI:Notify({
    Title = "Chain已加载",
    Content = "Chain V3.0",
    Duration = 5,
    Icon = "check-circle",
})


