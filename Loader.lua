-- Defina o repositório e a branch
local repo = "Airzer000/Air-Hub"
local branch = "main"
local baseUrl = "https://raw.githubusercontent.com/"..repo.."/"..branch.."/"

-- Função para carregar módulos
local function loadModule(modulePath)
    return loadstring(game:HttpGet(baseUrl..modulePath))()
end

-- Carregando módulos específicos (exemplo)
loadModule("Main.lua") -- Carregar o Main.lua

-- Carregar os módulos adicionais
loadModule("Modules/Aimbot.lua")
loadModule("Modules/ESP.lua")
loadModule("Modules/Settings.lua")
loadModule("Modules/Utils.lua")
