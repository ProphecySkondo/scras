--[[
 ███╗   ██╗ ██████╗ ██╗   ██╗ █████╗     ██╗  ██╗██╗   ██╗██████╗ ██████╗  ██████╗ ██╗  ██╗██╗██████╗ ███████╗
 ████╗  ██║██╔═══██╗██║   ██║██╔══██╗    ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝██║██╔══██╗██╔════╝
 ██╔██╗ ██║██║   ██║██║   ██║███████║    ███████║ ╚████╔╝ ██║  ██║██████╔╝██║   ██║ ╚███╔╝ ██║██║  ██║█████╗  
 ██║╚██╗██║██║   ██║╚██╗ ██╔╝██╔══██║    ██╔══██║  ╚██╔╝  ██║  ██║██╔══██╗██║   ██║ ██╔██╗ ██║██║  ██║██╔══╝  
 ██║ ╚████║╚██████╔╝ ╚████╔╝ ██║  ██║    ██║  ██║   ██║   ██████╔╝██║  ██║╚██████╔╝██╔╝ ██╗██║██████╔╝███████╗
 ╚═╝  ╚═══╝ ╚═════╝   ╚═══╝  ╚═╝  ╚═╝    ╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝╚═════╝ ╚══════╝
]]

repeat wait() until game:IsLoaded() and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Clean existing
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "NovaHydroxide" then
        v:Destroy()
    end
end

function Library:Window(title)
    title = title or "Nova Hydroxide"
    
    -- Main ScreenGui
    local Holder = Instance.new("ScreenGui")
    Holder.Name = "NovaHydroxide"
    Holder.Parent = CoreGui
    Holder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = Holder
    Main.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.2, 0, 0.207, 0)
    Main.Size = UDim2.new(0, 800, 0, 500)
    Main.Visible = false
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 4)
    MainCorner.Parent = Main
    
    -- Left Section (Sidebar)
    local LeftSection = Instance.new("Frame")
    LeftSection.Name = "LeftSection"
    LeftSection.Parent = Main
    LeftSection.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    LeftSection.BorderSizePixel = 1
    LeftSection.BorderColor3 = Color3.fromRGB(220, 50, 60)
    LeftSection.Size = UDim2.new(0, 180, 0, 500)
    
    local LeftCorner = Instance.new("UICorner")
    LeftCorner.CornerRadius = UDim.new(0, 4)
    LeftCorner.Parent = LeftSection
    
    -- Tab Section
    local TabSection = Instance.new("Frame")
    TabSection.Name = "TabSection"
    TabSection.Parent = LeftSection
    TabSection.BackgroundTransparency = 1
    TabSection.Position = UDim2.new(0.08, 0, 0.17, 0)
    TabSection.Size = UDim2.new(0, 150, 0, 375)
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabSection
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)
    
    -- Title
    local Title = Instance.new("ImageLabel")
    Title.Name = "Title" 
    Title.Parent = LeftSection
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 0, 0.006, 0)
    Title.Size = UDim2.new(0, 170, 0, 93)
    Title.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    
    local TitleText = Instance.new("TextLabel")
    TitleText.Parent = Title
    TitleText.BackgroundTransparency = 1
    TitleText.Size = UDim2.new(1, 0, 1, 0)
    TitleText.Font = Enum.Font.GothamBold
    TitleText.Text = title
    TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleText.TextSize = 20
    
    -- Content Holder
    local TabContentHolder = Instance.new("Frame")
    TabContentHolder.Name = "TabContentHolder"
    TabContentHolder.Parent = Main
    TabContentHolder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    TabContentHolder.BorderSizePixel = 1
    TabContentHolder.BorderColor3 = Color3.fromRGB(220, 50, 60)
    TabContentHolder.Position = UDim2.new(0.225, 0, 0.1, 0)
    TabContentHolder.Size = UDim2.new(0, 620, 0, 450)
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 4)
    ContentCorner.Parent = TabContentHolder
    
    -- Blur Effect
    local MenuBlur = Instance.new("BlurEffect")
    MenuBlur.Name = "NovaBlur"
    MenuBlur.Size = 0
    MenuBlur.Parent = Lighting
    
    -- Menu Sound
    local MenuSound = Instance.new("Sound")
    MenuSound.Name = "NovaLibSound"
    MenuSound.Parent = Holder
    MenuSound.SoundId = "rbxassetid://6895079853"
    MenuSound.Volume = 0.5
    
    local WindowObject = {
        Tabs = {},
        CurrentTab = nil
    }
    
    -- Toggle Function
    function WindowObject:Toggle()
        if Main.Visible then
            Main.Visible = false
            MenuBlur.Enabled = false
            MenuSound:Stop()
        else
            Main.Visible = true
            MenuBlur.Enabled = true
            MenuBlur.Size = 8
            MenuSound:Play()
        end
    end
    
    -- Notification Function
    function WindowObject:Notification(title, text, type, duration)
        type = type or "Info"
        duration = duration or 4
        
        local NotificationFrame = Instance.new("Frame")
        NotificationFrame.Name = "Notification"
        NotificationFrame.Parent = Holder
        NotificationFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        NotificationFrame.BorderSizePixel = 1
        NotificationFrame.BorderColor3 = Color3.fromRGB(220, 50, 60)
        NotificationFrame.Position = UDim2.new(1, -320, 0, 20)
        NotificationFrame.Size = UDim2.new(0, 300, 0, 80)
        
        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 4)
        NotifCorner.Parent = NotificationFrame
        
        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Parent = NotificationFrame
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Position = UDim2.new(0, 10, 0, 5)
        NotifTitle.Size = UDim2.new(1, -20, 0, 20)
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.Text = title
        NotifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        NotifTitle.TextSize = 14
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local NotifText = Instance.new("TextLabel")
        NotifText.Parent = NotificationFrame
        NotifText.BackgroundTransparency = 1
        NotifText.Position = UDim2.new(0, 10, 0, 25)
        NotifText.Size = UDim2.new(1, -20, 0, 50)
        NotifText.Font = Enum.Font.Gotham
        NotifText.Text = text
        NotifText.TextColor3 = Color3.fromRGB(180, 180, 180)
        NotifText.TextSize = 12
        NotifText.TextXAlignment = Enum.TextXAlignment.Left
        NotifText.TextYAlignment = Enum.TextYAlignment.Top
        NotifText.TextWrapped = true
        
        -- Animate in
        NotificationFrame.Position = UDim2.new(1, 50, 0, 20)
        TweenService:Create(NotificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position = UDim2.new(1, -320, 0, 20)
        }):Play()
        
        -- Auto remove
        task.spawn(function()
            task.wait(duration)
            TweenService:Create(NotificationFrame, TweenInfo.new(0.3), {
                Position = UDim2.new(1, 50, 0, 20)
            }):Play()
            task.wait(0.3)
            NotificationFrame:Destroy()
        end)
    end
    
    -- Tab Function
    function WindowObject:Tab(name, icon)
        name = name or "Tab"
        icon = icon or "rbxasset://textures/ui/GuiImagePlaceholder.png"
        
        local Tab = {
            Name = name,
            Elements = {}
        }
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Button"
        TabButton.Parent = TabSection
        TabButton.BackgroundColor3 = Color3.fromRGB(78, 0, 121)
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(0, 135, 0, 35)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = "  " .. name
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.TextSize = 14
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 4)
        TabCorner.Parent = TabButton
        
        -- Tab Icon
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "Icon"
        TabIcon.Parent = TabButton
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0.09, 0, 0.12, 0)
        TabIcon.Size = UDim2.new(0, 25, 0, 25)
        TabIcon.Image = icon
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Parent = TabContentHolder
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(220, 50, 60)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = TabContent
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 8)
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.Parent = TabContent
        ContentPadding.PaddingTop = UDim.new(0, 10)
        ContentPadding.PaddingLeft = UDim.new(0, 10)
        ContentPadding.PaddingRight = UDim.new(0, 10)
        ContentPadding.PaddingBottom = UDim.new(0, 10)
        
        -- Tab Selection
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(WindowObject.Tabs) do
                tab.Button.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                tab.Content.Visible = false
            end
            
            TabButton.BackgroundColor3 = Color3.fromRGB(78, 0, 121)
            TabContent.Visible = true
            WindowObject.CurrentTab = Tab
        end)
        
        -- Auto-select first tab
        if #WindowObject.Tabs == 0 then
            TabContent.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(78, 0, 121)
            WindowObject.CurrentTab = Tab
        else
            TabButton.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
        end
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        table.insert(WindowObject.Tabs, Tab)
        
        -- Update canvas size
        local function UpdateSize()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSize)
        
        -- Tab Elements
        function Tab:Section(text)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = "Section"
            SectionFrame.Parent = TabContent
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Size = UDim2.new(1, 0, 0, 30)
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Parent = SectionFrame
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Size = UDim2.new(1, 0, 1, 0)
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.Text = text
            SectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionLabel.TextSize = 16
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            UpdateSize()
            return SectionFrame
        end
        
        function Tab:Button(text, desc, callback)
            callback = callback or function() end
            
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = "Button"
            ButtonFrame.Parent = TabContent
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
            ButtonFrame.BorderSizePixel = 1
            ButtonFrame.BorderColor3 = Color3.fromRGB(220, 50, 60)
            ButtonFrame.Size = UDim2.new(1, 0, 0, 45)
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 4)
            ButtonCorner.Parent = ButtonFrame
            
            local Button = Instance.new("TextButton")
            Button.Parent = ButtonFrame
            Button.BackgroundColor3 = Color3.fromRGB(78, 0, 121)
            Button.BorderSizePixel = 0
            Button.Position = UDim2.new(1, -90, 0, 8)
            Button.Size = UDim2.new(0, 80, 0, 30)
            Button.Font = Enum.Font.Gotham
            Button.Text = "Execute"
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 12
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 4)
            BtnCorner.Parent = Button
            
            local ButtonTitle = Instance.new("TextLabel")
            ButtonTitle.Parent = ButtonFrame
            ButtonTitle.BackgroundTransparency = 1
            ButtonTitle.Position = UDim2.new(0, 10, 0, 5)
            ButtonTitle.Size = UDim2.new(1, -100, 0, 20)
            ButtonTitle.Font = Enum.Font.GothamMedium
            ButtonTitle.Text = text
            ButtonTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            ButtonTitle.TextSize = 14
            ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local ButtonDesc = Instance.new("TextLabel")
            ButtonDesc.Parent = ButtonFrame
            ButtonDesc.BackgroundTransparency = 1
            ButtonDesc.Position = UDim2.new(0, 10, 0, 22)
            ButtonDesc.Size = UDim2.new(1, -100, 0, 18)
            ButtonDesc.Font = Enum.Font.Gotham
            ButtonDesc.Text = desc
            ButtonDesc.TextColor3 = Color3.fromRGB(138, 138, 138)
            ButtonDesc.TextSize = 11
            ButtonDesc.TextXAlignment = Enum.TextXAlignment.Left
            
            Button.MouseButton1Click:Connect(callback)
            
            UpdateSize()
            return ButtonFrame
        end
        
        function Tab:Toggle(text, desc, default, callback)
            default = default or false
            callback = callback or function() end
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "Toggle"
            ToggleFrame.Parent = TabContent
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
            ToggleFrame.BorderSizePixel = 1
            ToggleFrame.BorderColor3 = Color3.fromRGB(220, 50, 60)
            ToggleFrame.Size = UDim2.new(1, 0, 0, 45)
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 4)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Parent = ToggleFrame
            ToggleButton.BackgroundColor3 = default and Color3.fromRGB(78, 0, 121) or Color3.fromRGB(60, 60, 60)
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Position = UDim2.new(1, -60, 0, 12)
            ToggleButton.Size = UDim2.new(0, 45, 0, 22)
            ToggleButton.Text = ""
            
            local ToggleBtnCorner = Instance.new("UICorner")
            ToggleBtnCorner.CornerRadius = UDim.new(0, 11)
            ToggleBtnCorner.Parent = ToggleButton
            
            local ToggleKnob = Instance.new("Frame")
            ToggleKnob.Parent = ToggleButton
            ToggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleKnob.BorderSizePixel = 0
            ToggleKnob.Position = default and UDim2.new(0, 25, 0, 2) or UDim2.new(0, 2, 0, 2)
            ToggleKnob.Size = UDim2.new(0, 18, 0, 18)
            
            local KnobCorner = Instance.new("UICorner")
            KnobCorner.CornerRadius = UDim.new(0, 9)
            KnobCorner.Parent = ToggleKnob
            
            local ToggleTitle = Instance.new("TextLabel")
            ToggleTitle.Parent = ToggleFrame
            ToggleTitle.BackgroundTransparency = 1
            ToggleTitle.Position = UDim2.new(0, 10, 0, 5)
            ToggleTitle.Size = UDim2.new(1, -80, 0, 20)
            ToggleTitle.Font = Enum.Font.GothamMedium
            ToggleTitle.Text = text
            ToggleTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleTitle.TextSize = 14
            ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local ToggleDesc = Instance.new("TextLabel")
            ToggleDesc.Parent = ToggleFrame
            ToggleDesc.BackgroundTransparency = 1
            ToggleDesc.Position = UDim2.new(0, 10, 0, 22)
            ToggleDesc.Size = UDim2.new(1, -80, 0, 18)
            ToggleDesc.Font = Enum.Font.Gotham
            ToggleDesc.Text = desc
            ToggleDesc.TextColor3 = Color3.fromRGB(138, 138, 138)
            ToggleDesc.TextSize = 11
            ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left
            
            local toggled = default
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = toggled and Color3.fromRGB(78, 0, 121) or Color3.fromRGB(60, 60, 60)
                }):Play()
                
                TweenService:Create(ToggleKnob, TweenInfo.new(0.2), {
                    Position = toggled and UDim2.new(0, 25, 0, 2) or UDim2.new(0, 2, 0, 2)
                }):Play()
                
                callback(toggled)
            end)
            
            UpdateSize()
            return ToggleFrame
        end
        
        function Tab:Slider(text, desc, min, max, default, callback)
            min = min or 0
            max = max or 100
            default = default or min
            callback = callback or function() end
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "Slider"
            SliderFrame.Parent = TabContent
            SliderFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
            SliderFrame.BorderSizePixel = 1
            SliderFrame.BorderColor3 = Color3.fromRGB(220, 50, 60)
            SliderFrame.Size = UDim2.new(1, 0, 0, 60)
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 4)
            SliderCorner.Parent = SliderFrame
            
            local SliderTitle = Instance.new("TextLabel")
            SliderTitle.Parent = SliderFrame
            SliderTitle.BackgroundTransparency = 1
            SliderTitle.Position = UDim2.new(0, 10, 0, 5)
            SliderTitle.Size = UDim2.new(1, -20, 0, 18)
            SliderTitle.Font = Enum.Font.GothamMedium
            SliderTitle.Text = text .. ": " .. default
            SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderTitle.TextSize = 14
            SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local SliderDesc = Instance.new("TextLabel")
            SliderDesc.Parent = SliderFrame
            SliderDesc.BackgroundTransparency = 1
            SliderDesc.Position = UDim2.new(0, 10, 0, 20)
            SliderDesc.Size = UDim2.new(1, -20, 0, 15)
            SliderDesc.Font = Enum.Font.Gotham
            SliderDesc.Text = desc
            SliderDesc.TextColor3 = Color3.fromRGB(138, 138, 138)
            SliderDesc.TextSize = 11
            SliderDesc.TextXAlignment = Enum.TextXAlignment.Left
            
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Parent = SliderFrame
            SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            SliderTrack.BorderSizePixel = 0
            SliderTrack.Position = UDim2.new(0, 10, 0, 38)
            SliderTrack.Size = UDim2.new(1, -20, 0, 6)
            
            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(0, 3)
            TrackCorner.Parent = SliderTrack
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Parent = SliderTrack
            SliderFill.BackgroundColor3 = Color3.fromRGB(78, 0, 121)
            SliderFill.BorderSizePixel = 0
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(0, 3)
            FillCorner.Parent = SliderFill
            
            local SliderKnob = Instance.new("Frame")
            SliderKnob.Parent = SliderTrack
            SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderKnob.BorderSizePixel = 0
            SliderKnob.Position = UDim2.new((default - min) / (max - min), -8, 0, -4)
            SliderKnob.Size = UDim2.new(0, 16, 0, 14)
            
            local KnobCorner = Instance.new("UICorner")
            KnobCorner.CornerRadius = UDim.new(0, 7)
            KnobCorner.Parent = SliderKnob
            
            local currentValue = default
            local dragging = false
            
            local function UpdateSlider(value)
                currentValue = math.clamp(value, min, max)
                local percentage = (currentValue - min) / (max - min)
                
                SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                SliderKnob.Position = UDim2.new(percentage, -8, 0, -4)
                SliderTitle.Text = text .. ": " .. math.floor(currentValue)
                
                callback(math.floor(currentValue))
            end
            
            SliderKnob.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = UserInputService:GetMouseLocation().X
                    local trackPos = SliderTrack.AbsolutePosition.X
                    local trackSize = SliderTrack.AbsoluteSize.X
                    
                    local percentage = math.clamp((mousePos - trackPos) / trackSize, 0, 1)
                    local value = min + (percentage * (max - min))
                    
                    UpdateSlider(value)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UpdateSize()
            return SliderFrame
        end
        
        return Tab
    end
    
    -- Toggle keybind
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightShift then
            WindowObject:Toggle()
        end
    end)
    
    -- Dragging
    local dragging = false
    local dragStart, startPos
    
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return WindowObject
end

return Library
