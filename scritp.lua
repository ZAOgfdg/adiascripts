-- // AIDA CHEAT v4.0 - Premium Research Edition
-- // Fully Featured UI with Advanced Systems

local function AidaCheat()
    -- //━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    -- // SERVICES & CACHE
    -- //━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    
    -- //━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // // STATE MANAGEMENT
    // //━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    local State = {
        SystemEnabled = true,
        MenuVisible = true,
        
        -- // Aimbot
        Aimbot = {
            Enabled = true,
            TeamCheck = false,
            WallCheck = false,
            HitChance = 85,
            FOV = 120,
            Smoothness = 15,
            TargetPart = "Head",
            SilentAim = true,
            AutoFire = true,
            TriggerKey = "MouseButton2"
        },
        
        -- // Spinbot
        Spinbot = {
            Enabled = true,
            Speed = 45,
            Direction = 1, -- 1 = Right, -1 = Left
            Jitter = false,
            JitterAmount = 5,
            FakeLag = false,
            FakeLagAmount = 100
        },
        
        -- // ESP
        ESP = {
            Enabled = true,
            Box = true,
            Skeleton = true,
            HealthBar = true,
            Name = true,
            Distance = true,
            Weapon = true,
            HeadDot = true,
            Chams = false,
            Glow = false
        },
        
        -- // Movement
        Movement = {
            BunnyHop = true,
            AutoStrafe = true,
            AutoJump = false,
            EdgeBug = false,
            PixelSurf = false
        },
        
        -- // Visuals
        Visuals = {
            NoRecoil = true,
            NoSpread = false,
            FullBright = false,
            NoFog = false,
            Zoom = false,
            ZoomAmount = 2
        },
        
        -- // Misc
        Misc = {
            AntiAim = false,
            AimSway = false,
            Triggerbot = false,
            AutoPistol = true,
            AutoReload = true
        }
    }
    
    -- //━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // // UI CONSTRUCTION
    // //━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    local function BuildUI()
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "AidaCheat"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        
        -- // Main Window
        local Main = Instance.new("Frame")
        Main.Size = UDim2.new(0, 550, 0, 650)
        Main.Position = UDim2.new(0.5, -275, 0.5, -325)
        Main.BackgroundColor3 = Color3.fromRGB(10, 12, 22)
        Main.BackgroundTransparency = 0.05
        Main.BorderSizePixel = 1
        Main.BorderColor3 = Color3.fromRGB(35, 45, 75)
        Main.ClipsDescendants = true
        Main.Parent = ScreenGui
        
        -- // Glow Effect
        local Glow = Instance.new("ImageLabel")
        Glow.Size = UDim2.new(1, 20, 1, 20)
        Glow.Position = UDim2.new(0, -10, 0, -10)
        Glow.BackgroundTransparency = 1
        Glow.Image = "rbxassetid://5028857070"
        Glow.ImageColor3 = Color3.fromRGB(100, 150, 255)
        Glow.ImageTransparency = 0.7
        Glow.Parent = Main
        
        -- // Header
        local Header = Instance.new("Frame")
        Header.Size = UDim2.new(1, 0, 0, 55)
        Header.BackgroundColor3 = Color3.fromRGB(15, 18, 35)
        Header.BorderSizePixel = 0
        Header.Parent = Main
        
        -- // Logo
        local Logo = Instance.new("TextLabel")
        Logo.Size = UDim2.new(1, -80, 1, 0)
        Logo.Position = UDim2.new(0, 15, 0, 0)
        Logo.BackgroundTransparency = 1
        Logo.Text = "✦ AIDA CHEAT v4.0"
        Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
        Logo.TextXAlignment = Enum.TextXAlignment.Left
        Logo.Font = Enum.Font.GothamBold
        Logo.TextSize = 22
        Logo.Parent = Header
        
        -- // Status indicator
        local StatusDot = Instance.new("Frame")
        StatusDot.Size = UDim2.new(0, 10, 0, 10)
        StatusDot.Position = UDim2.new(1, -45, 0.5, -5)
        StatusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        StatusDot.BorderSizePixel = 0
        StatusDot.Parent = Header
        
        -- // Status Label
        local StatusLabel = Instance.new("TextLabel")
        StatusLabel.Size = UDim2.new(0, 40, 1, 0)
        StatusLabel.Position = UDim2.new(1, -30, 0, 0)
        StatusLabel.BackgroundTransparency = 1
        StatusLabel.Text = "ON"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        StatusLabel.Font = Enum.Font.GothamBold
        StatusLabel.TextSize = 14
        StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
        StatusLabel.Parent = Header
        
        -- // Close Button
        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0, 35, 0, 35)
        CloseBtn.Position = UDim2.new(1, -42, 0, 10)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        CloseBtn.BackgroundTransparency = 0.7
        CloseBtn.Text = "✕"
        CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseBtn.Font = Enum.Font.Gotham
        CloseBtn.TextSize = 18
        CloseBtn.Parent = Header
        
        -- // Drag System
        local Dragging = false
        local DragStart, StartPos
        
        Header.InputBegan:Connect(function(I)
            if I.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                DragStart = I.Position
                StartPos = Main.Position
                I.Changed:Connect(function()
                    if I.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                    end
                end)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(I)
            if Dragging and I.UserInputType == Enum.UserInputType.MouseMovement then
                local Delta = I.Position - DragStart
                Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X,
                                        StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
            end
        end)
        
        CloseBtn.MouseButton1Click:Connect(function()
            Main.Visible = not Main.Visible
            State.MenuVisible = Main.Visible
        end)
        
        -- // Tab Navigation
        local TabBar = Instance.new("Frame")
        TabBar.Size = UDim2.new(1, 0, 0, 40)
        TabBar.Position = UDim2.new(0, 0, 0, 55)
        TabBar.BackgroundColor3 = Color3.fromRGB(12, 15, 30)
        TabBar.BorderSizePixel = 0
        TabBar.Parent = Main
        
        -- // Content Container
        local Content = Instance.new("Frame")
        Content.Size = UDim2.new(1, -20, 1, -120)
        Content.Position = UDim2.new(0, 10, 0, 100)
        Content.BackgroundTransparency = 1
        Content.Parent = Main
        
        -- // Footer
        local Footer = Instance.new("Frame")
        Footer.Size = UDim2.new(1, 0, 0, 25)
        Footer.Position = UDim2.new(0, 0, 1, -25)
        Footer.BackgroundColor3 = Color3.fromRGB(8, 10, 20)
        Footer.BorderSizePixel = 1
        Footer.BorderColor3 = Color3.fromRGB(25, 30, 50)
        Footer.Parent = Main
        
        local FooterText = Instance.new("TextLabel")
        FooterText.Size = UDim2.new(1, -20, 1, 0)
        FooterText.Position = UDim2.new(0, 10, 0, 0)
        FooterText.BackgroundTransparency = 1
        FooterText.Text = "🔒 AIDA | Premium Research Build | FPS: 0 | Players: 0"
        FooterText.TextColor3 = Color3.fromRGB(100, 150, 255)
        FooterText.TextXAlignment = Enum.TextXAlignment.Left
        FooterText.Font = Enum.Font.Gotham
        FooterText.TextSize = 11
        FooterText.Parent = Footer
        
        -- // UI Element Builders
        local function CreateToggle(Parent, Label, Default, Callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 34)
            Frame.BackgroundColor3 = Color3.fromRGB(20, 22, 40)
            Frame.BackgroundTransparency = 0.4
            Frame.BorderSizePixel = 1
            Frame.BorderColor3 = Color3.fromRGB(30, 35, 55)
            Frame.Parent = Parent
            
            local LabelText = Instance.new("TextLabel")
            LabelText.Size = UDim2.new(1, -75, 1, 0)
            LabelText.Position = UDim2.new(0, 12, 0, 0)
            LabelText.BackgroundTransparency = 1
            LabelText.Text = Label
            LabelText.TextColor3 = Color3.fromRGB(200, 210, 230)
            LabelText.TextXAlignment = Enum.TextXAlignment.Left
            LabelText.Font = Enum.Font.Gotham
            LabelText.TextSize = 13
            LabelText.Parent = Frame
            
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(0, 50, 0, 26)
            Button.Position = UDim2.new(1, -60, 0.5, -13)
            Button.BackgroundColor3 = Default and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(50, 50, 65)
            Button.BorderSizePixel = 0
            Button.Text = Default and "ON" or "OFF"
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.Font = Enum.Font.GothamBold
            Button.TextSize = 11
            Button.Parent = Frame
            
            local Toggled = Default
            Button.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Button.BackgroundColor3 = Toggled and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(50, 50, 65)
                Button.Text = Toggled and "ON" or "OFF"
                if Callback then Callback(Toggled) end
            end)
            
            return {State = Toggled, Button = Button}
        end
        
        local function CreateSlider(Parent, Label, Min, Max, Default, Callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 50)
            Frame.BackgroundColor3 = Color3.fromRGB(20, 22, 40)
            Frame.BackgroundTransparency = 0.4
            Frame.BorderSizePixel = 1
            Frame.BorderColor3 = Color3.fromRGB(30, 35, 55)
            Frame.Parent = Parent
            
            local LabelText = Instance.new("TextLabel")
            LabelText.Size = UDim2.new(1, -100, 0, 18)
            LabelText.Position = UDim2.new(0, 12, 0, 4)
            LabelText.BackgroundTransparency = 1
            LabelText.Text = Label
            LabelText.TextColor3 = Color3.fromRGB(200, 210, 230)
            LabelText.TextXAlignment = Enum.TextXAlignment.Left
            LabelText.Font = Enum.Font.Gotham
            LabelText.TextSize = 13
            LabelText.Parent = Frame
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 45, 0, 18)
            ValueLabel.Position = UDim2.new(1, -55, 0, 4)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(Default)
            ValueLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.TextSize = 14
            ValueLabel.Parent = Frame
            
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Size = UDim2.new(1, -24, 0, 4)
            SliderTrack.Position = UDim2.new(0, 12, 0, 32)
            SliderTrack.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
            SliderTrack.BorderSizePixel = 0
            SliderTrack.Parent = Frame
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderTrack
            
            local DragButton = Instance.new("TextButton")
            DragButton.Size = UDim2.new(0, 16, 0, 16)
            DragButton.Position = UDim2.new((Default - Min) / (Max - Min), -8, 0.5, -8)
            DragButton.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
            DragButton.BorderSizePixel = 0
            DragButton.Text = ""
            DragButton.Parent = SliderTrack
            
            local Value = Default
            local Dragging = false
            
            DragButton.MouseButton1Down:Connect(function() Dragging = true end)
            UserInputService.InputEnded:Connect(function(I)
                if I.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(I)
                if Dragging and I.UserInputType == Enum.UserInputType.MouseMovement then
                    local RelativeX = I.Position.X - SliderTrack.AbsolutePosition.X
                    local Percent = math.clamp(RelativeX / SliderTrack.AbsoluteSize.X, 0, 1)
                    Value = Min + (Max - Min) * Percent
                    Value = math.round(Value)
                    
                    SliderFill.Size = UDim2.new(Percent, 0, 1, 0)
                    DragButton.Position = UDim2.new(Percent, -8, 0.5, -8)
                    ValueLabel.Text = tostring(Value)
                    
                    if Callback then Callback(Value) end
                end
            end)
            
            return {Value = Value, SetValue = function(V)
                V = math.clamp(V, Min, Max)
                Value = V
                local P = (V - Min) / (Max - Min)
                SliderFill.Size = UDim2.new(P, 0, 1, 0)
                DragButton.Position = UDim2.new(P, -8, 0.5, -8)
                ValueLabel.Text = tostring(V)
            end}
        end
        
        local function CreateDropdown(Parent, Label, Options, Default, Callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 38)
            Frame.BackgroundColor3 = Color3.fromRGB(20, 22, 40)
            Frame.BackgroundTransparency = 0.4
            Frame.BorderSizePixel = 1
            Frame.BorderColor3 = Color3.fromRGB(30, 35, 55)
            Frame.Parent = Parent
            
            local LabelText = Instance.new("TextLabel")
            LabelText.Size = UDim2.new(0.4, -10, 1, 0)
            LabelText.Position = UDim2.new(0, 12, 0, 0)
            LabelText.BackgroundTransparency = 1
            LabelText.Text = Label
            LabelText.TextColor3 = Color3.fromRGB(200, 210, 230)
            LabelText.TextXAlignment = Enum.TextXAlignment.Left
            LabelText.Font = Enum.Font.Gotham
            LabelText.TextSize = 13
            LabelText.Parent = Frame
            
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(0.6, -20, 1, -8)
            Button.Position = UDim2.new(0.4, 0, 0, 4)
            Button.BackgroundColor3 = Color3.fromRGB(35, 38, 55)
            Button.BorderSizePixel = 1
            Button.BorderColor3 = Color3.fromRGB(45, 50, 65)
            Button.Text = Default
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 12
            Button.Parent = Frame
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(0.6, -20, 0, 90)
            DropdownFrame.Position = UDim2.new(0.4, 0, 1, 4)
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 28, 45)
            DropdownFrame.BorderSizePixel = 1
            DropdownFrame.BorderColor3 = Color3.fromRGB(40, 45, 60)
            DropdownFrame.Visible = false
            DropdownFrame.ZIndex = 10
            DropdownFrame.Parent = Frame
            
            local List = Instance.new("ScrollingFrame")
            List.Size = UDim2.new(1, 0, 1, 0)
            List.BackgroundTransparency = 1
            List.ScrollBarThickness = 3
            List.Parent = DropdownFrame
            
            local Layout = Instance.new("UIGridLayout")
            Layout.CellSize = UDim2.new(1, 0, 0, 24)
            Layout.CellPadding = UDim2.new(0, 0, 0, 1)
            Layout.FillDirection = Enum.FillDirection.Vertical
            Layout.SortOrder = Enum.SortOrder.LayoutOrder
            Layout.Parent = List
            
            local Current = Default
            
            for _, Opt in ipairs(Options) do
                local OptButton = Instance.new("TextButton")
                OptButton.Size = UDim2.new(1, 0, 0, 24)
                OptButton.BackgroundColor3 = Color3.fromRGB(35, 38, 55)
                OptButton.BorderSizePixel = 0
                OptButton.Text = Opt
                OptButton.TextColor3 = Color3.fromRGB(190, 200, 215)
                OptButton.Font = Enum.Font.Gotham
                OptButton.TextSize = 12
                OptButton.Parent = List
                
                OptButton.MouseButton1Click:Connect(function()
                    Current = Opt
                    Button.Text = Opt
                    DropdownFrame.Visible = false
                    if Callback then Callback(Opt) end
                end)
            end
            
            Button.MouseButton1Click:Connect(function()
                DropdownFrame.Visible = not DropdownFrame.Visible
            end)
            
            return {Value = Current, SetValue = function(V)
                Current = V
                Button.Text = V
            end}
        end
        
        local function CreateSection(Parent, Title)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 28)
            Frame.BackgroundTransparency = 1
            Frame.Parent = Parent
            
            local Line = Instance.new("Frame")
            Line.Size = UDim2.new(1, -20, 0, 1)
            Line.Position = UDim2.new(0, 10, 0.5, 0)
            Line.BackgroundColor3 = Color3.fromRGB(50, 60, 90)
            Line.BorderSizePixel = 0
            Line.Parent = Frame
            
            local Text = Instance.new("TextLabel")
            Text.Size = UDim2.new(0, 120, 1, 0)
            Text.Position = UDim2.new(0.5, -60, 0, 0)
            Text.BackgroundTransparency = 1
            Text.Text = Title
            Text.TextColor3 = Color3.fromRGB(150, 180, 255)
            Text.Font = Enum.Font.GothamBold
            Text.TextSize = 11
            Text.TextXAlignment = Enum.TextXAlignment.Center
            Text.Parent = Frame
            
            return Frame
        end
        
        -- //━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // // TABS CREATION
        // //━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        local Tabs = {}
        local CurrentTab = nil
        
        local function CreateTab(Name, Icon)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(0, 90, 1, 0)
            Button.BackgroundTransparency = 1
            Button.Text = Icon .. " " .. Name
            Button.TextColor3 = Color3.fromRGB(150, 160, 190)
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 12
            Button.Parent = TabBar
            
            local Container = Instance.new("ScrollingFrame")
            Container.Size = UDim2.new(1, 0, 1, 0)
            Container.BackgroundTransparency = 1
            Container.ScrollBarThickness = 4
            Container.Visible = false
            Container.Parent = Content
            
            local Grid = Instance.new("UIGridLayout")
            Grid.CellSize = UDim2.new(1, -10, 0, 36)
            Grid.CellPadding = UDim2.new(0, 5, 0, 4)
            Grid.FillDirection = Enum.FillDirection.Vertical
            Grid.SortOrder = Enum.SortOrder.LayoutOrder
            Grid.Parent = Container
            
            local Tab = {Button = Button, Container = Container, Grid = Grid, Elements = {}}
            
            Button.MouseButton1Click:Connect(function()
                for _, T in pairs(Tabs) do
                    T.Container.Visible = false
                    T.Button.TextColor3 = Color3.fromRGB(150, 160, 190)
                end
                Container.Visible = true
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                CurrentTab = Tab
            end)
            
            table.insert(Tabs, Tab)
            return Tab
        end
        
        -- // Build Tabs
        local AimTab = CreateTab("Aimbot", "🎯")
        local SpinTab = CreateTab("Spinbot", "🔄")
        local ESPTab = CreateTab("ESP", "👁️")
        local MoveTab = CreateTab("Movement", "🏃")
        local VisualTab = CreateTab("Visuals", "✨")
        local MiscTab = CreateTab("Misc", "⚙️")
        
        -- // Set first tab active
        AimTab.Container.Visible = true
        AimTab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        -- //━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        // // POPULATE TABS
        // //━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        
        -- // AIMBOT TAB
        CreateSection(AimTab.Container, "GENERAL")
        CreateToggle(AimTab.Container, "Aimbot Enabled", true, function(S)
            State.Aimbot.Enabled = S
        end)
        CreateToggle(AimTab.Container, "Team Check", false, function(S)
            State.Aimbot.TeamCheck = S
        end)
        CreateToggle(AimTab.Container, "Wall Check", false, function(S)
            State.Aimbot.WallCheck = S
        end)
        CreateToggle(AimTab.Container, "Silent Aim", true, function(S)
            State.Aimbot.SilentAim = S
        end)
        CreateToggle(AimTab.Container, "Auto Fire", true, function(S)
            State.Aimbot.AutoFire = S
        end)
        
        CreateSection(AimTab.Container, "ADVANCED")
        CreateSlider(AimTab.Container, "FOV Range", 10, 360, 120, function(V)
            State.Aimbot.FOV = V
        end)
        CreateSlider(AimTab.Container, "Smoothness", 1, 50, 15, function(V)
            State.Aimbot.Smoothness = V
        end)
        CreateSlider(AimTab.Container, "Hit Chance %", 1, 100, 85, function(V)
            State.Aimbot.HitChance = V
        end)
        
        CreateDropdown(AimTab.Container, "Target Part", {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart"}, "Head", function(V)
            State.Aimbot.TargetPart = V
        end)
        CreateDropdown(AimTab.Container, "Trigger Key", {"MouseButton1", "MouseButton2", "Q", "E", "F", "G", "LeftControl"}, "MouseButton2", function(V)
            State.Aimbot.TriggerKey = V
        end)
        
        -- // SPINBOT TAB
        CreateSection(SpinTab.Container, "CONTROLS")
        CreateToggle(SpinTab.Container, "Spinbot Enabled", true, function(S)
            State.Spinbot.Enabled = S
        end)
        CreateSlider(SpinTab.Container, "Spin Speed", 1, 200, 45, function(V)
            State.Spinbot.Speed = V
        end)
        CreateDropdown(SpinTab.Container, "Direction", {"Right", "Left"}, "Right", function(V)
            State.Spinbot.Direction = V == "Right" and 1 or -1
        end)
        
        CreateSection(SpinTab.Container, "ADVANCED")
        CreateToggle(SpinTab.Container, "Jitter Mode", false, function(S)
            State.Spinbot.Jitter = S
        end)
        CreateSlider(SpinTab.Container, "Jitter Amount", 1, 20, 5, function(V)
            State.Spinbot.JitterAmount = V
        end)
        CreateToggle(SpinTab.Container, "Fake Lag", false, function(S)
            State.Spinbot.FakeLag = S
        end)
        CreateSlider(SpinTab.Container, "Fake Lag (ms)", 20, 200, 100, function(V)
            State.Spinbot.FakeLagAmount = V
        end)
        
        -- // ESP TAB
        CreateSection(ESPTab.Container, "MAIN")
        CreateToggle(ESPTab.Container, "ESP Enabled", true, function(S)
            State.ESP.Enabled = S
        end)
        CreateToggle(ESPTab.Container, "Box ESP", true, function(S)
            State.ESP.Box = S
        end)
        CreateToggle(ESPTab.Container, "Skeleton", true, function(S)
            State.ESP.Skeleton = S
        end)
        CreateToggle(ESPTab.Container, "Health Bar", true, function(S)
            State.ESP.HealthBar = S
        end)
        
        CreateSection(ESPTab.Container, "DETAILS")
        CreateToggle(ESPTab.Container, "Name Tags", true, function(S)
            State.ESP.Name = S
        end)
        CreateToggle(ESPTab.Container, "Distance", true, function(S)
            State.ESP.Distance = S
        end)
        CreateToggle(ESPTab.Container, "Weapon", true, function(S)
            State.ESP.Weapon = S
        end)
        CreateToggle(ESPTab.Container, "Head Dot", true, function(S)
            State.ESP.HeadDot = S
        end)
        
        CreateSection(ESPTab.Container, "VISUAL")
        CreateToggle(ESPTab.Container, "Chams (X-Ray)", false, function(S)
            State.ESP.Chams = S
        end)
        CreateToggle(ESPTab.Container, "Glow Effect", false, function(S)
            State.ESP.Glow = S
        end)
        
        -- // MOVEMENT TAB
        CreateSection(MoveTab.Container, "MOVEMENT")
        CreateToggle(MoveTab.Container, "Bunny Hop", true, function(S)
            State.Movement.BunnyHop = S
        end)
        CreateToggle(MoveTab.Container, "Auto Strafe", true, function(S)
            State.Movement.AutoStrafe = S
        end)
        CreateToggle(MoveTab.Container, "Auto Jump", false, function(S)
            State.Movement.AutoJump = S
        end)
        
        CreateSection(MoveTab.Container, "ADVANCED")
        CreateToggle(MoveTab.Container, "Edge Bug", false, function(S)
            State.Movement.EdgeBug = S
        end)
        CreateToggle(MoveTab.Container, "Pixel Surf", false, function(S)
            State.Movement.PixelSurf = S
        end)
        CreateSlider(MoveTab.Container, "Edge Bug Radius", 10, 128, 64)
        
        -- // VISUALS TAB
        CreateSection(VisualTab.Container, "VISUAL MODS")
        CreateToggle(VisualTab.Container, "No Recoil", true, function(S)
            State.Visuals.NoRecoil = S
        end)
        CreateToggle(VisualTab.Container, "No Spread", false, function(S)
            State.Visuals.NoSpread = S
        end)
        CreateToggle(VisualTab.Container, "Full Bright", false, function(S)
            State.Visuals.FullBright = S
        end)
        CreateToggle(VisualTab.Container, "No Fog", false, function(S)
            State.Visuals.NoFog = S
        end)
        
        CreateSection(VisualTab.Container, "CAMERA")
        CreateToggle(VisualTab.Container, "Zoom Mode", false, function(S)
            State.Visuals.Zoom = S
        end)
        CreateSlider(VisualTab.Container, "Zoom Amount", 1, 5, 2, function(V)
            State.Visuals.ZoomAmount = V
        end)
        
        -- // MISC TAB
        CreateSection(MiscTab.Container, "MISC")
        CreateToggle(MiscTab.Container, "Anti-Aim", false, function(S)
            State.Misc.AntiAim = S
        end)
        CreateToggle(MiscTab.Container, "Aim Sway", false, function(S)
            State.Misc.AimSway = S
        end)
        CreateToggle(MiscTab.Container, "Triggerbot", false, function(S)
            State.Misc.Triggerbot = S
        end)
        CreateToggle(MiscTab.Container, "Auto Pistol", true, function(S)
            State.Misc.AutoPistol = S
        end)
        CreateToggle(MiscTab.Container, "Auto Reload", true, function(S)
            State.Misc.AutoReload = S
        end)
        
        return {
            Main = Main,
            FooterText = FooterText,
            StatusDot = StatusDot,
            StatusLabel = StatusLabel
        }
    end
    
    -- //━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // // CORE SYSTEMS
    // //━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    local UI = BuildUI()
    local SpinAngle = 0
    local Connections = {}
    
    -- // Aimbot System
    local function GetClosestPlayer(FOV)
        local Closest = nil
        local ClosestDist = FOV or State.Aimbot.FOV
        
        for _, Player in ipairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character then
                local Character = Player.Character
                local TargetPart = Character:FindFirstChild(State.Aimbot.TargetPart)
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                
                if TargetPart and Humanoid and Humanoid.Health > 0 then
                    if State.Aimbot.TeamCheck and Player.Team == LocalPlayer.Team then
                        continue
                    end
                    
                    local Vector, OnScreen = Camera:WorldToViewportPoint(TargetPart.Position)
                    local MousePos = UserInputService:GetMouseLocation()
                    local Distance = (Vector2.new(MousePos.X, MousePos.Y) - Vector2.new(Vector.X, Vector.Y)).Magnitude
                    
                    if Distance < ClosestDist and OnScreen then
                        ClosestDist = Distance
                        Closest = Player
                    end
                end
            end
        end
        
        return Closest
    end
    
    -- // Main Loop
    Connections.MainLoop = RunService.RenderStepped:Connect(function()
        local PlayerCount = #Players:GetPlayers()
        UI.FooterText.Text = "🔒 AIDA | Premium Research Build | FPS: " .. math.floor(1 / RunService.RenderStepped:Wait()) ..
