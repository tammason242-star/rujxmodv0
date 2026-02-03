
-- [[ RUJXMOD SUPREME V5 - MASTER LOADER ]] --
-- GitHub: tammason242-star / rujxmodv0

local BaseURL = "https://raw.githubusercontent.com/tammason242-star/rujxmodv0/refs/heads/main/"

-- === [ 1. GLOBAL DATA SYSTEM ] ===
_G.Zenith_Data = {
    Version = "5.0.1",
    Config = {
        Combat = { Aimbot = false, Smooth = 5, AimPart = "Head" },
        Visuals = { ESP = false, Tracers = false },
        Movement = { Speed = 16, Jump = 50 },
    },
    Modules = {}
}

-- === [ 2. NOTIFICATION SYSTEM ] ===
local function SendNotify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = 5;
    })
end

-- === [ 3. SECURE MODULE LOADER ] ===
local function LoadModule(FileName)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(BaseURL .. FileName))()
    end)
    
    if success and result then
        return result
    else
        warn("Failed to load: " .. FileName)
        return nil
    end
end

-- === [ 4. INITIALIZATION ] ===
SendNotify("RUJXMOD", "Connecting to GitHub...")

-- โหลดไฟล์ย่อยตามรายชื่อที่มีในรูป GitHub มึง
_G.Zenith_Data.Modules.UI = LoadModule("UI_Library.lua")
_G.Zenith_Data.Modules.Combat = LoadModule("Combat.lua")
_G.Zenith_Data.Modules.Visuals = LoadModule("Visuals.lua")
_G.Zenith_Data.Modules.Funcs = LoadModule("Functions.lua")

-- ตรวจสอบและเริ่มทำงาน
if _G.Zenith_Data.Modules.UI then
    _G.Zenith_Data.Modules.UI:Init() -- สั่งให้ UI แสดงผล
    SendNotify("SUCCESS", "RUJXMOD V0 LOADED!")
else
    SendNotify("ERROR", "UI Library not found!")
end
