local Puppet = {}
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Utility for creating instances
local function Create(class, props)
    local inst = Instance.new(class)
    for k,v in pairs(props) do
        inst[k] = v
    end
    return inst
end

-- Create a Window
function Puppet:CreateWindow(Config)
    local Window = {}
    Window.Title = Config.Title or "Puppet UI"
    Window.Icon = Config.Icon or "rbxassetid://6031075931" -- default icon

    -- ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "PuppetUI",
        ResetOnSpawn = false,
        Parent = player:WaitForChild("PlayerGui")
    })

    -- Main Window
    local Main = Create("Frame", {
        Size = UDim2.new(0, 500, 0, 350),
        Position = UDim2.new(0.25, 0, 0.25, 0),
        BackgroundColor3 = Color3.fromRGB(25,25,25),
        Active = true,
        Draggable = true,
        Visible = true,
        Parent = ScreenGui
    })

    -- Topbar
    local Topbar = Create("Frame", {
        Size = UDim2.new(1,0,0,40),
        BackgroundColor3 = Color3.fromRGB(35,35,35),
        Parent = Main
    })

    local Title = Create("TextLabel", {
        Size = UDim2.new(1,0,1,0),
        Text = Window.Title,
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255,255,255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Parent = Topbar
    })

    -- Minimize / Maximize Button (Logo Icon)
    local LogoButton = Create("ImageButton", {
        Size = UDim2.new(0,40,0,40),
        Position = UDim2.new(1,-45,0,0),
        BackgroundTransparency = 1,
        Image = Window.Icon,
        Parent = Topbar
    })

    -- Tabs container
    local TabFrame = Create("Frame", {
        Size = UDim2.new(0,120,1,-40),
        Position = UDim2.new(0,0,0,40),
        BackgroundColor3 = Color3.fromRGB(30,30,30),
        Parent = Main
    })

    local Content = Create("Frame", {
        Size = UDim2.new(1,-120,1,-40),
        Position = UDim2.new(0,120,0,40),
        BackgroundColor3 = Color3.fromRGB(40,40,40),
        Parent = Main
    })

    local Tabs = {}
    Window.Tabs = Tabs

    -- Minimize / Maximize Logic
    local isVisible = true
    function Window:ToggleUI(State)
        if typeof(State) == "boolean" then
            isVisible = State
        else
            isVisible = not isVisible
        end
        Main.Visible = isVisible
    end

    LogoButton.MouseButton1Click:Connect(function()
        Window:ToggleUI()
    end)

    -- Add Tab
    function Window:AddTab(name)
        local Tab = {}
        local Button = Create("TextButton", {
            Size = UDim2.new(1,0,0,40),
            Text = name,
            TextColor3 = Color3.fromRGB(255,255,255),
            BackgroundColor3 = Color3.fromRGB(30,30,30),
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
                if pg:IsA("ScrollingFrame") then
                    pg.Visible = false
                end
            end
            Page.Visible = true
        end)

        -- Add Toggle
        function Tab:AddToggle(Config)
            local state = Config.Default or false
            local Toggle = Create("TextButton", {
                Size = UDim2.new(1,-10,0,30),
                Text = (state and "[✔] " or "[ ] ") .. (Config.Title or "Toggle"),
                TextColor3 = Color3.fromRGB(255,255,255),
                BackgroundColor3 = Color3.fromRGB(50,50,50),
                Parent = Page
            })

            local function Update()
                Toggle.Text = (state and "[✔] " or "[ ] ") .. Config.Title
                if Config.Callback then
                    Config.Callback(state)
                end
            end

            Toggle.MouseButton1Click:Connect(function()
                state = not state
                Update()
            end)

            Update()
        end

        -- Add Button
        function Tab:AddButton(Config)
            local ButtonEl = Create("TextButton", {
                Size = UDim2.new(1,-10,0,30),
                Text = Config.Title or "Button",
                TextColor3 = Color3.fromRGB(255,255,255),
                BackgroundColor3 = Color3.fromRGB(60,60,60),
                Parent = Page
            })

            ButtonEl.MouseButton1Click:Connect(function()
                if Config.Callback then
                    Config.Callback()
                end
            end)
        end

        -- Add Dropdown
        function Tab:AddDropdown(Config)
            local Dropdown = Create("TextButton", {
                Size = UDim2.new(1,-10,0,30),
                Text = (Config.Title or "Dropdown") .. " ▼",
                TextColor3 = Color3.fromRGB(255,255,255),
                BackgroundColor3 = Color3.fromRGB(70,70,70),
                Parent = Page
            })

            local ListFrame = Create("Frame", {
                Size = UDim2.new(1,-10,0,#Config.Options * 25),
                BackgroundColor3 = Color3.fromRGB(50,50,50),
                Visible = false,
                Parent = Page
            })

            local UIList = Instance.new("UIListLayout", ListFrame)
            UIList.SortOrder = Enum.SortOrder.LayoutOrder

            for _,opt in ipairs(Config.Options or {}) do
                local OptBtn = Create("TextButton", {
                    Size = UDim2.new(1,0,0,25),
                    Text = opt,
                    TextColor3 = Color3.fromRGB(255,255,255),
                    BackgroundColor3 = Color3.fromRGB(80,80,80),
                    Parent = ListFrame
                })

                OptBtn.MouseButton1Click:Connect(function()
                    Dropdown.Text = opt .. " ▼"
                    ListFrame.Visible = false
                    if Config.Callback then
                        Config.Callback(opt)
                    end
                end)
            end

            Dropdown.MouseButton1Click:Connect(function()
                ListFrame.Visible = not ListFrame.Visible
            end)
        end

        -- Add Slider
        function Tab:AddSlider(Config)
            local Frame = Create("Frame", {
                Size = UDim2.new(1,-10,0,40),
                BackgroundColor3 = Color3.fromRGB(60,60,60),
                Parent = Page
            })

            local Label = Create("TextLabel", {
                Size = UDim2.new(1,0,0,20),
                BackgroundTransparency = 1,
                Text = Config.Title or "Slider",
                TextColor3 = Color3.fromRGB(255,255,255),
                Parent = Frame
            })

            local SliderBar = Create("Frame", {
                Size = UDim2.new(1,-20,0,10),
                Position = UDim2.new(0,10,0,25),
                BackgroundColor3 = Color3.fromRGB(90,90,90),
                Parent = Frame
            })

            local Fill = Create("Frame", {
                Size = UDim2.new(0,0,1,0),
                BackgroundColor3 = Color3.fromRGB(0,170,255),
                Parent = SliderBar
            })

            local Min, Max = Config.Min or 0, Config.Max or 100
            local Value = Config.Default or Min

            local function SetValue(val)
                Value = math.clamp(val, Min, Max)
                Fill.Size = UDim2.new((Value-Min)/(Max-Min),0,1,0)
                if Config.Callback then
                    Config.Callback(Value)
                end
            end

            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local conn
                    conn = game:GetService("UserInputService").InputChanged:Connect(function(change)
                        if change.UserInputType == Enum.UserInputType.MouseMovement then
                            local ratio = (change.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
                            SetValue(math.floor(Min + (Max-Min)*ratio))
                        end
                    end)
                    game:GetService("UserInputService").InputEnded:Connect(function(endInput)
                        if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
                            conn:Disconnect()
                        end
                    end)
                end
            end)

            SetValue(Value)
        end

        table.insert(Tabs, Tab)
        return Tab
    end

    return Window
end

return Puppet
