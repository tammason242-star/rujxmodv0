--[[
    KANYAPAK SCRIPT - MAIN LOADER
    Game: 99 Nights in the Forest (Survival)
    Author: Tammason242 & Gemini AI
]]

-- 1. ป้องกันการรันซ้ำ (Anti-Duplicate)
if _G.Kanyapak_Loaded then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "KANYAPAK",
        Text = "สคริปต์ทำงานอยู่แล้ว! (Script is already running)",
        Duration = 5
    })
    return
end
_G.Kanyapak_Loaded = true

-- 2. ตั้งค่า Global Data (ฐานข้อมูลกลาง)
-- ค่าเหล่านี้จะถูกแชร์ไปให้ทุกไฟล์ใช้งานร่วมกัน
_G.Zenith_Data = {
    Config = {
        Automation = { 
            Fire = false,       -- เติมไฟ
            Eat = false,        -- กินอาหาร
            Stun = false        -- สตั้นมอน
        },
        Visuals = { 
            Chest = false,      -- มองกล่อง
            Corrupted = false,  -- มองกล่องม่วง
            FullBright = false, -- สว่างคาตา
            NoFog = false       -- ลบหมอก
        },
        Player = { 
            Speed = 16,         -- ความเร็วเดิม
            Jump = 50,          -- กระโดดเดิม
            InfJump = false,    -- โดดรัว
            SafeZone = false    -- วาร์ปกลับบ้าน
        },
        Combat = { 
            KillAura = false,   -- ตบมอนรอบตัว
            Reach = false,      -- ตีไกล
            AutoPickup = false, -- ดูดของ
            FastBreak = false   -- ขุดไว
        }
    }
}

-- 3. ตั้งค่าลิงก์ GitHub (Repository Setup)
-- ตรงนี้คือลิงก์ไปยัง Folder ที่เก็บไฟล์ของคุณ
local Repo = "https://raw.githubusercontent.com/tammason242-star/rujxmodv0/refs/heads/main/"

-- ฟังก์ชันแจ้งเตือน (Notification)
local function SendNotify(title, text, time)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = time or 5,
        Icon = "rbxassetid://6031071057" -- ไอคอนรูปสวยๆ
    })
end

SendNotify("KANYAPAK", "กำลังโหลดสคริปต์... (Loading...)", 3)

-- 4. ฟังก์ชันโหลดไฟล์ (Script Loader)
local function LoadModule(ScriptName)
    local url = Repo .. ScriptName
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        local loadSuccess, module = pcall(function()
            return loadstring(result)()
        end)
        
        if loadSuccess and module then
            print("Successfully loaded: " .. ScriptName)
            return module
        else
            warn("Error executing: " .. ScriptName .. " | " .. tostring(module))
            SendNotify("Error", "ไม่สามารถรันไฟล์: " .. ScriptName, 5)
            return nil
        end
    else
        warn("Failed to download: " .. ScriptName)
        SendNotify("Error", "หาไฟล์ไม่เจอ: " .. ScriptName, 5)
        return nil
    end
end

-- 5. สั่งโหลดไฟล์ย่อยทั้งหมด (Execution Sequence)
-- ลำดับสำคัญมาก: ต้องโหลด Function/Visual/Combat ก่อน แล้วค่อยโหลด UI

local Functions = LoadModule("Functions.lua")
local Visuals   = LoadModule("Visuals.lua")
local Combat    = LoadModule("Combat.lua")
local UI_Lib    = LoadModule("UI_Library.lua")

-- 6. สั่งเริ่มทำงาน (Initialization)
if Functions then Functions:Init() end
if Visuals then Visuals:Init() end
if Combat then Combat:Init() end

if UI_Lib then 
    UI_Lib:Init() 
    SendNotify("KANYAPAK", "สคริปต์พร้อมใช้งานแล้ว! (Ready!)", 5)
else
    SendNotify("Error", "โหลดเมนูไม่สำเร็จ (UI Failed)", 5)
end
