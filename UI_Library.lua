--[[ 
    ⭐ KANYAPAK SHOP V3.0 - UI_Library.lua ⭐
    Premium Mobile-Optimized Interface System
    FIXED: Icon Button & Menu Display Issues
]]

local UI_Library = {}
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎨 THEME SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

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

-- ═══════════════════════════════════════════════════════════════════════════
-- 🔊 SOUND EFFECTS (ปลอดภัย - ถ้าไม่เล่นก็ไม่มีปัญหา)
-- ═══════════════════════════════════════════════════════════════════════════

local SoundAssets = {
    Toggle = "rbxassetid://12221967",
    Click = "rbxassetid://12221964",
    Open = "rbxassetid://12221969",
    Close = "rbxassetid://12221966",
    Hover = "rbxassetid://12221965"
}

local function PlaySound(SoundId, Volume)
    Volume = Volume or 0.5
    if not SoundId then return end
    task.spawn(function()
        pcall(function()
            local Sound = Instance.new("Sound")
            Sound.SoundId = SoundId
            Sound.Volume = Volume
            Sound.Parent = workspace
            game:GetService("Debris"):AddItem(Sound, 2)
            Sound:Play()
        end)
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- ⚡ ANIMATION HELPERS
-- ═══════════════════════════════════════════════════════════════════════════

local function CreateTween(Object, Duration, Properties, Style, Direction)
    if not Object then return nil end
    Style = Style or Enum.EasingStyle.Quad
    Direction = Direction or Enum.EasingDirection.InOut
    local TweenInfo = TweenInfo.new(Duration, Style, Direction)
    local Tween = TweenService:Create(Object, TweenInfo, Properties)
    Tween:Play()
    return Tween
end

local function PulseEffect(Object)
    if not Object then return end
    local OriginalSize = Object.Size
    CreateTween(Object, 0.1, { Size = OriginalSize + UDim2.new(0, 4, 0, 4) })
    task.wait(0.1)
    CreateTween(Object, 0.1, { Size = OriginalSize })
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 📌 MAIN UI INITIALIZATION - FIXED VERSION
-- ═══════════════════════════════════════════════════════════════════════════

function UI_Library:Init()
    print("🎨 [KANYAPAK SHOP V3] UI Initializing...\n")
    
    -- 1. MAIN SCREEN GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KanyapakShop_V3"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    print("✅ [UI] ScreenGui Created")
    
    -- 2. FLOATING SHOP ICON (ปุ่มสว่างสีเขียวที่มุมจอ)
    local FloatingIcon = Instance.new("TextButton")
    FloatingIcon.Name = "FloatingShopIcon"
    FloatingIcon.Size = UDim2.new(0, 70, 0, 70)
    FloatingIcon.Position = UDim2.new(1, -90, 1, -100)
    FloatingIcon.BackgroundColor3 = Theme.Primary
    FloatingIcon.BorderSizePixel = 0
    FloatingIcon.Text = "🛍️"
    FloatingIcon.TextSize = 35
    FloatingIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    FloatingIcon.Font = Enum.Font.GothamBold
    FloatingIcon.Parent = ScreenGui
    FloatingIcon.ZIndex = 500
    FloatingIcon.CanQuery = true
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(1, 0)
    IconCorner.Parent = FloatingIcon
    
    local IconStroke = Instance.new("UIStroke")
    IconStroke.Color = Theme.Secondary
    IconStroke.Thickness = 3
    IconStroke.Parent = FloatingIcon
    
    print("✅ [UI] Floating Icon Created at Bottom-Right Corner")
    
    -- 3. MAIN MENU FRAME (แผงเมนูหลัก)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "KanyapakMainMenu"
    MainFrame.Size = UDim2.new(0, 450, 0, 720)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -360)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    MainFrame.Visible = false  -- เริ่มต้นปิดอยู่
    MainFrame.ZIndex = 400
    MainFrame.CanQuery = true
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Theme.Primary
    MainStroke.Thickness = 3
    MainStroke.Parent = MainFrame
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 15)
    MainCorner.Parent = MainFrame
    
    print("✅ [UI] Main Menu Frame Created")
    
    -- 4. HEADER (แถบด้านบน)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = Theme.Surface
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    Header.ZIndex = 401
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 15)
    HeaderCorner.Parent = Header
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Text = "⭐ KANYAPAK SHOP V3"
    Title.Size = UDim2.new(0, 300, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Theme.Primary
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = Header
    Title.ZIndex = 402
    
    -- Sea Info
    local SeaLabel = Instance.new("TextLabel")
    SeaLabel.Text = "SEA " .. _G.Zenith_Data.CurrentSea
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
    
    print("✅ [UI] Header Created")
    
    -- 5. CLOSE BUTTON
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseBtn"
    CloseButton.Text = "✕"
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Position = UDim2.new(1, -45, 0, 5)
    CloseButton.BackgroundColor3 = Theme.Danger
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 18
    CloseButton.BorderSizePixel = 0
    CloseButton.AutoButtonColor = false
    CloseButton.Parent = Header
    CloseButton.ZIndex = 402
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    -- 6. SCROLLABLE CONTENT
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "ContentArea"
    ContentFrame.Size = UDim2.new(1, -10, 1, -60)
    ContentFrame.Position = UDim2.new(0, 5, 0, 55)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ScrollBarThickness = 3
    ContentFrame.ScrollBarImageColor3 = Theme.Primary
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.Parent = MainFrame
    ContentFrame.ZIndex = 401
    
    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 8)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Layout.Parent = ContentFrame
    
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
    end)
    
    print("✅ [UI] Content Area Created")
    
    -- 7. CREATE TOGGLE FUNCTION
    local function CreateToggle(Parent, IconText, Text, ConfigTable, ConfigKey, Description)
        Description = Description or ""
        
        local ToggleContainer = Instance.new("TextButton")
        ToggleContainer.Name = ConfigKey .. "_Toggle"
        ToggleContainer.Size = UDim2.new(0, 420, 0, 50)
        ToggleContainer.BackgroundColor3 = Theme.Surface2
        ToggleContainer.Text = ""
        ToggleContainer.AutoButtonColor = false
        ToggleContainer.Parent = Parent
        ToggleContainer.ZIndex = 402
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 8)
        ToggleCorner.Parent = ToggleContainer
        
        local ToggleStroke = Instance.new("UIStroke")
        ToggleStroke.Color = Theme.TextDark
        ToggleStroke.Thickness = 1
        ToggleStroke.Transparency = 0.7
        ToggleStroke.Parent = ToggleContainer
        
        -- Icon
        local Icon = Instance.new("TextLabel")
        Icon.Text = IconText
        Icon.Size = UDim2.new(0, 40, 0, 40)
        Icon.Position = UDim2.new(0, 8, 0.5, -20)
        Icon.BackgroundColor3 = Theme.Primary
        Icon.TextColor3 = Color3.fromRGB(0, 0, 0)
        Icon.Font = Enum.Font.GothamBold
        Icon.TextSize = 20
        Icon.BorderSizePixel = 0
        Icon.Parent = ToggleContainer
        Icon.ZIndex = 403
        
        local IconCorner2 = Instance.new("UICorner")
        IconCorner2.CornerRadius = UDim.new(0, 6)
        IconCorner2.Parent = Icon
        
        -- Info
        local InfoContainer = Instance.new("Frame")
        InfoContainer.Size = UDim2.new(0, 280, 1, 0)
        InfoContainer.Position = UDim2.new(0, 55, 0, 0)
        InfoContainer.BackgroundTransparency = 1
        InfoContainer.Parent = ToggleContainer
        InfoContainer.ZIndex = 403
        
        local Label = Instance.new("TextLabel")
        Label.Text = Text
        Label.Size = UDim2.new(1, 0, 0, 25)
        Label.Position = UDim2.new(0, 0, 0, 5)
        Label.BackgroundTransparency = 1
        Label.TextColor3 = Theme.Text
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 13
        Label.Parent = InfoContainer
        Label.ZIndex = 403
        
        local Desc = Instance.new("TextLabel")
        Desc.Text = Description
        Desc.Size = UDim2.new(1, 0, 0, 18)
        Desc.Position = UDim2.new(0, 0, 0, 28)
        Desc.BackgroundTransparency = 1
        Desc.TextColor3 = Theme.TextDark
        Desc.TextXAlignment = Enum.TextXAlignment.Left
        Desc.Font = Enum.Font.Gotham
        Desc.TextSize = 11
        Desc.Parent = InfoContainer
        Desc.ZIndex = 403
        
        -- Toggle Switch
        local SwitchFrame = Instance.new("Frame")
        SwitchFrame.Size = UDim2.new(0, 50, 0, 28)
        SwitchFrame.Position = UDim2.new(1, -60, 0.5, -14)
        SwitchFrame.BackgroundColor3 = ConfigTable[ConfigKey] and Theme.Success or Theme.TextDark
        SwitchFrame.BorderSizePixel = 0
        SwitchFrame.Parent = ToggleContainer
        SwitchFrame.ZIndex = 403
        
        local SwitchCorner = Instance.new("UICorner")
        SwitchCorner.CornerRadius = UDim.new(0, 14)
        SwitchCorner.Parent = SwitchFrame
        
        local SwitchDot = Instance.new("Frame")
        SwitchDot.Size = UDim2.new(0, 24, 0, 24)
        SwitchDot.Position = ConfigTable[ConfigKey] and UDim2.new(0, 23, 0.5, -12) or UDim2.new(0, 2, 0.5, -12)
        SwitchDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SwitchDot.BorderSizePixel = 0
        SwitchDot.Parent = SwitchFrame
        SwitchDot.ZIndex = 404
        
        local DotCorner = Instance.new("UICorner")
        DotCorner.CornerRadius = UDim.new(1, 0)
        DotCorner.Parent = SwitchDot
        
        -- Click Handler
        ToggleContainer.MouseButton1Click:Connect(function()
            ConfigTable[ConfigKey] = not ConfigTable[ConfigKey]
            PlaySound(SoundAssets.Toggle, 0.4)
            PulseEffect(ToggleContainer)
            
            CreateTween(SwitchFrame, 0.3, {
                BackgroundColor3 = ConfigTable[ConfigKey] and Theme.Success or Theme.TextDark
            })
            
            CreateTween(SwitchDot, 0.3, {
                Position = ConfigTable[ConfigKey] and UDim2.new(0, 23, 0.5, -12) or UDim2.new(0, 2, 0.5, -12)
            })
            
            print("[TOGGLE] " .. Text .. ": " .. (ConfigTable[ConfigKey] and "✅ ON" or "❌ OFF"))
        end)
        
        -- Hover
        ToggleContainer.MouseEnter:Connect(function()
            CreateTween(ToggleContainer, 0.2, { BackgroundColor3 = Theme.Surface })
            PlaySound(SoundAssets.Hover, 0.2)
        end)
        
        ToggleContainer.MouseLeave:Connect(function()
            CreateTween(ToggleContainer, 0.2, { BackgroundColor3 = Theme.Surface2 })
        end)
    end
    
    -- 8. CREATE SECTION HEADER
    local function CreateSection(Parent, Title)
        local SectionHeader = Instance.new("TextButton")
        SectionHeader.Name = Title .. "_Header"
        SectionHeader.Size = UDim2.new(0, 420, 0, 35)
        SectionHeader.BackgroundColor3 = Theme.Accent
        SectionHeader.Text = ""
        SectionHeader.AutoButtonColor = false
        SectionHeader.Parent = Parent
        SectionHeader.ZIndex = 402
        
        local SectionCorner = Instance.new("UICorner")
        SectionCorner.CornerRadius = UDim.new(0, 8)
        SectionCorner.Parent = SectionHeader
        
        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Text = Title
        SectionTitle.Size = UDim2.new(1, -30, 1, 0)
        SectionTitle.Position = UDim2.new(0, 10, 0, 0)
        SectionTitle.BackgroundTransparency = 1
        SectionTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
        SectionTitle.Font = Enum.Font.GothamBold
        SectionTitle.TextSize = 13
        SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        SectionTitle.Parent = SectionHeader
        SectionTitle.ZIndex = 403
        
        SectionHeader.MouseEnter:Connect(function()
            CreateTween(SectionHeader, 0.2, { BackgroundColor3 = Theme.Primary })
        end)
        
        SectionHeader.MouseLeave:Connect(function()
            CreateTween(SectionHeader, 0.2, { BackgroundColor3 = Theme.Accent })
        end)
    end
    
    -- 9. BUILD SECTIONS
    print("\n📋 Building UI Sections...")
    
    CreateSection(ContentFrame, "🌾 FARMING SYSTEM")
    CreateToggle(ContentFrame, "🎯", "Auto Farm Level", _G.Zenith_Data.Config.Farm, "Level", "ฟาร์มเลเวลอัตโนมัติ")
    CreateToggle(ContentFrame, "⚔️", "Auto Mastery", _G.Zenith_Data.Config.Farm, "Mastery", "ฟาร์มระดับอาวุธ")
    CreateToggle(ContentFrame, "🧲", "Bring Mobs", _G.Zenith_Data.Config.Farm, "BringMob", "รวมมอนสเตอร์")
    CreateToggle(ContentFrame, "💰", "Auto Sell Items", _G.Zenith_Data.Config.Farm, "AutoSell", "ขายไอเทมอัตโนมัติ")
    
    CreateSection(ContentFrame, "👤 PLAYER ENHANCEMENT")
    CreateToggle(ContentFrame, "🚀", "Infinite Jump", _G.Zenith_Data.Config.Player, "InfJump", "กระโดดไม่จำกัด")
    CreateToggle(ContentFrame, "👻", "No Clip", _G.Zenith_Data.Config.Player, "NoClip", "ผ่านผนัง")
    CreateToggle(ContentFrame, "🛡️", "Anti-Stun", _G.Zenith_Data.Config.Player, "AntiStun", "ป้องกันสตั้น")
    CreateToggle(ContentFrame, "🌪️", "Anti-Knockback", _G.Zenith_Data.Config.Player, "AntiKnockback", "ป้องกันหลุด")
    CreateToggle(ContentFrame, "🪂", "Flight Mode", _G.Zenith_Data.Config.Player, "FlightMode", "บินได้")
    
    CreateSection(ContentFrame, "👁️ VISUAL & ESP")
    CreateToggle(ContentFrame, "🍎", "Fruit ESP", _G.Zenith_Data.Config.Visuals, "FruitESP", "มองผลไม้")
    CreateToggle(ContentFrame, "👥", "Player ESP", _G.Zenith_Data.Config.Visuals, "PlayerESP", "มองผู้เล่น")
    CreateToggle(ContentFrame, "💎", "Chest ESP", _G.Zenith_Data.Config.Visuals, "ChestESP", "มองหีบ")
    CreateToggle(ContentFrame, "🌞", "Full Bright", _G.Zenith_Data.Config.Visuals, "FullBright", "สว่างเต็ม")
    CreateToggle(ContentFrame, "🗺️", "Island ESP", _G.Zenith_Data.Config.Visuals, "IslandESP", "แสดงเกาะ")
    
    CreateSection(ContentFrame, "✨ SPECIAL FEATURES")
    CreateToggle(ContentFrame, "🎪", "Auto Raid", _G.Zenith_Data.Config.Misc, "AutoRaid", "Raid อัตโนมัติ")
    CreateToggle(ContentFrame, "🌍", "Auto New World", _G.Zenith_Data.Config.Misc, "AutoNewWorld", "เปลี่ยนโลก")
    CreateToggle(ContentFrame, "🎯", "Fruit Sniper", _G.Zenith_Data.Config.Misc, "FruitSniper", "ล็อคผลไม้")
    CreateToggle(ContentFrame, "⏰", "Anti-AFK", _G.Zenith_Data.Config.Misc, "AntiAFK", "ป้องกันเตะ")
    
    print("✅ [UI] All sections created\n")
    
    -- 10. STATS DISPLAY
    local StatsFrame = Instance.new("Frame")
    StatsFrame.Size = UDim2.new(1, 0, 0, 40)
    StatsFrame.BackgroundColor3 = Theme.Surface
    StatsFrame.BorderSizePixel = 0
    StatsFrame.Parent = MainFrame
    StatsFrame.Position = UDim2.new(0, 0, 1, -40)
    StatsFrame.ZIndex = 401
    
    local StatsCorner = Instance.new("UICorner")
    StatsCorner.CornerRadius = UDim.new(0, 15)
    StatsCorner.Parent = StatsFrame
    
    local StatsText = Instance.new("TextLabel")
    StatsText.Text = "⏱️ 0s  |  🎯 0 Mobs  |  ⭐ 0 Exp"
    StatsText.Size = UDim2.new(1, -20, 1, 0)
    StatsText.Position = UDim2.new(0, 10, 0, 0)
    StatsText.BackgroundTransparency = 1
    StatsText.TextColor3 = Theme.Primary
    StatsText.Font = Enum.Font.Gotham
    StatsText.TextSize = 11
    StatsText.TextXAlignment = Enum.TextXAlignment.Left
    StatsText.Parent = StatsFrame
    StatsText.ZIndex = 402
    
    RunService.Heartbeat:Connect(function()
        if _G.Zenith_Data.Statistics then
            local SessionTime = math.floor(_G.Zenith_Data.Statistics.SessionTime)
            StatsText.Text = string.format(
                "⏱️ %ds  |  🎯 %d Mobs  |  ⭐ %d Exp",
                SessionTime,
                _G.Zenith_Data.Statistics.MobsKilled,
                _G.Zenith_Data.Statistics.ExpGained
            )
        end
    end)
    
    -- 11. MENU TOGGLE LOGIC (ส่วนสำคัญ - FIXED)
    local MenuOpen = false
    
    local function OpenMenu()
        if MenuOpen then return end
        MenuOpen = true
        print("📂 [UI] Opening Menu...")
        
        PlaySound(SoundAssets.Open, 0.5)
        MainFrame.Visible = true
        
        -- Slide in from right
        MainFrame.Position = UDim2.new(1.5, 0, 0.5, -360)
        CreateTween(MainFrame, 0.4, {
            Position = UDim2.new(0.5, -225, 0.5, -360)
        })
        
        CreateTween(FloatingIcon, 0.3, {
            BackgroundColor3 = Theme.Secondary
        })
    end
    
    local function CloseMenu()
        if not MenuOpen then return end
        MenuOpen = false
        print("📂 [UI] Closing Menu...")
        
        PlaySound(SoundAssets.Close, 0.5)
        
        -- Slide out to right
        CreateTween(MainFrame, 0.4, {
            Position = UDim2.new(1.5, 0, 0.5, -360)
        })
        
        task.wait(0.4)
        MainFrame.Visible = false
        
        CreateTween(FloatingIcon, 0.3, {
            BackgroundColor3 = Theme.Primary
        })
    end
    
    -- Icon Click Handler
    FloatingIcon.MouseButton1Click:Connect(function()
        PulseEffect(FloatingIcon)
        if MenuOpen then
            CloseMenu()
        else
            OpenMenu()
        end
    end)
    
    -- Icon Hover
    FloatingIcon.MouseEnter:Connect(function()
        CreateTween(FloatingIcon, 0.2, {
            Size = UDim2.new(0, 80, 0, 80)
        })
    end)
    
    FloatingIcon.MouseLeave:Connect(function()
        if not MenuOpen then
            CreateTween(FloatingIcon, 0.2, {
                Size = UDim2.new(0, 70, 0, 70)
            })
        end
    end)
    
    -- Close Button
    CloseButton.MouseButton1Click:Connect(function()
        PlaySound(SoundAssets.Click, 0.5)
        PulseEffect(CloseButton)
        CloseMenu()
    end)
    
    CloseButton.MouseEnter:Connect(function()
        CreateTween(CloseButton, 0.2, {
            BackgroundColor3 = Theme.Warning
        })
    end)
    
    CloseButton.MouseLeave:Connect(function()
        CreateTween(CloseButton, 0.2, {
            BackgroundColor3 = Theme.Danger
        })
    end)
    
    -- 12. DRAG FUNCTIONALITY
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
            MainFrame.Position = UDim2.new(
                DragPos.X.Scale,
                DragPos.X.Offset + Delta.X,
                DragPos.Y.Scale,
                DragPos.Y.Offset + Delta.Y
            )
        end
    end)
    
    -- COMPLETED
    print("=" .. string.rep("=", 68) .. "=")
    print("✅ [KANYAPAK SHOP V3] UI FULLY LOADED & READY")
    print("=" .. string.rep("=", 68) .. "=")
    print("📌 CONTROLS:")
    print("   🛍️ Click Icon (Bottom-Right) = Toggle Menu")
    print("   ✕ Click Close = Close Menu")
    print("   🖱️ Drag Header = Move Menu")
    print("=" .. string.rep("=", 68) .. "=\n")
    
    return MainFrame
end

return UI_Library
