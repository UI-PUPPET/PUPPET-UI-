
local Puppet = {}

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Helper function to create instances
local function Create(class, props)
    local inst = Instance.new(class)
    for k,v in pairs(props) do
        inst[k] = v
    end
    return inst
end

function Puppet:CreateWindow(options)
    options = options or {}
    local ScreenGui = Create("ScreenGui", {
        Name = "PuppetUI",
        ResetOnSpawn = false,
        Parent = player:WaitForChild("PlayerGui")
    })

    local Window = Create("Frame", {
        Size = UDim2.new(0, 600, 0, 400),
        Position = UDim2.new(0.25, 0, 0.25, 0),
        BackgroundColor3 = Color3.fromRGB(25,25,25),
        BorderSizePixel = 0,
        Active = true,
        Draggable = true,
        Parent = ScreenGui
    })

    local Topbar = Create("Frame", {
        Size = UDim2.new(1,0,0,40),
        BackgroundColor3 = Color3.fromRGB(35,35,35),
        BorderSizePixel = 0,
        Parent = Window
    })

    local Title = Create("TextLabel", {
        Size = UDim2.new(1,-50,1,0),
        Position = UDim2.new(0,10,0,0),
        Text = options.Title or "Puppet UI",
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255,255,255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Topbar
    })

    -- Minimize / Maximize Button with Logo
    local ToggleButton = Create("ImageButton", {
        Size = UDim2.new(0,30,0,30),
        Position = UDim2.new(1,-35,0.5,-15),
        BackgroundTransparency = 1,
        Image = "rbxassetid://125260781582626",
        Parent = Topbar
    })

    local TabFrame = Create("Frame", {
        Size = UDim2.new(0,150,1,-40),
        Position = UDim2.new(0,0,0,40),
        BackgroundColor3 = Color3.fromRGB(30,30,30),
        BorderSizePixel = 0,
        Parent = Window
    })

    local Content = Create("Frame", {
        Size = UDim2.new(1,-150,1,-40),
        Position = UDim2.new(0,150,0,40),
        BackgroundColor3 = Color3.fromRGB(40,40,40),
        BorderSizePixel = 0,
        Parent = Window
    })

    -- Minimize/Maximize Logic
    local isVisible = true
    ToggleButton.MouseButton1Click:Connect(function()
        isVisible = not isVisible
        Window.Visible = isVisible
    end)

    local Tabs = {}
    function Tabs:AddTab(name)
        local Button = Create("TextButton", {
            Size = UDim2.new(1,0,0,40),
            Text = name,
            TextColor3 = Color3.fromRGB(255,255,255),
            BackgroundColor3 = Color3.fromRGB(30,30,30),
            Font = Enum.Font.Gotham,
            TextSize = 14,
            Parent = TabFrame
        })

        local Page = Create("ScrollingFrame", {
            Size = UDim2.new(1,0,1,0),
            CanvasSize = UDim2.new(0,0,0,0),
            ScrollBarThickness = 4,
            BackgroundTransparency = 1,
            Visible = false,
            Parent = Content
        })

        local UIList = Instance.new("UIListLayout", Page)
        UIList.Padding = UDim.new(0,6)
        UIList.SortOrder = Enum.SortOrder.LayoutOrder

        Button.MouseButton1Click:Connect(function()
            for _,pg in ipairs(Content:GetChildren()) do
                if pg:IsA("ScrollingFrame") then pg.Visible = false end
            end
            Page.Visible = true
        end)

        local TabAPI = {}

        -- Toggle
        function TabAPI:AddToggle(text, config, callback)
            local Toggle = Create("TextButton", {
                Size = UDim2.new(1,-10,0,30),
                Text = text .. ": OFF",
                TextColor3 = Color3.fromRGB(255,255,255),
                BackgroundColor3 = Color3.fromRGB(50,50,50),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                Parent = Page
            })
            local state = config.Default or false

            local function Update()
                Toggle.Text = text .. ": " .. (state and "ON" or "OFF")
                if callback then callback(state) end
            end

            Toggle.MouseButton1Click:Connect(function()
                state = not state
                Update()
            end)

            Update()
        end

        -- Button
        function TabAPI:AddButton(text, callback)
            local Btn = Create("TextButton", {
                Size = UDim2.new(1,-10,0,30),
                Text = text,
                TextColor3 = Color3.fromRGB(255,255,255),
                BackgroundColor3 = Color3.fromRGB(70,70,70),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                Parent = Page
            })
            Btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
        end

        -- Slider
        function TabAPI:AddSlider(text, min, max, default, callback)
            local Frame = Create("Frame", {
                Size = UDim2.new(1,-10,0,40),
                BackgroundTransparency = 1,
                Parent = Page
            })
            local Label = Create("TextLabel", {
                Size = UDim2.new(1,0,0,20),
                Text = text .. ": " .. tostring(default),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(255,255,255),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                Parent = Frame
            })
            local SliderBack = Create("Frame", {
                Size = UDim2.new(1,0,0,10),
                Position = UDim2.new(0,0,0,25),
                BackgroundColor3 = Color3.fromRGB(60,60,60),
                Parent = Frame
            })
            local SliderFill = Create("Frame", {
                Size = UDim2.new((default-min)/(max-min),0,1,0),
                BackgroundColor3 = Color3.fromRGB(120,120,255),
                Parent = SliderBack
            })
            local UserInputService = game:GetService("UserInputService")

            local dragging = false
            SliderBack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pct = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X)/SliderBack.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max-min)*pct)
                    SliderFill.Size = UDim2.new(pct,0,1,0)
                    Label.Text = text .. ": " .. tostring(value)
                    if callback then callback(value) end
                end
            end)
        end

        -- Dropdown
        function TabAPI:AddDropdown(text, list, callback)
            local Dropdown = Create("TextButton", {
                Size = UDim2.new(1,-10,0,30),
                Text = text .. " ▼",
                TextColor3 = Color3.fromRGB(255,255,255),
                BackgroundColor3 = Color3.fromRGB(50,50,50),
                Font = Enum.Font.Gotham,
                TextSize = 14,
                Parent = Page
            })

            local Open = false
            local OptionsFrame = Create("Frame", {
                Size = UDim2.new(1,-10,0,#list*30),
                Position = UDim2.new(0,0,0,30),
                BackgroundColor3 = Color3.fromRGB(40,40,40),
                Visible = false,
                Parent = Page
            })

            local UIList2 = Instance.new("UIListLayout", OptionsFrame)
            UIList2.Padding = UDim.new(0,2)
            UIList2.SortOrder = Enum.SortOrder.LayoutOrder

            for _,item in ipairs(list) do
                local Opt = Create("TextButton", {
                    Size = UDim2.new(1,0,0,30),
                    Text = item,
                    TextColor3 = Color3.fromRGB(255,255,255),
                    BackgroundColor3 = Color3.fromRGB(60,60,60),
                    Font = Enum.Font.Gotham,
                    TextSize = 14,
                    Parent = OptionsFrame
                })
                Opt.MouseButton1Click:Connect(function()
                    Dropdown.Text = text .. ": " .. item
                    OptionsFrame.Visible = false
                    Open = false
                    if callback then callback(item) end
                end)
            end

            Dropdown.MouseButton1Click:Connect(function()
                Open = not Open
                OptionsFrame.Visible = Open
            end)
        end

        return TabAPI
    end

    return Tabs
end

return Puppet
