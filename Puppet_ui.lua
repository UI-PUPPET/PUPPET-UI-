-- PUPPET UI 
-- Author: MOHA

local PuppetUI = {}
PuppetUI.__index = PuppetUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local CONFIG_FILE = "PUPPET_UI_Config.json"

local function createInstance(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        inst[k] = v
    end
    return inst
end

local function loadConfig()
    if isfile(CONFIG_FILE) then
        return HttpService:JSONDecode(readfile(CONFIG_FILE))
    end
    return {}
end

local function saveConfig(cfg)
    writefile(CONFIG_FILE, HttpService:JSONEncode(cfg))
end

function PuppetUI:CreateWindow(title)
    local self = setmetatable({}, PuppetUI)
    self.Tabs = {}
    self.Config = loadConfig()

    local ScreenGui = createInstance("ScreenGui", {
        Name = "PUPPET_UI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = CoreGui
    })

    local Main = createInstance("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 600, 0, 400),
        Position = UDim2.new(0.5, -300, 0.5, -200),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = ScreenGui
    })

    local TopBar = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Parent = Main
    })

    local Title = createInstance("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Text = title or "PUPPET UI",
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })

    local Close = createInstance("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5),
        Text = "✕",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Color3.fromRGB(255, 80, 80),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Parent = TopBar
    })

    Close.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = false
    end)

    local TabsHolder = createInstance("Frame", {
        Name = "Tabs",
        Size = UDim2.new(0, 120, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderSizePixel = 0,
        Parent = Main
    })

    local ContentFrame = createInstance("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -120, 1, -40),
        Position = UDim2.new(0, 120, 0, 40),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Parent = Main
    })

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = TabsHolder

    self.ScreenGui = ScreenGui
    self.Main = Main
    self.TabsHolder = TabsHolder
    self.ContentFrame = ContentFrame
    return self
end

function PuppetUI:CreateTab(icon, name)
    local tabButton = createInstance("TextButton", {
        Size = UDim2.new(1, 0, 0, 40),
        Text = icon .. "  " .. name,
        Font = Enum.Font.Gotham,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BorderSizePixel = 0,
        Parent = self.TabsHolder
    })

    local scroll = createInstance("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        BorderSizePixel = 0,
        ScrollBarThickness = 6,
        Visible = false,
        Parent = self.ContentFrame
    })

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = scroll

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    tabButton.MouseButton1Click:Connect(function()
        for _, obj in ipairs(self.ContentFrame:GetChildren()) do
            if obj:IsA("ScrollingFrame") then obj.Visible = false end
        end
        scroll.Visible = true
    end)

    scroll.Visible = (#self.Tabs == 0)
    table.insert(self.Tabs, scroll)

    return {
        Frame = scroll,
        AddButton = function(_, text, callback)
            local btn = createInstance("TextButton", {
                Size = UDim2.new(1, -10, 0, 36),
                Text = text,
                Font = Enum.Font.GothamBold,
                TextSize = 15,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0,
                Parent = scroll
            })
            btn.MouseButton1Click:Connect(callback)
        end,

        AddToggle = function(_, text, key, callback)
            local toggle = createInstance("TextButton", {
                Size = UDim2.new(1, -10, 0, 36),
                Text = text .. " [OFF]",
                Font = Enum.Font.Gotham,
                TextSize = 15,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0,
                Parent = scroll
            })
            local state = self.Config[key] or false
            toggle.Text = text .. (state and " [ON]" or " [OFF]")
            toggle.MouseButton1Click:Connect(function()
                state = not state
                self.Config[key] = state
                toggle.Text = text .. (state and " [ON]" or " [OFF]")
                saveConfig(self.Config)
                callback(state)
            end)
        end
    }
end

return PuppetUI
