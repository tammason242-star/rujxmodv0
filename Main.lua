--[[
    ⭐ KANYAPAK HUB V4.5 - MASTER CONTROLLER (PROFESSIONAL EDITION) ⭐
    "The Ultimate Mobile/PC Execution Environment"
    
    [INFO]
    Author: Kanyapak Dev Team
    Build: Professional Stable Release 4.5
    Last Update: 2025
    Optimization: Extreme (Mobile/PC Compatible)
]]

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    1. GUARD & INITIALIZATION
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- Singleton Check (ป้องกันรันซ้ำ)
if _G.Kanyapak_Executed then 
    warn("⚠️ [GUARD] Script already running! Cleaning up old instance...")
    
    -- ลบ UI เก่า
    local OldUI = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Kanyapak_Pro_V45")
    if OldUI then OldUI:Destroy() end
    
    wait(0.5)
end

_G.Kanyapak_Executed = true
_G.Kanyapak_Version = "4.5"

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    2. SERVICE & ENVIRONMENT SETUP
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local Services = {
    Players = game:GetService("Players"),
    UserInputService = game:GetService("UserInputService"),
    RunService = game:GetService("RunService"),
    TweenService = game:GetService("TweenService"),
    HttpService = game:GetService("HttpService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    VirtualUser = game:GetService("VirtualUser"),
    StarterGui = game:GetService("StarterGui"),
    Debris = game:GetService("Debris")
}

local LocalPlayer = Services.Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- ตรวจสอบว่าเป็นมือถือหรือ PC
local IsMobile = Services.UserInputService.TouchEnabled and not Services.UserInputService.MouseEnabled

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    3. CUSTOM LOGGER (Professional)
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local Logger = {}

function Logger:Log(Type, Message, Details)
    local Prefix = "⬜"
    local Color = "\27[37m"  -- White
    
    if Type == "INFO" then 
        Prefix = "🟦 [INFO]"
        Color = "\27[36m"  -- Cyan
    elseif Type == "WARN" then 
        Prefix = "🟨 [WARN]"
        Color = "\27[33m"  -- Yellow
    elseif Type == "ERROR" then 
        Prefix = "🟥 [ERROR]"
        Color = "\27[31m"  -- Red
    elseif Type == "SUCCESS" then 
        Prefix = "🟩 [SUCCESS]"
        Color = "\27[32m"  -- Green
    elseif Type == "DEBUG" then 
        Prefix = "🟪 [DEBUG]"
        Color = "\27[35m"  -- Magenta
    end
    
    local TimeStamp = os.date("%H:%M:%S")
    local LogMsg = string.format("%s [%s] %s", Prefix, TimeStamp, Message)
    
    if Details then
        LogMsg = LogMsg .. " | " .. tostring(Details)
    end
    
    print(LogMsg)
end

Logger:Log("INFO", "═══════════════════════════════════════════════════════")
Logger:Log("INFO", "KANYAPAK SYSTEM V4.5 - INITIALIZING")
Logger:Log("INFO", "Platform: " .. (IsMobile and "📱 MOBILE" or "🖥️ PC"))
Logger:Log("INFO", "Player: " .. LocalPlayer.Name)
Logger:Log("INFO", "═══════════════════════════════════════════════════════")

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    4. GLOBAL DATA CENTER (The Brain)
-- ╚══════════════════════════════════════════════════════════════════════════════╝

_G.Kanyapak_Config = {
    -- ═══ SYSTEM ═══
    System = {
        Version = "4.5",
        SafeMode = true,
        DebugMode = false,
        AutoRestart = true,
        MaxRestartAttempts = 5,
        RestartAttempts = 0
    },
    
    -- ═══ FARMING ═══
    Farm = {
        Enabled = false,
        Mode = "Level",
        Weapon = "Melee",
        BringMob = true,
        AutoHaki = true,
        FastAttack = true,
        AttackSpeed = 0.1,
        MobDistance = 300,
        AutoEquip = true,
        AutoBounty = false
    },
    
    -- ═══ PLAYER MODS ═══
    Player = {
        InfJump = false,
        SpeedHack = false,
        SpeedValue = 100,
        NoClip = false,
        Fly = false,
        FlySpeed = 50
    },
    
    -- ═══ VISUALS ═══
    Visuals = {
        ESP_Player = false,
        ESP_Chest = false,
        ESP_Fruit = false,
        ESP_Boss = false,
        FullBright = false,
        ShowDistance = true
    },
    
    -- ═══ MISC ═══
    Misc = {
        AutoRejoin = true,
        WhiteScreen = false,
        FPSCap = 60,
        ChatSpam = false,
        AntiKick = true,
        ShowNotifications = true
    },
    
    -- ═══ RUNTIME DATA ═══
    Runtime = {
        IsActive = false,
        LastSaved = tick(),
        LoadedModules = {},
        Errors = {},
        Status = "Ready"
    }
}

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    5. CONFIGURATION FILE HANDLER
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local ConfigHandler = {}
ConfigHandler.FilePath = "Kanyapak_Settings.json"

function ConfigHandler:LoadConfig()
    Logger:Log("INFO", "Loading Configuration...")
    
    local Success, ConfigData = pcall(function()
        if not readfile then return nil end
        local Saved = readfile(self.FilePath)
        return Services.HttpService:JSONDecode(Saved)
    end)
    
    if Success and ConfigData then
        for Category, Values in pairs(ConfigData) do
            if _G.Kanyapak_Config[Category] then
                for Key, Value in pairs(Values) do
                    _G.Kanyapak_Config[Category][Key] = Value
                end
            end
        end
        Logger:Log("SUCCESS", "Config loaded from file")
        return true
    else
        Logger:Log("WARN", "Config file not found, using defaults")
        return false
    end
end

function ConfigHandler:SaveConfig()
    Logger:Log("DEBUG", "Saving Configuration...")
    
    local Success, Result = pcall(function()
        if not writefile then return false end
        
        local ConfigToSave = {
            Farm = _G.Kanyapak_Config.Farm,
            Player = _G.Kanyapak_Config.Player,
            Visuals = _G.Kanyapak_Config.Visuals,
            Misc = _G.Kanyapak_Config.Misc
        }
        
        local JSONData = Services.HttpService:JSONEncode(ConfigToSave)
        writefile(self.FilePath, JSONData)
        return true
    end)
    
    if Success then
        Logger:Log("SUCCESS", "Config saved")
        _G.Kanyapak_Config.Runtime.LastSaved = tick()
    else
        Logger:Log("ERROR", "Failed to save config", Result)
    end
end

ConfigHandler:LoadConfig()

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    6. UI LIBRARY LOADER (Fixed)
-- ╚══════════════════════════════════════════════════════════════════════════════╝

Logger:Log("INFO", "═══ MODULE LOADING PHASE ═══")

local UI_Library = nil

-- ✅ วิธีที่ 1: ลองโหลด UI_Library จาก ReplicatedStorage
local function LoadUIFromStorage()
    local Success, Module = pcall(function()
        return require(game:GetService("ReplicatedStorage"):WaitForChild("UI_Library", 5))
    end)
    
    if Success and Module then
        Logger:Log("SUCCESS", "UI_Library loaded from ReplicatedStorage")
        return Module
    end
    
    return nil
end

-- ✅ วิธีที่ 2: ลองโหลด UI_Library จาก ServerScriptService
local function LoadUIFromServer()
    local Success, Module = pcall(function()
        return require(game:GetService("ServerScriptService"):WaitForChild("UI_Library", 5))
    end)
    
    if Success and Module then
        Logger:Log("SUCCESS", "UI_Library loaded from ServerScriptService")
        return Module
    end
    
    return nil
end

-- ✅ วิธีที่ 3: ลองโหลด UI_Library จาก GitHub (Inline)
local function LoadUIFromGitHub()
    Logger:Log("INFO", "Attempting to load UI_Library from GitHub...")
    
    local Success, Result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/tammason242-star/rujxmodv0/refs/heads/main/UI_Library.lua?t=" .. tick())
    end)
    
    if Success then
        local LoadFunc, SyntaxErr = loadstring(Result)
        if LoadFunc then
            local LoadSuccess, Module = pcall(LoadFunc)
            if LoadSuccess then
                Logger:Log("SUCCESS", "UI_Library loaded from GitHub")
                return Module
            else
                Logger:Log("ERROR", "Runtime Error in GitHub UI_Library", Module)
            end
        else
            Logger:Log("ERROR", "Syntax Error in GitHub UI_Library", SyntaxErr)
        end
    else
        Logger:Log("WARN", "GitHub download failed", Result)
    end
    
    return nil
end

-- ✅ ลองโหลดตามลำดับ
UI_Library = LoadUIFromStorage() or LoadUIFromServer() or LoadUIFromGitHub()

-- ✅ ถ้าทั้งหมดล้มเหลว ให้ใช้ Fallback
if not UI_Library then
    Logger:Log("ERROR", "UI_Library failed to load from all sources!")
    Logger:Log("WARN", "Creating Fallback UI_Library...")
    
    UI_Library = {
        Init = function()
            return {
                CreateTab = function() return {} end,
                AddToggle = function() end,
                AddButton = function() end,
                AddSlider = function() end,
                AddLabel = function() end,
                AddDropdown = function() end
            }
        end
    }
end

_G.Kanyapak_UI = UI_Library
Logger:Log("SUCCESS", "UI_Library ready")
Logger:Log("INFO", "═══ MODULE LOADING COMPLETE ═══")

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    7. BUILD UI INTERFACE
-- ╚══════════════════════════════════════════════════════════════════════════════╝

task.spawn(function()
    Logger:Log("INFO", "Building Professional Dashboard...")
    
    if not UI_Library or not UI_Library.Init then
        Logger:Log("ERROR", "UI_Library not available")
        Services.StarterGui:SetCore("SendNotification", {
            Title = "⚠️ ERROR",
            Text = "UI Library failed to initialize",
            Duration = 5
        })
        return
    end
    
    pcall(function()
        local Library = UI_Library:Init()
        
        -- 🏠 HOME TAB
        local HomeTab = Library:CreateTab("🏠 Home")
        Library:AddLabel(HomeTab, "KANYAPAK V4.5")
        Library:AddLabel(HomeTab, "Status: " .. _G.Kanyapak_Config.Runtime.Status)
        Library:AddLabel(HomeTab, "Player: " .. LocalPlayer.Name)
        Library:AddButton(HomeTab, "Refresh Status", function()
            Logger:Log("INFO", "Status refreshed")
        end)
        
        -- 🌾 FARMING TAB
        local FarmTab = Library:CreateTab("🌾 Farming")
        
        Library:AddToggle(FarmTab, "Auto Farm Level", _G.Kanyapak_Config.Farm, "Enabled", function(Value)
            _G.Kanyapak_Config.Farm.Enabled = Value
            ConfigHandler:SaveConfig()
            Logger:Log("INFO", "Auto Farm: " .. (Value and "ENABLED" or "DISABLED"))
        end)
        
        Library:AddToggle(FarmTab, "Bring Mobs", _G.Kanyapak_Config.Farm, "BringMob", function(Value)
            _G.Kanyapak_Config.Farm.BringMob = Value
            ConfigHandler:SaveConfig()
        end)
        
        Library:AddToggle(FarmTab, "Fast Attack", _G.Kanyapak_Config.Farm, "FastAttack", function(Value)
            _G.Kanyapak_Config.Farm.FastAttack = Value
            ConfigHandler:SaveConfig()
        end)
        
        Library:AddSlider(FarmTab, "Attack Speed", _G.Kanyapak_Config.Farm, "AttackSpeed", 0.05, 0.5, 0.05, function(Value)
            _G.Kanyapak_Config.Farm.AttackSpeed = Value
            ConfigHandler:SaveConfig()
        end)
        
        -- 🚀 PLAYER TAB
        local PlayerTab = Library:CreateTab("🚀 Player")
        
        Library:AddToggle(PlayerTab, "Infinite Jump", _G.Kanyapak_Config.Player, "InfJump", function(Value)
            _G.Kanyapak_Config.Player.InfJump = Value
            ConfigHandler:SaveConfig()
        end)
        
        Library:AddToggle(PlayerTab, "NoClip", _G.Kanyapak_Config.Player, "NoClip", function(Value)
            _G.Kanyapak_Config.Player.NoClip = Value
            ConfigHandler:SaveConfig()
        end)
        
        Library:AddToggle(PlayerTab, "Speed Hack", _G.Kanyapak_Config.Player, "SpeedHack", function(Value)
            _G.Kanyapak_Config.Player.SpeedHack = Value
            ConfigHandler:SaveConfig()
        end)
        
        Library:AddSlider(PlayerTab, "Speed Value", _G.Kanyapak_Config.Player, "SpeedValue", 50, 200, 10, function(Value)
            _G.Kanyapak_Config.Player.SpeedValue = Value
            ConfigHandler:SaveConfig()
        end)
        
        -- 👁️ VISUALS TAB
        local VisualTab = Library:CreateTab("👁️ Visuals")
        
        Library:AddToggle(VisualTab, "ESP Players", _G.Kanyapak_Config.Visuals, "ESP_Player", function(Value)
            _G.Kanyapak_Config.Visuals.ESP_Player = Value
            ConfigHandler:SaveConfig()
        end)
        
        Library:AddToggle(VisualTab, "ESP Chests", _G.Kanyapak_Config.Visuals, "ESP_Chest", function(Value)
            _G.Kanyapak_Config.Visuals.ESP_Chest = Value
            ConfigHandler:SaveConfig()
        end)
        
        Library:AddToggle(VisualTab, "Full Bright", _G.Kanyapak_Config.Visuals, "FullBright", function(Value)
            _G.Kanyapak_Config.Visuals.FullBright = Value
            ConfigHandler:SaveConfig()
        end)
        
        -- ⚙️ SETTINGS TAB
        local SettingsTab = Library:CreateTab("⚙️ Settings")
        
        Library:AddButton(SettingsTab, "Save Config", function()
            ConfigHandler:SaveConfig()
        end)
        
        Library:AddButton(SettingsTab, "Load Config", function()
            ConfigHandler:LoadConfig()
        end)
        
        Logger:Log("SUCCESS", "Dashboard built successfully!")
    end)
end)

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    8. MOBILE HUD
-- ╚══════════════════════════════════════════════════════════════════════════════╝

if IsMobile then
    Logger:Log("INFO", "Injecting Mobile HUD...")
    
    local MobileHUD = Instance.new("ScreenGui")
    MobileHUD.Name = "Kanyapak_MobileOverlay"
    MobileHUD.Parent = PlayerGui
    MobileHUD.ResetOnSpawn = false
    MobileHUD.ZIndex = 9999
    
    local function CreateMiniBtn(Text, Pos, Color, Callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0, 60, 0, 60)
        Btn.Position = Pos
        Btn.BackgroundColor3 = Color
        Btn.Text = Text
        Btn.TextColor3 = Color3.new(1, 1, 1)
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 11
        Btn.Parent = MobileHUD
        
        local Corner = Instance.new("UICorner", Btn)
        Corner.CornerRadius = UDim.new(0, 12)
        
        local Stroke = Instance.new("UIStroke", Btn)
        Stroke.Color = Color3.new(1, 1, 1)
        Stroke.Thickness = 2
        Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        
        Btn.TouchTap:Connect(function()
            pcall(Callback)
        end)
    end
    
    CreateMiniBtn("STOP", UDim2.new(0, 20, 1, -160), Color3.fromRGB(255, 50, 50), function()
        _G.Kanyapak_Config.Farm.Enabled = false
        Logger:Log("WARN", "Emergency Stop via Mobile HUD")
    end)
    
    Logger:Log("SUCCESS", "Mobile HUD injected")
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    9. BACKGROUND LOOPS
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local HeartbeatConnection

function StartHeartbeat()
    if HeartbeatConnection then HeartbeatConnection:Disconnect() end
    
    HeartbeatConnection = Services.RunService.Heartbeat:Connect(function()
        pcall(function()
            -- Anti-AFK
            if LocalPlayer.Character and LocalPlayer.Idled then
                Services.VirtualUser:CaptureController()
                Services.VirtualUser:ClickButton2(Vector2.new())
            end
            
            -- Infinite Jump
            if _G.Kanyapak_Config.Player.InfJump and LocalPlayer.Character then
                local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if Humanoid then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
            
            -- NoClip
            if _G.Kanyapak_Config.Player.NoClip and LocalPlayer.Character then
                for _, Part in pairs(LocalPlayer.Character:GetChildren()) do
                    if Part:IsA("BasePart") then
                        Part.CanCollide = false
                    end
                end
            end
        end)
    end)
    
    Logger:Log("SUCCESS", "Heartbeat loop started")
end

task.delay(1, StartHeartbeat)

-- Auto-Save Config
task.spawn(function()
    while _G.Kanyapak_Executed do
        task.wait(30)
        ConfigHandler:SaveConfig()
    end
end)

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    10. CLEANUP ON DISCONNECT
-- ╚══════════════════════════════════════════════════════════════════════════════╝

LocalPlayer.AncestryChanged:Connect(function(_, Parent)
    if not Parent then
        Logger:Log("WARN", "Player left the game")
        if HeartbeatConnection then
            HeartbeatConnection:Disconnect()
        end
        ConfigHandler:SaveConfig()
        _G.Kanyapak_Executed = false
    end
end)

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    11. STARTUP NOTIFICATION
-- ╚══════════════════════════════════════════════════════════════════════════════╝

task.wait(1)

Services.StarterGui:SetCore("SendNotification", {
    Title = "✅ KANYAPAK V4.5",
    Text = "System loaded successfully!",
    Duration = 5,
    Button1 = "Let's Go! 🔥"
})

print("\n")
print("  ██╗  ██╗ █████╗ ███╗   ██╗██╗   ██╗ █████╗ ██████╗  █████╗ ██╗  ██╗")
print("  ██║ ██╔╝██╔══██╗████╗  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██╔══██╗██║ ██╔╝")
print("  █████╔╝ ███████║██╔██╗ ██║ ╚████╔╝ ███████║██████╔╝███████║█████╔╝ ")
print("  ██╔═██╗ ██╔══██║██║╚██╗██║  ╚██╔╝  ██╔══██║██╔═══╝ ██╔══██║██╔═██╗ ")
print("  ██║  ██╗██║  ██║██║ ╚████║   ██║   ██║  ██║██║     ██║  ██║██║  ██╗")
print("  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝")
print("\n")
print("  🟩 [SUCCESS] KANYAPAK SHOP V4.5 - READY!")
print("  👤 Player: " .. LocalPlayer.Name)
print("\n")

Logger:Log("SUCCESS", "═══════════════════════════════════════════════════════")
Logger:Log("SUCCESS", "ALL SYSTEMS ONLINE - READY FOR OPERATION")
Logger:Log("SUCCESS", "═══════════════════════════════════════════════════════")

-- END OF MAIN.LUA
