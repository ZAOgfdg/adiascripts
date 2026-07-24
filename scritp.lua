-- // AIDA CHEAT v5.2 – by Zao
-- // Fixed ESP, Chams, Watermark

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

    -- // ─── Состояния ──────────────────────────────────────────
    local State = {
        Aimbot = { Enabled = false, FOV = 120, Smoothness = 0, Part = "Head", TeamCheck = false, WallCheck = false },
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

    -- // ─── Переменные для модулей ─────────────────────────────
    local SpinAngle = 0
    local ESPDrawings = {}
    local ChamsHighlights = {}
    local MainLoopConnection = nil
    local Watermark = nil

    -- // ─── GUI: Окно ──────────────────────────────────────────
    local Window = Fluent:CreateWindow({
        Title = "✦ AIDA CHEAT v5.2",
        SubTitle = "by Zao",
        TabWidth = 130,
        Size = UDim2.fromOffset(540, 480),
        Acrylic = false,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    -- // ─── Водяной знак "by Zao" в правом нижнем углу ────────
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

    -- // ─── Удаление водяного знака при выгрузке ──────────────
    local function DestroyWatermark()
        if Watermark then
            pcall(function() Watermark:Destroy() end)
            Watermark = nil
        end
    end

    -- // ─── Вкладка Aimbot ──────────────────────────────────────
    local AimbotTab = Window:AddTab({ Title = "Aimbot", Icon = "crosshair" })
    local AimbotSection = AimbotTab:AddSection("Main")

    local AimbotToggle = AimbotSection:AddToggle("AimbotEnabled", {
        Title = "Enable Aimbot",
        Default = false,
        Callback = function(v) State.Aimbot.Enabled = v end
    })

    AimbotSection:AddSlider("AimbotFOV", {
        Title = "FOV",
        Default = 120,
        Min = 10,
        Max = 360,
        Rounding = 0,
        Callback = function(v) State.Aimbot.FOV = v end
    })

    AimbotSection:AddSlider("AimbotSmooth", {
        Title = "Smoothness (0 = instant)",
        Default = 0,
        Min = 0,
        Max = 30,
        Rounding = 0,
        Callback = function(v) State.Aimbot.Smoothness = v end
    })

    AimbotSection:AddDropdown("AimbotPart", {
        Title = "Target Part",
        Values = { "Head", "UpperTorso", "LowerTorso", "HumanoidRootPart" },
        Default = "Head",
        Callback = function(v) State.Aimbot.Part = v end
    })

    AimbotSection:AddToggle("AimbotTeamCheck", {
        Title = "Team Check",
        Default = false,
        Callback = function(v) State.Aimbot.TeamCheck = v end
    })

    AimbotSection:AddToggle("AimbotWallCheck", {
        Title = "Wall Check",
        Default = false,
        Callback = function(v) State.Aimbot.WallCheck = v end
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
                -- Полная очистка ESP-объектов
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
            -- удаляем все, если остались
            for player, _ in pairs(ESPDrawings) do
                RemoveESPObjects(player)
            end
            return
        end

        -- Создаём для новых игроков
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if not ESPDrawings[player] then
                    CreateESPObjects(player)
                end
                if State.ESP.Chams and not ChamsHighlights[player] then
                    ApplyChams(player)
                end
                if not State.ESP.Chams and ChamsHighlights[player] then
                    pcall(function() ChamsHighlights[player]:Destroy() end)
                    ChamsHighlights[player] = nil
                end
            end
        end

        -- Удаляем для исчезнувших
        for player, _ in pairs(ESPDrawings) do
            if not Players:FindFirstChild(player.Name) then
                RemoveESPObjects(player)
            end
        end

        -- Обновление позиций
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

    -- // ─── Логика Aimbot ──────────────────────────────────────
    local function FindTarget()
        local closest = nil
        local closestDist = State.Aimbot.FOV
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            if not player.Character then continue end
            local part = player.Character:FindFirstChild(State.Aimbot.Part)
            if not part then continue end
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then continue end
            if State.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then continue end
            if State.Aimbot.WallCheck then
                local obscured = #Camera:GetPartsObscuringTarget({part.Position}, player.Character:GetDescendants())
                if obscured > 0 then continue end
            end
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if not onScreen then continue end
            local mousePos = UserInputService:GetMouseLocation()
            local dist = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = player
            end
        end
        return closest
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

    -- // ─── Главный цикл ──────────────────────────────────────────
    local function MainLoop()
        if State.Aimbot.Enabled then
            local target = FindTarget()
            if target and target.Character then
                local part = target.Character:FindFirstChild(State.Aimbot.Part)
                if part then
                    local targetPos = part.Position
                    local currentCF = Camera.CFrame
                    local targetCF = CFrame.new(currentCF.Position, targetPos)
                    local smooth = State.Aimbot.Smoothness
                    if smooth == 0 then
                        Camera.CFrame = targetCF
                    else
                        local lerp = 1 / (smooth + 1)
                        Camera.CFrame = currentCF:Lerp(targetCF, lerp)
                    end
                end
            end
        end

        SpinbotLoop()
        UpdateESP()
    end

    -- // ─── Запуск и очистка ──────────────────────────────────────
    CreateWatermark()

    MainLoopConnection = RunService.RenderStepped:Connect(MainLoop)

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Insert then
            Window:Toggle()
        end
        if input.KeyCode == Enum.KeyCode.End then
            if MainLoopConnection then MainLoopConnection:Disconnect() end
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
        Title = "AIDA CHEAT v5.2",
        Content = "by Zao | Insert – меню, End – выгрузить.",
        Duration = 4
    })

    SaveManager:LoadAutoloadConfig()
end

pcall(AidaCheat)
