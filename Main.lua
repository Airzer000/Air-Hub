-- Carregar Módulos
local Settings = require(script.Modules.Settings)
local Utils = require(script.Modules.Utils)
local Aimbot = require(script.Modules.Aimbot)
local ESP = require(script.Modules.ESP)

-- Configurar ESP
ESP.Setup(Settings)

-- Configurar Aimbot
Aimbot.Setup(Settings, Utils)

-- Setup completo
print("AirHub modular carregado com sucesso.")
