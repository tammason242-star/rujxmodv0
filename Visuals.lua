local Visuals = {}
local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer

-- ฟังก์ชันสร้างกรอบ (Box ESP)
local function CreateESP(Model, Color, NameTag)
    if Model:FindFirstChild("Kanyapak_ESP") then return end -- มีแล้วไม่ต้องสร้างซ้ำ
    
    local Highlight = Instance.new("Highlight")
    Highlight.Name = "Kanyapak_ESP"
    Highlight.FillColor = Color
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    Highlight.FillTransparency = 0.5
    Highlight.OutlineTransparency = 0
    Highlight.Adornee = Model
    Highlight.Parent = Model

    -- สร้างชื่อบอก
    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "Kanyapak_Tag"
    Billboard.Adornee = Model
    Billboard.Size = UDim2.new(0, 100, 0, 40)
    Billboard.StudsOffset = Vector3.new(0, 3, 0)
    Billboard.AlwaysOnTop = true
    Billboard.Parent = Model

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Text = NameTag
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextColor3 = Color
    TextLabel.TextStrokeTransparency = 0
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 14
    TextLabel.Parent = Billboard
end

-- ฟังก์ชันลบ ESP
local function ClearESP()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Kanyapak_ESP" or v.Name == "Kanyapak_Tag" then
            v:Destroy()
        end
    end
end

function Visuals:Init()
    print("Kanyapak: Visuals Module Loaded")

    task.spawn(function()
        while task.wait(1) do -- อัปเดตทุก 1 วินาทีกันแลค
            
            -- ถ้าปิดสวิตช์ ให้ลบ ESP ออก
            if not _G.Zenith_Data.Config.Visuals.Chest and not _G.Zenith_Data.Config.Visuals.Corrupted then
                ClearESP()
                continue
            end

            for _, obj in pairs(workspace:GetDescendants()) do
                -- 3.1 มองทะลุกล่องทั่วไป (Chest ESP)
                if _G.Zenith_Data.Config.Visuals.Chest then
                    if obj.Name == "Chest" or obj.Name == "Crate" or obj.Name:find("Box") then
                        CreateESP(obj, Color3.fromRGB(0, 255, 0), "Box") -- สีเขียว
                    end
                end

                -- 3.2 ไฮไลท์กล่องติดเชื้อ (Corrupted Highlight)
                if _G.Zenith_Data.Config.Visuals.Corrupted then
                    -- เช็คชื่อกล่องพิเศษ (ตามที่ยูทูปบอก)
                    if obj.Name:find("Corrupted") or obj.Name:find("Infected") then
                        CreateESP(obj, Color3.fromRGB(170, 0, 255), "CORRUPTED!") -- สีม่วง
                    end
                end
            end
        end
    end)
end

return Visuals

