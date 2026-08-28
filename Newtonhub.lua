-- Newton Hub V1.0.0 - Cross-Platform (PC & Mobile) Unified Version
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

local localPlayer = Players.LocalPlayer
local successHui, parentGui = pcall(function()
    return (gethui and gethui()) or localPlayer:WaitForChild("PlayerGui")
end)
if not successHui or not parentGui then
    parentGui = localPlayer:WaitForChild("PlayerGui")
end

if parentGui:FindFirstChild("NewtonHubComplete") then
    parentGui.NewtonHubComplete:Destroy()
end

-- ==========================================
-- PRE-SAVED SCRIPTS CONFIGURATION
-- ==========================================
local SAVED_GAME_SCRIPTS = {
    { TargetGame = "Universal", Name = "Fullbright & NoFog", Code = "game.Lighting.Brightness = 2\ngame.Lighting.GlobalShadows = false" },
    { TargetGame = "Universal", Name = "Infinite Jump", Code = "game:GetService('UserInputService').JumpRequest:Connect(function() game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)" },
    { TargetGame = "BedWars", Name = "BedWars Custom ESP", Code = "print('Running BedWars script...')" },
    { TargetGame = "Blox Fruits", Name = "Blox Fruits Auto Farm Test", Code = "print('Running Blox Fruits script...')" }
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NewtonHubComplete"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999999
screenGui.Parent = parentGui

-- ==========================================
-- 1. MINIMIZED "N" ICON (Draggable / Touch Friendly)
-- ==========================================
local minIcon = Instance.new("TextButton")
minIcon.Size = UDim2.new(0, 50, 0, 50)
minIcon.Position = UDim2.new(0, 30, 0.5, -25)
minIcon.BackgroundColor3 = Color3.fromRGB(24, 20, 42)
minIcon.Text = "N"
minIcon.TextColor3 = Color3.fromRGB(220, 220, 230)
minIcon.Font = Enum.Font.GothamBold
minIcon.TextSize = 24
minIcon.Visible = false
minIcon.Active = true
minIcon.Draggable = true
minIcon.Parent = screenGui
Instance.new("UICorner", minIcon).CornerRadius = UDim.new(1, 0)

-- ==========================================
-- 2. MAIN HUB WINDOW & MOVING STARRY BACKGROUND
-- ==========================================
local mainWindow = Instance.new("Frame")
mainWindow.Size = UDim2.new(0, 680, 0, 390)
mainWindow.Position = UDim2.new(0.5, -340, 0.5, -195)
mainWindow.BackgroundColor3 = Color3.fromRGB(18, 15, 30)
mainWindow.BorderSizePixel = 0
mainWindow.Active = true
mainWindow.Draggable = true
mainWindow.ClipsDescendants = true
mainWindow.Parent = screenGui
Instance.new("UICorner", mainWindow).CornerRadius = UDim.new(0, 12)

-- Procedural Moving Starry Background Generator
local starHolder = Instance.new("Folder")
starHolder.Name = "StarryBackground"
starHolder.Parent = mainWindow

math.randomseed(os.time())
local activeStars = {}

for i = 1, 40 do
    local star = Instance.new("Frame")
    local starSize = math.random(1, 3)
    star.Size = UDim2.new(0, starSize, 0, starSize)
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    star.BackgroundTransparency = math.random(20, 80) / 100
    star.BorderSizePixel = 0
    star.Parent = starHolder
    Instance.new("UICorner", star).CornerRadius = UDim.new(1, 0)
    
    table.insert(activeStars, {
        Object = star,
        Speed = math.random(8, 20) / 1000
    })
end

RunService.RenderStepped:Connect(function(dt)
    for _, starData in ipairs(activeStars) do
        local star = starData.Object
        if star and star.Parent then
            local currentPos = star.Position
            local newY = currentPos.Y.Scale - (starData.Speed * dt)
            
            if newY < -0.05 then
                star:Destroy()
                
                local newStar = Instance.new("Frame")
                local starSize = math.random(1, 3)
                newStar.Size = UDim2.new(0, starSize, 0, starSize)
                newStar.Position = UDim2.new(math.random(), 0, 1.05, 0)
                newStar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                newStar.BackgroundTransparency = math.random(20, 80) / 100
                newStar.BorderSizePixel = 0
                newStar.Parent = starHolder
                Instance.new("UICorner", newStar).CornerRadius = UDim.new(1, 0)
                
                starData.Object = newStar
            else
                star.Position = UDim2.new(currentPos.X.Scale, currentPos.X.Offset, newY, currentPos.Y.Offset)
            end
        end
    end
end)

-- Titlebar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(24, 20, 42)
titleBar.BorderSizePixel = 0
titleBar.ZIndex = 5
titleBar.Parent = mainWindow
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local fixTitleCorner = Instance.new("Frame")
fixTitleCorner.Size = UDim2.new(1, 0, 0, 10)
fixTitleCorner.Position = UDim2.new(0, 0, 1, -10)
fixTitleCorner.BackgroundColor3 = Color3.fromRGB(24, 20, 42)
fixTitleCorner.BorderSizePixel = 0
fixTitleCorner.ZIndex = 5
fixTitleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0, 200, 1, 0)
titleText.Position = UDim2.new(0, 14, 0, 0)
titleText.BackgroundTransparency = 1
titleText.ZIndex = 5
titleText.Text = "Newton Hub <font color=\"#888888\">V1.0.0</font>"
titleText.RichText = true
titleText.TextColor3 = Color3.fromRGB(220, 220, 230)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Game Name Pill in Titlebar with Live Game Icon
local gameBadge = Instance.new("Frame")
gameBadge.Size = UDim2.new(0, 210, 0, 26)
gameBadge.Position = UDim2.new(0.5, -105, 0.5, -13)
gameBadge.BackgroundColor3 = Color3.fromRGB(18, 15, 30)
gameBadge.ZIndex = 5
gameBadge.Parent = titleBar
Instance.new("UICorner", gameBadge).CornerRadius = UDim.new(1, 0)

local gameIconImg = Instance.new("ImageLabel")
gameIconImg.Size = UDim2.new(0, 18, 0, 18)
gameIconImg.Position = UDim2.new(0, 4, 0.5, -9)
gameIconImg.BackgroundTransparency = 1
gameIconImg.ZIndex = 5
gameIconImg.Image = "rbxassetid://6023426915"
gameIconImg.Parent = gameBadge
Instance.new("UICorner", gameIconImg).CornerRadius = UDim.new(0, 4)

task.spawn(function()
    local ok, info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
    if ok and info and info.IconImageAssetId and info.IconImageAssetId > 0 then
        gameIconImg.Image = "rbxassetid://" .. tostring(info.IconImageAssetId)
    end
end)

local successInfo, gameInfo = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
local actualGameName = (successInfo and gameInfo and gameInfo.Name) or "{GAME_NAME}"

local gameNameLbl = Instance.new("TextLabel")
gameNameLbl.Size = UDim2.new(1, -30, 1, 0)
gameNameLbl.Position = UDim2.new(0, 28, 0, 0)
gameNameLbl.BackgroundTransparency = 1
gameNameLbl.ZIndex = 5
gameNameLbl.Text = actualGameName
gameNameLbl.TextColor3 = Color3.fromRGB(180, 170, 200)
gameNameLbl.Font = Enum.Font.GothamMedium
gameNameLbl.TextSize = 11
gameNameLbl.TextXAlignment = Enum.TextXAlignment.Left
gameNameLbl.Parent = gameBadge

-- Window Controls (Mac style, touch responsive)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 14, 0, 14)
closeBtn.Position = UDim2.new(1, -22, 0.5, -7)
closeBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
closeBtn.Text = ""
closeBtn.ZIndex = 5
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)
closeBtn.Activated:Connect(function() screenGui:Destroy() end)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 14, 0, 14)
minBtn.Position = UDim2.new(1, -46, 0.5, -7)
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

-- ==========================================
-- 3. SIDEBAR NAVIGATION & TAB SYSTEM
-- ==========================================
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 130, 1, -45)
sidebar.Position = UDim2.new(0, 10, 0, 40)
sidebar.BackgroundTransparency = 1
sidebar.ZIndex = 5
sidebar.Parent = mainWindow

local tabList = {"Execute", actualGameName .. " Tools", "Clipboard", "Online scripts", "Settings", "About"}
local tabButtons = {}
local tabContainers = {}

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(0, 515, 1, -55)
contentArea.Position = UDim2.new(0, 150, 0, 45)
contentArea.BackgroundTransparency = 1
contentArea.ZIndex = 2
contentArea.Parent = mainWindow

for i, tabName in ipairs(tabList) do
    local rawKeyName = tabList[i]
    
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, 0, 0, 36)
    tabBtn.Position = UDim2.new(0, 0, 0, (i - 1) * 44)
    tabBtn.BackgroundColor3 = (i == 1) and Color3.fromRGB(35, 28, 60) or Color3.fromRGB(28, 22, 48)
    tabBtn.Text = (i == 2) and "{GAME} Tools" or tabName
    tabBtn.TextColor3 = (i == 1) and Color3.fromRGB(240, 240, 250) or Color3.fromRGB(140, 130, 160)
    tabBtn.Font = (i == 1) and Enum.Font.GothamBold or Enum.Font.GothamMedium
    tabBtn.TextSize = 12
    tabBtn.ZIndex = 5
    tabBtn.Parent = sidebar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8)
    tabButtons[rawKeyName] = tabBtn

    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    container.ScrollBarThickness = 4
    container.Visible = (i == 1)
    container.ZIndex = 2
    container.Parent = contentArea
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = container
    
    tabContainers[rawKeyName] = container
end

for name, btn in pairs(tabButtons) do
    btn.Activated:Connect(function()
        for otherName, otherBtn in pairs(tabButtons) do
            otherBtn.BackgroundColor3 = Color3.fromRGB(28, 22, 48)
            otherBtn.TextColor3 = Color3.fromRGB(140, 130, 160)
            otherBtn.Font = Enum.Font.GothamMedium
        }
        for _, cont in pairs(tabContainers) do
            cont.Visible = false
        end
        btn.BackgroundColor3 = Color3.fromRGB(35, 28, 60)
        btn.TextColor3 = Color3.fromRGB(240, 240, 250)
        btn.Font = Enum.Font.GothamBold
        tabContainers[name].Visible = true
    end)
end

-- ==========================================
-- 4. BUILD EXECUTE TAB CONTENT
-- ==========================================
local executeContainer = tabContainers["Execute"]

local editorBox = Instance.new("TextBox")
editorBox.Size = UDim2.new(1, 0, 0, 230)
editorBox.BackgroundColor3 = Color3.fromRGB(28, 22, 48)
editorBox.MultiLine = true
editorBox.ClearTextOnFocus = false
local placeholderTextStr = "Put your script here, then press Run.\n\nIf you want SS: Press Toggle Mode first, then press Run.\n\nIf you want to reset modes between local or SS: Press Toggle mode again to switch to local."
editorBox.Text = placeholderTextStr
editorBox.TextColor3 = Color3.fromRGB(100, 90, 120)
editorBox.Font = Enum.Font.Code
editorBox.TextSize = 12
editorBox.TextXAlignment = Enum.TextXAlignment.Left
editorBox.TextYAlignment = Enum.TextYAlignment.Top
editorBox.ZIndex = 2
editorBox.Parent = executeContainer
Instance.new("UICorner", editorBox).CornerRadius = UDim.new(0, 8)

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
execButtonRow.Size = UDim2.new(1, 0, 0, 40)
execButtonRow.BackgroundTransparency = 1
execButtonRow.ZIndex = 2
execButtonRow.Parent = executeContainer

local runBtn = Instance.new("TextButton")
runBtn.Size = UDim2.new(0, 150, 1, 0)
runBtn.BackgroundColor3 = Color3.fromRGB(28, 22, 48)
runBtn.Text = "Run"
runBtn.TextColor3 = Color3.fromRGB(170, 160, 190)
runBtn.Font = Enum.Font.GothamBold
runBtn.TextSize = 14
runBtn.ZIndex = 2
runBtn.Parent = execButtonRow
Instance.new("UICorner", runBtn).CornerRadius = UDim.new(0, 8)

local consoleBtn = Instance.new("TextButton")
consoleBtn.Size = UDim2.new(0, 150, 1, 0)
consoleBtn.Position = UDim2.new(0, 160, 0, 0)
consoleBtn.BackgroundColor3 = Color3.fromRGB(28, 22, 48)
consoleBtn.Text = "Console"
consoleBtn.TextColor3 = Color3.fromRGB(170, 160, 190)
consoleBtn.Font = Enum.Font.GothamBold
consoleBtn.TextSize = 14
consoleBtn.ZIndex = 2
consoleBtn.Parent = execButtonRow
Instance.new("UICorner", consoleBtn).CornerRadius = UDim.new(0, 8)

local toggleModeBtn = Instance.new("TextButton")
toggleModeBtn.Size = UDim2.new(0, 185, 1, 0)
toggleModeBtn.Position = UDim2.new(0, 320, 0, 0)
toggleModeBtn.BackgroundColor3 = Color3.fromRGB(28, 22, 48)
toggleModeBtn.Text = "Toggle Mode: Local/Backdoor"
toggleModeBtn.TextColor3 = Color3.fromRGB(170, 160, 190)
toggleModeBtn.Font = Enum.Font.GothamBold
toggleModeBtn.TextSize = 11
toggleModeBtn.ZIndex = 2
toggleModeBtn.Parent = execButtonRow
Instance.new("UICorner", toggleModeBtn).CornerRadius = UDim.new(0, 8)

local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, 0, 0, 20)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "Status: Ready"
statusLbl.TextColor3 = Color3.fromRGB(140, 130, 160)
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextSize = 11
statusLbl.ZIndex = 2
statusLbl.Parent = executeContainer

-- ==========================================
-- 5. BUILD {GAME} TOOLS TAB CONTENT (Game-Specific Only, Universal Excluded)
-- ==========================================
local toolsContainer = tabContainers[actualGameName .. " Tools"]

local sec1Header = Instance.new("TextLabel")
sec1Header.Size = UDim2.new(1, 0, 0, 24)
sec1Header.BackgroundTransparency = 1
sec1Header.Text = "📌 Saved Game Scripts (" .. actualGameName .. " Only)"
sec1Header.TextColor3 = Color3.fromRGB(220, 210, 240)
sec1Header.Font = Enum.Font.GothamBold
sec1Header.TextSize = 13
sec1Header.TextXAlignment = Enum.TextXAlignment.Left
sec1Header.ZIndex = 2
sec1Header.Parent = toolsContainer

local foundAnyMatch = false
for _, scriptData in ipairs(SAVED_GAME_SCRIPTS) do
    if scriptData.TargetGame == actualGameName then
        foundAnyMatch = true
        local scriptCard = Instance.new("Frame")
        scriptCard.Size = UDim2.new(1, 0, 0, 45)
        scriptCard.BackgroundColor3 = Color3.fromRGB(28, 22, 48)
        scriptCard.ZIndex = 2
        scriptCard.Parent = toolsContainer
        Instance.new("UICorner", scriptCard).CornerRadius = UDim.new(0, 8)
        
        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, -110, 1, 0)
        nameLbl.Position = UDim2.new(0, 12, 0, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = scriptData.Name
        nameLbl.TextColor3 = Color3.fromRGB(190, 180, 210)
        nameLbl.Font = Enum.Font.GothamMedium
        nameLbl.TextSize = 12
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.ZIndex = 2
        nameLbl.Parent = scriptCard
        
        local execCardBtn = Instance.new("TextButton")
        execCardBtn.Size = UDim2.new(0, 90, 0, 30)
        execCardBtn.Position = UDim2.new(1, -98, 0.5, -15)
        execCardBtn.BackgroundColor3 = Color3.fromRGB(45, 35, 75)
        execCardBtn.Text = "Execute"
        execCardBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
        execCardBtn.Font = Enum.Font.GothamBold
        execCardBtn.TextSize = 12
        execCardBtn.ZIndex = 2
        execCardBtn.Parent = scriptCard
        Instance.new("UICorner", execCardBtn).CornerRadius = UDim.new(0, 6)
        
        execCardBtn.Activated:Connect(function()
            local success, err = pcall(function()
                local func = loadstring(scriptData.Code)
                if func then task.spawn(func) end
            end)
            if success then
                statusLbl.Text = "Status: Ran saved script [" .. scriptData.Name .. "]"
                statusLbl.TextColor3 = Color3.fromRGB(46, 204, 113)
            else
                statusLbl.Text = "Status: Error running saved script."
                statusLbl.TextColor3 = Color3.fromRGB(231, 76, 60)
            end
        end)
    end
end

if not foundAnyMatch then
    local noMatchLbl = Instance.new("TextLabel")
    noMatchLbl.Size = UDim2.new(1, 0, 0, 30)
    noMatchLbl.BackgroundTransparency = 1
    noMatchLbl.Text = "No specific saved scripts found for this game."
    noMatchLbl.TextColor3 = Color3.fromRGB(140, 130, 160)
    noMatchLbl.Font = Enum.Font.GothamItalic
    noMatchLbl.TextSize = 12
    noMatchLbl.TextXAlignment = Enum.TextXAlignment.Left
    noMatchLbl.ZIndex = 2
    noMatchLbl.Parent = toolsContainer
end

-- Section Header 2: Online Scripts
local sec2Header = Instance.new("TextLabel")
sec2Header.Size = UDim2.new(1, 0, 0, 30)
sec2Header.BackgroundTransparency = 1
sec2Header.Text = "🌐 Online Community Scripts"
sec2Header.TextColor3 = Color3.fromRGB(220, 210, 240)
sec2Header.Font = Enum.Font.GothamBold
sec2Header.TextSize = 13
sec2Header.TextXAlignment = Enum.TextXAlignment.Left
sec2Header.ZIndex = 2
sec2Header.Parent = toolsContainer

local onlineScriptsList = Instance.new("Frame")
onlineScriptsList.Size = UDim2.new(1, 0, 0, 120)
onlineScriptsList.BackgroundTransparency = 1
onlineScriptsList.ZIndex = 2
onlineScriptsList.Parent = toolsContainer

local onlineLayout = Instance.new("UIListLayout")
onlineLayout.SortOrder = Enum.SortOrder.LayoutOrder
onlineLayout.Padding = UDim.new(0, 6)
onlineLayout.Parent = onlineScriptsList

task.spawn(function()
    local success, response = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/visiven/NewtonHub-OnlineScripts/main/scripts.json")
    end)
    
    if success and response then
        local okDecode, scriptArray = pcall(function() return HttpService:JSONDecode(response) end)
        if okDecode and type(scriptArray) == "table" then
            for _, onlineData in ipairs(scriptArray) do
                local card = Instance.new("Frame")
                card.Size = UDim2.new(1, 0, 0, 38)
                card.BackgroundColor3 = Color3.fromRGB(24, 19, 40)
                card.ZIndex = 2
                card.Parent = onlineScriptsList
                Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)
                
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, -95, 1, 0)
                lbl.Position = UDim2.new(0, 10, 0, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text = onlineData.Name or "Online Script"
                lbl.TextColor3 = Color3.fromRGB(170, 165, 195)
                lbl.Font = Enum.Font.GothamMedium
                lbl.TextSize = 11
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.ZIndex = 2
                lbl.Parent = card
                
                local loadBtn = Instance.new("TextButton")
                loadBtn.Size = UDim2.new(0, 80, 0, 26)
                loadBtn.Position = UDim2.new(1, -88, 0.5, -13)
                loadBtn.BackgroundColor3 = Color3.fromRGB(38, 28, 62)
                loadBtn.Text = "Load"
                loadBtn.TextColor3 = Color3.fromRGB(200, 195, 220)
                loadBtn.Font = Enum.Font.GothamBold
                loadBtn.TextSize = 11
                loadBtn.ZIndex = 2
                loadBtn.Parent = card
                Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 4)
                
                loadBtn.Activated:Connect(function()
                    if onlineData.Url then
                        local fetchedCode = game:HttpGet(onlineData.Url)
                        local fn = loadstring(fetchedCode)
                        if fn then task.spawn(fn) end
                        statusLbl.Text = "Status: Executed online script [" .. onlineData.Name .. "]"
                        statusLbl.TextColor3 = Color3.fromRGB(46, 204, 113)
                    end
                end)
            end
        end
    else
        local fallbackCard = Instance.new("Frame")
        fallbackCard.Size = UDim2.new(1, 0, 0, 38)
        fallbackCard.BackgroundColor3 = Color3.fromRGB(24, 19, 40)
        fallbackCard.ZIndex = 2
        fallbackCard.Parent = onlineScriptsList
        Instance.new("UICorner", fallbackCard).CornerRadius = UDim.new(0, 6)
        
        local fallbackLbl = Instance.new("TextLabel")
        fallbackLbl.Size = UDim2.new(1, -15, 1, 0)
        fallbackLbl.Position = UDim2.new(0, 10, 0, 0)
        fallbackLbl.BackgroundTransparency = 1
        fallbackLbl.Text = "No online repository connected yet."
        fallbackLbl.TextColor3 = Color3.fromRGB(140, 130, 160)
        fallbackLbl.Font = Enum.Font.GothamItalic
        fallbackLbl.TextSize = 11
        fallbackLbl.TextXAlignment = Enum.TextXAlignment.Left
        fallbackLbl.ZIndex = 2
        fallbackLbl.Parent = fallbackCard
    end
end)

-- ==========================================
-- 6. EXECUTION HANDLERS
-- ==========================================
runBtn.Activated:Connect(function()
    local code = editorBox.Text
    if code == placeholderTextStr or code == "" then
        statusLbl.Text = "Status: No script provided to run."
        statusLbl.TextColor3 = Color3.fromRGB(231, 76, 60)
        return
    end

    local success, err = pcall(function()
        local func = loadstring(code)
        if func then task.spawn(func) end
    end)
    
    if success then
        statusLbl.Text = "Status: Successfully ran script!"
        statusLbl.TextColor3 = Color3.fromRGB(46, 204, 113)
    else
        statusLbl.Text = "Status: Execution error encountered."
        statusLbl.TextColor3 = Color3.fromRGB(231, 76, 60)
    end
end)

consoleBtn.Activated:Connect(function()
    pcall(function() game:GetService("StarterGui"):SetCore("DevConsoleVisible", true) end)
    statusLbl.Text = "Status: Developer Console toggled."
    statusLbl.TextColor3 = Color3.fromRGB(170, 160, 190)
end)
