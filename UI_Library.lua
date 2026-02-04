--[[
    💎 KANYAPAK UI LIBRARY - ULTIMATE EDITION (V4.0)
    "ระบบอินเตอร์เฟซระดับสูงสุด สำหรับมืออาชีพ"
    
    🎨 Theme: Deep Blue & Stealth Black
    📱 Support: Mobile / Tablet / PC
    🌐 Language: Thai (ภาษาไทย)
]]

local UI_Library = {}

-- [[ บริการเสริมของระบบ ]]
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- [[ การตั้งค่าธีมสี (Blue Neon) ]]
local Theme = {
    Main = Color3.fromRGB(10, 12, 15),
    Sidebar = Color3.fromRGB(15, 18, 22),
    Accent = Color3.fromRGB(0, 170, 255), -- ฟ้าเข้มสะท้อนแสง
    Text = Color3.fromRGB(255, 255, 255),
    DarkText = Color3.fromRGB(130, 145, 160),
    ItemBg = Color3.fromRGB(22, 26, 30),
    Stroke = Color3.fromRGB(30, 35, 45)
}

-- [[ ฟังก์ชันช่วยทำงาน (Helper Functions) ]]
local function MakeDraggable(Frame, Handle)
    local Dragging, DragInput, DragStart, StartPos
    Handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = Frame.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = input.Position - DragStart
            Frame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)
end

-- [[ เริ่มสร้าง UI ]]
function UI_Library:Init()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Kanyapak_Pro_V4"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    -- [ปุ่มไอคอนเปิดเมนู KANSHOP]
    local Icon = Instance.new("TextButton", ScreenGui)
    Icon.Name = "KanIcon"
    Icon.Size = UDim2.new(0, 90, 0, 45)
    Icon.Position = UDim2.new(1, -110, 0.5, 0)
    Icon.BackgroundColor3 = Theme.Main
    Icon.Text = "KANSHOP"
    Icon.TextColor3 = Theme.Accent
    Icon.Font = Enum.Font.GothamBold
    Icon.TextSize = 14
    local IconCorner = Instance.new("UICorner", Icon)
    local IconStroke = Instance.new("UIStroke", Icon)
    IconStroke.Color = Theme.Accent
    IconStroke.Thickness = 1.5

    -- [แผงเมนูหลัก]
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 580, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
    MainFrame.BackgroundColor3 = Theme.Main
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false
    MainFrame.ClipsDescendants = true
    local MainCorner = Instance.new("UICorner", MainFrame)
    local MainStroke = Instance.new("UIStroke", MainFrame)
    MainStroke.Color = Theme.Stroke
    MainStroke.Thickness = 2

    -- [แถบด้านข้าง (Sidebar)]
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0

    local Logo = Instance.new("TextLabel", Sidebar)
    Logo.Size = UDim2.new(1, 0, 0, 60)
    Logo.Text = "KANYAPAK V4"
    Logo.TextColor3 = Theme.Accent
    Logo.Font = Enum.Font.GothamBold
    Logo.TextSize = 18
    Logo.BackgroundTransparency = 1

    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, -70)
    TabContainer.Position = UDim2.new(0, 0, 0, 65)
    TabContainer.BackgroundTransparency = 1
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ScrollBarThickness = 0
    local TabList = Instance.new("UIListLayout", TabContainer)
    TabList.Padding = UDim.new(0, 5)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- [พื้นที่เนื้อหา (Content)]
    local PageHolder = Instance.new("Frame", MainFrame)
    PageHolder.Size = UDim2.new(1, -175, 1, -15)
    PageHolder.Position = UDim2.new(0, 170, 0, 10)
    PageHolder.BackgroundTransparency = 1

    -- [ระบบปรับขนาด (Resize)]
    local ResizeBtn = Instance.new("TextButton", MainFrame)
    ResizeBtn.Size = UDim2.new(0, 20, 0, 20)
    ResizeBtn.Position = UDim2.new(1, -20, 1, -20)
    ResizeBtn.BackgroundTransparency = 1
    ResizeBtn.Text = "◢"
    ResizeBtn.TextColor3 = Theme.Accent
    ResizeBtn.TextSize = 20

    local Resizing = false
    ResizeBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Resizing = true
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if Resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local MousePos = UIS:GetMouseLocation()
            local NewSizeX = MousePos.X - MainFrame.AbsolutePosition.X
            local NewSizeY = MousePos.Y - MainFrame.AbsolutePosition.Y
            MainFrame.Size = UDim2.new(0, math.max(450, NewSizeX), 0, math.max(300, NewSizeY))
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Resizing = false
        end
    end)

    MakeDraggable(MainFrame, Sidebar)

    -- [[ ฟังก์ชันสร้างหมวดหมู่ (Tabs) ]]
    function UI_Library:CreateTab(Name)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(0, 145, 0, 40)
        TabBtn.BackgroundColor3 = Theme.Accent
        TabBtn.BackgroundTransparency = 1
        TabBtn.Text = " " .. Name
        TabBtn.TextColor3 = Theme.DarkText
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        local TabCorner = Instance.new("UICorner", TabBtn)

        local Page = Instance.new("ScrollingFrame", PageHolder)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Theme.Accent
        local PageList = Instance.new("UIListLayout", Page)
        PageList.Padding = UDim.new(0, 10)
        PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(PageHolder:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabContainer:GetChildren()) do 
                if v:IsA("TextButton") then
                    TS:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextColor3 = Theme.DarkText}):Play()
                end
            end
            Page.Visible = true
            TS:Create(TabBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0.8, TextColor3 = Theme.Accent}):Play()
        end)

        -- ฟังก์ชันเพิ่ม Toggle (เปิด/ปิด)
        function UI_Library:AddToggle(ParentPage, Title, Config, Key, Callback)
            local ToggleFrame = Instance.new("TextButton", ParentPage)
            ToggleFrame.Size = UDim2.new(0, 380, 0, 45)
            ToggleFrame.BackgroundColor3 = Theme.ItemBg
            ToggleFrame.Text = "   " .. Title
            ToggleFrame.TextColor3 = Theme.Text
            ToggleFrame.Font = Enum.Font.GothamBold
            ToggleFrame.TextSize = 13
            ToggleFrame.TextXAlignment = Enum.TextXAlignment.Left
            ToggleFrame.AutoButtonColor = false
            local TCorner = Instance.new("UICorner", ToggleFrame)

            local Box = Instance.new("Frame", ToggleFrame)
            Box.Size = UDim2.new(0, 45, 0, 22)
            Box.Position = UDim2.new(1, -55, 0.5, -11)
            Box.BackgroundColor3 = Config[Key] and Theme.Accent or Color3.fromRGB(40, 45, 50)
            local BCorner = Instance.new("UICorner", Box, {CornerRadius = UDim.new(1,0)})

            local Dot = Instance.new("Frame", Box)
            Dot.Size = UDim2.new(0, 18, 0, 18)
            Dot.Position = Config[Key] and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
            Dot.BackgroundColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", Dot, {CornerRadius = UDim.new(1,0)})

            ToggleFrame.MouseButton1Click:Connect(function()
                Config[Key] = not Config[Key]
                TS:Create(Box, TweenInfo.new(0.3), {BackgroundColor3 = Config[Key] and Theme.Accent or Color3.fromRGB(40, 45, 50)}):Play()
                TS:Create(Dot, TweenInfo.new(0.3), {Position = Config[Key] and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}):Play()
                if Callback then Callback(Config[Key]) end
            end)
        end

        -- ฟังก์ชันเพิ่มปุ่ม (Button)
        function UI_Library:AddButton(ParentPage, Title, Callback)
            local Btn = Instance.new("TextButton", ParentPage)
            Btn.Size = UDim2.new(0, 380, 0, 45)
            Btn.BackgroundColor3 = Theme.ItemBg
            Btn.Text = Title
            Btn.TextColor3 = Theme.Accent
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 14
            local BCorner = Instance.new("UICorner", Btn)
            
            Btn.MouseButton1Click:Connect(function()
                Btn.BackgroundColor3 = Theme.Accent
                Btn.TextColor3 = Theme.Main
                task.wait(0.1)
                TS:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ItemBg, TextColor3 = Theme.Accent}):Play()
                if Callback then Callback() end
            end)
        end

        -- ฟังก์ชันเพิ่มแถบเลื่อน (Slider)
        function UI_Library:AddSlider(ParentPage, Title, Min, Max, Default, Config, Key, Callback)
            local SliderFrame = Instance.new("Frame", ParentPage)
            SliderFrame.Size = UDim2.new(0, 380, 0, 65)
            SliderFrame.BackgroundColor3 = Theme.ItemBg
            local SCorner = Instance.new("UICorner", SliderFrame)

            local Label = Instance.new("TextLabel", SliderFrame)
            Label.Size = UDim2.new(1, -20, 0, 30)
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.Text = Title .. " : " .. Default
            Label.TextColor3 = Theme.Text
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1

            local BarBg = Instance.new("TextButton", SliderFrame)
            BarBg.Size = UDim2.new(1, -20, 0, 6)
            BarBg.Position = UDim2.new(0, 10, 0, 45)
            BarBg.BackgroundColor3 = Color3.fromRGB(40, 45, 50)
            BarBg.Text = ""
            local BCorner = Instance.new("UICorner", BarBg)

            local Bar = Instance.new("Frame", BarBg)
            Bar.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
            Bar.BackgroundColor3 = Theme.Accent
            local BarCorner = Instance.new("UICorner", Bar)

            local function UpdateSlider()
                local Percent = math.clamp((Mouse.X - BarBg.AbsolutePosition.X) / BarBg.AbsoluteSize.X, 0, 1)
                local Value = math.floor(Min + (Max - Min) * Percent)
                Config[Key] = Value
                Bar.Size = UDim2.new(Percent, 0, 1, 0)
                Label.Text = Title .. " : " .. Value
                if Callback then Callback(Value) end
            end

            local MoveCon
            BarBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    MoveCon = RS.RenderStepped:Connect(UpdateSlider)
                end
            end)
            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if MoveCon then MoveCon:Disconnect() end
                end
            end)
        end

        return Page
    end

    -- [ระบบเปิด/ปิดเมนู]
    Icon.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then
            MainFrame:TweenSize(UDim2.new(0, 580, 0, 380), "Out", "Back", 0.4, true)
        end
    end)

    return UI_Library
end

return UI_Library

