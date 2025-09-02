-- Puppet UI Library
local Puppet = {}

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function Create(class, props)
    local inst = Instance.new(class)
    for k,v in pairs(props) do
        inst[k] = v
    end
    return inst
end

function Puppet:CreateWindow(options)
    local ScreenGui = Create("ScreenGui", {
        Name = "PuppetUI",
        ResetOnSpawn = false,
        Parent = player:WaitForChild("PlayerGui")
    })

    local Window = Create("Frame", {
        Size = UDim2.new(0, 500, 0, 350),
        Position = UDim2.new(0.25, 0, 0.25, 0),
        BackgroundColor3 = Color3.fromRGB(25,25,25),
        Active = true,
        Draggable = true,
        Parent = ScreenGui
    })

    local Topbar = Create("Frame", {
        Size = UDim2.new(1,0,0,40),
        BackgroundColor3 = Color3.fromRGB(35,35,35),
        Parent = Window
    })

    local Title = Create("TextLabel", {
        Size = UDim2.new(1,0,1,0),
        Text = options.Title or "Puppet UI",
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255,255,255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Parent = Topbar
    })

    local Tabs = {}
    local TabButtons = {}
    local TabFrame = Create("Frame", {
        Size = UDim2.new(0,120,1,-40),
        Position = UDim2.new(0,0,0,40),
        BackgroundColor3 = Color3.fromRGB(30,30,30),
        Parent = Window
    })

    local Content = Create("Frame", {
        Size = UDim2.new(1,-120,1,-40),
        Position = UDim2.new(0,120,0,40),
        BackgroundColor3 = Color3.fromRGB(40,40,40),
        Parent = Window
    })

    function Tabs:AddTab(name)
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
                if pg:IsA("ScrollingFrame") then pg.Visible = false end
            end
            Page.Visible = true
        end)

        local TabAPI = {}

        function TabAPI:AddToggle(text, config, callback)
            local Toggle = Create("TextButton", {
                Size = UDim2.new(1,-10,0,30),
                Text = "[ ] " .. text,
                TextColor3 = Color3.fromRGB(255,255,255),
                BackgroundColor3 = Color3.fromRGB(50,50,50),
                Parent = Page
            })
            local state = config.Default or false

            local function Update()
                Toggle.Text = (state and "[✔] " or "[ ] ") .. text
                if callback then callback(state) end
            end

            Toggle.MouseButton1Click:Connect(function()
                state = not state
                Update()
            end)

            Update()
        end

        return TabAPI
    end

    return Tabs
end

return Puppet
