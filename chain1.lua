-- ========== WindUI 主窗口 ==========
local Window = WindUI:CreateWindow({
    Title = "NeverLose",
    Icon = "rbxassetid://129260712070622",
    IconThemed = true,
    Author = "NeverLose Script",
    Folder = "NeverLoseConfig",
    Size = UDim2.fromOffset(620, 500),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 180,
    ScrollBarEnabled = true,
})

-- 标题栏按钮
Window:CreateTopbarButton("NeverLose", "shield", function() end, 999)

-- 编辑呼出按钮样式
Window:EditOpenButton({
    Title = "NeverLose",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
    Draggable = true,
})

-- ========== 创建所有标签页 ==========
local VisualTab = Window:Tab({ Title = "视觉", Icon = "eye" })
local PlayerTab = Window:Tab({ Title = "玩家", Icon = "person" })
local WeaponTab = Window:Tab({ Title = "武器", Icon = "sword" })
local WorldTab = Window:Tab({ Title = "世界", Icon = "globe" })
local MiscTab = Window:Tab({ Title = "其他", Icon = "settings" })
local ConfigTab = Window:Tab({ Title = "配置", Icon = "file-cog" })

-- ============================================
-- 视觉标签页 - 左侧（玩家 & Chain）
-- ============================================
local VisualLeft = VisualTab:Section({ Title = "玩家 & Chain", Icon = "users" })

-- ---------- 玩家 ESP ----------
VisualLeft:Toggle({
    Title = "玩家 ESP",
    Desc = "显示其他玩家的位置信息",
    Value = false,
    Callback = function(value)
        PlayerESPSettings.Enabled = value
        if value then
            for _, player in ipairs(P:GetPlayers()) do
                if player ~= lp then SetupPlayerESP(player) end
            end
        else
            for player, obj in pairs(PlayerESPObjs) do obj:Remove() end
            table.clear(PlayerESPObjs)
        end
    end
})

VisualLeft:Colorpicker({
    Title = "玩家颜色",
    Default = Color3.fromRGB(0, 120, 255),
    Callback = function(color)
        PlayerESPSettings.Color = color
        for _, obj in pairs(PlayerESPObjs) do obj:SetColor(color) end
    end
})

-- 玩家子选项（使用 Paragraph 包装多个控件）
local PlayerSub = VisualLeft:Paragraph({
    Title = "玩家 ESP 选项",
    Image = "settings",
})

PlayerSub:Toggle({ Title = "高亮", Value = true, Callback = function(v) PlayerESPSettings.Highlight = v; UpdateAllPlayerESP("Highlight", v) end })
PlayerSub:Toggle({ Title = "方框", Value = true, Callback = function(v) PlayerESPSettings.Box = v; UpdateAllPlayerESP("Box", v) end })
PlayerSub:Toggle({ Title = "名称", Value = true, Callback = function(v) PlayerESPSettings.Text = v; UpdateAllPlayerESP("Text", v) end })
PlayerSub:Toggle({ Title = "距离", Value = true, Callback = function(v) PlayerESPSettings.Distance = v; UpdateAllPlayerESP("Distance", v) end })
PlayerSub:Toggle({ Title = "线条", Value = false, Callback = function(v) PlayerESPSettings.Line = v; UpdateAllPlayerESP("Line", v) end })
PlayerSub:Slider({ Title = "文字大小", Value = { Min = 8, Max = 24, Default = 14 }, Callback = function(v) PlayerESPSettings.TextSize = v; UpdateAllPlayerESP("TextSize", v) end })

VisualLeft:Divider()

-- ---------- Chain ESP ----------
VisualLeft:Toggle({
    Title = "Chain ESP",
    Desc = "显示怪物的位置信息",
    Value = false,
    Callback = function(value)
        ChainESPSettings.Enabled = value
        if value then
            for _, c in ipairs(aiFolder:GetChildren()) do
                if c:IsA("Model") and c:FindFirstChild("Humanoid") then
                    CreateChainESP(c)
                end
            end
        else
            for entity, obj in pairs(ChainESPObjs) do obj:Remove() end
            table.clear(ChainESPObjs)
        end
    end
})

VisualLeft:Colorpicker({
    Title = "Chain 颜色",
    Default = Color3.fromRGB(255, 21, 21),
    Callback = function(color)
        ChainESPSettings.Color = color
        for _, obj in pairs(ChainESPObjs) do obj:SetColor(color) end
    end
})

local ChainSub = VisualLeft:Paragraph({ Title = "Chain ESP 选项", Image = "settings" })

ChainSub:Toggle({ Title = "高亮", Value = true, Callback = function(v) ChainESPSettings.Highlight = v; UpdateAllChainESP("Highlight", v) end })
ChainSub:Toggle({ Title = "方框", Value = true, Callback = function(v) ChainESPSettings.Box = v; UpdateAllChainESP("Box", v) end })
ChainSub:Toggle({ Title = "名称", Value = true, Callback = function(v) ChainESPSettings.Text = v; UpdateAllChainESP("Text", v) end })
ChainSub:Toggle({ Title = "距离", Value = true, Callback = function(v) ChainESPSettings.Distance = v; UpdateAllChainESP("Distance", v) end })
ChainSub:Toggle({ Title = "线条", Value = true, Callback = function(v) ChainESPSettings.Line = v; UpdateAllChainESP("Line", v) end })
ChainSub:Toggle({ Title = "信息显示", Value = true, Callback = function(v) ChainESPSettings.Info = v end })
ChainSub:Slider({ Title = "文字大小", Value = { Min = 8, Max = 24, Default = 14 }, Callback = function(v) ChainESPSettings.TextSize = v; UpdateAllChainESP("TextSize", v) end })

-- ============================================
-- 视觉标签页 - 右侧（区域 & 物品）
-- ============================================
local VisualRight = VisualTab:Section({ Title = "区域 & 物品", Icon = "map" })

-- 区域 ESP
VisualRight:Toggle({ Title = "发电站 ESP", Value = false, Callback = function(v) AreaESPSettings.PowerStation = v; ToggleAreaESP("POWERSTATION", v) end })
VisualRight:Toggle({ Title = "仓库 ESP", Value = false, Callback = function(v) AreaESPSettings.WareHouse = v; ToggleAreaESP("WareHouse", v) end })
VisualRight:Toggle({ Title = "工作区 ESP", Value = false, Callback = function(v) AreaESPSettings.Workshop = v; ToggleAreaESP("Workshop", v) end })

VisualRight:Colorpicker({
    Title = "区域颜色",
    Default = Color3.fromRGB(255, 255, 0),
    Callback = function(color)
        AreaESPSettings.Color = color
        for _, data in pairs(AreaESPObjs) do data.Obj:SetColor(color) end
    end
})

VisualRight:Divider()

-- 废品 ESP
VisualRight:Toggle({
    Title = "废品 ESP",
    Value = false,
    Callback = function(value)
        ScrapESPSettings.Enabled = value
        if value then
            for _, scrap in ipairs(ScrapFolder:GetChildren()) do
                if scrap:IsA("Model") and scrap:GetAttribute("Scrap") ~= nil then
                    CreateScrapESP(scrap)
                end
            end
        else
            for model, data in pairs(ScrapESPObjs) do
                data.Obj:Remove()
                data.Part:Destroy()
            end
            ScrapESPObjs = {}
        end
    end
})

VisualRight:Colorpicker({
    Title = "废品颜色",
    Default = Color3.fromRGB(255, 200, 0),
    Callback = function(color)
        ScrapESPSettings.Color = color
        for _, data in pairs(ScrapESPObjs) do data.Obj:SetColor(color) end
    end
})

VisualRight:Divider()

-- 空投 ESP
VisualRight:Toggle({
    Title = "空投 ESP",
    Value = false,
    Callback = function(v)
        AirDropESPEnabled = v
        if v then EnableAirDropESP() else DisableAirDropESP() end
    end
})

VisualRight:Colorpicker({
    Title = "空投颜色",
    Default = Color3.fromRGB(170, 0, 255),
    Callback = function(color)
        AirDropESPSettings.Color = color
        if AirDropESPObj then AirDropESPObj:SetColor(color) end
    end
})

-- ============================================
-- 玩家标签页 - 左侧（能力）
-- ============================================
local PlayerLeft = PlayerTab:Section({ Title = "能力", Icon = "zap" })

-- 自动收集废料
PlayerLeft:Toggle({
    Title = "自动收集废料",
    Value = false,
    Callback = function(v)
        if pseudoActive and v then
            Notify("提示", "伪无敌期间无法开启自动收集废料", 3, "alert-triangle")
            return
        end
        AutoCollectSettings.Enabled = v
        if v then
            task.spawn(function()
                while AutoCollectSettings.Enabled do
                    if not ScrapCountdownActive then
                        local char = lp.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            for _, scrap in ipairs(ScrapFolder:GetChildren()) do
                                if not AutoCollectSettings.Enabled then break end
                                if scrap:IsA("Model") and scrap:GetAttribute("Scrap") ~= nil then
                                    local vals = scrap:FindFirstChild("Values")
                                    if vals and vals:GetAttribute("Available") == true then
                                        local dist = (hrp.Position - scrap:GetPivot().Position).Magnitude
                                        if dist <= AutoCollectSettings.Range then
                                            local prompt = scrap:FindFirstChildWhichIsA("ProximityPrompt", true)
                                            if prompt then
                                                if AutoCollectSettings.Teleport then
                                                    local savedCF = hrp.CFrame
                                                    char:PivotTo(scrap:GetPivot() * CFrame.new(0, 3, 0))
                                                    task.wait(0.2)
                                                    fireproximityprompt(prompt)
                                                    task.wait(0.2)
                                                    char:PivotTo(savedCF)
                                                else
                                                    fireproximityprompt(prompt)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.2)
                end
            end)
        end
    end
})

local AutoCollectSub = PlayerLeft:Paragraph({ Title = "自动收集选项", Image = "settings" })
AutoCollectSub:Slider({ Title = "范围", Value = { Min = 10, Max = 200, Default = 50 }, Callback = function(v) AutoCollectSettings.Range = v end })
AutoCollectSub:Toggle({ Title = "传送收集", Value = false, Callback = function(v) AutoCollectSettings.Teleport = v end })

PlayerLeft:Divider()

-- 面向 Chain
local FaceChainToggle
FaceChainToggle = PlayerLeft:Toggle({
    Title = "面向 Chain",
    Value = false,
    Callback = function(v)
        faceChainActive = v
        if v then
            task.spawn(function()
                while faceChainActive do
                    pcall(function()
                        local char = lp.Character
                        local hrp = char and char:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local nearest, nearDist = nil, math.huge
                            for _, chain in ipairs(aiFolder:GetChildren()) do
                                if chain:IsA("Model") then
                                    local cHRP = chain:FindFirstChild("HumanoidRootPart")
                                    local cHum = chain:FindFirstChild("Humanoid")
                                    if cHRP and cHum and cHum.Health > 0 then
                                        local dist = (hrp.Position - cHRP.Position).Magnitude
                                        if dist < nearDist then nearDist = dist; nearest = cHRP end
                                    end
                                end
                            end
                            if nearest then
                                Cam.CFrame = CFrame.lookAt(Cam.CFrame.Position, nearest.Position)
                            end
                        end
                    end)
                    task.wait(0.03)
                end
            end)
        end
    end
})

PlayerLeft:Divider()

-- Chain 技能预警
PlayerLeft:Toggle({
    Title = "Chain 技能预警",
    Value = false,
    Callback = function(v)
        cAlert.Active = v
        if v then
            setupChainAlert()
            createChainRings()
        else
            for _, conn in ipairs(chainAlertConns) do conn:Disconnect() end
            chainAlertConns = {}
            clearChainRings()
        end
    end
})

local AlertSub = PlayerLeft:Paragraph({ Title = "预警选项", Image = "settings" })
AlertSub:Toggle({ Title = "通知", Value = true, Callback = function(v) cAlert.Notify = v end })
AlertSub:Toggle({
    Title = "自动躲避",
    Value = false,
    Callback = function(v)
        if pseudoActive and v then
            Notify("提示", "伪无敌期间无法开启自动躲避", 3, "alert-triangle")
            return
        end
        cAlert.Dodge = v
    end
})
AlertSub:Toggle({ Title = "显示圈环", Value = true, Callback = function(v) cAlert.ShowRing = v end })
AlertSub:Toggle({ Title = "圈环旋转", Value = true, Callback = function(v) cAlert.RingRotating = v end })
AlertSub:Colorpicker({ Title = "圈环颜色", Default = Color3.fromRGB(255, 50, 50), Callback = function(v) cAlert.RingColor = v end })
AlertSub:Slider({ Title = "圈环扩大", Value = { Min = 0, Max = 50, Default = 0 }, Callback = function(v) RING_EXTRA = v end })

PlayerLeft:Divider()

-- 自动 QTE
PlayerLeft:Toggle({
    Title = "自动 QTE",
    Value = false,
    Callback = function(v)
        autoQTEActive = v
        for _, conn in ipairs(qteConns) do conn:Disconnect() end
        qteConns = {}
        if v then
            for _, name in ipairs(QTEFrames) do
                setupQTE(MechanicsFrame:FindFirstChild(name))
            end
        end
    end
})

PlayerLeft:Divider()

-- 无限体力
PlayerLeft:Toggle({
    Title = "无限体力",
    Value = false,
    Callback = function(v)
        staminaActive = v
        if v then
            task.spawn(function()
                while staminaActive do
                    pcall(function() lp.Character.Stats.Stamina.Value = 100 end)
                    task.wait(0.5)
                end
            end)
        end
    end
})

-- 无限战斗体力
PlayerLeft:Toggle({
    Title = "无限战斗体力",
    Value = false,
    Callback = function(v)
        combatStaminaActive = v
        if v then
            task.spawn(function()
                while combatStaminaActive do
                    pcall(function() lp.Character.Stats.CombatStamina.Value = 100 end)
                    task.wait(0.5)
                end
            end)
        end
    end
})

-- 自动赢进度条对决
PlayerLeft:Toggle({
    Title = "自动赢进度条对决",
    Value = false,
    Callback = function(v)
        clashActive = v
        if v then
            task.spawn(function()
                while clashActive do
                    pcall(function() lp.Character.Stats.ClashStrength.Value = 100 end)
                    task.wait(0.005)
                end
            end)
        end
    end
})

-- 无限电锯燃料
PlayerLeft:Toggle({
    Title = "无限电锯燃料",
    Value = false,
    Callback = function(v)
        gasActive = v
        if v then
            task.spawn(function()
                while gasActive do
                    pcall(function()
                        local c = lp.Character
                        if c and c:FindFirstChild("Items") and c.Items:FindFirstChild("XSaw") then
                            c.Items.XSaw:SetAttribute("Gas", 100)
                        end
                    end)
                    task.wait(0.01)
                end
            end)
        end
    end
})

-- 自动发电站
PlayerLeft:Toggle({
    Title = "自动发电站",
    Value = false,
    Callback = function(v)
        if pseudoActive and v then
            Notify("提示", "伪无敌期间无法开启自动发电站", 3, "alert-triangle")
            return
        end
        autoPowerActive = v
        if v then
            task.spawn(function()
                while autoPowerActive do
                    pcall(function()
                        local power = valuesFolder:GetAttribute("Power")
                        if type(power) == "number" and power <= 0 then
                            local char = lp.Character
                            local hrp = char and char:FindFirstChild("HumanoidRootPart")
                            local station = GameSections:FindFirstChild("POWERSTATION")
                            if hrp and station then
                                local savedCF = hrp.CFrame
                                hrp.CFrame = POWERSTATION_CF
                                task.wait(0.2)
                                local startTime = tick()
                                while autoPowerActive and tick() - startTime < 60 do
                                    local curPower = valuesFolder:GetAttribute("Power")
                                    if type(curPower) == "number" and curPower > 0 then break end
                                    local c = lp.Character
                                    local h = c and c:FindFirstChild("HumanoidRootPart")
                                    if h then h.CFrame = POWERSTATION_CF end
                                    pcall(function()
                                        local alertUI = GameSections.POWERSTATION:FindFirstChild("AlertUI")
                                        if alertUI then
                                            local gui = alertUI:FindFirstChild("GUI")
                                            if gui and not gui.Enabled then
                                                fireInteract(station)
                                            end
                                        end
                                    end)
                                    task.wait(0.03)
                                end
                                if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                                    lp.Character.HumanoidRootPart.CFrame = savedCF
                                end
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end
    end
})

-- ============================================
-- 玩家标签页 - 右侧（光照 & 远程界面）
-- ============================================
local PlayerRight = PlayerTab:Section({ Title = "光照", Icon = "sun" })

-- 去雾
PlayerRight:Toggle({
    Title = "去雾",
    Value = false,
    Callback = function(v)
        for _, conn in ipairs(nofogConns) do conn:Disconnect() end
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
    end
})

-- 全亮
PlayerRight:Toggle({
    Title = "全亮",
    Value = false,
    Callback = function(v)
        if fullbrightConn then fullbrightConn:Disconnect() fullbrightConn = nil end
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
    end
})

PlayerRight:Divider()

-- 远程界面
local RemoteSection = PlayerRight:Section({ Title = "远程界面", Icon = "monitor" })

RemoteSection:Toggle({
    Title = "商店界面",
    Value = false,
    Callback = function(v)
        if v and not isDaytime() then
            Notify("提示", "商店只能在白天打开", 2, "alert-triangle")
            return
        end
        SetRemoteGui("Shop", v)
    end
})

RemoteSection:Toggle({
    Title = "分解器界面",
    Value = false,
    Callback = function(v) SetRemoteGui("Deconstructor", v) end
})

RemoteSection:Toggle({
    Title = "工作台界面",
    Value = false,
    Callback = function(v) SetRemoteGui("Workbench", v) end
})

-- ============================================
-- 武器标签页
-- ============================================
local WeaponSection = WeaponTab:Section({ Title = "枪械", Icon = "sword" })

-- 无限弹药
WeaponSection:Toggle({
    Title = "无限弹药",
    Value = false,
    Callback = function(v)
        infAmmoActive = v
        if v then
            setupAmmoHooks()
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
                                end
                                if origSyncFunc then
                                    pcall(origSyncFunc, "Sync", gunName, {maxAmmo, 999})
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        else
            for _, c in ipairs(ammoConns) do pcall(function() c:Disconnect() end) end
            ammoConns = {}
        end
    end
})

-- 子弹追踪
WeaponSection:Toggle({
    Title = "子弹追踪",
    Value = false,
    Callback = function(v)
        bullet.TrackActive = v
        if v then
            if not bullet.Simulate then
                local ok = setupBulletTrack()
                if not ok then
                    bullet.TrackActive = false
                    Notify("错误", "子弹追踪初始化失败", 3, "alert-triangle")
                end
            end
        else
            if bullet.Simulate then
                local PH = require(game:GetService("ReplicatedStorage").GameStuff.Modules.ProjectileHandler)
                PH.SimulateProjectile = bullet.Simulate
                bullet.Simulate = nil
            end
        end
    end
})

local BulletSub = WeaponSection:Paragraph({ Title = "子弹追踪选项", Image = "settings" })
BulletSub:Toggle({ Title = "轨迹显示", Value = false, Callback = function(v) bullet.TrailActive = v end })
BulletSub:Colorpicker({ Title = "轨迹颜色", Default = Color3.fromRGB(0, 120, 255), Callback = function(v) bullet.TrailColor = v end })
BulletSub:Slider({ Title = "滞留时间", Value = { Min = 0.1, Max = 3, Default = 0.5, Rounding = 2 }, Callback = function(v) bullet.TrailLinger = v end })

-- 无后坐力
WeaponSection:Divider()
WeaponSection:Toggle({
    Title = "无后坐力",
    Value = false,
    Callback = function(v)
        noRecoilActive = v
        if v then hookRecoil() else restoreRecoil() end
    end
})

-- ============================================
-- 世界标签页（人物/速度/穿墙/第三人称）
-- ============================================
local WorldSection = WorldTab:Section({ Title = "人物", Icon = "person-standing" })

-- 速度
WorldSection:Toggle({
    Title = "速度",
    Value = false,
    Callback = function(v)
        tpwalk.Active = v
        if v then
            setupTPWalk()
        else
            if tpwalk.Conn then tpwalk.Conn:Disconnect() tpwalk.Conn = nil end
            if tpwalk.CharConn then tpwalk.CharConn:Disconnect() tpwalk.CharConn = nil end
        end
    end
})

local SpeedSub = WorldSection:Paragraph({ Title = "速度选项", Image = "settings" })
SpeedSub:Slider({ Title = "速度值", Value = { Min = 1, Max = 10, Default = 1, Rounding = 1 }, Callback = function(v) tpwalk.Speed = v end })

WorldSection:Divider()

-- 穿墙
WorldSection:Toggle({
    Title = "穿墙",
    Value = false,
    Callback = function(v)
        noclipActive = v
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        if v then
            noclipConn = RS.Stepped:Connect(function()
                local char = lp.Character
                if not char then return end
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        end
    end
})

WorldSection:Divider()

-- 第三人称
WorldSection:Toggle({
    Title = "第三人称",
    Value = false,
    Callback = function(v)
        tp3.Active = v
        if v then
            tp3.SavedMax = lp.CameraMaxZoomDistance
            tp3.SavedMin = lp.CameraMinZoomDistance
            enforceThirdPerson()
        else
            if tp3.Conn then tp3.Conn:Disconnect() tp3.Conn = nil end
            if tp3.CharConn then tp3.CharConn:Disconnect() tp3.CharConn = nil end
            pcall(function()
                lp.CameraMode = Enum.CameraMode.LockFirstPerson
                if tp3.SavedMax then lp.CameraMaxZoomDistance = tp3.SavedMax end
                if tp3.SavedMin then lp.CameraMinZoomDistance = tp3.SavedMin end
            end)
        end
        updateCameraLock()
    end
})

local TPSub = WorldSection:Paragraph({ Title = "第三人称选项", Image = "settings" })
TPSub:Toggle({ Title = "镜头锁定", Value = false, Callback = function(v) tp3.CamLock = v; updateCameraLock() end })

-- ============================================
-- 其他标签页（伪无敌）
-- ============================================
local MiscSection = MiscTab:Section({ Title = "无敌", Icon = "shield" })

MiscSection:Toggle({
    Title = "伪无敌",
    Desc = "开启后自动关闭某些功能，关闭后恢复",
    Value = false,
    Callback = function(v)
        if v ~= pseudoActive then
            togglePseudoInvincible()
        end
    end
})

MiscSection:Divider()

-- 徽章绕过通知
MiscSection:Paragraph({
    Title = "AK47 购买",
    Desc = "AK47 购买徽章已绕过",
    Image = "check",
})

-- ============================================
-- 配置标签页
-- ============================================
local ConfigSection = ConfigTab:Section({ Title = "配置管理", Icon = "save" })

-- 配置管理器
local ConfigManager = Window.ConfigManager
local myConfig = ConfigManager:CreateConfig("NeverLoseSettings")

ConfigSection:Button({
    Title = "保存所有配置",
    Callback = function()
        myConfig:Save()
        Notify("配置", "配置已保存", 2, "check")
    end
})

ConfigSection:Button({
    Title = "加载所有配置",
    Callback = function()
        myConfig:Load()
        Notify("配置", "配置已加载", 2, "check")
    end
})

-- 注册需要保存的组件
-- 注意：需要为每个需要保存的 Toggle/Slider 设置 Flag 参数
-- 例如：:Toggle({ ..., Flag = "PlayerESP" })

print("NeverLose 脚本加载完成！按 Insert 键打开菜单")