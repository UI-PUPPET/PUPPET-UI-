--[[
PUPPET UI - All-in-one Roblox Script UI
Features: Key system, open/close icon, draggable window, scrollable tabs (with icons), 
scrollable contents, text labels, buttons & toggles (with descriptions), dropdown, slider, 
and 10 unique themes (including Bloody Moon).

Place this as a LocalScript in StarterGui.
]]

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- === THEMES ===
local Themes = {
    ["Bloody Moon"] = {
        Background = Color3.fromRGB(20, 10, 20),
        Accent = Color3.fromRGB(60, 0, 0),
        Panel = Color3.fromRGB(40, 0, 10),
        Text = Color3.fromRGB(255,190,200),
        Button = Color3.fromRGB(120, 0, 40),
        Danger = Color3.fromRGB(220, 32, 64),
        Success = Color3.fromRGB(180, 0, 60),
        TabActive = Color3.fromRGB(120, 0, 40),
        TabInactive = Color3.fromRGB(65, 0, 25),
    },
    ["Lime Dream"] = {
        Background = Color3.fromRGB(22, 40, 22),
        Accent = Color3.fromRGB(32, 70, 32),
        Panel = Color3.fromRGB(38, 104, 38),
        Text = Color3.fromRGB(180,255,180),
        Button = Color3.fromRGB(80, 200, 120),
        Danger = Color3.fromRGB(200, 40, 70),
        Success = Color3.fromRGB(80, 200, 120),
        TabActive = Color3.fromRGB(80,200,120),
        TabInactive = Color3.fromRGB(32,70,32),
    },
    ["Skyfall"] = {
        Background = Color3.fromRGB(180, 210, 255),
        Accent = Color3.fromRGB(100, 170, 255),
        Panel = Color3.fromRGB(120, 200, 255),
        Text = Color3.fromRGB(30,30,50),
        Button = Color3.fromRGB(80,170,255),
        Danger = Color3.fromRGB(255, 80, 120),
        Success = Color3.fromRGB(90, 200, 255),
        TabActive = Color3.fromRGB(80,170,255),
        TabInactive = Color3.fromRGB(120,200,255),
    },
    ["Sunset"] = {
        Background = Color3.fromRGB(60, 34, 70),
        Accent = Color3.fromRGB(120, 60, 90),
        Panel = Color3.fromRGB(80, 40, 70),
        Text = Color3.fromRGB(255,220,230),
        Button = Color3.fromRGB(255, 120, 120),
        Danger = Color3.fromRGB(255, 80, 120),
        Success = Color3.fromRGB(255, 180, 110),
        TabActive = Color3.fromRGB(255,120,120),
        TabInactive = Color3.fromRGB(120,60,90),
    },
    ["Night"] = {
        Background = Color3.fromRGB(24, 24, 32),
        Accent = Color3.fromRGB(44, 44, 74),
        Panel = Color3.fromRGB(34, 34, 54),
        Text = Color3.fromRGB(220,220,255),
        Button = Color3.fromRGB(74, 85, 162),
        Danger = Color3.fromRGB(200, 40, 70),
        Success = Color3.fromRGB(40, 200, 120),
        TabActive = Color3.fromRGB(74,85,162),
        TabInactive = Color3.fromRGB(44,44,74),
    },
    ["Gold"] = {
        Background = Color3.fromRGB(60, 50, 12),
        Accent = Color3.fromRGB(168, 134, 4),
        Panel = Color3.fromRGB(218, 165, 32),
        Text = Color3.fromRGB(255,255,190),
        Button = Color3.fromRGB(255, 175, 75),
        Danger = Color3.fromRGB(200, 100, 40),
        Success = Color3.fromRGB(255, 210, 100),
        TabActive = Color3.fromRGB(255,175,75),
        TabInactive = Color3.fromRGB(168,134,4),
    },
    ["Oceanic"] = {
        Background = Color3.fromRGB(14, 41, 58),
        Accent = Color3.fromRGB(31, 80, 114),
        Panel = Color3.fromRGB(20, 58, 87),
        Text = Color3.fromRGB(178, 244, 255),
        Button = Color3.fromRGB(42, 156, 201),
        Danger = Color3.fromRGB(199, 66, 56),
        Success = Color3.fromRGB(56, 199, 119),
        TabActive = Color3.fromRGB(42,156,201),
        TabInactive = Color3.fromRGB(20,58,87),
    },
    ["Lavender"] = {
        Background = Color3.fromRGB(79, 64, 102),
        Accent = Color3.fromRGB(130, 110, 160),
        Panel = Color3.fromRGB(100, 80, 140),
        Text = Color3.fromRGB(230,210,255),
        Button = Color3.fromRGB(170, 130, 255),
        Danger = Color3.fromRGB(180, 50, 120),
        Success = Color3.fromRGB(120, 200, 255),
        TabActive = Color3.fromRGB(170,130,255),
        TabInactive = Color3.fromRGB(130,110,160),
    },
    ["Mint"] = {
        Background = Color3.fromRGB(44, 62, 80),
        Accent = Color3.fromRGB(46, 204, 113),
        Panel = Color3.fromRGB(39, 174, 96),
        Text = Color3.fromRGB(236, 240, 241),
        Button = Color3.fromRGB(52, 152, 219),
        Danger = Color3.fromRGB(231, 76, 60),
        Success = Color3.fromRGB(39, 174, 96),
        TabActive = Color3.fromRGB(46,204,113),
        TabInactive = Color3.fromRGB(44,62,80),
    },
    ["Dark Gray"] = {
        Background = Color3.fromRGB(36,36,36),
        Accent = Color3.fromRGB(52,52,52),
        Panel = Color3.fromRGB(44,44,44),
        Text = Color3.fromRGB(220,220,220),
        Button = Color3.fromRGB(80,80,80),
        Danger = Color3.fromRGB(120,40,40),
        Success = Color3.fromRGB(60,120,80),
        TabActive = Color3.fromRGB(80,80,80),
        TabInactive = Color3.fromRGB(52,52,52)
    }
}
local themeNames = {}
for k in pairs(Themes) do table.insert(themeNames, k) end
local CurrentTheme = Themes["Bloody Moon"]

local function ApplyTheme(tbl, theme)
    tbl.BackgroundColor3 = theme.Background or tbl.BackgroundColor3
    if tbl:FindFirstChild("Accent") then tbl.Accent.BackgroundColor3 = theme.Accent or tbl.Accent.BackgroundColor3 end
end

local function SetTheme(themeName, allFrames)
    if Themes[themeName] then
        CurrentTheme = Themes[themeName]
        for _, t in ipairs(allFrames) do
            t()
        end
    end
end

-- === UI CREATION ===

local gui = Instance.new("ScreenGui")
gui.Name = "PUPPET_UI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Open/Close Icon (🏠 Home Lucide Icon style, you can change asset id)
local openIcon = Instance.new("ImageButton")
openIcon.Name = "PuppetOpenIcon"
openIcon.Size = UDim2.new(0, 50, 0, 50)
openIcon.Position = UDim2.new(0, 30, 0.5, -25)
openIcon.AnchorPoint = Vector2.new(0, 0.5)
openIcon.Image = "rbxassetid://6035067836" -- Home icon (lucide style), change to your own!
openIcon.BackgroundColor3 = CurrentTheme.Accent
openIcon.BackgroundTransparency = 0.05
openIcon.Parent = gui
local openCorner = Instance.new("UICorner", openIcon) openCorner.CornerRadius = UDim.new(1,0)

-- MAIN WINDOW
local main = Instance.new("Frame")
main.Name = "PuppetMain"
main.Size = UDim2.new(0, 730, 0, 500)
main.Position = UDim2.new(0.5, -365, 0.5, -250)
main.BackgroundColor3 = CurrentTheme.Background
main.BorderSizePixel = 0
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Visible = false
main.Parent = gui
local mainCorner = Instance.new("UICorner", main) mainCorner.CornerRadius = UDim.new(0, 22)
main.ZIndex = 10

-- Top Bar
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 54)
topBar.BackgroundColor3 = CurrentTheme.Accent
local topBarCorner = Instance.new("UICorner", topBar)
topBarCorner.CornerRadius = UDim.new(0, 22)
topBar.Name = "TopBar"

-- Icon
local puppetIcon = Instance.new("ImageLabel", topBar)
puppetIcon.Size = UDim2.new(0, 40, 0, 40)
puppetIcon.Position = UDim2.new(0, 12, 0, 7)
puppetIcon.BackgroundTransparency = 1
puppetIcon.Image = "rbxassetid://6031090990"
local puppetIconCorner = Instance.new("UICorner", puppetIcon) puppetIconCorner.CornerRadius = UDim.new(1,0)

-- Title
local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(0, 270, 1, 0)
title.Position = UDim2.new(0, 54, 0, 0)
title.Text = "PUPPET UI"
title.TextColor3 = CurrentTheme.Text
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.TextXAlignment = Enum.TextXAlignment.Left

-- Window Controls
local minimize = Instance.new("TextButton", topBar)
minimize.Size = UDim2.new(0, 36, 0, 36)
minimize.Position = UDim2.new(1, -86, 0, 9)
minimize.Text = "-"
minimize.BackgroundColor3 = CurrentTheme.Button
minimize.TextColor3 = CurrentTheme.Text
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 22
local minCorner = Instance.new("UICorner", minimize) minCorner.CornerRadius = UDim.new(1,0)

local close = Instance.new("TextButton", topBar)
close.Size = UDim2.new(0, 36, 0, 36)
close.Position = UDim2.new(1, -44, 0, 9)
close.Text = "×"
close.BackgroundColor3 = CurrentTheme.Danger
close.TextColor3 = CurrentTheme.Text
close.Font = Enum.Font.GothamBold
close.TextSize = 22
local closeCorner = Instance.new("UICorner", close) closeCorner.CornerRadius = UDim.new(1,0)

-- Tabs (Scrollable)
local tabsFrame = Instance.new("Frame", main)
tabsFrame.Name = "TabsFrame"
tabsFrame.Size = UDim2.new(0, 120, 1, -54)
tabsFrame.Position = UDim2.new(0, 0, 0, 54)
tabsFrame.BackgroundColor3 = CurrentTheme.Accent
local tabsCorner = Instance.new("UICorner", tabsFrame) tabsCorner.CornerRadius = UDim.new(0, 18)

local tabsScrolling = Instance.new("ScrollingFrame", tabsFrame)
tabsScrolling.Name = "TabsScrolling"
tabsScrolling.Size = UDim2.new(1, 0, 1, 0)
tabsScrolling.CanvasSize = UDim2.new(0,0,0, 9*60+10)
tabsScrolling.ScrollBarThickness = 6
tabsScrolling.BackgroundTransparency = 1
tabsScrolling.BorderSizePixel = 0

local tabData = {
    {Name="Home", Icon="rbxassetid://6035067836"},
    {Name="Key System", Icon="rbxassetid://6031280882"},
    {Name="Buttons", Icon="rbxassetid://6031094678"},
    {Name="Toggles", Icon="rbxassetid://6031280882"},
    {Name="Dropdowns", Icon="rbxassetid://6035067836"},
    {Name="Slider", Icon="rbxassetid://6035067836"},
    {Name="Theme", Icon="rbxassetid://6035067836"},
    {Name="Info", Icon="rbxassetid://6031090990"},
    {Name="Files", Icon="rbxassetid://6031071053"}
}
tabsScrolling.CanvasSize = UDim2.new(0,0,0,#tabData*56+10)
local tabs = {}
local selectedTab = 1

for i, tab in ipairs(tabData) do
    local tabBtn = Instance.new("TextButton", tabsScrolling)
    tabBtn.Size = UDim2.new(1, -12, 0, 46)
    tabBtn.Position = UDim2.new(0, 6, 0, (i-1)*52 + 8)
    tabBtn.BackgroundColor3 = (i==selectedTab) and CurrentTheme.TabActive or CurrentTheme.TabInactive
    tabBtn.Text = "   "..tab.Name
    tabBtn.TextColor3 = CurrentTheme.Text
    tabBtn.Font = Enum.Font.Gotham
    tabBtn.TextSize = 18
    tabBtn.Name = "Tab"..i
    tabBtn.TextXAlignment = Enum.TextXAlignment.Left
    local tabBtnCorner = Instance.new("UICorner", tabBtn) tabBtnCorner.CornerRadius = UDim.new(1,0)

    local icon = Instance.new("ImageLabel", tabBtn)
    icon.Image = tab.Icon
    icon.Size = UDim2.new(0, 22, 0, 22)
    icon.Position = UDim2.new(0, 8, 0.5, -11)
    icon.BackgroundTransparency = 1
    tabs[i] = tabBtn
end

-- Content Frame (Scrollable)
local contentFrame = Instance.new("Frame", main)
contentFrame.Size = UDim2.new(1, -140, 1, -74)
contentFrame.Position = UDim2.new(0, 130, 0, 64)
contentFrame.BackgroundColor3 = CurrentTheme.Panel
local contentCorner = Instance.new("UICorner", contentFrame) contentCorner.CornerRadius = UDim.new(0, 18)

local contentScroll = Instance.new("ScrollingFrame", contentFrame)
contentScroll.Size = UDim2.new(1, 0, 1, 0)
contentScroll.CanvasSize = UDim2.new(0,0,0,800)
contentScroll.ScrollBarThickness = 8
contentScroll.BackgroundTransparency = 1
contentScroll.BorderSizePixel = 0
contentScroll.Name = "ContentScroll"
local layout = Instance.new("UIListLayout", contentScroll)
layout.Padding = UDim.new(0, 16)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local function clearContent()
    for _, child in ipairs(contentScroll:GetChildren()) do
        if not child:IsA("UIListLayout") then
            child:Destroy()
        end
    end
end

-- === RENDERERS ===
local function renderHome()
    clearContent()
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, -20, 0, 60)
    txt.Text = "Welcome to PUPPET UI! Choose a tab to get started."
    txt.TextColor3 = CurrentTheme.Text
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.Gotham
    txt.TextSize = 24
    txt.TextWrapped = true
    txt.LayoutOrder = 1
    txt.Parent = contentScroll
end

local function renderKeySystem()
    clearContent()
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 36)
    label.Text = "Enter your key to unlock features:"
    label.TextColor3 = CurrentTheme.Text
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 18
    label.LayoutOrder = 1
    label.Parent = contentScroll

    local keyBox = Instance.new("TextBox")
    keyBox.Size = UDim2.new(1, -20, 0, 40)
    keyBox.Text = ""
    keyBox.PlaceholderText = "Paste your key here"
    keyBox.TextColor3 = CurrentTheme.Text
    keyBox.BackgroundColor3 = CurrentTheme.Panel
    keyBox.Font = Enum.Font.Gotham
    keyBox.TextSize = 18
    keyBox.LayoutOrder = 2
    keyBox.Parent = contentScroll
    local keyCorner = Instance.new("UICorner", keyBox) keyCorner.CornerRadius = UDim.new(1,0)

    local unlockBtn = Instance.new("TextButton")
    unlockBtn.Size = UDim2.new(0, 120, 0, 40)
    unlockBtn.Position = UDim2.new(0, 10, 0, 0)
    unlockBtn.Text = "Unlock"
    unlockBtn.TextColor3 = CurrentTheme.Text
    unlockBtn.BackgroundColor3 = CurrentTheme.Success
    unlockBtn.Font = Enum.Font.GothamBold
    unlockBtn.TextSize = 20
    unlockBtn.LayoutOrder = 3
    unlockBtn.Parent = contentScroll
    local unlockCorner = Instance.new("UICorner", unlockBtn) unlockCorner.CornerRadius = UDim.new(1,0)

    local result = Instance.new("TextLabel")
    result.Size = UDim2.new(1, -20, 0, 30)
    result.Text = ""
    result.TextColor3 = CurrentTheme.Text
    result.BackgroundTransparency = 1
    result.Font = Enum.Font.Gotham
    result.TextSize = 17
    result.LayoutOrder = 4
    result.Parent = contentScroll

    unlockBtn.MouseButton1Click:Connect(function()
        if keyBox.Text == "PUPPET123" then
            result.Text = "Access Granted!"
            result.TextColor3 = CurrentTheme.Success
        else
            result.Text = "Invalid Key."
            result.TextColor3 = CurrentTheme.Danger
        end
    end)
end

local function renderButtons()
    clearContent()
    for i = 1, 2 do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 44)
        btn.Text = "Button "..i
        btn.TextColor3 = CurrentTheme.Text
        btn.BackgroundColor3 = CurrentTheme.Button
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 18
        btn.LayoutOrder = i
        btn.Parent = contentScroll
        local btnCorner = Instance.new("UICorner", btn) btnCorner.CornerRadius = UDim.new(1,0)

        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(1, -20, 0, 24)
        desc.Text = "This is Button "..i.." description."
        desc.TextColor3 = CurrentTheme.Text
        desc.BackgroundTransparency = 1
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 15
        desc.LayoutOrder = i+10
        desc.Parent = contentScroll
        btn.MouseButton1Click:Connect(function()
            btn.Text = "Clicked!"
        end)
    end
end

local function renderToggles()
    clearContent()
    for i = 1, 2 do
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(1, -20, 0, 44)
        toggle.Text = "Toggle "..i..": OFF"
        toggle.TextColor3 = CurrentTheme.Text
        toggle.BackgroundColor3 = CurrentTheme.Button
        toggle.Font = Enum.Font.Gotham
        toggle.TextSize = 18
        toggle.LayoutOrder = i
        toggle.Parent = contentScroll
        local toggleCorner = Instance.new("UICorner", toggle) toggleCorner.CornerRadius = UDim.new(1,0)

        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(1, -20, 0, 24)
        desc.Text = "This is Toggle "..i.." description."
        desc.TextColor3 = CurrentTheme.Text
        desc.BackgroundTransparency = 1
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 15
        desc.LayoutOrder = i+10
        desc.Parent = contentScroll

        local on = false
        toggle.MouseButton1Click:Connect(function()
            on = not on
            toggle.Text = "Toggle "..i..": "..(on and "ON" or "OFF")
            toggle.BackgroundColor3 = on and CurrentTheme.Success or CurrentTheme.Button
        end)
    end
end

local function renderDropdowns()
    clearContent()
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 36)
    label.Text = "Choose a file:"
    label.TextColor3 = CurrentTheme.Text
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 18
    label.LayoutOrder = 1
    label.Parent = contentScroll

    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(1, -20, 0, 36)
    dropdown.Position = UDim2.new(0, 10, 0, 0)
    dropdown.BackgroundColor3 = CurrentTheme.Button
    dropdown.Text = "Select File ▼"
    dropdown.TextColor3 = CurrentTheme.Text
    dropdown.Font = Enum.Font.Gotham
    dropdown.TextSize = 18
    dropdown.LayoutOrder = 2
    dropdown.Parent = contentScroll
    local dropCorner = Instance.new("UICorner", dropdown) dropCorner.CornerRadius = UDim.new(1,0)

    local files = {"File1.lua", "File2.lua", "ScriptA.lua", "ScriptB.lua"}
    local dropFrame = Instance.new("Frame")
    dropFrame.Size = UDim2.new(1, 0, 0, #files*32)
    dropFrame.Position = UDim2.new(0, 0, 1, 2)
    dropFrame.Visible = false
    dropFrame.BackgroundColor3 = CurrentTheme.Panel
    dropFrame.BorderSizePixel = 0
    dropFrame.Parent = dropdown

    for i, fname in ipairs(files) do
        local opt = Instance.new("TextButton")
        opt.Size = UDim2.new(1, 0, 0, 30)
        opt.Position = UDim2.new(0, 0, 0, (i-1)*32)
        opt.BackgroundColor3 = CurrentTheme.Button
        opt.Text = fname
        opt.TextColor3 = CurrentTheme.Text
        opt.Font = Enum.Font.Gotham
        opt.TextSize = 16
        opt.Parent = dropFrame
        opt.MouseButton1Click:Connect(function()
            dropdown.Text = fname
            dropFrame.Visible = false
        end)
    end
    dropdown.MouseButton1Click:Connect(function()
        dropFrame.Visible = not dropFrame.Visible
    end)
end

local function renderSlider()
    clearContent()
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 36)
    label.Text = "Adjust Value:"
    label.TextColor3 = CurrentTheme.Text
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 18
    label.LayoutOrder = 1
    label.Parent = contentScroll

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -20, 0, 30)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.LayoutOrder = 2
    sliderFrame.Parent = contentScroll

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -40, 0, 8)
    bar.Position = UDim2.new(0, 20, 0.5, -4)
    bar.BackgroundColor3 = CurrentTheme.Button
    bar.Parent = sliderFrame

    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, 20, 0, 20)
    handle.Position = UDim2.new(0, 0, 0.5, -10)
    handle.BackgroundColor3 = CurrentTheme.TabActive
    handle.Parent = sliderFrame

    local value = Instance.new("TextLabel")
    value.Size = UDim2.new(0, 40, 1, 0)
    value.Position = UDim2.new(1, -40, 0, 0)
    value.Text = "0"
    value.TextColor3 = CurrentTheme.Text
    value.BackgroundTransparency = 1
    value.Font = Enum.Font.Gotham
    value.TextSize = 16
    value.Parent = sliderFrame

    local dragging = false
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = input.Position.X - bar.AbsolutePosition.X
            local percent = math.clamp(rel/bar.AbsoluteSize.X, 0, 1)
            handle.Position = UDim2.new(percent, -10, 0.5, -10)
            value.Text = tostring(math.floor(percent*100))
        end
    end)
end

local function renderTheme()
    clearContent()
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 40)
    label.Text = "Choose a Theme:"
    label.TextColor3 = CurrentTheme.Text
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 22
    label.LayoutOrder = 1
    label.Parent = contentScroll

    local themeList = Instance.new("Frame", contentScroll)
    themeList.Size = UDim2.new(1, -20, 0, #themeNames*44)
    themeList.BackgroundTransparency = 1
    themeList.LayoutOrder = 2

    local layout = Instance.new("UIListLayout", themeList)
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    for _, themeName in ipairs(themeNames) do
        local btn = Instance.new("TextButton", themeList)
        btn.Size = UDim2.new(1, 0, 0, 36)
        btn.BackgroundColor3 = Themes[themeName].Button
        btn.Text = themeName
        btn.TextColor3 = Themes[themeName].Text
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 18
        btn.LayoutOrder = 1
        btn.MouseButton1Click:Connect(function()
            SetTheme(themeName, {
                function() main.BackgroundColor3 = Themes[themeName].Background end,
                function() topBar.BackgroundColor3 = Themes[themeName].Accent end,
                function() tabsFrame.BackgroundColor3 = Themes[themeName].Accent end,
                function() contentFrame.BackgroundColor3 = Themes[themeName].Panel end,
                function() title.TextColor3 = Themes[themeName].Text end,
                function() openIcon.BackgroundColor3 = Themes[themeName].Accent end
            })
            CurrentTheme = Themes[themeName]
            tabs[selectedTab].BackgroundColor3 = CurrentTheme.TabActive
        end)
    end
end

local function renderInfo()
    clearContent()
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, -20, 0, 80)
    txt.Text = "PUPPET UI\nCreated by UI-PUPPET\nAll features are fully customizable and modern!"
    txt.TextColor3 = CurrentTheme.Text
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.Gotham
    txt.TextSize = 20
    txt.TextWrapped = true
    txt.LayoutOrder = 1
    txt.Parent = contentScroll
end

local function renderFiles()
    clearContent()
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 36)
    label.Text = "Files (dropdown selector):"
    label.TextColor3 = CurrentTheme.Text
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 18
    label.LayoutOrder = 1
    label.Parent = contentScroll

    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(1, -20, 0, 36)
    dropdown.BackgroundColor3 = CurrentTheme.Button
    dropdown.Text = "Select File ▼"
    dropdown.TextColor3 = CurrentTheme.Text
    dropdown.Font = Enum.Font.Gotham
    dropdown.TextSize = 18
    dropdown.LayoutOrder = 2
    dropdown.Parent = contentScroll
    local dropCorner = Instance.new("UICorner", dropdown) dropCorner.CornerRadius = UDim.new(1,0)

    local files = {"FileX.lua", "FileY.lua", "FileZ.lua"}
    local dropFrame = Instance.new("Frame")
    dropFrame.Size = UDim2.new(1, 0, 0, #files*32)
    dropFrame.Position = UDim2.new(0, 0, 1, 2)
    dropFrame.Visible = false
    dropFrame.BackgroundColor3 = CurrentTheme.Panel
    dropFrame.BorderSizePixel = 0
    dropFrame.Parent = dropdown

    for i, fname in ipairs(files) do
        local opt = Instance.new("TextButton")
        opt.Size = UDim2.new(1, 0, 0, 30)
        opt.Position = UDim2.new(0, 0, 0, (i-1)*32)
        opt.BackgroundColor3 = CurrentTheme.Button
        opt.Text = fname
        opt.TextColor3 = CurrentTheme.Text
        opt.Font = Enum.Font.Gotham
        opt.TextSize = 16
        opt.Parent = dropFrame
        opt.MouseButton1Click:Connect(function()
            dropdown.Text = fname
            dropFrame.Visible = false
        end)
    end
    dropdown.MouseButton1Click:Connect(function()
        dropFrame.Visible = not dropFrame.Visible
    end)
end

local tabRenders = {
    renderHome,
    renderKeySystem,
    renderButtons,
    renderToggles,
    renderDropdowns,
    renderSlider,
    renderTheme,
    renderInfo,
    renderFiles
}

-- Tab Switching Logic
for i, tabBtn in ipairs(tabs) do
    tabBtn.MouseButton1Click:Connect(function()
        for j, btn in ipairs(tabs) do
            btn.BackgroundColor3 = (i == j) and CurrentTheme.TabActive or CurrentTheme.TabInactive
        end
        selectedTab = i
        tabRenders[i]()
    end)
end

tabRenders[1]()

-- Open/Close Logic
openIcon.MouseButton1Click:Connect(function()
    main.Visible = true
    openIcon.Visible = false
end)
close.MouseButton1Click:Connect(function()
    main.Visible = false
    openIcon.Visible = true
end)
minimize.MouseButton1Click:Connect(function()
    main.Visible = false
    openIcon.Visible = true
end)

-- Dragging
local dragging = false
local dragStart, startPos
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- THEME HOTKEY: Press T to open Theme tab directly!
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.T then
        main.Visible = true
        openIcon.Visible = false
        for j, btn in ipairs(tabs) do
            btn.BackgroundColor3 = (j == 7) and CurrentTheme.TabActive or CurrentTheme.TabInactive
        end
        selectedTab = 7
        tabRenders[7]()
    end
end)

-- READY! You can now expand each tab with your own logic/controls as needed!
