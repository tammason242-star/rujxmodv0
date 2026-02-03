local Functions = {}
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer

function Functions:Init()
    print("Kanyapak: Functions Module Loaded")

    -- [[ 1. ลูปหลักสำหรับจัดการตัวละครและโลก (รันตลอดเวลา) ]]
    RunService.RenderStepped:Connect(function()
        local Character = LocalPlayer.Character
        local Humanoid = Character and Character:FindFirstChild("Humanoid")
        local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

        if not (Character and Humanoid and RootPart) then return end

        -- 1.1 จัดการความเร็วและกระโดด (Movement)
        if _G.Zenith_Data.Config.Player.Speed > 16 then
            Humanoid.WalkSpeed = _G.Zenith_Data.Config.Player.Speed
        end
        if _G.Zenith_Data.Config.Player.Jump > 50 then
            Humanoid.JumpPower = _G.Zenith_Data.Config.Player.Jump
        end

        -- 1.2 กระโดดรัว (Infinite Jump)
        if _G.Zenith_Data.Config.Player.InfJump then
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end

        -- 1.3 สว่างคาตา (Full Bright)
        if _G.Zenith_Data.Config.Visuals.FullBright then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14 -- บ่ายสองตลอดกาล
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        end

        -- 1.4 ลบหมอก (No Fog)
        if _G.Zenith_Data.Config.Visuals.NoFog then
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
        end
        
        -- 1.5 วาร์ปกลับจุดปลอดภัย (Safe Zone)
        if _G.Zenith_Data.Config.Player.SafeZone then
            -- พิกัดนี้ต้องแก้ตามแมพจริง (อันนี้สมมติว่าเป็นจุดเกิดบนฟ้า)
            -- ถ้าแมพมีจุด Safezone ชัดเจน ให้ใส่ CFrame ตรงนี้
            RootPart.CFrame = CFrame.new(0, 100, 0) 
            _G.Zenith_Data.Config.Player.SafeZone = false -- วาร์ปเสร็จแล้วปิดสวิตช์
        end
    end)

    -- [[ 2. ระบบอัตโนมัติ (Automation Loop - รันทุก 1 วินาที) ]]
    task.spawn(function()
        while task.wait(1) do
            local Character = LocalPlayer.Character
            local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
            if not RootPart then continue end

            -- 2.1 เติมไฟอัตโนมัติ (Auto Fill Fire)
            if _G.Zenith_Data.Config.Automation.Fire then
                for _, obj in pairs(workspace:GetDescendants()) do
                    -- หา Campfire ที่มี ProximityPrompt
                    if obj:IsA("ProximityPrompt") and (obj.Parent.Name:find("Fire") or obj.Parent.Name:find("Camp")) then
                        local Dist = (RootPart.Position - obj.Parent.Position).Magnitude
                        if Dist < 15 then -- ถ้าระยะใกล้พอ
                            fireproximityprompt(obj) -- สั่งกด E อัตโนมัติ
                        end
                    end
                end
            end

            -- 2.2 กินอาหารอัตโนมัติ (Auto Eat)
            if _G.Zenith_Data.Config.Automation.Eat then
                local Humanoid = Character:FindFirstChild("Humanoid")
                if Humanoid and Humanoid.Health < Humanoid.MaxHealth * 0.7 then -- กินเมื่อเลือดต่ำกว่า 70%
                    local Tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                    -- หาของกินในกระเป๋า (ต้องเช็คชื่อเอาเองว่าเกมใช้อะไร)
                    if Tool and (Tool.Name:find("Meat") or Tool.Name:find("Berry") or Tool.Name:find("Food")) then
                        Humanoid:EquipTool(Tool)
                        task.wait(0.2)
                        Tool:Activate() -- กดกิน
                        task.wait(0.5)
                        Humanoid:UnequipTools()
                    end
                end
            end
        end
    end)
    
    -- [[ 3. สตั้นกวาง/มอน (Auto Stun - ทำงานเมื่อมี Event) ]]
    -- หมายเหตุ: ต้องหา RemoteEvent ของเกม ถ้าหาไม่เจอใช้วิธีเดินชน
    task.spawn(function()
        while task.wait(0.5) do
            if _G.Zenith_Data.Config.Automation.Stun then
               -- โค้ดส่วนนี้ต้องแก้ตามชื่อมอนสเตอร์ในเกม
               for _, enemy in pairs(workspace:GetChildren()) do
                   if enemy:FindFirstChild("Humanoid") and (enemy.Name:find("Deer") or enemy.Name:find("Monster")) then
                        -- สมมติว่าการสตั้นคือการส่ง Event หรือการโจมตี
                        -- ตรงนี้ใส่โค้ดโจมตีเฉพาะกิจ
                   end
               end
            end
        end
    end)
end

return Functions

