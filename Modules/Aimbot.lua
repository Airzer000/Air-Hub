-- Esp By serversadzz (discord)
local smoothness = 0.2
local fov = 40
local maxDistance = 400
local teamCheck = false
local wallCheck = false
local aimbotEnabled = false
local fovCircleEnabled = false
local chamsColor = Color3.fromRGB(170, 0, 255)
local espEnabled = true

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Cam = workspace.CurrentCamera
local localPlayer = Players.LocalPlayer

local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 2
FOVring.Color = chamsColor
FOVring.Filled = false
FOVring.Radius = fov
FOVring.Position = Cam.ViewportSize / 2

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function lookAtSmooth(targetPos)
    if not aimbotEnabled then return end
    local camPos = Cam.CFrame.Position
    local currentLook = Cam.CFrame.LookVector
    local targetLook = (targetPos - camPos).Unit
    local newLook = Vector3.new(
        lerp(currentLook.X, targetLook.X, smoothness),
        lerp(currentLook.Y, targetLook.Y, smoothness),
        lerp(currentLook.Z, targetLook.Z, smoothness)
    )
    Cam.CFrame = CFrame.new(camPos, camPos + newLook)
end

local function isPlayerAlive(player)
    local char = player.Character
    return char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0
end

local function isVisible(player, part)
    if not wallCheck then return true end
    local ray = Ray.new(Cam.CFrame.Position, (part.Position - Cam.CFrame.Position))
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {localPlayer.Character})
    return hit and hit:IsDescendantOf(player.Character)
end

local function getClosestInFOV()
    local closest = nil
    local shortest = math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and isPlayerAlive(player) and (not teamCheck or player.Team ~= localPlayer.Team) then
            local part = player.Character and player.Character:FindFirstChild("Head")
            if part then
                local screenPos, visible = Cam:WorldToViewportPoint(part.Position)
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Cam.ViewportSize/2).Magnitude
                if visible and dist < fov and dist < maxDistance and isVisible(player, part) and dist < shortest then
                    closest = player
                    shortest = dist
                end
            end
        end
    end
    return closest
end

local function updateESP(player)
    if not espEnabled then return end
    if player == localPlayer or not player.Character then return end
    local char = player.Character
    local head = char:FindFirstChild("Head")
    local humanoid = char:FindFirstChild("Humanoid")

    local highlight = char:FindFirstChild("ESP_Highlight") or Instance.new("Highlight", char)
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = char
    highlight.FillTransparency = 1
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.OutlineColor = player.Team and player.Team.TeamColor.Color or chamsColor

    local billboard = char:FindFirstChild("ESP_Name") or Instance.new("BillboardGui", char)
    billboard.Name = "ESP_Name"
    billboard.Size = UDim2.new(0, 120, 0, 20)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Adornee = head
    billboard.AlwaysOnTop = true

    local label = billboard:FindFirstChild("ESP_Label") or Instance.new("TextLabel", billboard)
    label.Name = "ESP_Label"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.TextStrokeTransparency = 1
    label.Text = ""
    label.TextColor3 = Color3.new(1,1,1)

    if humanoid then
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            local hp, max = math.floor(humanoid.Health), math.floor(humanoid.MaxHealth)
            local cor = hp > max*0.6 and Color3.new(0,1,0) or hp > max*0.3 and Color3.new(1,1,0) or Color3.new(1,0,0)
            label.Text = player.Name.." - "..hp.."/"..max
            label.TextColor3 = cor
        end)
    end
end

local function updateAllESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= localPlayer then
            if espEnabled then
                updateESP(plr)
            else
                local char = plr.Character
                if char then
                    local h = char:FindFirstChild("ESP_Highlight")
                    local b = char:FindFirstChild("ESP_Name")
                    if h then h:Destroy() end
                    if b then b:Destroy() end
                end
            end
        end
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    updateESP(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        updateESP(plr)
    end)
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        updateESP(plr)
    end)
end)

local Window = Rayfield:CreateWindow({
    Name = "Air Hub - Universal Aimbot",
    LoadingTitle = "Air Hub",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AirHubData",
        FileName = "AirHubConfig"
    }
})

local AimbotTab = Window:CreateTab("Aimbot", 4483362458)

AimbotTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Callback = function(v) aimbotEnabled = v end
})

AimbotTab:CreateToggle({
    Name = "Show FOV",
    CurrentValue = false,
    Callback = function(v) fovCircleEnabled = v end
})

AimbotTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Callback = function(v) teamCheck = v end
})

AimbotTab:CreateToggle({
    Name = "Wall Check",
    CurrentValue = false,
    Callback = function(v) wallCheck = v end
})

AimbotTab:CreateSlider({
    Name = "FOV",
    Range = {10, 200},
    Increment = 1,
    CurrentValue = fov,
    Callback = function(v) fov = v end
})

AimbotTab:CreateSlider({
    Name = "Smoothness",
    Range = {0.05, 1},
    Increment = 0.05,
    CurrentValue = smoothness,
    Callback = function(v) smoothness = v end
})

AimbotTab:CreateColorPicker({
    Name = "ESP Color",
    Color = chamsColor,
    Callback = function(color)
        chamsColor = color
        updateAllESP()
    end
})

AimbotTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = espEnabled,
    Callback = function(v)
        espEnabled = v
        updateAllESP()
    end
})

RunService.RenderStepped:Connect(function()
    FOVring.Position = Cam.ViewportSize / 2
    FOVring.Radius = fov
    FOVring.Visible = fovCircleEnabled
    updateAllESP()
    if aimbotEnabled then
        local target = getClosestInFOV()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            lookAtSmooth(target.Character.Head.Position)
        end
    end
end)

Rayfield:LoadConfiguration()
