--[[
    💎 KANYAPAK UI LIBRARY - ENHANCED PROFESSIONAL EDITION (V4.5)
    "ระบบอินเตอร์เฟซระดับสูงสุด - Smooth Animation & Localization Support"
    
    [INFO]
    Developer: จักรพรรดิรุจ (Rujxmod Dev Team Lead)
    Features: Scrollable Panels, Tween Animations, Language Switch (Thai/English), Pro Design like Famous Hubs (Redz/HoHo)
    Optimization: Mobile/PC Compatible, Clean & Scalable
    Last Update: February 2026
    Note: Icon uses clear font with blue color. UI has pro movements, categorized functions, and full animations.
]]

local UI_Library = {}
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Theme (Professional Dark Theme with Blue Accents - Like Famous Hubs)
local Theme = {
    Background = Color3.fromRGB(10, 10, 15),
    Sidebar = Color3.fromRGB(15, 15, 25),
    ItemBg = Color3.fromRGB(20, 20, 30),
    ItemBgHover = Color3.fromRGB(30, 30, 45),
    Primary = Color3.fromRGB(0, 170, 255),  -- Blue for KHUB Icon
    Secondary = Color3.fromRGB(100, 200, 255),
    Success = Color3.fromRGB(0, 200, 100),
    Danger = Color3.fromRGB(255, 50, 50),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 190, 200),
    Border = Color3.fromRGB(30, 40, 55),
    ScrollBar = Color3.fromRGB(0, 170, 255),
}

-- Localization (2 Languages: Thai/English - Switchable)
local Language = "English"  -- Default
local Translations = {
    English = {
        Home = "🏠 Home",
        Farming = "🌾 Farming",
        Combat = "⚔️ Combat",
        Fruits = "🍎 Fruits",
        Visuals = "👁️ Visuals",
        Player = "🚀 Player",
        Misc = "⚙️ Misc",
        Settings = "⚙️ Settings",
        Toggle = "Toggle",
        Slider = "Slider",
        Button = "Button",
        Label = "Label",
        LanguageSwitch = "Switch to Thai",
        -- Add more function names here for categories
        AutoFarmLevel = "Auto Farm Level",
        BringMobs = "Bring Mobs",
        FastAttack = "Fast Attack",
        AttackSpeed = "Attack Speed",
        InfiniteJump = "Infinite Jump",
        NoClip = "NoClip",
        SpeedHack = "Speed Hack",
        SpeedValue = "Speed Value",
        ESPPlayers = "ESP Players",
        ESPChests = "ESP Chests",
        FullBright = "Full Bright",
        SaveConfig = "Save Config",
        LoadConfig = "Load Config",
    },
    Thai = {
        Home = "🏠 หน้าหลัก",
        Farming = "🌾 ฟาร์มมิง",
        Combat = "⚔️ การต่อสู้",
        Fruits = "🍎 ผลไม้",
        Visuals = "👁️ วิชวล",
        Player = "🚀 ผู้เล่น",
        Misc = "⚙️ เบ็ดเตล็ด",
        Settings = "⚙️ การตั้งค่า",
        Toggle = "เปิด/ปิด",
        Slider = "สไลเดอร์",
        Button = "ปุ่ม",
        Label = "ฉลาก",
        LanguageSwitch = "สลับเป็นภาษาอังกฤษ",
        -- Add more
        AutoFarmLevel = "ฟาร์มเลเวลอัตโนมัติ",
        BringMobs = "ดึงม็อบ",
        FastAttack = "โจมตีเร็ว",
        AttackSpeed = "ความเร็วโจมตี",
        InfiniteJump = "กระโดดไม่จำกัด",
        NoClip = "ทะลุกำแพง",
        SpeedHack = "แฮกความเร็ว",
        SpeedValue = "ค่าความเร็ว",
        ESPPlayers = "ESP ผู้เล่น",
        ESPChests = "ESP หีบ",
        FullBright = "สว่างเต็มที่",
        SaveConfig = "บันทึกการตั้งค่า",
        LoadConfig = "โหลดการตั้งค่า",
    }
}

local function GetText(key)
    return Translations[Language][key] or key
end

-- Utility Functions (Pro Animations like Famous Hubs)
local function AddCorner(Instance, Radius)
    local Corner = Instance.new("UICorner", Instance)
    Corner.CornerRadius = UDim.new(0, Radius or 8)
end

local function AddStroke(Instance, Color, Thickness)
    local Stroke = Instance.new("UIStroke", Instance)
    Stroke.Color = Color or Theme.Border
    Stroke.Thickness = Thickness or 1.5
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end

local function Tween(Object, Properties, Duration, Style, Direction)
    local Info = TweenInfo.new(Duration or 0.3, Enum.EasingStyle[Style or "Quad"], Enum.EasingDirection[Direction or "Out"])
    local Tween = TS:Create(Object, Info, Properties)
    Tween:Play()
    return Tween
end

local function MakeDraggable(Frame, Handle)
    local Dragging = false
    local DragStart, StartPos

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

-- AddToggle (With Smooth Animation)
function UI_Library:AddToggle(ParentPage, Title, ConfigTable, ConfigKey, Callback)
    local ToggleFrame = Instance.new("Frame", ParentPage)
    ToggleFrame.Size = UDim2.new(1, -20, 0, 50)
    ToggleFrame.BackgroundColor3 = Theme.ItemBg
    AddCorner(ToggleFrame, 10)
    AddStroke(ToggleFrame)

    local Label = Instance.new("TextLabel", ToggleFrame)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.Text = GetText(Title)
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 14
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ToggleBox = Instance.new("Frame", ToggleFrame)
    ToggleBox.Size = UDim2.new(0, 50, 0, 28)
    ToggleBox.Position = UDim2.new(1, -70, 0.5, -14)
    ToggleBox.BackgroundColor3 = ConfigTable[ConfigKey] and Theme.Success or Theme.ItemBgHover
    AddCorner(ToggleBox, 14)
    AddStroke(ToggleBox)

    local ToggleCircle = Instance.new("Frame", ToggleBox)
    ToggleCircle.Size = UDim2.new(0, 24, 0, 24)
    ToggleCircle.Position = ConfigTable[ConfigKey] and UDim2.new(1, -26, 0.5, -12) or UDim2.new(0, 2, 0.5, -12)
    ToggleCircle.BackgroundColor3 = Color3.new(1,1,1)
    AddCorner(ToggleCircle, 12)

    local ClickArea = Instance.new("TextButton", ToggleFrame)
    ClickArea.Size = UDim2.new(1, 0, 1, 0)
    ClickArea.BackgroundTransparency = 1
    ClickArea.Text = ""

    ClickArea.MouseButton1Click:Connect(function()
        ConfigTable[ConfigKey] = not ConfigTable[ConfigKey]
        local en = ConfigTable[ConfigKey]
        Tween(ToggleBox, {BackgroundColor3 = en and Theme.Success or Theme.ItemBgHover}, 0.3, "Sine")
        Tween(ToggleCircle, {Position = en and UDim2.new(1,-26,0.5,-12) or UDim2.new(0,2,0.5,-12)}, 0.3, "Sine")
        if Callback then pcall(Callback, en) end
    end)

    ToggleFrame.MouseEnter:Connect(function() Tween(ToggleFrame, {BackgroundColor3 = Theme.ItemBgHover}, 0.2) end)
    ToggleFrame.MouseLeave:Connect(function() Tween(ToggleFrame, {BackgroundColor3 = Theme.ItemBg}, 0.2) end)
end

-- AddButton (With Hover & Click Animation)
function UI_Library:AddButton(ParentPage, Title, Callback)
    local ButtonFrame = Instance.new("TextButton", ParentPage)
    ButtonFrame.Size = UDim2.new(1, -20, 0, 50)
    ButtonFrame.BackgroundColor3 = Theme.ItemBg
    ButtonFrame.Text = GetText(Title)
    ButtonFrame.TextColor3 = Theme.Primary
    ButtonFrame.Font = Enum.Font.GothamBold
    ButtonFrame.TextSize = 15
    ButtonFrame.AutoButtonColor = false
    AddCorner(ButtonFrame, 10)
    AddStroke(ButtonFrame)

    ButtonFrame.MouseEnter:Connect(function() Tween(ButtonFrame, {BackgroundColor3 = Theme.Primary, TextColor3 = Color3.new(0,0,0)}, 0.2, "Sine") end)
    ButtonFrame.MouseLeave:Connect(function() Tween(ButtonFrame, {BackgroundColor3 = Theme.ItemBg, TextColor3 = Theme.Primary}, 0.2, "Sine") end)
    ButtonFrame.MouseButton1Click:Connect(function()
        Tween(ButtonFrame, {BackgroundColor3 = Theme.Secondary}, 0.1, "Bounce")
        task.wait(0.1)
        Tween(ButtonFrame, {BackgroundColor3 = Theme.ItemBg}, 0.1, "Sine")
        if Callback then pcall(Callback) end
    end)
end

-- AddSlider (Smooth Slide + Value Update Animation)
function UI_Library:AddSlider(ParentPage, Title, ConfigTable, ConfigKey, Min, Max, Step, Callback)
    local SliderFrame = Instance.new("Frame", ParentPage)
    SliderFrame.Size = UDim2.new(1, -20, 0, 75)
    SliderFrame.BackgroundColor3 = Theme.ItemBg
    AddCorner(SliderFrame, 10)
    AddStroke(SliderFrame)

    local SliderLabel = Instance.new("TextLabel", SliderFrame)
    SliderLabel.Size = UDim2.new(1, -30, 0, 25)
    SliderLabel.Position = UDim2.new(0, 15, 0, 8)
    SliderLabel.Text = GetText(Title) .. ": " .. (ConfigTable[ConfigKey] or Min)
    SliderLabel.TextColor3 = Theme.Text
    SliderLabel.Font = Enum.Font.GothamBold
    SliderLabel.TextSize = 13
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left

    local SliderBg = Instance.new("Frame", SliderFrame)
    SliderBg.Size = UDim2.new(1, -30, 0, 8)
    SliderBg.Position = UDim2.new(0, 15, 0, 40)
    SliderBg.BackgroundColor3 = Theme.ItemBgHover
    AddCorner(SliderBg, 4)

    local Progress = Instance.new("Frame", SliderBg)
    Progress.Size = UDim2.new(math.clamp((ConfigTable[ConfigKey] or Min - Min) / (Max - Min), 0, 1), 0, 1, 0)
    Progress.BackgroundColor3 = Theme.Primary
    AddCorner(Progress, 4)

    local SliderButton = Instance.new("TextButton", SliderBg)
    SliderButton.Size = UDim2.new(0, 20, 0, 20)
    SliderButton.Position = UDim2.new(math.clamp((ConfigTable[ConfigKey] or Min - Min) / (Max - Min), 0, 1), -10, 0.5, -10)
    SliderButton.BackgroundColor3 = Theme.Primary
    SliderButton.Text = ""
    AddCorner(SliderButton, 10)
    AddStroke(SliderButton, Theme.Text, 1.2)

    local SliderActive = false
    local function UpdateSlider(input)
        local x = input.Position.X
        local start = SliderBg.AbsolutePosition.X
        local endx = start + SliderBg.AbsoluteSize.X
        local pct = math.clamp((x - start) / (endx - start), 0, 1)
        local val = math.floor((Min + (Max - Min) * pct) / Step) * Step

        ConfigTable[ConfigKey] = val
        SliderLabel.Text = GetText(Title) .. ": " .. val
        Tween(Progress, {Size = UDim2.new(pct, 0, 1, 0)}, 0.05, "Linear")
        Tween(SliderButton, {Position = UDim2.new(pct, -10, 0.5, -10)}, 0.05, "Linear")
        if Callback then pcall(Callback, val) end
    end

    SliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            SliderActive = true
            UpdateSlider(input)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if SliderActive and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            SliderActive = false
        end
    end)
end

-- AddLabel
function UI_Library:AddLabel(ParentPage, Text)
    local LabelFrame = Instance.new("TextLabel", ParentPage)
    LabelFrame.Size = UDim2.new(1, -20, 0, 40)
    LabelFrame.BackgroundColor3 = Theme.ItemBg
    LabelFrame.Text = GetText(Text)
    LabelFrame.TextColor3 = Theme.TextSecondary
    LabelFrame.Font = Enum.Font.GothamBold
    LabelFrame.TextSize = 13
    AddCorner(LabelFrame, 8)
    AddStroke(LabelFrame)
end

-- CreateTab (Scrollable Sidebar - Pro like Famous Hubs)
function UI_Library:CreateTab(TabName)
    local TabBtn = Instance.new("TextButton", UI_Library.TabContainer)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 50)
    TabBtn.BackgroundColor3 = Theme.ItemBg
    TabBtn.Text = GetText(TabName)
    TabBtn.TextColor3 = Theme.TextSecondary
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 15
    TabBtn.AutoButtonColor = false
    TabBtn.TextWrapped = true
    AddCorner(TabBtn, 10)
    AddStroke(TabBtn)

    local TabContent = Instance.new("ScrollingFrame", UI_Library.ContentArea)
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.Visible = false
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.ScrollBarThickness = 5
    TabContent.ScrollBarImageColor3 = Theme.ScrollBar
    TabContent.ClipsDescendants = true

    local ContentLayout = Instance.new("UIListLayout", TabContent)
    ContentLayout.Padding = UDim.new(0, 12)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

    TabBtn.MouseButton1Click:Connect(function()
        for _, c in pairs(UI_Library.ContentArea:GetChildren()) do
            if c:IsA("ScrollingFrame") then Tween(c, {Transparency = 0}, 0.3, "Sine"); c.Visible = false end
        end
        for _, b in pairs(UI_Library.TabContainer:GetChildren()) do
            if b:IsA("TextButton") then
                Tween(b, {BackgroundColor3 = Theme.ItemBg, TextColor3 = Theme.TextSecondary}, 0.2, "Sine")
            end
        end
        TabContent.Visible = true
        Tween(TabContent, {Transparency = 1}, 0.3, "Sine")
        Tween(TabBtn, {BackgroundColor3 = Theme.Primary, TextColor3 = Color3.new(1,1,1)}, 0.2, "Sine")
    end)

    TabBtn.MouseEnter:Connect(function()
        if not TabContent.Visible then Tween(TabBtn, {BackgroundColor3 = Theme.ItemBgHover}, 0.2, "Sine") end
    end)
    TabBtn.MouseLeave:Connect(function()
        if not TabContent.Visible then Tween(TabBtn, {BackgroundColor3 = Theme.ItemBg}, 0.2, "Sine") end
    end)

    return TabContent
end

-- Init (Pro Initialization with KHUB Icon & Language Switch)
function UI_Library:Init()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Kanyapak_Pro_V45"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- KHUB Icon (Blue, Clear Font - Like Famous Hubs)
    local ToggleIcon = Instance.new("TextButton", ScreenGui)
    ToggleIcon.Size = UDim2.new(0, 120, 0, 50)
    ToggleIcon.Position = UDim2.new(1, -140, 0.5, -25)
    ToggleIcon.BackgroundColor3 = Theme.ItemBg
    ToggleIcon.Text = "KHUB"
    ToggleIcon.TextColor3 = Theme.Primary  -- Blue Color
    ToggleIcon.Font = Enum.Font.GothamBlack  -- Clear, Bold Font
    ToggleIcon.TextSize = 22  -- Big & Clear
    ToggleIcon.AutoButtonColor = false
    AddCorner(ToggleIcon, 12)
    AddStroke(ToggleIcon, Theme.Primary, 2)

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 720, 0, 520)
    MainFrame.Position = UDim2.new(0.5, -360, 0.5, -260)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.Visible = false
    MainFrame.ClipsDescendants = true
    AddCorner(MainFrame, 16)
    AddStroke(MainFrame, Theme.Border, 2)

    local HeaderBar = Instance.new("Frame", MainFrame)
    HeaderBar.Size = UDim2.new(1, 0, 0, 60)
    HeaderBar.BackgroundColor3 = Theme.Sidebar
    AddCorner(HeaderBar, 16)

    local Title = Instance.new("TextLabel", HeaderBar)
    Title.Size = UDim2.new(0.6, 0, 1, 0)
    Title.Position = UDim2.new(0, 25, 0, 0)
    Title.Text = "💎 KANYAPAK HUB V4.5"
    Title.TextColor3 = Theme.Primary
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 22
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local LanguageButton = Instance.new("TextButton", HeaderBar)
    LanguageButton.Size = UDim2.new(0, 100, 0, 40)
    LanguageButton.Position = UDim2.new(0.7, 0, 0, 10)
    LanguageButton.BackgroundColor3 = Theme.ItemBg
    LanguageButton.Text = GetText("LanguageSwitch")
    LanguageButton.TextColor3 = Theme.Text
    LanguageButton.Font = Enum.Font.GothamBold
    LanguageButton.TextSize = 14
    AddCorner(LanguageButton, 8)

    LanguageButton.MouseButton1Click:Connect(function()
        Language = Language == "English" and "Thai" or "English"
        LanguageButton.Text = GetText("LanguageSwitch")
        -- Refresh UI texts (you may need to rebuild tabs or update labels dynamically)
        -- For simplicity, reload UI or notify user to reopen
    end)

    local CloseBtn = Instance.new("TextButton", HeaderBar)
    CloseBtn.Size = UDim2.new(0, 40, 0, 40)
    CloseBtn.Position = UDim2.new(1, -50, 0, 10)
    CloseBtn.BackgroundColor3 = Theme.Danger
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.new(1,1,1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 20
    AddCorner(CloseBtn, 10)

    CloseBtn.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0,0,0,0)}, 0.3, "Sine")
        task.wait(0.3)
        MainFrame.Visible = false
        MainFrame.Size = UDim2.new(0,720,0,520)
    end)

    MakeDraggable(MainFrame, HeaderBar)

    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 190, 1, -65)
    Sidebar.Position = UDim2.new(0, 0, 0, 60)
    Sidebar.BackgroundColor3 = Theme.Sidebar

    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.CanvasSize = UDim2.new(0,0,0,0)
    TabContainer.ScrollBarThickness = 5
    TabContainer.ScrollBarImageColor3 = Theme.ScrollBar

    local TabLayout = Instance.new("UIListLayout", TabContainer)
    TabLayout.Padding = UDim.new(0, 10)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -200, 1, -65)
    ContentArea.Position = UDim2.new(0, 195, 0, 60)
    ContentArea.BackgroundTransparency = 1
    ContentArea.ClipsDescendants = true

    -- Store for CreateTab
    UI_Library.TabContainer = TabContainer
    UI_Library.ContentArea = ContentArea

    -- Resize Handle (Smooth & Mobile Friendly)
    local ResizeHandle = Instance.new("TextLabel", MainFrame)
    ResizeHandle.Size = UDim2.new(0, 30, 0, 30)
    ResizeHandle.Position = UDim2.new(1, -30, 1, -30)
    ResizeHandle.BackgroundColor3 = Theme.Primary
    ResizeHandle.Text = "↘"
    ResizeHandle.TextColor3 = Color3.new(1,1,1)
    ResizeHandle.TextSize = 20
    ResizeHandle.Font = Enum.Font.GothamBold
    AddCorner(ResizeHandle, 6)

    local Resizing = false
    ResizeHandle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            Resizing = true
        end
    end)

    UIS.InputChanged:Connect(function(inp)
        if Resizing and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local newW = math.max(500, inp.Position.X - MainFrame.AbsolutePosition.X)
            local newH = math.max(350, inp.Position.Y - MainFrame.AbsolutePosition.Y)
            Tween(MainFrame, {Size = UDim2.new(0, newW, 0, newH)}, 0.2, "Sine")
        end
    end)

    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            Resizing = false
        end
    end)

    -- Toggle Animation (Open/Close Smooth)
    ToggleIcon.MouseButton1Click:Connect(function()
        if MainFrame.Visible then
            Tween(MainFrame, {Size = UDim2.new(0,0,0,0)}, 0.3, "Sine")
            task.wait(0.3)
            MainFrame.Visible = false
            MainFrame.Size = UDim2.new(0,720,0,520)
        else
            MainFrame.Visible = true
            Tween(MainFrame, {Size = UDim2.new(0,720,0,520)}, 0.3, "Sine")
        end
    end)

    return UI_Library
end

return UI_Library
