--[[
    💎 KANYAPAK UI LIBRARY - FIXED EDITION (V4.5.1)
    "แก้ไขบัค Slider และระบบ Scope เรียบร้อย รันบนมือถือผ่านฉลุย"
]]

local UI_Library = {}
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Theme
local Theme = {
    Background = Color3.fromRGB(10, 10, 15),
    Sidebar = Color3.fromRGB(15, 15, 25),
    ItemBg = Color3.fromRGB(20, 20, 30),
    ItemBgHover = Color3.fromRGB(30, 30, 45),
    Primary = Color3.fromRGB(0, 170, 255),
    Secondary = Color3.fromRGB(100, 200, 255),
    Success = Color3.fromRGB(0, 200, 100),
    Danger = Color3.fromRGB(255, 50, 50),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 190, 200),
    Border = Color3.fromRGB(30, 40, 55),
    ScrollBar = Color3.fromRGB(0, 170, 255),
}

-- Localization
local Language = "English"
local Translations = {
    English = {
        Home = "🏠 Home", Farming = "🌾 Farming", Combat = "⚔️ Combat", Fruits = "🍎 Fruits",
        Visuals = "👁️ Visuals", Player = "🚀 Player", Misc = "⚙️ Misc", Settings = "⚙️ Settings",
        LanguageSwitch = "Switch to Thai", SaveConfig = "Save Config", LoadConfig = "Load Config",
    },
    Thai = {
        Home = "🏠 หน้าหลัก", Farming = "🌾 ฟาร์มมิง", Combat = "⚔️ การต่อสู้", Fruits = "🍎 ผลไม้",
        Visuals = "👁️ วิชวล", Player = "🚀 ผู้เล่น", Misc = "⚙️ เบ็ดเตล็ด", Settings = "⚙️ การตั้งค่า",
        LanguageSwitch = "สลับเป็นภาษาอังกฤษ", SaveConfig = "บันทึกการตั้งค่า", LoadConfig = "โหลดการตั้งค่า",
    }
}

local function GetText(key)
    return Translations[Language][key] or key
end

-- Utility Functions
local function AddCorner(Instance, Radius)
    local Corner = Instance.new("UICorner", Instance)
    Corner.CornerRadius = UDim.new(0, Radius or 8)
    return Corner
end

local function AddStroke(Instance, Color, Thickness)
    local Stroke = Instance.new("UIStroke", Instance)
    Stroke.Color = Color or Theme.Border
    Stroke.Thickness = Thickness or 1.5
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return Stroke
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

-- --------------------------------------------------------
-- ELEMENTS
-- --------------------------------------------------------

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

    -- Safe Check for Config
    if not ConfigTable then ConfigTable = {} end
    if ConfigTable[ConfigKey] == nil then ConfigTable[ConfigKey] = false end

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
        if Callback then task.spawn(function() pcall(Callback, en) end) end
    end)
end

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

    ButtonFrame.MouseButton1Click:Connect(function()
        Tween(ButtonFrame, {BackgroundColor3 = Theme.Secondary}, 0.1, "Bounce")
        task.wait(0.1)
        Tween(ButtonFrame, {BackgroundColor3 = Theme.ItemBg}, 0.1, "Sine")
        if Callback then task.spawn(function() pcall(Callback) end) end
    end)
end

function UI_Library:AddSlider(ParentPage, Title, ConfigTable, ConfigKey, Min, Max, Step, Callback)
    local SliderFrame = Instance.new("Frame", ParentPage)
    SliderFrame.Size = UDim2.new(1, -20, 0, 75)
    SliderFrame.BackgroundColor3 = Theme.ItemBg
    AddCorner(SliderFrame, 10)
    AddStroke(SliderFrame)

    -- Safe Check for Config
    if not ConfigTable then ConfigTable = {} end
    local CurrentValue = ConfigTable[ConfigKey] or Min
    
    local SliderLabel = Instance.new("TextLabel", SliderFrame)
    SliderLabel.Size = UDim2.new(1, -30, 0, 25)
    SliderLabel.Position = UDim2.new(0, 15, 0, 8)
    SliderLabel.Text = GetText(Title) .. ": " .. CurrentValue
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

    -- ✅ FIX: Correct Math Logic to prevent crash
    local Percent = math.clamp((CurrentValue - Min) / (Max - Min), 0, 1)

    local Progress = Instance.new("Frame", SliderBg)
    Progress.Size = UDim2.new(Percent, 0, 1, 0)
    Progress.BackgroundColor3 = Theme.Primary
    AddCorner(Progress, 4)

    local SliderButton = Instance.new("TextButton", SliderBg)
    SliderButton.Size = UDim2.new(0, 20, 0, 20)
    SliderButton.Position = UDim2.new(Percent, -10, 0.5, -10)
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
        
        if Callback then task.spawn(function() pcall(Callback, val) end) end
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

-- --------------------------------------------------------
-- CORE FUNCTIONS
-- --------------------------------------------------------

function UI_Library:CreateTab(TabName)
    -- Guard: Check if Init was called
    if not UI_Library.TabContainer then 
        warn("⚠️ Error: UI_Library:Init() must be called before CreateTab!") 
        return Instance.new("Frame") -- Return dummy to prevent crash
    end

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
            if c:IsA("ScrollingFrame") then c.Visible = false end
        end
        for _, b in pairs(UI_Library.TabContainer:GetChildren()) do
            if b:IsA("TextButton") then
                Tween(b, {BackgroundColor3 = Theme.ItemBg, TextColor3 = Theme.TextSecondary}, 0.2, "Sine")
            end
        end
        TabContent.Visible = true
        Tween(TabBtn, {BackgroundColor3 = Theme.Primary, TextColor3 = Color3.new(1,1,1)}, 0.2, "Sine")
    end)

    return TabContent
end

function UI_Library:Init()
    -- Clean Old GUI
    if PlayerGui:FindFirstChild("Kanyapak_Pro_V45") then
        PlayerGui.Kanyapak_Pro_V45:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Kanyapak_Pro_V45"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 999 -- Top Layer

    -- Toggle Icon (Optimized for Mobile)
    local ToggleIcon = Instance.new("TextButton", ScreenGui)
    ToggleIcon.Size = UDim2.new(0, 100, 0, 50)
    ToggleIcon.Position = UDim2.new(1, -120, 0.4, 0) -- Adjusted higher for mobile
    ToggleIcon.BackgroundColor3 = Theme.ItemBg
    ToggleIcon.Text = "KHUB"
    ToggleIcon.TextColor3 = Theme.Primary
    ToggleIcon.Font = Enum.Font.GothamBlack
    ToggleIcon.TextSize = 20
    ToggleIcon.AutoButtonColor = false
    AddCorner(ToggleIcon, 12)
    AddStroke(ToggleIcon, Theme.Primary, 2)

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 650, 0, 400) -- Smaller initial size for mobile
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.Visible = false
    MainFrame.ClipsDescendants = true
    AddCorner(MainFrame, 16)
    AddStroke(MainFrame, Theme.Border, 2)

    local HeaderBar = Instance.new("Frame", MainFrame)
    HeaderBar.Size = UDim2.new(1, 0, 0, 50)
    HeaderBar.BackgroundColor3 = Theme.Sidebar
    AddCorner(HeaderBar, 16)

    local Title = Instance.new("TextLabel", HeaderBar)
    Title.Size = UDim2.new(0.6, 0, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.Text = "💎 KANYAPAK HUB V4.5"
    Title.TextColor3 = Theme.Primary
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 18
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("TextButton", HeaderBar)
    CloseBtn.Size = UDim2.new(0, 40, 0, 40)
    CloseBtn.Position = UDim2.new(1, -45, 0, 5)
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
        MainFrame.Size = UDim2.new(0, 650, 0, 400)
    end)

    MakeDraggable(MainFrame, HeaderBar)

    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Size = UDim2.new(0, 180, 1, -55)
    Sidebar.Position = UDim2.new(0, 0, 0, 55)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0

    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.CanvasSize = UDim2.new(0,0,0,0)
    TabContainer.ScrollBarThickness = 4
    TabContainer.ScrollBarImageColor3 = Theme.ScrollBar

    local TabLayout = Instance.new("UIListLayout", TabContainer)
    TabLayout.Padding = UDim.new(0, 10)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Size = UDim2.new(1, -190, 1, -55)
    ContentArea.Position = UDim2.new(0, 185, 0, 55)
    ContentArea.BackgroundTransparency = 1
    ContentArea.ClipsDescendants = true

    -- Setup Globals for CreateTab
    UI_Library.TabContainer = TabContainer
    UI_Library.ContentArea = ContentArea

    ToggleIcon.MouseButton1Click:Connect(function()
        if MainFrame.Visible then
            Tween(MainFrame, {Size = UDim2.new(0,0,0,0)}, 0.3, "Sine")
            task.wait(0.3)
            MainFrame.Visible = false
            MainFrame.Size = UDim2.new(0, 650, 0, 400)
        else
            MainFrame.Visible = true
            Tween(MainFrame, {Size = UDim2.new(0, 650, 0, 400)}, 0.3, "Sine")
        end
    end)

    return UI_Library
end

return UI_Library
