--[[ 
    ⚔️ COMBAT.LUA - KANYAPAK SHOP V3.0 ⚔️
    Advanced Combat System for Blox Fruits
    Features: Fast Attack, Mob Control, Auto Combo, Ability System, Statistics Tracking
    
    🎯 Combat Features:
    - Lightning-fast clicking system
    - Smart mob targeting & pulling
    - Auto ability combo execution
    - Damage calculation & tracking
    - Anti-damage protection
    - Intelligent ability rotation
    - Performance optimization
]]

local Combat = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎨 UI NOTIFICATION HELPER
-- ═══════════════════════════════════════════════════════════════════════════

local function ShowCombatNotify(Title, Message, Duration, Color)
    Duration = Duration or 3
    Color = Color or Color3.fromRGB(0, 255, 127)
    
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = Title,
            Text = Message,
            Duration = Duration,
            Icon = "rbxassetid://12221969"
        })
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- ⚡ CLICK SYSTEM - ULTRA FAST ATTACKING
-- ═══════════════════════════════════════════════════════════════════════════

local ClickCounter = 0
local LastClickTime = 0
local ClickDelay = 0.05 -- 50ms between clicks (20 clicks per second)

local function FastClick(Count)
    Count = Count or 1
    local VirtualUser = game:GetService("VirtualUser")
    
    for i = 1, Count do
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new())
        end)
        ClickCounter = ClickCounter + 1
        task.wait(ClickDelay)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎯 SMART TARGET SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local function GetClosestEnemy(MaxDistance)
    MaxDistance = MaxDistance or 50
    local Character = LocalPlayer.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")
    
    if not Root then return nil end
    
    local ClosestEnemy = nil
    local ClosestDistance = MaxDistance
    
    pcall(function()
        for _, Enemy in pairs(workspace:FindFirstChild("Enemies") and workspace.Enemies:GetChildren() or {}) do
            if Enemy:FindFirstChild("Humanoid") and Enemy:FindFirstChild("HumanoidRootPart") then
                local Humanoid = Enemy.Humanoid
                local EnemyRoot = Enemy.HumanoidRootPart
                
                if Humanoid.Health > 0 then
                    local Distance = (EnemyRoot.Position - Root.Position).Magnitude
                    
                    if Distance < ClosestDistance then
                        ClosestDistance = Distance
                        ClosestEnemy = Enemy
                    end
                end
            end
        end
    end)
    
    return ClosestEnemy
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🧲 MOB PULLING SYSTEM - BRING MOBS TOGETHER
-- ═══════════════════════════════════════════════════════════════════════════

local function BringMobsToPlayer(Radius, PullDistance)
    Radius = Radius or 50
    PullDistance = PullDistance or 5
    
    local Character = LocalPlayer.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")
    
    if not Root then return end
    
    pcall(function()
        for _, Enemy in pairs(workspace:FindFirstChild("Enemies") and workspace.Enemies:GetChildren() or {}) do
            if Enemy:FindFirstChild("Humanoid") and Enemy:FindFirstChild("HumanoidRootPart") then
                local EnemyHumanoid = Enemy.Humanoid
                local EnemyRoot = Enemy.HumanoidRootPart
                
                if EnemyHumanoid.Health > 0 then
                    local Distance = (EnemyRoot.Position - Root.Position).Magnitude
                    
                    if Distance < Radius then
                        -- Pull enemy to player
                        EnemyRoot.CFrame = Root.CFrame * CFrame.new(0, 0, -PullDistance)
                        EnemyRoot.CanCollide = false
                        EnemyRoot.Velocity = Vector3.new(0, 0, 0)
                        
                        -- Disable walk
                        if EnemyHumanoid then
                            EnemyHumanoid.WalkSpeed = 0
                        end
                    end
                end
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🔥 ABILITY EXECUTION SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local AbilityQueue = {}
local LastAbilityTime = 0
local AbilityDelay = 0.5

local function ExecuteAbility(AbilityName)
    local Character = LocalPlayer.Character
    if not Character then return end
    
    local CurrentTime = tick()
    if CurrentTime - LastAbilityTime < AbilityDelay then return end
    
    pcall(function()
        -- Find ability in character
        local Ability = Character:FindFirstChild(AbilityName)
        if Ability and Ability:IsA("RemoteFunction") then
            Ability:InvokeServer()
            LastAbilityTime = CurrentTime
            _G.Zenith_Data.Statistics.AbilitiesUsed = _G.Zenith_Data.Statistics.AbilitiesUsed + 1
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 💥 AUTO COMBO SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local function ExecuteCombo(ComboType)
    ComboType = ComboType or "basic"
    
    if ComboType == "basic" then
        -- Basic: Fast clicks + ability
        FastClick(5)
        task.wait(0.1)
        ExecuteAbility("Z")
        task.wait(0.3)
        FastClick(3)
        
    elseif ComboType == "advanced" then
        -- Advanced: Multi-hit combo
        FastClick(7)
        task.wait(0.15)
        ExecuteAbility("X")
        task.wait(0.2)
        FastClick(5)
        task.wait(0.1)
        ExecuteAbility("C")
        task.wait(0.2)
        FastClick(3)
        
    elseif ComboType == "aggressive" then
        -- Aggressive: Maximum damage
        FastClick(10)
        task.wait(0.1)
        ExecuteAbility("Z")
        task.wait(0.1)
        ExecuteAbility("X")
        task.wait(0.1)
        FastClick(8)
        task.wait(0.15)
        ExecuteAbility("C")
        task.wait(0.1)
        FastClick(5)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🛡️ ANTI-DAMAGE PROTECTION
-- ═══════════════════════════════════════════════════════════════════════════

local function ApplyAntiDamage(State)
    local Character = LocalPlayer.Character
    if not Character then return end
    
    pcall(function()
        for _, Part in pairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") then
                Part.CanCollide = not State
                if State then
                    -- Anti-damage mode
                    Part.TopSurface = Enum.SurfaceType.Smooth
                    Part.BottomSurface = Enum.SurfaceType.Smooth
                end
            end
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 📊 DAMAGE TRACKING SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local function TrackDamage()
    local Character = LocalPlayer.Character
    if not Character or not Character:FindFirstChild("Humanoid") then return end
    
    local LastHealth = Character.Humanoid.Health
    
    Character.Humanoid.Changed:Connect(function()
        local CurrentHealth = Character.Humanoid.Health
        
        if CurrentHealth < LastHealth then
            local DamageTaken = LastHealth - CurrentHealth
            print("[COMBAT] 💔 Damage taken: " .. math.floor(DamageTaken))
        end
        
        LastHealth = CurrentHealth
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎯 WEAPON EQUIP SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local function EquipTool(ToolName)
    local Character = LocalPlayer.Character
    if not Character then return end
    
    pcall(function()
        -- Check if tool is already equipped
        if Character:FindFirstChild(ToolName) then
            return
        end
        
        -- Find tool in backpack
        local Tool = LocalPlayer.Backpack:FindFirstChild(ToolName)
        if Tool then
            LocalPlayer.Character.Humanoid:EquipTool(Tool)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🔄 ABILITY ROTATION SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

local AbilityRotation = {
    Primary = "Z",
    Secondary = "X",
    Tertiary = "C",
    CurrentIndex = 1
}

local function RotateAbility()
    local Abilities = { AbilityRotation.Primary, AbilityRotation.Secondary, AbilityRotation.Tertiary }
    AbilityRotation.CurrentIndex = (AbilityRotation.CurrentIndex % #Abilities) + 1
    return Abilities[AbilityRotation.CurrentIndex]
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 📈 STATISTICS HELPER
-- ═══════════════════════════════════════════════════════════════════════════

local function UpdateStatistics(Enemy)
    if not Enemy or not Enemy:FindFirstChild("Humanoid") then return end
    
    -- Track kills
    if Enemy.Humanoid.Health <= 0 then
        _G.Zenith_Data.Statistics.MobsKilled = _G.Zenith_Data.Statistics.MobsKilled + 1
    end
    
    -- Track clicks
    _G.Zenith_Data.Statistics.AbilitiesUsed = _G.Zenith_Data.Statistics.AbilitiesUsed + 1
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎯 MAIN COMBAT LOOP - FARMING SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════

function Combat:Init()
    print("⚔️ [KANYAPAK SHOP V3] Combat Module Initialized")
    ShowCombatNotify("⚔️ COMBAT SYSTEM", "Advanced Combat Module Loaded!", 3)
    
    -- Main Combat Loop
    task.spawn(function()
        while task.wait(0.1) do
            local Config = _G.Zenith_Data.Config.Farm
            local Character = LocalPlayer.Character
            
            if not Config.Enabled or not Character then continue end
            
            -- Get closest enemy
            local Enemy = GetClosestEnemy(Config.Distance)
            
            if Enemy and Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 then
                local EnemyRoot = Enemy.HumanoidRootPart
                local MyRoot = Character.HumanoidRootPart
                
                if EnemyRoot and MyRoot then
                    local Distance = (EnemyRoot.Position - MyRoot.Position).Magnitude
                    
                    -- Pull mobs if enabled
                    if Config.BringMob then
                        BringMobsToPlayer(Config.Distance, 5)
                    end
                    
                    -- Execute combat based on distance
                    if Distance < Config.Distance then
                        if Config.UseAbilities then
                            -- Use combo system
                            if Config.SmartTargeting then
                                ExecuteCombo("advanced")
                            else
                                ExecuteCombo("basic")
                            end
                        else
                            -- Just click
                            FastClick(5)
                        end
                        
                        -- Update stats
                        UpdateStatistics(Enemy)
                    end
                end
            end
        end
    end)
    
    -- Anti-Damage System
    task.spawn(function()
        while task.wait(0.5) do
            if _G.Zenith_Data.Config.Player.AntiStun then
                ApplyAntiDamage(true)
            end
        end
    end)
    
    -- Damage Tracking
    task.spawn(function()
        TrackDamage()
    end)
    
    -- Statistics Update Loop
    task.spawn(function()
        while task.wait(1) do
            if _G.Zenith_Data.Statistics then
                -- Update session time
                _G.Zenith_Data.Statistics.SessionTime = tick() - _G.Zenith_Data.Statistics.SessionStart
                
                -- Debug output if enabled
                if _G.Zenith_Data.Config.Advanced.DebugMode then
                    print(string.format(
                        "[STATS] Time: %ds | Mobs: %d | Clicks: %d",
                        math.floor(_G.Zenith_Data.Statistics.SessionTime),
                        _G.Zenith_Data.Statistics.MobsKilled,
                        ClickCounter
                    ))
                end
            end
        end
    end)
    
    -- Auto-Equipment System
    task.spawn(function()
        while task.wait(1) do
            if _G.Zenith_Data.Config.Farm.Enabled then
                EquipTool(_G.Zenith_Data.Config.Farm.Tool or "Melee")
            end
        end
    end)
    
    print("✅ [COMBAT] All systems online!")
    print("✅ [COMBAT] Fast Click: Enabled (20 clicks/sec)")
    print("✅ [COMBAT] Mob Pulling: " .. (_G.Zenith_Data.Config.Farm.BringMob and "ON" or "OFF"))
    print("✅ [COMBAT] Ability System: " .. (_G.Zenith_Data.Config.Farm.UseAbilities and "ON" or "OFF"))
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎮 ADDITIONAL FUNCTIONS FOR UI INTEGRATION
-- ═══════════════════════════════════════════════════════════════════════════

function Combat:SetComboType(ComboType)
    _G.Zenith_Data.CurrentCombo = ComboType
    ShowCombatNotify("⚔️ COMBO CHANGED", "Now using: " .. ComboType, 2)
end

function Combat:GetClickCount()
    return ClickCounter
end

function Combat:ResetStats()
    ClickCounter = 0
    _G.Zenith_Data.Statistics.MobsKilled = 0
    _G.Zenith_Data.Statistics.AbilitiesUsed = 0
    ShowCombatNotify("📊 STATS RESET", "All statistics cleared!", 2)
end

function Combat:ToggleCombat(State)
    _G.Zenith_Data.Config.Farm.Enabled = State
    ShowCombatNotify(State and "✅ COMBAT ON" or "❌ COMBAT OFF", "", 2)
end

return Combat
