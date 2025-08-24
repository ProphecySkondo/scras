--[=[
    db   db db    db d8888b. d8888b.  .d88b.  db    db d888888b d8888b. d88888b      d8888b. d88888b d8888b.      d888888b db   db d88888b .88b  d88. d88888b 
    88   88 `8b  d8' 88  `8D 88  `8D .8P  Y8. `8b  d8'   `88'   88  `8D 88'          88  `8D 88'     88  `8D        `88'   88   88 88'     88'YbdP`88 88'     
    88ooo88  `8bd8'  88   88 88oobY' 88    88  `8bd8'     88    88   88 88ooooo      88oobY' 88ooooo 88   88         88    88ooo88 88ooooo 88  88  88 88ooooo 
    88~~~88    88    88   88 88`8b   88    88  d8`8b      88    88   88 88~~~~~      88`8b   88~~~~~ 88   88         88    88~~~88 88~~~~~ 88  88  88 88~~~~~ 
    88   88    88    88  .8D 88 `88. `8b  d8' d8' `8b    .88.   88  .8D 88.          88 `88. 88.     88  .8D        .88.   88   88 88.     88  88  88 88.     
    YP   YP    YP    Y8888D' 88   YD  `Y88P'  Y8   Y8    Y888P  Y8888D' Y88888P      88   YD Y88888P Y8888D'        Y888P  YP   YP Y88888P YP  YP  YP Y88888P 
                                                                                                                                                @uniquadev
]=]

-- Instances: 25 | Scripts: 8 | Modules: 3 | Tags: 0
local G2L = {}
local Library = {}

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- StarterGui.HydroxideRedThemeGUI
G2L["1"] = Instance.new("ScreenGui", PlayerGui)
G2L["1"]["Name"] = "HydroxideRedThemeGUI"
G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling
G2L["1"]["ResetOnSpawn"] = false

-- StarterGui.HydroxideRedThemeGUI.Main
G2L["2"] = Instance.new("Frame", G2L["1"])
G2L["2"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30)
G2L["2"]["Size"] = UDim2.new(0, 600, 0, 400)
G2L["2"]["Position"] = UDim2.new(0.5, -300, 0.5, -200)
G2L["2"]["BorderColor3"] = Color3.fromRGB(255, 0, 0)
G2L["2"]["BorderSizePixel"] = 1
G2L["2"]["Name"] = "Main"

-- StarterGui.HydroxideRedThemeGUI.Main.TopBar
G2L["3"] = Instance.new("Frame", G2L["2"])
G2L["3"]["BackgroundColor3"] = Color3.fromRGB(45, 25, 25)
G2L["3"]["Size"] = UDim2.new(1, 0, 0, 30)
G2L["3"]["Position"] = UDim2.new(0, 0, 0, 0)
G2L["3"]["BorderSizePixel"] = 0
G2L["3"]["Name"] = "TopBar"

-- StarterGui.HydroxideRedThemeGUI.Main.TopBar.Title
G2L["4"] = Instance.new("TextLabel", G2L["3"])
G2L["4"]["TextWrapped"] = true
G2L["4"]["BorderSizePixel"] = 0
G2L["4"]["TextSize"] = 14
G2L["4"]["TextScaled"] = false
G2L["4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
G2L["4"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
G2L["4"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
G2L["4"]["BackgroundTransparency"] = 1
G2L["4"]["Size"] = UDim2.new(1, -60, 1, 0)
G2L["4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
G2L["4"]["Text"] = "Hydroxide Red Theme"
G2L["4"]["Name"] = "Title"
G2L["4"]["Position"] = UDim2.new(0, 10, 0, 0)
G2L["4"]["TextXAlignment"] = Enum.TextXAlignment.Left

-- StarterGui.HydroxideRedThemeGUI.Main.TopBar.CloseButton
G2L["5"] = Instance.new("TextButton", G2L["3"])
G2L["5"]["TextWrapped"] = true
G2L["5"]["BorderSizePixel"] = 0
G2L["5"]["TextSize"] = 14
G2L["5"]["TextScaled"] = false
G2L["5"]["BackgroundColor3"] = Color3.fromRGB(255, 50, 50)
G2L["5"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
G2L["5"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
G2L["5"]["Size"] = UDim2.new(0, 50, 1, 0)
G2L["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
G2L["5"]["Text"] = "×"
G2L["5"]["Name"] = "CloseButton"
G2L["5"]["Position"] = UDim2.new(1, -50, 0, 0)

-- StarterGui.HydroxideRedThemeGUI.Main.Sidebar
G2L["6"] = Instance.new("Frame", G2L["2"])
G2L["6"]["BackgroundColor3"] = Color3.fromRGB(45, 25, 25)
G2L["6"]["Size"] = UDim2.new(0, 150, 1, -30)
G2L["6"]["Position"] = UDim2.new(0, 0, 0, 30)
G2L["6"]["BorderSizePixel"] = 0
G2L["6"]["Name"] = "Sidebar"

-- StarterGui.HydroxideRedThemeGUI.Main.Content
G2L["7"] = Instance.new("ScrollingFrame", G2L["2"])
G2L["7"]["BackgroundColor3"] = Color3.fromRGB(30, 30, 30)
G2L["7"]["Size"] = UDim2.new(1, -150, 1, -30)
G2L["7"]["Position"] = UDim2.new(0, 150, 0, 30)
G2L["7"]["BorderSizePixel"] = 0
G2L["7"]["Name"] = "Content"
G2L["7"]["ScrollBarThickness"] = 6
G2L["7"]["ScrollBarImageColor3"] = Color3.fromRGB(255, 50, 50)
G2L["7"]["CanvasSize"] = UDim2.new(0, 0, 0, 0)

-- StarterGui.HydroxideRedThemeGUI.Main.Content.UIListLayout
G2L["8"] = Instance.new("UIListLayout", G2L["7"])
G2L["8"]["Padding"] = UDim.new(0, 5)
G2L["8"]["SortOrder"] = Enum.SortOrder.LayoutOrder

-- StarterGui.HydroxideRedThemeGUI.Main.Content.UIPadding
G2L["9"] = Instance.new("UIPadding", G2L["7"])
G2L["9"]["PaddingTop"] = UDim.new(0, 10)
G2L["9"]["PaddingLeft"] = UDim.new(0, 10)
G2L["9"]["PaddingRight"] = UDim.new(0, 10)
G2L["9"]["PaddingBottom"] = UDim.new(0, 10)

-- StarterGui.HydroxideRedThemeGUI.Notifications
G2L["10"] = Instance.new("Frame", G2L["1"])
G2L["10"]["BackgroundTransparency"] = 1
G2L["10"]["Size"] = UDim2.new(0, 300, 1, 0)
G2L["10"]["Position"] = UDim2.new(1, -320, 0, 20)
G2L["10"]["BorderSizePixel"] = 0
G2L["10"]["Name"] = "Notifications"

-- StarterGui.HydroxideRedThemeGUI.Notifications.UIListLayout
G2L["11"] = Instance.new("UIListLayout", G2L["10"])
G2L["11"]["Padding"] = UDim.new(0, 10)
G2L["11"]["SortOrder"] = Enum.SortOrder.LayoutOrder
G2L["11"]["VerticalAlignment"] = Enum.VerticalAlignment.Bottom

-- StarterGui.HydroxideRedThemeGUI.Assets
G2L["12"] = Instance.new("ModuleScript", G2L["1"])
G2L["12"]["Name"] = "Assets"

-- StarterGui.HydroxideRedThemeGUI.ThemeModule
G2L["13"] = Instance.new("ModuleScript", G2L["1"])
G2L["13"]["Name"] = "ThemeModule"

-- StarterGui.HydroxideRedThemeGUI.DragScript
G2L["14"] = Instance.new("LocalScript", G2L["1"])
G2L["14"]["Name"] = "DragScript"

-- StarterGui.HydroxideRedThemeGUI.ToggleScript
G2L["15"] = Instance.new("LocalScript", G2L["1"])
G2L["15"]["Name"] = "ToggleScript"

-- StarterGui.HydroxideRedThemeGUI.NotificationScript
G2L["16"] = Instance.new("LocalScript", G2L["1"])
G2L["16"]["Name"] = "NotificationScript"

-- Theme Configuration
local Theme = {
    Background = Color3.fromRGB(30, 30, 30),
    Sidebar = Color3.fromRGB(45, 25, 25),
    Primary = Color3.fromRGB(255, 50, 50),
    Secondary = Color3.fromRGB(200, 40, 40),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(200, 200, 200),
    Border = Color3.fromRGB(255, 0, 0),
    Success = Color3.fromRGB(0, 255, 0),
    Warning = Color3.fromRGB(255, 165, 0),
    Error = Color3.fromRGB(255, 0, 0),
    Info = Color3.fromRGB(100, 150, 255)
}

-- Require G2L wrapper
local G2L_REQUIRE = require
local G2L_MODULES = {}
local function require(Module)
    local ModuleState = G2L_MODULES[Module]
    if ModuleState then
        if not ModuleState.Required then
            ModuleState.Required = true
            ModuleState.Value = ModuleState.Closure()
        end
        return ModuleState.Value
    end
    return G2L_REQUIRE(Module)
end

-- Assets Module
G2L_MODULES[G2L["12"]] = {
    Closure = function()
        local script = G2L["12"]
        local module = {}
        local assets = {
            ["success"] = "rbxassetid://14368695894",
            ["warning"] = "rbxassetid://14368696199", 
            ["error"] = "rbxassetid://14368696505",
            ["info"] = "rbxassetid://14368696774"
        }
        return assets
    end
}

-- Theme Module
G2L_MODULES[G2L["13"]] = {
    Closure = function()
        local script = G2L["13"]
        return Theme
    end
}

-- Main Library Functions
Library.CurrentWindow = nil
Library.Tabs = {}
Library.CurrentTab = nil

function Library:CreateWindow(config)
    local Window = {}
    Window.Title = config.Title or "Hydroxide Red Theme"
    Window.Tabs = {}
    Window.CurrentTab = nil
    
    -- Set window title
    G2L["4"]["Text"] = Window.Title
    
    Library.CurrentWindow = Window
    
    -- Notification system
    function Window:Notify(title, description, type)
        type = type or "info"
        
        local notification = Instance.new("Frame")
        notification.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        notification.BorderColor3 = Theme[type:gsub("^%l", string.upper)] or Theme.Info
        notification.BorderSizePixel = 1
        notification.Size = UDim2.new(1, 0, 0, 80)
        notification.Parent = G2L["10"]
        notification.BackgroundTransparency = 0.1
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.BackgroundTransparency = 1
        titleLabel.Size = UDim2.new(1, -10, 0, 20)
        titleLabel.Position = UDim2.new(0, 5, 0, 5)
        titleLabel.Text = title
        titleLabel.TextColor3 = Theme.Text
        titleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        titleLabel.TextSize = 14
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Parent = notification
        
        local descLabel = Instance.new("TextLabel")
        descLabel.BackgroundTransparency = 1
        descLabel.Size = UDim2.new(1, -10, 0, 50)
        descLabel.Position = UDim2.new(0, 5, 0, 25)
        descLabel.Text = description
        descLabel.TextColor3 = Theme.TextDark
        descLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        descLabel.TextSize = 12
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.TextYAlignment = Enum.TextYAlignment.Top
        descLabel.TextWrapped = true
        descLabel.Parent = notification
        
        -- Animate in
        notification.Position = UDim2.new(1, 50, 0, 0)
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local tween = TweenService:Create(notification, tweenInfo, {Position = UDim2.new(0, 0, 0, 0)})
        tween:Play()
        
        -- Auto remove after 4 seconds
        task.spawn(function()
            task.wait(4)
            local fadeInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local fadeTween = TweenService:Create(notification, fadeInfo, {
                Position = UDim2.new(1, 50, 0, 0),
                BackgroundTransparency = 1
            })
            TweenService:Create(titleLabel, fadeInfo, {TextTransparency = 1}):Play()
            TweenService:Create(descLabel, fadeInfo, {TextTransparency = 1}):Play()
            fadeTween:Play()
            fadeTween.Completed:Connect(function()
                notification:Destroy()
            end)
        end)
    end
    
    function Window:CreateTab(config)
        local Tab = {}
        Tab.Name = config.Name or "Tab"
        Tab.Elements = {}
        
        -- Create tab button
        local tabButton = Instance.new("TextButton")
        tabButton.BackgroundColor3 = Theme.Sidebar
        tabButton.BorderSizePixel = 0
        tabButton.Size = UDim2.new(1, 0, 0, 40)
        tabButton.Text = Tab.Name
        tabButton.TextColor3 = Theme.Text
        tabButton.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        tabButton.TextSize = 14
        tabButton.Parent = G2L["6"]
        
        -- Tab content frame
        local tabContent = Instance.new("Frame")
        tabContent.BackgroundTransparency = 1
        tabContent.Size = UDim2.new(1, 0, 0, 0)
        tabContent.Visible = false
        tabContent.Parent = G2L["7"]
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 5)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = tabContent
        
        -- Tab selection logic
        tabButton.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Content.Visible = false
                Window.CurrentTab.Button.BackgroundColor3 = Theme.Sidebar
            end
            
            tabContent.Visible = true
            tabButton.BackgroundColor3 = Theme.Primary
            Window.CurrentTab = {Content = tabContent, Button = tabButton}
        end)
        
        -- Auto-select first tab
        if #Window.Tabs == 0 then
            tabContent.Visible = true
            tabButton.BackgroundColor3 = Theme.Primary
            Window.CurrentTab = {Content = tabContent, Button = tabButton}
        end
        
        Tab.Content = tabContent
        Tab.Button = tabButton
        table.insert(Window.Tabs, Tab)
        
        -- Tab element creation functions
        function Tab:CreateLabel(text)
            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 0, 25)
            label.Text = text
            label.TextColor3 = Theme.Text
            label.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = tabContent
            
            contentLayout:ApplyLayout()
            tabContent.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y)
            G2L["7"].CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
            
            return label
        end
        
        function Tab:CreateButton(config)
            local button = Instance.new("TextButton")
            button.BackgroundColor3 = Theme.Primary
            button.BorderSizePixel = 0
            button.Size = UDim2.new(1, 0, 0, 35)
            button.Text = config.Text or "Button"
            button.TextColor3 = Theme.Text
            button.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
            button.TextSize = 14
            button.Parent = tabContent
            
            -- Hover effects
            button.MouseEnter:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Secondary}):Play()
            end)
            
            button.MouseLeave:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Primary}):Play()
            end)
            
            button.MouseButton1Click:Connect(function()
                if config.Callback then
                    config.Callback()
                end
            end)
            
            contentLayout:ApplyLayout()
            tabContent.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y)
            G2L["7"].CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
            
            return button
        end
        
        function Tab:CreateToggle(config)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Size = UDim2.new(1, 0, 0, 35)
            toggleFrame.Parent = tabContent
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Size = UDim2.new(1, -50, 1, 0)
            toggleLabel.Position = UDim2.new(0, 10, 0, 0)
            toggleLabel.Text = config.Text or "Toggle"
            toggleLabel.TextColor3 = Theme.Text
            toggleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
            toggleLabel.TextSize = 14
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.BackgroundColor3 = config.Default and Theme.Primary or Color3.fromRGB(100, 100, 100)
            toggleButton.BorderSizePixel = 0
            toggleButton.Size = UDim2.new(0, 30, 0, 20)
            toggleButton.Position = UDim2.new(1, -40, 0.5, -10)
            toggleButton.Text = ""
            toggleButton.Parent = toggleFrame
            
            local toggleState = config.Default or false
            
            toggleButton.MouseButton1Click:Connect(function()
                toggleState = not toggleState
                local newColor = toggleState and Theme.Primary or Color3.fromRGB(100, 100, 100)
                TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = newColor}):Play()
                
                if config.Callback then
                    config.Callback(toggleState)
                end
            end)
            
            contentLayout:ApplyLayout()
            tabContent.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y)
            G2L["7"].CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
            
            return {Frame = toggleFrame, Button = toggleButton, State = toggleState}
        end
        
        function Tab:CreateSlider(config)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Size = UDim2.new(1, 0, 0, 50)
            sliderFrame.Parent = tabContent
            
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Size = UDim2.new(1, 0, 0, 20)
            sliderLabel.Position = UDim2.new(0, 10, 0, 5)
            sliderLabel.Text = (config.Text or "Slider") .. ": " .. (config.Default or config.Min or 0)
            sliderLabel.TextColor3 = Theme.Text
            sliderLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
            sliderLabel.TextSize = 14
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Parent = sliderFrame
            
            local sliderTrack = Instance.new("Frame")
            sliderTrack.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            sliderTrack.BorderSizePixel = 0
            sliderTrack.Size = UDim2.new(1, -20, 0, 6)
            sliderTrack.Position = UDim2.new(0, 10, 0, 30)
            sliderTrack.Parent = sliderFrame
            
            local sliderFill = Instance.new("Frame")
            sliderFill.BackgroundColor3 = Theme.Primary
            sliderFill.BorderSizePixel = 0
            sliderFill.Size = UDim2.new(0, 0, 1, 0)
            sliderFill.Parent = sliderTrack
            
            local sliderKnob = Instance.new("TextButton")
            sliderKnob.BackgroundColor3 = Theme.Text
            sliderKnob.BorderSizePixel = 0
            sliderKnob.Size = UDim2.new(0, 12, 0, 12)
            sliderKnob.Position = UDim2.new(0, -6, 0.5, -6)
            sliderKnob.Text = ""
            sliderKnob.Parent = sliderTrack
            
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or min
            local currentValue = default
            
            local function updateSlider(value)
                currentValue = math.clamp(value, min, max)
                local percentage = (currentValue - min) / (max - min)
                sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                sliderKnob.Position = UDim2.new(percentage, -6, 0.5, -6)
                sliderLabel.Text = (config.Text or "Slider") .. ": " .. math.floor(currentValue)
                
                if config.Callback then
                    config.Callback(math.floor(currentValue))
                end
            end
            
            updateSlider(currentValue)
            
            local dragging = false
            sliderKnob.MouseButton1Down:Connect(function()
                dragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = UserInputService:GetMouseLocation()
                    local relativePos = mousePos.X - sliderTrack.AbsolutePosition.X
                    local percentage = math.clamp(relativePos / sliderTrack.AbsoluteSize.X, 0, 1)
                    local value = min + (percentage * (max - min))
                    updateSlider(value)
                end
            end)
            
            contentLayout:ApplyLayout()
            tabContent.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y)
            G2L["7"].CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
            
            return {Frame = sliderFrame, Value = currentValue, UpdateValue = updateSlider}
        end
        
        function Tab:CreateKeybind(config)
            local keybindFrame = Instance.new("Frame")
            keybindFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            keybindFrame.BorderSizePixel = 0
            keybindFrame.Size = UDim2.new(1, 0, 0, 35)
            keybindFrame.Parent = tabContent
            
            local keybindLabel = Instance.new("TextLabel")
            keybindLabel.BackgroundTransparency = 1
            keybindLabel.Size = UDim2.new(1, -80, 1, 0)
            keybindLabel.Position = UDim2.new(0, 10, 0, 0)
            keybindLabel.Text = config.Text or "Keybind"
            keybindLabel.TextColor3 = Theme.Text
            keybindLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
            keybindLabel.TextSize = 14
            keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            keybindLabel.Parent = keybindFrame
            
            local keybindButton = Instance.new("TextButton")
            keybindButton.BackgroundColor3 = Theme.Primary
            keybindButton.BorderSizePixel = 0
            keybindButton.Size = UDim2.new(0, 60, 0, 25)
            keybindButton.Position = UDim2.new(1, -70, 0.5, -12.5)
            keybindButton.Text = config.Default or "None"
            keybindButton.TextColor3 = Theme.Text
            keybindButton.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
            keybindButton.TextSize = 12
            keybindButton.Parent = keybindFrame
            
            local currentKey = config.Default or "None"
            local listening = false
            
            keybindButton.MouseButton1Click:Connect(function()
                if listening then return end
                listening = true
                keybindButton.Text = "..."
                keybindButton.BackgroundColor3 = Theme.Warning
                
                local connection
                connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    
                    local keyName = input.KeyCode.Name
                    if keyName ~= "Unknown" then
                        currentKey = keyName
                        keybindButton.Text = keyName
                        keybindButton.BackgroundColor3 = Theme.Primary
                        listening = false
                        connection:Disconnect()
                        
                        -- Set up the actual keybind
                        UserInputService.InputBegan:Connect(function(newInput, newGameProcessed)
                            if newGameProcessed then return end
                            if newInput.KeyCode.Name == currentKey then
                                if config.Callback then
                                    config.Callback()
                                end
                            end
                        end)
                    end
                end)
            end)
            
            -- Set up initial keybind if default exists
            if config.Default then
                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    if input.KeyCode.Name == currentKey then
                        if config.Callback then
                            config.Callback()
                        end
                    end
                end)
            end
            
            contentLayout:ApplyLayout()
            tabContent.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y)
            G2L["7"].CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
            
            return {Frame = keybindFrame, Button = keybindButton, Key = currentKey}
        end
        
        return Tab
    end
    
    return Window
end

-- StarterGui.HydroxideRedThemeGUI.DragScript
local function C_14()
    local script = G2L["14"]
    local topBar = G2L["3"]
    local mainFrame = G2L["2"]
    
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    topBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            
            local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(mainFrame, tweenInfo, {Position = newPos}):Play()
        end
    end)
    
    topBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- StarterGui.HydroxideRedThemeGUI.ToggleScript
local function C_15()
    local script = G2L["15"]
    local gui = G2L["1"]
    local closeButton = G2L["5"]
    
    -- Close button functionality
    closeButton.MouseButton1Click:Connect(function()
        gui.Enabled = false
    end)
    
    -- Toggle with Insert key
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Insert then
            gui.Enabled = not gui.Enabled
        end
    end)
end

-- StarterGui.HydroxideRedThemeGUI.NotificationScript  
local function C_16()
    local script = G2L["16"]
    -- Notification positioning and management handled in main library
end

-- Initialize scripts
task.spawn(C_14)
task.spawn(C_15) 
task.spawn(C_16)

return Library
