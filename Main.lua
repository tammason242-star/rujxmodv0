--[[
    ⭐ KANYAPAK HUB V4.0 - MASTER CONTROLLER ⭐
    "The Ultimate Mobile Execution Environment"
    
    [INFO]
    Author: Kanyapak Dev Team
    Build: Stable Release 4.0
    Optimization: Extreme (Mobile/PC)
]]

-- -------------------------------------------------------------------------
-- 1. SECURITY & ENVIRONMENT SETUP
-- -------------------------------------------------------------------------

if _G.Kanyapak_Executed then 
    warn("⚠️ [SYSTEM] Script is already running!")
    return 
end
_G.Kanyapak_Executed = true

local Services = {
    Players = game:GetService("Players"),
    UserInputService = game:GetService("UserInputService"),
    RunService = game:GetService("RunService"),
    TweenService = game:GetService("TweenService"),
    HttpService = game:GetService("HttpService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    VirtualUser = game:GetService("VirtualUser"),
    StarterGui = game:GetService("StarterGui")
}

local LocalPlayer = Services.Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local IsMobile = Services.UserInputService.TouchEnabled and not Services.UserInputService.MouseEnabled

-- Custom Logger
local function Log(Type, Msg)
    local Prefix = "⬜"
    if Type == "INFO" then Prefix = "🟦 [INFO]" 
    elseif Type == "WARN" then Prefix = "🟨 [WARN]"
    elseif Type == "ERROR" then Prefix = "🟥 [ERROR]"
    elseif Type == "SUCCESS" then Prefix = "🟩 [SUCCESS]" end
    print(string.format("%s %s", Prefix, Msg))
end

Log("INFO", "Initializing KANYAPAK SYSTEM V4.0...")
Log("INFO", "Platform: " .. (IsMobile and "Mobile 📱" or "PC 🖥️"))

-- -------------------------------------------------------------------------
-- 2. GLOBAL CONFIGURATION (DATA CENTER)
-- -------------------------------------------------------------------------

_G.Zenith_Data = {
    User = LocalPlayer.Name,
    Version = "4.0",
    SafeMode = true,
    
    -- การตั้งค่าทั้งหมดจะถูกควบคุมจากตรงนี้
    Config = {
        Farm = {
            Enabled = false,
            Mode = "Level", -- Level, Bone, Katakuri
            Weapon = "Melee",
            BringMob = true,
            AutoHaki = true,
            FastAttack = true,
            MobDistance = 300
        },
        Player = {
            InfJump = false,
            SpeedHack = false,
            SpeedVal = 100,
            NoClip = false,
            Fly = false
        },
        Visuals = {
            ESP_Player = false,
            ESP_Chest = false,
            ESP_Fruit = false,
            FullBright = false
        },
        Misc = {
            AutoRejoin = true,
            WhiteScreen = false, -- AFK Mode
            FPSCap = 60
        }
    },
    
    -- Runtime Cache (ห้ามแตะต้อง)
    Runtime = {
        Target = nil,
        CurrentQuest = nil,
        LoadedModules = {}
    }
}

-- -------------------------------------------------------------------------
-- 3. INTELLIGENT MODULE LOADER
-- -------------------------------------------------------------------------

local RepoURL = "https://raw.githubusercontent.com/tammason242-star/rujxmodv0/refs/heads/main/"

local function LoadComponent(FileName, ModuleName)
    Log("INFO", "Fetching module: " .. ModuleName .. "...")
    
    -- ใส่ ?t=tick() เพื่อแก้ปัญหา GitHub Cache (สำคัญมาก)
    local Url = RepoURL .. FileName .. ".lua?t=" .. tick()
    
    local Success, Result = pcall(function()
        return game:HttpGet(Url)
    end)

    if Success then
        local LoadFn, Err = loadstring(Result)
        if LoadFn then
            local Module = LoadFn()
            _G.Zenith_Data.Runtime.LoadedModules[ModuleName] = true
            Log("SUCCESS", ModuleName .. " Loaded!")
            return Module
        else
            Log("ERROR", "Syntax Error in " .. ModuleName .. ": " .. tostring(Err))
            return nil
        end
    else
        Log("ERROR", "Failed to download " .. ModuleName .. " (Check GitHub Link)")
        return nil
    end
end

-- -------------------------------------------------------------------------
-- 4. SYSTEM INITIALIZATION (The Core)
-- -------------------------------------------------------------------------

task.spawn(function()
    -- A. Load Helper Functions
    -- local Funcs = LoadComponent("Functions", "Functions")
    
    -- B. Load UI Library (สำคัญที่สุด)
    local UI = LoadComponent("UI_Library", "UI_Library")
    
    if UI and UI.Init then
        Log("INFO", "Building Professional Dashboard...")
        
        -- เริ่มสร้างหน้าจอ UI
        local Library = UI:Init()
        
        -- [[ 1. FARMING TAB ]]
        local FarmTab = Library:CreateTab("🌾 Farming")
        
        Library:AddToggle(FarmTab, "Auto Farm Level", _G.Zenith_Data.Config.Farm, "Enabled")
        Library:AddToggle(FarmTab, "Bring Mobs (รวมมอน)", _G.Zenith_Data.Config.Farm, "BringMob")
        Library:AddToggle(FarmTab, "Fast Attack", _G.Zenith_Data.Config.Farm, "FastAttack")
        Library:AddToggle(FarmTab, "Auto Haki", _G.Zenith_Data.Config.Farm, "AutoHaki")
        
        -- [[ 2. PLAYER TAB ]]
        local PlayerTab = Library:CreateTab("🚀 Player")
        
        Library:AddToggle(PlayerTab, "Infinite Jump", _G.Zenith_Data.Config.Player, "InfJump")
        Library:AddToggle(PlayerTab, "NoClip (เดินทะลุ)", _G.Zenith_Data.Config.Player, "NoClip")
        Library:AddToggle(PlayerTab, "Speed Hack", _G.Zenith_Data.Config.Player, "SpeedHack")
        
        -- [[ 3. VISUALS TAB ]]
        local VisualTab = Library:CreateTab("👁️ Visuals")
        
        Library:AddToggle(VisualTab, "ESP Players", _G.Zenith_Data.Config.Visuals, "ESP_Player")
        Library:AddToggle(VisualTab, "ESP Chests", _G.Zenith_Data.Config.Visuals, "ESP_Chest")
        Library:AddToggle(VisualTab, "ESP Fruits", _G.Zenith_Data.Config.Visuals, "ESP_Fruit")
        
        Log("SUCCESS", "Dashboard Setup Complete!")
    else
        Log("ERROR", "CRITICAL: UI Failed to load. Using Fallback Mode.")
    end

    -- C. Load Logic Modules (Combat, Visuals)
    -- local Combat = LoadComponent("Combat", "Combat")
    -- if Combat then Combat:Init() end
    
    -- local Visuals = LoadComponent("Visuals", "Visuals")
    -- if Visuals then Visuals:Init() end
end)

-- -------------------------------------------------------------------------
-- 5. MOBILE OVERLAY CONTROLS (Native Support)
-- -------------------------------------------------------------------------
-- ระบบนี้จะสร้างปุ่มลอยแยกต่างหาก สำหรับมือถือโดยเฉพาะ
-- กันเหนียว เผื่อหน้า UI หลักโหลดไม่ขึ้น หรืออยากกดปิดฟาร์มไวๆ

if IsMobile then
    local MobileHUD = Instance.new("ScreenGui")
    MobileHUD.Name = "Kanyapak_MobileOverlay"
    MobileHUD.Parent = PlayerGui
    MobileHUD.ResetOnSpawn = false
    
    local function CreateMiniBtn(Text, Pos, Color, Callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0, 50, 0, 50)
        Btn.Position = Pos
        Btn.BackgroundColor3 = Color
        Btn.Text = Text
        Btn.TextColor3 = Color3.new(1,1,1)
        Btn.Font = Enum.Font.GothamBold
        Btn.TextSize = 10
        Btn.Parent = MobileHUD
        
        -- Styling
        local Corn = Instance.new("UICorner", Btn)
        Corn.CornerRadius = UDim.new(0, 10)
        local Stroke = Instance.new("UIStroke", Btn)
        Stroke.Color = Color3.new(1,1,1)
        Stroke.Thickness = 1.5
        Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        
        Btn.TouchTap:Connect(function()
            Services.TweenService:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.new(0,45,0,45)}):Play()
            task.wait(0.1)
            Services.TweenService:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.new(0,50,0,50)}):Play()
            Callback()
        end)
    end
    
    -- ปุ่มเปิด/ปิด เมนูหลัก (ขวาล่าง)
    CreateMiniBtn("MENU", UDim2.new(1, -70, 1, -140), Color3.fromRGB(0, 170, 255), function()
        local MainUI = PlayerGui:FindFirstChild("Kanyapak_Pro_V4") -- ต้องตรงกับชื่อใน UI_Library
        if MainUI then
             -- พยายามหา Frame หลักเพื่อเปิดปิด
            for _, v in pairs(MainUI:GetChildren()) do
                if v:IsA("Frame") and v.Size.X.Offset > 100 then
                    v.Visible = not v.Visible
                end
            end
        end
    end)
    
    -- ปุ่มฉุกเฉิน ปิดฟาร์ม (ซ้ายล่าง)
    CreateMiniBtn("STOP", UDim2.new(0, 20, 1, -140), Color3.fromRGB(255, 50, 50), function()
        _G.Zenith_Data.Config.Farm.Enabled = false
        Log("WARN", "Emergency Stop Triggered via Mobile HUD")
    end)
    
    Log("INFO", "Mobile HUD Injected")
end

-- -------------------------------------------------------------------------
-- 6. BACKGROUND PROCESSES (Loops)
-- -------------------------------------------------------------------------

Services.RunService.Heartbeat:Connect(function()
    -- 1. Anti AFK
    if LocalPlayer.Idled then
        Services.VirtualUser:CaptureController()
        Services.VirtualUser:ClickButton2(Vector2.new())
    end
    
    -- 2. Player Mods (Speed/Jump)
    if _G.Zenith_Data.Config.Player.InfJump then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
    
    if _G.Zenith_Data.Config.Player.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
    
    -- 3. Farm Logic Trigger
    -- ตรงนี้คือจุดที่จะไปเรียกโค้ดใน Combat.lua
    if _G.Zenith_Data.Config.Farm.Enabled then
        -- pcall(function() Combat:ExecuteFarm() end)
    end
end)

-- -------------------------------------------------------------------------
-- 7. FINISH
-- -------------------------------------------------------------------------

Services.StarterGui:SetCore("SendNotification", {
    Title = "KANYAPAK V4.0",
    Text = "System Loaded Successfully!",
    Duration = 5,
    Button1 = "Let's Go!"
})

print("\n")
print("  █ █▄ █ ▄▀▄ ▀█▀ █ █ ▀█▀")
print("  █ █ ▀█ █▀█  █  █ █  █ ")
print("  KANYAPAK SHOP V4.0 - READY")
print("\n")

