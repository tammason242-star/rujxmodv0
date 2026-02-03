local UI_Lib = {}

-- [[ ตั้งค่าเริ่มต้น ]] --
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer

-- [[ โครงสร้างข้อมูลสำหรับเก็บค่าต่างๆ ]] --
-- ถ้ายังไม่มีการประกาศ _G.Zenith_Data ให้ประกาศไว้กัน error
if not _G.Zenith_Data then
    _G.Zenith_Data = {
        Config = {
            Automation = { Fire=false, Eat=false, Stun=false },
            Visuals = { Chest=false, Corrupted=false, FullBright=false, NoFog=false },
            Player = { Speed=16, Jump=50, InfJump=false, SafeZone=false },
            Combat = { KillAura=false, Reach=false, AutoPickup=false, FastBreak=false }
        }
    }
end

function UI_Lib:Init()
    -- ลบ GUI เก่าออกถ้ามี (กันซ้อน)
    if game.CoreGui:FindFirstChild("Kanyapak_Project_UI") then
        game.CoreGui.Kanyapak_Project_UI:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Kanyapak_Project_UI"
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ResetOnSpawn = false

    -- =============================================
    -- [1. ปุ่มลอย Floating Button - Kanyapak HD]
    -- =============================================
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "KanyapakBtn"
    ToggleBtn.Size = UDim2.new(0, 130, 0, 50)
    ToggleBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
    ToggleBtn.Text = "Kanyapak"
    ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 255) -- สีฟ้า Neon
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 22
    ToggleBtn.RichText = true
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.Parent = ScreenGui

    -- ตกแต่งปุ่ม
    local BtnCorner = Instance.new("UICorner", ToggleBtn)
    BtnCorner.CornerRadius = UDim.new(0, 12)
    
    local BtnStroke = Instance.new("UIStroke", ToggleBtn)
    BtnStroke.Color = Color3.fromRGB(0, 255, 255)
    BtnStroke.Thickness = 2.5
    BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- เงาปุ่ม
    local Shadow = Instance.new("ImageLabel", ToggleBtn)
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Color3.fromRGB(0, 255, 255)
    Shadow.ImageTransparency = 0.6
    Shadow.ZIndex = -1

    -- =============================================
    -- [2. หน้าต่างเมนูหลัก Main Frame]
    -- =============================================
    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 550, 0, 380)
    Main.Position = UDim2.new(0.5, -275, 0.5, -190)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Main.Visible = false -- เริ่มมาซ่อนไว้ก่อน
    Main.Parent = ScreenGui

    -- ตกแต่งหน้าต่างหลัก
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Color3.fromRGB(40, 40, 60)
    MainStroke.Thickness = 2

    -- แถบชื่อด้านบน
    local Title = Instance.new("TextLabel")
    Title.Text = "KANYAPAK | 99 NIGHTS SURVIVAL"
    Title.Size = UDim2.new(1, -20, 0, 40)
    Title.Position = UDim2.new(0, 20, 0, 5)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Main

    -- เส้นคั่น
    local Line = Instance.new("Frame")
    Line.Size = UDim2.new(1, 0, 0, 1)
    Line.Position = UDim2.new(0, 0, 0, 50)
    Line.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    Line.BorderSizePixel = 0
    Line.Parent = Main

    -- =============================================
    -- [3. ระบบ Sidebar (เลือกหมวดหมู่)]
    -- =============================================
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 140, 1, -55)
    Sidebar.Position = UDim2.new(0, 0, 0, 55)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = Main

    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarLayout.Padding = UDim.new(0, 8)
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -150, 1, -60)
    ContentContainer.Position = UDim2.new(0, 150, 0, 55)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.ClipsDescendants = true
    ContentContainer.Parent = Main

    -- ฟังก์ชันสร้างหน้า (Tab)
    local Tabs = {}
    local function CreateTab(Name, IconID)
        -- ปุ่มเลือกหน้า
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(0.9, 0, 0, 40)
        TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        TabBtn.Text = Name
        TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 14
        TabBtn.Parent = Sidebar
        
        local TCorner = Instance.new("UICorner", TabBtn)
        TCorner.CornerRadius = UDim.new(0, 8)

        -- หน้าเนื้อหา
        local Page = Instance.new("ScrollingFrame")
        Page.Name = Name .. "_Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 255)
        Page.Parent = ContentContainer
        
        local PLayout = Instance.new("UIListLayout", Page)
        PLayout.Padding = UDim.new(0, 10)
        PLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        Instance.new("UIPadding", Page).PaddingRight = UDim.new(0, 5)

        -- ระบบกดเปลี่ยนหน้า
        TabBtn.MouseButton1Click:Connect(function()
            -- รีเซ็ตปุ่มอื่น
            for _, btn in pairs(Sidebar:GetChildren()) do
                if btn:IsA("TextButton") then
                    TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(25, 25, 35), TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
                end
            end
            -- รีเซ็ตหน้าอื่น
            for _, pg in pairs(ContentContainer:GetChildren()) do
                pg.Visible = false
            end
            
            -- เปิดหน้าที่เลือก
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 255, 255), TextColor3 = Color3.fromRGB(0, 0, 0)}):Play()
        end)
        
        return Page
    end

    -- =============================================
    -- [4. ฟังก์ชันสร้าง Toggle (สวิตช์)]
    -- =============================================
    function UI_Lib:AddToggle(Page, Text, Category, Flag, Default)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 45)
        Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        Frame.Parent = Page
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

        local Label = Instance.new("TextLabel")
        Label.Text = "  " .. Text
        Label.Size = UDim2.new(0.7, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Color3.fromRGB(230, 230, 230)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.Parent = Frame

        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(0, 50, 0, 24)
        Button.Position = UDim2.new(1, -60, 0.5, -12)
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        Button.Text = ""
        Button.Parent = Frame
        Instance.new("UICorner", Button).CornerRadius = UDim.new(1, 0)

        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.new(0, 20, 0, 20)
        Circle.Position = UDim2.new(0, 2, 0.5, -10)
        Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Circle.Parent = Button
        Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

        local Toggled = Default or false
        
        -- ฟังก์ชันเปลี่ยนสถานะ
        local function UpdateToggle()
            Toggled = not Toggled
            local TargetPos = Toggled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            local TargetColor = Toggled and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(50, 50, 60)
            
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = TargetPos}):Play()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = TargetColor}):Play()
            
            -- บันทึกค่าลง _G
            if _G.Zenith_Data.Config[Category] then
                _G.Zenith_Data.Config[Category][Flag] = Toggled
                print("Set " .. Flag .. " to " .. tostring(Toggled))
            end
        end

        Button.MouseButton1Click:Connect(UpdateToggle)
    end

    -- =============================================
    -- [5. ฟังก์ชันสร้าง Slider (แถบเลื่อน)]
    -- =============================================
    function UI_Lib:AddSlider(Page, Text, Category, Flag, Min, Max, Default)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 60)
        Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
        Frame.Parent = Page
        Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

        local Label = Instance.new("TextLabel")
        Label.Text = "  " .. Text .. ": " .. Default
        Label.Size = UDim2.new(1, 0, 0, 30)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Color3.fromRGB(230, 230, 230)
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 14
        Label.Parent = Frame

        local SliderBar = Instance.new("TextButton")
        SliderBar.Size = UDim2.new(0.9, 0, 0, 6)
        SliderBar.Position = UDim2.new(0.05, 0, 0.7, 0)
        SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        SliderBar.Text = ""
        SliderBar.AutoButtonColor = false
        SliderBar.Parent = Frame
        Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
        Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
        Fill.Parent = SliderBar
        Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

        local function Update(Input)
            local SizeX = math.clamp((Input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(SizeX, 0, 1, 0)
            local Value = math.floor(Min + ((Max - Min) * SizeX))
            Label.Text = "  " .. Text .. ": " .. Value
            
            if _G.Zenith_Data.Config[Category] then
                _G.Zenith_Data.Config[Category][Flag] = Value
            end
        end

        local Dragging = false
        SliderBar.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                Update(Input)
            end
        end)
        
        UIS.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                Dragging = false
            end
        end)
        
        UIS.InputChanged:Connect(function(Input)
            if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
                Update(Input)
            end
        end)
    end

    -- =============================================
    -- [6. สร้างหน้าและใส่ฟังก์ชัน (Setup)]
    -- =============================================
    
    -- สร้าง Tab หมวดหมู่
    local AutoTab = CreateTab("อัตโนมัติ")
    local VisualTab = CreateTab("การมองเห็น")
    local PlayerTab = CreateTab("ตัวละคร")
    local CombatTab = CreateTab("การต่อสู้")

    -- [[ หมวดอัตโนมัติ ]]
    UI_Lib:AddToggle(AutoTab, "เติมไฟอัตโนมัติ", "Automation", "Fire")
    UI_Lib:AddToggle(AutoTab, "กินอาหารอัตโนมัติ", "Automation", "Eat")
    UI_Lib:AddToggle(AutoTab, "สตั้นมอนสเตอร์ (Auto Stun)", "Automation", "Stun")
    
    -- [[ หมวดการมองเห็น ]]
    UI_Lib:AddToggle(VisualTab, "มองทะลุกล่อง (Box ESP)", "Visuals", "Chest")
    UI_Lib:AddToggle(VisualTab, "ไฮไลท์กล่องติดเชื้อ (สีม่วง)", "Visuals", "Corrupted")
    UI_Lib:AddToggle(VisualTab, "สว่างคาตา (Full Bright)", "Visuals", "FullBright")
    UI_Lib:AddToggle(VisualTab, "ลบหมอก (No Fog)", "Visuals", "NoFog")

    -- [[ หมวดตัวละคร ]]
    UI_Lib:AddSlider(PlayerTab, "ความเร็วเดิน (WalkSpeed)", "Player", "Speed", 16, 200, 16)
    UI_Lib:AddSlider(PlayerTab, "แรงกระโดด (JumpPower)", "Player", "Jump", 50, 400, 50)
    UI_Lib:AddToggle(PlayerTab, "กระโดดรัว (Inf Jump)", "Player", "InfJump")
    UI_Lib:AddToggle(PlayerTab, "วาร์ปกลับบ้าน (Safe Zone)", "Player", "SafeZone")

    -- [[ หมวดการต่อสู้/ฟาร์ม ]]
    UI_Lib:AddToggle(CombatTab, "ตบมอนรอบตัว (Kill Aura)", "Combat", "KillAura")
    UI_Lib:AddToggle(CombatTab, "ตีไกล / ขุดไกล (Reach)", "Combat", "Reach")
    UI_Lib:AddToggle(CombatTab, "ดูดของอัตโนมัติ (Pickup)", "Combat", "AutoPickup")
    UI_Lib:AddToggle(CombatTab, "ขุดไว / ตีไว (Fast Break)", "Combat", "FastBreak")


    -- =============================================
    -- [7. ระบบลากปุ่ม & เปิดปิดเมนู]
    -- =============================================
    local Dragging, DragStart, StartPos
    ToggleBtn.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = Input.Position
            StartPos = ToggleBtn.Position
        end
    end)
    
    UIS.InputChanged:Connect(function(Input)
        if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = Input.Position - DragStart
            ToggleBtn.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
    
    UIS.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)

    -- กดปุ่มเพื่อเปิด/ปิด เมนู
    ToggleBtn.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
    end)
    
    -- เปิดหน้าแรกอัตโนมัติ
    AutoTab.Visible = true
    print("Kanyapak UI Library Loaded Successfully!")
end

return UI_Lib
