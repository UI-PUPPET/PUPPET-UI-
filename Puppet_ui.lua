--[[
    PUPPET UI v1.0  
    MADE BY MOHA 🌊
]]

local PuppetUI = {}
PuppetUI.__index = PuppetUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local CONFIG_NAME = "PUPPET_UI_Config.json"
local config = isfile(CONFIG_NAME) and HttpService:JSONDecode(readfile(CONFIG_NAME)) or {}
local function SaveConfig() writefile(CONFIG_NAME, HttpService:JSONEncode(config)) end

local function New(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end

function PuppetUI:CreateWindow(settings)
    local self = setmetatable({}, PuppetUI)
    self.Config = config
    self.Tabs = {}

    local GUI = New("ScreenGui", {
        Name = "PUPPET_UI",
        Parent = CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local Main = New("Frame", {
        Size = UDim2.new(0, 600, 0, 420),
        Position = UDim2.new(0.5, -300, 0.5, -210),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = GUI
    })
    New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Main })

    local TopBar = New("Frame", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BorderSizePixel = 0,
        Parent = Main
    })
    New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = TopBar })

    local Title = New("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 40, 0, 0),
        Text = settings.Title or "PUPPET UI",
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextColor3 = Color3.fromRGB(130, 200, 255),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })

    if settings.LogoImage then
        New("ImageLabel", {
            Size = UDim2.new(0, 28, 0, 28),
            Position = UDim2.new(0, 6, 0.5, -14),
            Image = settings.LogoImage,
            BackgroundTransparency = 1,
            Parent = TopBar
        })
    end

    local Close = New("TextButton", {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -36, 0, 4),
        Text = "✕",
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = Color3.fromRGB(255, 80, 80),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        Parent = TopBar
    })
    New("UICorner", { CornerRadius = UDim.new(0, 4), Parent = Close })

    Close.MouseButton1Click:Connect(function()
        GUI:Destroy()
    end)

    local TabBar = New("Frame", {
        Size = UDim2.new(0, 130, 1, -36),
        Position = UDim2.new(0, 0, 0, 36),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0,
        Parent = Main
    })
    New("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = TabBar })

    local Body = New("Frame", {
        Size = UDim2.new(1, -130, 1, -36),
        Position = UDim2.new(0, 130, 0, 36),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Parent = Main
    })

    function self:CreateTab(icon, label)
        local TabBtn = New("TextButton", {
            Size = UDim2.new(1, -12, 0, 32),
            Text = icon .. "  " .. label,
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextColor3 = Color3.fromRGB(220, 220, 220),
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            BorderSizePixel = 0,
            Parent = TabBar
        })
        New("UICorner", { CornerRadius = UDim.new(0, 4), Parent = TabBtn })

        local TabContent = New("ScrollingFrame", {
            Visible = false,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 6,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Parent = Body
        })
        local Layout = New("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = TabContent
        })
        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 16)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in ipairs(Body:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            TabContent.Visible = true
        end)

        local tab = {}

        function tab:AddButton(text, callback)
            local btn = New("TextButton", {
                Size = UDim2.new(1, -10, 0, 30),
                Text = text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = Color3.fromRGB(255,255,255),
                BackgroundColor3 = Color3.fromRGB(60,60,60),
                Parent = TabContent
            })
            New("UICorner", { CornerRadius = UDim.new(0, 4), Parent = btn })
            btn.MouseButton1Click:Connect(callback)
        end

        function tab:AddToggle(text, key, callback)
            local state = config[key] or false
            local btn = New("TextButton", {
                Size = UDim2.new(1, -10, 0, 30),
                Text = text .. " [" .. (state and "ON" or "OFF") .. "]",
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = Color3.fromRGB(255,255,255),
                BackgroundColor3 = Color3.fromRGB(60,60,60),
                Parent = TabContent
            })
            New("UICorner", { CornerRadius = UDim.new(0, 4), Parent = btn })
            btn.MouseButton1Click:Connect(function()
                state = not state
                btn.Text = text .. " [" .. (state and "ON" or "OFF") .. "]"
                config[key] = state
                SaveConfig()
                callback(state)
            end)
        end

        function tab:AddDropdown(text, options, key, callback)
            local chosen = config[key] or options[1]
            local main = New("TextButton", {
                Size = UDim2.new(1, -10, 0, 30),
                Text = text .. ": " .. chosen,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = Color3.fromRGB(255,255,255),
                BackgroundColor3 = Color3.fromRGB(60,60,60),
                Parent = TabContent
            })
            New("UICorner", { CornerRadius = UDim.new(0, 4), Parent = main })
            main.MouseButton1Click:Connect(function()
                for _, opt in ipairs(options) do
                    local o = New("TextButton", {
                        Size = UDim2.new(1, -10, 0, 26),
                        Text = "↳ " .. opt,
                        Font = Enum.Font.Gotham,
                        TextSize = 13,
                        TextColor3 = Color3.fromRGB(255,255,255),
                        BackgroundColor3 = Color3.fromRGB(45,45,45),
                        Parent = TabContent
                    })
                    New("UICorner", { CornerRadius = UDim.new(0, 4), Parent = o })
                    o.MouseButton1Click:Connect(function()
                        main.Text = text .. ": " .. opt
                        config[key] = opt
                        SaveConfig()
                        callback(opt)
                        for _, c in ipairs(TabContent:GetChildren()) do
                            if c ~= main and c:IsA("TextButton") and string.sub(c.Text, 1, 2) == "↳ " then
                                c:Destroy()
                            end
                        end
                    end)
                end
            end)
        end

        function tab:AddKeybind(text, key, default, callback)
            local current = config[key] or default
            local btn = New("TextButton", {
                Size = UDim2.new(1, -10, 0, 30),
                Text = text .. ": " .. current.Name,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = Color3.fromRGB(255,255,255),
                BackgroundColor3 = Color3.fromRGB(60,60,60),
                Parent = TabContent
            })
            New("UICorner", { CornerRadius = UDim.new(0, 4), Parent = btn })
            btn.MouseButton1Click:Connect(function()
                btn.Text = text .. ": [Press Key]"
                local conn
                conn = UserInputService.InputBegan:Connect(function(input, gp)
                    if not gp and input.UserInputType == Enum.UserInputType.Keyboard then
                        current = input.KeyCode
                        config[key] = current
                        SaveConfig()
                        btn.Text = text .. ": " .. current.Name
                        conn:Disconnect()
                        callback(current)
                    end
                end)
            end)
            UserInputService.InputBegan:Connect(function(input)
                if input.KeyCode == current then
                    callback(input.KeyCode)
                end
            end)
        end

        return tab
    end

    return self
end

return PuppetUI
