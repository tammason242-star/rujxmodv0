if _G.Kanyapak_Executed then return end
_G.Kanyapak_Executed = true

print("\n[KANYAPAK V3.0] Loading...\n")

local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local IsMobile = UIS.TouchEnabled and not UIS.MouseEnabled

-- GLOBAL DATA
_G.Zenith_Data = {
    Version = "3.0",
    IsMobile = IsMobile,
    CurrentSea = 1,
    Config = {
        Farm = {Enabled=true, Level=true, Mastery=true, Tool="Melee", BringMob=true, Distance=25, AutoSell=false, UseAbilities=true, AbilityDelay=0.5},
        Player = {Speed=25, Jump=60, InfJump=false, NoClip=false, AntiStun=true, AntiKnockback=false, FlightMode=false, FlightSpeed=30},
        Visuals = {FruitESP=false, PlayerESP=false, ChestESP=false, FullBright=false, IslandESP=false},
        Misc = {AutoRaid=false, AutoNewWorld=false, FruitSniper=false, AntiAFK=true},
        Advanced = {DebugMode=true}
    },
    Statistics = {SessionTime=0, MobsKilled=0, ExpGained=0, SessionStart=tick()}
}

-- THEME
local Theme = {
    Primary = Color3.fromRGB(0, 255, 127),
    Secondary = Color3.fromRGB(255, 85, 127),
    Background = Color3.fromRGB(15, 15, 15),
    Surface = Color3.fromRGB(25, 25, 25),
    Surface2 = Color3.fromRGB(35, 35, 35),
    Text = Color3.fromRGB(220, 220, 220),
    TextDark = Color3.fromRGB(150, 150, 150),
    Accent = Color3.fromRGB(0, 150, 255),
    Success = Color3.fromRGB(0, 255, 127),
    Warning = Color3.fromRGB(255, 165, 0),
    Danger = Color3.fromRGB(255, 50, 50)
}

-- TWEEN HELPER
local function Tween(Obj, Dur, Props)
    if not Obj then return nil end
    local T = TS:Create(Obj, TweenInfo.new(Dur, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), Props)
    T:Play()
    return T
end

-- CREATE SCREENGUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KanyapakShop_V3"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
print("[UI] ScreenGui created")

-- FLOATING ICON
local Icon = Instance.new("TextButton")
Icon.Name = "FloatingShopIcon"
Icon.Size = UDim2.new(0, 70, 0, 70)
Icon.Position = UDim2.new(1, -90, 1, -100)
Icon.BackgroundColor3 = Theme.Primary
Icon.BorderSizePixel = 0
Icon.Text = "🛍️"
Icon.TextSize = 35
Icon.TextColor3 = Color3.fromRGB(255, 255, 255)
Icon.Font = Enum.Font.GothamBold
Icon.AutoButtonColor = false
Icon.Parent = ScreenGui
Icon.ZIndex = 500

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = Icon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Theme.Secondary
IconStroke.Thickness = 3
IconStroke.Parent = Icon

print("[UI] Floating icon created")

-- MAIN MENU FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "KanyapakMainMenu"
MainFrame.Size = UDim2.new(0, 450, 0, 700)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -350)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Visible = false
MainFrame.ZIndex = 400

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Primary
MainStroke.Thickness = 3
MainStroke.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

print("[UI] Main frame created")

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Theme.Surface
Header.BorderSizePixel = 0
Header.Parent = MainFrame
Header.ZIndex = 401

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Text = "⭐ KANYAPAK V3"
Title.Size = UDim2.new(0, 300, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Theme.Primary
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Header
Title.ZIndex = 402

local SeaLabel = Instance.new("TextLabel")
SeaLabel.Text = "SEA 1"
SeaLabel.Size = UDim2.new(0, 70, 0, 35)
SeaLabel.Position = UDim2.new(1, -75, 0, 7)
SeaLabel.BackgroundColor3 = Theme.Accent
SeaLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
SeaLabel.Font = Enum.Font.GothamBold
SeaLabel.TextSize = 12
SeaLabel.BorderSizePixel = 0
SeaLabel.Parent = Header
SeaLabel.ZIndex = 402

local SeaCorner = Instance.new("UICorner")
SeaCorner.CornerRadius = UDim.new(0, 8)
SeaCorner.Parent = SeaLabel

-- CLOSE BUTTON
local CloseBtn = Instance.new("TextButton")
CloseBtn.Text = "✕"
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 5)
CloseBtn.BackgroundColor3 = Theme.Danger
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header
CloseBtn.ZIndex = 402

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- CONTENT SCROLLFRAME
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -10, 1, -60)
Content.Position = UDim2.new(0, 5, 0, 55)
Content.BackgroundTransparency = 1
Content.ScrollBarThickness = 3
Content.ScrollBarImageColor3 = Theme.Primary
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.Parent = MainFrame
Content.ZIndex = 401

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.Parent = Content

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Content.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
end)

print("[UI] Content area created")

-- CREATE TOGGLE FUNCTION
local function CreateToggle(Parent, Icon, Text, Config, Key, Desc)
    Desc = Desc or ""
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 420, 0, 50)
    ToggleBtn.BackgroundColor3 = Theme.Surface2
    ToggleBtn.Text = ""
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.Parent = Parent
    ToggleBtn.ZIndex = 402
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleBtn
    
    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = Theme.TextDark
    ToggleStroke.Thickness = 1
    ToggleStroke.Transparency = 0.7
    ToggleStroke.Parent = ToggleBtn
    
    -- Icon
    local IconLabel = Instance.new("TextLabel")
    IconLabel.Text = Icon
    IconLabel.Size = UDim2.new(0, 40, 0, 40)
    IconLabel.Position = UDim2.new(0, 8, 0.5, -20)
    IconLabel.BackgroundColor3 = Theme.Primary
    IconLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.TextSize = 20
    IconLabel.BorderSizePixel = 0
    IconLabel.Parent = ToggleBtn
    IconLabel.ZIndex = 403
    
    local IconCorner2 = Instance.new("UICorner")
    IconCorner2.CornerRadius = UDim.new(0, 6)
    IconCorner2.Parent = IconLabel
    
    -- Info Container
    local Info = Instance.new("Frame")
    Info.Size = UDim2.new(0, 280, 1, 0)
    Info.Position = UDim2.new(0, 55, 0, 0)
    Info.BackgroundTransparency = 1
    Info.Parent = ToggleBtn
    Info.ZIndex = 403
    
    local Label = Instance.new("TextLabel")
    Label.Text = Text
    Label.Size = UDim2.new(1, 0, 0, 25)
    Label.Position = UDim2.new(0, 0, 0, 5)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 13
    Label.Parent = Info
    Label.ZIndex = 403
    
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Text = Desc
    DescLabel.Size = UDim2.new(1, 0, 0, 18)
    DescLabel.Position = UDim2.new(0, 0, 0, 28)
    DescLabel.BackgroundTransparency = 1
    DescLabel.TextColor3 = Theme.TextDark
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextSize = 11
    DescLabel.Parent = Info
    DescLabel.ZIndex = 403
    
    -- Toggle Switch
    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0, 50, 0, 28)
    Switch.Position = UDim2.new(1, -60, 0.5, -14)
    Switch.BackgroundColor3 = Config[Key] and Theme.Success or Theme.TextDark
    Switch.BorderSizePixel = 0
    Switch.Parent = ToggleBtn
    Switch.ZIndex = 403
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(0, 14)
    SwitchCorner.Parent = Switch
    
    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 24, 0, 24)
    Dot.Position = Config[Key] and UDim2.new(0, 23, 0.5, -12) or UDim2.new(0, 2, 0.5, -12)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.BorderSizePixel = 0
    Dot.Parent = Switch
    Dot.ZIndex = 404
    
    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = Dot
    
    -- Click Event
    ToggleBtn.MouseButton1Click:Connect(function()
        Config[Key] = not Config[Key]
        Tween(Switch, 0.3, {BackgroundColor3 = Config[Key] and Theme.Success or Theme.TextDark})
        Tween(Dot, 0.3, {Position = Config[Key] and UDim2.new(0, 23, 0.5, -12) or UDim2.new(0, 2, 0.5, -12)})
        print("[TOGGLE] " .. Text .. ": " .. (Config[Key] and "✅ ON" or "❌ OFF"))
    end)
    
    ToggleBtn.MouseEnter:Connect(function()
        Tween(ToggleBtn, 0.2, {BackgroundColor3 = Theme.Surface})
    end)
    
    ToggleBtn.MouseLeave:Connect(function()
        Tween(ToggleBtn, 0.2, {BackgroundColor3 = Theme.Surface2})
    end)
end

-- CREATE SECTION FUNCTION
local function CreateSection(Parent, Title)
    local Section = Instance.new("TextButton")
    Section.Size = UDim2.new(0, 420, 0, 35)
    Section.BackgroundColor3 = Theme.Accent
    Section.Text = ""
    Section.AutoButtonColor = false
    Section.Parent = Parent
    Section.ZIndex = 402
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 8)
    SectionCorner.Parent = Section
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Text = Title
    SectionTitle.Size = UDim2.new(1, -30, 1, 0)
    SectionTitle.Position = UDim2.new(0, 10, 0, 0)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextSize = 13
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = Section
    SectionTitle.ZIndex = 403
    
    Section.MouseEnter:Connect(function()
        Tween(Section, 0.2, {BackgroundColor3 = Theme.Primary})
    end)
    
    Section.MouseLeave:Connect(function()
        Tween(Section, 0.2, {BackgroundColor3 = Theme.Accent})
    end)
end

-- BUILD UI
print("[UI] Building sections...\n")

CreateSection(Content, "🌾 FARMING")
CreateToggle(Content, "🎯", "Auto Farm Level", _G.Zenith_Data.Config.Farm, "Level", "ฟาร์มเลเวล")
CreateToggle(Content, "⚔️", "Auto Mastery", _G.Zenith_Data.Config.Farm, "Mastery", "ฟาร์มอาวุธ")
CreateToggle(Content, "🧲", "Bring Mobs", _G.Zenith_Data.Config.Farm, "BringMob", "รวมมอนสเตอร์")
CreateToggle(Content, "💰", "Auto Sell", _G.Zenith_Data.Config.Farm, "AutoSell", "ขายอัตโนมัติ")

CreateSection(Content, "👤 PLAYER")
CreateToggle(Content, "🚀", "Infinite Jump", _G.Zenith_Data.Config.Player, "InfJump", "กระโดดไม่จำกัด")
CreateToggle(Content, "👻", "No Clip", _G.Zenith_Data.Config.Player, "NoClip", "ผ่านผนัง")
CreateToggle(Content, "🛡️", "Anti-Stun", _G.Zenith_Data.Config.Player, "AntiStun", "ป้องกันสตั้น")
CreateToggle(Content, "🪂", "Flight Mode", _G.Zenith_Data.Config.Player, "FlightMode", "บินได้")

CreateSection(Content, "👁️ VISUALS")
CreateToggle(Content, "🍎", "Fruit ESP", _G.Zenith_Data.Config.Visuals, "FruitESP", "มองผลไม้")
CreateToggle(Content, "👥", "Player ESP", _G.Zenith_Data.Config.Visuals, "PlayerESP", "มองผู้เล่น")
CreateToggle(Content, "💎", "Chest ESP", _G.Zenith_Data.Config.Visuals, "ChestESP", "มองหีบ")
CreateToggle(Content, "🌞", "Full Bright", _G.Zenith_Data.Config.Visuals, "FullBright", "สว่างเต็ม")
CreateToggle(Content, "🗺️", "Island ESP", _G.Zenith_Data.Config.Visuals, "IslandESP", "แสดงเกาะ")

CreateSection(Content, "✨ FEATURES")
CreateToggle(Content, "🎪", "Auto Raid", _G.Zenith_Data.Config.Misc, "AutoRaid", "Raid อัตโนมัติ")
CreateToggle(Content, "🌍", "Auto New World", _G.Zenith_Data.Config.Misc, "AutoNewWorld", "เปลี่ยนโลก")
CreateToggle(Content, "⏰", "Anti-AFK", _G.Zenith_Data.Config.Misc, "AntiAFK", "ป้องกันเตะ")

-- STATS FRAME
local Stats = Instance.new("Frame")
Stats.Size = UDim2.new(1, 0, 0, 40)
Stats.BackgroundColor3 = Theme.Surface
Stats.BorderSizePixel = 0
Stats.Parent = MainFrame
Stats.Position = UDim2.new(0, 0, 1, -40)
Stats.ZIndex = 401

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 15)
StatsCorner.Parent = Stats

local StatsText = Instance.new("TextLabel")
StatsText.Text = "⏱️ 0s | 🎯 0 Mobs | ⭐ 0 Exp"
StatsText.Size = UDim2.new(1, -20, 1, 0)
StatsText.Position = UDim2.new(0, 10, 0, 0)
StatsText.BackgroundTransparency = 1
StatsText.TextColor3 = Theme.Primary
StatsText.Font = Enum.Font.Gotham
StatsText.TextSize = 11
StatsText.TextXAlignment = Enum.TextXAlignment.Left
StatsText.Parent = Stats
StatsText.ZIndex = 402

RS.Heartbeat:Connect(function()
    if _G.Zenith_Data.Statistics then
        local Time = math.floor(_G.Zenith_Data.Statistics.SessionTime)
        StatsText.Text = string.format("⏱️ %ds | 🎯 %d Mobs | ⭐ %d Exp", Time, _G.Zenith_Data.Statistics.MobsKilled, _G.Zenith_Data.Statistics.ExpGained)
    end
end)

print("[UI] All toggles created\n")

-- MENU TOGGLE
local MenuOpen = false

local function OpenMenu()
    if MenuOpen then return end
    MenuOpen = true
    MainFrame.Visible = true
    MainFrame.Position = UDim2.new(1.5, 0, 0.5, -350)
    Tween(MainFrame, 0.4, {Position = UDim2.new(0.5, -225, 0.5, -350)})
    Tween(Icon, 0.3, {BackgroundColor3 = Theme.Secondary})
end

local function CloseMenu()
    if not MenuOpen then return end
    MenuOpen = false
    Tween(MainFrame, 0.4, {Position = UDim2.new(1.5, 0, 0.5, -350)})
    task.wait(0.4)
    MainFrame.Visible = false
    Tween(Icon, 0.3, {BackgroundColor3 = Theme.Primary})
end

-- ICON CLICK
Icon.MouseButton1Click:Connect(function()
    if MenuOpen then CloseMenu() else OpenMenu() end
end)

Icon.TouchTap:Connect(function()
    if MenuOpen then CloseMenu() else OpenMenu() end
end)

-- ICON HOVER
Icon.MouseEnter:Connect(function()
    Tween(Icon, 0.2, {Size = UDim2.new(0, 80, 0, 80)})
end)

Icon.MouseLeave:Connect(function()
    if not MenuOpen then
        Tween(Icon, 0.2, {Size = UDim2.new(0, 70, 0, 70)})
    end
end)

-- CLOSE BUTTON
CloseBtn.MouseButton1Click:Connect(function()
    CloseMenu()
end)

CloseBtn.MouseEnter:Connect(function()
    Tween(CloseBtn, 0.2, {BackgroundColor3 = Theme.Warning})
end)

CloseBtn.MouseLeave:Connect(function()
    Tween(CloseBtn, 0.2, {BackgroundColor3 = Theme.Danger})
end)

-- DRAG FUNCTION
local Dragging = false
local DragStart = nil
local DragPos = nil

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = input.Position
        DragPos = MainFrame.Position
    end
end)

Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if Dragging and DragStart and DragPos then
        local Delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(DragPos.X.Scale, DragPos.X.Offset + Delta.X, DragPos.Y.Scale, DragPos.Y.Offset + Delta.Y)
    end
end)

-- HEARTBEAT
RS.Heartbeat:Connect(function()
    if _G.Zenith_Data and _G.Zenith_Data.Statistics then
        _G.Zenith_Data.Statistics.SessionTime = tick() - _G.Zenith_Data.Statistics.SessionStart
    end
end)

-- ANTI-AFK
if _G.Zenith_Data.Config.Misc.AntiAFK then
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

print(string.rep("=", 60))
print("✅ KANYAPAK V3.0 - READY")
print(string.rep("=", 60))
print("\n🛍️ Click icon at bottom-right corner\n")

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🎉 KANYAPAK V3.0",
    Text = "Ready! Tap 🛍️ icon",
    Duration = 5
})
