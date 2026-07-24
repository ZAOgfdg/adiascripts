-- // Adia Cheat - Мгновенная загрузка с Toggle
-- // Исследовательская версия

local function AdiaCheat()
    -- // Services
    local P = game:GetService("Players")
    local R = game:GetService("RunService")
    local U = game:GetService("UserInputService")
    local T = game:GetService("TweenService")
    local L = P.LocalPlayer
    
    -- // Состояние системы
    local SystemActive = true
    local MenuVisible = true
    
    -- // UI Creation (мгновенно)
    local function CreateUI()
        local SG = Instance.new("ScreenGui")
        SG.Name = "AdiaCheat"
        SG.ResetOnSpawn = false
        SG.Parent = L:WaitForChild("PlayerGui")
        
        local MF = Instance.new("Frame")
        MF.Size = UDim2.new(0, 480, 0, 520)
        MF.Position = UDim2.new(0.5, -240, 0.5, -260)
        MF.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
        MF.BackgroundTransparency = 0.08
        MF.BorderSizePixel = 1
        MF.BorderColor3 = Color3.fromRGB(40, 45, 60)
        MF.ClipsDescendants = true
        MF.Parent = SG
        
        -- // Заголовок
        local TB = Instance.new("Frame")
        TB.Size = UDim2.new(1, 0, 0, 40)
        TB.BackgroundColor3 = Color3.fromRGB(25, 28, 38)
        TB.BorderSizePixel = 0
        TB.Parent = MF
        
        local TL = Instance.new("TextLabel")
        TL.Size = UDim2.new(1, -60, 1, 0)
        TL.Position = UDim2.new(0, 15, 0, 0)
        TL.BackgroundTransparency = 1
        TL.Text = "⚡ ADIA CHEAT v3.0"
        TL.TextColor3 = Color3.fromRGB(255, 255, 255)
        TL.TextXAlignment = Enum.TextXAlignment.Left
        TL.Font = Enum.Font.GothamBold
        TL.TextSize = 18
        TL.Parent = TB
        
        -- // Кнопка закрытия (крестик)
        local CB = Instance.new("TextButton")
        CB.Size = UDim2.new(0, 32, 1, 0)
        CB.Position = UDim2.new(1, -35, 0, 0)
        CB.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        CB.BackgroundTransparency = 0.7
        CB.Text = "✕"
        CB.TextColor3 = Color3.fromRGB(255, 255, 255)
        CB.Font = Enum.Font.Gotham
        CB.TextSize = 16
        CB.Parent = TB
        CB.MouseButton1Click:Connect(function()
            MF.Visible = not MF.Visible
            MenuVisible = not MenuVisible
        end)
        
        -- // Tabs
        local TabBar = Instance.new("Frame")
        TabBar.Size = UDim2.new(1, 0, 0, 35)
        TabBar.Position = UDim2.new(0, 0, 0, 40)
        TabBar.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
        TabBar.BorderSizePixel = 0
        TabBar.Parent = MF
        
        local Content = Instance.new("Frame")
        Content.Size = UDim2.new(1, -20, 1, -100)
        Content.Position = UDim2.new(0, 10, 0, 80)
        Content.BackgroundTransparency = 1
        Content.Parent = MF
        
        -- // Status Bar
        local SB = Instance.new("Frame")
        SB.Size = UDim2.new(1, 0, 0, 25)
        SB.Position = UDim2.new(0, 0, 1, -25)
        SB.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
        SB.BorderSizePixel = 1
        SB.BorderColor3 = Color3.fromRGB(30, 35, 45)
        SB.Parent = MF
        
        local ST = Instance.new("TextLabel")
        ST.Size = UDim2.new(1, -20, 1, 0)
        ST.Position = UDim2.new(0, 10, 0, 0)
        ST.BackgroundTransparency = 1
        ST.Text = "● ACTIVE  |  Players: " .. #P:GetPlayers()
        ST.TextColor3 = Color3.fromRGB(100, 255, 100)
        ST.TextXAlignment = Enum.TextXAlignment.Left
        ST.Font = Enum.Font.Gotham
        ST.TextSize = 11
        ST.Parent = SB
        
        -- // Drag
        local Dragging = false
        local DragStart, StartPos
        
        TB.InputBegan:Connect(function(I)
            if I.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                DragStart = I.Position
                StartPos = MF.Position
                I.Changed:Connect(function()
                    if I.UserInputState == Enum.InputUserState.End then
                        Dragging = false
                    end
                end)
            end
        end)
        
        U.InputChanged:Connect(function(I)
            if Dragging and I.UserInputType == Enum.UserInputType.MouseMovement then
                local Delta = I.Position - DragStart
                MF.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X,
                                       StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
            end
        end)
        
        -- // Toggle Helper
        local function CreateToggle(Parent, Label, Default, Callback)
            local F = Instance.new("Frame")
            F.Size = UDim2.new(1, 0, 0, 32)
            F.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
            F.BackgroundTransparency = 0.5
            F.BorderSizePixel = 1
            F.BorderColor3 = Color3.fromRGB(35, 40, 50)
            F.Parent = Parent
            
            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(1, -70, 1, 0)
            Lbl.Position = UDim2.new(0, 12, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = Label
            Lbl.TextColor3 = Color3.fromRGB(210, 215, 225)
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Font = Enum.Font.Gotham
            Lbl.TextSize = 13
            Lbl.Parent = F
            
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(0, 44, 0, 24)
            Btn.Position = UDim2.new(1, -54, 0.5, -12)
            Btn.BackgroundColor3 = Default and Color3.fromRGB(50, 200, 80) or Color3.fromRGB(55, 55, 65)
            Btn.BorderSizePixel = 0
            Btn.Text = Default and "ON" or "OFF"
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.GothamBold
            Btn.TextSize = 11
            Btn.Parent = F
            
            local State = Default
            Btn.MouseButton1Click:Connect(function()
                State = not State
                Btn.BackgroundColor3 = State and Color3.fromRGB(50, 200, 80) or Color3.fromRGB(55, 55, 65)
                Btn.Text = State and "ON" or "OFF"
                if Callback then Callback(State) end
            end)
            
            return Btn
        end
        
        -- // Slider Helper
        local function CreateSlider(Parent, Label, Min, Max, Default, Callback)
            local F = Instance.new("Frame")
            F.Size = UDim2.new(1, 0, 0, 48)
            F.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
            F.BackgroundTransparency = 0.5
            F.BorderSizePixel = 1
            F.BorderColor3 = Color3.fromRGB(35, 40, 50)
            F.Parent = Parent
            
            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(1, -100, 0, 18)
            Lbl.Position = UDim2.new(0, 12, 0, 4)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = Label
            Lbl.TextColor3 = Color3.fromRGB(210, 215, 225)
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Font = Enum.Font.Gotham
            Lbl.TextSize = 13
            Lbl.Parent = F
            
            local Val = Instance.new("TextLabel")
            Val.Size = UDim2.new(0, 40, 0, 18)
            Val.Position = UDim2.new(1, -52, 0, 4)
            Val.BackgroundTransparency = 1
            Val.Text = tostring(Default)
            Val.TextColor3 = Color3.fromRGB(130, 190, 255)
            Val.TextXAlignment = Enum.TextXAlignment.Right
            Val.Font = Enum.Font.GothamBold
            Val.TextSize = 14
            Val.Parent = F
            
            local Sl = Instance.new("Frame")
            Sl.Size = UDim2.new(1, -24, 0, 3)
            Sl.Position = UDim2.new(0, 12, 0, 30)
            Sl.BackgroundColor3 = Color3.fromRGB(45, 50, 60)
            Sl.BorderSizePixel = 0
            Sl.Parent = F
            
            local Fi = Instance.new("Frame")
            Fi.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
            Fi.BackgroundColor3 = Color3.fromRGB(70, 150, 255)
            Fi.BorderSizePixel = 0
            Fi.Parent = Sl
            
            local Db = Instance.new("TextButton")
            Db.Size = UDim2.new(0, 14, 0, 14)
            Db.Position = UDim2.new((Default - Min) / (Max - Min), -7, 0.5, -7)
            Db.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
            Db.BorderSizePixel = 0
            Db.Text = ""
            Db.Parent = Sl
            
            local Value = Default
            local Dragging = false
            
            Db.MouseButton1Down:Connect(function()
                Dragging = true
            end)
            
            U.InputEnded:Connect(function(I)
                if I.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                end
            end)
            
            U.InputChanged:Connect(function(I)
                if Dragging and I.UserInputType == Enum.UserInputType.MouseMovement then
                    local Rx = I.Position.X - Sl.AbsolutePosition.X
                    local Pc = math.clamp(Rx / Sl.AbsoluteSize.X, 0, 1)
                    Value = Min + (Max - Min) * Pc
                    Value = math.round(Value)
                    
                    Fi.Size = UDim2.new(Pc, 0, 1, 0)
                    Db.Position = UDim2.new(Pc, -7, 0.5, -7)
                    Val.Text = tostring(Value)
                    
                    if Callback then Callback(Value) end
                end
            end)
            
            return {Value = Value, SetValue = function(V)
                V = math.clamp(V, Min, Max)
                Value = V
                local Pc = (V - Min) / (Max - Min)
                Fi.Size = UDim2.new(Pc, 0, 1, 0)
                Db.Position = UDim2.new(Pc, -7, 0.5, -7)
                Val.Text = tostring(V)
            end}
        end
        
        -- // Dropdown Helper
        local function CreateDropdown(Parent, Label, Options, Default, Callback)
            local F = Instance.new("Frame")
            F.Size = UDim2.new(1, 0, 0, 38)
            F.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
            F.BackgroundTransparency = 0.5
            F.BorderSizePixel = 1
            F.BorderColor3 = Color3.fromRGB(35, 40, 50)
            F.Parent = Parent
            
            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(0.4, -10, 1, 0)
            Lbl.Position = UDim2.new(0, 12, 0, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = Label
            Lbl.TextColor3 = Color3.fromRGB(210, 215, 225)
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Font = Enum.Font.Gotham
            Lbl.TextSize = 13
            Lbl.Parent = F
            
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(0.6, -20, 1, -8)
            Btn.Position = UDim2.new(0.4, 0, 0, 4)
            Btn.BackgroundColor3 = Color3.fromRGB(38, 40, 52)
            Btn.BorderSizePixel = 1
            Btn.BorderColor3 = Color3.fromRGB(50, 55, 65)
            Btn.Text = Default
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 12
            Btn.Parent = F
            
            local DF = Instance.new("Frame")
            DF.Size = UDim2.new(0.6, -20, 0, 100)
            DF.Position = UDim2.new(0.4, 0, 1, 4)
            DF.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
            DF.BorderSizePixel = 1
            DF.BorderColor3 = Color3.fromRGB(45, 50, 60)
            DF.Visible = false
            DF.ZIndex = 10
            DF.Parent = F
            
            local DL = Instance.new("ScrollingFrame")
            DL.Size = UDim2.new(1, 0, 1, 0)
            DL.BackgroundTransparency = 1
            DL.ScrollBarThickness = 3
            DL.Parent = DF
            
            local UG = Instance.new("UIGridLayout")
            UG.CellSize = UDim2.new(1, 0, 0, 24)
            UG.CellPadding = UDim2.new(0, 0, 0, 1)
            UG.FillDirection = Enum.FillDirection.Vertical
            UG.SortOrder = Enum.SortOrder.LayoutOrder
            UG.Parent = DL
            
            local Current = Default
            
            for _, Opt in ipairs(Options) do
                local OB = Instance.new("TextButton")
                OB.Size = UDim2.new(1, 0, 0, 24)
                OB.BackgroundColor3 = Color3.fromRGB(38, 40, 52)
                OB.BorderSizePixel = 0
                OB.Text = Opt
                OB.TextColor3 = Color3.fromRGB(200, 205, 215)
                OB.Font = Enum.Font.Gotham
                OB.TextSize = 12
                OB.Parent = DL
                
                OB.MouseButton1Click:Connect(function()
                    Current = Opt
                    Btn.Text = Opt
                    DF.Visible = false
                    if Callback then Callback(Opt) end
                end)
            end
            
            Btn.MouseButton1Click:Connect(function()
                DF.Visible = not DF.Visible
            end)
            
            return {Value = Current, SetValue = function(V)
                Current = V
                Btn.Text = V
            end}
        end
        
        -- // Создание табов
        local function CreateTab(Name, Icon)
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(0, 100, 1, 0)
            Btn.BackgroundTransparency = 1
            Btn.Text = Icon .. " " .. Name
            Btn.TextColor3 = Color3.fromRGB(160, 165, 180)
            Btn.Font = Enum.Font.Gotham
            Btn.TextSize = 13
            Btn.Parent = TabBar
            
            local Cont = Instance.new("ScrollingFrame")
            Cont.Size = UDim2.new(1, 0, 1, 0)
            Cont.BackgroundTransparency = 1
            Cont.ScrollBarThickness = 4
            Cont.Visible = false
            Cont.Parent = Content
            
            local Layout = Instance.new("UIGridLayout")
            Layout.CellSize = UDim2.new(1, -10, 0, 34)
            Layout.CellPadding = UDim2.new(0, 5, 0, 4)
            Layout.FillDirection = Enum.FillDirection.Vertical
            Layout.SortOrder = Enum.SortOrder.LayoutOrder
            Layout.Parent = Cont
            
            local TabObj = {Button = Btn, Content = Cont, Layout = Layout, Elements = {}}
            
            Btn.MouseButton1Click:Connect(function()
                for _, T in pairs(Tabs) do
                    T.Content.Visible = false
                    T.Button.TextColor3 = Color3.fromRGB(160, 165, 180)
                end
                Cont.Visible = true
                Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            end)
            
            return TabObj
        end
        
        local Tabs = {}
        
        -- // Создание вкладок
        local AimbotTab = CreateTab("Aimbot", "🎯")
        local SpinbotTab = CreateTab("Spinbot", "🔄")
        local ESPTab = CreateTab("ESP", "👁️")
        local MiscTab = CreateTab("Misc", "⚙️")
        Tabs = {AimbotTab, SpinbotTab, ESPTab, MiscTab}
        AimbotTab.Content.Visible = true
        AimbotTab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        -- // Настройки для UI элементов
        local UIState = {
            aimbotEnabled = true,
            spinbotEnabled = true,
            espEnabled = true,
            fovAmount = 90,
            spinSpeed = 40,
        }
        
        -- // Aimbot Toggles
        CreateToggle(AimbotTab.Content, "Aimbot Enabled", true, function(S)
            UIState.aimbotEnabled = S
        end)
        CreateToggle(AimbotTab.Content, "Team Check", false)
        CreateToggle(AimbotTab.Content, "Wall Check", false)
        CreateToggle(AimbotTab.Content, "Third Person", false)
        CreateSlider(AimbotTab.Content, "FOV Amount", 10, 360, 90, function(V)
            UIState.fovAmount = V
        end)
        CreateSlider(AimbotTab.Content, "Sensitivity", 0, 2, 0.5)
        CreateDropdown(AimbotTab.Content, "Lock Part", {"Head", "UpperTorso", "LowerTorso"}, "Head")
        CreateDropdown(AimbotTab.Content, "Trigger Key", {"RMB", "LMB", "Q", "E", "F"}, "RMB")
        
        -- // Spinbot
        CreateToggle(SpinbotTab.Content, "Spinbot Enabled", true, function(S)
            UIState.spinbotEnabled = S
        end)
        CreateSlider(SpinbotTab.Content, "Spin Speed", 1, 200, 40, function(V)
            UIState.spinSpeed = V
        end)
        CreateDropdown(SpinbotTab.Content, "Direction", {"Right", "Left"}, "Right")
        
        -- // ESP
        CreateToggle(ESPTab.Content, "ESP Enabled", true, function(S)
            UIState.espEnabled = S
        end)
        CreateToggle(ESPTab.Content, "Box ESP", true)
        CreateToggle(ESPTab.Content, "Skeleton ESP", true)
        CreateToggle(ESPTab.Content, "Health Bar", true)
        CreateToggle(ESPTab.Content, "Name ESP", true)
        
        -- // Misc
        CreateToggle(MiscTab.Content, "Bunny Hop", true)
        CreateToggle(MiscTab.Content, "Auto Strafe", true)
        CreateToggle(MiscTab.Content, "Auto Jump", false)
        
        return {MF = MF, UIState = UIState, StatusText = ST}
    end
    
    -- // Создание UI
    local UI = CreateUI()
    
    -- // Spinbot Logic
    local SpinAngle = 0
    local SpinDirection = 1
    
    -- // Загрузка ESP
    local ESPLoaded = false
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/wa0101/Roblox-ESP/refs/heads/main/esp.lua", true))()
        ESPLoaded = true
    end)
    
    -- // Основной цикл
    local Connections = {}
    
    -- // Только 1 соединение для всего
    Connections.MainLoop = R.RenderStepped:Connect(function()
        -- Обновление статуса
        UI.StatusText.Text = "● " .. (SystemActive and "ACTIVE" or "PAUSED") .. "  |  Players: " .. #P:GetPlayers()
        
        -- Spinbot
        if SystemActive and UI.UIState.spinbotEnabled and L.Character then
            local Char = L.Character
            local Root = Char:FindFirstChild("HumanoidRootPart")
            local Hum = Char:FindFirstChildOfClass("Humanoid")
            
            if Root and Hum then
                Hum.AutoRotate = false
                SpinAngle = (SpinAngle + UI.UIState.spinSpeed * SpinDirection) % 360
                Root.CFrame = CFrame.new(Root.Position) * CFrame.Angles(0, math.rad(SpinAngle), 0)
            end
        end
    end)
    
    -- // Toggle система (Insert - полное выключение)
    Connections.Toggle = U.InputBegan:Connect(function(I)
        if I.KeyCode == Enum.KeyCode.Insert then
            SystemActive = not SystemActive
            
            if not SystemActive then
                -- // Полное отключение
                UI.MF.Visible = false
                
                -- // Остановка спинбота
                if L.Character then
                    local Char = L.Character
                    local Root = Char:FindFirstChild("HumanoidRootPart")
                    if Root then
                        Root.CFrame = CFrame.new(Root.Position)
                    end
                end
                
                -- // Отключение ESP если загружен
                if ESPLoaded and getgenv().ESP then
                    pcall(function()
                        getgenv().ESP.Functions:Exit()
                    end)
                end
                
                -- // Статус
                UI.StatusText.Text = "● DISABLED  |  Press Insert to Enable"
                UI.StatusText.TextColor3 = Color3.fromRGB(255, 80, 80)
            else
                -- // Включение
                UI.MF.Visible = true
                UI.StatusText.TextColor3 = Color3.fromRGB(100, 255, 100)
                
                -- // Перезагрузка ESP
                if ESPLoaded then
                    pcall(function()
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/wa0101/Roblox-ESP/refs/heads/main/esp.lua", true))()
                    end)
                end
            end
        end
    end)
    
    -- // Очистка при выходе
    return {
        Disable = function()
            for _, C in pairs(Connections) do
                C:Disconnect()
            end
            SystemActive = false
        end
    }
end

-- // Мгновенный запуск
local Cheat = AdiaCheat()

-- // Горячая клавиша для полного закрытия (End)
game:GetService("UserInputService").InputBegan:Connect(function(I)
    if I.KeyCode == Enum.KeyCode.End then
        Cheat.Disable()
        print("Adia Cheat полностью отключен")
    end
end)
