--[[
    ENHANCED RED THEME GUI LIBRARY
    Features: Keybinds, Notifications, Theme Changer, Smooth Dragging
]]

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Wait for player to load
repeat task.wait() until LocalPlayer and LocalPlayer.PlayerGui

-- Cleanup existing instances
for _, gui in pairs(game.CoreGui:GetChildren()) do
    if gui.Name == "RedThemeGUI" then
        gui:Destroy()
    end
end

for _, effect in pairs(game.Lighting:GetChildren()) do
    if effect.Name == "RedThemeBlur" then
        effect:Destroy()
    end
end

print("[RED-THEME] Loading Enhanced GUI Library...")

local RedThemeLib = {}

-- Configuration
local Config = {
    DragSpeed = 0.1,          -- Adjustable drag smoothing (lower = smoother)
    AnimationSpeed = 0.25,
    BlurIntensity = 15,
    EnableAnimations = true,
    EnableBlur = true,
    NotificationDuration = 4
}

-- Themes
local Themes = {
    Red = {
        Background = Color3.fromRGB(67, 67, 67),
        Sidebar = Color3.fromRGB(40, 15, 15),      -- More reddish
        Border = Color3.fromRGB(255, 0, 0),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 200),
        AccentRed = Color3.fromRGB(255, 50, 50),
        AccentDarkRed = Color3.fromRGB(150, 30, 30),
        Success = Color3.fromRGB(46, 125, 50),
        Warning = Color3.fromRGB(255, 152, 0),
        Error = Color3.fromRGB(244, 67, 54),
        ButtonNormal = Color3.fromRGB(45, 45, 45),
        ButtonHover = Color3.fromRGB(60, 60, 60)
    },
    Blue = {
        Background = Color3.fromRGB(67, 67, 67),
        Sidebar = Color3.fromRGB(15, 25, 40),
        Border = Color3.fromRGB(0, 100, 255),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 200),
        AccentRed = Color3.fromRGB(50, 100, 255),
        AccentDarkRed = Color3.fromRGB(30, 70, 150),
        Success = Color3.fromRGB(46, 125, 50),
        Warning = Color3.fromRGB(255, 152, 0),
        Error = Color3.fromRGB(244, 67, 54),
        ButtonNormal = Color3.fromRGB(45, 45, 45),
        ButtonHover = Color3.fromRGB(60, 60, 60)
    },
    Green = {
        Background = Color3.fromRGB(67, 67, 67),
        Sidebar = Color3.fromRGB(15, 40, 15),
        Border = Color3.fromRGB(0, 255, 0),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 200),
        AccentRed = Color3.fromRGB(50, 255, 50),
        AccentDarkRed = Color3.fromRGB(30, 150, 30),
        Success = Color3.fromRGB(46, 125, 50),
        Warning = Color3.fromRGB(255, 152, 0),
        Error = Color3.fromRGB(244, 67, 54),
        ButtonNormal = Color3.fromRGB(45, 45, 45),
        ButtonHover = Color3.fromRGB(60, 60, 60)
    }
}

local CurrentTheme = Themes.Red

-- Assets
local Assets = {
    ["add"] = "rbxassetid://14368300605",
    ["alert"] = "rbxassetid://14368301329",
    ["home"] = "rbxassetid://14368292698",
    ["settings"] = "rbxassetid://14368293672"
}

-- Utils
local Utils = {}
local NotificationContainer = nil

function Utils.Tween(object, properties, duration)
    if not Config.EnableAnimations then
        for property, value in pairs(properties) do
            object[property] = value
        end
        return
    end
    
    local info = TweenInfo.new(
        duration or Config.AnimationSpeed,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(object, info, properties)
    tween:Play()
    return tween
end

function Utils.MakeDraggable(frame, dragArea)
    local dragArea = dragArea or frame
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            
            -- Smooth dragging with tweening
            Utils.Tween(frame, {Position = targetPos}, Config.DragSpeed)
        end
    end)
    
    dragArea.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Notification System
function Utils.CreateNotification(title, description, notificationType)
    if not NotificationContainer then return end
    
    local notificationType = notificationType or "info"
    local notificationColors = {
        success = CurrentTheme.Success,
        warning = CurrentTheme.Warning,
        error = CurrentTheme.Error,
        info = CurrentTheme.AccentRed
    }
    
    local color = notificationColors[notificationType] or CurrentTheme.AccentRed
    
    -- Create notification frame
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Parent = NotificationContainer
    notification.BackgroundColor3 = CurrentTheme.Background
    notification.BackgroundTransparency = 0.1  -- Slightly transparent
    notification.BorderColor3 = CurrentTheme.Border  -- Red border
    notification.BorderSizePixel = 1
    notification.Size = UDim2.new(0, 300, 0, 80)
    notification.Position = UDim2.new(0, 350, 0, 0)  -- Start off-screen
    
    -- Accent bar
    local accentBar = Instance.new("Frame")
    accentBar.Parent = notification
    accentBar.BackgroundColor3 = color
    accentBar.BorderSizePixel = 0
    accentBar.Size = UDim2.new(0, 4, 1, 0)
    accentBar.Position = UDim2.new(0, 0, 0, 0)
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = notification
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 15, 0, 5)
    titleLabel.Size = UDim2.new(1, -25, 0, 20)
    titleLabel.Text = title
    titleLabel.TextColor3 = CurrentTheme.TextPrimary
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Description
    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = notification
    descLabel.BackgroundTransparency = 1
    descLabel.Position = UDim2.new(0, 15, 0, 25)
    descLabel.Size = UDim2.new(1, -25, 0, 50)
    descLabel.Text = description
    descLabel.TextColor3 = CurrentTheme.TextSecondary
    descLabel.TextSize = 12
    descLabel.Font = Enum.Font.SourceSans
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Top
    descLabel.TextWrapped = true
    
    -- Animate in
    Utils.Tween(notification, {Position = UDim2.new(0, 0, 0, 0)}, 0.3)
    
    -- Auto remove after duration
    task.spawn(function()
        task.wait(Config.NotificationDuration)
        if notification and notification.Parent then
            Utils.Tween(notification, {Position = UDim2.new(0, 350, 0, 0)}, 0.3)
            task.wait(0.3)
            notification:Destroy()
        end
    end)
    
    -- Update layout
    local layout = NotificationContainer:FindFirstChild("UIListLayout")
    if layout then
        task.wait(0.1)
        for i, child in pairs(NotificationContainer:GetChildren()) do
            if child:IsA("Frame") and child ~= layout then
                child.Position = UDim2.new(0, 0, 0, (i-2) * 85)
            end
        end
    end
end

-- Keybind System
local KeybindWaiting = nil

function Utils.WaitForKeybind(callback)
    KeybindWaiting = callback
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if KeybindWaiting and input.UserInputType == Enum.UserInputType.Keyboard then
        local keyName = input.KeyCode.Name
        KeybindWaiting(keyName)
        KeybindWaiting = nil
    end
end)

-- Theme Changer
function Utils.ChangeTheme(themeName)
    if Themes[themeName] then
        CurrentTheme = Themes[themeName]
        Utils.CreateNotification("Theme Changed", "Switched to " .. themeName .. " theme", "success")
    end
end

-- Main GUI Creation
function RedThemeLib:CreateWindow(options)
    options = options or {}
    local title = options.Title or "Red Theme GUI"
    local size = options.Size or UDim2.new(0, 445, 0, 387)
    local position = options.Position or UDim2.new(0.5, -222, 0.5, -193)
    
    local windowData = {
        tabs = {},
        currentTab = nil
    }
    
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RedThemeGUI"
    screenGui.Parent = LocalPlayer.PlayerGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    
    -- Blur Effect
    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Name = "RedThemeBlur"
    blurEffect.Size = Config.EnableBlur and Config.BlurIntensity or 0
    blurEffect.Parent = game.Lighting
    
    -- Notification Container (Bottom Right)
    NotificationContainer = Instance.new("Frame")
    NotificationContainer.Name = "NotificationContainer"
    NotificationContainer.Parent = screenGui
    NotificationContainer.BackgroundTransparency = 1
    NotificationContainer.Position = UDim2.new(1, -320, 1, -100)
    NotificationContainer.Size = UDim2.new(0, 300, 0, 400)
    
    local notifLayout = Instance.new("UIListLayout")
    notifLayout.Parent = NotificationContainer
    notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    notifLayout.Padding = UDim.new(0, 5)
    
    -- Main Frame - ONLY this has border
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "Main"
    mainFrame.Parent = screenGui
    mainFrame.BackgroundColor3 = CurrentTheme.Background
    mainFrame.BorderColor3 = CurrentTheme.Border  -- Only main frame has border
    mainFrame.BorderSizePixel = 1
    mainFrame.Size = size
    mainFrame.Position = position
    mainFrame.ClipsDescendants = true
    
    -- Sidebar Frame - NO border, more reddish
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Parent = mainFrame
    sidebar.BackgroundColor3 = CurrentTheme.Sidebar  -- More reddish now
    sidebar.BorderSizePixel = 0  -- NO border
    sidebar.Size = UDim2.new(0, 115, 1, 0)
    sidebar.Position = UDim2.new(0, 0, 0, 0)
    
    -- Title Frame - NO border
    local titleFrame = Instance.new("Frame")
    titleFrame.Name = "TitleFrame"
    titleFrame.Parent = sidebar
    titleFrame.BackgroundColor3 = CurrentTheme.Sidebar
    titleFrame.BorderSizePixel = 0  -- NO border
    titleFrame.Size = UDim2.new(1, 0, 0, 40)
    titleFrame.Position = UDim2.new(0, 0, 0, 0)
    
    -- Title Label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Parent = titleFrame
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -30, 1, 0)
    titleLabel.Position = UDim2.new(0, 5, 0, 0)
    titleLabel.Text = title
    titleLabel.TextColor3 = CurrentTheme.TextPrimary
    titleLabel.TextSize = 12
    titleLabel.Font = Enum.Font.SourceSans
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button - NO border
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Parent = titleFrame
    closeButton.BackgroundColor3 = CurrentTheme.Error
    closeButton.BorderSizePixel = 0  -- NO border
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -25, 0, 10)
    closeButton.Text = "X"
    closeButton.TextColor3 = CurrentTheme.TextPrimary
    closeButton.TextSize = 12
    closeButton.Font = Enum.Font.SourceSansBold
    
    closeButton.MouseButton1Click:Connect(function()
        Utils.Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        Utils.Tween(blurEffect, {Size = 0}, 0.3)
        task.wait(0.3)
        screenGui:Destroy()
    end)
    
    closeButton.MouseEnter:Connect(function()
        Utils.Tween(closeButton, {BackgroundColor3 = CurrentTheme.AccentRed}, 0.2)
    end)
    
    closeButton.MouseLeave:Connect(function()
        Utils.Tween(closeButton, {BackgroundColor3 = CurrentTheme.Error}, 0.2)
    end)
    
    -- Username Label
    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Name = "Username"
    usernameLabel.Parent = sidebar
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Size = UDim2.new(1, -10, 0, 25)
    usernameLabel.Position = UDim2.new(0, 5, 1, -30)
    usernameLabel.Text = LocalPlayer.Name
    usernameLabel.TextColor3 = CurrentTheme.TextSecondary
    usernameLabel.TextSize = 10
    usernameLabel.Font = Enum.Font.SourceSans
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Parent = sidebar
    tabContainer.BackgroundTransparency = 1
    tabContainer.Size = UDim2.new(1, 0, 1, -70)
    tabContainer.Position = UDim2.new(0, 0, 0, 45)
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Parent = tabContainer
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 2)
    
    -- Content Frame - NO border
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Parent = mainFrame
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0  -- NO border
    contentFrame.Size = UDim2.new(0, 330, 1, 0)
    contentFrame.Position = UDim2.new(0, 115, 0, 0)
    contentFrame.ScrollBarImageColor3 = CurrentTheme.AccentRed
    contentFrame.ScrollBarThickness = 6
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    -- Content Layout
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Parent = contentFrame
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 5)
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.Parent = contentFrame
    contentPadding.PaddingTop = UDim.new(0, 10)
    contentPadding.PaddingLeft = UDim.new(0, 10)
    contentPadding.PaddingRight = UDim.new(0, 10)
    contentPadding.PaddingBottom = UDim.new(0, 10)
    
    -- Update content size
    local function updateContentSize()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateContentSize)
    
    -- Make window draggable (smooth)
    Utils.MakeDraggable(mainFrame, titleFrame)
    
    -- Window Functions
    windowData.screenGui = screenGui
    windowData.mainFrame = mainFrame
    windowData.sidebar = sidebar
    windowData.contentFrame = contentFrame
    windowData.tabContainer = tabContainer
    
    -- Create Tab Function
    function windowData:CreateTab(tabOptions)
        tabOptions = tabOptions or {}
        local tabName = tabOptions.Name or "New Tab"
        local tabIcon = tabOptions.Icon or Assets.home
        
        local tabData = {
            name = tabName,
            visible = false
        }
        
        -- Tab Button - NO border
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName .. "Tab"
        tabButton.Parent = tabContainer
        tabButton.BackgroundColor3 = CurrentTheme.Sidebar
        tabButton.BorderSizePixel = 0  -- NO border
        tabButton.Size = UDim2.new(1, 0, 0, 35)
        tabButton.Text = ""
        tabButton.AutoButtonColor = false
        
        -- Tab Icon
        local tabIconImage = Instance.new("ImageLabel")
        tabIconImage.Name = "Icon"
        tabIconImage.Parent = tabButton
        tabIconImage.BackgroundTransparency = 1
        tabIconImage.Size = UDim2.new(0, 16, 0, 16)
        tabIconImage.Position = UDim2.new(0, 8, 0.5, -8)
        tabIconImage.Image = tabIcon
        tabIconImage.ImageColor3 = CurrentTheme.TextSecondary
        
        -- Tab Label
        local tabLabel = Instance.new("TextLabel")
        tabLabel.Name = "Label"
        tabLabel.Parent = tabButton
        tabLabel.BackgroundTransparency = 1
        tabLabel.Size = UDim2.new(1, -35, 1, 0)
        tabLabel.Position = UDim2.new(0, 30, 0, 0)
        tabLabel.Text = tabName
        tabLabel.TextColor3 = CurrentTheme.TextSecondary
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.TextSize = 11
        tabLabel.Font = Enum.Font.SourceSans
        
        -- Tab Content Container
        local tabContent = Instance.new("Frame")
        tabContent.Name = tabName .. "Content"
        tabContent.Parent = contentFrame
        tabContent.BackgroundTransparency = 1
        tabContent.Size = UDim2.new(1, 0, 0, 0)
        tabContent.Visible = false
        
        local tabContentLayout = Instance.new("UIListLayout")
        tabContentLayout.Parent = tabContent
        tabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabContentLayout.Padding = UDim.new(0, 5)
        
        -- Tab functionality
        tabButton.MouseButton1Click:Connect(function()
            -- Hide all other tabs
            for _, tab in pairs(windowData.tabs) do
                tab.button.BackgroundColor3 = CurrentTheme.Sidebar
                tab.iconImage.ImageColor3 = CurrentTheme.TextSecondary
                tab.label.TextColor3 = CurrentTheme.TextSecondary
                tab.content.Visible = false
                tab.visible = false
            end
            
            -- Show this tab
            tabButton.BackgroundColor3 = CurrentTheme.AccentDarkRed
            tabIconImage.ImageColor3 = CurrentTheme.TextPrimary
            tabLabel.TextColor3 = CurrentTheme.TextPrimary
            tabContent.Visible = true
            tabData.visible = true
            
            windowData.currentTab = tabData
        end)
        
        tabButton.MouseEnter:Connect(function()
            if not tabData.visible then
                Utils.Tween(tabButton, {BackgroundColor3 = CurrentTheme.ButtonHover}, 0.2)
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if not tabData.visible then
                Utils.Tween(tabButton, {BackgroundColor3 = CurrentTheme.Sidebar}, 0.2)
            end
        end)
        
        -- Store tab data
        tabData.button = tabButton
        tabData.content = tabContent
        tabData.iconImage = tabIconImage
        tabData.label = tabLabel
        tabData.layout = tabContentLayout
        
        table.insert(windowData.tabs, tabData)
        
        -- Auto-select first tab
        if #windowData.tabs == 1 then
            tabButton.BackgroundColor3 = CurrentTheme.AccentDarkRed
            tabIconImage.ImageColor3 = CurrentTheme.TextPrimary
            tabLabel.TextColor3 = CurrentTheme.TextPrimary
            tabContent.Visible = true
            tabData.visible = true
            windowData.currentTab = tabData
        end
        
        -- Tab element creation functions
        function tabData:CreateButton(buttonOptions)
            buttonOptions = buttonOptions or {}
            local buttonText = buttonOptions.Text or "Button"
            local callback = buttonOptions.Callback or function() end
            
            local button = Instance.new("TextButton")
            button.Name = buttonText .. "Button"
            button.Parent = tabContent
            button.BackgroundColor3 = CurrentTheme.ButtonNormal
            button.BorderSizePixel = 0  -- NO border
            button.Size = UDim2.new(1, -10, 0, 35)
            button.Text = buttonText
            button.TextColor3 = CurrentTheme.TextPrimary
            button.TextSize = 12
            button.Font = Enum.Font.SourceSansBold
            button.AutoButtonColor = false
            
            button.MouseButton1Click:Connect(function()
                callback()
            end)
            
            button.MouseEnter:Connect(function()
                Utils.Tween(button, {BackgroundColor3 = CurrentTheme.ButtonHover}, 0.2)
            end)
            
            button.MouseLeave:Connect(function()
                Utils.Tween(button, {BackgroundColor3 = CurrentTheme.ButtonNormal}, 0.2)
            end)
            
            -- Update content size
            tabContent.Size = UDim2.new(1, 0, 0, tabContentLayout.AbsoluteContentSize.Y)
            updateContentSize()
            
            return button
        end
        
        function tabData:CreateKeybind(keybindOptions)
            keybindOptions = keybindOptions or {}
            local keybindText = keybindOptions.Text or "Keybind"
            local defaultKey = keybindOptions.Default or "None"
            local callback = keybindOptions.Callback or function() end
            
            local keybindFrame = Instance.new("Frame")
            keybindFrame.Name = keybindText .. "Keybind"
            keybindFrame.Parent = tabContent
            keybindFrame.BackgroundColor3 = CurrentTheme.ButtonNormal
            keybindFrame.BorderSizePixel = 0  -- NO border
            keybindFrame.Size = UDim2.new(1, -10, 0, 35)
            
            local keybindLabel = Instance.new("TextLabel")
            keybindLabel.Parent = keybindFrame
            keybindLabel.BackgroundTransparency = 1
            keybindLabel.Size = UDim2.new(0.6, 0, 1, 0)
            keybindLabel.Position = UDim2.new(0, 10, 0, 0)
            keybindLabel.Text = keybindText
            keybindLabel.TextColor3 = CurrentTheme.TextPrimary
            keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            keybindLabel.TextSize = 11
            keybindLabel.Font = Enum.Font.SourceSans
            
            local keybindButton = Instance.new("TextButton")
            keybindButton.Parent = keybindFrame
            keybindButton.BackgroundColor3 = CurrentTheme.AccentDarkRed
            keybindButton.BorderSizePixel = 0  -- NO border
            keybindButton.Size = UDim2.new(0, 80, 0, 25)
            keybindButton.Position = UDim2.new(1, -90, 0.5, -12)
            keybindButton.Text = defaultKey
            keybindButton.TextColor3 = CurrentTheme.TextPrimary
            keybindButton.TextSize = 10
            keybindButton.Font = Enum.Font.SourceSansBold
            keybindButton.AutoButtonColor = false
            
            local currentKey = defaultKey
            
            keybindButton.MouseButton1Click:Connect(function()
                keybindButton.Text = "Press a key..."
                Utils.WaitForKeybind(function(keyName)
                    currentKey = keyName
                    keybindButton.Text = keyName
                    Utils.CreateNotification("Keybind Set", keybindText .. " bound to " .. keyName, "success")
                end)
            end)
            
            -- Listen for the keybind
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed or KeybindWaiting then return end
                if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == currentKey then
                    callback()
                end
            end)
            
            -- Update content size
            tabContent.Size = UDim2.new(1, 0, 0, tabContentLayout.AbsoluteContentSize.Y)
            updateContentSize()
            
            return {
                SetKey = function(keyName)
                    currentKey = keyName
                    keybindButton.Text = keyName
                end
            }
        end
        
        function tabData:CreateToggle(toggleOptions)
            toggleOptions = toggleOptions or {}
            local toggleText = toggleOptions.Text or "Toggle"
            local defaultValue = toggleOptions.Default or false
            local callback = toggleOptions.Callback or function() end
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = toggleText .. "Toggle"
            toggleFrame.Parent = tabContent
            toggleFrame.BackgroundColor3 = CurrentTheme.ButtonNormal
            toggleFrame.BorderSizePixel = 0  -- NO border
            toggleFrame.Size = UDim2.new(1, -10, 0, 35)
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Parent = toggleFrame
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            toggleLabel.Position = UDim2.new(0, 10, 0, 0)
            toggleLabel.Text = toggleText
            toggleLabel.TextColor3 = CurrentTheme.TextPrimary
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.TextSize = 11
            toggleLabel.Font = Enum.Font.SourceSans
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Parent = toggleFrame
            toggleButton.BackgroundColor3 = defaultValue and CurrentTheme.Success or CurrentTheme.Error
            toggleButton.BorderSizePixel = 0  -- NO border
            toggleButton.Size = UDim2.new(0, 50, 0, 20)
            toggleButton.Position = UDim2.new(1, -60, 0.5, -10)
            toggleButton.Text = defaultValue and "ON" or "OFF"
            toggleButton.TextColor3 = CurrentTheme.TextPrimary
            toggleButton.TextSize = 9
            toggleButton.Font = Enum.Font.SourceSansBold
            toggleButton.AutoButtonColor = false
            
            local toggled = defaultValue
            
            toggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                Utils.Tween(toggleButton, {
                    BackgroundColor3 = toggled and CurrentTheme.Success or CurrentTheme.Error
                }, 0.2)
                
                toggleButton.Text = toggled and "ON" or "OFF"
                callback(toggled)
            end)
            
            -- Update content size
            tabContent.Size = UDim2.new(1, 0, 0, tabContentLayout.AbsoluteContentSize.Y)
            updateContentSize()
            
            return {
                Set = function(value)
                    toggled = value
                    toggleButton.Text = toggled and "ON" or "OFF"
                    Utils.Tween(toggleButton, {
                        BackgroundColor3 = toggled and CurrentTheme.Success or CurrentTheme.Error
                    }, 0.2)
                end
            }
        end
        
        function tabData:CreateSlider(sliderOptions)
            sliderOptions = sliderOptions or {}
            local sliderText = sliderOptions.Text or "Slider"
            local minValue = sliderOptions.Min or 0
            local maxValue = sliderOptions.Max or 100
            local defaultValue = sliderOptions.Default or minValue
            local callback = sliderOptions.Callback or function() end
            
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Name = sliderText .. "Slider"
            sliderFrame.Parent = tabContent
            sliderFrame.BackgroundColor3 = CurrentTheme.ButtonNormal
            sliderFrame.BorderSizePixel = 0  -- NO border
            sliderFrame.Size = UDim2.new(1, -10, 0, 45)
            
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Parent = sliderFrame
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Size = UDim2.new(1, -10, 0, 20)
            sliderLabel.Position = UDim2.new(0, 5, 0, 2)
            sliderLabel.Text = sliderText .. ": " .. defaultValue
            sliderLabel.TextColor3 = CurrentTheme.TextPrimary
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.TextSize = 10
            sliderLabel.Font = Enum.Font.SourceSans
            
            local sliderTrack = Instance.new("Frame")
            sliderTrack.Parent = sliderFrame
            sliderTrack.BackgroundColor3 = CurrentTheme.Sidebar
            sliderTrack.BorderSizePixel = 0  -- NO border
            sliderTrack.Size = UDim2.new(1, -20, 0, 8)
            sliderTrack.Position = UDim2.new(0, 10, 1, -15)
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Parent = sliderTrack
            sliderFill.BackgroundColor3 = CurrentTheme.AccentRed
            sliderFill.BorderSizePixel = 0  -- NO border
            sliderFill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
            
            local sliderButton = Instance.new("TextButton")
            sliderButton.Parent = sliderTrack
            sliderButton.BackgroundColor3 = CurrentTheme.TextPrimary
            sliderButton.BorderSizePixel = 0  -- NO border
            sliderButton.Size = UDim2.new(0, 12, 0, 12)
            sliderButton.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -6, 0.5, -6)
            sliderButton.Text = ""
            sliderButton.AutoButtonColor = false
            
            local currentValue = defaultValue
            local dragging = false
            
            local function updateSlider(input)
                local relativeX = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
                currentValue = math.floor(minValue + (maxValue - minValue) * relativeX)
                
                sliderLabel.Text = sliderText .. ": " .. currentValue
                sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                sliderButton.Position = UDim2.new(relativeX, -6, 0.5, -6)
                
                callback(currentValue)
            end
            
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
                    updateSlider(input)
                end
            end)
            
            sliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    updateSlider(input)
                end
            end)
            
            -- Update content size
            tabContent.Size = UDim2.new(1, 0, 0, tabContentLayout.AbsoluteContentSize.Y)
            updateContentSize()
            
            return {
                Set = function(value)
                    currentValue = math.clamp(value, minValue, maxValue)
                    local relativeX = (currentValue - minValue) / (maxValue - minValue)
                    sliderLabel.Text = sliderText .. ": " .. currentValue
                    sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                    sliderButton.Position = UDim2.new(relativeX, -6, 0.5, -6)
                end
            }
        end
        
        function tabData:CreateLabel(labelOptions)
            labelOptions = labelOptions or {}
            local labelText = labelOptions.Text or "Label"
            
            local label = Instance.new("TextLabel")
            label.Name = labelText .. "Label"
            label.Parent = tabContent
            label.BackgroundColor3 = CurrentTheme.ButtonNormal
            label.BorderSizePixel = 0  -- NO border
            label.Size = UDim2.new(1, -10, 0, 25)
            label.Text = labelText
            label.TextColor3 = CurrentTheme.TextPrimary
            label.TextSize = 11
            label.Font = Enum.Font.SourceSans
            
            -- Update content size
            tabContent.Size = UDim2.new(1, 0, 0, tabContentLayout.AbsoluteContentSize.Y)
            updateContentSize()
            
            return {
                Set = function(text)
                    label.Text = text
                end
            }
        end
        
        function tabData:CreateThemeChanger()
            local themeFrame = Instance.new("Frame")
            themeFrame.Name = "ThemeChanger"
            themeFrame.Parent = tabContent
            themeFrame.BackgroundColor3 = CurrentTheme.ButtonNormal
            themeFrame.BorderSizePixel = 0  -- NO border
            themeFrame.Size = UDim2.new(1, -10, 0, 35)
            
            local themeLabel = Instance.new("TextLabel")
            themeLabel.Parent = themeFrame
            themeLabel.BackgroundTransparency = 1
            themeLabel.Size = UDim2.new(0.4, 0, 1, 0)
            themeLabel.Position = UDim2.new(0, 10, 0, 0)
            themeLabel.Text = "Theme:"
            themeLabel.TextColor3 = CurrentTheme.TextPrimary
            themeLabel.TextXAlignment = Enum.TextXAlignment.Left
            themeLabel.TextSize = 11
            themeLabel.Font = Enum.Font.SourceSans
            
            local redBtn = Instance.new("TextButton")
            redBtn.Parent = themeFrame
            redBtn.BackgroundColor3 = Themes.Red.Border
            redBtn.BorderSizePixel = 0
            redBtn.Size = UDim2.new(0, 30, 0, 20)
            redBtn.Position = UDim2.new(0, 120, 0.5, -10)
            redBtn.Text = "R"
            redBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            redBtn.TextSize = 10
            redBtn.Font = Enum.Font.SourceSansBold
            
            local blueBtn = Instance.new("TextButton")
            blueBtn.Parent = themeFrame
            blueBtn.BackgroundColor3 = Themes.Blue.Border
            blueBtn.BorderSizePixel = 0
            blueBtn.Size = UDim2.new(0, 30, 0, 20)
            blueBtn.Position = UDim2.new(0, 155, 0.5, -10)
            blueBtn.Text = "B"
            blueBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            blueBtn.TextSize = 10
            blueBtn.Font = Enum.Font.SourceSansBold
            
            local greenBtn = Instance.new("TextButton")
            greenBtn.Parent = themeFrame
            greenBtn.BackgroundColor3 = Themes.Green.Border
            greenBtn.BorderSizePixel = 0
            greenBtn.Size = UDim2.new(0, 30, 0, 20)
            greenBtn.Position = UDim2.new(0, 190, 0.5, -10)
            greenBtn.Text = "G"
            greenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            greenBtn.TextSize = 10
            greenBtn.Font = Enum.Font.SourceSansBold
            
            redBtn.MouseButton1Click:Connect(function()
                Utils.ChangeTheme("Red")
            end)
            
            blueBtn.MouseButton1Click:Connect(function()
                Utils.ChangeTheme("Blue")
            end)
            
            greenBtn.MouseButton1Click:Connect(function()
                Utils.ChangeTheme("Green")
            end)
            
            -- Update content size
            tabContent.Size = UDim2.new(1, 0, 0, tabContentLayout.AbsoluteContentSize.Y)
            updateContentSize()
        end
        
        return tabData
    end
    
    -- Notification system
    function windowData:Notify(title, description, notificationType)
        Utils.CreateNotification(title, description, notificationType)
    end
    
    return windowData
end

print("[RED-THEME] Enhanced GUI Library Loaded Successfully!")
print("[RED-THEME] Features: Keybinds, Notifications, Themes, Smooth Dragging")

-- Make library global
getgenv().RedThemeLib = RedThemeLib

return RedThemeLib
