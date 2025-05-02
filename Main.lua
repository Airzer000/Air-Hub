-- Initial Configurations
local debugX = true

local smoothness = 0.2
local fov = 40
local maxDistance = 400
local teamCheck = false
local wallCheck = false
local aimPart = "Head"
local chamsEnabled = false
local aimbotEnabled = false
local fovCircleEnabled = false
local chamsColor = Color3.fromRGB(170, 0, 255)

-- Services
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Cam = workspace.CurrentCamera

-- FOV Drawing
local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 2
FOVring.Color = chamsColor
FOVring.Filled = false
FOVring.Radius = fov
FOVring.Position = Cam.ViewportSize / 2

-- Utility Functions
local function lerp(a, b, t)
    return a + (b - a) * t
end

local function updateDrawings()
    FOVring.Position = Cam.ViewportSize / 2
    FOVring.Radius = fov
    FOVring.Visible = fovCircleEnabled
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
    local character = player.Character
    return character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0
end

local function isPlayerVisibleThroughWalls(player, trg_part)
    if not wallCheck then return true end

    local localChar = Players.LocalPlayer.Character
    if not localChar then return false end

    local part = player.Character and player.Character:FindFirstChild(trg_part)
    if not part then return false end

    local ray = Ray.new(Cam.CFrame.Position, (part.Position - Cam.CFrame.Position))
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {localChar})

    return hit and hit:IsDescendantOf(player.Character)
end

local function getClosestPlayerInFOV(trg_part)
    if not aimbotEnabled then return nil end
    local nearest = nil
    local last = math.huge
    local playerMousePos = Cam.ViewportSize / 2
    local localPlayer = Players.LocalPlayer

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and (not teamCheck or player.Team ~= localPlayer.Team) and isPlayerAlive(player) then
            local part = player.Character and player.Character:FindFirstChild(trg_part)
            if part then
                local ePos, visible = Cam:WorldToViewportPoint(part.Position)
                local distance = (Vector2.new(ePos.X, ePos.Y) - playerMousePos).Magnitude

                if distance < last and visible and distance < fov and distance < maxDistance and isPlayerVisibleThroughWalls(player, trg_part) then
                    last = distance
                    nearest = player
                end
            end
        end
    end

    return nearest
end

local function applyChams(player)
    if player == Players.LocalPlayer or not player.Character then return end

    for _, part in ipairs(player.Character:GetChildren()) do
        if part:IsA("BasePart") then
            local existing = part:FindFirstChild("ChamHighlight")
            if chamsEnabled then
                if not existing then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ChamHighlight"
                    highlight.FillColor = player.Team and player.Team.TeamColor.Color or chamsColor
                    highlight.OutlineTransparency = 1
                    highlight.FillTransparency = 0.5
                    highlight.Parent = part
                else
                    existing.FillColor = player.Team and player.Team.TeamColor.Color or chamsColor
                end
            elseif existing then
                existing:Destroy()
            end
        end
    end
end

-- Update all chams dynamically
local function updateAllChams()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            applyChams(player)
        end
    end
end

-- Player events
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        applyChams(player)
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function()
        task.wait(1)
        applyChams(player)
    end)
    applyChams(player)
end

-- Delete key removes FOV circle
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Delete then
        FOVring:Remove()
    end
end)

-- Main loop
RunService.RenderStepped:Connect(function()
    updateDrawings()
    updateAllChams()

    if aimbotEnabled then
        local target = getClosestPlayerInFOV(aimPart)
        if target and target.Character and target.Character:FindFirstChild(aimPart) then
            lookAtSmooth(target.Character[aimPart].Position)
        end
    end
end)

-- GUI
local Window = Rayfield:CreateWindow({
    Name = "Air Hub - Dead Rails, Universal & Aimbot",
    LoadingTitle = "Loading Air Hub",
    LoadingSubtitle = "Interface by Rayfield",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AirHubData",
        FileName = "AirHubConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "seuconvite",
        RememberJoins = true
    },
    KeySystem = false
})

-- Dead Rails Tab
local DeadRails = Window:CreateTab("Dead Rails", 4483362458)

DeadRails:CreateButton({ Name = "Skull Hub", Callback = function()
    loadstring(game:HttpGet('https://skullhub.xyz/loader.lua'))()
end})

DeadRails:CreateButton({ Name = "Null Fire", Callback = function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Dead-Rails-Alpha-NullFire-32921"))()
end})

DeadRails:CreateButton({ Name = "Tp To POI's", Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/JonasThePogi/DeadRails/refs/heads/main/newloadstring"))();
end})

DeadRails:CreateButton({ Name = "Tp To End (Tora)", Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/refs/heads/main/DeadRails"))()
end})

DeadRails:CreateButton({ Name = "Air Weld (press Y)", Callback = function()
    _G.key = "Y"
    _G.MobileButton = false
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Beru1337/DeadRails/refs/heads/main/betterweld.lua"))()
end})

-- Blox Fruits Tab
local BloxFruits = Window:CreateTab("Blox Fruits", 4483362458)

BloxFruits:CreateButton({
    Name = "Redz Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/newredz/BloxFruits/refs/heads/main/Source.luau"))(Settings)
    end
})

-- Universal Tab
local Universal = Window:CreateTab("Universal", 4483362458)

Universal:CreateButton({
    Name = "V Fly",
    Callback = function()

loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Vehicle%20Fly%20Gui'))()
    end
})

local Universal = Window:CreateTab("Universal", 4483362458)

Universal:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

Universal:CreateButton({
    Name = "FE Jerk Off",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
    end
})

Universal:CreateButton({
    Name = "Shaders Ultimate",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Pshade-Ultimate-26321"))()
    end
})

Universal:CreateButton({
    Name = "FPS Booster",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/8YZ2cc6V"))()
    end
})

-- Aimbot Tab
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)

AimbotTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Callback = function(state)
        aimbotEnabled = state
        Rayfield:Notify({
            Title = "Air Hub",
            Content = state and "Aimbot Enabled" or "Aimbot Disabled",
            Duration = 2
        })
    end
})

AimbotTab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = false,
    Callback = function(state)
        fovCircleEnabled = state
    end
})

AimbotTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Callback = function(state)
        teamCheck = state
    end
})

AimbotTab:CreateToggle({
    Name = "Wall Check",
    CurrentValue = false,
    Callback = function(state)
        wallCheck = state
    end
})

AimbotTab:CreateToggle({
    Name = "Chams",
    CurrentValue = false,
    Callback = function(state)
        chamsEnabled = state
        updateAllChams()
    end
})

AimbotTab:CreateColorPicker({
    Name = "Chams Color",
    Color = chamsColor,
    Callback = function(color)
        chamsColor = color
        updateAllChams()
    end
})

AimbotTab:CreateDropdown({
    Name = "Aim Part",
    Options = { "Head", "HumanoidRootPart" },
    CurrentOption = "Head",
    Callback = function(option)
        aimPart = option
    end
})

AimbotTab:CreateSlider({
    Name = "FOV",
    Range = {10, 200},
    Increment = 1,
    CurrentValue = fov,
    Callback = function(value)
        fov = value
    end
})

AimbotTab:CreateSlider({
    Name = "Smoothness",
    Range = {0.05, 1},
    Increment = 0.05,
    CurrentValue = smoothness,
    Callback = function(value)
        smoothness = value
    end
})

Rayfield:LoadConfiguration()
