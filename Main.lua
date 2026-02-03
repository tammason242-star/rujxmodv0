--[[ 
    ⭐ MAIN.LUA - MOBILE OPTIMIZED ⭐
    Fixed for Tablet & Phone
]]

if _G.Kanyapak_Executed then
    warn("[KANYAPAK] Already running!")
    return
end
_G.Kanyapak_Executed = true

print("\n[MOBILE] Loading Kanyapak V3.0...")

-- ═══════════════════════════════════════════════════════════════════════════
-- DETECT DEVICE TYPE
-- ═══════════════════════════════════════════════════════════════════════════

local UserInputService = game:GetService("UserInputService")
local IsMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

print("[DEVICE] Type: " .. (IsMobile and "MOBILE/TABLET" or "PC/MOUSE"))

-- ═══════════════════════════════════════════════════════════════════════════
-- INITIALIZE GLOBAL DATA
-- ═══════════════════════════════════════════════════════════════════════════

_G.Zenith_Data = {
    Version = "3.0",
    IsMobile = IsMobile,
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
            DebugMode = true
        },
        
        Advanced = {
            RequestsPerSecond = 50,
            MemoryOptimization = true,
            MultiThreading = true,
            CacheSystem = true,
            UIScale = IsMobile and 0.85 or 1.0,
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

print("[CONFIG] Mobile optimized UI scale: " .. _G.Zenith_Data.Config.Advanced.UIScale)

-- ═══════════════════════════════════════════════════════════════════════════
-- WORLD DETECTION
-- ═══════════════════════════════════════════════════════════════════════════

local function DetectWorld()
    local PlaceId = game.PlaceId
    local WorldData = {
        [2753915549] = { Sea = 1, Name = "Sea 1", Type = "Starter" },
        [4442272183] = { Sea = 2, Name = "Sea 2", Type = "Intermediate" },
        [7449423635] = { Sea = 3, Name = "Sea 3", Type = "Advanced" }
    }
    
    local Data = WorldData[PlaceId]
    if Data then
        _G.Zenith_Data.CurrentSea = Data.Sea
        _G.Zenith_Data.WorldName = Data.Name
        _G.Zenith_Data.WorldType = Data.Type
        print("[WORLD] " .. Data.Name)
        return Data
    end
    return nil
end

DetectWorld()

-- ═══════════════════════════════════════════════════════════════════════════
-- LOAD UI LIBRARY
-- ═══════════════════════════════════════════════════════════════════════════

print("\n[LOADING] UI Library...")

local UI_Library = nil

local function LoadUILibrary()
    local Success, Result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/tammason242-star/rujxmodv0/refs/heads/main/UI_Library.lua")
    end)
    
    if Success and Result ~= "404: Not Found" and Result ~= "" then
        local LoadFunc, Error = loadstring(Result)
        if LoadFunc then
            UI_Library = LoadFunc()
            print("[SUCCESS] UI Library loaded")
            return UI_Library
        else
            warn("[ERROR] UI Parse Error: " .. tostring(Error))
            return nil
        end
    else
        warn("[ERROR] Could not download UI Library")
        return nil
    end
end

UI_Library = LoadUILibrary()

if not UI_Library then
    warn("\n⚠️  CRITICAL: UI Library load failed!")
    return
end

-- ═══════════════════════════════════════════════════════════════════════════
-- INITIALIZE UI
-- ═══════════════════════════════════════════════════════════════════════════

print("\n[INIT] Initializing UI System...")

task.spawn(function()
    pcall(function()
        if UI_Library and UI_Library.Init then
            UI_Library:Init()
        end
    end)
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- LOAD OTHER MODULES
-- ═══════════════════════════════════════════════════════════════════════════

task.wait(2)

print("[LOADING] Combat Module...")
local Combat = loadstring(game:HttpGet("https://raw.githubusercontent.com/tammason242-star/rujxmodv0/refs/heads/main/Combat.lua"))()

task.wait(0.5)
print("[LOADING] Functions Module...")
local Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/tammason242-star/rujxmodv0/refs/heads/main/Functions.lua"))()

task.wait(0.5)
print("[LOADING] Visuals Module...")
local Visuals = loadstring(game:HttpGet("https://raw.githubusercontent.com/tammason242-star/rujxmodv0/refs/heads/main/Visuals.lua"))()

-- ═══════════════════════════════════════════════════════════════════════════
-- INITIALIZE ALL MODULES
-- ═══════════════════════════════════════════════════════════════════════════

print("\n[INIT] Starting all systems...\n")

task.spawn(function()
    if Combat and Combat.Init then
        pcall(function() Combat:Init() end)
    end
end)

task.spawn(function()
    task.wait(0.5)
    if Functions and Functions.Init then
        pcall(function() Functions:Init() end)
    end
end)

task.spawn(function()
    task.wait(0.5)
    if Visuals and Visuals.Init then
        pcall(function() Visuals:Init() end)
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- HEARTBEAT
-- ═══════════════════════════════════════════════════════════════════════════

game:GetService("RunService").Heartbeat:Connect(function()
    if _G.Zenith_Data and _G.Zenith_Data.Statistics then
        _G.Zenith_Data.Statistics.SessionTime = tick() - _G.Zenith_Data.Statistics.SessionStart
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- ANTI-AFK
-- ═══════════════════════════════════════════════════════════════════════════

if _G.Zenith_Data.Config.Misc.AntiAFK then
    local VirtualUser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- MOBILE BUTTON CONTROLS
-- ═══════════════════════════════════════════════════════════════════════════

if IsMobile then
    print("[MOBILE] Setting up touch controls...\n")
    
    -- Create mobile control buttons
    local CoreGui = game:GetService("CoreGui")
    local MobileControls = Instance.new("ScreenGui")
    MobileControls.Name = "MobileControls"
    MobileControls.Parent = CoreGui
    MobileControls.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Toggle Farming Button (F6)
    local FarmBtn = Instance.new("TextButton")
    FarmBtn.Name = "FarmToggle"
    FarmBtn.Text = "🌾 FARM"
    FarmBtn.Size = UDim2.new(0, 70, 0, 50)
    FarmBtn.Position = UDim2.new(0, 10, 1, -70)
    FarmBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    FarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    FarmBtn.Font = Enum.Font.GothamBold
    FarmBtn.TextSize = 12
    FarmBtn.BorderSizePixel = 0
    FarmBtn.Parent = MobileControls
    FarmBtn.ZIndex = 300
    
    local FarmCorner = Instance.new("UICorner")
    FarmCorner.CornerRadius = UDim.new(0, 8)
    FarmCorner.Parent = FarmBtn
    
    FarmBtn.TouchTap:Connect(function()
        _G.Zenith_Data.Config.Farm.Enabled = not _G.Zenith_Data.Config.Farm.Enabled
        FarmBtn.BackgroundColor3 = _G.Zenith_Data.Config.Farm.Enabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
        print("[FARM] Toggled: " .. (_G.Zenith_Data.Config.Farm.Enabled and "ON" or "OFF"))
    end)
    
    -- Show Menu Button (F7)
    local MenuBtn = Instance.new("TextButton")
    MenuBtn.Name = "MenuToggle"
    MenuBtn.Text = "☰ MENU"
    MenuBtn.Size = UDim2.new(0, 70, 0, 50)
    MenuBtn.Position = UDim2.new(0, 90, 1, -70)
    MenuBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    MenuBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MenuBtn.Font = Enum.Font.GothamBold
    MenuBtn.TextSize = 12
    MenuBtn.BorderSizePixel = 0
    MenuBtn.Parent = MobileControls
    MenuBtn.ZIndex = 300
    
    local MenuCorner = Instance.new("UICorner")
    MenuCorner.CornerRadius = UDim.new(0, 8)
    MenuCorner.Parent = MenuBtn
    
    MenuBtn.TouchTap:Connect(function()
        local ScreenGui = CoreGui:FindFirstChild("KanyapakShop_V3")
        if ScreenGui then
            local MainMenu = ScreenGui:FindFirstChild("KanyapakMainMenu")
            if MainMenu then
                MainMenu.Visible = not MainMenu.Visible
                print("[MENU] " .. (MainMenu.Visible and "SHOWN" or "HIDDEN"))
            end
        end
    end)
    
    print("[MOBILE] Control buttons added at bottom-left")
end

-- ═══════════════════════════════════════════════════════════════════════════
-- COMPLETION
-- ═══════════════════════════════════════════════════════════════════════════

task.wait(3)

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🎉 KANYAPAK V3.0",
        Text = IsMobile and "Ready! Use 🌾 FARM & ☰ MENU buttons" or "Ready! Click 🛍️ icon or F7",
        Duration = 5
    })
end)

print("\n" .. string.rep("=", 60))
print("✅ KANYAPAK V3.0 - LOADED")
print(string.rep("=", 60))

if IsMobile then
    print("\n📱 MOBILE CONTROLS:")
    print("   🌾 = Toggle Farming (bottom-left)")
    print("   ☰ = Show Menu (bottom-left)")
    print("   Or tap 🛍️ icon (bottom-right)")
else
    print("\n🖱️  CONTROLS:")
    print("   🛍️ = Tap icon to toggle menu")
    print("   F6 = Toggle Farming")
    print("   F7 = Toggle Menu")
end

print("\n" .. string.rep("=", 60) .. "\n")
และอัปเดต UI_Library.lua ตรงส่วนนี้:
เปลี่ยนบรรทัดที่ 73-75:
local FloatingIcon = Instance.new("TextButton")  -- เปลี่ยนจาก Frame เป็น TextButton
FloatingIcon.Name = "FloatingShopIcon"
FloatingIcon.Size = UDim2.new(0, 65, 0, 65)
FloatingIcon.Position = UDim2.new(1, -85, 1, -95)  -- ตรวจสอบว่าไม่ติด UI เกม
FloatingIcon.BackgroundColor3 = Theme.Primary
FloatingIcon.BorderSizePixel = 0
FloatingIcon.Text = "🛍️"
FloatingIcon.TextSize = 32
FloatingIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingIcon.Font = Enum.Font.GothamBold
FloatingIcon.Parent = ScreenGui
FloatingIcon.ZIndex = 500
FloatingIcon.CanQuery = true
FloatingIcon.AutoButtonColor = false

-- เพิ่ม Touch Input
FloatingIcon.TouchTap:Connect(function()
    PulseEffect(FloatingIcon)
    if MenuOpen then
        CloseMenu()
    else
        OpenMenu()
    end
end)

-- เก็บ MouseButton1Click ไว้ด้วย
FloatingIcon.MouseButton1Click:Connect(function()
    PulseEffect(FloatingIcon)
    if MenuOpen then
        CloseMenu()
    else
        OpenMenu()
    end
end)
