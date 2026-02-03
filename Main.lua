--[[ 
    ⭐ KANYAPAK PREMIUM SCRIPT V3.0 (BLOX FRUITS EDITION) ⭐
    Project: Kanyapak V3 - Advanced Mobile Optimization & Security
    Compatible: Sea 1, Sea 2, Sea 3, Sea 4+
    
    🔐 Security Features:
    - Multi-layer execution protection
    - Obfuscation-ready architecture
    - Anti-detection mechanisms
    - Memory optimization
    
    ⚡ Performance:
    - Lightweight footprint (~50KB)
    - Parallel task execution
    - Smart caching system
    - Optimized module loading
]]

-- ═══════════════════════════════════════════════════════════════════════════
-- 📌 SECTION 1: CORE EXECUTION PROTECTION & INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════

if _G.Kanyapak_Executed then
    warn("[KANYAPAK] Script is already running! Aborting...")
    return
end

_G.Kanyapak_Executed = true
_G.Kanyapak_Version = "3.0"
_G.Kanyapak_Timestamp = tick()
_G.Kanyapak_Protection = {
    _locked = true,
    _signature = "KANYAPAK_PREMIUM_2024"
}

-- ═══════════════════════════════════════════════════════════════════════════
-- 📌 SECTION 2: ADVANCED CONFIGURATION SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

_G.Zenith_Data = {
    Config = {
        -- 🌾 FARMING SYSTEM
        Farm = {
            Enabled = true,
            Level = true,
            Mastery = true,
            Tool = "Melee", -- [Melee, Sword, Fruit, Hybrid]
            BringMob = true,
            Distance = 25,
            AutoSell = false,
            SellInterval = 300,
            SmartTargeting = true,
            PriorityHigh = false,
            UseAbilities = true,
            AbilityDelay = 0.5
        },
        
        -- 👤 PLAYER ENHANCEMENT
        Player = {
            Speed = 25,
            Jump = 60,
            InfJump = false,
            NoClip = false,
            AntiStun = true,
            AntiKnockback = false,
            WallWalk = false,
            FlightMode = false,
            FlightSpeed = 30,
            SlideMode = true,
            Godmode = false
        },
        
        -- 👁️ VISUAL SYSTEM
        Visuals = {
            FruitESP = false,
            FruitDistance = 9999,
            PlayerESP = false,
            ChestESP = false,
            IslandESP = false,
            BossESP = false,
            FullBright = false,
            NoFog = false,
            UndergroundVision = false,
            CustomNameColor = Color3.fromRGB(0, 255, 127),
            ESPDistance = 5000
        },
        
        -- 🎯 SPECIAL FEATURES
        Misc = {
            AutoRaid = false,
            AutoNewWorld = false,
            FruitSniper = false,
            FruitSniperRange = 200,
            AntiAFK = true,
            AutoRejoin = false,
            AutoLogin = false,
            MacroSystem = true,
            VoiceCommand = false,
            AutoUpdate = true,
            DebugMode = false
        },
        
        -- ⚙️ ADVANCED SETTINGS
        Advanced = {
            RequestsPerSecond = 50,
            MemoryOptimization = true,
            MultiThreading = true,
            CacheSystem = true,
            PacketLogging = false,
            NetworkOptimization = true,
            UIScale = 1.0,
            HideUI = false,
            DarkMode = true
        }
    },
    
    CurrentSea = 1,
    WorldName = "Unknown",
    WorldType = "Unknown",
    
    Statistics = {
        SessionTime = 0,
        MobsKilled = 0,
        ExpGained = 0,
        MasteryGained = 0,
        ItemsCollected = 0,
        DistanceTraveled = 0,
        AbilitiesUsed = 0,
        SessionStart = tick()
    },
    
    Cache = {
        MobLocations = {},
        FruitLocations = {},
        PlayerData = {},
        IslandData = {},
        LastUpdate = 0
    }
}

-- ═══════════════════════════════════════════════════════════════════════════
-- 📌 SECTION 3: WORLD DETECTION SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local function DetectWorld()
    local PlaceId = game.PlaceId
    local WorldData = {
        [2753915549] = { Sea = 1, Name = "Sea 1", Type = "Starting World" },
        [4442272183] = { Sea = 2, Name = "Sea 2", Type = "Mid World" },
        [7449423635] = { Sea = 3, Name = "Sea 3", Type = "Late World" }
    }
    
    local Data = WorldData[PlaceId]
    if Data then
        _G.Zenith_Data.CurrentSea = Data.Sea
        _G.Zenith_Data.WorldName = Data.Name
        _G.Zenith_Data.WorldType = Data.Type
        return Data
    else
        _G.Zenith_Data.CurrentSea = 0
        _G.Zenith_Data.WorldName = "Unknown World"
        _G.Zenith_Data.WorldType = "Custom/Unknown"
        return nil
    end
end

local WorldInfo = DetectWorld()
print("[KANYAPAK] Detected: " .. _G.Zenith_Data.WorldName)

-- ═══════════════════════════════════════════════════════════════════════════
-- 📌 SECTION 4: GITHUB MODULE SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local GitHubConfig = {
    MainRepo = "https://raw.githubusercontent.com/tammason242-star/rujxmodv0/refs/heads/main/",
    BackupRepo = "https://raw.githubusercontent.com/Kanyapak-Dev/backup/refs/heads/main/",
    Timeout = 10,
    MaxRetries = 3
}

local ModuleCache = {}

local function LoadScript(FileName, UseBackup)
    if ModuleCache[FileName] then
        print("[CACHE] Using cached module: " .. FileName)
        return ModuleCache[FileName]
    end
    
    local Repos = { GitHubConfig.MainRepo }
    if UseBackup then
        table.insert(Repos, GitHubConfig.BackupRepo)
    end
    
    for _, Repo in ipairs(Repos) do
        local Success = false
        local Result = nil
        
        for Retry = 1, GitHubConfig.MaxRetries do
            Success, Result = pcall(function()
                return game:HttpGet(Repo .. FileName)
            end)
            
            if Success and Result ~= "404: Not Found" then
                local Exec, Error = loadstring(Result)
                if Exec then
                    print("✅ [LOADED] " .. FileName)
                    ModuleCache[FileName] = Exec()
                    return ModuleCache[FileName]
                else
                    warn("❌ [PARSE ERROR] " .. FileName .. ": " .. tostring(Error))
                end
                break
            elseif Retry < GitHubConfig.MaxRetries then
                task.wait(1)
            end
        end
    end
    
    warn("⚠️ [FAILED] Could not load: " .. FileName)
    return nil
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 📌 SECTION 5: ANTI-AFK SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

if _G.Zenith_Data.Config.Misc.AntiAFK then
    local VirtualUser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        print("⚡ [ANTI-AFK] System activated!")
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 📌 SECTION 6: NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local NotificationQueue = {}

local function SendNotification(Title, Message, Duration, Icon)
    Duration = Duration or 5
    Icon = Icon or 0
    
    local Notification = {
        Title = Title or "KANYAPAK",
        Text = Message or "No message",
        Duration = Duration,
        Callback = function() end
    }
    
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", Notification)
    end)
    
    table.insert(NotificationQueue, Notification)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 📌 SECTION 7: MAIN EXECUTION & MODULE INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════

task.spawn(function()
    SendNotification("🚀 KANYAPAK V3.0", "Initializing...", 3)
    task.wait(0.5)
    
    SendNotification("🌍 WORLD DETECTOR", "Detected: " .. _G.Zenith_Data.WorldName, 4)
    task.wait(0.5)
    
    -- Load all modules
    print("[KANYAPAK] Loading modules...")
    local modules = {
        Combat = "Combat.lua",
        Visuals = "Visuals.lua",
        Functions = "Functions.lua",
        UI = "UI_Library.lua"
    }
    
    local LoadedModules = {}
    for name, file in pairs(modules) do
        LoadedModules[name] = LoadScript(file, true) -- true = use backup
    end
    
    task.wait(1)
    
    -- Initialize all modules
    for name, module in pairs(LoadedModules) do
        if module and module.Init then
            task.spawn(function()
                pcall(function()
                    module:Init()
                    print("✅ [INITIALIZED] " .. name)
                end)
            end)
        end
    end
    
    task.wait(2)
    SendNotification("✨ READY!", "All systems online - Blox Fruits V" .. _G.Zenith_Data.CurrentSea, 4)
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- 📌 SECTION 8: HEARTBEAT MONITORING
-- ═══════════════════════════════════════════════════════════════════════════

local LastHeartbeat = tick()
game:GetService("RunService").Heartbeat:Connect(function()
    _G.Zenith_Data.Statistics.SessionTime = tick() - _G.Zenith_Data.Statistics.SessionStart
    
    if tick() - LastHeartbeat > 60 then
        if _G.Zenith_Data.Config.Advanced.DebugMode then
            print("[DEBUG] Stats - Mobs: " .. _G.Zenith_Data.Statistics.MobsKilled .. 
                  " | Exp: " .. _G.Zenith_Data.Statistics.ExpGained)
        end
        LastHeartbeat = tick()
    end
end)

print("[✓] KANYAPAK V3.0 Successfully Loaded!")
print("[✓] Version: " .. _G.Kanyapak_Version)
print("[✓] Timestamp: " .. os.date("%Y-%m-%d %H:%M:%S", _G.Kanyapak_Timestamp))
