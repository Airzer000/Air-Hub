-- Air Hub by Airzer
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Air Hub | Discord: Diego_144",
   LoadingTitle = "Air Hub: Made by Diego_144",
   LoadingSubtitle = "Made by Airzero",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "AirHub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false
})

-- Dead Rails Tab
local DeadRailsTab = Window:CreateTab("Dead Rails", 4483362458)

DeadRailsTab:CreateButton({
   Name = "Skull Hub",
   Callback = function()
      loadstring(game:HttpGet('https://skullhub.xyz/loader.lua'))()
   end,
})

DeadRailsTab:CreateButton({
   Name = "Null Fire",
   Callback = function()
      loadstring(game:HttpGet("https://rawscripts.net/raw/Dead-Rails-Alpha-NullFire-32921"))()
   end,
})

DeadRailsTab:CreateButton({
   Name = "Tp to POIs",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/JonasThePogi/DeadRails/refs/heads/main/newloadstring"))();
   end,
})

DeadRailsTab:CreateButton({
   Name = "Tp to End (Tora)",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/refs/heads/main/DeadRails"))()
   end,
})

DeadRailsTab:CreateButton({
   Name = "Air Weld (Press Y)",
   Callback = function()
      _G.key = "Y"
      _G.MobileButton = false
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Beru1337/DeadRails/refs/heads/main/betterweld.lua"))()
   end,
})

-- Universal Tab
local UniversalTab = Window:CreateTab("Universal", 4483362458)

UniversalTab:CreateButton({
   Name = "VFly",
   Callback = function()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Vehicle%20Fly%20Gui'))()
   end,
})

UniversalTab:CreateButton({
   Name = "Aimbot Head",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Airzer000/Air-Hub/refs/heads/main/Aimbot-Head.lua"))()
   end,
})

UniversalTab:CreateButton({
   Name = "Aimbot Torso",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Airzer000/Air-Hub/refs/heads/main/Aimbot-Torso.lua"))()
   end,
})

Rayfield:LoadConfiguration()