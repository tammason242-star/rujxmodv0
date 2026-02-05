--[[
    💎 KANYAPAK UI LIBRARY - FIXED & ENHANCED EDITION (V4.5 Mobile/PC)
    "แก้ scope CreateTab + Mobile friendly + สวยหรูขึ้นนิด ๆ"
    Author: Grok Fixed for Moda
]]

local UI_Library = {}
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Theme สวย ๆ หรู (dark modern)
local Theme = {
    Background = Color3.fromRGB(8, 10, 16),
    Sidebar = Color3.fromRGB(12, 15, 25),
    ItemBg = Color3.fromRGB(15, 20, 30),
    ItemBgHover = Color3.fromRGB(25, 35, 50),
    Primary = Color3.fromRGB(0, 180, 255),
    Secondary = Color3.fromRGB(80, 220, 255),
    Success = Color3.fromRGB(0, 220, 120),
    Danger = Color3.fromRGB(255, 60, 60),
    Text = Color3.fromRGB(240, 240, 255),
    TextSecondary = Color3.fromRGB(160, 170, 190),
    Border = Color3.fromRGB(40, 50, 70),
    ScrollBar = Color3.fromRGB(0, 180, 255),
}

-- Utility Functions
local function AddCorner(inst, rad)
    local c = Instance.new("UICorner", inst)
    c.CornerRadius = UDim.new(0, rad or 8)
end

local function AddStroke(inst, col, thick)
    local s = Instance.new("UIStroke", inst)
    s.Color = col or Theme.Border
    s.Thickness = thick or 1.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
end

local function Tween(obj, props, dur, style, dir)
    local ti = TweenInfo.new(dur or 0.3, Enum.EasingStyle[style or "Quad"], Enum.EasingDirection[dir or "Out"])
    local tw = TS:Create(obj, ti, props)
    tw:Play()
    return tw
end

local function MakeDraggable(frame, handle)
    local dragging, dragStart, startPos = false, nil, nil

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- AddToggle
function UI_Library:AddToggle(parent, title, cfgTable, cfgKey, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, -20, 0, 50)
    f.BackgroundColor3 = Theme.ItemBg
    f.BorderSizePixel = 0
    AddCorner(f, 10)
    AddStroke(f)

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.Position = UDim2.new(0, 15, 0, 0)
    lbl.Text = title
    lbl.TextColor3 = Theme.Text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 14
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local box = Instance.new("Frame", f)
    box.Name = "Box"
    box.Size = UDim2.new(0, 50, 0, 28)
    box.Position = UDim2.new(1, -70, 0.5, -14)
    box.BackgroundColor3 = cfgTable[cfgKey] and Theme.Success or Theme.ItemBgHover
    box.BorderSizePixel = 0
    AddCorner(box, 14)
    AddStroke(box)

    local circle = Instance.new("Frame", box)
    circle.Size = UDim2.new(0, 24, 0, 24)
    circle.Position = cfgTable[cfgKey] and UDim2.new(1, -26, 0.5, -12) or UDim2.new(0, 2, 0.5, -12)
    circle.BackgroundColor3 = Color3.new(1,1,1)
    circle.BorderSizePixel = 0
    AddCorner(circle, 12)

    local click = Instance.new("TextButton", f)
    click.Size = UDim2.new(1,0,1,0)
    click.BackgroundTransparency = 1
    click.Text = ""

    click.MouseButton1Click:Connect(function()
        cfgTable[cfgKey] = not cfgTable[cfgKey]
        local en = cfgTable[cfgKey]
        Tween(box, {BackgroundColor3 = en and Theme.Success or Theme.ItemBgHover}, 0.3)
        Tween(circle, {Position = en and UDim2.new(1,-26,0.5,-12) or UDim2.new(0,2,0.5,-12)}, 0.3)
        if callback then pcall(callback, en) end
    end)

    f.MouseEnter:Connect(function() Tween(f, {BackgroundColor3 = Theme.ItemBgHover}, 0.2) end)
    f.MouseLeave:Connect(function() Tween(f, {BackgroundColor3 = Theme.ItemBg}, 0.2) end)
end

-- AddButton (เหมือนเดิม แต่ text size ใหญ่ขึ้นนิด)
function UI_Library:AddButton(parent, title, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -20, 0, 50)
    b.BackgroundColor3 = Theme.ItemBg
    b.Text = title
    b.TextColor3 = Theme.Primary
    b.Font = Enum.Font.GothamBold
    b.TextSize = 15
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    AddCorner(b, 10)
    AddStroke(b)

    b.MouseEnter:Connect(function() Tween(b, {BackgroundColor3 = Theme.Primary, TextColor3 = Color3.new(0,0,0)}, 0.2) end)
    b.MouseLeave:Connect(function() Tween(b, {BackgroundColor3 = Theme.ItemBg, TextColor3 = Theme.Primary}, 0.2) end)
    b.MouseButton1Click:Connect(function()
        Tween(b, {BackgroundColor3 = Theme.Secondary}, 0.1)
        task.wait(0.1)
        Tween(b, {BackgroundColor3 = Theme.ItemBg}, 0.1)
        if callback then pcall(callback) end
    end)
end

-- AddSlider (ปรับให้ smooth ขึ้น)
function UI_Library:AddSlider(parent, title, cfgTable, cfgKey, min, max, step, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1, -20, 0, 75)
    f.BackgroundColor3 = Theme.ItemBg
    f.BorderSizePixel = 0
    AddCorner(f, 10)
    AddStroke(f)

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1, -30, 0, 25)
    lbl.Position = UDim2.new(0, 15, 0, 8)
    lbl.Text = title .. ": " .. (cfgTable[cfgKey] or min)
    lbl.TextColor3 = Theme.Text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local bg = Instance.new("Frame", f)
    bg.Size = UDim2.new(1, -30, 0, 8)
    bg.Position = UDim2.new(0, 15, 0, 40)
    bg.BackgroundColor3 = Theme.ItemBgHover
    bg.BorderSizePixel = 0
    AddCorner(bg, 4)

    local prog = Instance.new("Frame", bg)
    prog.Size = UDim2.new(math.clamp((cfgTable[cfgKey] or min - min) / (max - min), 0, 1), 0, 1, 0)
    prog.BackgroundColor3 = Theme.Primary
    prog.BorderSizePixel = 0
    AddCorner(prog, 4)

    local btn = Instance.new("TextButton", bg)
    btn.Size = UDim2.new(0, 20, 0, 20)
    btn.Position = UDim2.new(math.clamp((cfgTable[cfgKey] or min - min) / (max - min), 0, 1), -10, 0.5, -10)
    btn.BackgroundColor3 = Theme.Primary
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    AddCorner(btn, 10)
    AddStroke(btn, Theme.Text, 1.2)

    local active = false
    local function update(input)
        local x = input.Position.X
        local start = bg.AbsolutePosition.X
        local endx = start + bg.AbsoluteSize.X
        local pct = math.clamp((x - start) / (endx - start), 0, 1)
        local val = math.floor((min + (max - min) * pct) / step) * step

        cfgTable[cfgKey] = val
        lbl.Text = title .. ": " .. val
        Tween(prog, {Size = UDim2.new(pct, 0, 1, 0)}, 0.05)
        Tween(btn, {Position = UDim2.new(pct, -10, 0.5, -10)}, 0.05)
        if callback then pcall(callback, val) end
    end

    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            active = true
            update(input)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if active and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            active = false
        end
    end)
end

-- AddLabel
function UI_Library:AddLabel(parent, text)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(1, -20, 0, 40)
    l.BackgroundColor3 = Theme.ItemBg
    l.Text = text
    l.TextColor3 = Theme.TextSecondary
    l.Font = Enum.Font.GothamBold
    l.TextSize = 13
    l.BorderSizePixel = 0
    AddCorner(l, 8)
    AddStroke(l)
end

-- CreateTab (main level ตอนนี้!)
function UI_Library:CreateTab(name)
    local btn = Instance.new("TextButton", UI_Library.TabContainer)
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.BackgroundColor3 = Theme.ItemBg
    btn.Text = name
    btn.TextColor3 = Theme.TextSecondary
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.AutoButtonColor = false
    btn.TextWrapped = true
    AddCorner(btn, 10)
    AddStroke(btn)

    local content = Instance.new("ScrollingFrame", UI_Library.ContentArea)
    content.Name = name .. "_Content"
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = Theme.ScrollBar
    content.ClipsDescendants = true

    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 12)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    btn.MouseButton1Click:Connect(function()
        for _, c in pairs(UI_Library.ContentArea:GetChildren()) do
            if c:IsA("ScrollingFrame") then c.Visible = false end
        end
        for _, b in pairs(UI_Library.TabContainer:GetChildren()) do
            if b:IsA("TextButton") then
                Tween(b, {BackgroundColor3 = Theme.ItemBg, TextColor3 = Theme.TextSecondary}, 0.2)
            end
        end
        content.Visible = true
        Tween(btn, {BackgroundColor3 = Theme.Primary, TextColor3 = Color3.new(1,1,1)}, 0.2)
    end)

    btn.MouseEnter:Connect(function()
        if not content.Visible then Tween(btn, {BackgroundColor3 = Theme.ItemBgHover}, 0.2) end
    end)
    btn.MouseLeave:Connect(function()
        if not content.Visible then Tween(btn, {BackgroundColor3 = Theme.ItemBg}, 0.2) end
    end)

    return content
end

-- Init
function UI_Library:Init()
    local sg = Instance.new("ScreenGui")
    sg.Name = "Kanyapak_Pro_V45"
    sg.Parent = PlayerGui
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local toggleBtn = Instance.new("TextButton", sg)
    toggleBtn.Size = UDim2.new(0, 120, 0, 50)
    toggleBtn.Position = UDim2.new(1, -140, 0.5, -25)
    toggleBtn.BackgroundColor3 = Theme.Primary
    toggleBtn.Text = "KANYAPAK"
    toggleBtn.TextColor3 = Color3.new(1,1,1)
    toggleBtn.Font = Enum.Font.GothamBlack
    toggleBtn.TextSize = 16
    toggleBtn.AutoButtonColor = false
    AddCorner(toggleBtn, 12)
    AddStroke(toggleBtn, Theme.Primary, 2.5)

    local main = Instance.new("Frame", sg)
    main.Name = "Main"
    main.Size = UDim2.new(0, 720, 0, 520)
    main.Position = UDim2.new(0.5, -360, 0.5, -260)
    main.BackgroundColor3 = Theme.Background
    main.BorderSizePixel = 0
    main.Visible = false
    main.ClipsDescendants = true
    AddCorner(main, 16)
    AddStroke(main, Theme.Border, 2)

    local header = Instance.new("Frame", main)
    header.Size = UDim2.new(1, 0, 0, 60)
    header.BackgroundColor3 = Theme.Sidebar
    header.BorderSizePixel = 0
    AddCorner(header, 16)

    local titleLbl = Instance.new("TextLabel", header)
    titleLbl.Size = UDim2.new(0.6, 0, 1, 0)
    titleLbl.Position = UDim2.new(0, 25, 0, 0)
    titleLbl.Text = "💎 KANYAPAK HUB V4.5"
    titleLbl.TextColor3 = Theme.Primary
    titleLbl.Font = Enum.Font.GothamBlack
    titleLbl.TextSize = 20
    titleLbl.BackgroundTransparency = 1
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left

    local close = Instance.new("TextButton", header)
    close.Size = UDim2.new(0, 40, 0, 40)
    close.Position = UDim2.new(1, -50, 0, 10)
    close.BackgroundColor3 = Theme.Danger
    close.Text = "×"
    close.TextColor3 = Color3.new(1,1,1)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 20
    close.AutoButtonColor = false
    AddCorner(close, 10)

    close.MouseButton1Click:Connect(function()
        Tween(main, {Size = UDim2.new(0,0,0,0)}, 0.3)
        task.wait(0.3)
        main.Visible = false
        main.Size = UDim2.new(0, 720, 0, 520)
    end)

    MakeDraggable(main, header)

    local sidebar = Instance.new("Frame", main)
    sidebar.Size = UDim2.new(0, 190, 1, -65)
    sidebar.Position = UDim2.new(0, 0, 0, 60)
    sidebar.BackgroundColor3 = Theme.Sidebar
    sidebar.BorderSizePixel = 0

    local tabCont = Instance.new("ScrollingFrame", sidebar)
    tabCont.Size = UDim2.new(1, 0, 1, 0)
    tabCont.BackgroundTransparency = 1
    tabCont.CanvasSize = UDim2.new(0,0,0,0)
    tabCont.ScrollBarThickness = 3
    tabCont.ScrollBarImageColor3 = Theme.ScrollBar

    local tabLayout = Instance.new("UIListLayout", tabCont)
    tabLayout.Padding = UDim.new(0, 10)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local contentArea = Instance.new("Frame", main)
    contentArea.Size = UDim2.new(1, -200, 1, -65)
    contentArea.Position = UDim2.new(0, 195, 0, 60)
    contentArea.BackgroundTransparency = 1
    contentArea.ClipsDescendants = true

    -- เก็บไว้ใช้ใน CreateTab
    UI_Library.TabContainer = tabCont
    UI_Library.ContentArea = contentArea

    -- Resize Handle (fallback สำหรับ mobile ไม่ใช้ Mouse)
    local resHandle = Instance.new("TextLabel", main)
    resHandle.Size = UDim2.new(0, 30, 0, 30)
    resHandle.Position = UDim2.new(1, -30, 1, -30)
    resHandle.BackgroundColor3 = Theme.Primary
    resHandle.Text = "↘"
    resHandle.TextColor3 = Color3.new(1,1,1)
    resHandle.TextSize = 20
    resHandle.Font = Enum.Font.GothamBold
    resHandle.BorderSizePixel = 0
    AddCorner(resHandle, 6)

    local resizing = false
    resHandle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            resizing = true
        end
    end)

    UIS.InputChanged:Connect(function(inp)
        if resizing and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local newW = math.max(500, inp.Position.X - main.AbsolutePosition.X)
            local newH = math.max(350, inp.Position.Y - main.AbsolutePosition.Y)
            main.Size = UDim2.new(0, newW, 0, newH)
        end
    end)

    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)

    toggleBtn.MouseButton1Click:Connect(function()
        if main.Visible then
            Tween(main, {Size = UDim2.new(0,0,0,0)}, 0.3)
            task.wait(0.3)
            main.Visible = false
            main.Size = UDim2.new(0,720,0,520)
        else
            main.Visible = true
            Tween(main, {Size = UDim2.new(0,720,0,520)}, 0.3)
        end
    end)

    return UI_Library
end

return UI_Library
