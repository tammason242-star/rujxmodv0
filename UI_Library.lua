--[[
╔════════════════════════════════════════════════════════════════════╗
║           KANYAPAK V3.0 - ULTIMATE UI (CYBER BLUE THEME)          ║
║         Advanced Features • Smooth Animations • Professional UI     ║
╚════════════════════════════════════════════════════════════════════╝
]]

if _G.Kanyapak_Executed then return end
_G.Kanyapak_Executed = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- GLOBAL DATA
_G.Zenith_Data = {
    Version = "3.0",
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

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎨 CYBER BLUE THEME
-- ═══════════════════════════════════════════════════════════════════════════

local Theme = {
    Primary = Color3.fromRGB(0, 200, 255),      -- Cyan
    Secondary = Color3.fromRGB(0, 150, 255),    -- Bright Blue
    Tertiary = Color3.fromRGB(0, 100, 200),     -- Deep Blue
    
    Background = Color3.fromRGB(10, 15, 25),    -- Very Dark Blue
    Surface = Color3.fromRGB(15, 25, 40),       -- Dark Surface
    Surface2 = Color3.fromRGB(20, 35, 55),      -- Lighter Surface
    SurfaceHover = Color3.fromRGB(25, 45, 70),  -- Hover State
    
    Text = Color3.fromRGB(220, 240, 255),       -- Light Cyan
    TextDark = Color3.fromRGB(150, 170, 190),   -- Medium Gray
    TextMuted = Color3.fromRGB(100, 120, 140),  -- Dark Gray
    
    Accent = Color3.fromRGB(0, 255, 200),       -- Neon Cyan
    Success = Color3.fromRGB(0, 255, 150),      -- Green Cyan
    Warning = Color3.fromRGB(255, 200, 0),      -- Gold
    Danger = Color3.fromRGB(255, 80, 80),       -- Red
    
    GlowBlue = Color3.fromRGB(0, 180, 255),
    NetGreen = Color3.fromRGB(0, 200, 100),
    CyberPurple = Color3.fromRGB(150, 50, 255)
}

-- ═══════════════════════════════════════════════════════════════════════════
-- 🔊 SOUND EFFECTS
-- ═══════════════════════════════════════════════════════════════════════════

local function PlaySound(SoundId, Volume, Parent)
    Volume = Volume or 0.5
    Parent = Parent or workspace
    task.spawn(function()
        pcall(function()
            local Sound = Instance.new("Sound")
            Sound.SoundId = SoundId
            Sound.Volume = Volume
            Sound.Parent = Parent
            Debris:AddItem(Sound, 2)
            Sound:Play()
        end)
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- ⚡ ANIMATION LIBRARY
-- ═══════════════════════════════════════════════════════════════════════════

local function Tween(Obj, Duration, Properties, Style, Direction)
    if not Obj then return nil end
    Style = Style or Enum.EasingStyle.Quad
    Direction = Direction or Enum.EasingDirection.InOut
    local TweenInfo = TweenInfo.new(Duration, Style, Direction)
    local Tween = TweenService:Create(Obj, TweenInfo, Properties)
    Tween:Play()
    return Tween
end

local function ColorTween(Obj, Color, Duration)
    Tween(Obj, Duration or 0.2, {BackgroundColor3 = Color})
end

local function Scale(Obj, Scale, Duration)
    local OrigSize = Obj.Size
    Obj.Size = OrigSize * Scale
    Tween(Obj, Duration or 0.15, {Size = OrigSize})
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🗑️ CLEANUP & INIT
-- ═══════════════════════════════════════════════════════════════════════════

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("KanyapakV3") then
    PlayerGui.KanyapakV3:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KanyapakV3"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

print("[KANYAPAK V3.0] Loading UI...\n")

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎪 FLOATING ICON
-- ═══════════════════════════════════════════════════════════════════════════

local Icon = Instance.new("TextButton")
Icon.Name = "MainIcon"
Icon.Size = UDim2.new(0, 75, 0, 75)
Icon.Position = UDim2.new(1, -95, 1, -100)
Icon.BackgroundColor3 = Theme.Background
Icon.BorderSizePixel = 0
Icon.Text = "KX"
Icon.TextColor3 = Theme.Primary
Icon.Font = Enum.Font.GothamBlack
Icon.TextSize = 26
Icon.AutoButtonColor = false
Icon.Parent = ScreenGui
Icon.ZIndex = 500

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = Icon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Theme.Primary
IconStroke.Thickness = 3
IconStroke.Transparency = 0.3
IconStroke.Parent = Icon

-- Icon Animations
Icon.MouseEnter:Connect(function()
    ColorTween(Icon, Theme.Secondary, 0.2)
    Scale(Icon, 1.1, 0.15)
    PlaySound("rbxassetid://12221969", 0.3)
end)

Icon.MouseLeave:Connect(function()
    ColorTween(Icon, Theme.Background, 0.2)
    Scale(Icon, 1.0, 0.15)
end)

Icon.MouseButton1Click:Connect(function()
    Scale(Icon, 0.9, 0.1)
    PlaySound("rbxassetid://12221967", 0.4)
end)

print("[UI] Floating Icon Created ✅")

-- ═══════════════════════════════════════════════════════════════════════════
-- 🪟 MAIN WINDOW
-- ═══════════════════════════════════════════════════════════════════════════

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainHub"
MainFrame.Size = UDim2.new(0, 600, 0, 750)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -375)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
MainFrame.ZIndex = 400

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Primary
MainStroke.Thickness = 2.5
MainStroke.Transparency = 0.2
MainStroke.Parent = MainFrame

print("[UI] Main Frame Created ✅")

-- ═══════════════════════════════════════════════════════════════════════════
-- 📌 HEADER
-- ═══════════════════════════════════════════════════════════════════════════

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Theme.Surface
Header.BorderSizePixel = 0
Header.Parent = MainFrame
Header.ZIndex = 401

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

local HeaderStroke = Instance.new("UIStroke")
HeaderStroke.Color = Theme.Secondary
HeaderStroke.Thickness = 1.5
HeaderStroke.Transparency = 0.5
HeaderStroke.Parent = Header

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "  ⚙️ KANYAPAK V3.0"
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Theme.Primary
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.Parent = Header
Title.ZIndex = 402

-- FPS Label
local FPSLabel = Instance.new("TextLabel")
FPSLabel.Text = "FPS: 60"
FPSLabel.Size = UDim2.new(0.2, 0, 1, 0)
FPSLabel.Position = UDim2.new(0.65, 0, 0, 0)
FPSLabel.BackgroundTransparency = 1
FPSLabel.TextColor3 = Theme.Accent
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.TextSize = 13
FPSLabel.Parent = Header
FPSLabel.ZIndex = 402

local FrameCounter = 0
RunService.RenderStepped:Connect(function()
    FrameCounter = FrameCounter + 1
    if FrameCounter >= 30 then
        FPSLabel.Text = "FPS: " .. math.round(1 / game:GetService("RunService").RenderStepped:Wait())
        FrameCounter = 0
    end
end)

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 55, 0, 55)
CloseBtn.Position = UDim2.new(1, -60, 0, 2.5)
CloseBtn.BackgroundColor3 = Theme.Danger
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBlack
CloseBtn.TextSize = 20
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header
CloseBtn.ZIndex = 402

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
    ColorTween(CloseBtn, Theme.Warning, 0.2)
end)

CloseBtn.MouseLeave:Connect(function()
    ColorTween(CloseBtn, Theme.Danger, 0.2)
end)

CloseBtn.MouseButton1Click:Connect(function()
    Scale(CloseBtn, 0.85, 0.1)
    Tween(MainFrame, 0.3, {Position = UDim2.new(0.5, -300, 2, -375)})
    task.wait(0.3)
    MainFrame.Visible = false
    PlaySound("rbxassetid://12221966", 0.4)
end)

print("[UI] Header Created ✅")

-- ═══════════════════════════════════════════════════════════════════════════
-- 📂 SIDEBAR & TABS
-- ═══════════════════════════════════════════════════════════════════════════

local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Size = UDim2.new(0, 150, 1, -65)
Sidebar.Position = UDim2.new(0, 5, 0, 60)
Sidebar.BackgroundTransparency = 1
Sidebar.ScrollBarThickness = 2
Sidebar.ScrollBarImageColor3 = Theme.Primary
Sidebar.Parent = MainFrame
Sidebar.ZIndex = 401

local SideList = Instance.new("UIListLayout")
SideList.Padding = UDim.new(0, 6)
SideList.Parent = Sidebar

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -165, 1, -65)
ContentArea.Position = UDim2.new(0, 155, 0, 60)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame
ContentArea.ZIndex = 401

local Pages = {}

local function CreateTab(TabName)
    -- Tab Button
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, -5, 0, 50)
    TabBtn.Text = TabName
    TabBtn.BackgroundColor3 = Theme.Surface2
    TabBtn.TextColor3 = Theme.TextDark
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 12
    TabBtn.BorderSizePixel = 0
    TabBtn.AutoButtonColor = false
    TabBtn.Parent = Sidebar
    TabBtn.ZIndex = 402

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabBtn

    local TabStroke = Instance.new("UIStroke")
    TabStroke.Color = Theme.Secondary
    TabStroke.Thickness = 1
    TabStroke.Transparency = 0.8
    TabStroke.Parent = TabBtn

    -- Page
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Theme.Primary
    Page.Visible = false
    Page.Parent = ContentArea
    Page.ZIndex = 401

    local PageList = Instance.new("UIListLayout")
    PageList.Padding = UDim.new(0, 8)
    PageList.Parent = Page

    Page:GetPropertyChangedSignal("CanvasSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 16)
    end)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true

        for _, b in pairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                ColorTween(b, Theme.Surface2, 0.2)
                b.TextColor3 = Theme.TextDark
            end
        end

        ColorTween(TabBtn, Theme.Tertiary, 0.2)
        TabBtn.TextColor3 = Theme.Accent
        PlaySound("rbxassetid://12221967", 0.3)
    end)

    TabBtn.MouseEnter:Connect(function()
        if not Page.Visible then
            ColorTween(TabBtn, Theme.SurfaceHover, 0.15)
        end
    end)

    TabBtn.MouseLeave:Connect(function()
        if not Page.Visible then
            ColorTween(TabBtn, Theme.Surface2, 0.15)
        end
    end)

    Pages[TabName] = Page
    return Page
end

-- Create Tabs
local CombatTab = CreateTab("⚔️ Combat")
local PlayerTab = CreateTab("👤 Player")
local VisualTab = CreateTab("👁️ Visual")
local MiscTab = CreateTab("⚙️ Misc")

CombatTab.Visible = true
ColorTween(Sidebar:GetChildren()[1], Theme.Tertiary, 0)
Sidebar:GetChildren()[1].TextColor3 = Theme.Accent

print("[UI] Tabs Created ✅")

-- ═══════════════════════════════════════════════════════════════════════════
-- 🔧 UI BUILDERS
-- ═══════════════════════════════════════════════════════════════════════════

local function CreateSection(Page, Title)
    local Section = Instance.new("TextLabel")
    Section.Size = UDim2.new(1, 0, 0, 30)
    Section.Text = "  " .. Title
    Section.TextColor3 = Theme.TextMuted
    Section.BackgroundTransparency = 1
    Section.Font = Enum.Font.GothamBold
    Section.TextSize = 11
    Section.TextXAlignment = Enum.TextXAlignment.Left
    Section.Parent = Page
    Section.ZIndex = 402
end

local function CreateToggle(Page, IconText, Text, Config, Key, Desc)
    Desc = Desc or ""
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 55)
    ToggleFrame.BackgroundColor3 = Theme.Surface2
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = Page
    ToggleFrame.ZIndex = 402

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame

    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = Theme.Secondary
    ToggleStroke.Thickness = 1
    ToggleStroke.Transparency = 0.7
    ToggleStroke.Parent = ToggleFrame

    -- Icon
    local Icon = Instance.new("TextLabel")
    Icon.Text = IconText
    Icon.Size = UDim2.new(0, 45, 0, 45)
    Icon.Position = UDim2.new(0, 5, 0.5, -22)
    Icon.BackgroundColor3 = Theme.Primary
    Icon.TextColor3 = Theme.Background
    Icon.Font = Enum.Font.GothamBold
    Icon.TextSize = 18
    Icon.BorderSizePixel = 0
    Icon.Parent = ToggleFrame
    Icon.ZIndex = 403

    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 6)
    IconCorner.Parent = Icon

    -- Text
    local Label = Instance.new("TextLabel")
    Label.Text = Text
    Label.Size = UDim2.new(0, 200, 0, 28)
    Label.Position = UDim2.new(0, 55, 0, 5)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    Label.ZIndex = 403

    -- Description
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Text = Desc
    DescLabel.Size = UDim2.new(0, 200, 0, 18)
    DescLabel.Position = UDim2.new(0, 55, 0, 32)
    DescLabel.BackgroundTransparency = 1
    DescLabel.TextColor3 = Theme.TextMuted
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.TextSize = 10
    DescLabel.TextXAlignment = Enum.TextXAlignment.Left
    DescLabel.Parent = ToggleFrame
    DescLabel.ZIndex = 403

    -- Toggle Switch
    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0, 50, 0, 28)
    Switch.Position = UDim2.new(1, -55, 0.5, -14)
    Switch.BackgroundColor3 = Config[Key] and Theme.Success or Theme.Surface
    Switch.BorderSizePixel = 0
    Switch.Parent = ToggleFrame
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
    local ClickDetector = Instance.new("TextButton")
    ClickDetector.Size = UDim2.new(1, 0, 1, 0)
    ClickDetector.BackgroundTransparency = 1
    ClickDetector.Text = ""
    ClickDetector.AutoButtonColor = false
    ClickDetector.Parent = ToggleFrame
    ClickDetector.ZIndex = 405

    ClickDetector.MouseButton1Click:Connect(function()
        Config[Key] = not Config[Key]
        ColorTween(Switch, Config[Key] and Theme.Success or Theme.Surface, 0.2)
        Tween(Dot, 0.2, {Position = Config[Key] and UDim2.new(0, 23, 0.5, -12) or UDim2.new(0, 2, 0.5, -12)})
        Scale(Switch, 0.9, 0.1)
        PlaySound("rbxassetid://12221967", 0.4)
        print("[TOGGLE] " .. Text .. ": " .. (Config[Key] and "✅ ON" or "❌ OFF"))
    end)

    ClickDetector.MouseEnter:Connect(function()
        ColorTween(ToggleFrame, Theme.SurfaceHover, 0.15)
        Scale(ToggleFrame, 1.02, 0.1)
    end)

    ClickDetector.MouseLeave:Connect(function()
        ColorTween(ToggleFrame, Theme.Surface2, 0.15)
        Scale(ToggleFrame, 1.0, 0.1)
    end)
end

local function CreateSlider(Page, Text, Min, Max, Key, Config, Callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 70)
    SliderFrame.BackgroundColor3 = Theme.Surface2
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = Page
    SliderFrame.ZIndex = 402

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame

    -- Label
    local Label = Instance.new("TextLabel")
    Label.Text = Text .. ": " .. Config[Key]
    Label.Size = UDim2.new(1, -20, 0, 25)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    Label.ZIndex = 403

    -- Bar
    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, -20, 0, 10)
    Bar.Position = UDim2.new(0, 10, 0, 35)
    Bar.BackgroundColor3 = Theme.Surface
    Bar.BorderSizePixel = 0
    Bar.Parent = SliderFrame
    Bar.ZIndex = 403

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = Bar

    -- Fill
    local Fill = Instance.new("Frame")
    Fill.BackgroundColor3 = Theme.Primary
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar
    Fill.ZIndex = 404

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    -- Update Fill
    local StartPercent = (Config[Key] - Min) / (Max - Min)
    Fill.Size = UDim2.new(StartPercent, 0, 1, 0)

    -- Click Detection
    local function UpdateSlider(input)
        local pos = input.Position.X
        local percent = math.clamp((pos - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        local value = math.floor(Min + (Max - Min) * percent)
        
        Config[Key] = value
        Label.Text = Text .. ": " .. value
        Fill.Size = UDim2.new(percent, 0, 1, 0)
        
        if Callback then Callback(value) end
    end

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            UpdateSlider(input)
            
            local conn = UserInputService.InputChanged:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                    UpdateSlider(inp)
                end
            end)
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    conn:Disconnect()
                end
            end)
        end
    end)
end

local function CreateButton(Page, Text, Callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 45)
    Btn.Text = Text
    Btn.BackgroundColor3 = Theme.Tertiary
    Btn.TextColor3 = Theme.Text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 13
    Btn.BorderSizePixel = 0
    Btn.AutoButtonColor = false
    Btn.Parent = Page
    Btn.ZIndex = 402

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        Scale(Btn, 0.92, 0.1)
        PlaySound("rbxassetid://6895490539", 0.5)
        Callback()
    end)

    Btn.MouseEnter:Connect(function()
        ColorTween(Btn, Theme.Secondary, 0.2)
        Scale(Btn, 1.05, 0.1)
    end)

    Btn.MouseLeave:Connect(function()
        ColorTween(Btn, Theme.Tertiary, 0.2)
        Scale(Btn, 1.0, 0.1)
    end)
end

print("[UI] Builders Created ✅")

-- ═══════════════════════════════════════════════════════════════════════════
-- 📋 POPULATE TABS
-- ═══════════════════════════════════════════════════════════════════════════

-- Combat Tab
CreateSection(CombatTab, "⚔️ FARMING")
CreateToggle(CombatTab, "🎯", "Auto Farm", _G.Zenith_Data.Config.Farm, "Level", "自動でレベルをファーム")
CreateToggle(CombatTab, "⚔️", "Auto Mastery", _G.Zenith_Data.Config.Farm, "Mastery", "武器のマスタリーを自動")
CreateToggle(CombatTab, "🧲", "Bring Mobs", _G.Zenith_Data.Config.Farm, "BringMob", "敵を集める")
CreateToggle(CombatTab, "💰", "Auto Sell", _G.Zenith_Data.Config.Farm, "AutoSell", "自動で売却")

-- Player Tab
CreateSection(PlayerTab, "👤 MOVEMENT")
CreateSlider(PlayerTab, "Walk Speed", 16, 300, "Speed", _G.Zenith_Data.Config.Player, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)
CreateSlider(PlayerTab, "Jump Power", 50, 500, "Jump", _G.Zenith_Data.Config.Player)
CreateToggle(PlayerTab, "🚀", "Infinite Jump", _G.Zenith_Data.Config.Player, "InfJump", "無制限ジャンプ")
CreateToggle(PlayerTab, "👻", "No Clip", _G.Zenith_Data.Config.Player, "NoClip", "壁を通り抜け")

CreateSection(PlayerTab, "✨ ABILITIES")
CreateToggle(PlayerTab, "🛡️", "Anti-Stun", _G.Zenith_Data.Config.Player, "AntiStun", "スタンを防ぐ")
CreateToggle(PlayerTab, "🌪️", "Anti-Knockback", _G.Zenith_Data.Config.Player, "AntiKnockback", "ノックバック防止")
CreateToggle(PlayerTab, "🪂", "Flight Mode", _G.Zenith_Data.Config.Player, "FlightMode", "自由に飛行")

-- Visual Tab
CreateSection(VisualTab, "👁️ ESP")
CreateToggle(VisualTab, "🍎", "Fruit ESP", _G.Zenith_Data.Config.Visuals, "FruitESP", "悪魔の実を表示")
CreateToggle(VisualTab, "👥", "Player ESP", _G.Zenith_Data.Config.Visuals, "PlayerESP", "プレイヤーを表示")
CreateToggle(VisualTab, "💎", "Chest ESP", _G.Zenith_Data.Config.Visuals, "ChestESP", "宝箱を表示")
CreateToggle(VisualTab, "🗺️", "Island ESP", _G.Zenith_Data.Config.Visuals, "IslandESP", "島を表示")

CreateSection(VisualTab, "🌞 WORLD")
CreateToggle(VisualTab, "☀️", "Full Bright", _G.Zenith_Data.Config.Visuals, "FullBright", "明るい表示")

-- Misc Tab
CreateSection(MiscTab, "⚙️ SYSTEM")
CreateToggle(MiscTab, "🎪", "Auto Raid", _G.Zenith_Data.Config.Misc, "AutoRaid", "自動レイド")
CreateToggle(MiscTab, "🌍", "Auto New World", _G.Zenith_Data.Config.Misc, "AutoNewWorld", "ワールド変更自動")
CreateToggle(MiscTab, "⏰", "Anti-AFK", _G.Zenith_Data.Config.Misc, "AntiAFK", "AFK防止")

CreateSection(MiscTab, "💻 UTILITY")
CreateButton(MiscTab, "Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)
CreateButton(MiscTab, "Clear Cache", function()
    _G.Zenith_Data.Cache = {MobLocations={}, FruitLocations={}, PlayerData={}}
    print("✅ Cache Cleared")
end)

print("[UI] Tabs Populated ✅\n")

-- ═══════════════════════════════════════════════════════════════════════════
-- 📊 STATS FOOTER
-- ═══════════════════════════════════════════════════════════════════════════

local Footer = Instance.new("Frame")
Footer.Size = UDim2.new(1, 0, 0, 50)
Footer.BackgroundColor3 = Theme.Surface
Footer.BorderSizePixel = 0
Footer.Position = UDim2.new(0, 0, 1, -50)
Footer.Parent = MainFrame
Footer.ZIndex = 401

local FooterCorner = Instance.new("UICorner")
FooterCorner.CornerRadius = UDim.new(0, 15)
FooterCorner.Parent = Footer

local StatsText = Instance.new("TextLabel")
StatsText.Text = "⏱️ 0s | 🎯 0 Mobs | ⭐ 0 Exp | 💾 Ready"
StatsText.Size = UDim2.new(1, -20, 1, 0)
StatsText.Position = UDim2.new(0, 10, 0, 0)
StatsText.BackgroundTransparency = 1
StatsText.TextColor3 = Theme.Accent
StatsText.Font = Enum.Font.Gotham
StatsText.TextSize = 11
StatsText.TextXAlignment = Enum.TextXAlignment.Left
StatsText.Parent = Footer
StatsText.ZIndex = 402

RunService.Heartbeat:Connect(function()
    if _G.Zenith_Data.Statistics then
        local Time = math.floor(_G.Zenith_Data.Statistics.SessionTime)
        StatsText.Text = string.format("⏱️ %ds | 🎯 %d Mobs | ⭐ %d Exp | 💾 Ready", Time, _G.Zenith_Data.Statistics.MobsKilled, _G.Zenith_Data.Statistics.ExpGained)
    end
end)

print("[UI] Stats Footer Created ✅")

-- ═══════════════════════════════════════════════════════════════════════════
-- 🔌 OPEN/CLOSE MENU
-- ═══════════════════════════════════════════════════════════════════════════

Icon.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        Tween(MainFrame, 0.3, {Position = UDim2.new(0.5, -300, 2, -375)})
        task.wait(0.3)
        MainFrame.Visible = false
    else
        MainFrame.Visible = true
        MainFrame.Position = UDim2.new(0.5, -300, -1, -375)
        Tween(MainFrame, 0.4, {Position = UDim2.new(0.5, -300, 0.5, -375)})
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- 💾 DRAG FUNCTIONALITY
-- ═══════════════════════════════════════════════════════════════════════════

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

UserInputService.InputChanged:Connect(function(input)
    if Dragging and DragStart and DragPos then
        local Delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(DragPos.X.Scale, DragPos.X.Offset + Delta.X, DragPos.Y.Scale, DragPos.Y.Offset + Delta.Y)
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- ✅ STARTUP
-- ═══════════════════════════════════════════════════════════════════════════

RunService.Heartbeat:Connect(function()
    if _G.Zenith_Data.Statistics then
        _G.Zenith_Data.Statistics.SessionTime = tick() - _G.Zenith_Data.Statistics.SessionStart
    end
end)

-- Anti-AFK
if _G.Zenith_Data.Config.Misc.AntiAFK then
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

print(string.rep("=", 60))
print("✅ KANYAPAK V3.0 - FULLY LOADED")
print("🎨 Cyber Blue Theme: ACTIVE")
print("🔊 Sound Effects: ENABLED")
print("⚡ Animations: SMOOTH")
print(string.rep("=", 60))
print("\n📍 Click KX icon (bottom-right) to open menu\n")

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🎉 KANYAPAK V3.0",
    Text = "Cyber Blue Edition Ready! Click KX icon",
    Duration = 5
})
