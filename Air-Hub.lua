debugX = true

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Air Hub - Dead Rails & Universais",
   LoadingTitle = "Carregando Air Hub",
   LoadingSubtitle = "Interface por Rayfield",
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

-- ABA: Dead Rails
local DeadRails = Window:CreateTab("Dead Rails", 4483362458)

DeadRails:CreateButton({
   Name = "Skull Hub",
   Callback = function()
      loadstring(game:HttpGet('https://skullhub.xyz/loader.lua'))()
   end
})

DeadRails:CreateButton({
   Name = "Null Fire",
   Callback = function()
      loadstring(game:HttpGet("https://rawscripts.net/raw/Dead-Rails-Alpha-NullFire-32921"))()
   end
})

DeadRails:CreateButton({
   Name = "Tp To POI's",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/JonasThePogi/DeadRails/refs/heads/main/newloadstring"))();
   end
})

DeadRails:CreateButton({
   Name = "Tp To End (Tora)",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/refs/heads/main/DeadRails"))()
   end
})

DeadRails:CreateButton({
   Name = "Air Weld (press Y)",
   Callback = function()
      _G.key = "Y"
      _G.MobileButton = false
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Beru1337/DeadRails/refs/heads/main/betterweld.lua"))()
   end
})

-- ABA: Universal
local Universal = Window:CreateTab("Universal", 4483362458)

Universal:CreateButton({
   Name = "Vfly",
   Callback = function()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Vehicle%20Fly%20Gui'))()
   end
})

Universal:CreateButton({
   Name = "Aimbot Head",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Airzer000/Roblox-Ui-Test/refs/heads/main/Aimbot-Head.lua"))()
   end
})

Universal:CreateButton({
   Name = "Aimbot Torso",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Airzer000/Roblox-Ui-Test/refs/heads/main/Aimbot-Torso.lua"))()
   end
})

Rayfield:LoadConfiguration()
