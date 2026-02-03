local Combat = {}
local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer

function Combat:Init()
    print("Kanyapak: Combat Module Loaded")

    task.spawn(function()
        while task.wait(0.1) do -- รันเร็วหน่อยเพื่อความแม่นยำ
            local Character = LocalPlayer.Character
            local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")
            if not RootPart then continue end

            -- 4.1 ตบมอนรอบตัว (Kill Aura)
            if _G.Zenith_Data.Config.Combat.KillAura then
                for _, enemy in pairs(workspace:GetChildren()) do
                    -- เช็คว่าเป็นมอนสเตอร์ (มี Humanoid และไม่ใช่เรา)
                    if enemy:FindFirstChild("Humanoid") and enemy ~= Character and enemy:FindFirstChild("HumanoidRootPart") then
                        local Dist = (RootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                        
                        if Dist < 20 then -- ระยะ 20 เมตร
                            -- สั่งโจมตี (ถ้ามีดาบในมือ)
                            local Tool = Character:FindFirstChildOfClass("Tool")
                            if Tool then
                                Tool:Activate() -- กดตี
                                -- ถ้าเกมมี RemoteEvent สำหรับดาเมจ ใส่ตรงนี้ได้เลย
                            end
                        end
                    end
                end
            end

            -- 4.2 ดูดของอัตโนมัติ (Auto Pickup)
            if _G.Zenith_Data.Config.Combat.AutoPickup then
                for _, item in pairs(workspace:GetChildren()) do
                    -- เช็คว่าเป็นของตก (มี Handle)
                    if item:IsA("Tool") or (item:IsA("Model") and item:FindFirstChild("Handle")) then
                        local Handle = item:FindFirstChild("Handle") or item.PrimaryPart
                        if Handle then
                            -- วาร์ปของมาหาตัวเรา (Client Side - บางเกมอาจไม่เห็นผลกับคนอื่น)
                            Handle.CFrame = RootPart.CFrame
                        end
                    end
                end
            end
        end
    end)
    
    -- 4.3 ตีไกล / ขุดไกล (Reach)
    RunService.RenderStepped:Connect(function()
        if _G.Zenith_Data.Config.Combat.Reach then
            local Tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if Tool and Tool:FindFirstChild("Handle") then
                -- ขยาย Hitbox ของอาวุธให้ใหญ่ขึ้น 20 เท่า
                local SelectionBox = Tool.Handle:FindFirstChild("ReachBox") or Instance.new("SelectionBox", Tool.Handle)
                SelectionBox.Name = "ReachBox"
                SelectionBox.Adornee = Tool.Handle
                Tool.Handle.Size = Vector3.new(20, 20, 20) -- ขยายขนาด
                Tool.Handle.Transparency = 1 -- ซ่อนไม่ให้เห็นว่าใหญ่
            end
        end
    end)
end

return Combat

