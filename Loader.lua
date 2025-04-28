local repo = "Airzer000/Air-Hub" -- Nome do seu repositório
local branch = "main" -- Ou o nome da branch onde você está
local baseUrl = "https://raw.githubusercontent.com/"..repo.."/"..branch.."/"

local function loadModule(modulePath)
    return loadstring(game:HttpGet(baseUrl..modulePath))()
end

-- Carregar o Main.lua e outros módulos
loadstring(game:HttpGet(baseUrl.."Main.lua"))()
