local ESP = {}
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Storage = Instance.new("Folder")
Storage.Name = "ESP_Storage"
Storage.Parent = CoreGui

local connections = {}

function ESP.CreateBox(player, Settings)
    local box = Drawing.new("Square")
    local name = Drawing.new("Text")

    box.Visible = false
    box.Color = Settings.ESPBoxColor
    box.Thickness = 2
    box.Transparency = 1
    box.Filled = false

    name.Visible = false
    name.Color = Settings.ESPNameColor
    name.Size = 16
    name.Center = true
    name.Outline = true
    name.Transparency = 1
    name.Font = 2 -- UI Font

    connections[player] = game:GetService("RunService").RenderStepped:Connect(function()
        if not Settings.ESPEnabled then
            box.Visible = false
            name.Visible = false
            return
        end

        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                local size = Vector2.new(40, 60) -- Tamanho fixo (pode ser adaptável)
                box.Size = size
                box.Position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
                box.Visible = true

                name.Text = player.Name
                name.Position = Vector2.new(pos.X, pos.Y - size.Y/2 - 15)
                name.Visible = true
            else
                box.Visible = false
                name.Visible = false
            end
        else
            box.Visible = false
            name.Visible = false
        end
    end)
end

function ESP.RemoveBox(player)
    if connections[player] then
        connections[player]:Disconnect()
        connections[player] = nil
    end
end

function ESP.Setup(Settings)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            ESP.CreateBox(player, Settings)
        end
    end

    Players.PlayerAdded:Connect(function(player)
        ESP.CreateBox(player, Settings)
    end)

    Players.PlayerRemoving:Connect(function(player)
        ESP.RemoveBox(player)
    end)
end

return ESP
