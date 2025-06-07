-- Serviços
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local workspaceService = cloneref(workspace)

-- Criação do "Gayze" invisível, se não existir
local part = workspaceService:FindFirstChild("Gayze")
if not part then
    local newPart = Instance.new("Part")
    newPart.Name = "Gayze"
    newPart.Size = Vector3.new(0, 5, 0)
    newPart.Position = Vector3.new(5, 5, 5)
    newPart.Transparency = 1
    newPart.CanCollide = false
    newPart.Anchored = true
    newPart.Parent = workspaceService
end

local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local hum = character:WaitForChild("Humanoid")

local VAMPIRE_CASTLE_POS = Vector3.new(60, 5, -9000)
local MAX_RADIUS = 1000
local SEAT_CHECK_INTERVAL = 0.2

local function isUnanchored(m)
    for _, p in pairs(m:GetDescendants()) do
        if p:IsA("BasePart") and not p.Anchored then
            return true
        end
    end
    return false
end

local function isNearCastle(model)
    local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    if not primary then return false end
    return (primary.Position - VAMPIRE_CASTLE_POS).Magnitude < MAX_RADIUS
end

local function findVCMaximGun()
    local searchParents = {}
    if workspace:FindFirstChild("VampireCastle") then
        table.insert(searchParents, workspace.VampireCastle)
        if workspace.VampireCastle:FindFirstChild("CastleLoot") then
            table.insert(searchParents, workspace.VampireCastle.CastleLoot)
        end
    end
    if workspace:FindFirstChild("RuntimeItems") then
        table.insert(searchParents, workspace.RuntimeItems)
    end
    for _, parent in ipairs(searchParents) do
        for _, obj in ipairs(parent:GetDescendants()) do
            if obj:IsA("Model") and obj.Name:lower():find("maximgun") and isUnanchored(obj) and isNearCastle(obj) then
                local seat = obj:FindFirstChildWhichIsA("VehicleSeat", true) or obj:FindFirstChildWhichIsA("Seat", true)
                if seat and not seat.Occupant then
                    return obj, seat
                end
            end
        end
    end
    return nil, nil
end

root.CFrame = CFrame.new(VAMPIRE_CASTLE_POS)

repeat task.wait(0.5) until workspace:FindFirstChild("RuntimeItems")
repeat task.wait(0.5) until #workspace.RuntimeItems:GetChildren() > 0

local lockedPos = root.CFrame
local foundMaximGun, seat
repeat
    root.CFrame = lockedPos
    foundMaximGun, seat = findVCMaximGun()
    task.wait(SEAT_CHECK_INTERVAL)
until foundMaximGun and seat

hum.JumpPower = 0
hum.JumpHeight = 0

local function confirmSeated(seat)
    local maxWait = 2
    local timer = 0
    while hum.SeatPart ~= seat and not hum.Sit and timer < maxWait do
        task.wait(0.1)
        timer += 0.1
    end
    if hum.SeatPart == seat and hum.Sit then
        hum.Jump = true
        task.wait(1)
        hum.Jump = false
        task.spawn(function()
            while hum.SeatPart == seat and hum.Sit do
                if not root:FindFirstChild("MaximGunWeld") then
                    local weld = Instance.new("WeldConstraint")
                    weld.Name = "MaximGunWeld"
                    weld.Part0 = root
                    weld.Part1 = seat
                    weld.Parent = root
                end
                root.CFrame = seat.CFrame
                task.wait(0.2)
            end
        end)
    end
end

root.CFrame = seat.CFrame
seat:Sit(hum)
task.delay(1, function() confirmSeated(seat) end)

-- Interface removida: créditos

local lockedY = root.Position.Y
task.spawn(function()
    while true do
        if root and root.Parent then
            if hum.SeatPart == seat and seat.Occupant == hum then
                root.CFrame = seat.CFrame
                lockedY = seat.Position.Y
            else
                local pos = root.Position
                root.CFrame = CFrame.new(pos.X, lockedY, pos.Z)
                seat:Sit(hum)
            end
        end
        task.wait(0.2)
    end
end)

local activateRemote = ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Network"):WaitForChild("RemotePromise"):WaitForChild("Remotes"):WaitForChild("C_ActivateObject")

local function findNearestBond()
    local closest, shortestDist = nil, math.huge
    local itemsFolder = workspace.RuntimeItems
    if not itemsFolder then return nil end
    for _, item in ipairs(itemsFolder:GetChildren()) do
        if item:IsA("Model") and item.Name:lower() == "bond" then
            local primary = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")
            if primary then
                local dist = (primary.Position - root.Position).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closest = item
                end
            end
        end
    end
    return closest
end

local bondCount = 0
local targetCount = 123
local function teleportTo(bond)
    local primary = bond.PrimaryPart or bond:FindFirstChildWhichIsA("BasePart")
    if not primary then return end
    seat.CFrame = primary.CFrame + Vector3.new(0, 5, 0)
    local startTime = os.clock()
    while bond.Parent and os.clock() - startTime < 1 do
        activateRemote:FireServer(bond)
        task.wait(0.08)
    end
    if not bond.Parent then
        bondCount += 1
    end
end

repeat task.wait(0.5) until workspace.RuntimeItems and #workspace.RuntimeItems:GetChildren() > 0

while bondCount < targetCount do
    local bond = findNearestBond()
    if bond then
        teleportTo(bond)
    else
        break
    end
    task.wait(0.01)
end

-- Scanner de camada
local layerSize = 2048
local halfSize = layerSize / 2
local xStart = -halfSize
local xEnd = halfSize
local yScan = -50
local zStart = 30000
local zEnd = -49872
local zStep = -layerSize
local zPos = zStart
local direction = 1

while bondCount < targetCount and ((zStep < 0 and zPos >= zEnd) or (zStep > 0 and zPos <= zEnd)) do
    local x1 = (direction == 1) and xStart or xEnd
    local x2 = (direction == 1) and xEnd or xStart

    seat.CFrame = CFrame.new(x1, yScan, zPos)
    task.wait(0.1)
    local bond = findNearestBond()
    while bond and bondCount < targetCount do
        teleportTo(bond)
        bond = findNearestBond()
    end

    seat.CFrame = CFrame.new(x2, yScan, zPos)
    task.wait(0.1)
    bond = findNearestBond()
    while bond and bondCount < targetCount do
        teleportTo(bond)
        bond = findNearestBond()
    end

    zPos += zStep
    direction *= -1
end

-- Interface de crédito final REMOVIDA

task.wait(5.5)
TeleportService:Teleport(116495829188952, LocalPlayer)