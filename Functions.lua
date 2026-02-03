local Functions = {}
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- [[ ฟังก์ชันเสริมสำหรับการกดปุ่ม ProximityPrompt (สำหรับมือถือ) ]] --
local function FirePrompt(Prompt)
    if not Prompt then return end
    task.spawn(function()
        fireproximityprompt(Prompt)
    end)
end

-- [[ ฟังก์ชันค้นหาไอเทมในตัว (Inventory Check) ]] --
local function GetItem(names)
    local bp = LocalPlayer.Backpack
    local char = LocalPlayer.Character
    for _, item in pairs(bp:GetChildren()) do
        for _, n in pairs(names) do
            if item.Name:lower():find(n:lower()) then return item end
        end
    end
    if char then
        for _, item in pairs(char:GetChildren()) do
            if item:IsA("Tool") then
                for _, n in pairs(names) do
                    if item.Name:lower():find(n:lower()) then return item end
                end
            end
        end
    end
    return nil
end

function Functions:Init()
    print("💎 Kanyapak: Premium Functions Module Loaded (Fixed & Extended)")

    -- [[ 1. ลูปการเคลื่อนที่และการปรับแต่งตัวละคร (ความเร็ว/กระโดด) ]] --
    -- ใช้ RenderStepped เพื่อความลื่นไหลสูงสุดของตัวละคร
    RunService.RenderStepped:Connect(function()
        local Config = _G.Zenith_Data.Config.Player
        local VisualConfig = _G.Zenith_Data.Config.Visuals
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        local Root = Character and Character:FindFirstChild("HumanoidRootPart")

        if not (Character and Humanoid and Root) then return end

        -- 1.1 ระบบเดินไว (WalkSpeed) - มีการดักจับค่าเดิมเพื่อไม่ให้กระตุก
        if Config.Speed > 16 then
            Humanoid.WalkSpeed = Config.Speed
        end

        -- 1.2 ระบบกระโดดสูง (JumpPower)
        if Config.Jump > 50 then
            Humanoid.UseJumpPower = true
            Humanoid.JumpPower = Config.Jump
        end

        -- 1.3 กระโดดรัวบนอากาศ (Infinite Jump - Support Mobile)
        if Config.InfJump then
            -- เช็คทั้งปุ่ม Space และ ปุ่มกระโดดบนจอมือถือ
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) or Humanoid.Jump then
                Root.Velocity = Vector3.new(Root.Velocity.X, Config.Jump, Root.Velocity.Z)
            end
        end

        -- 1.4 ปรับแต่งโลก (World Settings)
        if VisualConfig.FullBright then
            Lighting.Brightness = 2.5
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
            -- ปรับแต่งสภาพอากาศให้สว่างขึ้น
            local Bloom = Lighting:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect", Lighting)
            Bloom.Intensity = 0.5
        end

        if VisualConfig.NoFog then
            Lighting.FogEnd = 9e9 -- ค่ามหาศาลเพื่อให้มองทะลุหมอก
            Lighting.FogStart = 0
            -- ลบ Atmosphere ออกชั่วคราวเพื่อให้มองเห็นชัดเจนในที่มืด
            local Atmos = Lighting:FindFirstChildOfClass("Atmosphere")
            if Atmos then Atmos.Density = 0 end
        end

        -- 1.5 ระบบวาร์ปกลับจุดปลอดภัย (Safe Zone Warp)
        if Config.SafeZone then
            -- ใส่พิกัดที่ต้องการวาร์ปไป (ควรเป็นพิกัดที่ปลอดภัยในแมพนั้นๆ)
            Root.CFrame = CFrame.new(0, 150, 0) -- ตัวอย่าง: บนฟ้า
            Config.SafeZone = false -- วาร์ปเสร็จแล้วปิดการทำงานทันที
        end
    end)

    -- [[ 2. ลูประบบอัตโนมัติ (Automation Logic) - รันทุก 1 วินาทีเพื่อลดความร้อนเครื่อง ]] --
    task.spawn(function()
        while task.wait(1) do
            local Auto = _G.Zenith_Data.Config.Automation
            local Character = LocalPlayer.Character
            local Root = Character and Character:FindFirstChild("HumanoidRootPart")
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

            if not (Character and Root and Humanoid) then continue end

            -- 2.1 ระบบเติมไฟอัตโนมัติ (Advanced Auto Fill Fire)
            if Auto.Fire then
                -- ค้นหาเฉพาะในรัศมีใกล้ๆ เพื่อป้องกันการแล็ค
                for _, obj in pairs(workspace:GetChildren()) do
                    -- ตรวจสอบว่าเป็นกองไฟหรือไม่ (เช็คจากชื่อยอดนิยมในเกม)
                    if obj.Name:lower():find("fire") or obj.Name:lower():find("camp") then
                        local Dist = (Root.Position - (obj:IsA("Model") and obj:GetModelCFrame().p or obj.Position)).Magnitude
                        if Dist < 18 then
                            -- ค้นหา ProximityPrompt ในวัตถุนั้นๆ
                            local Prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if Prompt then
                                FirePrompt(Prompt)
                            end
                        end
                    end
                end
            end

            -- 2.2 ระบบกินอาหารอัตโนมัติ (Smart Auto Eat)
            if Auto.Eat then
                -- กินเมื่อเลือดต่ำกว่า 80% หรือตามค่าที่กำหนด
                if Humanoid.Health < (Humanoid.MaxHealth * 0.8) then
                    -- รายชื่อไอเทมที่ใช้ฟื้นฟู (มึงสามารถเพิ่มชื่อไอเทมในแมพนี้เข้าไปได้)
                    local Food = GetItem({"Meat", "Berry", "Apple", "Bread", "Water", "Steak", "Food"})
                    if Food then
                        Humanoid:EquipTool(Food)
                        task.wait(0.2)
                        Food:Activate()
                        task.wait(0.3)
                        Humanoid:UnequipTools()
                    end
                end
            end

            -- 2.3 ระบบต่อต้านสถานะผิดปกติ (Anti-Environment Debuffs)
            if _G.Zenith_Data.Config.Visuals.FullBright then
                -- ลบ Blur หรือ เอฟเฟกต์มืดที่หน้าจอ
                local Camera = workspace.CurrentCamera
                if Camera then
                    for _, effect in pairs(Camera:GetChildren()) do
                        if effect:IsA("BlurEffect") or effect:IsA("ColorCorrectionEffect") then
                            effect.Enabled = false
                        end
                    end
                end
            end
        end
    end)

    -- [[ 3. ระบบจัดการความปลอดภัย (Anti-Kick/Anti-AFK) ]] --
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        print("Kanyapak: Anti-AFK Active!")
    end)
end

return Functions
