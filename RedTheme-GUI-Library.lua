--[[
    RED THEME GUI LIBRARY
    Professional interface with red border theme
]]

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Wait for player to load
repeat task.wait() until LocalPlayer and LocalPlayer.PlayerGui

-- Cleanup any existing instances
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

print("[RED-THEME] Loading GUI Library...")

-- ═══════════════════════════════════════════════════════════════════════════════════════════
-- LIBRARY CONFIGURATION
-- ═══════════════════════════════════════════════════════════════════════════════════════════

local RedThemeLib = {}

-- Configuration
local Config = {
    AnimationSpeed = 0.25,
    BlurIntensity = 15,
    EnableAnimations = true,
    EnableBlur = true,
    EnableSounds = true,
    Theme = "RedDark"
}

-- Red Theme Colors
local Theme = {
    -- Main Colors
    Background = Color3.fromRGB(67, 67, 67),      -- Main background
    Sidebar = Color3.fromRGB(25, 9, 9),           -- Dark red sidebar
    Border = Color3.fromRGB(255, 0, 0),           -- Red border
    
    -- Text Colors
    TextPrimary = Color3.fromRGB(255, 255, 255),   -- White text
    TextSecondary = Color3.fromRGB(200, 200, 200), -- Light gray text
    TextMuted = Color3.fromRGB(150, 150, 150),     -- Muted text
    
    -- Accent Colors
    AccentRed = Color3.fromRGB(255, 50, 50),       -- Bright red
    AccentDarkRed = Color3.fromRGB(150, 30, 30),   -- Dark red
    Success = Color3.fromRGB(46, 125, 50),         -- Green
    Warning = Color3.fromRGB(255, 152, 0),         -- Orange
    Error = Color3.fromRGB(244, 67, 54),           -- Red error
    
    -- Interactive Colors
    ButtonNormal = Color3.fromRGB(45, 45, 45),
    ButtonHover = Color3.fromRGB(60, 60, 60),
    ButtonActive = Color3.fromRGB(255, 50, 50),
    
    -- Transparency
    BackgroundTransparency = 0,
    SidebarTransparency = 0,
}

-- Assets (Icons)
local Assets = {
    ["add"] = "rbxassetid://14368300605",
    ["alert"] = "rbxassetid://14368301329",
    ["home"] = "rbxassetid://14368292698",
    ["settings"] = "rbxassetid://14368293672",
    ["close"] = "rbxassetid://14368294239",
    ["minimize"] = "rbxassetid://14368295058",
}

-- ═══════════════════════════════════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════════════════

local Utils = {}

-- Create smooth tween animation
function Utils.Tween(object, properties, duration, easingStyle, easingDirection)
    if not Config.EnableAnimations then
        for property, value in pairs(properties) do
            object[property] = value
        end
        return
    end
    
    local info = TweenInfo.new(
        duration or Config.AnimationSpeed,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(object, info, properties)
    tween:Play()
    return tween
end

-- Create ripple effect
function Utils.CreateRipple(frame, position)
    if not Config.EnableAnimations then return end
    
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.BackgroundColor3 = Theme.AccentRed
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Position = UDim2.new(0, position.X - frame.AbsolutePosition.X, 0, position.Y - frame.AbsolutePosition.Y)
    ripple.Parent = frame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple
    
    local maxSize = math.max(frame.AbsoluteSize.X, frame.AbsoluteSize.Y) * 2
    
    Utils.Tween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }, 0.6)
    
    game:GetService("Debris"):AddItem(ripple, 0.6)
end

-- Make frame draggable
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
            
            Utils.CreateRipple(dragArea, input.Position)
        end
    end)
    
    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    dragArea.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Create professional notification
function Utils.Notify(title, message, notificationType, duration)
    notificationType = notificationType or "info"
    duration = duration or 3
    
    local notificationColors = {
        success = Theme.Success,
        warning = Theme.Warning,
        error = Theme.Error,
        info = Theme.AccentRed
    }
    
    local color = notificationColors[notificationType] or Theme.AccentRed
    
    -- Create notification (simple implementation for now)
    print("[" .. string.upper(notificationType) .. "] " .. title .. ": " .. message)
    
    return true
end

-- ═══════════════════════════════════════════════════════════════════════════════════════════
-- MAIN GUI CREATION
-- ═══════════════════════════════════════════════════════════════════════════════════════════

function RedThemeLib:CreateWindow(options)
    options = options or {}
    local title = options.Title or "Red Theme GUI"
    local size = options.Size or UDim2.new(0, 445, 0, 387)
    local position = options.Position or UDim2.new(0.5, -222, 0.5, -193)
    
    local windowData = {
        tabs = {},
        currentTab = nil,
        elements = {}
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
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "Main"
    mainFrame.Parent = screenGui
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BorderColor3 = Theme.Border
    mainFrame.BorderSizePixel = 1
    mainFrame.Size = size
    mainFrame.Position = position
    mainFrame.ClipsDescendants = true
    
    -- Main frame corner
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 6)
    mainCorner.Parent = mainFrame
    
    -- Sidebar Frame
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Parent = mainFrame
    sidebar.BackgroundColor3 = Theme.Sidebar
    sidebar.BorderSizePixel = 0
    sidebar.Size = UDim2.new(0, 115, 1, 0)
    sidebar.Position = UDim2.new(0, 0, 0, 0)
    
    -- Sidebar corner
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 6)
    sidebarCorner.Parent = sidebar
    
    -- Title Frame (in sidebar)
    local titleFrame = Instance.new("Frame")
    titleFrame.Name = "TitleFrame"
    titleFrame.Parent = sidebar
    titleFrame.BackgroundColor3 = Theme.Sidebar
    titleFrame.BorderColor3 = Theme.Border
    titleFrame.BorderSizePixel = 1
    titleFrame.Size = UDim2.new(1, 0, 0, 40)
    titleFrame.Position = UDim2.new(0, 0, 0, 0)
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 6)
    titleCorner.Parent = titleFrame
    
    -- Title Label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Parent = titleFrame
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -10, 1, 0)
    titleLabel.Position = UDim2.new(0, 5, 0, 0)
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.TextPrimary
    titleLabel.TextScaled = false
    titleLabel.TextSize = 12
    titleLabel.Font = Enum.Font.JosefinSans
    titleLabel.FontFace = Font.new("rbxasset://fonts/families/JosefinSans.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    
    -- Username Label (at bottom of sidebar)
    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Name = "Username"
    usernameLabel.Parent = sidebar
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Size = UDim2.new(1, -10, 0, 25)
    usernameLabel.Position = UDim2.new(0, 5, 1, -30)
    usernameLabel.Text = LocalPlayer.Name
    usernameLabel.TextColor3 = Theme.TextSecondary
    usernameLabel.TextScaled = false
    usernameLabel.TextSize = 10
    usernameLabel.Font = Enum.Font.JosefinSans
    usernameLabel.FontFace = Font.new("rbxasset://fonts/families/JosefinSans.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    
    -- Tab Container (in sidebar)
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
    
    -- Content Frame (Scrolling Overlay)
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Parent = mainFrame
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.Size = UDim2.new(0, 330, 1, 0)
    contentFrame.Position = UDim2.new(0, 115, 0, 0)
    contentFrame.ScrollBarImageColor3 = Theme.AccentRed
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
    
    -- Update content size automatically
    local function updateContentSize()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateContentSize)
    
    -- Make window draggable
    Utils.MakeDraggable(mainFrame, titleFrame)
    
    -- Close functionality (X button)
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Parent = titleFrame
    closeButton.BackgroundColor3 = Theme.Error
    closeButton.BorderSizePixel = 0
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -25, 0, 5)
    closeButton.Text = "×"
    closeButton.TextColor3 = Theme.TextPrimary
    closeButton.TextScaled = false
    closeButton.TextSize = 14
    closeButton.Font = Enum.Font.GothamBold
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        Utils.Tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        Utils.Tween(blurEffect, {Size = 0}, 0.3)
        task.wait(0.3)
        screenGui:Destroy()
    end)
    
    closeButton.MouseEnter:Connect(function()
        Utils.Tween(closeButton, {BackgroundColor3 = Theme.AccentRed}, 0.2)
    end)
    
    closeButton.MouseLeave:Connect(function()
        Utils.Tween(closeButton, {BackgroundColor3 = Theme.Error}, 0.2)
    end)
    
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
            elements = {},
            visible = false
        }
        
        -- Tab Button (in sidebar)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName .. "Tab"
        tabButton.Parent = tabContainer
        tabButton.BackgroundColor3 = Theme.Sidebar
        tabButton.BorderColor3 = Theme.Border
        tabButton.BorderSizePixel = 1
        tabButton.Size = UDim2.new(1, 0, 0, 35)
        tabButton.Text = ""
        tabButton.AutoButtonColor = false
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 4)
        tabCorner.Parent = tabButton
        
        -- Tab Icon
        local tabIconImage = Instance.new("ImageLabel")
        tabIconImage.Name = "Icon"
        tabIconImage.Parent = tabButton
        tabIconImage.BackgroundTransparency = 1
        tabIconImage.Size = UDim2.new(0, 16, 0, 16)
        tabIconImage.Position = UDim2.new(0, 8, 0.5, -8)
        tabIconImage.Image = tabIcon
        tabIconImage.ImageColor3 = Theme.TextSecondary
        
        -- Tab Label
        local tabLabel = Instance.new("TextLabel")
        tabLabel.Name = "Label"
        tabLabel.Parent = tabButton
        tabLabel.BackgroundTransparency = 1
        tabLabel.Size = UDim2.new(1, -35, 1, 0)
        tabLabel.Position = UDim2.new(0, 30, 0, 0)
        tabLabel.Text = tabName
        tabLabel.TextColor3 = Theme.TextSecondary
        tabLabel.TextXAlignment = Enum.TextXAlignment.Left
        tabLabel.TextScaled = false
        tabLabel.TextSize = 11
        tabLabel.Font = Enum.Font.Arial
        tabLabel.FontFace = Font.new("rbxasset://fonts/families/Arial.json", Enum.FontWeight.Regular, Enum.FontStyle.Italic)
        
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
                tab.button.BackgroundColor3 = Theme.Sidebar
                tab.iconImage.ImageColor3 = Theme.TextSecondary
                tab.label.TextColor3 = Theme.TextSecondary
                tab.content.Visible = false
                tab.visible = false
            end
            
            -- Show this tab
            tabButton.BackgroundColor3 = Theme.AccentDarkRed
            tabIconImage.ImageColor3 = Theme.TextPrimary
            tabLabel.TextColor3 = Theme.TextPrimary
            tabContent.Visible = true
            tabData.visible = true
            
            windowData.currentTab = tabData
            Utils.CreateRipple(tabButton, {X = tabButton.AbsoluteSize.X/2, Y = tabButton.AbsoluteSize.Y/2})
        end)
        
        tabButton.MouseEnter:Connect(function()
            if not tabData.visible then
                Utils.Tween(tabButton, {BackgroundColor3 = Theme.ButtonHover}, 0.2)
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if not tabData.visible then
                Utils.Tween(tabButton, {BackgroundColor3 = Theme.Sidebar}, 0.2)
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
            -- Show this tab
            tabButton.BackgroundColor3 = Theme.AccentDarkRed
            tabIconImage.ImageColor3 = Theme.TextPrimary
            tabLabel.TextColor3 = Theme.TextPrimary
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
            button.BackgroundColor3 = Theme.ButtonNormal
            button.BorderColor3 = Theme.Border
            button.BorderSizePixel = 1
            button.Size = UDim2.new(1, -10, 0, 35)
            button.Text = buttonText
            button.TextColor3 = Theme.TextPrimary
            button.TextScaled = false
            button.TextSize = 12
            button.Font = Enum.Font.GothamBold
            button.AutoButtonColor = false
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 4)
            buttonCorner.Parent = button
            
            button.MouseButton1Click:Connect(function()
                Utils.CreateRipple(button, {X = button.AbsoluteSize.X/2, Y = button.AbsoluteSize.Y/2})
                callback()
            end)
            
            button.MouseEnter:Connect(function()
                Utils.Tween(button, {BackgroundColor3 = Theme.ButtonHover}, 0.2)
            end)
            
            button.MouseLeave:Connect(function()
                Utils.Tween(button, {BackgroundColor3 = Theme.ButtonNormal}, 0.2)
            end)
            
            -- Update content size
            tabContent.Size = UDim2.new(1, 0, 0, tabContentLayout.AbsoluteContentSize.Y)
            updateContentSize()
            
            return button
        end
        
        function tabData:CreateToggle(toggleOptions)
            toggleOptions = toggleOptions or {}
            local toggleText = toggleOptions.Text or "Toggle"
            local defaultValue = toggleOptions.Default or false
            local callback = toggleOptions.Callback or function() end
            
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = toggleText .. "Toggle"
            toggleFrame.Parent = tabContent
            toggleFrame.BackgroundColor3 = Theme.ButtonNormal
            toggleFrame.BorderColor3 = Theme.Border
            toggleFrame.BorderSizePixel = 1
            toggleFrame.Size = UDim2.new(1, -10, 0, 35)
            
            local toggleCorner = Instance.new("UICorner")
            toggleCorner.CornerRadius = UDim.new(0, 4)
            toggleCorner.Parent = toggleFrame
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Parent = toggleFrame
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            toggleLabel.Position = UDim2.new(0, 10, 0, 0)
            toggleLabel.Text = toggleText
            toggleLabel.TextColor3 = Theme.TextPrimary
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.TextScaled = false
            toggleLabel.TextSize = 11
            toggleLabel.Font = Enum.Font.Gotham
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Parent = toggleFrame
            toggleButton.BackgroundColor3 = defaultValue and Theme.Success or Theme.Error
            toggleButton.BorderSizePixel = 0
            toggleButton.Size = UDim2.new(0, 50, 0, 20)
            toggleButton.Position = UDim2.new(1, -60, 0.5, -10)
            toggleButton.Text = defaultValue and "ON" or "OFF"
            toggleButton.TextColor3 = Theme.TextPrimary
            toggleButton.TextScaled = false
            toggleButton.TextSize = 9
            toggleButton.Font = Enum.Font.GothamBold
            toggleButton.AutoButtonColor = false
            
            local toggleButtonCorner = Instance.new("UICorner")
            toggleButtonCorner.CornerRadius = UDim.new(0, 4)
            toggleButtonCorner.Parent = toggleButton
            
            local toggled = defaultValue
            
            toggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                Utils.Tween(toggleButton, {
                    BackgroundColor3 = toggled and Theme.Success or Theme.Error
                }, 0.2)
                
                toggleButton.Text = toggled and "ON" or "OFF"
                Utils.CreateRipple(toggleButton, {X = toggleButton.AbsoluteSize.X/2, Y = toggleButton.AbsoluteSize.Y/2})
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
                        BackgroundColor3 = toggled and Theme.Success or Theme.Error
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
            sliderFrame.BackgroundColor3 = Theme.ButtonNormal
            sliderFrame.BorderColor3 = Theme.Border
            sliderFrame.BorderSizePixel = 1
            sliderFrame.Size = UDim2.new(1, -10, 0, 45)
            
            local sliderCorner = Instance.new("UICorner")
            sliderCorner.CornerRadius = UDim.new(0, 4)
            sliderCorner.Parent = sliderFrame
            
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Parent = sliderFrame
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Size = UDim2.new(1, -10, 0, 20)
            sliderLabel.Position = UDim2.new(0, 5, 0, 2)
            sliderLabel.Text = sliderText .. ": " .. defaultValue
            sliderLabel.TextColor3 = Theme.TextPrimary
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.TextScaled = false
            sliderLabel.TextSize = 10
            sliderLabel.Font = Enum.Font.Gotham
            
            local sliderTrack = Instance.new("Frame")
            sliderTrack.Parent = sliderFrame
            sliderTrack.BackgroundColor3 = Theme.Sidebar
            sliderTrack.BorderColor3 = Theme.Border
            sliderTrack.BorderSizePixel = 1
            sliderTrack.Size = UDim2.new(1, -20, 0, 8)
            sliderTrack.Position = UDim2.new(0, 10, 1, -15)
            
            local trackCorner = Instance.new("UICorner")
            trackCorner.CornerRadius = UDim.new(0, 4)
            trackCorner.Parent = sliderTrack
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Parent = sliderTrack
            sliderFill.BackgroundColor3 = Theme.AccentRed
            sliderFill.BorderSizePixel = 0
            sliderFill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(0, 4)
            fillCorner.Parent = sliderFill
            
            local sliderButton = Instance.new("TextButton")
            sliderButton.Parent = sliderTrack
            sliderButton.BackgroundColor3 = Theme.TextPrimary
            sliderButton.BorderSizePixel = 0
            sliderButton.Size = UDim2.new(0, 12, 0, 12)
            sliderButton.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -6, 0.5, -6)
            sliderButton.Text = ""
            sliderButton.AutoButtonColor = false
            
            local sliderButtonCorner = Instance.new("UICorner")
            sliderButtonCorner.CornerRadius = UDim.new(1, 0)
            sliderButtonCorner.Parent = sliderButton
            
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
            label.BackgroundColor3 = Theme.ButtonNormal
            label.BorderColor3 = Theme.Border
            label.BorderSizePixel = 1
            label.Size = UDim2.new(1, -10, 0, 25)
            label.Text = labelText
            label.TextColor3 = Theme.TextPrimary
            label.TextScaled = false
            label.TextSize = 11
            label.Font = Enum.Font.Gotham
            
            local labelCorner = Instance.new("UICorner")
            labelCorner.CornerRadius = UDim.new(0, 4)
            labelCorner.Parent = label
            
            -- Update content size
            tabContent.Size = UDim2.new(1, 0, 0, tabContentLayout.AbsoluteContentSize.Y)
            updateContentSize()
            
            return {
                Set = function(text)
                    label.Text = text
                end
            }
        end
        
        return tabData
    end
    
    -- Notification system
    function windowData:Notify(title, message, notificationType, duration)
        return Utils.Notify(title, message, notificationType, duration)
    end
    
    -- Show startup notification
    Utils.Notify("Red Theme GUI", "Professional GUI Library Loaded Successfully", "success", 3)
    
    return windowData
end

-- ═══════════════════════════════════════════════════════════════════════════════════════════
-- EXPORT LIBRARY
-- ═══════════════════════════════════════════════════════════════════════════════════════════

print("[RED-THEME] GUI Library Loaded Successfully!")
print("[RED-THEME] Ready for use")

-- Make library global
getgenv().RedThemeLib = RedThemeLib

return RedThemeLib
