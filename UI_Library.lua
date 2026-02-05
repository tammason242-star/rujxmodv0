--[[
    💎 KANYAPAK UI LIBRARY - FIXED EDITION (V4.5)
    "ระบบอินเตอร์เฟซระดับสูงสุด - Scope Fix"
]]

local UI_Library = {}
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Theme
local Theme = {
    Background = Color3.fromRGB(10, 12, 15),
    Sidebar = Color3.fromRGB(12, 16, 22),
    ItemBg = Color3.fromRGB(18, 24, 32),
    ItemBgHover = Color3.fromRGB(24, 32, 42),
    Primary = Color3.fromRGB(0, 170, 255),
    Secondary = Color3.fromRGB(100, 200, 255),
    Success = Color3.fromRGB(0, 200, 100),
    Danger = Color3.fromRGB(255, 50, 50),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 190, 200),
    Border = Color3.fromRGB(30, 40, 55),
    ScrollBar = Color3.fromRGB(0, 170, 255),
}

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
    local Info = TweenInfo.new(
        Duration or 0.3,
        Enum.EasingStyle[Style or "Quad"],
        Enum.EasingDirection[Direction or "Out"]
    )
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

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║              DEFINE FUNCTIONS AT MAIN LEVEL (NOT INSIDE CreateTab)
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- ✅ AddToggle - MAIN LEVEL
function UI_Library:AddToggle(ParentPage, Title, ConfigTable, ConfigKey, Callback)
    local ToggleFrame = Instance.new("Frame", ParentPage)
    ToggleFrame.Name = "Toggle_" .. Title:gsub(" ", "_")
    ToggleFrame.Size = UDim2.new(1, -20, 0, 50)
    ToggleFrame.BackgroundColor3 = Theme.ItemBg
    ToggleFrame.BorderSizePixel = 0
    AddCorner(ToggleFrame, 10)
    AddStroke(ToggleFrame, Theme.Border, 1)
    
    local Label = Instance.new("TextLabel", ToggleFrame)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.Text = Title
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 13
    Label.BackgroundTransparency = 1
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleBox = Instance.new("Frame", ToggleFrame)
    ToggleBox.Name = "ToggleBox"
    ToggleBox.Size = UDim2.new(0, 50, 0, 28)
    ToggleBox.Position = UDim2.new(1, -70, 0.5, -14)
    ToggleBox.BackgroundColor3 = (ConfigTable and ConfigTable[ConfigKey]) and Theme.Success or Theme.ItemBgHover
    ToggleBox.BorderSizePixel = 0
    AddCorner(ToggleBox, 14)
    AddStroke(ToggleBox, Theme.Border, 1)
    
    local ToggleCircle = Instance.new("Frame", ToggleBox)
    ToggleCircle.Name = "Circle"
    ToggleCircle.Size = UDim2.new(0, 24, 0, 24)
    ToggleCircle.Position = (ConfigTable and ConfigTable[ConfigKey]) and UDim2.new(1, -26, 0.5, -12) or UDim2.new(0, 2, 0.5, -12)
    ToggleCircle.BackgroundColor3 = Color3.new(1, 1, 1)
    ToggleCircle.BorderSizePixel = 0
    AddCorner(ToggleCircle, 12)
    
    local ClickArea = Instance.new("TextButton", ToggleFrame)
    ClickArea.Size = UDim2.new(1, 0, 1, 0)
    ClickArea.BackgroundTransparency = 1
    ClickArea.Text = ""
    ClickArea.AutoButtonColor = false
    
    ClickArea.MouseButton1Click:Connect(function()
        if ConfigTable then
            ConfigTable[ConfigKey] = not ConfigTable[ConfigKey]
            local IsEnabled = ConfigTable[ConfigKey]
            Tween(ToggleBox, {BackgroundColor3 = IsEnabled and Theme.Success or Theme.ItemBgHover}, 0.3)
            Tween(ToggleCircle, {Position = IsEnabled and UDim2.new(1, -26, 0.5, -12) or UDim2.new(0, 2, 0.5, -12)}, 0.3)
            if Callback then pcall(function() Callback(IsEnabled) end) end
        end
    end)
    
    ToggleFrame.MouseEnter:Connect(function()
        Tween(ToggleFrame, {BackgroundColor3 = Theme.ItemBgHover}, 0.2)
    end)
    ToggleFrame.MouseLeave:Connect(function()
        Tween(ToggleFrame, {BackgroundColor3 = Theme.ItemBg}, 0.2)
    end)
end

-- ✅ AddButton - MAIN LEVEL
function UI_Library:AddButton(ParentPage, Title, Callback)
    local ButtonFrame = Instance.new("TextButton", ParentPage)
    ButtonFrame.Name = "Button_" .. Title:gsub(" ", "_")
    ButtonFrame.Size = UDim2.new(1, -20, 0, 50)
    ButtonFrame.BackgroundColor3 = Theme.ItemBg
    ButtonFrame.Text = Title
    ButtonFrame.TextColor3 = Theme.Primary
    ButtonFrame.Font = Enum.Font.GothamBold
    ButtonFrame.TextSize = 13
    ButtonFrame.AutoButtonColor = false
    ButtonFrame.BorderSizePixel = 0
    AddCorner(ButtonFrame, 10)
    AddStroke(ButtonFrame, Theme.Border, 1)
    
    ButtonFrame.MouseEnter:Connect(function()
        Tween(ButtonFrame, {BackgroundColor3 = Theme.Primary, TextColor3 = Color3.new(0, 0, 0)}, 0.2)
    end)
    ButtonFrame.MouseLeave:Connect(function()
        Tween(ButtonFrame, {BackgroundColor3 = Theme.ItemBg, TextColor3 = Theme.Primary}, 0.2)
    end)
    ButtonFrame.MouseButton1Click:Connect(function()
        Tween(ButtonFrame, {BackgroundColor3 = Theme.Secondary}, 0.1)
        task.wait(0.1)
        Tween(ButtonFrame, {BackgroundColor3 = Theme.ItemBg}, 0.1)
        if Callback then pcall(function() Callback() end) end
    end)
end

-- ✅ AddSlider - MAIN LEVEL
function UI_Library:AddSlider(ParentPage, Title, ConfigTable, ConfigKey, Min, Max, Step, Callback)
    local SliderFrame = Instance.new("Frame", ParentPage)
    SliderFrame.Name = "Slider_" .. Title:gsub(" ", "_")
    SliderFrame.Size = UDim2.new(1, -20, 0, 75)
    SliderFrame.BackgroundColor3 = Theme.ItemBg
    SliderFrame.BorderSizePixel = 0
    AddCorner(SliderFrame, 10)
    AddStroke(SliderFrame, Theme.Border, 1)
    
    local SliderLabel = Instance.new("TextLabel", SliderFrame)
    SliderLabel.Size = UDim2.new(1, -30, 0, 25)
    SliderLabel.Position = UDim2.new(0, 15, 0, 8)
    SliderLabel.Text = Title .. ": " .. (ConfigTable[ConfigKey] or Min)
    SliderLabel.TextColor3 = Theme.Text
    SliderLabel.Font = Enum.Font.GothamBold
    SliderLabel.TextSize = 12
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local SliderBg = Instance.new("Frame", SliderFrame)
    SliderBg.Name = "SliderBg"
    SliderBg.Size = UDim2.new(1, -30, 0, 6)
    SliderBg.Position = UDim2.new(0, 15, 0, 40)
    SliderBg.BackgroundColor3 = Theme.ItemBgHover
    SliderBg.BorderSizePixel = 0
    AddCorner(SliderBg, 3)
    
    local CurrentValue = ConfigTable[ConfigKey] or Min
    local Progress = Instance.new("Frame", SliderBg)
    Progress.Name = "Progress"
    Progress.Size = UDim2.new(math.clamp((CurrentValue - Min) / (Max - Min), 0, 1), 0, 1, 0)
    Progress.BackgroundColor3 = Theme.Primary
    Progress.BorderSizePixel = 0
    AddCorner(Progress, 3)
    
    local SliderButton = Instance.new("TextButton", SliderBg)
    SliderButton.Name = "SliderButton"
    SliderButton.Size = UDim2.new(0, 16, 0, 16)
    SliderButton.Position = UDim2.new(math.clamp((CurrentValue - Min) / (Max - Min), 0, 1), -8, 0.5, -8)
    SliderButton.BackgroundColor3 = Theme.Primary
    SliderButton.Text = ""
    SliderButton.AutoButtonColor = false
    SliderButton.BorderSizePixel = 0
    AddCorner(SliderButton, 8)
    AddStroke(SliderButton, Theme.Text, 1)
    
    local SliderActive = false
    local function UpdateSlider(input)
        local MouseX = input.Position.X
        local SliderStart = SliderBg.AbsolutePosition.X
        local SliderEnd = SliderStart + SliderBg.AbsoluteSize.X
        local Percent = math.clamp((MouseX - SliderStart) / (SliderEnd - SliderStart), 0, 1)
        local NewValue = math.floor((Min + (Max - Min) * Percent) / Step) * Step
        
        if ConfigTable then ConfigTable[ConfigKey] = NewValue end
        SliderLabel.Text = Title .. ": " .. NewValue
        Tween(Progress, {Size = UDim2.new(Percent, 0, 1, 0)}, 0.05)
        Tween(SliderButton, {Position = UDim2.new(Percent, -8, 0.5, -8)}, 0.05)
        if Callback then pcall(function() Callback(NewValue) end) end
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

-- ✅ AddLabel - MAIN LEVEL
function UI_Library:AddLabel(ParentPage, Text)
    local LabelFrame = Instance.new("TextLabel", ParentPage)
    LabelFrame.Name = "Label_" .. Text:gsub(" ", "_")
    LabelFrame.Size = UDim2.new(1, -20, 0, 40)
    LabelFrame.BackgroundColor3 = Theme.ItemBg
    LabelFrame.Text = Text
    LabelFrame.TextColor3 = Theme.TextSecondary
    LabelFrame.Font = Enum.Font.GothamBold
    LabelFrame.TextSize = 12
    LabelFrame.BorderSizePixel = 0
    AddCorner(LabelFrame, 8)
    AddStroke(LabelFrame, Theme.Border, 1)
end

-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║                    INIT & CREATE TAB (No functions inside)
-- ╚══════════════════════════════════════════════════════════════════════════════╝

function UI_Library:Init()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Kanyapak_Pro_V45"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndex = 100
    
    local ToggleIcon = Instance.new("TextButton", ScreenGui)
    ToggleIcon.Name = "ToggleIcon"
    ToggleIcon.Size = UDim2.new(0, 100, 0, 50)
    ToggleIcon.Position = UDim2.new(1, -120, 0.5, 0)
    ToggleIcon.BackgroundColor3 = Theme.Primary
    ToggleIcon.Text = "KANSHOP"
    ToggleIcon.TextColor3 = Color3.new(1, 1, 1)
    ToggleIcon.Font = Enum.Font.GothamBold
    ToggleIcon.TextSize = 14
    ToggleIcon.AutoButtonColor = false
    AddCorner(ToggleIcon, 12)
    AddStroke(ToggleIcon, Theme.Primary, 2)
    
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 700, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false
    MainFrame.ClipsDescendants = true
    MainFrame.ZIndex = 101
    AddCorner(MainFrame, 15)
    AddStroke(MainFrame, Theme.Border, 2)
    
    local HeaderBar = Instance.new("Frame", MainFrame)
    HeaderBar.Name = "HeaderBar"
    HeaderBar.Size = UDim2.new(1, 0, 0, 60)
    HeaderBar.BackgroundColor3 = Theme.Sidebar
    HeaderBar.BorderSizePixel = 0
    AddCorner(HeaderBar, 15)
    
    local Title = Instance.new("TextLabel", HeaderBar)
    Title.Size = UDim2.new(0.6, 0, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.Text = "💎 KANYAPAK V4.5"
    Title.TextColor3 = Theme.Primary
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local CloseBtn = Instance.new("TextButton", HeaderBar)
    CloseBtn.Size = UDim2.new(0, 40, 0, 40)
    CloseBtn.Position = UDim2.new(1, -50, 0, 10)
    CloseBtn.BackgroundColor3 = Theme.Danger
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.new(1, 1, 1)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 16
    CloseBtn.AutoButtonColor = false
    AddCorner(CloseBtn, 8)
    
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        MainFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 700, 0, 500)
    end)
    
    MakeDraggable(MainFrame, HeaderBar)
    
    local Sidebar = Instance.new("Frame", MainFrame)
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 180, 1, -65)
    Sidebar.Position = UDim2.new(0, 0, 0, 60)
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    
    local TabContainer = Instance.new("ScrollingFrame", Sidebar)
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ScrollBarThickness = 3
    TabContainer.ScrollBarImageColor3 = Theme.ScrollBar
    
    local TabListLayout = Instance.new("UIListLayout", TabContainer)
    TabListLayout.Padding = UDim.new(0, 8)
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local ContentArea = Instance.new("Frame", MainFrame)
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -190, 1, -65)
    ContentArea.Position = UDim2.new(0, 185, 0, 60)
    ContentArea.BackgroundTransparency = 1
    ContentArea.BorderSizePixel = 0
    ContentArea.ClipsDescendants = true
    
    local ResizeHandle = Instance.new("TextLabel", MainFrame)
    ResizeHandle.Name = "ResizeHandle"
    ResizeHandle.Size = UDim2.new(0, 25, 0, 25)
    ResizeHandle.Position = UDim2.new(1, -25, 1, -25)
    ResizeHandle.BackgroundColor3 = Theme.Primary
    ResizeHandle.Text = "◢"
    ResizeHandle.TextColor3 = Color3.new(1, 1, 1)
    ResizeHandle.TextSize = 18
    ResizeHandle.Font = Enum.Font.GothamBold
    ResizeHandle.BorderSizePixel = 0
    AddCorner(ResizeHandle, 5)
    
    local Resizing = false
    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Resizing = true
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if Resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local NewWidth = math.max(500, Mouse.X - MainFrame.AbsolutePosition.X)
            local NewHeight = math.max(350, Mouse.Y - MainFrame.AbsolutePosition.Y)
            MainFrame.Size = UDim2.new(0, NewWidth, 0, NewHeight)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Resizing = false
        end
    end)
    
    ToggleIcon.MouseButton1Click:Connect(function()
        if MainFrame.Visible then
            Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
            task.wait(0.3)
            MainFrame.Visible = false
            MainFrame.Size = UDim2.new(0, 700, 0, 500)
        else
            MainFrame.Visible = true
            Tween(MainFrame, {Size = UDim2.new(0, 700, 0, 500)}, 0.3)
        end
    end)
    
    -- ✅ CreateTab - NO functions inside
    function UI_Library:CreateTab(TabName)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Name = TabName:gsub(" ", "_")
        TabBtn.Size = UDim2.new(0.9, 0, 0, 45)
        TabBtn.BackgroundColor3 = Theme.ItemBg
        TabBtn.Text = TabName
        TabBtn.TextColor3 = Theme.TextSecondary
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 12
        TabBtn.AutoButtonColor = false
        TabBtn.TextWrapped = true
        AddCorner(TabBtn, 8)
        
        local TabContent = Instance.new("ScrollingFrame", ContentArea)
        TabContent.Name = TabName:gsub(" ", "_") .. "_Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Theme.ScrollBar
        TabContent.ClipsDescendants = true
        
        local ContentLayout = Instance.new("UIListLayout", TabContent)
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        TabBtn.MouseButton1Click:Connect(function()
            for _, Child in pairs(ContentArea:GetChildren()) do
                if Child:IsA("ScrollingFrame") then Child.Visible = false end
            end
            for _, Btn in pairs(TabContainer:GetChildren()) do
                if Btn:IsA("TextButton") then
                    Tween(Btn, {BackgroundColor3 = Theme.ItemBg, TextColor3 = Theme.TextSecondary}, 0.2)
                end
            end
            TabContent.Visible = true
            Tween(TabBtn, {BackgroundColor3 = Theme.Primary, TextColor3 = Color3.new(1, 1, 1)}, 0.2)
        end)
        
        TabBtn.MouseEnter:Connect(function()
            if not TabContent.Visible then
                Tween(TabBtn, {BackgroundColor3 = Theme.ItemBgHover}, 0.2)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if not TabContent.Visible then
                Tween(TabBtn, {BackgroundColor3 = Theme.ItemBg}, 0.2)
            end
        end)
        
        return TabContent
    end
    
    return UI_Library
end

return UI_Library
