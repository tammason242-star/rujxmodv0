local UI_Lib = {}

function UI_Lib:Init()
    local UIS = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Kanyapak_GUI"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false

    -- === [ 1. ปุ่มเปิด-ปิดแบบข้อความ "Kanyapak" ] ===
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "KanyapakButton"
    ToggleBtn.Size = UDim2.new(0, 100, 0, 40) -- ปรับขนาดให้พอดีกับข้อความ
    ToggleBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    ToggleBtn.Text = "Kanyapak"
    ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 255) -- ฟอนต์สีฟ้า
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 16
    ToggleBtn.Parent = ScreenGui
    
    local BtnCorner = Instance.new("UICorner", ToggleBtn)
    BtnCorner.CornerRadius = UDim.new(0, 8)
    
    local BtnStroke = Instance.new("UIStroke", ToggleBtn)
    BtnStroke.Color = Color3.fromRGB(0, 255, 255)
    BtnStroke.Thickness = 1.5

    -- === [ 2. หน้าต่างเมนูหลัก (Main Frame) ] ===
    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 480, 0, 320)
    Main.Position = UDim2.new(0.5, -240, 0.5, -160)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Main.Visible = false
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

    -- Sidebar สำหรับเปลี่ยนหมวดหมู่
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 120, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Sidebar.Parent = Main
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

    -- Container สำหรับเนื้อหาแต่ละหมวดหมู่
    local ContentHolder = Instance.new("Frame")
    ContentHolder.Size = UDim2.new(1, -130, 1, -20)
    ContentHolder.Position = UDim2.new(0, 125, 0, 10)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Parent = Main

    -- === [ 3. ฟังก์ชันสร้างหมวดหมู่ (Tab System) ] ===
    local Tabs = {}
    function UI_Lib:CreateTab(name)
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.Parent = ContentHolder
        
        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0, 8)
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0.9, 0, 0, 35)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.Parent = Sidebar
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
        Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 10)
        Instance.new("UIListLayout", Sidebar).HorizontalAlignment = Enum.HorizontalAlignment.Center
        Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(ContentHolder:GetChildren()) do p.Visible = false end
            Page.Visible = true
        end)
        
        return Page
    end

    -- === [ 4. ฟังก์ชันสร้างปุ่ม Switch (Toggle) ] ===
    function UI_Lib:AddToggle(parent, text, callback)
        local TFrame = Instance.new("Frame")
        TFrame.Size = UDim2.new(1, -10, 0, 40)
        TFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        TFrame.Parent = parent
        Instance.new("UICorner", TFrame).CornerRadius = UDim.new(0, 6)
        
        local TLabel = Instance.new("TextLabel")
        TLabel.Text = "  " .. text
        TLabel.Size = UDim2.new(1, 0, 1, 0)
        TLabel.BackgroundTransparency = 1
        TLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TLabel.TextXAlignment = "Left"
        TLabel.Font = Enum.Font.Gotham
        TLabel.Parent = TFrame

        local Switch = Instance.new("TextButton")
        Switch.Size = UDim2.new(0, 40, 0, 20)
        Switch.Position = UDim2.new(1, -50, 0.5, -10)
        Switch.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Switch.Text = ""
        Switch.Parent = TFrame
        local SCorn = Instance.new("UICorner", Switch)
        SCorn.CornerRadius = UDim.new(1, 0)

        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.new(0, 16, 0, 16)
        Circle.Position = UDim2.new(0, 2, 0.5, -8)
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.Parent = Switch
        Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

        local active = false
        Switch.MouseButton1Click:Connect(function()
            active = not active
            local targetPos = active and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            local targetColor = active and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(50, 50, 50)
            
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
            callback(active)
        end)
    end

    -- === [ 5. ฟังก์ชันสร้าง Slider (แถบเลื่อน) ] ===
    function UI_Lib:AddSlider(parent, text, min, max, default, callback)
        local SFrame = Instance.new("Frame")
        SFrame.Size = UDim2.new(1, -10, 0, 50)
        SFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        SFrame.Parent = parent
        Instance.new("UICorner", SFrame).CornerRadius = UDim.new(0, 6)

        local SLabel = Instance.new("TextLabel")
        SLabel.Text = "  " .. text .. ": " .. default
        SLabel.Size = UDim2.new(1, 0, 0, 25)
        SLabel.BackgroundTransparency = 1
        SLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        SLabel.TextXAlignment = "Left"
        SLabel.Font = Enum.Font.Gotham
        SLabel.Parent = SFrame

        local Bar = Instance.new("Frame")
        Bar.Size = UDim2.new(0.9, 0, 0, 4)
        Bar.Position = UDim2.new(0.05, 0, 0.7, 0)
        Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        Bar.Parent = SFrame
        
        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
        Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
        Fill.Parent = Bar

        -- ระบบเลื่อน Slider
        local function UpdateSlider()
            local mousePos = UIS:GetMouseLocation().X
            local barPos = Bar.AbsolutePosition.X
            local barSize = Bar.AbsoluteSize.X
            local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
            local value = math.floor(min + (max - min) * percent)
            
            Fill.Size = UDim2.new(percent, 0, 1, 0)
            SLabel.Text = "  " .. text .. ": " .. value
            callback(value)
        end

        Bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local connection
                connection = RunService.RenderStepped:Connect(function()
                    UpdateSlider()
                    if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                        connection:Disconnect()
                    end
                end)
            end
        end)
    end

    -- === [ ระบบ Toggle & Drag ] ===
    ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    local dragging, dragStart, startPos
    ToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = ToggleBtn.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function() dragging = false end)

    -- === [ ตัวอย่างการใช้งานหมวดหมู่ ] ===
    local CombatTab = UI_Lib:CreateTab("Combat")
    local PlayerTab = UI_Lib:CreateTab("Player")

    UI_Lib:AddToggle(CombatTab, "Aimbot Enabled", function(v) _G.Zenith_Data.Config.Combat.Aimbot = v end)
    UI_Lib:AddSlider(PlayerTab, "WalkSpeed", 16, 200, 16, function(v) _G.Zenith_Data.Config.Movement.Speed = v end)
    UI_Lib:AddSlider(PlayerTab, "JumpPower", 50, 300, 50, function(v) _G.Zenith_Data.Config.Movement.Jump = v end)

    print("Kanyapak UI: Ready")
end

return UI_Lib
