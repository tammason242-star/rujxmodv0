--[[ 
    🚀 FUNCTIONS.LUA - KANYAPAK SHOP V3.0 🚀
    Advanced Intelligence & Movement Engine
    Features: Smart Navigation, Auto Quest, Pathfinding, Teleport, Sea Handling
    
    🎯 Core Features:
    - Advanced Tween System with Anti-Collision
    - Intelligent Quest Management
    - Dynamic NPC Navigation
    - Enemy Spawn Detection
    - Multi-Sea Support
    - Performance Optimization
    - Caching & State Management
]]

local Functions = {}
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- ═══════════════════════════════════════════════════════════════════════════
-- 📊 CONFIGURATION & CACHING
-- ═══════════════════════════════════════════════════════════════════════════

local NavigationCache = {
    LastQuestNPC = nil,
    LastMonsterSpawn = nil,
    PathHistory = {},
    EstimatedTime = 0
}

local NPCLocations = {
    [1] = { -- SEA 1
        ["Bandit"] = { Pos = CFrame.new(1059, 15, 1548), QuestName = "BanditQuest1", MaxLevel = 10 },
        ["Monkey"] = { Pos = CFrame.new(-1598, 35, 153), QuestName = "MonkeyQuest1", MaxLevel = 15 },
        ["Zombie"] = { Pos = CFrame.new(-5313, 0, -627), QuestName = "ZombieQuest1", MaxLevel = 30 },
        ["Ape"] = { Pos = CFrame.new(-2788, 88, -2083), QuestName = "ApeQuest1", MaxLevel = 50 },
        ["Pirate"] = { Pos = CFrame.new(-7523, 5, -7634), QuestName = "PirateQuest1", MaxLevel = 70 },
        ["Brute"] = { Pos = CFrame.new(-4894, 24, 4247), QuestName = "BruteQuest1", MaxLevel = 150 }
    },
    [2] = { -- SEA 2
        ["Swordsman"] = { Pos = CFrame.new(863, 34, 870), QuestName = "SwordsmanQuest1", MaxLevel = 200 },
        ["Snowman"] = { Pos = CFrame.new(-6069, 108, -6066), QuestName = "SnowmanQuest1", MaxLevel = 300 },
        ["Arctic Warrior"] = { Pos = CFrame.new(-6069, 108, -6066), QuestName = "ArcticWarriorQuest1", MaxLevel = 400 }
    },
    [3] = { -- SEA 3
        ["Magician"] = { Pos = CFrame.new(-4975, 10, 8832), QuestName = "MagicianQuest1", MaxLevel = 500 }
    }
}

local MonsterSpawns = {
    [1] = {
        ["Bandit"] = CFrame.new(1050, 20, 1500),
        ["Monkey"] = CFrame.new(-1600, 50, 150),
        ["Zombie"] = CFrame.new(-5300, 10, -650),
        ["Ape"] = CFrame.new(-2800, 100, -2100),
        ["Pirate"] = CFrame.new(-7500, 15, -7600),
        ["Brute"] = CFrame.new(-4900, 30, 4200)
    }
}

-- ═══════════════════════════════════════════════════════════════════════════
-- 📢 NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local function SendFunctionNotify(Title, Message, Duration)
    Duration = Duration or 3
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = Title,
            Text = Message,
            Duration = Duration,
            Icon = "rbxassetid://12221969"
        })
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🛡️ COLLISION & PHYSICS MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════════════

local function SetNoCollide(State)
    local Character = LocalPlayer.Character
    if not Character then return end
    
    pcall(function()
        for _, Part in pairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") then
                Part.CanCollide = not State
                if State then
                    Part.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
                end
            end
        end
    end)
end

local function OptimizePhysics()
    local Character = LocalPlayer.Character
    if not Character then return end
    
    pcall(function()
        for _, Part in pairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") then
                Part.TopSurface = Enum.SurfaceType.Smooth
                Part.BottomSurface = Enum.SurfaceType.Smooth
                Part.CanCollide = false
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- ✈️ ADVANCED TWEEN SYSTEM - SMART NAVIGATION
-- ═══════════════════════════════════════════════════════════════════════════

function Functions:SmartTween(TargetCFrame, Speed, Mode)
    local Character = LocalPlayer.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")
    if not Root then return nil end
    
    Speed = Speed or 250
    Mode = Mode or "flight" -- flight, walk, teleport
    
    local Distance = (Root.Position - TargetCFrame.p).Magnitude
    local TravelTime = Distance / Speed
    
    -- Update cache
    NavigationCache.EstimatedTime = TravelTime
    table.insert(NavigationCache.PathHistory, {Time = tick(), Position = Root.Position})
    
    if Mode == "teleport" then
        -- Instant teleport
        Root.CFrame = TargetCFrame
        return nil
    elseif Mode == "walk" then
        -- Walking mode (slower, for NPCs)
        TravelTime = Distance / 50
    end
    
    -- Create tween with smooth easing
    local TweenInfo = TweenInfo.new(
        TravelTime,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut
    )
    
    local Tween = TweenService:Create(Root, TweenInfo, { CFrame = TargetCFrame })
    
    -- Anti-collision during flight
    local NoClipConnection
    NoClipConnection = RunService.Stepped:Connect(function()
        if not Tween or Tween.PlaybackState == Enum.PlaybackState.Completed or Tween.PlaybackState == Enum.PlaybackState.Cancelled then
            if NoClipConnection then NoClipConnection:Disconnect() end
            return
        end
        
        if _G.Zenith_Data.Config.Player.NoClip or Mode == "flight" then
            SetNoCollide(true)
        end
    end)
    
    Tween:Play()
    
    -- Debug info
    if _G.Zenith_Data.Config.Advanced.DebugMode then
        print(string.format("[NAV] Flying %.2f studs in %.2f seconds (Speed: %d)", Distance, TravelTime, Speed))
    end
    
    return Tween
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎯 SMART LEVEL-BASED QUEST SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local function GetPlayerLevel()
    pcall(function()
        return LocalPlayer:WaitForChild("Data"):WaitForChild("Level").Value
    end)
    return 1
end

local function GetCurrentQuest()
    pcall(function()
        local PlrGui = LocalPlayer:WaitForChild("PlayerGui")
        local Main = PlrGui:FindFirstChild("Main")
        if Main then
            local QuestFrame = Main:FindFirstChild("QuestContainer") or Main:FindFirstChild("Quest")
            if QuestFrame and QuestFrame.Visible then
                return true
            end
        end
    end)
    return false
end

function Functions:GetOptimalQuest()
    local Sea = _G.Zenith_Data.CurrentSea
    local Level = GetPlayerLevel()
    local SeaNPCs = NPCLocations[Sea]
    
    if not SeaNPCs then
        print("[ERROR] Sea " .. Sea .. " data not found")
        return nil
    end
    
    -- Find best quest for current level
    for NPCName, NPCData in pairs(SeaNPCs) do
        if Level >= (NPCData.MaxLevel - 50) and Level <= NPCData.MaxLevel then
            return NPCData, NPCName
        end
    end
    
    -- Fallback to highest available quest
    local BestQuest = nil
    local BestName = nil
    for NPCName, NPCData in pairs(SeaNPCs) do
        if not BestQuest or NPCData.MaxLevel > BestQuest.MaxLevel then
            BestQuest = NPCData
            BestName = NPCName
        end
    end
    
    return BestQuest, BestName
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🧭 MONSTER DETECTION & TARGETING
-- ═══════════════════════════════════════════════════════════════════════════

local function FindMonsterByName(MonsterName, SearchRadius)
    SearchRadius = SearchRadius or 5000
    local Character = LocalPlayer.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")
    
    if not Root then return nil end
    
    pcall(function()
        for _, Enemy in pairs(workspace:FindFirstChild("Enemies") and workspace.Enemies:GetChildren() or {}) do
            if Enemy.Name == MonsterName and Enemy:FindFirstChild("Humanoid") then
                if Enemy.Humanoid.Health > 0 then
                    local Distance = (Enemy.HumanoidRootPart.Position - Root.Position).Magnitude
                    if Distance < SearchRadius then
                        return Enemy
                    end
                end
            end
        end
    end)
    
    return nil
end

local function WaitForMonsterSpawn(MonsterName, MaxWaitTime, CheckInterval)
    MaxWaitTime = MaxWaitTime or 60
    CheckInterval = CheckInterval or 1
    local StartTime = tick()
    
    while tick() - StartTime < MaxWaitTime do
        local Monster = FindMonsterByName(MonsterName)
        if Monster then
            return Monster
        end
        task.wait(CheckInterval)
    end
    
    return nil
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 📡 QUEST MANAGEMENT SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

function Functions:StartQuest(QuestName)
    pcall(function()
        -- Try to find and invoke quest remote
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
        
        if Remotes then
            local CommF = Remotes:FindFirstChild("CommF_")
            if CommF and CommF:IsA("RemoteFunction") then
                CommF:InvokeServer("StartQuest", QuestName, 1)
                SendFunctionNotify("📜 QUEST", "Quest started: " .. QuestName, 2)
                return true
            end
        end
    end)
    
    return false
end

function Functions:CompleteQuest()
    pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
        
        if Remotes then
            local CommF = Remotes:FindFirstChild("CommF_")
            if CommF and CommF:IsA("RemoteFunction") then
                CommF:InvokeServer("QuestComplete")
                SendFunctionNotify("✅ QUEST", "Quest completed!", 2)
                return true
            end
        end
    end)
    
    return false
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🌊 SEA NAVIGATION & AUTO-TRAVEL
-- ═══════════════════════════════════════════════════════════════════════════

function Functions:TeleportToIsland(IslandName)
    local IslandPos = {
        ["Starter Island"] = CFrame.new(-133, 16, 260),
        ["Pirate Island"] = CFrame.new(-7523, 10, -7634),
        ["Jungle"] = CFrame.new(-2788, 88, -2083),
        ["Snow"] = CFrame.new(-6069, 108, -6066),
        ["Water 7"] = CFrame.new(-4975, 10, 8832)
    }
    
    if IslandPos[IslandName] then
        return Functions:SmartTween(IslandPos[IslandName], 300, "flight")
    end
end

function Functions:AutoNavigateToQuest()
    local QuestData, QuestName = Functions:GetOptimalQuest()
    
    if not QuestData then
        SendFunctionNotify("❌ NAV ERROR", "No suitable quest found", 3)
        return false
    end
    
    print("[NAV] Navigating to " .. QuestName)
    
    -- Step 1: Go to NPC
    SendFunctionNotify("🧭 NAVIGATING", "Flying to " .. QuestName .. " NPC...", 2)
    Functions:SmartTween(QuestData.Pos, 300, "flight")
    task.wait(3) -- Wait for flight to complete
    
    -- Step 2: Start quest
    Functions:StartQuest(QuestData.QuestName)
    task.wait(2)
    
    -- Step 3: Find and go to monster
    SendFunctionNotify("🔍 HUNTING", "Searching for monsters...", 2)
    local Monster = WaitForMonsterSpawn(QuestName, 30, 0.5)
    
    if Monster then
        -- Fly above the monster
        local MonsterRoot = Monster:FindFirstChild("HumanoidRootPart")
        if MonsterRoot then
            Functions:SmartTween(MonsterRoot.CFrame * CFrame.new(0, 30, 30), 300, "flight")
            SendFunctionNotify("🎯 FOUND", "Monster found! Starting combat...", 2)
        end
        return true
    else
        SendFunctionNotify("❌ NOT FOUND", "Monster failed to spawn", 3)
        return false
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 💡 VISUAL ENHANCEMENTS
-- ═══════════════════════════════════════════════════════════════════════════

local function EnableFullBright()
    local Lighting = game:GetService("Lighting")
    Lighting.Brightness = 2.5
    Lighting.ClockTime = 12
    Lighting.GlobalShadows = false
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
end

local function RemoveFog()
    pcall(function()
        for _, Part in pairs(workspace:GetDescendants()) do
            if Part:IsA("Atmosphere") then
                Part:Destroy()
            end
        end
    end)
end

local function EnableUndergroundVision()
    local Camera = workspace.CurrentCamera
    Camera.ClipPlanes = Vector2.new(0.1, 100000)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎮 MAIN INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════

function Functions:Init()
    print("🚀 [KANYAPAK SHOP V3] Functions & Navigation System Loaded")
    SendFunctionNotify("🚀 NAV SYSTEM", "Navigation Engine Online", 3)
    
    -- Auto Farm Loop
    task.spawn(function()
        while task.wait(1) do
            local Config = _G.Zenith_Data.Config.Farm
            
            if not Config.Enabled or not Config.Level then continue end
            
            local Character = LocalPlayer.Character
            if not Character then continue end
            
            local HasQuest = GetCurrentQuest()
            
            if not HasQuest then
                -- No quest - navigate to NPC and start
                if _G.Zenith_Data.Config.Advanced.DebugMode then
                    print("[FARM] No active quest, starting navigation...")
                end
                Functions:AutoNavigateToQuest()
            else
                -- Have quest - find and hunt monsters
                local QuestData, QuestName = Functions:GetOptimalQuest()
                if QuestData then
                    local Monster = FindMonsterByName(QuestName)
                    if Monster and Monster.Humanoid.Health > 0 then
                        -- Monster exists and combat will handle it
                        if _G.Zenith_Data.Config.Advanced.DebugMode then
                            print("[FARM] Hunting " .. QuestName)
                        end
                    else
                        -- Monster died or despawned
                        task.wait(2)
                        Functions:CompleteQuest()
                    end
                end
            end
        end
    end)
    
    -- Visual Enhancement Loop
    task.spawn(function()
        while task.wait(1) do
            local Visuals = _G.Zenith_Data.Config.Visuals
            
            if Visuals.FullBright then
                EnableFullBright()
            end
            
            if Visuals.NoFog then
                RemoveFog()
            end
            
            if Visuals.UndergroundVision then
                EnableUndergroundVision()
            end
        end
    end)
    
    -- Physics Optimization
    task.spawn(function()
        while task.wait(0.5) do
            if _G.Zenith_Data.Config.Player.FlightMode or _G.Zenith_Data.Config.Farm.Enabled then
                OptimizePhysics()
            end
        end
    end)
    
    -- Sea Change Detection
    task.spawn(function()
        local LastSea = _G.Zenith_Data.CurrentSea
        
        while task.wait(5) do
            local CurrentSea = _G.Zenith_Data.CurrentSea
            
            if CurrentSea ~= LastSea then
                SendFunctionNotify("🌊 SEA CHANGED", "Now in Sea " .. CurrentSea, 3)
                LastSea = CurrentSea
            end
        end
    end)
    
    print("✅ [FUNCTIONS] All systems initialized")
    print("✅ [NAV] Smart Tween System Ready")
    print("✅ [FARM] Auto Quest System Ready")
    print("✅ [VISUALS] Visual Enhancements Ready")
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 📍 PUBLIC API FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════

function Functions:TeleportTo(X, Y, Z)
    local Character = LocalPlayer.Character
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        Character.HumanoidRootPart.CFrame = CFrame.new(X, Y, Z)
        SendFunctionNotify("📍 TELEPORT", "Teleported to position", 2)
    end
end

function Functions:ResetCache()
    NavigationCache = {
        LastQuestNPC = nil,
        LastMonsterSpawn = nil,
        PathHistory = {},
        EstimatedTime = 0
    }
    SendFunctionNotify("🔄 CACHE", "Navigation cache cleared", 2)
end

function Functions:GetStats()
    return {
        LastQuestNPC = NavigationCache.LastQuestNPC,
        EstimatedTravelTime = NavigationCache.EstimatedTime,
        PathCount = #NavigationCache.PathHistory
    }
end

return Functions
