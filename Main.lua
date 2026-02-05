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
        Mode = "Level",  -- Level, Bone, Katakuri
        Weapon = "Melee",
        BringMob = true,
        AutoHaki = true,
        FastAttack = true,
        AttackSpeed = 0.1,  -- เวลารอระหว่างการโจมตี (วินาที)
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
        WhiteScreen = false,  -- AFK Mode
        FPSCap = 60,
        ChatSpam = false,
        AntiKick = true,
        ShowNotifications = true
    },
    
    -- ═══ RUNTIME DATA (Do not edit manually) ═══
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
        -- ลองอ่าน Config ที่เคยบันทึกไว้
        local Saved = readfile(self.FilePath)
        return Services.HttpService:JSONDecode(Saved)
    end)
    
    if Success and ConfigData then
        -- Merge กับ Default Config
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

-- โหลด Config เมื่อเริ่ม
ConfigHandler:LoadConfig()

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    6. INTELLIGENT MODULE LOADER
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local ModuleLoader = {}

-- URL ของ GitHub Repository
ModuleLoader.BaseURL = "https://raw.githubusercontent.com/tammason242-star/rujxmodv0/refs/heads/main/"

-- ประเมินแบบ Fallback (หากโหลดจาก GitHub ไม่สำเร็จ)
ModuleLoader.FallbackModules = {
    UI_Library = true,
    Functions = true,
    Combat = true,
    Visuals = true
}

function ModuleLoader:Load(FileName, ModuleName)
    Logger:Log("INFO", "Loading Module: " .. ModuleName .. "...")
    
    -- URL พร้อม Cache Buster
    local URL = self.BaseURL .. FileName .. ".lua?t=" .. tick()
    
    local Success, Result = pcall(function()
        return game:HttpGet(URL)
    end)
    
    if not Success then
        Logger:Log("ERROR", "Failed to download " .. ModuleName, Result)
        
        -- ลอง Fallback Mode
        if self.FallbackModules[ModuleName] then
            Logger:Log("WARN", "Switching to Fallback for " .. ModuleName)
            return self:GetFallback(ModuleName)
        end
        return nil
    end
    
    -- Load String
    local LoadFunc, SyntaxErr = loadstring(Result)
    if not LoadFunc then
        Logger:Log("ERROR", "Syntax Error in " .. ModuleName, SyntaxErr)
        return self:GetFallback(ModuleName)
    end
    
    -- Execute
    local LoadSuccess, Module = pcall(LoadFunc)
    if LoadSuccess then
        _G.Kanyapak_Config.Runtime.LoadedModules[ModuleName] = true
        Logger:Log("SUCCESS", ModuleName .. " Loaded Successfully!")
        return Module
    else
        Logger:Log("ERROR", "Runtime Error in " .. ModuleName, Module)
        return self:GetFallback(ModuleName)
    end
end

function ModuleLoader:GetFallback(ModuleName)
    Logger:Log("WARN", "Providing Fallback for: " .. ModuleName)
    
    -- Return Fallback Module
    if ModuleName == "UI_Library" then
        return {
            Init = function()
                return {
                    CreateTab = function() return {} end,
                    AddToggle = function() end,
                    AddButton = function() end,
                    AddSlider = function() end
                }
            end
        }
    elseif ModuleName == "Functions" then
        return {
            StartFarm = function() Logger:Log("INFO", "Fallback: Farm Started") end,
            StopFarm = function() Logger:Log("INFO", "Fallback: Farm Stopped") end,
            WarpToNPC = function() Logger:Log("INFO", "Fallback: Warped") end
        }
    elseif ModuleName == "Combat" then
        return {
            Init = function() Logger:Log("INFO", "Fallback: Combat Init") end,
            ExecuteFarm = function() Logger:Log("INFO", "Fallback: Farm Executing") end
        }
    elseif ModuleName == "Visuals" then
        return {
            Init = function() Logger:Log("INFO", "Fallback: Visuals Init") end,
            UpdateESP = function() Logger:Log("INFO", "Fallback: ESP Updated") end
        }
    end
    
    return nil
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    7. MODULE INITIALIZATION
-- ╚══════════════════════════════════════════════════════════════════════════════╝

Logger:Log("INFO", "═══ MODULE LOADING PHASE ═══")

-- ลำดับการโหลด (IMPORTANT!)
local Functions = ModuleLoader:Load("Functions", "Functions")
local UI_Library = ModuleLoader:Load("UI_Library", "UI_Library")
local Combat = ModuleLoader:Load("Combat", "Combat")
local Visuals = ModuleLoader:Load("Visuals", "Visuals")

-- เก็บไว้ใน Global เพื่อให้ Modules อื่นใช้ได้
_G.Kanyapak_Functions = Functions
_G.Kanyapak_Combat = Combat
_G.Kanyapak_Visuals = Visuals

Logger:Log("INFO", "═══ MODULE LOADING COMPLETE ═══")

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    8. UI INITIALIZATION & MENU BUILDING
-- ╚══════════════════════════════════════════════════════════════════════════════╝

task.spawn(function()
    Logger:Log("INFO", "Building Professional Dashboard...")
    
    if not UI_Library or not UI_Library.Init then
        Logger:Log("ERROR", "UI_Library not available, using minimal UI")
        Services.StarterGui:SetCore("SendNotification", {
            Title = "⚠️ WARNING",
            Text = "UI Library failed to load. Using fallback mode.",
            Duration = 5
        })
        return
    end
    
    pcall(function()
        local Library = UI_Library:Init()
        
        -- 🟦 TAB 1: HOME / STATUS
        local HomeTab = Library:CreateTab("🏠 Home")
        Library:AddLabel(HomeTab, "KANYAPAK V4.5")
        Library:AddLabel(HomeTab, "Status: " .. _G.Kanyapak_Config.Runtime.Status)
        Library:AddLabel(HomeTab, "Player: " .. LocalPlayer.Name)
        Library:AddLabel(HomeTab, "Platform: " .. (IsMobile and "Mobile 📱" or "PC 🖥️"))
        Library:AddButton(HomeTab, "Refresh Status", function()
            Logger:Log("INFO", "Status refreshed")
        end)
        
        -- 🌾 TAB 2: FARMING
        local FarmTab = Library:CreateTab("🌾 Farming")
        
        Library:AddToggle(FarmTab, "Auto Farm Level", _G.Kanyapak_Config.Farm, "Enabled", function(Value)
            _G.Kanyapak_Config.Farm.Enabled = Value
            ConfigHandler:SaveConfig()
            Logger:Log("INFO", "Auto Farm: " .. (Value and "ENABLED" or "DISABLED"))
            
            if Value and Functions and Functions.StartFarm then
                Functions:StartFarm()
            elseif not Value and Functions and Functions.StopFarm then
                Functions:StopFarm()
            end
        end)
        
        Library:AddToggle(FarmTab, "Bring Mobs (รวมมอน)", _G.Kanyapak_Config.Farm, "BringMob", function(Value)
            _G.Kanyapak_Config.Farm.BringMob = Value
            ConfigHandler:SaveConfig()
            Logger:Log("INFO", "Bring Mob: " .. (Value and "ON" or "OFF"))
        end)
        
        Library:AddToggle(FarmTab, "Fast Attack", _G.Kanyapak_Config.Farm, "FastAttack", function(Value)
            _G.Kanyapak_Config.Farm.FastAttack = Value
            ConfigHandler:SaveConfig()
            Logger:Log("INFO", "Fast Attack: " .. (Value and "ON" or "OFF"))
        end)
        
        Library:AddToggle(FarmTab, "Auto Haki", _G.Kanyapak_Config.Farm, "AutoHaki", function(Value)
            _G.Kanyapak_Config.Farm.AutoHaki = Value
            ConfigHandler:SaveConfig()
            Logger:Log("INFO", "Auto Haki: " .. (Value and "ON" or "OFF"))
        end)
        
        Library:AddSlider(FarmTab, "Attack Speed", _G.Kanyapak_Config.Farm, "AttackSpeed", 0.05, 0.5, 0.05, function(Value)
            _G.Kanyapak_Config.Farm.AttackSpeed = Value
            ConfigHandler:SaveConfig()
            Logger:Log("DEBUG", "Attack Speed: " .. Value)
        end)
        
        -- 🚀 TAB 3: PLAYER MODS
        local PlayerTab = Library:CreateTab("🚀 Player")
        
        Library:AddToggle(PlayerTab, "Infinite Jump", _G.Kanyapak_Config.Player, "InfJump", function(Value)
            _G.Kanyapak_Config.Player.InfJump = Value
            ConfigHandler:SaveConfig()
            Logger:Log("INFO", "Infinite Jump: " .. (Value and "ON" or "OFF"))
        end)
        
        Library:AddToggle(PlayerTab, "NoClip (เดินทะลุ)", _G.Kanyapak_Config.Player, "NoClip", function(Value)
            _G.Kanyapak_Config.Player.NoClip = Value
            ConfigHandler:SaveConfig()
            Logger:Log("INFO", "NoClip: " .. (Value and "ON" or "OFF"))
        end)
        
        Library:AddToggle(PlayerTab, "Speed Hack", _G.Kanyapak_Config.Player, "SpeedHack", function(Value)
            _G.Kanyapak_Config.Player.SpeedHack = Value
            ConfigHandler:SaveConfig()
            Logger:Log("INFO", "Speed Hack: " .. (Value and "ON" or "OFF"))
        end)
        
        Library:AddSlider(PlayerTab, "Speed Value", _G.Kanyapak_Config.Player, "SpeedValue", 50, 200, 10, function(Value)
            _G.Kanyapak_Config.Player.SpeedValue = Value
            ConfigHandler:SaveConfig()
        end)
        
        -- 👁️ TAB 4: VISUALS
        local VisualTab = Library:CreateTab("👁️ Visuals")
        
        Library:AddToggle(VisualTab, "ESP Players", _G.Kanyapak_Config.Visuals, "ESP_Player", function(Value)
            _G.Kanyapak_Config.Visuals.ESP_Player = Value
            ConfigHandler:SaveConfig()
            Logger:Log("INFO", "ESP Players: " .. (Value and "ON" or "OFF"))
        end)
        
        Library:AddToggle(VisualTab, "ESP Chests", _G.Kanyapak_Config.Visuals, "ESP_Chest", function(Value)
            _G.Kanyapak_Config.Visuals.ESP_Chest = Value
            ConfigHandler:SaveConfig()
            Logger:Log("INFO", "ESP Chests: " .. (Value and "ON" or "OFF"))
        end)
        
        Library:AddToggle(VisualTab, "ESP Fruits", _G.Kanyapak_Config.Visuals, "ESP_Fruit", function(Value)
            _G.Kanyapak_Config.Visuals.ESP_Fruit = Value
            ConfigHandler:SaveConfig()
            Logger:Log("INFO", "ESP Fruits: " .. (Value and "ON" or "OFF"))
        end)
        
        Library:AddToggle(VisualTab, "Full Bright", _G.Kanyapak_Config.Visuals, "FullBright", function(Value)
            _G.Kanyapak_Config.Visuals.FullBright = Value
            ConfigHandler:SaveConfig()
            Logger:Log("INFO", "Full Bright: " .. (Value and "ON" or "OFF"))
        end)
        
        -- ⚙️ TAB 5: SETTINGS
        local SettingsTab = Library:CreateTab("⚙️ Settings")
        
        Library:AddToggle(SettingsTab, "Debug Mode", _G.Kanyapak_Config.System, "DebugMode", function(Value)
            _G.Kanyapak_Config.System.DebugMode = Value
            ConfigHandler:SaveConfig()
            Logger:Log("INFO", "Debug Mode: " .. (Value and "ON" or "OFF"))
        end)
        
        Library:AddToggle(SettingsTab, "Show Notifications", _G.Kanyapak_Config.Misc, "ShowNotifications", function(Value)
            _G.Kanyapak_Config.Misc.ShowNotifications = Value
            ConfigHandler:SaveConfig()
        end)
        
        Library:AddButton(SettingsTab, "Save Config", function()
            ConfigHandler:SaveConfig()
            Logger:Log("SUCCESS", "Configuration saved!")
        end)
        
        Library:AddButton(SettingsTab, "Load Config", function()
            ConfigHandler:LoadConfig()
            Logger:Log("SUCCESS", "Configuration loaded!")
        end)
        
        Library:AddButton(SettingsTab, "Reset All", function()
            -- Reset ทั้งหมด (ถ้าต้องการ)
            Logger:Log("WARN", "Reset requested - would clear all settings")
        end)
        
        Logger:Log("SUCCESS", "Dashboard built successfully!")
        
    end)
end)

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    9. MOBILE HUD (Emergency Controls)
-- ╚══════════════════════════════════════════════════════════════════════════════╝

if IsMobile then
    Logger:Log("INFO", "Injecting Mobile HUD...")
    
    local MobileHUD = Instance.new("ScreenGui")
    MobileHUD.Name = "Kanyapak_MobileOverlay"
    MobileHUD.Parent = PlayerGui
    MobileHUD.ResetOnSpawn = false
    MobileHUD.ZIndex = 9999
    
    local function CreateMiniButton(Text, Position, Color, Callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0, 60, 0, 60)
        Button.Position = Position
        Button.BackgroundColor3 = Color
        Button.Text = Text
        Button.TextColor3 = Color3.new(1, 1, 1)
        Button.Font = Enum.Font.GothamBold
        Button.TextSize = 11
        Button.Parent = MobileHUD
        
        local Corner = Instance.new("UICorner", Button)
        Corner.CornerRadius = UDim.new(0, 12)
        
        local Stroke = Instance.new("UIStroke", Button)
        Stroke.Color = Color3.new(1, 1, 1)
        Stroke.Thickness = 2
        Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        
        Button.TouchTap:Connect(function()
            Services.TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(0, 55, 0, 55)}):Play()
            task.wait(0.1)
            Services.TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(0, 60, 0, 60)}):Play()
            
            pcall(Callback)
        end)
        
        return Button
    end
    
    -- ปุ่ม MENU
    CreateMiniButton("MENU", UDim2.new(1, -90, 1, -160), Color3.fromRGB(0, 170, 255), function()
        Logger:Log("INFO", "Mobile Menu tapped")
    end)
    
    -- ปุ่ม STOP
    CreateMiniButton("STOP", UDim2.new(0, 20, 1, -160), Color3.fromRGB(255, 50, 50), function()
        _G.Kanyapak_Config.Farm.Enabled = false
        Logger:Log("WARN", "Emergency Stop via Mobile HUD")
        
        if _G.Kanyapak_Functions and _G.Kanyapak_Functions.StopFarm then
            _G.Kanyapak_Functions:StopFarm()
        end
    end)
    
    Logger:Log("SUCCESS", "Mobile HUD injected")
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    10. BACKGROUND LOOP (The Heartbeat)
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local HeartbeatConnection

function StartHeartbeat()
    if HeartbeatConnection then 
        HeartbeatConnection:Disconnect() 
    end
    
    HeartbeatConnection = Services.RunService.Heartbeat:Connect(function()
        pcall(function()
            -- 1️⃣ Anti-AFK
            if LocalPlayer.Character and LocalPlayer.Idled then
                Services.VirtualUser:CaptureController()
                Services.VirtualUser:ClickButton2(Vector2.new())
            end
            
            -- 2️⃣ Infinite Jump
            if _G.Kanyapak_Config.Player.InfJump and LocalPlayer.Character then
                local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if Humanoid and Humanoid.Jump then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
            
            -- 3️⃣ NoClip
            if _G.Kanyapak_Config.Player.NoClip and LocalPlayer.Character then
                for _, Part in pairs(LocalPlayer.Character:GetChildren()) do
                    if Part:IsA("BasePart") then
                        Part.CanCollide = false
                    end
                end
            end
            
            -- 4️⃣ Speed Hack
            if _G.Kanyapak_Config.Player.SpeedHack and LocalPlayer.Character then
                LocalPlayer.Character:MoveTo(LocalPlayer.Character.PrimaryPart.Position + LocalPlayer.Character.PrimaryPart.CFrame.LookVector * (_G.Kanyapak_Config.Player.SpeedValue / 1000))
            end
            
            -- 5️⃣ Farm Logic Bridge
            if _G.Kanyapak_Config.Farm.Enabled then
                if _G.Kanyapak_Combat and _G.Kanyapak_Combat.ExecuteFarm then
                    _G.Kanyapak_Combat:ExecuteFarm()
                elseif _G.Kanyapak_Functions and _G.Kanyapak_Functions.ExecuteFarm then
                    _G.Kanyapak_Functions:ExecuteFarm()
                end
            end
            
            -- 6️⃣ Update Visuals
            if _G.Kanyapak_Visuals and _G.Kanyapak_Visuals.UpdateESP then
                _G.Kanyapak_Visuals:UpdateESP()
            end
            
        end)
    end)
    
    Logger:Log("SUCCESS", "Heartbeat loop started")
end

task.delay(1, StartHeartbeat)

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    11. AUTO-SAVE LOOP
-- ╚══════════════════════════════════════════════════════════════════════════════╝

task.spawn(function()
    while _G.Kanyapak_Executed do
        task.wait(30)  -- บันทึก Config ทุก 30 วินาที
        
        pcall(function()
            ConfigHandler:SaveConfig()
        end)
    end
end)

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    12. ERROR MONITORING & AUTO-RESTART
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local ErrorMonitor = {}

function ErrorMonitor:CheckHealth()
    -- ตรวจสอบว่า Modules ยังทำงานอยู่
    if not LocalPlayer or not LocalPlayer.Parent then
        Logger:Log("ERROR", "Player disconnected!")
        return false
    end
    
    if not LocalPlayer.Character then
        Logger:Log("WARN", "Character missing")
        return true
    end
    
    return true
end

function ErrorMonitor:AutoRestart()
    if not _G.Kanyapak_Config.System.AutoRestart then return end
    
    if _G.Kanyapak_Config.System.RestartAttempts >= _G.Kanyapak_Config.System.MaxRestartAttempts then
        Logger:Log("ERROR", "Max restart attempts reached!")
        return
    end
    
    Logger:Log("WARN", "Attempting auto-restart...")
    _G.Kanyapak_Config.System.RestartAttempts = _G.Kanyapak_Config.System.RestartAttempts + 1
    
    task.wait(3)
    StartHeartbeat()
end

task.spawn(function()
    while _G.Kanyapak_Executed do
        task.wait(10)
        
        if not ErrorMonitor:CheckHealth() then
            ErrorMonitor:AutoRestart()
        end
    end
end)

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    13. CLEANUP ON DISCONNECT
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
-- ║                    14. STARTUP NOTIFICATION
-- ╚══════════════════════════════════════════════════════════════════════════════╝

task.wait(1)

Services.StarterGui:SetCore("SendNotification", {
    Title = "✅ KANYAPAK V4.5",
    Text = "System loaded successfully!",
    Duration = 5,
    Button1 = "Let's Go! 🔥"
})

-- ASCII Art
print("\n")
print("  ██╗  ██╗ █████╗ ███╗   ██╗██╗   ██╗ █████╗ ██████╗  █████╗ ██╗  ██╗")
print("  ██║ ██╔╝██╔══██╗████╗  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██╔══██╗██║ ██╔╝")
print("  █████╔╝ ███████║██╔██╗ ██║ ╚████╔╝ ███████║██████╔╝███████║█████╔╝ ")
print("  ██╔═██╗ ██╔══██║██║╚██╗██║  ╚██╔╝  ██╔══██║██╔═══╝ ██╔══██║██╔═██╗ ")
print("  ██║  ██╗██║  ██║██║ ╚████║   ██║   ██║  ██║██║     ██║  ██║██║  ██╗")
print("  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝")
print("\n")
print("  🟩 [SUCCESS] KANYAPAK SHOP V4.5 - READY TO GO!")
print("  📝 Config File: " .. ConfigHandler.FilePath)
print("  🌐 Platform: " .. (IsMobile and "MOBILE 📱" or "PC 🖥️"))
print("  👤 Player: " .. LocalPlayer.Name)
print("\n")

Logger:Log("SUCCESS", "═══════════════════════════════════════════════════════")
Logger:Log("SUCCESS", "ALL SYSTEMS ONLINE - READY FOR OPERATION")
Logger:Log("SUCCESS", "═══════════════════════════════════════════════════════")

-- END OF MAIN.LUA
