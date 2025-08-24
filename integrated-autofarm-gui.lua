--[[
    Enhanced Discord UI Library v2.0 - Final Stand Integration
    
    Features:
    ✓ Much darker theme for professional look
    ✓ Smooth animations & blur effects
    ✓ Modern toast notifications
    ✓ Z-key toggle functionality
    ✓ Complete Final Stand autofarm system
    ✓ Professional anti-AFK system
    ✓ Real-time combat monitoring
    ✓ Smart targeting and positioning
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

print("[SYSTEM] Initializing Final Stand GUI with Autofarm...")

-- Configuration
local Config = {
    AnimationSpeed = 0.3,
    DefaultTheme = "Dark",
    EnableSounds = true,
    EnableParticles = true,
    AutoSave = true,
    MaxTooltipWidth = 200,
    DebugMode = false
}

-- Enhanced Darker Theme
local Themes = {
    Dark = {
        Background = Color3.fromRGB(16, 18, 21),         -- Much darker background
        SecondaryBackground = Color3.fromRGB(24, 26, 30), -- Darker secondary
        TertiaryBackground = Color3.fromRGB(32, 35, 39),  -- Darker tertiary
        TextPrimary = Color3.fromRGB(240, 242, 245),      -- Softer white
        TextSecondary = Color3.fromRGB(170, 175, 185),    -- Muted secondary text
        TextMuted = Color3.fromRGB(100, 105, 115),        -- More muted
        Accent = Color3.fromRGB(88, 101, 242),            -- Discord purple
        AccentHover = Color3.fromRGB(71, 82, 196),        -- Darker purple hover
        Success = Color3.fromRGB(67, 181, 129),           -- Green success
        Warning = Color3.fromRGB(250, 166, 26),           -- Orange warning
        Error = Color3.fromRGB(240, 71, 71),              -- Red error
        Border = Color3.fromRGB(40, 43, 48)               -- Darker borders
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
        return HttpService:JSONDecode(readfile("enhanced_discord_lib_config.json"))
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
            writefile("enhanced_discord_lib_config.json", HttpService:JSONEncode(userinfo))
        end)
    end
end

-- Initialize save system
SaveSystem.Load()

-- Core UI Creation
local Discord = Instance.new("ScreenGui")
Discord.Name = "EnhancedDiscordLib"
Discord.Parent = game.CoreGui
Discord.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Discord.ResetOnSpawn = false

-- Enhanced Blur Effects
local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Name = "DiscordLibBlur"
BlurEffect.Size = 0
BlurEffect.Parent = game.Lighting

local ColorCorrection = Instance.new("ColorCorrectionEffect")
ColorCorrection.Name = "DiscordLibColorCorrection"
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
-- AUTOFARM SYSTEM INTEGRATION
-- ═══════════════════════════════════════════

-- Anti-AFK System Configuration
local antiAFK = {
    enabled = true,
    methods = {
        virtualInput = true,
        mouseMovement = false,
        characterMovement = false,
        jumpSpam = false
    },
    intervals = {
        virtualInput = 1140,      -- Every 19 minutes
        mouseMovement = 30,
        characterMovement = 60,
        jumpSpam = 120
    },
    lastActivation = {
        virtualInput = 0,
        mouseMovement = 0,
        characterMovement = 0,
        jumpSpam = 0
    },
    connection = nil
}

-- Autofarm state
local autofarm = {
    enabled = false,
    distance = 3,
    npcs = {"Saiba", "Saiyan", "Chi", "Boxer"},
    connections = {},
    currentTarget = nil,
    isMovingToTarget = false,
    activeTween = nil,
    lastAttackTime = 0,
    healthGui = nil,
    hitboxPart = nil
}

-- Get closest matching NPC
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
        
        local npcMatches = false
        if #autofarm.npcs > 0 then
            for _, targetName in pairs(autofarm.npcs) do
                if npc.Name:lower():find(targetName:lower()) then
                    npcMatches = true
                    break
                end
            end
        else
            npcMatches = true
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

-- Attack function
local function attack()
    if LocalPlayer.Backpack:FindFirstChild("ServerTraits") and LocalPlayer.Backpack.ServerTraits:FindFirstChild("Input") then
        LocalPlayer.Backpack.ServerTraits.Input:FireServer({"md"}, CFrame.new())
    end
end

-- Health GUI
local function createHealthGui(target)
    if autofarm.healthGui then
        autofarm.healthGui:Destroy()
    end
    
    local gui = Instance.new("BillboardGui")
    gui.Name = "CombatHealthDisplay"
    gui.Size = UDim2.new(0, 240, 0, 60)
    gui.StudsOffset = Vector3.new(0, 4, 0)
    gui.Parent = target:FindFirstChild("Head") or target:FindFirstChild("HumanoidRootPart")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(16, 18, 21)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = gui
    
    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(1, -10, 0.4, 0)
    healthBg.Position = UDim2.new(0, 5, 0.6, -2)
    healthBg.BackgroundColor3 = Color3.fromRGB(40, 43, 48)
    healthBg.BorderSizePixel = 0
    healthBg.Parent = frame
    
    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(67, 181, 129)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = healthBg
    
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0.6, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = string.format("%s | %d/%d HP", target.Name, math.floor(target.Humanoid.Health), math.floor(target.Humanoid.MaxHealth))
    healthLabel.TextColor3 = Color3.fromRGB(240, 242, 245)
    healthLabel.TextScaled = true
    healthLabel.Font = Enum.Font.GothamBold
    healthLabel.TextStrokeTransparency = 0.5
    healthLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    healthLabel.Parent = frame
    
    autofarm.healthGui = gui
    return gui
end

-- Update Health GUI
local function updateHealthGui(target)
    if autofarm.healthGui and target and target:FindFirstChildOfClass("Humanoid") then
        local frame = autofarm.healthGui.Frame
        local healthLabel = frame.TextLabel
        local healthBar = frame.Frame.HealthBar
        
        local currentHealth = math.floor(target.Humanoid.Health)
        local maxHealth = math.floor(target.Humanoid.MaxHealth)
        local healthPercent = target.Humanoid.Health / target.Humanoid.MaxHealth
        
        healthLabel.Text = string.format("%s | %d/%d HP (%.1f%%)", target.Name, currentHealth, maxHealth, healthPercent * 100)
        healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
        
        if healthPercent > 0.7 then
            healthBar.BackgroundColor3 = Color3.fromRGB(67, 181, 129)
            healthLabel.TextColor3 = Color3.fromRGB(240, 242, 245)
        elseif healthPercent > 0.4 then
            healthBar.BackgroundColor3 = Color3.fromRGB(250, 166, 26)
            healthLabel.TextColor3 = Color3.fromRGB(240, 242, 245)
        else
            healthBar.BackgroundColor3 = Color3.fromRGB(240, 71, 71)
            healthLabel.TextColor3 = Color3.fromRGB(240, 242, 245)
        end
    end
end

-- Smart positioning
local function smartPositionBehindNPC(target)
    if not target or not target:FindFirstChild("HumanoidRootPart") or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local character = LocalPlayer.Character
    local playerRootPart = character.HumanoidRootPart
    local targetRootPart = target.HumanoidRootPart
    
    local targetCFrame = targetRootPart.CFrame
    local behindOffset = targetCFrame.LookVector * -(autofarm.distance + 1.2)
    local behindPosition = targetCFrame.Position + behindOffset
    local desiredCFrame = CFrame.lookAt(behindPosition, targetRootPart.Position)
    
    local currentDistance = (playerRootPart.Position - behindPosition).Magnitude
    
    if currentDistance > 20 and not autofarm.isMovingToTarget then
        autofarm.isMovingToTarget = true
        
        if autofarm.activeTween then
            autofarm.activeTween:Cancel()
        end
        
        local tweenTime = math.min(currentDistance / 35, 1.2)
        autofarm.activeTween = TweenService:Create(
            playerRootPart,
            TweenInfo.new(tweenTime, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0),
            {CFrame = desiredCFrame}
        )
        
        autofarm.activeTween:Play()
        autofarm.activeTween.Completed:Connect(function()
            autofarm.isMovingToTarget = false
            autofarm.activeTween = nil
        end)
    elseif not autofarm.isMovingToTarget then
        playerRootPart.CFrame = desiredCFrame
    end
end

-- Camera control
local function updateCameraToTarget(target)
    if not target or not target:FindFirstChild("HumanoidRootPart") or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local playerRootPart = LocalPlayer.Character.HumanoidRootPart
    local targetRootPart = target.HumanoidRootPart
    
    local targetCFrame = targetRootPart.CFrame
    local cameraPosition = playerRootPart.Position + Vector3.new(0, 2, 0)
    local targetLookDirection = targetCFrame.Position + (targetCFrame.LookVector * 10)
    
    Camera.CFrame = CFrame.lookAt(cameraPosition, targetLookDirection)
end

-- Anti-AFK Functions
local function performVirtualInput()
    local keys = {Enum.KeyCode.LeftShift, Enum.KeyCode.LeftControl, Enum.KeyCode.Tab}
    local randomKey = keys[math.random(#keys)]
    
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, randomKey, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, randomKey, false, game)
    end)
end

local function handleAntiAFK()
    if not antiAFK.enabled then return end
    
    local currentTime = tick()
    
    if antiAFK.methods.virtualInput and (currentTime - antiAFK.lastActivation.virtualInput) >= antiAFK.intervals.virtualInput then
        performVirtualInput()
        antiAFK.lastActivation.virtualInput = currentTime
        print("[ANTI-AFK] Virtual input activated")
    end
end

-- Start Anti-AFK
local function startAntiAFK()
    if antiAFK.connection then
        antiAFK.connection:Disconnect()
    end
    
    antiAFK.connection = RunService.Heartbeat:Connect(function()
        handleAntiAFK()
    end)
    
    print("[ANTI-AFK] System activated")
end

-- Main autofarm functions
function autofarm.start()
    if autofarm.enabled then
        print("⚠️ Autofarm already running!")
        return
    end
    
    autofarm.enabled = true
    
    autofarm.connections.main = RunService.Heartbeat:Connect(function()
        if not autofarm.enabled then return end
        
        if not Workspace:FindFirstChild("Live") or not Workspace.Live:FindFirstChild(LocalPlayer.Name) then
            return
        end
        
        local target = getClosestNPC()
        if target then
            if autofarm.currentTarget ~= target then
                autofarm.currentTarget = target
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - target.HumanoidRootPart.Position).Magnitude
                print(string.format("[TARGET] Acquired: %s | Distance: %.1f studs", target.Name, distance))
                
                createHealthGui(target)
            end
            
            updateHealthGui(target)
            updateCameraToTarget(target)
            smartPositionBehindNPC(target)
            
            local currentTime = tick()
            if currentTime - autofarm.lastAttackTime >= 0.14 then
                attack()
                autofarm.lastAttackTime = currentTime
            end
        else
            if autofarm.currentTarget then
                print("[SYSTEM] No valid targets - Standing by...")
            end
            
            autofarm.currentTarget = nil
            
            if autofarm.healthGui then
                autofarm.healthGui:Destroy()
                autofarm.healthGui = nil
            end
        end
    end)
    
    print("[SYSTEM] Combat system activated")
end

function autofarm.stop()
    autofarm.enabled = false
    autofarm.currentTarget = nil
    autofarm.isMovingToTarget = false
    
    if autofarm.activeTween then
        autofarm.activeTween:Cancel()
        autofarm.activeTween = nil
    end
    
    if autofarm.healthGui then
        autofarm.healthGui:Destroy()
        autofarm.healthGui = nil
    end
    
    for _, connection in pairs(autofarm.connections) do
        if connection then
            connection:Disconnect()
        end
    end
    autofarm.connections = {}
    
    print("[SYSTEM] Combat system deactivated")
end

function autofarm.setDistance(distance)
    autofarm.distance = distance
    print("[CONFIG] Engagement distance updated: " .. distance .. " studs")
end

function autofarm.setTargets(npcTable)
    autofarm.npcs = npcTable
    print("[CONFIG] Target priority updated: " .. (#npcTable > 0 and table.concat(npcTable, ", ") or "All hostile entities"))
end

-- ═══════════════════════════════════════════
-- GUI SYSTEM (Simplified for Autofarm Integration)
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

-- Notification System
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
        info = "ℹ"
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
    
    -- Accent bar
    local AccentBar = Instance.new("Frame")
    AccentBar.Name = "AccentBar"
    AccentBar.Parent = Toast
    AccentBar.BackgroundColor3 = accentColor
    AccentBar.BorderSizePixel = 0
    AccentBar.Size = UDim2.new(0, 4, 1, 0)
    AccentBar.ZIndex = 151
    
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
    ToastTitle.Font = Enum.Font.GothamSemibold
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

-- Main Window Function
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
    MainFrame.Size = UDim2.new(0, 681, 0, 396)
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame
    
    -- Top Frame
    local TopFrame = Instance.new("Frame")
    TopFrame.Name = "TopFrame"
    TopFrame.Parent = MainFrame
    TopFrame.BackgroundColor3 = CurrentTheme.Background
    TopFrame.BackgroundTransparency = 1
    TopFrame.BorderSizePixel = 0
    TopFrame.Size = UDim2.new(1, 0, 0, 22)
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Parent = TopFrame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.015, 0, 0, 0)
    Title.Size = UDim2.new(0, 400, 0, 23)
    Title.Font = Enum.Font.GothamBold
    Title.Text = text or "Final Stand - Combat System"
    Title.TextColor3 = CurrentTheme.TextPrimary
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TopFrame
    CloseBtn.BackgroundColor3 = CurrentTheme.Background
    CloseBtn.Position = UDim2.new(0.959, 0, -0.017, 0)
    CloseBtn.Size = UDim2.new(0, 28, 0, 22)
    CloseBtn.Font = Enum.Font.Gotham
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = CurrentTheme.TextSecondary
    CloseBtn.TextSize = 18
    CloseBtn.BorderSizePixel = 0
    CloseBtn.AutoButtonColor = false
    
    CloseBtn.MouseEnter:Connect(function()
        Utils.CreateTween(CloseBtn, {BackgroundColor3 = CurrentTheme.Error}, 0.2)
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        Utils.CreateTween(CloseBtn, {BackgroundColor3 = CurrentTheme.Background}, 0.2)
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        autofarm.stop()
        Utils.CreateTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        Discord:Destroy()
    end)
    
    -- Content Area
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundColor3 = CurrentTheme.TertiaryBackground
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Position = UDim2.new(0, 0, 0, 22)
    ContentFrame.Size = UDim2.new(1, 0, 1, -22)
    
    -- Make window draggable
    MakeDraggable(TopFrame, MainFrame)
    
    -- Enhanced blur effects
    Utils.CreateTween(BlurEffect, {Size = 24}, Config.AnimationSpeed)
    Utils.CreateTween(ColorCorrection, {Contrast = -0.2, Brightness = -0.1, Saturation = -0.1}, Config.AnimationSpeed)
    
    -- Z-Key Toggle
    local isVisible = true
    
    local function toggleWindow()
        isVisible = not isVisible
        
        if isVisible then
            MainFrame.Visible = true
            Utils.CreateTween(MainFrame, {BackgroundTransparency = 0}, Config.AnimationSpeed * 0.5)
            Utils.CreateTween(BlurEffect, {Size = 24}, Config.AnimationSpeed)
            Utils.CreateTween(ColorCorrection, {Contrast = -0.2, Brightness = -0.1}, Config.AnimationSpeed)
            DiscordLib:Notification("GUI Toggled", "Combat interface is now visible", "success", 2)
        else
            Utils.CreateTween(MainFrame, {BackgroundTransparency = 1}, Config.AnimationSpeed * 0.5)
            Utils.CreateTween(BlurEffect, {Size = 0}, Config.AnimationSpeed)
            Utils.CreateTween(ColorCorrection, {Contrast = 0, Brightness = 0}, Config.AnimationSpeed)
            
            task.wait(Config.AnimationSpeed * 0.5)
            if not isVisible then
                MainFrame.Visible = false
            end
            
            DiscordLib:Notification("GUI Hidden", "Press Z to show combat interface", "info", 2)
        end
    end
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.Z then
            toggleWindow()
        end
    end)
    
    -- Create Autofarm Controls
    local function createAutofarmControls()
        local scroll = Instance.new("ScrollingFrame")
        scroll.Parent = ContentFrame
        scroll.BackgroundTransparency = 1
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.CanvasSize = UDim2.new(0, 0, 0, 800)
        scroll.ScrollBarThickness = 6
        scroll.ScrollBarImageColor3 = CurrentTheme.Border
        
        local layout = Instance.new("UIListLayout")
        layout.Parent = scroll
        layout.Padding = UDim.new(0, 8)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        
        local padding = Instance.new("UIPadding")
        padding.Parent = scroll
        padding.PaddingLeft = UDim.new(0, 20)
        padding.PaddingRight = UDim.new(0, 20)
        padding.PaddingTop = UDim.new(0, 20)
        
        -- Status Label
        local statusLabel = Instance.new("TextLabel")
        statusLabel.Parent = scroll
        statusLabel.BackgroundTransparency = 1
        statusLabel.Size = UDim2.new(1, 0, 0, 30)
        statusLabel.Font = Enum.Font.GothamBold
        statusLabel.Text = "🔥 FINAL STAND - COMBAT SYSTEM"
        statusLabel.TextColor3 = CurrentTheme.Accent
        statusLabel.TextSize = 16
        statusLabel.TextXAlignment = Enum.TextXAlignment.Center
        
        -- Main Controls
        local function createButton(text, callback)
            local button = Instance.new("TextButton")
            button.Parent = scroll
            button.BackgroundColor3 = CurrentTheme.Accent
            button.Size = UDim2.new(1, 0, 0, 35)
            button.Font = Enum.Font.GothamSemibold
            button.Text = text
            button.TextColor3 = CurrentTheme.TextPrimary
            button.TextSize = 14
            button.AutoButtonColor = false
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = button
            
            button.MouseEnter:Connect(function()
                Utils.CreateTween(button, {BackgroundColor3 = CurrentTheme.AccentHover}, 0.2)
            end)
            
            button.MouseLeave:Connect(function()
                Utils.CreateTween(button, {BackgroundColor3 = CurrentTheme.Accent}, 0.2)
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
            frame.Size = UDim2.new(1, 0, 0, 35)
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 6)
            frameCorner.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Parent = frame
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 15, 0, 0)
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.Font = Enum.Font.Gotham
            label.Text = text
            label.TextColor3 = CurrentTheme.TextSecondary
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Parent = frame
            toggleButton.BackgroundColor3 = toggled and CurrentTheme.Success or CurrentTheme.Error
            toggleButton.Position = UDim2.new(0.85, 0, 0.2, 0)
            toggleButton.Size = UDim2.new(0, 60, 0, 21)
            toggleButton.Font = Enum.Font.GothamBold
            toggleButton.Text = toggled and "ON" or "OFF"
            toggleButton.TextColor3 = CurrentTheme.TextPrimary
            toggleButton.TextSize = 11
            toggleButton.AutoButtonColor = false
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 10)
            toggleCorner.Parent = toggleButton
            
            toggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                Utils.CreateTween(toggleButton, {
                    BackgroundColor3 = toggled and CurrentTheme.Success or CurrentTheme.Error
                }, 0.2)
                
                toggleButton.Text = toggled and "ON" or "OFF"
                
                if callback then callback(toggled) end
            end)
            
            return {
                Set = function(value)
                    toggled = value
                    Utils.CreateTween(toggleButton, {
                        BackgroundColor3 = toggled and CurrentTheme.Success or CurrentTheme.Error
                    }, 0.2)
                    toggleButton.Text = toggled and "ON" or "OFF"
                end
            }
        end
        
        -- Control Buttons
        createButton("🚀 START AUTOFARM", function()
            autofarm.start()
            DiscordLib:Notification("Autofarm Started", "Combat system is now active", "success", 3)
        end)
        
        createButton("⏹️ STOP AUTOFARM", function()
            autofarm.stop()
            DiscordLib:Notification("Autofarm Stopped", "Combat system deactivated", "warning", 3)
        end)
        
        -- Settings
        local antiAfkToggle = createToggle("🔄 Anti-AFK System", true, function(enabled)
            antiAFK.enabled = enabled
            if enabled then
                startAntiAFK()
                DiscordLib:Notification("Anti-AFK Enabled", "System will prevent AFK kick", "info", 3)
            else
                if antiAFK.connection then
                    antiAFK.connection:Disconnect()
                end
                DiscordLib:Notification("Anti-AFK Disabled", "AFK protection turned off", "warning", 3)
            end
        end)
        
        -- Distance Slider
        local distanceFrame = Instance.new("Frame")
        distanceFrame.Parent = scroll
        distanceFrame.BackgroundColor3 = CurrentTheme.SecondaryBackground
        distanceFrame.Size = UDim2.new(1, 0, 0, 50)
        
        local distanceCorner = Instance.new("UICorner")
        distanceCorner.CornerRadius = UDim.new(0, 6)
        distanceCorner.Parent = distanceFrame
        
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Parent = distanceFrame
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.Position = UDim2.new(0, 15, 0, 5)
        distanceLabel.Size = UDim2.new(1, -30, 0, 20)
        distanceLabel.Font = Enum.Font.Gotham
        distanceLabel.Text = "⚡ Combat Distance: " .. autofarm.distance .. " studs"
        distanceLabel.TextColor3 = CurrentTheme.TextSecondary
        distanceLabel.TextSize = 13
        distanceLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local distanceSlider = Instance.new("Frame")
        distanceSlider.Parent = distanceFrame
        distanceSlider.BackgroundColor3 = CurrentTheme.Border
        distanceSlider.Position = UDim2.new(0, 15, 0, 30)
        distanceSlider.Size = UDim2.new(1, -30, 0, 8)
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.Parent = distanceSlider
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Parent = distanceSlider
        sliderFill.BackgroundColor3 = CurrentTheme.Accent
        sliderFill.Size = UDim2.new((autofarm.distance / 10), 0, 1, 0)
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.Parent = sliderFill
        
        local sliderButton = Instance.new("TextButton")
        sliderButton.Parent = distanceSlider
        sliderButton.BackgroundColor3 = CurrentTheme.TextPrimary
        sliderButton.Position = UDim2.new((autofarm.distance / 10), -6, -0.5, 0)
        sliderButton.Size = UDim2.new(0, 12, 0, 16)
        sliderButton.Text = ""
        sliderButton.AutoButtonColor = false
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
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
                distanceLabel.Text = "⚡ Combat Distance: " .. newDistance .. " studs"
                
                sliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
                sliderButton.Position = UDim2.new(relativePos, -6, -0.5, 0)
            end
        end)
        
        -- Info Section
        local infoFrame = Instance.new("Frame")
        infoFrame.Parent = scroll
        infoFrame.BackgroundColor3 = CurrentTheme.SecondaryBackground
        infoFrame.Size = UDim2.new(1, 0, 0, 120)
        
        local infoCorner = Instance.new("UICorner")
        infoCorner.CornerRadius = UDim.new(0, 6)
        infoCorner.Parent = infoFrame
        
        local infoText = Instance.new("TextLabel")
        infoText.Parent = infoFrame
        infoText.BackgroundTransparency = 1
        infoText.Position = UDim2.new(0, 15, 0, 10)
        infoText.Size = UDim2.new(1, -30, 1, -20)
        infoText.Font = Enum.Font.Gotham
        infoText.Text = [[📋 SYSTEM INFORMATION:

• Targets: Saiba, Saiyan, Chi, Boxer
• Attack Rate: 7.0 APS (optimized)
• Health Display: Real-time monitoring  
• Camera Control: Auto-focus on target
• Anti-AFK: Virtual input every 19 minutes
• Toggle Key: Press 'Z' to hide/show GUI]]
        infoText.TextColor3 = CurrentTheme.TextMuted
        infoText.TextSize = 11
        infoText.TextXAlignment = Enum.TextXAlignment.Left
        infoText.TextYAlignment = Enum.TextYAlignment.Top
        infoText.TextWrapped = true
        
        -- Update canvas size
        layout.Changed:Connect(function()
            scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 40)
        end)
    end
    
    createAutofarmControls()
    
    return windowData
end

-- ═══════════════════════════════════════════
-- INITIALIZATION
-- ═══════════════════════════════════════════

-- Initialize the GUI
local win = DiscordLib:Window("🔥 Final Stand - Combat System v2.0")

-- Start anti-AFK system
startAntiAFK()

-- Welcome notifications
DiscordLib:Notification("System Loaded! 🚀", "Final Stand combat system ready for deployment", "success", 4)

task.wait(2)
DiscordLib:Notification("Pro Tip 💡", "Press 'Z' to toggle GUI visibility with smooth blur effects", "info", 5)

-- Make systems global
getgenv().autofarm = autofarm
getgenv().antiAFK = antiAFK
getgenv().DiscordLib = DiscordLib

print("═══════════════════════════════════════════")
print("    Final Stand - Professional Combat AI    ")
print("           Enhanced GUI v2.0                ")
print("═══════════════════════════════════════════")
print("[✓] Dark theme activated")
print("[✓] Blur effects enabled")
print("[✓] Z-key toggle ready") 
print("[✓] Anti-AFK system active")
print("[✓] Combat system standby")
print("═══════════════════════════════════════════")
