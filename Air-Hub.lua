debugX = true

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Air Hub By: Diego_144 (Discord)",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Airhub is Loading",
   LoadingSubtitle = "by Diego_144",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local DeadRailsTab = Window:CreateTab("Dead Rails", 4483362458) -- Title, Image

-- Scripts for Dead Rails Tab

local AirWeldButton = DeadRailsTab:CreateButton({
   Name = "Air Weld (press Y)",
   Callback = function()
      -- Better Weld v1.0 - Made By Beru
      _G.key = "Y" -- Change key if you have some issue
      _G.MobileButton = false -- Activate/Desactivate Mobile Button

      loadstring(game:HttpGet("https://raw.githubusercontent.com/Beru1337/DeadRails/refs/heads/main/betterweld.lua"))()
   end,
})

local SkullHubButton = DeadRailsTab:CreateButton({
   Name = "Skull Hub",
   Callback = function()
      loadstring(game:HttpGet('https://skullhub.xyz/loader.lua'))()
   end,
})

local NullFireButton = DeadRailsTab:CreateButton({
   Name = "Null Fire",
   Callback = function()
      loadstring(game:HttpGet("https://rawscripts.net/raw/Dead-Rails-Alpha-NullFire-32921"))()
   end,
})

local TpToPOIsButton = DeadRailsTab:CreateButton({
   Name = "Tp To POI's",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/JonasThePogi/DeadRails/refs/heads/main/newloadstring"))()
   end,
})

local TpToEndButton = DeadRailsTab:CreateButton({
   Name = "Tp to end (Tora)",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/refs/heads/main/DeadRails"))()
   end,
})

-- Universal Tab with Vfly Script

local UniversalTab = Window:CreateTab("Universal", 4483362458) -- Title, Image

local VflyButton = UniversalTab:CreateButton({
   Name = "Vfly",
   Callback = function()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Vehicle%20Fly%20Gui'))()
   end,
})

Rayfield:LoadConfiguration()