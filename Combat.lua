local Combat = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- [[ ระบบจัดการการโจมตี (Attack Handler) ]] --
local function AttackTarget(Target)
    local Character = LocalPlayer.Character
    if not Character then return end
    
    -- หาอาวุธที่ถืออยู่
    local Weapon = Character:FindFirstChildOfClass("Tool")
    if Weapon then
        -- กดโจมตี (Activate)
        Weapon:Activate()
        
        -- ระบบเสริม: ส่งสัญญาณ Damage ไปยัง Remote (ถ้ามี)
        -- หมายเหตุ: ส่วนนี้จะปรับตามระบบของแต่ละเกม
        local Remote = Weapon:FindFirstChild("RemoteEvent") or Weapon:FindFirstChild("Attack")
        if Remote and Remote:IsA("RemoteEvent") then
            Remote:FireServer(Target)
        end
    end
end

-- [[ เริ่มต้นการทำงานของโมดูลต่อสู้ ]] --
function Combat:Init()
    print("⚔️ Kanyapak: Combat Module (Premium Mobile) Activated")

    -- 1. ลูป Kill Aura & Auto Stun (รันทุก 0.2 วินาที เพื่อความไวแต่ไม่แล็ค)
    task.spawn(function()
        while task.wait(0.2) do
            local Config = _G.Zenith_Data.Config.Combat
            local AutoConfig = _G.Zenith_Data.Config.Automation
            local Character = LocalPlayer.Character
            local Root = Character and Character:FindFirstChild("HumanoidRootPart")
            
            if not Root then continue end

            -- ค้นหาสิ่งมีชีวิตรอบตัว
            for _, v in pairs(workspace:GetChildren()) do
                -- เช็คว่าเป็นมอนสเตอร์/กวาง (ต้องมี Humanoid และไม่ใช่เรา)
                if v:FindFirstChild("Humanoid") and v ~= Character and v.Humanoid.Health > 0 then
                    local TargetRoot = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Head")
                    if not TargetRoot then continue end
                    
                    local Distance = (Root.Position - TargetRoot.Position).Magnitude

                    -- 1.1 Kill Aura (รัศมี 20-25 เมตร)
                    if Config.KillAura and Distance < 25 then
                        AttackTarget(v)
                    end

                    -- 1.2 Auto Stun (ระบบสตั้นมอนสเตอร์อัตโนมัติ)
                    if AutoConfig.Stun and Distance < 15 then
                        -- จำลองการกระแทกหรือการใช้สกิลสตั้น (ถ้ามีระบบในเกม)
                        -- ในที่นี้เน้นการโจมตีซ้ำๆ เพื่อขัดจังหวะมอนสเตอร์
                        AttackTarget(v)
                    end
                end
            end
        end
    end)

    -- 2. ระบบดูดไอเทมอัตโนมัติ (Auto Pickup - รันทุก 0.5 วินาที)
    task.spawn(function()
        while task.wait(0.5) do
            if _G.Zenith_Data.Config.Combat.AutoPickup then
                local Character = LocalPlayer.Character
                local Root = Character and Character:FindFirstChild("HumanoidRootPart")
                if not Root then continue end

                for _, item in pairs(workspace:GetChildren()) do
                    -- เช็คว่าเป็นไอเทมที่ตกพื้น (Tool หรือ Model ที่มี Handle)
                    if item:IsA("Tool") or item:IsA("Model") and item:FindFirstChild("Handle") then
                        local Handle = item:FindFirstChild("Handle") or item.PrimaryPart
                        if Handle then
                            local Dist = (Root.Position - Handle.Position).Magnitude
                            if Dist < 50 then -- ระยะดูด 50 เมตร
                                -- วาร์ปไอเทมมาที่เท้า (Client-Side Support)
                                Handle.CFrame = Root.CFrame
                                -- จำลองการกดเก็บ (ถ้ามี ProximityPrompt)
                                local Prompt = item:FindFirstChildOfClass("ProximityPrompt") or Handle:FindFirstChildOfClass("ProximityPrompt")
                                if Prompt then
                                    fireproximityprompt(Prompt)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    -- 3. ระบบขยายระยะโจมตี & ขุดไว (Reach & Fast Break)
    RunService.RenderStepped:Connect(function()
        local Config = _G.Zenith_Data.Config.Combat
        local Character = LocalPlayer.Character
        if not Character then return end

        local Tool = Character:FindFirstChildOfClass("Tool")
        if Tool and Tool:FindFirstChild("Handle") then
            -- 3.1 Reach Hack (ขยาย Hitbox ของอาวุธ)
            if Config.Reach then
                Tool.Handle.Size = Vector3.new(15, 15, 15) -- ขยายขนาดอาวุธให้ใหญ่ขึ้น
                Tool.Handle.Massless = true
                Tool.Handle.CanCollide = false
            else
                -- คืนค่าเดิมถ้าไม่ได้เปิด (ตัวอย่างค่ามาตรฐาน)
                -- Tool.Handle.Size = Vector3.new(1, 1, 2) 
            end

            -- 3.2 Fast Break (เร่งความเร็วการใช้เครื่องมือ)
            if Config.FastBreak then
                -- ลด Delay ของการกด Click
                -- (ปกติระบบนี้ต้องแก้ที่สคริปต์อาวุธ แต่เราใช้การ Activate รัวๆ แทน)
                if LocalPlayer:GetMouse().Button1Down then
                    Tool:Activate()
                end
            end
        end
    end)
end

return Combat
