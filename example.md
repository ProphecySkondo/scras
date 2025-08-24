# Enhanced Discord UI Library - Examples

This file contains comprehensive examples demonstrating the capabilities of the Enhanced Discord UI Library v2.0.

## 🚀 Basic Setup

```lua
-- Load the enhanced Discord library
local DiscordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ProphecySkondo/scras/main/discord-lib.lua"))()

-- Create main window
local win = DiscordLib:Window("My Enhanced GUI")

-- Create a server with custom icon
local server = win:Server("Main Server", "rbxassetid://6031075938")

-- Create channels
local mainChannel = server:Channel("General")
local settingsChannel = server:Channel("Settings")
local scriptChannel = server:Channel("Scripts")
```

## 🎮 Game Features Example

```lua
-- Auto Farm Section
mainChannel:Label("🌾 Auto Farm Features")
mainChannel:Seperator()

-- Toggle for auto farm
local autoFarmEnabled = false
mainChannel:Toggle("Enable Auto Farm", false, function(state)
    autoFarmEnabled = state
    DiscordLib:Notification("Auto Farm", state and "Enabled!" or "Disabled!", "OK")
    
    if state then
        -- Start auto farm logic here
        spawn(function()
            while autoFarmEnabled do
                -- Your auto farm code
                print("Auto farming...")
                wait(1)
            end
        end)
    end
end)

-- Farm speed slider
mainChannel:Slider("Farm Speed", 1, 10, 5, function(value)
    _G.FarmSpeed = value
    print("Farm speed set to:", value)
end)

-- Farm location dropdown
local farmLocations = {"Spawn", "Desert", "Forest", "Mountains", "Beach"}
mainChannel:Dropdown("Farm Location", farmLocations, function(location)
    _G.FarmLocation = location
    DiscordLib:Notification("Location", "Farming location set to " .. location, "Cool!")
end)
```

## ⚔️ Combat System Example

```lua
-- Combat Section
scriptChannel:Label("⚔️ Combat Features")
scriptChannel:Seperator()

-- Auto attack toggle
scriptChannel:Toggle("Auto Attack", false, function(state)
    _G.AutoAttack = state
    if state then
        spawn(function()
            while _G.AutoAttack do
                -- Auto attack logic
                local target = findNearestEnemy()
                if target then
                    attack(target)
                end
                wait(0.1)
            end
        end)
    end
end)

-- Attack damage multiplier
scriptChannel:Slider("Damage Multiplier", 1, 50, 1, function(value)
    _G.DamageMultiplier = value
end)

-- Combat range
scriptChannel:Slider("Attack Range", 5, 100, 20, function(value)
    _G.AttackRange = value
end)

-- Weapon selection
local weapons = {"Sword", "Bow", "Staff", "Dagger", "Hammer"}
scriptChannel:Dropdown("Select Weapon", weapons, function(weapon)
    _G.SelectedWeapon = weapon
    equipWeapon(weapon)
end)
```

## 🎨 Visual & ESP Features

```lua
-- ESP Section
settingsChannel:Label("👁️ Visual Features")
settingsChannel:Seperator()

-- Player ESP
settingsChannel:Toggle("Player ESP", false, function(state)
    _G.PlayerESP = state
    togglePlayerESP(state)
end)

-- ESP Color picker
settingsChannel:Colorpicker("ESP Color", Color3.fromRGB(255, 0, 0), function(color)
    _G.ESPColor = color
    updateESPColor(color)
end)

-- ESP Distance
settingsChannel:Slider("ESP Distance", 50, 1000, 200, function(value)
    _G.ESPDistance = value
end)

-- Fullbright toggle
settingsChannel:Toggle("Fullbright", false, function(state)
    game.Lighting.Brightness = state and 2 or 1
    game.Lighting.ClockTime = state and 12 or 14
end)

-- FOV Changer
settingsChannel:Slider("Field of View", 70, 120, 70, function(value)
    workspace.CurrentCamera.FieldOfView = value
end)
```

## 🏃 Movement & Teleport Features

```lua
-- Movement Section
mainChannel:Label("🏃 Movement Features")
mainChannel:Seperator()

-- Speed controls
local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")

mainChannel:Slider("Walk Speed", 16, 200, 16, function(value)
    if humanoid then
        humanoid.WalkSpeed = value
    end
end)

mainChannel:Slider("Jump Power", 50, 500, 50, function(value)
    if humanoid then
        humanoid.JumpPower = value
    end
end)

-- Fly toggle
local flying = false
mainChannel:Toggle("Fly Mode", false, function(state)
    flying = state
    if state then
        enableFly()
    else
        disableFly()
    end
end)

-- Noclip toggle  
mainChannel:Toggle("Noclip", false, function(state)
    _G.Noclip = state
    local character = game.Players.LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end
    end
end)

-- Teleport locations
local teleportLocations = {
    "Spawn",
    "Shop", 
    "Boss Arena",
    "Secret Area",
    "Safe Zone"
}

mainChannel:Dropdown("Teleport To", teleportLocations, function(location)
    teleportToLocation(location)
    DiscordLib:Notification("Teleport", "Teleported to " .. location, "Nice!")
end)
```

## 💰 Economy & Trading Features

```lua
-- Economy Section  
scriptChannel:Label("💰 Economy Features")
scriptChannel:Seperator()

-- Auto collect coins
scriptChannel:Toggle("Auto Collect Coins", false, function(state)
    _G.AutoCollectCoins = state
    if state then
        spawn(function()
            while _G.AutoCollectCoins do
                collectNearbyCoins()
                wait(0.5)
            end
        end)
    end
end)

-- Auto sell items
scriptChannel:Toggle("Auto Sell Items", false, function(state)
    _G.AutoSell = state
    if state then
        spawn(function()
            while _G.AutoSell do
                sellInventoryItems()
                wait(10)
            end
        end)
    end
end)

-- Money display (read-only textbox)
scriptChannel:Textbox("Current Money", "Loading...", true, function() end)

-- Update money display
spawn(function()
    while true do
        local money = getPlayerMoney()
        -- Update the textbox display here
        wait(2)
    end
end)
```

## 🛡️ Anti-Detection & Safety

```lua
-- Safety Section
settingsChannel:Label("🛡️ Safety Features")
settingsChannel:Seperator()

-- Anti-AFK
settingsChannel:Toggle("Anti-AFK", false, function(state)
    _G.AntiAFK = state
    if state then
        spawn(function()
            while _G.AntiAFK do
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):ClickButton2(Vector2.new())
                wait(300) -- Every 5 minutes
            end
        end)
    end
end)

-- Hide GUI key
settingsChannel:Textbox("Hide GUI Key", "H", false, function(key)
    _G.HideKey = key:upper()
    
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode[_G.HideKey] then
            win:Toggle() -- Assuming the library has a toggle method
        end
    end)
end)

-- Auto-save settings
settingsChannel:Toggle("Auto-Save Settings", true, function(state)
    _G.AutoSave = state
end)
```

## 🎯 Game-Specific Examples

### 🔫 FPS Game Features
```lua
-- FPS Games
if game.PlaceId == 292439477 then -- Phantom Forces example
    local fpsChannel = server:Channel("FPS Features")
    
    fpsChannel:Toggle("Aimbot", false, function(state)
        _G.Aimbot = state
    end)
    
    fpsChannel:Slider("Aimbot FOV", 50, 500, 100, function(value)
        _G.AimbotFOV = value
    end)
    
    fpsChannel:Toggle("No Recoil", false, function(state)
        _G.NoRecoil = state
    end)
    
    fpsChannel:Toggle("Infinite Ammo", false, function(state)
        _G.InfiniteAmmo = state
    end)
end
```

### 🏆 Simulator Game Features  
```lua
-- Simulator Games
if string.find(game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name:lower(), "simulator") then
    local simChannel = server:Channel("Simulator")
    
    simChannel:Toggle("Auto Click", false, function(state)
        _G.AutoClick = state
        spawn(function()
            while _G.AutoClick do
                -- Auto click logic
                fireproximityprompt(workspace.ClickPart.ProximityPrompt)
                wait(0.01)
            end
        end)
    end)
    
    simChannel:Toggle("Auto Rebirth", false, function(state)
        _G.AutoRebirth = state
        spawn(function()
            while _G.AutoRebirth do
                -- Auto rebirth logic
                game:GetService("ReplicatedStorage").Remotes.Rebirth:FireServer()
                wait(1)
            end
        end)
    end)
    
    simChannel:Toggle("Auto Upgrade", false, function(state)
        _G.AutoUpgrade = state
    end)
end
```

## 🎮 Advanced Control Examples

### 📊 Statistics Display
```lua
-- Stats channel
local statsChannel = server:Channel("Statistics")

-- Create labels for stats
local statsLabels = {}
statsLabels.level = statsChannel:Label("Level: Loading...")
statsLabels.xp = statsChannel:Label("XP: Loading...")  
statsLabels.coins = statsChannel:Label("Coins: Loading...")
statsLabels.playtime = statsChannel:Label("Play Time: Loading...")

-- Update stats every 2 seconds
spawn(function()
    while true do
        -- Update labels with current stats
        -- Note: You'd need to implement these getter functions
        local level = getPlayerLevel()
        local xp = getPlayerXP() 
        local coins = getPlayerCoins()
        local playtime = getPlayTime()
        
        -- Update the labels (method depends on library implementation)
        -- This is pseudo-code as the library might not support label updates
        wait(2)
    end
end)
```

### 🔧 Dynamic Dropdown Management
```lua
-- Dynamic dropdown example
local playerDropdown = mainChannel:Dropdown("Target Player", {}, function(playerName)
    _G.TargetPlayer = playerName
    print("Targeting:", playerName)
end)

-- Update player list every 5 seconds
spawn(function()
    while true do
        local players = {}
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                table.insert(players, player.Name)
            end
        end
        
        -- Clear and refill dropdown
        playerDropdown:Clear()
        for _, playerName in pairs(players) do
            playerDropdown:Add(playerName)
        end
        
        wait(5)
    end
end)
```

## 🎨 Theme Customization Example

```lua
-- Theme selection
settingsChannel:Label("🎨 Appearance")
settingsChannel:Seperator()

local themes = {"Dark", "Light", "Blue", "Red", "Green", "Purple"}
settingsChannel:Dropdown("Select Theme", themes, function(theme)
    -- You would need to implement theme switching in the library
    DiscordLib:SetTheme(theme)
    DiscordLib:Notification("Theme", "Theme changed to " .. theme, "Nice!")
end)

-- Custom accent color
settingsChannel:Colorpicker("Accent Color", Color3.fromRGB(114, 137, 218), function(color)
    -- Custom accent color implementation
    DiscordLib:SetAccentColor(color)
end)

-- GUI Transparency
settingsChannel:Slider("GUI Transparency", 0, 80, 0, function(value)
    DiscordLib:SetTransparency(value / 100)
end)
```

## 💡 Utility Functions

```lua
-- Utility functions that work with the examples above

function findNearestEnemy()
    local nearestEnemy = nil
    local shortestDistance = math.huge
    
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:FindFirstChild("Humanoid") and obj ~= game.Players.LocalPlayer.Character then
            local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestEnemy = obj
            end
        end
    end
    
    return nearestEnemy
end

function attack(target)
    -- Implement attack logic
    print("Attacking:", target.Name)
end

function equipWeapon(weaponName)
    -- Implement weapon equipping
    print("Equipped:", weaponName)
end

function teleportToLocation(locationName)
    local locations = {
        Spawn = Vector3.new(0, 10, 0),
        Shop = Vector3.new(100, 10, 0),
        ["Boss Arena"] = Vector3.new(-100, 10, 100),
        ["Secret Area"] = Vector3.new(0, 50, -200),
        ["Safe Zone"] = Vector3.new(50, 10, 50)
    }
    
    local position = locations[locationName]
    if position and game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

function enableFly()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = character.HumanoidRootPart
        
        _G.FlyBodyVelocity = bodyVelocity
    end
end

function disableFly()
    if _G.FlyBodyVelocity then
        _G.FlyBodyVelocity:Destroy()
        _G.FlyBodyVelocity = nil
    end
end

function collectNearbyCoins()
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name == "Coin" or obj.Name == "Money" then
            local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - obj.Position).Magnitude
            if distance < 50 then
                -- Collect coin logic
                obj:Destroy() -- Or however coins are collected in your game
            end
        end
    end
end
```

## 🚨 Error Handling & Best Practices

```lua
-- Safe function execution
local function safeExecute(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        DiscordLib:Notification("Error", "Function failed: " .. tostring(result), "OK")
        warn("Safe execution failed:", result)
    end
    return success, result
end

-- Example usage with error handling
mainChannel:Button("Risky Operation", function()
    safeExecute(function()
        -- Your risky code here
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(math.random(-1000, 1000), 1000, math.random(-1000, 1000))
    end)
end)

-- Save settings function
local function saveSettings()
    local settings = {
        walkSpeed = _G.WalkSpeed or 16,
        jumpPower = _G.JumpPower or 50,
        espEnabled = _G.PlayerESP or false,
        espColor = _G.ESPColor or Color3.fromRGB(255, 0, 0),
        autoFarm = _G.AutoFarm or false
    }
    
    -- Save to file (if supported) or datastore
    writefile("MyGUISettings.json", game:GetService("HttpService"):JSONEncode(settings))
end

-- Load settings function
local function loadSettings()
    if isfile("MyGUISettings.json") then
        local success, settings = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile("MyGUISettings.json"))
        end)
        
        if success then
            _G.WalkSpeed = settings.walkSpeed
            _G.JumpPower = settings.jumpPower
            _G.PlayerESP = settings.espEnabled
            _G.ESPColor = settings.espColor
            _G.AutoFarm = settings.autoFarm
            
            DiscordLib:Notification("Settings", "Settings loaded successfully!", "OK")
        end
    end
end

-- Auto-save every 30 seconds
spawn(function()
    while wait(30) do
        if _G.AutoSave then
            saveSettings()
        end
    end
end)

-- Load settings on startup
loadSettings()
```

## 📝 Complete Example Script

Here's a complete, ready-to-use script combining multiple features:

```lua
-- Complete Enhanced Discord UI Example
local DiscordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ProphecySkondo/scras/main/discord-lib.lua"))()

-- Initialize
local win = DiscordLib:Window("Ultimate Game GUI")
local server = win:Server("Main", "rbxassetid://6031075938")

-- Channels
local playerChannel = server:Channel("Player")
local visualChannel = server:Channel("Visual") 
local autoChannel = server:Channel("Automation")
local miscChannel = server:Channel("Misc")

-- Player modifications
playerChannel:Slider("Walk Speed", 16, 500, 16, function(v)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
end)

playerChannel:Slider("Jump Power", 50, 300, 50, function(v)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
end)

playerChannel:Toggle("Infinite Jump", false, function(state)
    _G.InfiniteJump = state
end)

-- Visual features
visualChannel:Toggle("Player ESP", false, function(state)
    _G.ESP = state
    -- ESP implementation here
end)

visualChannel:Colorpicker("ESP Color", Color3.fromRGB(255, 0, 0), function(color)
    _G.ESPColor = color
end)

visualChannel:Toggle("Fullbright", false, function(state)
    game.Lighting.Brightness = state and 3 or 1
end)

-- Automation
autoChannel:Toggle("Auto Farm", false, function(state)
    _G.AutoFarm = state
end)

autoChannel:Slider("Farm Delay", 0.1, 5, 1, function(v)
    _G.FarmDelay = v
end)

-- Miscellaneous
miscChannel:Button("Reset Character", function()
    game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").Health = 0
end)

miscChannel:Button("Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end)

miscChannel:Textbox("Status", "Ready!", true, function() end)

-- Success notification
DiscordLib:Notification("GUI Loaded", "Enhanced Discord UI loaded successfully!", "Awesome!")
```

---

⭐ **These examples showcase the full potential of the Enhanced Discord UI Library!**

**Need more examples?** Check out the main repository: https://github.com/ProphecySkondo/scras
