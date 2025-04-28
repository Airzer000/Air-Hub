local Aimbot = {}
local Players = game:GetService("Players")
local Cam = workspace.CurrentCamera

function Aimbot.lookAtSmooth(targetPos, Cam, Settings, Utils)
    if not Settings.AimbotEnabled then return end
    local camPos = Cam.CFrame.Position
    local currentLook = Cam.CFrame.LookVector
    local targetLook = (targetPos - camPos).Unit
    local newLook = Vector3.new(
        Utils.lerp(currentLook.X, targetLook.X, Settings.Smoothness),
        Utils.lerp(currentLook.Y, targetLook.Y, Settings.Smoothness),
        Utils.lerp(currentLook.Z, targetLook.Z, Settings.Smoothness)
    )
    Cam.CFrame = CFrame.new(camPos, camPos + newLook)
end

function Aimbot.isPlayerAlive(player)
    local character = player.Character
    return character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0
end

function Aimbot.isVisible(player, part, Cam, Settings)
    if not Settings.WallCheck then return true end
    local ray = Ray.new(Cam.CFrame.Position, (part.Position - Cam.CFrame.Position))
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {Players.LocalPlayer.Character})
    return hit and hit:IsDescendantOf(player.Character)
end

function Aimbot.getClosestPlayer(Cam, Settings)
    if not Settings.AimbotEnabled then return nil end
    local nearest, shortest = nil, math.huge
    local playerMousePos = Cam.ViewportSize / 2
    local localPlayer = Players.LocalPlayer

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and (not Settings.TeamCheck or player.Team ~= localPlayer.Team) and Aimbot.isPlayerAlive(player) then
            local part = player.Character and player.Character:FindFirstChild(Settings.AimPart)
            if part then
                local screenPos, visible = Cam:WorldToViewportPoint(part.Position)
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - playerMousePos).Magnitude

                if visible and distance < shortest and distance < Settings.FOV and distance < Settings.MaxDistance and Aimbot.isVisible(player, part, Cam, Settings) then
                    nearest = player
                    shortest = distance
                end
            end
        end
    end

    return nearest
end

return Aimbot
