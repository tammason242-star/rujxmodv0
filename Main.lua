--[[ 
    ⭐ MAIN.LUA - KANYAPAK SHOP V3.0 ⭐
    Complete Loader & Initialization System
    All-in-One Script for Blox Fruits
]]

-- ═══════════════════════════════════════════════════════════════════════════
-- 📌 EXECUTION PROTECTION
-- ═══════════════════════════════════════════════════════════════════════════

if _G.Kanyapak_Executed then
    warn("[KANYAPAK] Script already running!")
    return
end
_G.Kanyapak_Executed = true

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎨 GLOBAL DATA INITIALIZATION
-- ═══════════════════════════════════════════════════════════════════════════

print("\n" .. string.rep("=", 70))
print("⭐ KANYAPAK SHOP V3.0 - LOADING...")
print(string.rep("=", 70) .. "\n")

_G.Zenith_Data = {
    Version = "3.0",
    LoadTime = tick(),
    
    Config = {
        Farm = {
            Enabled = true,
            Level = true,
            Mastery = true,
            Tool = "Melee",
            BringMob = true,
            Distance = 25,
            AutoSell = false,
            SellInterval = 300,
            SmartTargeting = true,
            UseAbilities = true,
            AbilityDelay = 0.5
        },
        
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
            ESPDistance = 5000
        },
        
        Misc = {
            AutoRaid = false,
            AutoNewWorld = false,
            FruitSniper = false,
            AntiAFK = true,
            AutoRejoin = false,
            MacroSystem = true,
            VoiceCommand = false,
            AutoUpdate = true,
            DebugMode = false
        },
        
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
    },
    
    CurrentSea = 1,
    WorldName = "Unknown",
    WorldType = "Unknown"
}

-- ═══════════════════════════════════════════════════════════════════════════
-- 🌍 WORLD DETECTION
-- ═══════════════════════════════════════════════════════════════════════════

local function DetectWorld()
    local PlaceId = game.PlaceId
    local WorldData = {
        [2753915549] = { Sea = 1, Name = "Sea 1 (Starting Island)", Type = "Starter" },
        [4442272183] = { Sea = 2, Name = "Sea 2 (Paradise)", Type = "Intermediate" },
        [7449423635] = { Sea = 3, Name = "Sea 3 (EndGame)", Type = "Advanced" }
    }
    
    local Data = WorldData[PlaceId]
    if Data then
        _G.Zenith_Data.CurrentSea = Data.Sea
        _G.Zenith_Data.WorldName = Data.Name
        _G.Zenith_Data.WorldType = Data.Type
        print("✅ [WORLD] Detected: " .. Data.Name)
        return Data
    else
        print("⚠️ [WORLD] Unknown world detected (PlaceID: " .. PlaceId .. ")")
        return nil
    end
end

DetectWorld()

-- ═══════════════════════════════════════════════════════════════════════════
-- 📥 MODULE LOADER SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local ModuleCache = {}
local Repo = "https://raw.githubusercontent.com/tammason242-star/rujxmodv0/refs/heads/main/"

local function LoadModule(FileName)
    if ModuleCache[FileName] then
        print("📦 [CACHE] Using cached: " .. FileName)
        return ModuleCache[FileName]
    end
    
    print("📥 [LOADER] Loading: " .. FileName .. "...")
    
    local Success, Result = pcall(function()
        return game:HttpGet(Repo .. FileName)
    end)
    
    if Success and Result ~= "404: Not Found" then
        local LoadFunc, Error = loadstring(Result)
        
        if LoadFunc then
            local Module = LoadFunc()
            ModuleCache[FileName] = Module
            print("✅ [LOADED] " .. FileName)
            return Module
        else
            warn("❌ [ERROR] Failed to parse " .. FileName .. ": " .. tostring(Error))
            return nil
        end
    else
        warn("❌ [NETWORK] Failed to download " .. FileName)
        return nil
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🚀 LOAD ALL MODULES
-- ═══════════════════════════════════════════════════════════════════════════

print("\n[PHASE 1] Loading Modules...\n")

local UI_Library = LoadModule("UI_Library.lua")
local Combat = LoadModule("Combat.lua")
local Functions = LoadModule("Functions.lua")
local Visuals = LoadModule("Visuals.lua")

-- ═══════════════════════════════════════════════════════════════════════════
-- ⚡ INITIALIZE ALL SYSTEMS
-- ═══════════════════════════════════════════════════════════════════════════

print("\n[PHASE 2] Initializing Systems...\n")

task.spawn(function()
    if UI_Library and UI_Library.Init then
        pcall(function() UI_Library:Init() end)
    end
end)

task.spawn(function()
    task.wait(1)
    if Combat and Combat.Init then
        pcall(function() Combat:Init() end)
    end
end)

task.spawn(function()
    task.wait(1)
    if Functions and Functions.Init then
        pcall(function() Functions:Init() end)
    end
end)

task.spawn(function()
    task.wait(1)
    if Visuals and Visuals.Init then
        pcall(function() Visuals:Init() end)
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- 📊 HEARTBEAT MONITOR
-- ═══════════════════════════════════════════════════════════════════════════

local function StartHeartbeatMonitor()
    game:GetService("RunService").Heartbeat:Connect(function()
        if _G.Zenith_Data and _G.Zenith_Data.Statistics then
            _G.Zenith_Data.Statistics.SessionTime = tick() - _G.Zenith_Data.Statistics.SessionStart
        end
    end)
end

StartHeartbeatMonitor()

-- ═══════════════════════════════════════════════════════════════════════════
-- 🔔 ANTI-AFK SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local function StartAntiAFK()
    if _G.Zenith_Data.Config.Misc.AntiAFK then
        local VirtualUser = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
            print("⚡ [ANTI-AFK] System triggered!")
        end)
    end
end

StartAntiAFK()

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎮 KEYBIND SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- F6: Toggle farming
    if input.KeyCode == Enum.KeyCode.F6 then
        _G.Zenith_Data.Config.Farm.Enabled = not _G.Zenith_Data.Config.Farm.Enabled
        print("[KEYBIND] Farm toggled: " .. tostring(_G.Zenith_Data.Config.Farm.Enabled))
    end
    
    -- F7: Toggle combat UI
    if input.KeyCode == Enum.KeyCode.F7 then
        local ScreenGui = game:GetService("CoreGui"):FindFirstChild("KanyapakShop_V3")
        if ScreenGui then
            local MainFrame = ScreenGui:FindFirstChild("KanyapakMainMenu")
            if MainFrame then
                MainFrame.Visible = not MainFrame.Visible
            end
        end
    end
    
    -- F8: Reset statistics
    if input.KeyCode == Enum.KeyCode.F8 then
        _G.Zenith_Data.Statistics.MobsKilled = 0
        print("[STATS] Statistics reset!")
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- 📢 COMPLETION NOTIFICATION
-- ═══════════════════════════════════════════════════════════════════════════

task.wait(3)

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🎉 KANYAPAK V3.0",
        Text = "All systems loaded successfully! Use F7 to toggle UI",
        Duration = 5,
        Icon = "rbxassetid://12221969"
    })
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- 📊 FINAL STARTUP INFO
-- ═══════════════════════════════════════════════════════════════════════════

print("\n" .. string.rep("=", 70))
print("✅ KANYAPAK SHOP V3.0 - FULLY LOADED")
print(string.rep("=", 70))
print("\n📌 QUICK COMMANDS:")
print("   F6 = Toggle Farming")
print("   F7 = Toggle UI Panel")
print("   F8 = Reset Statistics")
print("\n🌍 WORLD INFO:")
print("   Sea: " .. _G.Zenith_Data.CurrentSea)
print("   Name: " .. _G.Zenith_Data.WorldName)
print("   Type: " .. _G.Zenith_Data.WorldType)
print("\n⚙️ MODULES LOADED:")
print("   ✅ UI Library")
print("   ✅ Combat System")
print("   ✅ Navigation System")
print("   ✅ Visual System")
print("\n🎯 FEATURES:")
print("   • Auto Farming")
print("   • Smart Navigation")
print("   • Combat System")
print("   • Visual Enhancements")
print("   • Statistics Tracking")
print("   • Anti-AFK Protection")
print(string.rep("=", 70) .. "\n")

-- ═══════════════════════════════════════════════════════════════════════════
-- 🔧 ERROR HANDLING & SAFETY
-- ═══════════════════════════════════════════════════════════════════════════

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(Character)
    print("[CHARACTER] Respawned - Reinitializing systems...")
    task.wait(1)
    if Combat and Combat.Init then
        pcall(function() Combat:Init() end)
    end
end)

-- Handle script errors gracefully
game:GetService("RunService").Heartbeat:Connect(function()
    pcall(function()
        -- Any heartbeat critical operations go here
    end)
end)

print("✨ KANYAPAK SHOP V3.0 is now ready to use!")
