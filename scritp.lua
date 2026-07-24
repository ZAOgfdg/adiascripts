-- // UI System - Adia Cheat v2.0
-- // Theoretical UI Framework for Roblox Research

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- // UI Library Setup
local Library = {
    Windows = {},
    CurrentWindow = nil,
    Dragging = false,
    DragInput = nil
}

-- // Main Window Constructor
function Library:CreateWindow(title, size)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AdiaCheatGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = size or UDim2.new(0, 500, 0, 600)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    -- // Drop Shadow
    local Shadow = Instance.new("Frame")
    Shadow.Size = UDim2.new(1, 10, 1, 10)
    Shadow.Position = UDim2.new(0, -5, 0, -5)
    Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.BackgroundTransparency = 0.5
    Shadow.BorderSizePixel = 0
    Shadow.Parent = MainFrame
    
    -- // Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "⚡ " .. title .. " v2.0"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Parent = TitleBar
    
    -- // Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 30, 1, 0)
    CloseBtn.Position = UDim2.new(1, -35, 0, 0)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.BackgroundTransparency = 0.8
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.Gotham
    CloseBtn.TextSize = 16
    CloseBtn.Parent = TitleBar
    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)
    
    -- // Tab Bar
    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, 0, 0, 40)
    TabBar.Position = UDim2.new(0, 0, 0, 35)
    TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TabBar.BorderSizePixel = 0
    TabBar.Parent = MainFrame
    
    -- // Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -20, 1, -95)
    ContentContainer.Position = UDim2.new(0, 10, 0, 80)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    -- // Status Bar
    local StatusBar = Instance.new("Frame")
    StatusBar.Size = UDim2.new(1, 0, 0, 25)
    StatusBar.Position = UDim2.new(0, 0, 1, -25)
    StatusBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    StatusBar.BorderSizePixel = 0
    StatusBar.Parent = MainFrame
    
    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(1, -20, 1, 0)
    StatusText.Position = UDim2.new(0, 10, 0, 0)
    StatusText.BackgroundTransparency = 1
    StatusText.Text = "● Active  |  FPS: 60  |  Players: " .. #Players:GetPlayers()
    StatusText.TextColor3 = Color3.fromRGB(100, 255, 100)
    StatusText.TextXAlignment = Enum.TextXAlignment.Left
    StatusText.Font = Enum.Font.Gotham
    StatusText.TextSize = 12
    StatusText.Parent = StatusBar
    
    -- // Drag Functionality
    local dragging = false
    local dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
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
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                          startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    local Window = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        ContentContainer = ContentContainer,
        TabBar = TabBar,
        StatusText = StatusText,
        Tabs = {},
        CurrentTab = nil
    }
    
    table.insert(Library.Windows, Window)
    return Window
end

-- // Tab Creator
function Library:CreateTab(window, name, icon)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0, 120, 1, 0)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = icon .. " " .. name
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.TextSize = 14
    TabBtn.Parent = window.TabBar
    
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.ScrollBarThickness = 4
    TabContent.Visible = false
    TabContent.Parent = window.ContentContainer
    
    local UIGrid = Instance.new("UIGridLayout")
    UIGrid.CellSize = UDim2.new(1, -10, 0, 40)
    UIGrid.CellPadding = UDim2.new(0, 5, 0, 5)
    UIGrid.FillDirection = Enum.FillDirection.Vertical
    UIGrid.SortOrder = Enum.SortOrder.LayoutOrder
    UIGrid.Parent = TabContent
    
    local Tab = {
        Button = TabBtn,
        Content = TabContent,
        UIGrid = UIGrid,
        Elements = {}
    }
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(window.Tabs) do
            t.Content.Visible = false
            t.Button.TextColor3 = Color3.fromRGB(180, 180, 190)
        end
        TabContent.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        window.CurrentTab = Tab
    end)
    
    table.insert(window.Tabs, Tab)
    
    if not window.CurrentTab then
        TabContent.Visible = true
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        window.CurrentTab = Tab
    end
    
    return Tab
end

-- // Toggle Element
function Library:CreateToggle(parent, label, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Frame.BackgroundTransparency = 0.5
    Frame.BorderSizePixel = 1
    Frame.BorderColor3 = Color3.fromRGB(40, 40, 45)
    Frame.Parent = parent.Content
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = label
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.Parent = Frame
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 40, 0, 22)
    ToggleBtn.Position = UDim2.new(1, -50, 0.5, -11)
    ToggleBtn.BackgroundColor3 = default and Color3.fromRGB(50, 200, 80) or Color3.fromRGB(60, 60, 70)
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Text = default and "ON" or "OFF"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 11
    ToggleBtn.Parent = Frame
    
    local state = default
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        ToggleBtn.BackgroundColor3 = state and Color3.fromRGB(50, 200, 80) or Color3.fromRGB(60, 60, 70)
        ToggleBtn.Text = state and "ON" or "OFF"
        if callback then callback(state) end
    end)
    
    table.insert(parent.Elements, {Type = "Toggle", Frame = Frame, Button = ToggleBtn, State = state})
    return ToggleBtn
end

-- // Slider Element
function Library:CreateSlider(parent, label, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Frame.BackgroundTransparency = 0.5
    Frame.BorderSizePixel = 1
    Frame.BorderColor3 = Color3.fromRGB(40, 40, 45)
    Frame.Parent = parent.Content
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -100, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = label
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.Parent = Frame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 40, 0, 20)
    ValueLabel.Position = UDim2.new(1, -50, 0, 5)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 14
    ValueLabel.Parent = Frame
    
    local Slider = Instance.new("Frame")
    Slider.Size = UDim2.new(1, -20, 0, 3)
    Slider.Position = UDim2.new(0, 10, 0, 32)
    Slider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Slider.BorderSizePixel = 0
    Slider.Parent = Frame
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(70, 150, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = Slider
    
    local DragBtn = Instance.new("TextButton")
    DragBtn.Size = UDim2.new(0, 12, 0, 12)
    DragBtn.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
    DragBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
    DragBtn.BorderSizePixel = 0
    DragBtn.Text = ""
    DragBtn.Parent = Slider
    
    local value = default
    local dragging = false
    
    DragBtn.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relX = input.Position.X - Slider.AbsolutePosition.X
            local percent = math.clamp(relX / Slider.AbsoluteSize.X, 0, 1)
            value = min + (max - min) * percent
            value = math.round(value)
            
            Fill.Size = UDim2.new(percent, 0, 1, 0)
            DragBtn.Position = UDim2.new(percent, -6, 0.5, -6)
            ValueLabel.Text = tostring(value)
            
            if callback then callback(value) end
        end
    end)
    
    table.insert(parent.Elements, {Type = "Slider", Frame = Frame, Value = value})
    return {Value = value, SetValue = function(v) 
        v = math.clamp(v, min, max)
        value = v
        local percent = (v - min) / (max - min)
        Fill.Size = UDim2.new(percent, 0, 1, 0)
        DragBtn.Position = UDim2.new(percent, -6, 0.5, -6)
        ValueLabel.Text = tostring(v)
    end}
end

-- // Dropdown Element
function Library:CreateDropdown(parent, label, options, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Frame.BackgroundTransparency = 0.5
    Frame.BorderSizePixel = 1
    Frame.BorderColor3 = Color3.fromRGB(40, 40, 45)
    Frame.Parent = parent.Content
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.4, -10, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = label
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.Parent = Frame
    
    local DropdownBtn = Instance.new("TextButton")
    DropdownBtn.Size = UDim2.new(0.6, -20, 1, -10)
    DropdownBtn.Position = UDim2.new(0.4, 0, 0, 5)
    DropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    DropdownBtn.BorderSizePixel = 1
    DropdownBtn.BorderColor3 = Color3.fromRGB(60, 60, 70)
    DropdownBtn.Text = default
    DropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownBtn.Font = Enum.Font.Gotham
    DropdownBtn.TextSize = 13
    DropdownBtn.Parent = Frame
    
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(0.6, -20, 0, 100)
    DropdownFrame.Position = UDim2.new(0.4, 0, 1, 5)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    DropdownFrame.BorderSizePixel = 1
    DropdownFrame.BorderColor3 = Color3.fromRGB(50, 50, 60)
    DropdownFrame.Visible = false
    DropdownFrame.ZIndex = 10
    DropdownFrame.Parent = Frame
    
    local DropdownList = Instance.new("ScrollingFrame")
    DropdownList.Size = UDim2.new(1, 0, 1, 0)
    DropdownList.BackgroundTransparency = 1
    DropdownList.ScrollBarThickness = 3
    DropdownList.Parent = DropdownFrame
    
    local UIGrid2 = Instance.new("UIGridLayout")
    UIGrid2.CellSize = UDim2.new(1, 0, 0, 25)
    UIGrid2.CellPadding = UDim2.new(0, 0, 0, 2)
    UIGrid2.FillDirection = Enum.FillDirection.Vertical
    UIGrid2.SortOrder = Enum.SortOrder.LayoutOrder
    UIGrid2.Parent = DropdownList
    
    local currentValue = default
    
    for _, option in ipairs(options) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, 0, 0, 25)
        OptBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        OptBtn.BorderSizePixel = 0
        OptBtn.Text = option
        OptBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
        OptBtn.Font = Enum.Font.Gotham
        OptBtn.TextSize = 13
        OptBtn.Parent = DropdownList
        
        OptBtn.MouseButton1Click:Connect(function()
            currentValue = option
            DropdownBtn.Text = option
            DropdownFrame.Visible = false
            if callback then callback(option) end
        end)
    end
    
    DropdownBtn.MouseButton1Click:Connect(function()
        DropdownFrame.Visible = not DropdownFrame.Visible
    end)
    
    table.insert(parent.Elements, {Type = "Dropdown", Frame = Frame, Value = currentValue})
    return {Value = currentValue, SetValue = function(v) 
        currentValue = v
        DropdownBtn.Text = v
    end}
end

-- // Actual UI Implementation
local MainWindow = Library:CreateWindow("Adia Cheat", UDim2.new(0, 500, 0, 600))

-- // AIMBOT Tab
local AimbotTab = Library:CreateTab(MainWindow, "Aimbot", "🎯")

-- // Aimbot Toggles
local aimbotToggle = Library:CreateToggle(AimbotTab, "Aimbot Enabled", true, function(state)
    Environment.Settings.Enabled = state
end)

local teamCheck = Library:CreateToggle(AimbotTab, "Team Check", false, function(state)
    Environment.Settings.TeamCheck = state
end)

local wallCheck = Library:CreateToggle(AimbotTab, "Wall Check", false, function(state)
    Environment.Settings.WallCheck = state
end)

local thirdPerson = Library:CreateToggle(AimbotTab, "Third Person Mode", false, function(state)
    Environment.Settings.ThirdPerson = state
end)

-- // Aimbot Sliders
local fovSlider = Library:CreateSlider(AimbotTab, "FOV Amount", 10, 360, 90, function(value)
    Environment.FOVSettings.Amount = value
end)

local sensitivitySlider = Library:CreateSlider(AimbotTab, "Sensitivity", 0, 2, 0.5, function(value)
    Environment.Settings.Sensitivity = value
end)

local tpSensitivity = Library:CreateSlider(AimbotTab, "TP Sensitivity", 0.1, 5, 3, function(value)
    Environment.Settings.ThirdPersonSensitivity = value
end)

-- // Aimbot Dropdowns
local lockPartDropdown = Library:CreateDropdown(AimbotTab, "Lock Part", 
    {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"}, "Head", function(value)
    Environment.Settings.LockPart = value
end)

local triggerDropdown = Library:CreateDropdown(AimbotTab, "Trigger Key",
    {"MouseButton1", "MouseButton2", "Q", "E", "F", "G"}, "MouseButton2", function(value)
    Environment.Settings.TriggerKey = value
end)

-- // SPINBOT Tab
local SpinbotTab = Library:CreateTab(MainWindow, "Spinbot", "🔄")

local spinbotToggle = Library:CreateToggle(SpinbotTab, "Spinbot Enabled", true, function(state)
    Environment.SpinbotEnabled = state
end)

local spinSpeedSlider = Library:CreateSlider(SpinbotTab, "Spin Speed", 1, 200, 40, function(value)
    Environment.SpinSpeed = value
end)

local spinDirection = Library:CreateDropdown(SpinbotTab, "Direction",
    {"Right", "Left"}, "Right", function(value)
    Environment.SpinDirection = value == "Right" and 1 or -1
end)

-- // ESP Tab
local ESPTab = Library:CreateTab(MainWindow, "ESP", "👁️")

local espToggle = Library:CreateToggle(ESPTab, "ESP Enabled", true, function(state)
    Environment.ESPEnabled = state
end)

local boxESP = Library:CreateToggle(ESPTab, "Box ESP", true)
local skeletonESP = Library:CreateToggle(ESPTab, "Skeleton ESP", true)
local healthBar = Library:CreateToggle(ESPTab, "Health Bar", true)
local nameESP = Library:CreateToggle(ESPTab, "Name ESP", true)

-- // MISC Tab
local MISCTab = Library:CreateTab(MainWindow, "Misc", "⚙️")

local bhopToggle = Library:CreateToggle(MISCTab, "Bunny Hop", true)
local autoStrafe = Library:CreateToggle(MISCTab, "Auto Strafe", true)

-- // Spinbot Logic Integration
local spinSpeed = 40
local angle = 0
local spinEnabled = true
local spinDirection = 1

-- Override spinbot to use UI settings
local originalSpin = spinbotToggle
spinbotToggle.MouseButton1Click:Connect(function()
    spinEnabled = not spinEnabled
end)

-- // Main Loop with UI Integration
RunService.RenderStepped:Connect(function()
    -- Update status bar
    MainWindow.StatusText.Text = "● Active  |  FPS: " .. math.floor(1 / RunService.RenderStepped:Wait()) .. "  |  Players: " .. #Players:GetPlayers()
    
    -- Spinbot Logic
    if spinEnabled and LocalPlayer.Character then
        local char = LocalPlayer.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        if root and hum then
            if hum.AutoRotate then hum.AutoRotate = false end
            angle = (angle + spinSpeed * spinDirection) % 360
            root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(angle), 0)
        end
    end
    
    -- Update FOV Circle
    if Environment.FOVSettings.Enabled and Environment.Settings.Enabled then
        Environment.FOVCircle.Position = Vector2.new(
            UserInputService:GetMouseLocation().X,
            UserInputService:GetMouseLocation().Y
        )
    end
end)

-- // Keybind to toggle menu (Insert key)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        MainWindow.MainFrame.Visible = not MainWindow.MainFrame.Visible
    end
end)

-- // Load ESP if needed
local espLoaded = false
local function LoadESP()
    if not espLoaded then
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/wa0101/Roblox-ESP/refs/heads/main/esp.lua", true))()
            espLoaded = true
        end)
    end
end

-- // Initialize
LoadESP()
