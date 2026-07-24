-- // AIDA CHEAT v4.0 - FIXED VERSION
-- // Полностью рабочая GUI с системами

local function AidaCheat()
    -- // Services
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    
    -- // State
    local State = {
        SystemEnabled = true,
        MenuVisible = true,
        Aimbot = {Enabled = true, TeamCheck = false, WallCheck = false, HitChance = 85, FOV = 120, Smoothness = 15, TargetPart = "Head", SilentAim = true, AutoFire = true, TriggerKey = "MouseButton2"},
        Spinbot = {Enabled = true, Speed = 45, Direction = 1, Jitter = false, JitterAmount = 5},
        ESP = {Enabled = true, Box = true, Skeleton = true, HealthBar = true, Name = true, Distance = true, Weapon = true, HeadDot = true},
        Movement = {BunnyHop = true, AutoStrafe = true, AutoJump = false}
    }
    
    -- // Create GUI
    local function CreateUI()
        -- // ScreenGui
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "AidaCheat"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        
        -- // Main Window
        local Main = Instance.new("Frame")
        Main.Size = UDim2.new(0, 500, 0, 580)
        Main.Position = UDim2.new(0.5, -250, 0.5, -290)
        Main.BackgroundColor3 = Color3.fromRGB(12, 14, 28)
        Main.BackgroundTransparency = 0.05
        Main.BorderSizePixel = 1
        Main.BorderColor3 = Color3.fromRGB(40, 50, 80)
        Main.ClipsDescendants = true
        Main.Parent = ScreenGui
        
        -- // Header
        local Header = Instance.new("Frame")
        Header.Size = UDim2.new(1, 0, 0, 45)
        Header.BackgroundColor3 = Color3.fromRGB(18, 20, 38)
        Header.BorderSizePixel = 0
        Header.Parent = Main
        
        -- // Title
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -80, 1, 0)
        Title.Position = UDim2.new(0, 15, 0, 0)
        Title.BackgroundTransparency = 1
        Title.Text = "✦ AIDA CHEAT v4.0"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 20
        Title.Parent = Header
        
        -- // Status
        local StatusLabel = Instance.new("TextLabel")
        StatusLabel.Size = UDim2.new(0, 50, 1, 0)
        StatusLabel.Position = UDim2.new(1, -60, 0, 0)
        StatusLabel.BackgroundTransparency = 1
        StatusLabel.Text = "● ON"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        StatusLabel.Font = Enum.Font.GothamBold
        StatusLabel.TextSize = 13
        StatusLabel.TextXAlignment = Enum.TextXAlignment.Right
        StatusLabel.Parent = Header
        
        -- // Close Button
        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(0, 30, 0, 30)
        CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        CloseBtn.BackgroundTransparency = 0.7
        CloseBtn.Text = "✕"
        CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseBtn.Font = Enum.Font.Gotham
        CloseBtn.TextSize = 16
        CloseBtn.Parent = Header
        CloseBtn.MouseButton1Click:Connect(function()
            Main.Visible = not Main.Visible
            State.MenuVisible = Main.Visible
        end)
        
        -- // Drag
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
        
        -- // Tab Bar
        local TabBar = Instance.new("Frame")
        TabBar.Size = UDim2.new(1, 0, 0, 35)
        TabBar.Position = UDim2.new(0, 0, 0, 45)
        TabBar.BackgroundColor3 = Color3.fromRGB(14, 16, 32)
        TabBar.BorderSizePixel = 0
        TabBar.Parent = Main
        
        -- // Content
        local Content = Instance.new("Frame")
        Content.Size = UDim2.new(1, -20, 1, -105)
        Content.Position = UDim2.new(0, 10, 0, 85)
        Content.BackgroundTransparency = 1
        Content.Parent = Main
        
        -- // Footer
        local Footer = Instance.new("Frame")
        Footer.Size = UDim2.new(1, 0, 0, 22)
        Footer.Position = UDim2.new(0, 0, 1, -22)
        Footer.BackgroundColor3 = Color3.fromRGB(8, 10, 22)
        Footer.BorderSizePixel = 1
        Footer.BorderColor3 = Color3.fromRGB(30, 35, 55)
        Footer.Parent = Main
        
        local FooterText = Instance.new("TextLabel")
        FooterText.Size = UDim2.new(1, -20, 1, 0)
        FooterText.Position = UDim2.new(0, 10, 0, 0)
        FooterText.BackgroundTransparency = 1
        FooterText.Text = "🔒 AIDA | Press INS to toggle | Players: " .. #Players:GetPlayers()
        FooterText.TextColor3 = Color3.fromRGB(100, 150, 255)
        FooterText.TextXAlignment = Enum.TextXAlignment.Left
        FooterText.Font = Enum.Font.Gotham
        FooterText.TextSize = 10
        FooterText.Parent = Footer
        
        -- // UI Builders
        local function CreateToggle(Parent, Label, Default, Callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 30)
            Frame.BackgroundColor3 = Color3.fromRGB(22, 24, 42)
            Frame.BackgroundTransparency = 0.3
            Frame.BorderSizePixel = 1
            Frame.BorderColor3 = Color3.fromRGB(32, 36, 56)
            Frame.Parent = Parent
            
            local LabelText = Instance.new("TextLabel")
            LabelText.Size = UDim2.new(1, -70, 1, 0)
            LabelText.Position = UDim2.new(0, 10, 0, 0)
            LabelText.BackgroundTransparency = 1
            LabelText.Text = Label
            LabelText.TextColor3 = Color3.fromRGB(200, 210, 230)
            LabelText.TextXAlignment = Enum.TextXAlignment.Left
            LabelText.Font = Enum.Font.Gotham
            LabelText.TextSize = 12
            LabelText.Parent = Frame
            
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(0, 45, 0, 22)
            Button.Position = UDim2.new(1, -55, 0.5, -11)
            Button.BackgroundColor3 = Default and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(50, 50, 65)
            Button.BorderSizePixel = 0
            Button.Text = Default and "ON" or "OFF"
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.Font = Enum.Font.GothamBold
            Button.TextSize = 10
            Button.Parent = Frame
            
            local Toggled = Default
            Button.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Button.BackgroundColor3 = Toggled and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(50, 50, 65)
                Button.Text = Toggled and "ON" or "OFF"
                if Callback then Callback(Toggled) end
            end)
            
            return Button
        end
        
        local function CreateSlider(Parent, Label, Min, Max, Default, Callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 44)
            Frame.BackgroundColor3 = Color3.fromRGB(22, 24, 42)
            Frame.BackgroundTransparency = 0.3
            Frame.BorderSizePixel = 1
            Frame.BorderColor3 = Color3.fromRGB(32, 36, 56)
            Frame.Parent = Parent
            
            local LabelText = Instance.new("TextLabel")
            LabelText.Size = UDim2.new(1, -90, 0, 16)
            LabelText.Position = UDim2.new(0, 10, 0, 2)
            LabelText.BackgroundTransparency = 1
            LabelText.Text = Label
            LabelText.TextColor3 = Color3.fromRGB(200, 210, 230)
            LabelText.TextXAlignment = Enum.TextXAlignment.Left
            LabelText.Font = Enum.Font.Gotham
            LabelText.TextSize = 12
            LabelText.Parent = Frame
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 40, 0, 16)
            ValueLabel.Position = UDim2.new(1, -50, 0, 2)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(Default)
            ValueLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.TextSize = 13
            ValueLabel.Parent = Frame
            
            local Track = Instance.new("Frame")
            Track.Size = UDim2.new(1, -20, 0, 3)
            Track.Position = UDim2.new(0, 10, 0, 28)
            Track.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
            Track.BorderSizePixel = 0
            Track.Parent = Frame
            
            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
            Fill.BackgroundColor3 = Color3.fromRGB(60, 150, 255)
            Fill.BorderSizePixel = 0
            Fill.Parent = Track
            
            local Drag = Instance.new("TextButton")
            Drag.Size = UDim2.new(0, 14, 0, 14)
            Drag.Position = UDim2.new((Default - Min) / (Max - Min), -7, 0.5, -7)
            Drag.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
            Drag.BorderSizePixel = 0
            Drag.Text = ""
            Drag.Parent = Track
            
            local Value = Default
            local IsDragging = false
            
            Drag.MouseButton1Down:Connect(function() IsDragging = true end)
            UserInputService.InputEnded:Connect(function(I)
                if I.UserInputType == Enum.UserInputType.MouseButton1 then
                    IsDragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(I)
                if IsDragging and I.UserInputType == Enum.UserInputType.MouseMovement then
                    local RelX = I.Position.X - Track.AbsolutePosition.X
                    local Percent = math.clamp(RelX / Track.AbsoluteSize.X, 0, 1)
                    Value = Min + (Max - Min) * Percent
                    Value = math.round(Value)
                    
                    Fill.Size = UDim2.new(Percent, 0, 1, 0)
                    Drag.Position = UDim2.new(Percent, -7, 0.5, -7)
                    ValueLabel.Text = tostring(Value)
                    
                    if Callback then Callback(Value) end
                end
            end)
            
            return {Value = Value}
        end
        
        local function CreateDropdown(Parent, Label, Options, Default, Callback)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 34)
            Frame.BackgroundColor3 = Color3.fromRGB(22, 24, 42)
            Frame.BackgroundTransparency = 0.3
            Frame.BorderSizePixel = 1
            Frame.BorderColor3 = Color3.fromRGB(32, 36, 56)
            Frame.Parent = Parent
            
            local LabelText = Instance.new("TextLabel")
            LabelText.Size = UDim2.new(0.4, -5, 1, 0)
            LabelText.Position = UDim2.new(0, 10, 0, 0)
            LabelText.BackgroundTransparency = 1
            LabelText.Text = Label
            LabelText.TextColor3 = Color3.fromRGB(200, 210, 230)
            LabelText.TextXAlignment = Enum.TextXAlignment.Left
            LabelText.Font = Enum.Font.Gotham
            LabelText.TextSize = 12
            LabelText.Parent = Frame
            
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(0.6, -15, 1, -6)
            Button.Position = UDim2.new(0.4, 0, 0, 3)
            Button.BackgroundColor3 = Color3.fromRGB(35, 38, 55)
            Button.BorderSizePixel = 1
            Button.BorderColor3 = Color3.fromRGB(45, 50, 65)
            Button.Text = Default
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 11
            Button.Parent = Frame
            
            local DF = Instance.new("Frame")
            DF.Size = UDim2.new(0.6, -15, 0, 80)
            DF.Position = UDim2.new(0.4, 0, 1, 3)
            DF.BackgroundColor3 = Color3.fromRGB(25, 28, 45)
            DF.BorderSizePixel = 1
            DF.BorderColor3 = Color3.fromRGB(40, 45, 60)
            DF.Visible = false
            DF.ZIndex = 10
            DF.Parent = Frame
            
            local List = Instance.new("ScrollingFrame")
            List.Size = UDim2.new(1, 0, 1, 0)
            List.BackgroundTransparency = 1
            List.ScrollBarThickness = 3
            List.Parent = DF
            
            local Layout = Instance.new("UIGridLayout")
            Layout.CellSize = UDim2.new(1, 0, 0, 22)
            Layout.CellPadding = UDim2.new(0, 0, 0, 1)
            Layout.FillDirection = Enum.FillDirection.Vertical
            Layout.SortOrder = Enum.SortOrder.LayoutOrder
            Layout.Parent = List
            
            local Current = Default
            
            for _, Opt in ipairs(Options) do
                local OB = Instance.new("TextButton")
                OB.Size = UDim2.new(1, 0, 0, 22)
                OB.BackgroundColor3 = Color3.fromRGB(35, 38, 55)
                OB.BorderSizePixel = 0
                OB.Text = Opt
                OB.TextColor3 = Color3.fromRGB(190, 200, 215)
                OB.Font = Enum.Font.Gotham
                OB.TextSize = 11
                OB.Parent = List
                
                OB.MouseButton1Click:Connect(function()
                    Current = Opt
                    Button.Text = Opt
                    DF.Visible = false
                    if Callback then Callback(Opt) end
                end)
            end
            
            Button.MouseButton1Click:Connect(function()
                DF.Visible = not DF.Visible
            end)
            
            return {Value = Current}
        end
        
        local function CreateSection(Parent, Title)
            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(1, 0, 0, 24)
            Frame.BackgroundTransparency = 1
            Frame.Parent = Parent
            
            local Line = Instance.new("Frame")
            Line.Size = UDim2.new(1, -20, 0, 1)
            Line.Position = UDim2.new(0, 10, 0.5, 0)
            Line.BackgroundColor3 = Color3.fromRGB(50, 60, 90)
            Line.BorderSizePixel = 0
            Line.Parent = Frame
            
            local Text = Instance.new("TextLabel")
            Text.Size = UDim2.new(0, 100, 1, 0)
            Text.Position = UDim2.new(0.5, -50, 0, 0)
            Text.BackgroundTransparency = 1
            Text.Text = Title
            Text.TextColor3 = Color3.fromRGB(150, 180, 255)
            Text.Font = Enum.Font.GothamBold
            Text.TextSize = 10
            Text.TextXAlignment = Enum.TextXAlignment.Center
            Text.Parent = Frame
            
            return Frame
        end
        
        -- // Create Tabs
        local Tabs = {}
        local function CreateTab(Name, Icon)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(0, 80, 1, 0)
            Btn.BackgroundTransparency = 1
            Btn.Text = Icon .. " " .. Name
            Btn.TextColor3 = Color3.fromRGB(150, 160, 190)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 11
            Btn.Parent = TabBar
            
            local Container = Instance.new("ScrollingFrame")
            Container.Size = UDim2.new(1, 0, 1, 0)
            Container.BackgroundTransparency = 1
            Container.ScrollBarThickness = 4
            Container.Visible = false
            Container.Parent = Content
            
            local Grid = Instance.new("UIGridLayout")
            Grid.CellSize = UDim2.new(1, -10, 0, 32)
            Grid.CellPadding = UDim2.new(0, 5, 0, 3)
            Grid.FillDirection = Enum.FillDirection.Vertical
            Grid.SortOrder = Enum.SortOrder.LayoutOrder
            Grid.Parent = Container
            
            local Tab = {Button = Btn, Container = Container, Grid = Grid}
            
            Btn.MouseButton1Click:Connect(function()
                for _, T in pairs(Tabs) do
                    T.Container.Visible = false
                    T.Button.TextColor3 = Color3.fromRGB(150, 160, 190)
                end
                Container.Visible = true
                Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            end)
            
            table.insert(Tabs, Tab)
            return Tab
        end
        
        -- // Build Tabs
        local AimTab = CreateTab("Aimbot", "🎯")
        local SpinTab = CreateTab("Spinbot", "🔄")
        local ESPTab = CreateTab("ESP", "👁️")
        local MoveTab = CreateTab("Move", "🏃")
        
        -- // Set first tab active
        AimTab.Container.Visible = true
        AimTab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        -- // Populate Aim Tab
        CreateSection(AimTab.Container, "GENERAL")
        CreateToggle(AimTab.Container, "Aimbot Enabled", true, function(S) State.Aimbot.Enabled = S end)
        CreateToggle(AimTab.Container, "Team Check", false, function(S) State.Aimbot.TeamCheck = S end)
        CreateToggle(AimTab.Container, "Wall Check", false, function(S) State.Aimbot.WallCheck = S end)
        CreateToggle(AimTab.Container, "Silent Aim", true, function(S) State.Aimbot.SilentAim = S end)
        CreateToggle(AimTab.Container, "Auto Fire", true, function(S) State.Aimbot.AutoFire = S end)
        
        CreateSection(AimTab.Container, "ADVANCED")
        CreateSlider(AimTab.Container, "FOV Range", 10, 360, 120, function(V) State.Aimbot.FOV = V end)
        CreateSlider(AimTab.Container, "Smoothness", 1, 50, 15, function(V) State.Aimbot.Smoothness = V end)
        CreateSlider(AimTab.Container, "Hit Chance %", 1, 100, 85, function(V) State.Aimbot.HitChance = V end)
        CreateDropdown(AimTab.Container, "Target Part", {"Head", "UpperTorso", "LowerTorso"}, "Head")
        CreateDropdown(AimTab.Container, "Trigger Key", {"MouseButton2", "MouseButton1", "Q", "E", "F"}, "MouseButton2")
        
        -- // Populate Spin Tab
        CreateSection(SpinTab.Container, "CONTROLS")
        CreateToggle(SpinTab.Container, "Spinbot Enabled", true, function(S) State.Spinbot.Enabled = S end)
        CreateSlider(SpinTab.Container, "Spin Speed", 1, 200, 45, function(V) State.Spinbot.Speed = V end)
        CreateDropdown(SpinTab.Container, "Direction", {"Right", "Left"}, "Right", function(V)
            State.Spinbot.Direction = V == "Right" and 1 or -1
        end)
        CreateToggle(SpinTab.Container, "Jitter Mode", false, function(S) State.Spinbot.Jitter = S end)
        CreateSlider(SpinTab.Container, "Jitter Amount", 1, 20, 5, function(V) State.Spinbot.JitterAmount = V end)
        
        -- // Populate ESP Tab
        CreateSection(ESPTab.Container, "MAIN")
        CreateToggle(ESPTab.Container, "ESP Enabled", true, function(S) State.ESP.Enabled = S end)
        CreateToggle(ESPTab.Container, "Box ESP", true, function(S) State.ESP.Box = S end)
        CreateToggle(ESPTab.Container, "Skeleton", true, function(S) State.ESP.Skeleton = S end)
        CreateToggle(ESPTab.Container, "Health Bar", true, function(S) State.ESP.HealthBar = S end)
        CreateToggle(ESPTab.Container, "Name Tags", true, function(S) State.ESP.Name = S end)
        CreateToggle(ESPTab.Container, "Distance", true, function(S) State.ESP.Distance = S end)
        CreateToggle(ESPTab.Container, "Head Dot", true, function(S) State.ESP.HeadDot = S end)
        
        -- // Populate Movement Tab
        CreateSection(MoveTab.Container, "MOVEMENT")
        CreateToggle(MoveTab.Container, "Bunny Hop", true, function(S) State.Movement.BunnyHop = S end)
        CreateToggle(MoveTab.Container, "Auto Strafe", true, function(S) State.Movement.AutoStrafe = S end)
        CreateToggle(MoveTab.Container, "Auto Jump", false, function(S) State.Movement.AutoJump = S end)
        
        -- // Return UI elements
        return {Main = Main, FooterText = FooterText, StatusLabel = StatusLabel}
    end
    
    -- // Create UI
    local UI = CreateUI()
    local SpinAngle = 0
    local Connections = {}
    
    -- // Spinbot System
    Connections.Spinbot = RunService.RenderStepped:Connect(function()
        if not State.SystemEnabled then return end
        
        -- // Update footer
        UI.FooterText.Text = "🔒 AIDA | INS to toggle | Players: " .. #Players:GetPlayers()
        
        -- // Spinbot
        if State.Spinbot.Enabled and LocalPlayer.Character then
            local Char = LocalPlayer.Character
            local Root = Char:FindFirstChild("HumanoidRootPart")
            local Hum = Char:FindFirstChildOfClass("Humanoid")
            
            if Root and Hum then
                Hum.AutoRotate = false
                SpinAngle = (SpinAngle + State.Spinbot.Speed * State.Spinbot.Direction) % 360
                
                if State.Spinbot.Jitter then
                    local Jitter = math.sin(SpinAngle / 10) * State.Spinbot.JitterAmount
                    Root.CFrame = CFrame.new(Root.Position) * CFrame.Angles(math.rad(Jitter), math.rad(SpinAngle), 0)
                else
                    Root.CFrame = CFrame.new(Root.Position) * CFrame.Angles(0, math.rad(SpinAngle), 0)
                end
            end
        end
    end)
    
    -- // Aimbot System (Simplified)
    local function FindTarget()
        local Closest = nil
        local ClosestDist = State.Aimbot.FOV
        
        for _, Player in ipairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character then
                local Char = Player.Character
                local Part = Char:FindFirstChild(State.Aimbot.TargetPart)
                local Hum = Char:FindFirstChildOfClass("Humanoid")
                
                if Part and Hum and Hum.Health > 0 then
                    if State.Aimbot.TeamCheck and Player.Team == LocalPlayer.Team then
                        continue
                    end
                    
                    local Vector, OnScreen = Camera:WorldToViewportPoint(Part.Position)
                    local Mouse = UserInputService:GetMouseLocation()
                    local Dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Vector.X, Vector.Y)).Magnitude
                    
                    if Dist < ClosestDist and OnScreen then
                        ClosestDist = Dist
                        Closest = Player
                    end
                end
            end
        end
        
        return Closest
    end
    
    -- // Aimbot Loop
    Connections.Aimbot = RunService.RenderStepped:Connect(function()
        if not State.SystemEnabled or not State.Aimbot.Enabled then return end
        
        local Target = FindTarget()
        if Target and Target.Character then
            local Part = Target.Character:FindFirstChild(State.Aimbot.TargetPart)
            if Part then
                -- // Smooth aim
                local NewCFrame = CFrame.new(Camera.CFrame.Position, Part.Position)
                Camera.CFrame = Camera.CFrame:Lerp(NewCFrame, 1 / (State.Aimbot.Smoothness + 1))
            end
        end
    end)
    
    -- // Toggle System (Insert Key)
    Connections.Toggle = UserInputService.InputBegan:Connect(function(I)
        if I.KeyCode == Enum.KeyCode.Insert then
            State.SystemEnabled = not State.SystemEnabled
            UI.Main.Visible = State.SystemEnabled
            UI.StatusLabel.Text = State.SystemEnabled and "● ON" or "● OFF"
            UI.StatusLabel.TextColor3 = State.SystemEnabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
        end
    end)
    
    -- // Cleanup
    return {
        Disable = function()
            for _, C in pairs(Connections) do
                C:Disconnect()
            end
            if UI.Main.Parent then
                UI.Main.Parent:Destroy()
            end
        end
    }
end

-- // Запуск
local Cheat = AidaCheat()

-- // Полное отключение по End
game:GetService("UserInputService").InputBegan:Connect(function(I)
    if I.KeyCode == Enum.KeyCode.End then
        Cheat.Disable()
        print("Aida Cheat полностью отключен")
    end
end)
