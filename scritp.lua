-- // AIDA CHEAT v5.4 – by Zao
-- // Aimbot (оригинальный), Spinbot, ESP, FOV Circle

local function AidaCheat()
    -- // ─── Загрузка библиотек ──────────────────────────────────
    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
    local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

    -- // ─── Сервисы ────────────────────────────────────────────
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera

    -- // ─── ВСТАВЛЯЕМ ОРИГИНАЛЬНЫЙ АИМБОТ ──────────────────────
    --// Cache
    local select = select
    local pcall, getgenv, next, Vector2, mathclamp, type, mousemoverel = select(1, pcall, getgenv, next, Vector2.new, math.clamp, type, mousemoverel or (Input and Input.MouseMove))

    --// Preventing Multiple Processes
    pcall(function()
        getgenv().Aimbot.Functions:Exit()
    end)

    --// Environment
    getgenv().Aimbot = {}
    local Environment = getgenv().Aimbot

    --// Services (уже объявлены выше, но для совместимости оставляем)
    local RunService = RunService
    local UserInputService = UserInputService
    local TweenService = game:GetService("TweenService")
    local Players = Players
    local Camera = Camera
    local LocalPlayer = LocalPlayer

    --// Variables
    local RequiredDistance, Typing, Running, Animation, ServiceConnections = 2000, false, false, nil, {}

    --// Script Settings (будут переопределены через GUI)
    Environment.Settings = {
        Enabled = true,
        TeamCheck = false,
        AliveCheck = true,
        WallCheck = false,
        Sensitivity = 0,
        ThirdPerson = false,
        ThirdPersonSensitivity = 3,
        TriggerKey = "MouseButton2",
        Toggle = false,
        LockPart = "Head"
    }

    Environment.FOVSettings = {
        Enabled = true,
        Visible = true,
        Amount = 90,
        Color = Color3.fromRGB(255, 255, 255),
        LockedColor = Color3.fromRGB(255, 70, 70),
        Transparency = 0.5,
        Sides = 60,
        Thickness = 1,
        Filled = false
    }

    Environment.FOVCircle = Drawing.new("Circle")

    --// Functions
    local function CancelLock()
        Environment.Locked = nil
        if Animation then Animation:Cancel() end
        Environment.FOVCircle.Color = Environment.FOVSettings.Color
    end

    local function GetClosestPlayer()
        if not Environment.Locked then
            RequiredDistance = (Environment.FOVSettings.Enabled and Environment.FOVSettings.Amount or 2000)

            for _, v in next, Players:GetPlayers() do
                if v ~= LocalPlayer then
                    if v.Character and v.Character:FindFirstChild(Environment.Settings.LockPart) and v.Character:FindFirstChildOfClass("Humanoid") then
                        if Environment.Settings.TeamCheck and v.Team == LocalPlayer.Team then continue end
                        if Environment.Settings.AliveCheck and v.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then continue end
                        if Environment.Settings.WallCheck and #(Camera:GetPartsObscuringTarget({v.Character[Environment.Settings.LockPart].Position}, v.Character:GetDescendants())) > 0 then continue end

                        local Vector, OnScreen = Camera:WorldToViewportPoint(v.Character[Environment.Settings.LockPart].Position)
                        local Distance = (Vector2(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2(Vector.X, Vector.Y)).Magnitude

                        if Distance < RequiredDistance and OnScreen then
                            RequiredDistance = Distance
                            Environment.Locked = v
                        end
                    end
                end
            end
        elseif (Vector2(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2(Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position).X, Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position).Y)).Magnitude > RequiredDistance then
            CancelLock()
        end
    end

    --// Typing Check
    ServiceConnections.TypingStartedConnection = UserInputService.TextBoxFocused:Connect(function()
        Typing = true
    end)

    ServiceConnections.TypingEndedConnection = UserInputService.TextBoxFocusReleased:Connect(function()
        Typing = false
    end)

    --// Main
    local function Load()
        ServiceConnections.RenderSteppedConnection = RunService.RenderStepped:Connect(function()
            if Environment.FOVSettings.Enabled and Environment.Settings.Enabled then
                Environment.FOVCircle.Radius = Environment.FOVSettings.Amount
                Environment.FOVCircle.Thickness = Environment.FOVSettings.Thickness
                Environment.FOVCircle.Filled = Environment.FOVSettings.Filled
                Environment.FOVCircle.NumSides = Environment.FOVSettings.Sides
                Environment.FOVCircle.Color = Environment.FOVSettings.Color
                Environment.FOVCircle.Transparency = Environment.FOVSettings.Transparency
                Environment.FOVCircle.Visible = Environment.FOVSettings.Visible
                Environment.FOVCircle.Position = Vector2(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
            else
                Environment.FOVCircle.Visible = false
            end

            if Running and Environment.Settings.Enabled then
                GetClosestPlayer()

                if Environment.Locked then
                    if Environment.Settings.ThirdPerson then
                        Environment.Settings.ThirdPersonSensitivity = mathclamp(Environment.Settings.ThirdPersonSensitivity, 0.1, 5)

                        local Vector = Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position)
                        mousemoverel((Vector.X - UserInputService:GetMouseLocation().X) * Environment.Settings.ThirdPersonSensitivity, (Vector.Y - UserInputService:GetMouseLocation().Y) * Environment.Settings.ThirdPersonSensitivity)
                    else
                        if Environment.Settings.Sensitivity > 0 then
                            Animation = TweenService:Create(Camera, TweenInfo.new(Environment.Settings.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, Environment.Locked.Character[Environment.Settings.LockPart].Position)})
                            Animation:Play()
                        else
                            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Environment.Locked.Character[Environment.Settings.LockPart].Position)
                        end
                    end

                    Environment.FOVCircle.Color = Environment.FOVSettings.LockedColor
                end
            end
        end)

        ServiceConnections.InputBeganConnection = UserInputService.InputBegan:Connect(function(Input)
            if not Typing then
                pcall(function()
                    if Input.KeyCode == Enum.KeyCode[Environment.Settings.TriggerKey] then
                        if Environment.Settings.Toggle then
                            Running = not Running
                            if not Running then CancelLock() end
                        else
                            Running = true
                        end
                    end
                end)

                pcall(function()
                    if Input.UserInputType == Enum.UserInputType[Environment.Settings.TriggerKey] then
                        if Environment.Settings.Toggle then
                            Running = not Running
                            if not Running then CancelLock() end
                        else
                            Running = true
                        end
                    end
                end)
            end
        end)

        ServiceConnections.InputEndedConnection = UserInputService.InputEnded:Connect(function(Input)
            if not Typing then
                if not Environment.Settings.Toggle then
                    pcall(function()
                        if Input.KeyCode == Enum.KeyCode[Environment.Settings.TriggerKey] then
                            Running = false; CancelLock()
                        end
                    end)

                    pcall(function()
                        if Input.UserInputType == Enum.UserInputType[Environment.Settings.TriggerKey] then
                            Running = false; CancelLock()
                        end
                    end)
                end
            end
        end)
    end

    Environment.Functions = {}

    function Environment.Functions:Exit()
        for _, v in next, ServiceConnections do
            v:Disconnect()
        end
        if Environment.FOVCircle.Remove then Environment.FOVCircle:Remove() end
        getgenv().Aimbot.Functions = nil
        getgenv().Aimbot = nil
        Load = nil; GetClosestPlayer = nil; CancelLock = nil
    end

    function Environment.Functions:Restart()
        for _, v in next, ServiceConnections do
            v:Disconnect()
        end
        Load()
    end

    function Environment.Functions:ResetSettings()
        Environment.Settings = {
            Enabled = true,
            TeamCheck = false,
            AliveCheck = true,
            WallCheck = false,
            Sensitivity = 0,
            ThirdPerson = false,
            ThirdPersonSensitivity = 3,
            TriggerKey = "MouseButton2",
            Toggle = false,
            LockPart = "Head"
        }
        Environment.FOVSettings = {
            Enabled = true,
            Visible = true,
            Amount = 90,
            Color = Color3.fromRGB(255, 255, 255),
            LockedColor = Color3.fromRGB(255, 70, 70),
            Transparency = 0.5,
            Sides = 60,
            Thickness = 1,
            Filled = false
        }
    end

    -- // ─── КОНЕЦ ВСТАВКИ АИМБОТА ──────────────────────────────

    -- // ─── Состояния для спинбота и ESP ──────────────────────
    local State = {
        Spinbot = { Enabled = false, Speed = 45, Direction = 1 },
        ESP = {
            Enabled = false,
            Box = true,
            Tracer = false,
            Health = true,
            Name = true,
            MaxDistance = 2000,
            Chams = false,
            ChamsColor = Color3.fromRGB(255, 0, 0),
            ChamsOutlineColor = Color3.fromRGB(255, 255, 255)
        }
    }

    -- // ─── Переменные для спинбота и ESP ──────────────────────
    local SpinAngle = 0
    local ESPDrawings = {}
    local ChamsHighlights = {}
    local MainLoopConnection = nil
    local Watermark = nil

    -- // ─── Водяной знак ──────────────────────────────────────
    local function CreateWatermark()
        local gui = LocalPlayer:WaitForChild("PlayerGui")
        Watermark = Instance.new("TextLabel")
        Watermark.Parent = gui
        Watermark.BackgroundTransparency = 1
        Watermark.Text = "by Zao"
        Watermark.TextColor3 = Color3.fromRGB(255, 255, 255)
        Watermark.TextSize = 16
        Watermark.Font = Enum.Font.GothamBold
        Watermark.TextXAlignment = Enum.TextXAlignment.Right
        Watermark.TextYAlignment = Enum.TextYAlignment.Bottom
        Watermark.Position = UDim2.new(1, -15, 1, -15)
        Watermark.Size = UDim2.new(0, 100, 0, 30)
        Watermark.TextTransparency = 0.7
        Watermark.ZIndex = 999
        Watermark.Visible = true
    end

    local function DestroyWatermark()
        if Watermark then pcall(function() Watermark:Destroy() end) end
        Watermark = nil
    end

    -- // ─── GUI: Окно ──────────────────────────────────────────
    local Window = Fluent:CreateWindow({
        Title = "✦ AIDA CHEAT v5.4",
        SubTitle = "by Zao",
        TabWidth = 130,
        Size = UDim2.fromOffset(540, 520),
        Acrylic = false,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    -- // ─── Вкладка Aimbot ──────────────────────────────────────
    local AimbotTab = Window:AddTab({ Title = "Aimbot", Icon = "crosshair" })
    local AimbotSection = AimbotTab:AddSection("Main")

    -- Привязываем к Environment.Settings
    local AimbotToggle = AimbotSection:AddToggle("AimbotEnabled", {
        Title = "Enable Aimbot (hold RMB)",
        Default = true,
        Callback = function(v)
            Environment.Settings.Enabled = v
            if not v then
                Running = false
                CancelLock()
            end
        end
    })

    AimbotSection:AddSlider("AimbotFOV", {
        Title = "FOV",
        Default = 90,
        Min = 10,
        Max = 360,
        Rounding = 0,
        Callback = function(v)
            Environment.FOVSettings.Amount = v
        end
    })

    AimbotSection:AddSlider("AimbotSmooth", {
        Title = "Smoothness (0 = instant)",
        Default = 0,
        Min = 0,
        Max = 30,
        Rounding = 0,
        Callback = function(v)
            Environment.Settings.Sensitivity = v
        end
    })

    AimbotSection:AddDropdown("AimbotPart", {
        Title = "Target Part",
        Values = { "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart" },
        Default = "Head",
        Callback = function(v)
            Environment.Settings.LockPart = v
        end
    })

    local TeamCheckToggle = AimbotSection:AddToggle("AimbotTeamCheck", {
        Title = "Team Check",
        Default = false,
        Callback = function(v)
            Environment.Settings.TeamCheck = v
        end
    })

    local WallCheckToggle = AimbotSection:AddToggle("AimbotWallCheck", {
        Title = "Wall Check",
        Default = false,
        Callback = function(v)
            Environment.Settings.WallCheck = v
        end
    })

    -- // FOV Circle настройки (привязываем к Environment.FOVSettings)
    local FOVSection = AimbotTab:AddSection("FOV Circle")
    local FOVToggle = FOVSection:AddToggle("ShowFOV", {
        Title = "Show FOV Circle",
        Default = true,
        Callback = function(v)
            Environment.FOVSettings.Visible = v
        end
    })

    local FOVColorPicker = FOVSection:AddColorpicker("FOVColor", {
        Title = "FOV Color",
        Default = Environment.FOVSettings.Color,
        Callback = function(v)
            Environment.FOVSettings.Color = v
        end
    })

    local FOVLockedColorPicker = FOVSection:AddColorpicker("FOVLockedColor", {
        Title = "Locked Color",
        Default = Environment.FOVSettings.LockedColor,
        Callback = function(v)
            Environment.FOVSettings.LockedColor = v
        end
    })

    FOVSection:AddSlider("FOVTransparency", {
        Title = "Transparency",
        Default = 0.5,
        Min = 0,
        Max = 1,
        Rounding = 2,
        Callback = function(v)
            Environment.FOVSettings.Transparency = v
        end
    })

    -- // ─── Вкладка Spinbot ──────────────────────────────────────
    local SpinbotTab = Window:AddTab({ Title = "Spinbot", Icon = "refresh-cw" })
    local SpinbotSection = SpinbotTab:AddSection("Controls")

    SpinbotSection:AddToggle("SpinbotEnabled", {
        Title = "Enable Spinbot",
        Default = false,
        Callback = function(v) State.Spinbot.Enabled = v end
    })

    SpinbotSection:AddSlider("SpinbotSpeed", {
        Title = "Speed",
        Default = 45,
        Min = 1,
        Max = 200,
        Rounding = 0,
        Callback = function(v) State.Spinbot.Speed = v end
    })

    SpinbotSection:AddDropdown("SpinbotDir", {
        Title = "Direction",
        Values = { "Right", "Left" },
        Default = "Right",
        Callback = function(v)
            State.Spinbot.Direction = (v == "Right") and 1 or -1
        end
    })

    -- // ─── Вкладка ESP ──────────────────────────────────────────
    local ESPTab = Window:AddTab({ Title = "ESP", Icon = "eye" })
    local ESPSection = ESPTab:AddSection("Visuals")

    local ESPToggle = ESPSection:AddToggle("ESPEnabled", {
        Title = "Enable ESP",
        Default = false,
        Callback = function(v)
            State.ESP.Enabled = v
            if not v then
                for player, obj in pairs(ESPDrawings) do
                    for _, draw in pairs(obj) do
                        pcall(function() draw:Remove() end)
                    end
                end
                ESPDrawings = {}
                for player, hl in pairs(ChamsHighlights) do
                    pcall(function() hl:Destroy() end)
                end
                ChamsHighlights = {}
            else
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        CreateESPObjects(player)
                    end
                end
            end
        end
    })

    ESPSection:AddToggle("ESPBox", {
        Title = "Box ESP",
        Default = true,
        Callback = function(v) State.ESP.Box = v end
    })

    ESPSection:AddToggle("ESPTracer", {
        Title = "Tracer",
        Default = false,
        Callback = function(v) State.ESP.Tracer = v end
    })

    ESPSection:AddToggle("ESPHealth", {
        Title = "Health Bar",
        Default = true,
        Callback = function(v) State.ESP.Health = v end
    })

    ESPSection:AddToggle("ESPName", {
        Title = "Name Tags",
        Default = true,
        Callback = function(v) State.ESP.Name = v end
    })

    ESPSection:AddSlider("ESPMaxDist", {
        Title = "Max Distance",
        Default = 2000,
        Min = 100,
        Max = 10000,
        Rounding = 0,
        Callback = function(v) State.ESP.MaxDistance = v end
    })

    -- // Чармсы
    local ChamsSection = ESPTab:AddSection("Chams (Highlight)")
    local ChamsToggle = ChamsSection:AddToggle("ESPChams", {
        Title = "Enable Chams",
        Default = false,
        Callback = function(v)
            State.ESP.Chams = v
            if not v then
                for player, hl in pairs(ChamsHighlights) do
                    pcall(function() hl:Destroy() end)
                end
                ChamsHighlights = {}
            else
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        ApplyChams(player)
                    end
                end
            end
        end
    })

    local ChamsColorPicker = ChamsSection:AddColorpicker("ChamsColor", {
        Title = "Fill Color",
        Default = State.ESP.ChamsColor,
        Callback = function(v)
            State.ESP.ChamsColor = v
            for player, hl in pairs(ChamsHighlights) do
                if hl then hl.FillColor = v end
            end
        end
    })

    local ChamsOutlinePicker = ChamsSection:AddColorpicker("ChamsOutlineColor", {
        Title = "Outline Color",
        Default = State.ESP.ChamsOutlineColor,
        Callback = function(v)
            State.ESP.ChamsOutlineColor = v
            for player, hl in pairs(ChamsHighlights) do
                if hl then hl.OutlineColor = v end
            end
        end
    })

    -- // ─── Вкладка Config ──────────────────────────────────────
    local ConfigTab = Window:AddTab({ Title = "Config", Icon = "save" })
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})
    InterfaceManager:SetFolder("AidaCheat")
    SaveManager:SetFolder("AidaCheat/configs")
    InterfaceManager:BuildInterfaceSection(ConfigTab)
    SaveManager:BuildConfigSection(ConfigTab)

    -- // ─── Вспомогательные функции ESP ──────────────────────────
    local function CreateESPObjects(player)
        if player == LocalPlayer then return end
        if ESPDrawings[player] then return end

        local drawings = {
            Box = Drawing.new("Square"),
            Tracer = Drawing.new("Line"),
            Health = Drawing.new("Square"),
            Name = Drawing.new("Text")
        }

        drawings.Box.Thickness = 1
        drawings.Box.Filled = false
        drawings.Tracer.Thickness = 1
        drawings.Health.Filled = true
        drawings.Health.Thickness = 0
        drawings.Name.Size = 14
        drawings.Name.Center = true
        drawings.Name.Outline = true

        for _, obj in pairs(drawings) do
            obj.Visible = false
            if obj ~= drawings.Name then
                obj.Color = Color3.fromRGB(255, 50, 50)
            else
                obj.Color = Color3.fromRGB(255, 255, 255)
            end
        end

        ESPDrawings[player] = drawings
    end

    local function ApplyChams(player)
        if player == LocalPlayer then return end
        local char = player.Character
        if not char then return end

        if ChamsHighlights[player] then
            pcall(function() ChamsHighlights[player]:Destroy() end)
            ChamsHighlights[player] = nil
        end

        local hl = Instance.new("Highlight")
        hl.Parent = char
        hl.FillColor = State.ESP.ChamsColor
        hl.OutlineColor = State.ESP.ChamsOutlineColor
        hl.FillTransparency = 0.4
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Enabled = State.ESP.Chams
        ChamsHighlights[player] = hl
    end

    local function RemoveESPObjects(player)
        local drawings = ESPDrawings[player]
        if drawings then
            for _, obj in pairs(drawings) do
                pcall(function() obj:Remove() end)
            end
            ESPDrawings[player] = nil
        end
        local hl = ChamsHighlights[player]
        if hl then
            pcall(function() hl:Destroy() end)
            ChamsHighlights[player] = nil
        end
    end

    -- // ─── Обновление ESP ──────────────────────────────────────
    local function UpdateESP()
        if not State.ESP.Enabled then
            for player, _ in pairs(ESPDrawings) do
                RemoveESPObjects(player)
            end
            return
        end

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if not ESPDrawings[player] then CreateESPObjects(player) end
                if State.ESP.Chams and not ChamsHighlights[player] then ApplyChams(player) end
                if not State.ESP.Chams and ChamsHighlights[player] then
                    pcall(function() ChamsHighlights[player]:Destroy() end)
                    ChamsHighlights[player] = nil
                end
            end
        end

        for player, _ in pairs(ESPDrawings) do
            if not Players:FindFirstChild(player.Name) then RemoveESPObjects(player) end
        end

        for player, drawings in pairs(ESPDrawings) do
            if player == LocalPlayer then
                for _, obj in pairs(drawings) do obj.Visible = false end
                continue
            end

            local char = player.Character
            if not char then
                for _, obj in pairs(drawings) do obj.Visible = false end
                continue
            end

            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not root or not hum or hum.Health <= 0 then
                for _, obj in pairs(drawings) do obj.Visible = false end
                continue
            end

            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            local dist = (root.Position - Camera.CFrame.Position).Magnitude
            if not onScreen or dist > State.ESP.MaxDistance then
                for _, obj in pairs(drawings) do obj.Visible = false end
                continue
            end

            local size = char:GetExtentsSize()
            local top = Camera:WorldToViewportPoint((root.CFrame * CFrame.new(0, size.Y/2, 0)).Position)
            local bottom = Camera:WorldToViewportPoint((root.CFrame * CFrame.new(0, -size.Y/2, 0)).Position)
            local height = bottom.Y - top.Y
            local width = height * 0.6
            local posX = top.X - width/2
            local posY = top.Y

            local teamColor = (player.Team == LocalPlayer.Team) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)

            if State.ESP.Box then
                drawings.Box.Position = Vector2.new(posX, posY)
                drawings.Box.Size = Vector2.new(width, height)
                drawings.Box.Color = teamColor
                drawings.Box.Visible = true
            else
                drawings.Box.Visible = false
            end

            if State.ESP.Tracer then
                drawings.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                drawings.Tracer.To = Vector2.new(pos.X, pos.Y)
                drawings.Tracer.Color = teamColor
                drawings.Tracer.Visible = true
            else
                drawings.Tracer.Visible = false
            end

            if State.ESP.Health then
                local health = hum.Health / hum.MaxHealth
                local barX = posX - 6
                local barY = posY
                local barH = height
                drawings.Health.Position = Vector2.new(barX, barY + (1 - health) * barH)
                drawings.Health.Size = Vector2.new(3, health * barH)
                drawings.Health.Color = Color3.fromRGB(255 * (1 - health), 255 * health, 0)
                drawings.Health.Visible = true
            else
                drawings.Health.Visible = false
            end

            if State.ESP.Name then
                drawings.Name.Text = player.DisplayName
                drawings.Name.Position = Vector2.new(pos.X, top.Y - 20)
                drawings.Name.Color = Color3.fromRGB(255, 255, 255)
                drawings.Name.Visible = true
            else
                drawings.Name.Visible = false
            end
        end
    end

    -- // ─── Логика Spinbot ──────────────────────────────────────
    local function SpinbotLoop()
        if not State.Spinbot.Enabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not (root and hum) then return end
        hum.AutoRotate = false
        SpinAngle = (SpinAngle + State.Spinbot.Speed * State.Spinbot.Direction) % 360
        root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(SpinAngle), 0)
    end

    -- // ─── Главный цикл (только спинбот и ESP) ────────────────
    local function MainLoop()
        SpinbotLoop()
        UpdateESP()
    end

    -- // ─── Активация аимбота по ПКМ ─────────────────────────────
    -- Мы будем управлять переменной Running (из аимбота) через RMBPressed
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            -- Если аимбот включён в настройках, то активируем
            if Environment.Settings.Enabled then
                Running = true
            end
        end
    end)

    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            -- Если не используется режим Toggle (у нас Toggle = false)
            if not Environment.Settings.Toggle then
                Running = false
                CancelLock()
            end
        end
    end)

    -- // ─── Запуск аимбота ──────────────────────────────────────
    Load()  -- запускаем аимбот

    -- // ─── Запуск спинбота и ESP ──────────────────────────────
    MainLoopConnection = RunService.RenderStepped:Connect(MainLoop)

    -- // ─── Водяной знак ──────────────────────────────────────
    CreateWatermark()

    -- // ─── Горячие клавиши ──────────────────────────────────────
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Insert then
            Window:Toggle()
        end
        if input.KeyCode == Enum.KeyCode.End then
            -- Выгружаем всё
            if MainLoopConnection then MainLoopConnection:Disconnect() end
            Environment.Functions:Exit() -- выгружаем аимбот
            for player, drawings in pairs(ESPDrawings) do
                for _, obj in pairs(drawings) do
                    pcall(function() obj:Remove() end)
                end
            end
            ESPDrawings = {}
            for player, hl in pairs(ChamsHighlights) do
                pcall(function() hl:Destroy() end)
            end
            ChamsHighlights = {}
            DestroyWatermark()
            Window:Destroy()
            print("AIDA CHEAT выгружен")
        end
    end)

    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer and State.ESP.Enabled then
            CreateESPObjects(player)
            if State.ESP.Chams then ApplyChams(player) end
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        RemoveESPObjects(player)
    end)

    Window:SelectTab(1)
    Fluent:Notify({
        Title = "AIDA CHEAT v5.4",
        Content = "by Zao | Insert – меню, End – выгрузить.\nАимбот активируется зажатием ПКМ",
        Duration = 5
    })

    SaveManager:LoadAutoloadConfig()
end

pcall(AidaCheat)
