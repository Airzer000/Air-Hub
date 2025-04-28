local repo = "Airzer000/Air-Hub"
local branch = "main"
local baseUrl = "https://raw.githubusercontent.com/"..repo.."/"..branch.."/"

local function loadModule(modulePath)
    local url = baseUrl..modulePath
    return loadstring(game:HttpGet(url))()
end

-- Carregar os módulos
loadModule("Modules/Aimbot.lua")
loadModule("Modules/ESP.lua")
loadModule("Main/Main.lua")
