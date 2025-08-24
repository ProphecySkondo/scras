--[[
    Enhanced Discord UI Library v2.0 - KRAKEN Framework Integration
    
    Features:
    ✓ Ultra-dark professional theme
    ✓ Complete KRAKEN Framework autofarm system
    ✓ Hitbox visualization with updates
    ✓ Advanced anti-AFK with multiple methods
    ✓ Professional health displays with color coding
    ✓ Smooth animations & blur effects
    ✓ Modern toast notifications
    ✓ Z-key toggle functionality
    ✓ Smart combat positioning system
    ✓ Real-time target monitoring
]]

-- Wait for game to load
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

-- Services
local DiscordLib = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")

print("[KRAKEN] Initializing Enhanced Final Stand GUI with Professional Combat AI...")

-- Configuration
local Config = {
    AnimationSpeed = 0.3,
    DefaultTheme = "Dark",
    EnableSounds = true,
    EnableParticles = true,
    AutoSave = true,
    MaxTooltipWidth = 200,
    DebugMode = false,
    DefaultKeybind = Enum.KeyCode.Z -- Default toggle keybind
}

-- Ultra-Dark Professional Theme
local Themes = {
    Dark = {
        Background = Color3.fromRGB(12, 14, 17),         -- Ultra dark background
        SecondaryBackground = Color3.fromRGB(20, 22, 26), -- Darker secondary
        TertiaryBackground = Color3.fromRGB(28, 31, 35),  -- Darker tertiary
        TextPrimary = Color3.fromRGB(245, 247, 250),      -- Brighter white
        TextSecondary = Color3.fromRGB(175, 180, 190),    -- Muted secondary text
        TextMuted = Color3.fromRGB(95, 100, 110),         -- More muted
        Accent = Color3.fromRGB(88, 101, 242),            -- Discord purple
        AccentHover = Color3.fromRGB(71, 82, 196),        -- Darker purple hover
        Success = Color3.fromRGB(67, 181, 129),           -- Green success
        Warning = Color3.fromRGB(250, 166, 26),           -- Orange warning
        Error = Color3.fromRGB(240, 71, 71),              -- Red error
        Border = Color3.fromRGB(35, 38, 43)               -- Darker borders
    }
}

local CurrentTheme = Themes[Config.DefaultTheme]

-- Utility Functions
local Utils = {}

function Utils.CreateTween(object, properties, duration, easingStyle, easingDirection)
    local info = TweenInfo.new(
        duration or Config.AnimationSpeed,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, info, properties)
    tween:Play()
    return tween
end

function Utils.RippleEffect(frame, position)
    if not Config.EnableParticles then return end
    
    local ripple = Instance.new("Frame")
    ripple.Name = "RippleEffect"
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.8
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Position = UDim2.new(0, position.X - frame.AbsolutePosition.X, 0, position.Y - frame.AbsolutePosition.Y)
    ripple.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    local maxSize = math.max(frame.AbsoluteSize.X, frame.AbsoluteSize.Y) * 2
    
    Utils.CreateTween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }, 0.5)
    
    game:GetService("Debris"):AddItem(ripple, 0.5)
end

-- Save/Load System
local SaveSystem = {}
local userinfo = {}

function SaveSystem.Load()
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile("kraken_enhanced_config.json"))
    end)
    
    if success and data then
        userinfo = data
    else
        userinfo = {
            pfp = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png",
            user = LocalPlayer.Name,
            tag = tostring(math.random(1000, 9999)),
            theme = Config.DefaultTheme
        }
    end
    
    if userinfo.theme and Themes[userinfo.theme] then
        CurrentTheme = Themes[userinfo.theme]
    end
end

function SaveSystem.Save()
    if Config.AutoSave then
        pcall(function()
            writefile("kraken_enhanced_config.json", HttpService:JSONEncode(userinfo))
        end)
    end
end

-- Initialize save system
SaveSystem.Load()

-- Core UI Creation
local Discord = Instance.new("ScreenGui")
Discord.Name = "KrakenEnhancedGUI"
Discord.Parent = game.CoreGui
Discord.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Discord.ResetOnSpawn = false

-- Enhanced Blur Effects
local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Name = "KrakenBlur"
BlurEffect.Size = 0
BlurEffect.Parent = game.Lighting

local ColorCorrection = Instance.new("ColorCorrectionEffect")
ColorCorrection.Name = "KrakenColorCorrection"
ColorCorrection.Saturation = 0
ColorCorrection.Contrast = 0
ColorCorrection.Brightness = 0
ColorCorrection.Parent = game.Lighting

-- Notification Container
local NotificationContainer = Instance.new("Frame")
NotificationContainer.Name = "NotificationContainer"
NotificationContainer.Parent = Discord
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Position = UDim2.new(1, -320, 0, 20)
NotificationContainer.Size = UDim2.new(0, 300, 1, -40)
NotificationContainer.ZIndex = 200

local NotificationLayout = Instance.new("UIListLayout")
NotificationLayout.Parent = NotificationContainer
NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotificationLayout.Padding = UDim.new(0, 10)
NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Top

-- ═══════════════════════════════════════════
-- ENHANCED KRAKEN AUTOFARM SYSTEM
-- ═══════════════════════════════════════════

-- Anti-AFK System Configuration (Full KRAKEN Implementation)
local antiAFK = {
    enabled = true,
    methods = {
        virtualInput = true,    -- Send virtual key inputs
        mouseMovement = false,   -- Move mouse slightly
        characterMovement = false, -- Small character movements
        jumpSpam = false        -- Periodic jumping (can be noticeable)
    },
    intervals = {
        virtualInput = 1140,      -- Every 19 minutes (19 * 60 = 1140 seconds)
        mouseMovement = 30,     -- Every 30 seconds
        characterMovement = 60, -- Every 60 seconds
        jumpSpam = 120         -- Every 2 minutes if enabled
    },
    lastActivation = {
        virtualInput = 0,
        mouseMovement = 0,
        characterMovement = 0,
        jumpSpam = 0
    },
    connection = nil
}

-- Enhanced autofarm state (KRAKEN Full Feature Set)
local autofarm = {
    enabled = false,
    distance = 3,
    npcs = {"Saiba", "Saiyan", "Chi", "Boxer"}, -- Change this or make it {} for all NPCs
    connections = {},
    currentTarget = nil,
    isMovingToTarget = false,
    activeTween = nil,
    lastAttackTime = 0,
    healthGui = nil,
    hitboxPart = nil
}

-- Get closest matching NPC (KRAKEN Implementation)
local function getClosestNPC()
    local liveFolder = Workspace:FindFirstChild("Live")
    if not liveFolder or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    
    local playerPos = LocalPlayer.Character.HumanoidRootPart.Position
    local closestNPC = nil
    local closestDistance = math.huge
    
    for _, npc in pairs(liveFolder:GetChildren()) do
        if npc.Name == LocalPlayer.Name or not npc:FindFirstChild("HumanoidRootPart") or not npc:FindFirstChildOfClass("Humanoid") or npc.Humanoid.Health <= 0 then
            continue
        end
        
        -- Check if NPC matches our targets
        local npcMatches = false
        if #autofarm.npcs > 0 then
            for _, targetName in pairs(autofarm.npcs) do
                if npc.Name:lower():find(targetName:lower()) then
                    npcMatches = true
                    break
                end
            end
        else
            npcMatches = true -- Attack all if no specific targets
        end
        
        if npcMatches then
            local distance = (playerPos - npc.HumanoidRootPart.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestNPC = npc
            end
        end
    end
    
    return closestNPC
end

-- Attack function using ServerTraits (KRAKEN Implementation)
local function attack()
    if LocalPlayer.Backpack:FindFirstChild("ServerTraits") and LocalPlayer.Backpack.ServerTraits:FindFirstChild("Input") then
        LocalPlayer.Backpack.ServerTraits.Input:FireServer({"md"}, CFrame.new())
    end
end

-- Professional Health Display (Enhanced KRAKEN Version)
local function createHealthGui(target)
    if autofarm.healthGui then
        autofarm.healthGui:Destroy()
    end
    
    local gui = Instance.new("BillboardGui")
    gui.Name = "KrakenHealthDisplay"
    gui.Size = UDim2.new(0, 250, 0, 70)
    gui.StudsOffset = Vector3.new(0, 4, 0)
    gui.Parent = target:FindFirstChild("Head") or target:FindFirstChild("HumanoidRootPart")
    
    -- Modern frame with ultra-dark theme
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(12, 14, 17)
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    frame.Parent = gui
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    -- Health bar background
    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(1, -10, 0.4, 0)
    healthBg.Position = UDim2.new(0, 5, 0.6, -2)
    healthBg.BackgroundColor3 = Color3.fromRGB(35, 38, 43)
    healthBg.BorderSizePixel = 0
    healthBg.Parent = frame
    
    local healthBgCorner = Instance.new("UICorner")
    healthBgCorner.CornerRadius = UDim.new(0, 4)
    healthBgCorner.Parent = healthBg
    
    -- Health bar fill
    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(67, 181, 129)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = healthBg
    
    local healthBarCorner = Instance.new("UICorner")
    healthBarCorner.CornerRadius = UDim.new(0, 4)
    healthBarCorner.Parent = healthBar
    
    -- Professional text label
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0.6, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = string.format("%s | %d/%d HP", target.Name, math.floor(target.Humanoid.Health), math.floor(target.Humanoid.MaxHealth))
    healthLabel.TextColor3 = Color3.fromRGB(245, 247, 250)
    healthLabel.TextScaled = true
    healthLabel.Font = Enum.Font.GothamBold
    healthLabel.TextStrokeTransparency = 0.3
    healthLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    healthLabel.Parent = frame
    
    autofarm.healthGui = gui
    return gui
end

-- Create hitbox visualization (KRAKEN Implementation)
local function createHitbox(target)
    if autofarm.hitboxPart then
        autofarm.hitboxPart:Destroy()
    end
    
    local hitbox = Instance.new("Part")
    hitbox.Name = "KrakenHitbox"
    hitbox.Anchored = true
    hitbox.CanCollide = false
    hitbox.Transparency = 0.75
    hitbox.BrickColor = BrickColor.new("Really red")
    hitbox.Material = Enum.Material.ForceField
    hitbox.Shape = Enum.PartType.Block
    
    local targetRootPart = target:FindFirstChild("HumanoidRootPart")
    if targetRootPart then
        hitbox.Size = Vector3.new(6, 8, 6) -- Bigger than actual hitbox for visibility
        hitbox.CFrame = targetRootPart.CFrame
        hitbox.Parent = workspace
        
        -- Add glow effect
        local pointLight = Instance.new("PointLight")
        pointLight.Color = Color3.fromRGB(240, 71, 71)
        pointLight.Brightness = 0.5
        pointLight.Range = 15
        pointLight.Parent = hitbox
        
        autofarm.hitboxPart = hitbox
        return hitbox
    end
end

-- Update Professional Health Display (Enhanced KRAKEN Version)
local function updateHealthGui(target)
    if autofarm.healthGui and target and target:FindFirstChildOfClass("Humanoid") then
        local frame = autofarm.healthGui.Frame
        local healthLabel = frame.TextLabel
        local healthBar = frame.Frame.HealthBar
        
        local currentHealth = math.floor(target.Humanoid.Health)
        local maxHealth = math.floor(target.Humanoid.MaxHealth)
        local healthPercent = target.Humanoid.Health / target.Humanoid.MaxHealth
        
        -- Update text with professional formatting
        healthLabel.Text = string.format("%s | %d/%d HP (%.1f%%)", target.Name, currentHealth, maxHealth, healthPercent * 100)
        
        -- Update health bar size and color
        healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
        
        -- Professional color coding with theme colors
        if healthPercent > 0.7 then
            healthBar.BackgroundColor3 = Color3.fromRGB(67, 181, 129) -- Success green
            healthLabel.TextColor3 = Color3.fromRGB(245, 247, 250)
        elseif healthPercent > 0.4 then
            healthBar.BackgroundColor3 = Color3.fromRGB(250, 166, 26) -- Warning orange
            healthLabel.TextColor3 = Color3.fromRGB(245, 247, 250)
        else
            healthBar.BackgroundColor3 = Color3.fromRGB(240, 71, 71) -- Error red
            healthLabel.TextColor3 = Color3.fromRGB(245, 247, 250)
        end
    end
end

-- Update hitbox position (KRAKEN Implementation)
local function updateHitbox(target)
    if autofarm.hitboxPart and target and target:FindFirstChild("HumanoidRootPart") then
        autofarm.hitboxPart.CFrame = target.HumanoidRootPart.CFrame
    end
end

-- Professional Camera Control System (KRAKEN Implementation)
local function updateCameraToTarget(target)
    if not target or not target:FindFirstChild("HumanoidRootPart") or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local playerRootPart = LocalPlayer.Character.HumanoidRootPart
    local targetRootPart = target.HumanoidRootPart
    
    -- Make camera face the same direction as the target (like we're behind them looking their way)
    local targetCFrame = targetRootPart.CFrame
    local cameraPosition = playerRootPart.Position + Vector3.new(0, 2, 0) -- Slightly above player
    local targetLookDirection = targetCFrame.Position + (targetCFrame.LookVector * 10) -- Look where target is looking
    
    Camera.CFrame = CFrame.lookAt(cameraPosition, targetLookDirection)
end

-- ═══════════════════════════════════════════
-- ANTI-AFK SYSTEM - Full KRAKEN Implementation
-- ═══════════════════════════════════════════

-- Virtual Input Anti-AFK
local function performVirtualInput()
    local keys = {Enum.KeyCode.LeftShift, Enum.KeyCode.LeftControl, Enum.KeyCode.Tab}
    local randomKey = keys[math.random(#keys)]
    
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, randomKey, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, randomKey, false, game)
    end)
end

-- Mouse Movement Anti-AFK
local function performMouseMovement()
    local mouse = LocalPlayer:GetMouse()
    local currentX, currentY = mouse.X, mouse.Y
    local offsetX = math.random(-5, 5)
    local offsetY = math.random(-5, 5)
    
    pcall(function()
        VirtualInputManager:SendMouseMoveEvent(currentX + offsetX, currentY + offsetY, game)
        task.wait(0.1)
        VirtualInputManager:SendMouseMoveEvent(currentX, currentY, game) -- Return to original position
    end)
end

-- Character Movement Anti-AFK (subtle)
local function performCharacterMovement()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") then
        return
    end
    
    local humanoid = LocalPlayer.Character.Humanoid
    
    pcall(function()
        -- Tiny movement that's barely noticeable
        humanoid:Move(Vector3.new(math.random(-0.1, 0.1), 0, math.random(-0.1, 0.1)), false)
        task.wait(0.05)
        humanoid:Move(Vector3.new(0, 0, 0), false)
    end)
end

-- Jump Spam Anti-AFK (optional, more noticeable)
local function performJumpSpam()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") then
        return
    end
    
    pcall(function()
        LocalPlayer.Character.Humanoid.Jump = true
        task.wait(0.1)
        LocalPlayer.Character.Humanoid.Jump = false
    end)
end

-- Main Anti-AFK Handler
local function handleAntiAFK()
    if not antiAFK.enabled then return end
    
    local currentTime = tick()
    
    -- Virtual Input Method
    if antiAFK.methods.virtualInput and (currentTime - antiAFK.lastActivation.virtualInput) >= antiAFK.intervals.virtualInput then
        performVirtualInput()
        antiAFK.lastActivation.virtualInput = currentTime
        print("[KRAKEN-AFK] Virtual input activated")
    end
    
    -- Mouse Movement Method
    if antiAFK.methods.mouseMovement and (currentTime - antiAFK.lastActivation.mouseMovement) >= antiAFK.intervals.mouseMovement then
        performMouseMovement()
        antiAFK.lastActivation.mouseMovement = currentTime
        print("[KRAKEN-AFK] Mouse movement activated")
    end
    
    -- Character Movement Method
    if antiAFK.methods.characterMovement and (currentTime - antiAFK.lastActivation.characterMovement) >= antiAFK.intervals.characterMovement then
        performCharacterMovement()
        antiAFK.lastActivation.characterMovement = currentTime
        print("[KRAKEN-AFK] Character movement activated")
    end
    
    -- Jump Spam Method (if enabled)
    if antiAFK.methods.jumpSpam and (currentTime - antiAFK.lastActivation.jumpSpam) >= antiAFK.intervals.jumpSpam then
        performJumpSpam()
        antiAFK.lastActivation.jumpSpam = currentTime
        print("[KRAKEN-AFK] Jump spam activated")
    end
end

-- Start Anti-AFK System
local function startAntiAFK()
    if antiAFK.connection then
        antiAFK.connection:Disconnect()
    end
    
    antiAFK.connection = RunService.Heartbeat:Connect(function()
        handleAntiAFK()
    end)
    
    print("[KRAKEN-AFK] System activated with methods:")
    for method, enabled in pairs(antiAFK.methods) do
        if enabled then
            print(string.format("  • %s (every %ds)", method:gsub("(%l)(%u)", "%1 %2"):gsub("^%l", string.upper), antiAFK.intervals[method]))
        end
    end
end

-- Stop Anti-AFK System
local function stopAntiAFK()
    if antiAFK.connection then
        antiAFK.connection:Disconnect()
        antiAFK.connection = nil
    end
    print("[KRAKEN-AFK] System deactivated")
end

-- Anti-AFK Configuration Functions
function antiAFK.toggle(enabled)
    antiAFK.enabled = enabled
    if enabled then
        startAntiAFK()
    else
        stopAntiAFK()
    end
end

function antiAFK.setMethod(method, enabled)
    if antiAFK.methods[method] ~= nil then
        antiAFK.methods[method] = enabled
        print(string.format("[KRAKEN-AFK] %s method %s", method:gsub("(%l)(%u)", "%1 %2"):gsub("^%l", string.upper), enabled and "enabled" or "disabled"))
    else
        print("[KRAKEN-AFK] Invalid method. Available: virtualInput, mouseMovement, characterMovement, jumpSpam")
    end
end

function antiAFK.setInterval(method, seconds)
    if antiAFK.intervals[method] ~= nil then
        antiAFK.intervals[method] = seconds
        print(string.format("[KRAKEN-AFK] %s interval set to %d seconds", method:gsub("(%l)(%u)", "%1 %2"):gsub("^%l", string.upper), seconds))
    else
        print("[KRAKEN-AFK] Invalid method. Available: virtualInput, mouseMovement, characterMovement, jumpSpam")
    end
end

-- Anchor NPC function (kept for compatibility)
local function anchorNPC(target, anchored)
    -- Function kept but no longer anchors NPCs
    if not target then return end
    
    if anchored then
        print("[KRAKEN] Engaged with target: " .. target.Name)
    else
        print("[KRAKEN] Disengaged from target: " .. target.Name)
    end
end

-- Professional Combat Positioning System (Full KRAKEN Implementation)
local function smartPositionBehindNPC(target)
    if not target or not target:FindFirstChild("HumanoidRootPart") or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local character = LocalPlayer.Character
    local playerRootPart = character.HumanoidRootPart
    local targetRootPart = target.HumanoidRootPart
    
    -- Calculate optimal combat position (behind target, facing them)
    local targetCFrame = targetRootPart.CFrame
    local behindOffset = targetCFrame.LookVector * -(autofarm.distance + 1.2)
    local behindPosition = targetCFrame.Position + behindOffset
    local desiredCFrame = CFrame.lookAt(behindPosition, targetRootPart.Position)
    
    local currentDistance = (playerRootPart.Position - behindPosition).Magnitude
    
    if currentDistance > 20 and not autofarm.isMovingToTarget then
        -- LONG RANGE: Professional smooth approach
        autofarm.isMovingToTarget = true
        
        if autofarm.activeTween then
            autofarm.activeTween:Cancel()
        end
        
        local tweenTime = math.min(currentDistance / 35, 1.2) -- Optimized timing
        autofarm.activeTween = TweenService:Create(
            playerRootPart,
            TweenInfo.new(tweenTime, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0),
            {CFrame = desiredCFrame}
        )
        
        print("[KRAKEN-MOVE] Approaching target: " .. string.format("%.1f", currentDistance) .. " studs")
        autofarm.activeTween:Play()
        autofarm.activeTween.Completed:Connect(function()
            autofarm.isMovingToTarget = false
            autofarm.activeTween = nil
            print("[KRAKEN-MOVE] Combat position achieved")
        end)
        
    elseif currentDistance > 8 and not autofarm.isMovingToTarget then
        -- MEDIUM RANGE: Instant teleport to combat position
        playerRootPart.CFrame = desiredCFrame
        
    elseif not autofarm.isMovingToTarget then
        -- CLOSE RANGE: Direct CFrame positioning (instant and precise)
        playerRootPart.CFrame = desiredCFrame
    end
end

-- Main autofarm function (Enhanced KRAKEN Version)
function autofarm.start()
    if autofarm.enabled then
        print("⚠️ KRAKEN Autofarm already running!")
        return
    end
    
    autofarm.enabled = true
    
    -- Main autofarm loop using Heartbeat
    autofarm.connections.main = RunService.Heartbeat:Connect(function()
        if not autofarm.enabled then return end
        
        -- Safety check
        if not Workspace:FindFirstChild("Live") or not Workspace.Live:FindFirstChild(LocalPlayer.Name) then
            return
        end
        
        local target = getClosestNPC()
        if target then
            -- Professional target acquisition and setup
            if autofarm.currentTarget ~= target then
                -- Clean up previous target
                if autofarm.currentTarget then
                    anchorNPC(autofarm.currentTarget, false)
                end
                
                autofarm.currentTarget = target
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - target.HumanoidRootPart.Position).Magnitude
                print(string.format("[KRAKEN-TARGET] Acquired: %s | Health: %d/%d | Distance: %.1f studs", 
                    target.Name, 
                    math.floor(target.Humanoid.Health), 
                    math.floor(target.Humanoid.MaxHealth),
                    distance
                ))
                
                -- Initialize combat systems
                createHealthGui(target)
                createHitbox(target)
                anchorNPC(target, true)
            end
            
            -- Real-time combat updates
            updateHealthGui(target)
            updateHitbox(target)
            
            -- Professional camera control
            updateCameraToTarget(target)
            
            -- Professional combat positioning
            smartPositionBehindNPC(target)
            
            -- Controlled attack sequence (7 APS - Anti-kick optimized)
            local currentTime = tick()
            if currentTime - autofarm.lastAttackTime >= 0.14 then
                attack()
                autofarm.lastAttackTime = currentTime
            end
        else
            -- Professional cleanup when no targets
            if autofarm.currentTarget then
                anchorNPC(autofarm.currentTarget, false)
                print("[KRAKEN] No valid targets - Standing by...")
            end
            
            autofarm.currentTarget = nil
            
            if autofarm.healthGui then
                autofarm.healthGui:Destroy()
                autofarm.healthGui = nil
            end
            if autofarm.hitboxPart then
                autofarm.hitboxPart:Destroy()
                autofarm.hitboxPart = nil
            end
        end
    end)
    
    print("[KRAKEN] Combat system activated successfully")
    print("[KRAKEN-CONFIG] Engagement distance: " .. autofarm.distance .. " studs")
    print("[KRAKEN-CONFIG] Target priority: " .. (#autofarm.npcs > 0 and table.concat(autofarm.npcs, ", ") or "All hostile entities"))
    print("[KRAKEN-CONFIG] Attack rate: 7.0 APS (Anti-detection optimized)")
end

-- Stop autofarm (Enhanced KRAKEN Version)
function autofarm.stop()
    autofarm.enabled = false
    autofarm.currentTarget = nil
    autofarm.isMovingToTarget = false
    
    -- Cancel any active tween
    if autofarm.activeTween then
        autofarm.activeTween:Cancel()
        autofarm.activeTween = nil
    end
    
    -- Clean up displays
    if autofarm.healthGui then
        autofarm.healthGui:Destroy()
        autofarm.healthGui = nil
    end
    if autofarm.hitboxPart then
        autofarm.hitboxPart:Destroy()
        autofarm.hitboxPart = nil
    end
    
    for _, connection in pairs(autofarm.connections) do
        if connection then
            connection:Disconnect()
        end
    end
    autofarm.connections = {}
    
    print("[KRAKEN] Combat system deactivated - All operations ceased")
end

-- Configuration functions
function autofarm.setDistance(distance)
    autofarm.distance = distance
    print("[KRAKEN-CONFIG] Engagement distance updated: " .. distance .. " studs")
end

function autofarm.setTargets(npcTable)
    autofarm.npcs = npcTable
    print("[KRAKEN-CONFIG] Target priority updated: " .. (#npcTable > 0 and table.concat(npcTable, ", ") or "All hostile entities"))
end

-- ═══════════════════════════════════════════
-- ENHANCED GUI SYSTEM
-- ═══════════════════════════════════════════

-- Dragging System
local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local pos = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
        object.Position = pos
    end

    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            Utils.RippleEffect(topbarobject, input.Position)

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

-- Enhanced Notification System
function DiscordLib:Notification(title, description, notificationType, duration)
    notificationType = notificationType or "info"
    duration = duration or 4
    
    local notificationColors = {
        success = CurrentTheme.Success,
        error = CurrentTheme.Error,
        warning = CurrentTheme.Warning,
        info = CurrentTheme.Accent
    }
    
    local notificationIcons = {
        success = "✓",
        error = "✕",
        warning = "⚠",
        info = "🔥"
    }
    
    local accentColor = notificationColors[notificationType] or CurrentTheme.Accent
    local iconText = notificationIcons[notificationType] or "ℹ"
    
    -- Create toast notification
    local Toast = Instance.new("Frame")
    Toast.Name = "Toast"
    Toast.Parent = NotificationContainer
    Toast.BackgroundColor3 = CurrentTheme.TertiaryBackground
    Toast.BorderSizePixel = 0
    Toast.Size = UDim2.new(1, 0, 0, 80)
    Toast.Position = UDim2.new(0, 300, 0, 0)
    Toast.ZIndex = 150
    
    local ToastCorner = Instance.new("UICorner")
    ToastCorner.CornerRadius = UDim.new(0, 8)
    ToastCorner.Parent = Toast
    
    -- Add subtle shadow
    local Shadow = Instance.new("Frame")
    Shadow.Parent = Toast
    Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.BackgroundTransparency = 0.8
    Shadow.Position = UDim2.new(0, 2, 0, 2)
    Shadow.Size = UDim2.new(1, 0, 1, 0)
    Shadow.ZIndex = 149
    
    local ShadowCorner = Instance.new("UICorner")
    ShadowCorner.CornerRadius = UDim.new(0, 8)
    ShadowCorner.Parent = Shadow
    
    -- Accent bar
    local AccentBar = Instance.new("Frame")
    AccentBar.Parent = Toast
    AccentBar.BackgroundColor3 = accentColor
    AccentBar.BorderSizePixel = 0
    AccentBar.Size = UDim2.new(0, 4, 1, 0)
    AccentBar.ZIndex = 151
    
    local AccentCorner = Instance.new("UICorner")
    AccentCorner.CornerRadius = UDim.new(0, 8)
    AccentCorner.Parent = AccentBar
    
    -- Icon
    local Icon = Instance.new("TextLabel")
    Icon.Parent = Toast
    Icon.BackgroundTransparency = 1
    Icon.Position = UDim2.new(0, 15, 0, 0)
    Icon.Size = UDim2.new(0, 30, 0, 30)
    Icon.Font = Enum.Font.GothamBold
    Icon.Text = iconText
    Icon.TextColor3 = accentColor
    Icon.TextSize = 18
    Icon.TextXAlignment = Enum.TextXAlignment.Center
    Icon.TextYAlignment = Enum.TextYAlignment.Center
    Icon.ZIndex = 152
    
    -- Title
    local ToastTitle = Instance.new("TextLabel")
    ToastTitle.Parent = Toast
    ToastTitle.BackgroundTransparency = 1
    ToastTitle.Position = UDim2.new(0, 50, 0, 8)
    ToastTitle.Size = UDim2.new(1, -80, 0, 20)
    ToastTitle.Font = Enum.Font.GothamBold
    ToastTitle.Text = title
    ToastTitle.TextColor3 = CurrentTheme.TextPrimary
    ToastTitle.TextSize = 14
    ToastTitle.TextXAlignment = Enum.TextXAlignment.Left
    ToastTitle.ZIndex = 152
    
    -- Description
    local ToastDesc = Instance.new("TextLabel")
    ToastDesc.Parent = Toast
    ToastDesc.BackgroundTransparency = 1
    ToastDesc.Position = UDim2.new(0, 50, 0, 30)
    ToastDesc.Size = UDim2.new(1, -80, 0, 40)
    ToastDesc.Font = Enum.Font.Gotham
    ToastDesc.Text = description
    ToastDesc.TextColor3 = CurrentTheme.TextSecondary
    ToastDesc.TextSize = 12
    ToastDesc.TextXAlignment = Enum.TextXAlignment.Left
    ToastDesc.TextYAlignment = Enum.TextYAlignment.Top
    ToastDesc.TextWrapped = true
    ToastDesc.ZIndex = 152
    
    -- Progress bar
    local ProgressBar = Instance.new("Frame")
    ProgressBar.Parent = Toast
    ProgressBar.BackgroundColor3 = accentColor
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Position = UDim2.new(0, 0, 1, -3)
    ProgressBar.Size = UDim2.new(1, 0, 0, 3)
    ProgressBar.ZIndex = 151
    
    -- Animate toast in
    Toast:TweenPosition(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.5, true)
    
    -- Progress bar animation
    ProgressBar:TweenSize(UDim2.new(0, 0, 0, 3), Enum.EasingDirection.Out, Enum.EasingStyle.Linear, duration, true)
    
    -- Auto-dismiss
    task.spawn(function()
        task.wait(duration)
        if Toast and Toast.Parent then
            Toast:TweenPosition(UDim2.new(0, 300, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
            task.wait(0.3)
            Toast:Destroy()
        end
    end)
    
    return Toast
end

-- Main Window Function (Enhanced)
function DiscordLib:Window(text, options)
    options = options or {}
    local windowData = {
        servers = {},
        minimized = false,
        currentServerToggled = ""
    }
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = Discord
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = CurrentTheme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 700, 0, 450)
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame
    
    -- Add subtle gradient
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 14, 17)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 22, 26))
    }
    Gradient.Rotation = 45
    Gradient.Parent = MainFrame
    
    -- Top Frame
    local TopFrame = Instance.new("Frame")
    TopFrame.Name = "TopFrame"
    TopFrame.Parent = MainFrame
    TopFrame.BackgroundColor3 = CurrentTheme.Background
    TopFrame.BackgroundTransparency = 1
    TopFrame.BorderSizePixel = 0
    TopFrame.Size = UDim2.new(1, 0, 0, 25)
    
    -- Title with KRAKEN branding
    local Title = Instance.new("TextLabel")
    Title.Parent = TopFrame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.02, 0, 0, 0)
    Title.Size = UDim2.new(0, 500, 0, 25)
    Title.Font = Enum.Font.GothamBold
    Title.Text = text or "🔥 KRAKEN Enhanced - Final Stand Combat AI"
    Title.TextColor3 = CurrentTheme.TextPrimary
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TopFrame
    CloseBtn.BackgroundColor3 = CurrentTheme.Background
    CloseBtn.Position = UDim2.new(0.955, 0, 0.1, 0)
    CloseBtn.Size = UDim2.new(0, 30, 0, 20)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = CurrentTheme.TextSecondary
    CloseBtn.TextSize = 16
    CloseBtn.BorderSizePixel = 0
    CloseBtn.AutoButtonColor = false
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 5)
    CloseCorner.Parent = CloseBtn
    
    CloseBtn.MouseEnter:Connect(function()
        Utils.CreateTween(CloseBtn, {BackgroundColor3 = CurrentTheme.Error}, 0.2)
        Utils.CreateTween(CloseBtn, {TextColor3 = CurrentTheme.TextPrimary}, 0.2)
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        Utils.CreateTween(CloseBtn, {BackgroundColor3 = CurrentTheme.Background}, 0.2)
        Utils.CreateTween(CloseBtn, {TextColor3 = CurrentTheme.TextSecondary}, 0.2)
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        autofarm.stop()
        stopAntiAFK()
        Utils.CreateTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        Discord:Destroy()
    end)
    
    -- Content Area
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundColor3 = CurrentTheme.TertiaryBackground
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Position = UDim2.new(0, 0, 0, 25)
    ContentFrame.Size = UDim2.new(1, 0, 1, -25)
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 10)
    ContentCorner.Parent = ContentFrame
    
    -- Make window draggable
    MakeDraggable(TopFrame, MainFrame)
    
    -- Enhanced blur effects
    Utils.CreateTween(BlurEffect, {Size = 30}, Config.AnimationSpeed)
    Utils.CreateTween(ColorCorrection, {Contrast = -0.25, Brightness = -0.15, Saturation = -0.1}, Config.AnimationSpeed)
    
    -- Z-Key Toggle
    local isVisible = true
    
    local function toggleWindow()
        isVisible = not isVisible
        
        if isVisible then
            MainFrame.Visible = true
            Utils.CreateTween(MainFrame, {BackgroundTransparency = 0}, Config.AnimationSpeed * 0.5)
            Utils.CreateTween(BlurEffect, {Size = 30}, Config.AnimationSpeed)
            Utils.CreateTween(ColorCorrection, {Contrast = -0.25, Brightness = -0.15}, Config.AnimationSpeed)
            DiscordLib:Notification("KRAKEN Activated", "Combat interface is now visible", "success", 2)
        else
            Utils.CreateTween(MainFrame, {BackgroundTransparency = 1}, Config.AnimationSpeed * 0.5)
            Utils.CreateTween(BlurEffect, {Size = 0}, Config.AnimationSpeed)
            Utils.CreateTween(ColorCorrection, {Contrast = 0, Brightness = 0}, Config.AnimationSpeed)
            
            task.wait(Config.AnimationSpeed * 0.5)
            if not isVisible then
                MainFrame.Visible = false
            end
            
            DiscordLib:Notification("KRAKEN Hidden", "Press Z to show combat interface", "info", 2)
        end
    end
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.Z then
            toggleWindow()
        end
    end)
    
    -- Create Enhanced Autofarm Controls
    local function createKrakenControls()
        local scroll = Instance.new("ScrollingFrame")
        scroll.Parent = ContentFrame
        scroll.BackgroundTransparency = 1
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.CanvasSize = UDim2.new(0, 0, 0, 900)
        scroll.ScrollBarThickness = 8
        scroll.ScrollBarImageColor3 = CurrentTheme.Border
        
        local layout = Instance.new("UIListLayout")
        layout.Parent = scroll
        layout.Padding = UDim.new(0, 12)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        
        local padding = Instance.new("UIPadding")
        padding.Parent = scroll
        padding.PaddingLeft = UDim.new(0, 25)
        padding.PaddingRight = UDim.new(0, 25)
        padding.PaddingTop = UDim.new(0, 25)
        
        -- Enhanced Status Header
        local statusFrame = Instance.new("Frame")
        statusFrame.Parent = scroll
        statusFrame.BackgroundColor3 = CurrentTheme.SecondaryBackground
        statusFrame.Size = UDim2.new(1, 0, 0, 60)
        
        local statusCorner = Instance.new("UICorner")
        statusCorner.CornerRadius = UDim.new(0, 8)
        statusCorner.Parent = statusFrame
        
        local statusGradient = Instance.new("UIGradient")
        statusGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(88, 101, 242)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(71, 82, 196))
        }
        statusGradient.Rotation = 45
        statusGradient.Parent = statusFrame
        
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Parent = statusFrame
        statusLabel.BackgroundTransparency = 1
        statusLabel.Size = UDim2.new(1, 0, 0.6, 0)
        statusLabel.Font = Enum.Font.GothamBold
        statusLabel.Text = "🔥 KRAKEN FRAMEWORK - FINAL STAND"
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        statusLabel.TextSize = 18
        statusLabel.TextXAlignment = Enum.TextXAlignment.Center
        
        local versionLabel = Instance.new("TextLabel")
        versionLabel.Parent = statusFrame
        versionLabel.BackgroundTransparency = 1
        versionLabel.Position = UDim2.new(0, 0, 0.6, 0)
        versionLabel.Size = UDim2.new(1, 0, 0.4, 0)
        versionLabel.Font = Enum.Font.Gotham
        versionLabel.Text = "Enhanced Combat AI with Professional Grade Systems"
        versionLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
        versionLabel.TextSize = 12
        versionLabel.TextXAlignment = Enum.TextXAlignment.Center
        
        -- Enhanced Control Functions
        local function createButton(text, callback, color)
            local button = Instance.new("TextButton")
            button.Parent = scroll
            button.BackgroundColor3 = color or CurrentTheme.Accent
            button.Size = UDim2.new(1, 0, 0, 40)
            button.Font = Enum.Font.GothamBold
            button.Text = text
            button.TextColor3 = CurrentTheme.TextPrimary
            button.TextSize = 15
            button.AutoButtonColor = false
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = button
            
            local gradient = Instance.new("UIGradient")
            gradient.Rotation = 45
            gradient.Parent = button
            
            button.MouseEnter:Connect(function()
                Utils.CreateTween(button, {BackgroundColor3 = Color3.fromRGB(
                    math.min(255, color.R * 255 + 30),
                    math.min(255, color.G * 255 + 30),
                    math.min(255, color.B * 255 + 30)
                )}, 0.2)
            end)
            
            button.MouseLeave:Connect(function()
                Utils.CreateTween(button, {BackgroundColor3 = color or CurrentTheme.Accent}, 0.2)
            end)
            
            button.MouseButton1Click:Connect(function()
                Utils.RippleEffect(button, Mouse.Hit.Position)
                if callback then callback() end
            end)
            
            return button
        end
        
        local function createToggle(text, default, callback)
            local toggled = default or false
            
            local frame = Instance.new("Frame")
            frame.Parent = scroll
            frame.BackgroundColor3 = CurrentTheme.SecondaryBackground
            frame.Size = UDim2.new(1, 0, 0, 45)
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 8)
            frameCorner.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 20, 0, 0)
            label.Size = UDim2.new(0.65, 0, 1, 0)
            label.Font = Enum.Font.GothamSemibold
            label.Text = text
            label.TextColor3 = CurrentTheme.TextSecondary
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Parent = frame
            toggleButton.BackgroundColor3 = toggled and CurrentTheme.Success or CurrentTheme.Error
            toggleButton.Position = UDim2.new(0.8, 0, 0.25, 0)
            toggleButton.Size = UDim2.new(0, 70, 0, 22)
            toggleButton.Font = Enum.Font.GothamBold
            toggleButton.Text = toggled and "ENABLED" or "DISABLED"
            toggleButton.TextColor3 = CurrentTheme.TextPrimary
            toggleButton.TextSize = 10
            toggleButton.AutoButtonColor = false
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 11)
            toggleCorner.Parent = toggleButton
            
            toggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                Utils.CreateTween(toggleButton, {
                    BackgroundColor3 = toggled and CurrentTheme.Success or CurrentTheme.Error
                }, 0.2)
                
                toggleButton.Text = toggled and "ENABLED" or "DISABLED"
                
                if callback then callback(toggled) end
            end)
            
            return {
                Set = function(value)
                    toggled = value
                    Utils.CreateTween(toggleButton, {
                        BackgroundColor3 = toggled and CurrentTheme.Success or CurrentTheme.Error
                    }, 0.2)
                    toggleButton.Text = toggled and "ENABLED" or "DISABLED"
                end
            }
        end
        
        -- Control Buttons
        createButton("🚀 START KRAKEN AUTOFARM", function()
            autofarm.start()
            DiscordLib:Notification("KRAKEN Activated", "Combat system online - All systems operational", "success", 4)
        end, CurrentTheme.Success)
        
        createButton("⏹️ STOP KRAKEN AUTOFARM", function()
            autofarm.stop()
            DiscordLib:Notification("KRAKEN Deactivated", "Combat system offline - All operations ceased", "warning", 4)
        end, CurrentTheme.Error)
        
        -- Anti-AFK Settings Section
        local afkHeader = Instance.new("TextLabel")
        afkHeader.Parent = scroll
        afkHeader.BackgroundTransparency = 1
        afkHeader.Size = UDim2.new(1, 0, 0, 30)
        afkHeader.Font = Enum.Font.GothamBold
        afkHeader.Text = "🛡️ ANTI-AFK PROTECTION SYSTEMS"
        afkHeader.TextColor3 = CurrentTheme.Accent
        afkHeader.TextSize = 14
        afkHeader.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Anti-AFK Toggles
        createToggle("🔄 Virtual Input Method (Primary)", true, function(enabled)
            antiAFK.setMethod("virtualInput", enabled)
            if enabled then
                DiscordLib:Notification("Virtual Input Enabled", "Primary anti-AFK method activated", "info", 3)
            else
                DiscordLib:Notification("Virtual Input Disabled", "Primary anti-AFK method deactivated", "warning", 3)
            end
        end)
        
        createToggle("🖱️ Mouse Movement Method", false, function(enabled)
            antiAFK.setMethod("mouseMovement", enabled)
            if enabled then
                DiscordLib:Notification("Mouse Movement Enabled", "Secondary anti-AFK method activated", "info", 3)
            end
        end)
        
        createToggle("🚶 Character Movement Method", false, function(enabled)
            antiAFK.setMethod("characterMovement", enabled)
            if enabled then
                DiscordLib:Notification("Character Movement Enabled", "Tertiary anti-AFK method activated", "info", 3)
            end
        end)
        
        createToggle("🦘 Jump Spam Method (Noticeable)", false, function(enabled)
            antiAFK.setMethod("jumpSpam", enabled)
            if enabled then
                DiscordLib:Notification("Jump Spam Enabled", "WARNING: This method is more noticeable", "warning", 3)
            end
        end)
        
        -- Combat Settings Section
        local combatHeader = Instance.new("TextLabel")
        combatHeader.Parent = scroll
        combatHeader.BackgroundTransparency = 1
        combatHeader.Size = UDim2.new(1, 0, 0, 30)
        combatHeader.Font = Enum.Font.GothamBold
        combatHeader.Text = "⚔️ COMBAT SYSTEM CONFIGURATION"
        combatHeader.TextColor3 = CurrentTheme.Warning
        combatHeader.TextSize = 14
        combatHeader.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Enhanced Distance Slider
        local distanceFrame = Instance.new("Frame")
        distanceFrame.Parent = scroll
        distanceFrame.BackgroundColor3 = CurrentTheme.SecondaryBackground
        distanceFrame.Size = UDim2.new(1, 0, 0, 60)
        
        local distanceCorner = Instance.new("UICorner")
        distanceCorner.CornerRadius = UDim.new(0, 8)
        distanceCorner.Parent = distanceFrame
        
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Parent = distanceFrame
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.Position = UDim2.new(0, 20, 0, 5)
        distanceLabel.Size = UDim2.new(1, -40, 0, 25)
        distanceLabel.Font = Enum.Font.GothamSemibold
        distanceLabel.Text = "⚡ Combat Engagement Distance: " .. autofarm.distance .. " studs"
        distanceLabel.TextColor3 = CurrentTheme.TextSecondary
        distanceLabel.TextSize = 13
        distanceLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local distanceSlider = Instance.new("Frame")
        distanceSlider.Parent = distanceFrame
        distanceSlider.BackgroundColor3 = CurrentTheme.Border
        distanceSlider.Position = UDim2.new(0, 20, 0, 35)
        distanceSlider.Size = UDim2.new(1, -40, 0, 12)
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 6)
        sliderCorner.Parent = distanceSlider
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Parent = distanceSlider
        sliderFill.BackgroundColor3 = CurrentTheme.Accent
        sliderFill.Size = UDim2.new((autofarm.distance / 10), 0, 1, 0)
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 6)
        fillCorner.Parent = sliderFill
        
        local sliderButton = Instance.new("TextButton")
        sliderButton.Parent = distanceSlider
        sliderButton.BackgroundColor3 = CurrentTheme.TextPrimary
        sliderButton.Position = UDim2.new((autofarm.distance / 10), -8, -0.25, 0)
        sliderButton.Size = UDim2.new(0, 16, 0, 18)
        sliderButton.Text = ""
        sliderButton.AutoButtonColor = false
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 8)
        buttonCorner.Parent = sliderButton
        
        local dragging = false
        
        sliderButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        
        sliderButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relativePos = math.clamp((input.Position.X - distanceSlider.AbsolutePosition.X) / distanceSlider.AbsoluteSize.X, 0, 1)
                local newDistance = math.floor(relativePos * 10) + 1
                
                autofarm.distance = newDistance
                distanceLabel.Text = "⚡ Combat Engagement Distance: " .. newDistance .. " studs"
                
                sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
                sliderButton.Position = UDim2.new(relativePos, -8, -0.25, 0)
            end
        end)
        
        -- Enhanced Info Section
        local infoFrame = Instance.new("Frame")
        infoFrame.Parent = scroll
        infoFrame.BackgroundColor3 = CurrentTheme.SecondaryBackground
        infoFrame.Size = UDim2.new(1, 0, 0, 180)
        
        local infoCorner = Instance.new("UICorner")
        infoCorner.CornerRadius = UDim.new(0, 8)
        infoCorner.Parent = infoFrame
        
        local infoTitle = Instance.new("TextLabel")
        infoTitle.Parent = infoFrame
        infoTitle.BackgroundTransparency = 1
        infoTitle.Position = UDim2.new(0, 20, 0, 10)
        infoTitle.Size = UDim2.new(1, -40, 0, 25)
        infoTitle.Font = Enum.Font.GothamBold
        infoTitle.Text = "📋 KRAKEN SYSTEM INFORMATION"
        infoTitle.TextColor3 = CurrentTheme.Accent
        infoTitle.TextSize = 14
        infoTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local infoText = Instance.new("TextLabel")
        infoText.Parent = infoFrame
        infoText.BackgroundTransparency = 1
        infoText.Position = UDim2.new(0, 20, 0, 35)
        infoText.Size = UDim2.new(1, -40, 1, -45)
        infoText.Font = Enum.Font.Gotham
        infoText.Text = [[• Primary Targets: Saiba, Saiyan, Chi, Boxer
• Attack Rate: 7.0 APS (Anti-detection optimized)
• Health Display: Real-time monitoring with color coding
• Hitbox Visualization: Enhanced with glow effects
• Camera Control: Professional auto-focus system
• Movement: Smart positioning behind targets
• Anti-AFK: Virtual input every 19 minutes (primary)
• Additional Methods: Mouse, character, jump available
• Toggle Key: Press 'Z' to hide/show interface
• Framework: KRAKEN Enhanced Combat AI v2.0]]
        infoText.TextColor3 = CurrentTheme.TextMuted
        infoText.TextSize = 11
        infoText.TextXAlignment = Enum.TextXAlignment.Left
        infoText.TextYAlignment = Enum.TextYAlignment.Top
        infoText.TextWrapped = true
        
        -- Update canvas size
        layout.Changed:Connect(function()
            scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 50)
        end)
    end
    
    createKrakenControls()
    
    return windowData
end

-- ═══════════════════════════════════════════
-- KRAKEN SYSTEM INITIALIZATION
-- ═══════════════════════════════════════════

-- Initialize the Enhanced GUI
local win = DiscordLib:Window("🔥 KRAKEN Enhanced - Final Stand Combat AI v2.0")

-- Start anti-AFK system
startAntiAFK()

-- Enhanced welcome sequence
DiscordLib:Notification("KRAKEN Framework Loaded! 🔥", "Enhanced combat system with professional grade AI ready for deployment", "success", 5)

task.wait(2)
DiscordLib:Notification("All Systems Online ⚡", "Anti-AFK protection active • Press 'Z' for instant toggle • Ready for combat", "info", 5)

task.wait(3)
DiscordLib:Notification("Pro Tip 💡", "Use START KRAKEN AUTOFARM to begin operations • Full hitbox visualization included", "warning", 4)

-- Make enhanced systems global
getgenv().autofarm = autofarm
getgenv().antiAFK = antiAFK
getgenv().DiscordLib = DiscordLib

-- Enhanced system initialization output
print("═══════════════════════════════════════════")
print("    KRAKEN Enhanced - Professional AI     ")
print("      Final Stand Combat System v2.0       ")
print("═══════════════════════════════════════════")
print("[✓] Ultra-dark theme activated")
print("[✓] Enhanced blur effects enabled")
print("[✓] KRAKEN autofarm system loaded") 
print("[✓] Professional anti-AFK active")
print("[✓] Hitbox visualization ready")
print("[✓] Real-time health monitoring ready")
print("[✓] Smart positioning system ready")
print("[✓] Z-key toggle functionality active")
print("[✓] All systems operational")
print("═══════════════════════════════════════════")
print("[KRAKEN] Ready for combat deployment")
print("[CONTROL] Use GUI controls or command line")
print("[TOGGLE] Press 'Z' to hide/show interface")
print("═══════════════════════════════════════════")

-- Auto-save system
if Config.AutoSave then
    task.spawn(function()
        while true do
            task.wait(60) -- Save every minute
            SaveSystem.Save()
        end
    end)
end
