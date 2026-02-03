local UI_Lib = {}

function UI_Lib:Init()
    local UIS = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Kanyapak_Premium_GUI"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false

    -- === [ 1. ปุ่มเปิด-ปิด (Floating Button) "Kanyapak" แบบชัดพิเศษ ] ===
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "KanyapakButton"
    ToggleBtn.Size = UDim2.new(0, 120, 0, 45)
    ToggleBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
    
    -- ตั้งค่าฟอนต์ให้คมชัดระดับ HD
    ToggleBtn.Text = "Kanyapak"
    ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
    ToggleBtn.Font = Enum.Font.GothamBold -- ฟอนต์ที่คมที่สุด
    ToggleBtn.TextSize = 20 -- ขนาดที่พอดี ไม่เบลอ
    ToggleBtn.RichText = true
    ToggleBtn.ZIndex = 10
    ToggleBtn.Parent = ScreenGui
    
    local BtnCorner = Instance.new("UICorner", ToggleBtn)
    BtnCorner.CornerRadius = UDim.new(0, 10)
    
    local BtnStroke = Instance.new("UIStroke", ToggleBtn)
    BtnStroke.Color = Color3.fromRGB(0, 255, 255)
    BtnStroke.Thickness = 2
    BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- === [ 2. หน้าต่างเมนูหลัก (Main Frame) ] ===
    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    Main.Visible = false
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Color3.fromRGB(0, 255, 255)
    MainStroke.Thickness = 1
    MainStroke.Transparency = 0.5

    -- Sidebar (แถบหมวดหมู่ด้านซ้าย)
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 130, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    Sidebar.Parent = Main
    Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(1, -140, 1, -20)
    TabContainer.Position = UDim2.new(0, 135, 0, 10)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = Main

    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarLayout.Padding = UDim.new(0, 8)
    Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 15)

    -- === [ 3. ฟังก์ชันสร้างหมวดหมู่ (Tab System) ] ===
    local function CreateTab(name)
        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 0
        Page.Parent = TabContainer
        
        Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
        
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0.85, 0, 0, 35)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 14
        TabBtn.Parent = Sidebar
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(TabContainer:GetChildren()) do p.Visible = false end
            for _, b in pairs(Sidebar:GetChildren()) do 
                if b:IsA("TextButton") then 
                    TweenService:Create(b, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 200, 200), BackgroundColor3 = Color3.fromRGB(25, 25, 40)}):Play()
                end 
            end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(0, 255, 255), BackgroundColor3 = Color3.fromRGB(35, 35, 55)}):Play()
        end)
        
        return Page
    end

    -- === [ 4. ฟังก์ชัน Switch (Toggle) ] ===
    function UI_Lib:AddToggle(parent, text, configKey, subKey, callback)
        local TFrame = Instance.new("Frame")
        TFrame.Size = UDim2.new(1, -10, 0, 45)
        TFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        TFrame.Parent = parent
        Instance.new("UICorner", TFrame).CornerRadius = UDim.new(0, 8)
        
        local TLabel = Instance.new("TextLabel")
        TLabel.Text = "  " .. text
        TLabel.Size = UDim2.new(1, 0, 1, 0)
        TLabel.BackgroundTransparency = 1
        TLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TLabel.TextXAlignment = "Left"
        TLabel.Font = Enum.Font.Gotham
        TLabel.TextSize = 14
        TLabel.Parent = TFrame

        local SwitchBg = Instance.new("TextButton")
        SwitchBg.Size = UDim2.new(0, 45, 0, 22)
        SwitchBg.Position = UDim2.new(1, -55, 0.5, -11)
        SwitchBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        SwitchBg.Text = ""
        SwitchBg.Parent = TFrame
        Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)

        local Circle = Instance.new("Frame")
        Circle.Size = Instance.new("Frame")
        Circle.Size = UDim2.new(0, 18, 0, 18)
        Circle.Position = UDim2.new(0, 2, 0.5, -9)
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.Parent = SwitchBg
        Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

        local active = false
        SwitchBg.MouseButton1Click:Connect(function()
            active = not active
            local targetPos = active and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            local targetColor = active and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(40, 40, 50)
            
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
            TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
            
            if _G.Zenith_Data.Config[configKey] then
                _G.Zenith_Data.Config[configKey][subKey] = active
            end
            callback(active)
        end)
    end

    -- === [ 5. ฟังก์ชัน Slider (แถบเลื่อน) ] ===
    function UI_Lib:AddSlider(parent, text, min, max, default, callback)
        local SFrame = Instance.new("Frame")
        SFrame.Size = UDim2.new(1, -10, 0, 55)
        SFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        SFrame.Parent = parent
        Instance.new("UICorner", SFrame).CornerRadius = UDim.new(0, 8)

        local SLabel = Instance.new("TextLabel")
        SLabel.Text = "  " .. text .. ": " .. default
        SLabel.Size = UDim2.new(1, 0, 0, 30)
        SLabel.BackgroundTransparency = 1
        SLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        SLabel.TextXAlignment = "Left"
        SLabel.Font = Enum.Font.Gotham
        SLabel.TextSize = 14
        SLabel.Parent = SFrame

        local Bar = Instance.new("TextButton")
        Bar.Size = UDim2.new(0.9, 0, 0, 6)
        Bar.Position = UDim2.new(0.05, 0, 0.75, 0)
        Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        Bar.Text = ""
        Bar.AutoButtonColor = false
        Bar.Parent = SFrame
        Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)
        
        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
        Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
        Fill.Parent = Bar
        Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

        local function Update()
            local input = UIS:GetMouseLocation().X
            local pos = math.clamp((input - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * pos)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            SLabel.Text = "  " .. text .. ": " .. value
            callback(value)
        end

        local Sliding = false
        Bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Sliding = true end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Sliding = false end
        end)
        RunService.RenderStepped:Connect(function()
            if Sliding then Update() end
        end)
    end

    -- === [ ระบบลากปุ่ม (Drag) ] ===
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
    
    ToggleBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

    -- === [ สร้างหน้าตัวอย่าง ] ===
    local CombatPage = CreateTab("Combat")
    local PlayerPage = CreateTab("Player")
    local VisualPage = CreateTab("Visuals")

    UI_Lib:AddToggle(CombatPage, "Aimbot", "Combat", "Aimbot", function(v) print("Aimbot:", v) end)
    UI_Lib:AddSlider(PlayerPage, "WalkSpeed", 16, 250, 16, function(v) _G.Zenith_Data.Config.Movement.Speed = v end)
    UI_Lib:AddSlider(PlayerPage, "JumpPower", 50, 500, 50, function(v) _G.Zenith_Data.Config.Movement.Jump = v end)
    UI_Lib:AddToggle(VisualPage, "ESP Box", "Visuals", "Box", function(v) _G.Zenith_Data.Config.Visuals.Box = v end)

    CombatPage.Visible = true -- ให้หน้าแรกโชว์
    print("Kanyapak UI V5 Loaded!")
end

return UI_Lib
