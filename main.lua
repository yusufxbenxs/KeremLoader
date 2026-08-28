print("OK-KeremLoader")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local username = player.Name

if username == "doors274779" then
    pcall(function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/yusufxbenxs/Gamebuddy/refs/heads/main/Loader.lua'))()
    end)
    pcall(function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/yusufxbenxs/KeremLoader/refs/heads/main/Newtonhub.lua'))()
    end)

    -- Simple Xeno PC Desync Script
    local desynced = false
    local clone = nil

    local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    screenGui.Name = "DesyncGUI"
    screenGui.ResetOnSpawn = false

    local btn = Instance.new("TextButton", screenGui)
    btn.Size = UDim2.new(0, 140, 0, 45)
    btn.Position = UDim2.new(0, 50, 0, 50)
    btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    btn.Text = "Desync: OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local dragging, dragStart, startPos
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = btn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    btn.MouseButton1Click:Connect(function()
        desynced = not desynced
        btn.Text = desynced and "Desync: ON" or "Desync: OFF"
        btn.BackgroundColor3 = desynced and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        
        local char = player.Character
        if not char then return end
        
        if desynced then
            char.Archivable = true
            clone = char:Clone()
            clone.Parent = workspace
            for _, part in ipairs(clone:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Material = Enum.Material.Glass
                    part.Transparency = 0.5
                    part.Color = Color3.fromRGB(255, 0, 0)
                    part.CanCollide = false
                end
            end
        else
            if clone then
                clone:Destroy()
                clone = nil
            end
        end
    end)
end
