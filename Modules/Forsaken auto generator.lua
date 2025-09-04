--// Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

--// Configurações iniciais
local staminaMax = 100
local staminaRefresh = 0.2
local generatorCooldown = 1.25
local generators = {}
local espObjects = {}
local autoGeradores = false
local autoThread
local completarAtivo = false
local completeButton

--// Controle ESP Killers e Survivors
local espEnabledKillers = true
local espEnabledSurvivors = true

-- Função geral de ESP
local function createESPTag(adornPart, text, color)
    if not adornPart or not adornPart.Parent then return end
    if adornPart:FindFirstChild("ESPTag") then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPTag"
    billboard.Size = UDim2.new(0, 100, 0, 25)
    billboard.AlwaysOnTop = true
    billboard.Adornee = adornPart
    billboard.StudsOffset = Vector3.new(0, 2, 0)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color
    lbl.TextStrokeTransparency = 0.3
    lbl.Font = Enum.Font.Ubuntu
    lbl.TextScaled = true
    lbl.TextWrapped = true
    lbl.Parent = billboard

    billboard.Parent = adornPart
end

-- ESP Killers & Survivors
local function applyESP(folder, color, enabled)
    if not folder then return end
    for _, obj in pairs(folder:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Head") then
            if enabled then
                createESPTag(obj.Head, obj.Name, color)
            else
                if obj.Head:FindFirstChild("ESPTag") then
                    obj.Head.ESPTag:Destroy()
                end
            end
        end
    end
end

local function updateESPPlayers()
    applyESP(workspace.Players:FindFirstChild("Killers"), Color3.fromRGB(255,0,0), espEnabledKillers)
    applyESP(workspace.Players:FindFirstChild("Survivors"), Color3.fromRGB(0,255,0), espEnabledSurvivors)
end

-- ESP Geradores
local function createGeneratorESP(part)
    if not part or not part.Parent then return end
    createESPTag(part, "⚡ Gerador", Color3.fromRGB(0,255,0))
    table.insert(espObjects, part)
end

local function clearGeneratorESP()
    for _, gen in ipairs(espObjects) do
        if gen:FindFirstChild("ESPTag") then
            gen.ESPTag:Destroy()
        end
    end
    espObjects = {}
end

local function updateGenerators()
    clearGeneratorESP()
    generators = {}
    local mapModel = workspace:WaitForChild("Map"):WaitForChild("Ingame"):WaitForChild("Map")
    for _, obj in ipairs(mapModel:GetChildren()) do
        if obj:FindFirstChild("Positions") and obj.Positions:FindFirstChild("Center") then
            local genPart = obj.Positions.Center
            table.insert(generators, genPart)
            createGeneratorESP(genPart)
        end
    end
end

-- Atualizações contínuas
RunService.RenderStepped:Connect(function()
    updateESPPlayers()
    local changed = false
    for _, gen in ipairs(generators) do
        if not gen.Parent then
            changed = true
            break
        end
    end
    if changed then
        updateGenerators()
    end
end)

workspace.Map.Ingame.ChildAdded:Connect(function(child)
    if child.Name == "Map" then
        task.wait(1)
        updateGenerators()
    end
end)

updateGenerators()
updateESPPlayers()

--// Interface
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "ConfigGUI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 360, 0, 330)
frame.Position = UDim2.new(0.5, -180, 0.5, -165)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)

local title = Instance.new("TextLabel", frame)
title.Text = "Configurações"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local function createSetting(parent, yPos, labelText, defaultValue, onChange)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Text = labelText
    lbl.Size = UDim2.new(1, -40, 0, 20)
    lbl.Position = UDim2.new(0, 20, 0, yPos)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local box = Instance.new("TextBox", parent)
    box.Text = tostring(defaultValue)
    box.Size = UDim2.new(1, -40, 0, 28)
    box.Position = UDim2.new(0, 20, 0, yPos + 22)
    box.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    box.TextColor3 = Color3.new(1,1,1)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then
            onChange(val, box)
        end
    end)

    return box
end

local staminaBox = createSetting(frame, 50, "Stamina Máxima", staminaMax, function(val)
    staminaMax = val
end)

local refreshBox = createSetting(frame, 100, "Refresh da Stamina (s)", staminaRefresh, function(val)
    staminaRefresh = val
end)

local cooldownBox
cooldownBox = createSetting(frame, 150, "Cooldown dos Geradores (s)", generatorCooldown, function(val, box)
    generatorCooldown = math.max(1.25, val)
    if box then box.Text = tostring(generatorCooldown) end
end)

local updateBtn = Instance.new("TextButton", frame)
updateBtn.Size = UDim2.new(0.9, 0, 0, 30)
updateBtn.Position = UDim2.new(0.05, 0, 0, 200)
updateBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
updateBtn.Text = "🔄 Atualizar ESP & TP"
updateBtn.TextColor3 = Color3.new(1,1,1)
updateBtn.Font = Enum.Font.GothamBold
updateBtn.TextSize = 14
Instance.new("UICorner", updateBtn).CornerRadius = UDim.new(0, 8)
updateBtn.MouseButton1Click:Connect(function()
    updateGenerators()
    updateESPPlayers()
end)

--// Restante: auto geradores, teleport, completar (igual seu código original)
-- ... (mantém igual, já que a alteração principal foi no ESP)

local autoBtn = Instance.new("TextButton", frame)
autoBtn.Size = UDim2.new(0.9, 0, 0, 30)
autoBtn.Position = UDim2.new(0.05, 0, 0, 240)
autoBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
autoBtn.Text = "⚡ Auto Geradores: OFF"
autoBtn.TextColor3 = Color3.new(1,1,1)
autoBtn.Font = Enum.Font.GothamBold
autoBtn.TextSize = 14
Instance.new("UICorner", autoBtn).CornerRadius = UDim.new(0, 8)

local function setCompleteLocked(locked)
    if not completeButton then return end
    completeButton.Active = not locked
    completeButton.Selectable = not locked
    if completeButton:FindFirstChild("LockStroke") then
        completeButton.LockStroke:Destroy()
    end
    if locked then
        completeButton.Text = "⚡ Completar"
        completeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        completeButton.TextTransparency = 0.2
        completeButton.AutoButtonColor = false
        local stroke = Instance.new("UIStroke")
        stroke.Name = "LockStroke"
        stroke.Parent = completeButton
        stroke.Thickness = 2
        stroke.Color = Color3.fromRGB(160, 60, 60)
    else
        completeButton.Text = "⚡ Completar"
        completeButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        completeButton.TextTransparency = 0
        completeButton.AutoButtonColor = true
    end
end

autoBtn.MouseButton1Click:Connect(function()
    if completarAtivo then
        warn("❌ Aguarde o finalizar manual terminar para alterar o Auto.")
        return
    end

    autoGeradores = not autoGeradores
    autoBtn.Text = autoGeradores and "⚡ Auto Geradores: ON" or "⚡ Auto Geradores: OFF"
    setCompleteLocked(autoGeradores)

    if autoGeradores and not autoThread then
        autoThread = task.spawn(function()
            while autoGeradores do
                if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame") and workspace.Map.Ingame:FindFirstChild("Map") then
                    for _, v in ipairs(workspace.Map.Ingame.Map:GetChildren()) do
                        if v.Name == "Generator" and v:FindFirstChild("Remotes") and v.Remotes:FindFirstChild("RE") then
                            v.Remotes.RE:FireServer()
                        end
                    end
                end
                task.wait(generatorCooldown)
            end
            autoThread = nil
        end)
    end
end)

local function createFloatingButton(text, posY)
    local buttonGui = Instance.new("ScreenGui", game.CoreGui)
    local Button = Instance.new("TextButton", buttonGui)
    Button.Size = UDim2.new(0, 160, 0, 60)
    Button.Position = UDim2.new(0.5, -80, posY, -30)
    Button.Text = text
    Button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 18
    Button.Active = true
    Button.Draggable = true
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 25)

    local stroke = Instance.new("UIStroke", Button)
    stroke.Name = "RGBStroke"
    stroke.Thickness = 3
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(255, 0, 0)

    task.spawn(function()
        local t = 0
        while Button.Parent do
            t += 0.05
            local r = math.sin(t)*127+128
            local g = math.sin(t+2)*127+128
            local b = math.sin(t+4)*127+128
            stroke.Color = Color3.fromRGB(r,g,b)
            task.wait(0.03)
        end
    end)

    return Button
end

local configButton = createFloatingButton("⚙ Config", 0.75)
local configVisible = true
configButton.MouseButton1Click:Connect(function()
    configVisible = not configVisible
    frame.Visible = configVisible
end)

local tpButton = createFloatingButton("⚡ Teleport", 0.85)
tpButton.MouseButton1Click:Connect(function()
    if #generators > 0 then
        local randomGen = generators[math.random(1, #generators)]
        if randomGen and randomGen.Parent then
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            hrp.CFrame = randomGen.CFrame + Vector3.new(0, 3, 0)
        end
    end
end)

completeButton = createFloatingButton("⚡ Completar", 0.95)
local canClick = true
local webhookURL = "https://discord.com/api/webhooks/XXXX"

local function sendEmbed(username)
    local data = {
        embeds = {{
            title = "🔧 Gerador Concluído!",
            description = "**" .. username .. "** completou um gerador com sucesso!",
            color = 65280,
            footer = {text = "Sistema Automático"},
            timestamp = DateTime.now():ToIsoDate()
        }}
    }
    pcall(function()
        local requestFunc = request or syn and syn.request or http_request or (http and http.request)
        if requestFunc then
            requestFunc({
                Url = webhookURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(data)
            })
        end
    end)
end

completeButton.MouseButton1Click:Connect(function()
    if autoGeradores then
        warn("❌ Bloqueado: desligue o Auto Geradores para completar manualmente.")
        return
    end
    if not canClick then return end

    canClick = false
    completarAtivo = true
    completeButton.Text = "Aguarde..."

    if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame") and workspace.Map.Ingame:FindFirstChild("Map") then
        for _, v in ipairs(workspace.Map.Ingame.Map:GetChildren()) do
            if v.Name == "Generator" and v:FindFirstChild("Remotes") and v.Remotes:FindFirstChild("RE") then
                v.Remotes.RE:FireServer()
            end
        end
    end

    sendEmbed(LocalPlayer.Name)

    task.delay(generatorCooldown, function()
        completeButton.Text = "⚡ Completar"
        canClick = true
        completarAtivo = false
    end)
end)

setCompleteLocked(autoGeradores)

task.spawn(function()
    while true do
        local success, staminaModule = pcall(function()
            return require(
                game.ReplicatedStorage:WaitForChild("Systems")
                    :WaitForChild("Character")
                    :WaitForChild("Game")
                    :WaitForChild("Sprinting")
            )
        end)

        if success and staminaModule then
            staminaModule.MaxStamina = staminaMax
            staminaModule.Stamina = staminaMax
            if staminaModule.__staminaChangedEvent then
                staminaModule.__staminaChangedEvent:Fire(staminaModule.Stamina)
            end
        end

        task.wait(staminaRefresh)
    end
end)