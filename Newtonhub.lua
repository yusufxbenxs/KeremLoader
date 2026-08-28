-- Newton Hub V1.0.0 - Delta Mobile Optimized Version
Print("Just letting you know that Newton hub is running")
local Players = game:GetService("Players")
local RunService = Service or game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Delta Mobile CoreGui / PlayerGui safety fallback
local parentGui = (gethui and gethui()) or playerGui

if parentGui:FindFirstChild("NewtonHubComplete") then
    parentGui.NewtonHubComplete:Destroy()
end

local SAVED_GAME_SCRIPTS = {
    { TargetGame = "Universal", Name = "Fullbright & NoFog", Code = "game.Lighting.Brightness = 2\ngame.Lighting.GlobalShadows = false" },
    { TargetGame = "Universal", Name = "Infinite Jump", Code = "game:GetService('UserInputService').JumpRequest:Connect(function() game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)" },
    { TargetGame = "BedWars", Name = "BedWars Custom ESP", Code = "print('Running BedWars script...')" },
    { TargetGame = "Blox Fruits", Name = "Blox Fruits Auto Farm Test", Code = "print('Running Blox Fruits script...')" }
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NewtonHubComplete"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = parentGui

-- 1. MINIMIZED FLOATING ICON (Delta Touch Friendly)
local minIcon = Instance.new("TextButton")
minIcon.Size = UDim2.new(0, 48, 0, 48)
minIcon.Position = UDim2.new(0, 20, 0.4, 0)
minIcon.BackgroundColor3 = Color3.fromRGB(24, 20, 42)
minIcon.Text = "N"
minIcon.TextColor3 = Color3.fromRGB(220, 220, 230)
minIcon.Font = Enum.Font.GothamBold
minIcon.TextSize = 22
minIcon.Visible = false
minIcon.Active = true
minIcon.Draggable = true
minIcon.Parent = screenGui
Instance.new("UICorner", minIcon).CornerRadius = UDim.new(1, 0)

-- 2. MAIN WINDOW
local mainWindow = Instance.new("Frame")
mainWindow.Size = UDim2.new(0, 560, 0, 320)
mainWindow.Position = UDim2.new(0.5, -280, 0.5, -160)
mainWindow.BackgroundColor3 = Color3.fromRGB(18, 15, 30)
mainWindow.BorderSizePixel = 0
mainWindow.Active = true
mainWindow.Draggable = true
mainWindow.ClipsDescendants = true
mainWindow.Parent = screenGui
Instance.new("UICorner", mainWindow).CornerRadius = UDim.new(0, 10)

-- Titlebar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(24, 20, 42)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 5
titleBar.Parent = mainWindow
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local fixTitleCorner = Instance.new("Frame")
fixTitleCorner.Size = UDim2.new(1, 0, 0, 8)
fixTitleCorner.Position = UDim2.new(0, 0, 1, -8)
fixTitleCorner.BackgroundColor3 = Color3.fromRGB(24, 20, 42)
fixTitleCorner.BorderSizePixel = 0
fixTitleCorner.ZIndex = 5
fixTitleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0, 160, 1, 0)
titleText.Position = UDim2.new(0, 12, 0, 0)
titleText.BackgroundTransparency = 1
titleText.ZIndex = 5
titleText.Text = "Newton Hub"
titleText.TextColor3 = Color3.fromRGB(220, 220, 230)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 13
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

local successInfo, gameInfo = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
local actualGameName = (successInfo and gameInfo and gameInfo.Name) or "Game"

-- Window Controls
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 12, 0, 12)
closeBtn.Position = UDim2.new(1, -18, 0.5, -6)
closeBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
closeBtn.Text = ""
closeBtn.ZIndex = 5
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)
closeBtn.Activated:Connect(function() screenGui:Destroy() end)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 12, 0, 12)
minBtn.Position = UDim2.new(1, -38, 0.5, -6)
minBtn.BackgroundColor3 = Color3.fromRGB(241, 196, 15)
minBtn.Text = ""
minBtn.ZIndex = 5
minBtn.Parent = titleBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1, 0)

minBtn.Activated:Connect(function()
    mainWindow.Visible = false
    minIcon.Visible = true
end)

minIcon.Activated:Connect(function()
    minIcon.Visible = false
    mainWindow.Visible = true
end)

-- 3. SIDEBAR NAVIGATION & TABS
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 120, 1, -40)
sidebar.Position = UDim2.new(0, 8, 0, 36)
sidebar.BackgroundTransparency = 1
sidebar.ZIndex = 5
sidebar.Parent = mainWindow

local tabList = {"Execute", actualGameName .. " Tools", "Online scripts"}
local tabButtons = {}
local tabContainers = {}

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(0, 415, 1, -44)
contentArea.Position = UDim2.new(0, 135, 0, 38)
contentArea.BackgroundTransparency = 1
contentArea.ZIndex = 2
contentArea.Parent = mainWindow

for i, tabName in ipairs(tabList) do
    local rawKeyName = tabList[i]
    
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 32)
    tabBtn.Position = UDim2.new(0, 0, 0, (i - 1) * 38)
    tabBtn.BackgroundColor3 = (i == 1) and Color3.fromRGB(35, 28, 60) or Color3.fromRGB(28, 22, 48)
    tabBtn.Text = (i == 2) and "Game Tools" or tabName
    tabBtn.TextColor3 = (i == 1) and Color3.fromRGB(240, 240, 250) or Color3.fromRGB(140, 130, 160)
    tabBtn.Font = (i == 1) and Enum.Font.GothamBold or Enum.Font.GothamMedium
    tabBtn.TextSize = 11
    tabBtn.ZIndex = 5
    tabBtn.Parent = sidebar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
    tabButtons[rawKeyName] = tabBtn

    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    container.ScrollBarThickness = 3
    container.Visible = (i == 1)
    container.ZIndex = 2
    container.Parent = contentArea
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 6)
    listLayout.Parent = container
    
    tabContainers[rawKeyName] = container
end

for name, btn in pairs(tabButtons) do
    btn.Activated:Connect(function()
        for _, otherBtn in pairs(tabButtons) do
            otherBtn.BackgroundColor3 = Color3.fromRGB(28, 22, 48)
            otherBtn.TextColor3 = Color3.fromRGB(140, 130, 160)
            otherBtn.Font = Enum.Font.GothamMedium
        end
        for _, cont in pairs(tabContainers) do
            cont.Visible = false
        end
        btn.BackgroundColor3 = Color3.fromRGB(35, 28, 60)
        btn.TextColor3 = Color3.fromRGB(240, 240, 250)
        btn.Font = Enum.Font.GothamBold
        tabContainers[name].Visible = true
    end)
end

-- 4. EXECUTE TAB
local executeContainer = tabContainers["Execute"]

local editorBox = Instance.new("TextBox")
editorBox.Size = UDim2.new(1, 0, 0, 180)
editorBox.BackgroundColor3 = Color3.fromRGB(28, 22, 48)
editorBox.MultiLine = true
editorBox.ClearTextOnFocus = false
local placeholderTextStr = "Paste script here..."
editorBox.Text = placeholderTextStr
editorBox.TextColor3 = Color3.fromRGB(100, 90, 120)
editorBox.Font = Enum.Font.Code
editorBox.TextSize = 11
editorBox.TextXAlignment = Enum.TextXAlignment.Left
editorBox.TextYAlignment = Enum.TextYAlignment.Top
editorBox.ZIndex = 2
editorBox.Parent = executeContainer
Instance.new("UICorner", editorBox).CornerRadius = UDim.new(0, 6)

editorBox.Focused:Connect(function()
    if editorBox.Text == placeholderTextStr then
        editorBox.Text = ""
        editorBox.TextColor3 = Color3.fromRGB(180, 170, 200)
    end
end)

editorBox.FocusLost:Connect(function()
    if editorBox.Text == "" then
        editorBox.Text = placeholderTextStr
        editorBox.TextColor3 = Color3.fromRGB(100, 90, 120)
    end
end)

local execButtonRow = Instance.new("Frame")
execButtonRow.Size = UDim2.new(1, 0, 0, 32)
execButtonRow.BackgroundTransparency = 1
execButtonRow.ZIndex = 2
execButtonRow.Parent = executeContainer

local runBtn = Instance.new("TextButton")
runBtn.Size = UDim2.new(0, 120, 1, 0)
runBtn.BackgroundColor3 = Color3.fromRGB(35, 28, 60)
runBtn.Text = "Run"
runBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
runBtn.Font = Enum.Font.GothamBold
runBtn.TextSize = 12
runBtn.ZIndex = 2
runBtn.Parent = execButtonRow
Instance.new("UICorner", runBtn).CornerRadius = UDim.new(0, 6)

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, 120, 1, 0)
clearBtn.Position = UDim2.new(0, 130, 0, 0)
clearBtn.BackgroundColor3 = Color3.fromRGB(28, 22, 48)
clearBtn.Text = "Clear"
clearBtn.TextColor3 = Color3.fromRGB(170, 160, 190)
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextSize = 12
clearBtn.ZIndex = 2
clearBtn.Parent = execButtonRow
Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0, 6)

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, 0, 0, 18)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "Status: Ready"
statusLbl.TextColor3 = Color3.fromRGB(140, 130, 160)
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextSize = 11
statusLbl.ZIndex = 2
statusLbl.Parent = executeContainer

-- 5. GAME TOOLS TAB (Game Scripts + Universal Scripts Combined Here)
local toolsContainer = tabContainers[actualGameName .. " Tools"]

local secHeader = Instance.new("TextLabel")
secHeader.Size = UDim2.new(1, 0, 0, 20)
secHeader.BackgroundTransparency = 1
secHeader.Text = "📌 Available Scripts (Game & Universal)"
secHeader.TextColor3 = Color3.fromRGB(220, 210, 240)
secHeader.Font = Enum.Font.GothamBold
secHeader.TextSize = 12
secHeader.TextXAlignment = Enum.TextXAlignment.Left
secHeader.ZIndex = 2
secHeader.Parent = toolsContainer

for _, scriptData in ipairs(SAVED_GAME_SCRIPTS) do
    if scriptData.TargetGame == actualGameName or scriptData.TargetGame == "Universal" then
        local scriptCard = Instance.new("Frame")
        scriptCard.Size = UDim2.new(1, 0, 0, 38)
        scriptCard.BackgroundColor3 = Color3.fromRGB(28, 22, 48)
        scriptCard.ZIndex = 2
        scriptCard.Parent = toolsContainer
        Instance.new("UICorner", scriptCard).CornerRadius = UDim.new(0, 6)
        
        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, -90, 1, 0)
        nameLbl.Position = UDim2.new(0, 10, 0, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = "[" .. scriptData.TargetGame .. "] " .. scriptData.Name
        nameLbl.TextColor3 = Color3.fromRGB(190, 180, 210)
        nameLbl.Font = Enum.Font.GothamMedium
        nameLbl.TextSize = 11
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.ZIndex = 2
        nameLbl.Parent = scriptCard
        
        local execCardBtn = Instance.new("TextButton")
        execCardBtn.Size = UDim2.new(0, 75, 0, 26)
        execCardBtn.Position = UDim2.new(1, -82, 0.5, -13)
        execCardBtn.BackgroundColor3 = Color3.fromRGB(45, 35, 75)
        execCardBtn.Text = "Execute"
        execCardBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
        execCardBtn.Font = Enum.Font.GothamBold
        execCardBtn.TextSize = 11
        execCardBtn.ZIndex = 2
        execCardBtn.Parent = scriptCard
        Instance.new("UICorner", execCardBtn).CornerRadius = UDim.new(0, 4)
        
        execCardBtn.Activated:Connect(function()
            local success = pcall(function()
                local func = loadstring(scriptData.Code)
                if func then task.spawn(func) end
            end)
            if success then
                statusLbl.Text = "Status: Ran [" .. scriptData.Name .. "]"
                statusLbl.TextColor3 = Color3.fromRGB(46, 204, 113)
            else
                statusLbl.Text = "Status: Execution error."
                statusLbl.TextColor3 = Color3.fromRGB(231, 76, 60)
            end
        end)
    end
end

-- 6. EXECUTION HANDLERS
runBtn.Activated:Connect(function()
    local code = editorBox.Text
    if code == placeholderTextStr or code == "" then
        statusLbl.Text = "Status: No script provided."
        statusLbl.TextColor3 = Color3.fromRGB(231, 76, 60)
        return
    end

    local success = pcall(function()
        local func = loadstring(code)
        if func then task.spawn(func) end
    end)
    
    if success then
        statusLbl.Text = "Status: Successfully ran script!"
        statusLbl.TextColor3 = Color3.fromRGB(46, 204, 113)
    else
        statusLbl.Text = "Status: Execution error."
        statusLbl.TextColor3 = Color3.fromRGB(231, 76, 60)
    end
end)

clearBtn.Activated:Connect(function()
    editorBox.Text = ""
    statusLbl.Text = "Status: Editor cleared."
    statusLbl.TextColor3 = Color3.fromRGB(170, 160, 190)
end)
