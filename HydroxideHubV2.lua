--[=[
 ██╗  ██╗██╗   ██╗██████╗ ██████╗  ██████╗ ██╗  ██╗██╗██████╗ ███████╗    ██╗   ██╗██████╗ 
 ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝██║██╔══██╗██╔════╝    ██║   ██║╚════██╗
 ███████║ ╚████╔╝ ██║  ██║██████╔╝██║   ██║ ╚███╔╝ ██║██║  ██║█████╗      ██║   ██║ █████╔╝
 ██╔══██║  ╚██╔╝  ██║  ██║██╔══██╗██║   ██║ ██╔██╗ ██║██║  ██║██╔══╝      ╚██╗ ██╔╝██╔═══╝ 
 ██║  ██║   ██║   ██████╔╝██║  ██║╚██████╔╝██╔╝ ██╗██║██████╔╝███████╗     ╚████╔╝ ███████╗
 ╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝╚═════╝ ╚══════╝      ╚═══╝  ╚══════╝
]=]

-- Enhanced Hydroxide Hub V2.0 - Professional Gaming Hub
-- No Hooks | No Metamethods | Clean & Secure

repeat wait() until game:IsLoaded() and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Clean existing GUIs
for _, gui in pairs(PlayerGui:GetChildren()) do
    if gui.Name == "HydroxideHubV2" or gui.Name == "HydroxideRedThemeGUI" then
        gui:Destroy()
    end
end

-- Variables
local Library = {}
local GuiState = {
    IsOpen = false,
    CurrentTab = nil,
    Tabs = {},
    Connections = {},
    Settings = {}
}

-- Theme Configuration
local Theme = {
    -- Main Colors
    Background = Color3.fromRGB(0, 0, 0),
    Sidebar = Color3.fromRGB(0, 0, 0),
    Content = Color3.fromRGB(0, 0, 0),
    TopBar = Color3.fromRGB(0, 0, 0),
    
    -- Accent Colors
    Primary = Color3.fromRGB(220, 50, 60),
    Secondary = Color3.fromRGB(240, 70, 80),
    Accent = Color3.fromRGB(255, 60, 70),
    
    -- Text Colors
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    TextMuted = Color3.fromRGB(130, 130, 130),
    
    -- Border Colors
    Border = Color3.fromRGB(220, 50, 60),
    BorderLight = Color3.fromRGB(255, 60, 70),
    
    -- Status Colors
    Success = Color3.fromRGB(72, 187, 120),
    Warning = Color3.fromRGB(245, 158, 11),
    Error = Color3.fromRGB(239, 68, 68),
    Info = Color3.fromRGB(59, 130, 246),
    
    -- Interactive Colors
    Hover = Color3.fromRGB(15, 15, 15),
    Active = Color3.fromRGB(25, 25, 25),
    Disabled = Color3.fromRGB(50, 50, 50)
}

-- Utility Functions
local function CreateTween(object, properties, duration, style, direction)
    duration = duration or 0.3
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    
    local tweenInfo = TweenInfo.new(duration, style, direction)
    local tween = TweenService:Create(object, tweenInfo, properties)
    return tween
end

local function AddCorner(object, radius)
    radius = radius or 8
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = object
    return corner
end

local function AddStroke(object, color, thickness)
    thickness = thickness or 1
    color = color or Theme.Border
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Parent = object
    return stroke
end

local function FormatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

local function GetPing()
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    return ping:match("(%d+)") or "0"
end

local function GetFPS()
    local fps = workspace:GetRealPhysicsFPS()
    return math.floor(fps)
end

-- Main GUI Creation
function Library:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "Hydroxide Hub V2"
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "HydroxideHubV2"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Create blur effect
    local BlurEffect = Instance.new("BlurEffect")
    BlurEffect.Name = "HydroxideBlur"
    BlurEffect.Size = 0
    BlurEffect.Parent = Lighting
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)
    MainFrame.Size = UDim2.new(0, 800, 0, 500)
    MainFrame.ClipsDescendants = true
    
    AddCorner(MainFrame, 12)
    AddStroke(MainFrame, Theme.Border, 2)
    
    -- TopBar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Theme.TopBar
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.Position = UDim2.new(0, 0, 0, 0)
    
    AddCorner(TopBar, 12)
    AddStroke(TopBar, Theme.Border, 1)
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.Size = UDim2.new(1, -120, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = windowTitle
    Title.TextColor3 = Theme.Text
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundColor3 = Theme.Error
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(1, -40, 0, 10)
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.new(1, 1, 1)
    CloseButton.TextSize = 20
    
    AddCorner(CloseButton, 6)
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TopBar
    MinimizeButton.BackgroundColor3 = Theme.Warning
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Position = UDim2.new(1, -75, 0, 10)
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
    MinimizeButton.TextSize = 20
    
    AddCorner(MinimizeButton, 6)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.Size = UDim2.new(0, 200, 1, -50)
    
    AddCorner(Sidebar, 12)
    AddStroke(Sidebar, Theme.Border, 1)
    
    -- Sidebar ScrollingFrame
    local SidebarScroll = Instance.new("ScrollingFrame")
    SidebarScroll.Name = "SidebarScroll"
    SidebarScroll.Parent = Sidebar
    SidebarScroll.BackgroundTransparency = 1
    SidebarScroll.BorderSizePixel = 0
    SidebarScroll.Position = UDim2.new(0, 10, 0, 20)
    SidebarScroll.Size = UDim2.new(1, -20, 1, -30)
    SidebarScroll.ScrollBarThickness = 4
    SidebarScroll.ScrollBarImageColor3 = Theme.Primary
    SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Name = "SidebarLayout"
    SidebarLayout.Parent = SidebarScroll
    SidebarLayout.FillDirection = Enum.FillDirection.Vertical
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 8)
    
    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Parent = MainFrame
    ContentArea.BackgroundColor3 = Theme.Content
    ContentArea.BorderSizePixel = 0
    ContentArea.Position = UDim2.new(0, 210, 0, 60)
    ContentArea.Size = UDim2.new(1, -220, 1, -70)
    
    AddCorner(ContentArea, 12)
    AddStroke(ContentArea, Theme.Border, 1)
    
    -- Content ScrollingFrame
    local ContentScroll = Instance.new("ScrollingFrame")
    ContentScroll.Name = "ContentScroll"
    ContentScroll.Parent = ContentArea
    ContentScroll.BackgroundTransparency = 1
    ContentScroll.BorderSizePixel = 0
    ContentScroll.Position = UDim2.new(0, 15, 0, 15)
    ContentScroll.Size = UDim2.new(1, -30, 1, -30)
    ContentScroll.ScrollBarThickness = 6
    ContentScroll.ScrollBarImageColor3 = Theme.Primary
    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Name = "ContentLayout"
    ContentLayout.Parent = ContentScroll
    ContentLayout.FillDirection = Enum.FillDirection.Vertical
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10)
    
    -- Notification Area
    local NotificationArea = Instance.new("Frame")
    NotificationArea.Name = "NotificationArea"
    NotificationArea.Parent = ScreenGui
    NotificationArea.BackgroundTransparency = 1
    NotificationArea.Position = UDim2.new(1, -320, 0, 20)
    NotificationArea.Size = UDim2.new(0, 300, 1, -40)
    
    local NotificationLayout = Instance.new("UIListLayout")
    NotificationLayout.Name = "NotificationLayout"
    NotificationLayout.Parent = NotificationArea
    NotificationLayout.FillDirection = Enum.FillDirection.Vertical
    NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    NotificationLayout.Padding = UDim.new(0, 10)
    
    -- Window Functions
    local Window = {}
    
    -- Toggle GUI
    function Window:Toggle()
        GuiState.IsOpen = not GuiState.IsOpen
        
        if GuiState.IsOpen then
            MainFrame.Visible = true
            CreateTween(BlurEffect, {Size = 8}, 0.3):Play()
            
            MainFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
            CreateTween(MainFrame, {
                Position = UDim2.new(0.5, -400, 0.5, -250)
            }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
        else
            CreateTween(BlurEffect, {Size = 0}, 0.3):Play()
            
            local exitTween = CreateTween(MainFrame, {
                Position = UDim2.new(0.5, -400, 0.5, -300)
            }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            
            exitTween:Play()
            exitTween.Completed:Connect(function()
                MainFrame.Visible = false
            end)
        end
    end
    
    -- Show notification
    function Window:Notify(title, description, notifType, duration)
        notifType = notifType or "info"
        duration = duration or 4
        
        local typeColors = {
            success = Theme.Success,
            warning = Theme.Warning,
            error = Theme.Error,
            info = Theme.Info
        }
        
        local NotificationFrame = Instance.new("Frame")
        NotificationFrame.Name = "Notification"
        NotificationFrame.Parent = NotificationArea
        NotificationFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        NotificationFrame.BorderSizePixel = 0
        NotificationFrame.Size = UDim2.new(1, 0, 0, 80)
        NotificationFrame.Position = UDim2.new(1, 50, 0, 0)
        
        AddCorner(NotificationFrame, 8)
        AddStroke(NotificationFrame, typeColors[notifType] or Theme.Info, 2)
        
        -- Notification Title
        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Name = "Title"
        NotifTitle.Parent = NotificationFrame
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Position = UDim2.new(0, 15, 0, 8)
        NotifTitle.Size = UDim2.new(1, -30, 0, 20)
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.Text = title
        NotifTitle.TextColor3 = Theme.Text
        NotifTitle.TextSize = 14
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Notification Description
        local NotifDesc = Instance.new("TextLabel")
        NotifDesc.Name = "Description"
        NotifDesc.Parent = NotificationFrame
        NotifDesc.BackgroundTransparency = 1
        NotifDesc.Position = UDim2.new(0, 15, 0, 30)
        NotifDesc.Size = UDim2.new(1, -30, 0, 40)
        NotifDesc.Font = Enum.Font.Gotham
        NotifDesc.Text = description
        NotifDesc.TextColor3 = Theme.TextDark
        NotifDesc.TextSize = 12
        NotifDesc.TextXAlignment = Enum.TextXAlignment.Left
        NotifDesc.TextYAlignment = Enum.TextYAlignment.Top
        NotifDesc.TextWrapped = true
        
        -- Animate in
        CreateTween(NotificationFrame, {
            Position = UDim2.new(0, 0, 0, 0)
        }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
        
        -- Auto remove
        task.spawn(function()
            task.wait(duration)
            
            local fadeOut = CreateTween(NotificationFrame, {
                Position = UDim2.new(1, 50, 0, 0),
                BackgroundTransparency = 1
            }, 0.3)
            
            CreateTween(NotifTitle, {TextTransparency = 1}, 0.3):Play()
            CreateTween(NotifDesc, {TextTransparency = 1}, 0.3):Play()
            
            fadeOut:Play()
            fadeOut.Completed:Connect(function()
                NotificationFrame:Destroy()
            end)
        end)
    end
    
    -- Create Tab
    function Window:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon or "🔹"
        
        local Tab = {}
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Button"
        TabButton.Parent = SidebarScroll
        TabButton.BackgroundColor3 = Theme.Sidebar
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.Text = tabIcon .. "  " .. tabName
        TabButton.TextColor3 = Theme.TextDark
        TabButton.TextSize = 14
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        
        local TabPadding = Instance.new("UIPadding")
        TabPadding.Parent = TabButton
        TabPadding.PaddingLeft = UDim.new(0, 15)
        
        AddCorner(TabButton, 8)
        AddStroke(TabButton, Theme.Border, 1)
        
        -- Tab Content
        local TabContent = Instance.new("Frame")
        TabContent.Name = tabName .. "Content"
        TabContent.Parent = ContentScroll
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 0, 0)
        TabContent.Visible = false
        
        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.Name = "TabContentLayout"
        TabContentLayout.Parent = TabContent
        TabContentLayout.FillDirection = Enum.FillDirection.Vertical
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentLayout.Padding = UDim.new(0, 8)
        
        -- Tab Selection Logic
        TabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, tab in pairs(GuiState.Tabs) do
                tab.Content.Visible = false
                CreateTween(tab.Button, {
                    BackgroundColor3 = Theme.Sidebar,
                    TextColor3 = Theme.TextDark
                }, 0.2):Play()
            end
            
            -- Show selected tab
            TabContent.Visible = true
            GuiState.CurrentTab = Tab
            
            CreateTween(TabButton, {
                BackgroundColor3 = Theme.Primary,
                TextColor3 = Theme.Text
            }, 0.2):Play()
        end)
        
        -- Hover Effects
        TabButton.MouseEnter:Connect(function()
            if GuiState.CurrentTab ~= Tab then
                CreateTween(TabButton, {
                    BackgroundColor3 = Theme.Hover
                }, 0.15):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if GuiState.CurrentTab ~= Tab then
                CreateTween(TabButton, {
                    BackgroundColor3 = Theme.Sidebar
                }, 0.15):Play()
            end
        end)
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        Tab.Layout = TabContentLayout
        table.insert(GuiState.Tabs, Tab)
        
        -- Auto-select first tab
        if #GuiState.Tabs == 1 then
            TabContent.Visible = true
            GuiState.CurrentTab = Tab
            CreateTween(TabButton, {
                BackgroundColor3 = Theme.Primary,
                TextColor3 = Theme.Text
            }, 0.2):Play()
        end
        
        -- Update canvas size
        local function updateCanvasSize()
            SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y + 20)
            ContentScroll.CanvasSize = UDim2.new(0, 0, 0, TabContentLayout.AbsoluteContentSize.Y + 30)
        end
        
        SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)
        TabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)
        
        -- Tab Elements
        function Tab:AddSection(title)
            local Section = Instance.new("Frame")
            Section.Name = "Section"
            Section.Parent = TabContent
            Section.BackgroundTransparency = 1
            Section.Size = UDim2.new(1, 0, 0, 30)
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "SectionTitle"
            SectionTitle.Parent = Section
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Size = UDim2.new(1, 0, 1, 0)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = title
            SectionTitle.TextColor3 = Theme.Text
            SectionTitle.TextSize = 16
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            return Section
        end
        
        function Tab:AddSeparator()
            local Separator = Instance.new("Frame")
            Separator.Name = "Separator"
            Separator.Parent = TabContent
            Separator.BackgroundColor3 = Theme.Border
            Separator.BorderSizePixel = 0
            Separator.Size = UDim2.new(1, 0, 0, 2)
            
            AddCorner(Separator, 1)
            
            return Separator
        end
        
        function Tab:AddButton(config)
            config = config or {}
            local buttonText = config.Text or "Button"
            local buttonDesc = config.Description or ""
            local callback = config.Callback or function() end
            
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Name = "ButtonFrame"
            ButtonFrame.Parent = TabContent
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Size = UDim2.new(1, 0, 0, 45)
            
            AddCorner(ButtonFrame, 8)
            AddStroke(ButtonFrame, Theme.Border, 1)
            
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Parent = ButtonFrame
            Button.BackgroundColor3 = Theme.Primary
            Button.BorderSizePixel = 0
            Button.Position = UDim2.new(1, -100, 0, 8)
            Button.Size = UDim2.new(0, 90, 0, 30)
            Button.Font = Enum.Font.GothamMedium
            Button.Text = "Execute"
            Button.TextColor3 = Theme.Text
            Button.TextSize = 12
            
            AddCorner(Button, 6)
            
            local ButtonLabel = Instance.new("TextLabel")
            ButtonLabel.Name = "ButtonLabel"
            ButtonLabel.Parent = ButtonFrame
            ButtonLabel.BackgroundTransparency = 1
            ButtonLabel.Position = UDim2.new(0, 15, 0, 5)
            ButtonLabel.Size = UDim2.new(1, -120, 0, 20)
            ButtonLabel.Font = Enum.Font.GothamMedium
            ButtonLabel.Text = buttonText
            ButtonLabel.TextColor3 = Theme.Text
            ButtonLabel.TextSize = 14
            ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local ButtonDesc = Instance.new("TextLabel")
            ButtonDesc.Name = "ButtonDesc"
            ButtonDesc.Parent = ButtonFrame
            ButtonDesc.BackgroundTransparency = 1
            ButtonDesc.Position = UDim2.new(0, 15, 0, 22)
            ButtonDesc.Size = UDim2.new(1, -120, 0, 18)
            ButtonDesc.Font = Enum.Font.Gotham
            ButtonDesc.Text = buttonDesc
            ButtonDesc.TextColor3 = Theme.TextMuted
            ButtonDesc.TextSize = 11
            ButtonDesc.TextXAlignment = Enum.TextXAlignment.Left
            
            -- Button functionality
            Button.MouseButton1Click:Connect(function()
                CreateTween(Button, {BackgroundColor3 = Theme.Secondary}, 0.1):Play()
                task.wait(0.1)
                CreateTween(Button, {BackgroundColor3 = Theme.Primary}, 0.1):Play()
                
                callback()
            end)
            
            -- Hover effects
            Button.MouseEnter:Connect(function()
                CreateTween(Button, {BackgroundColor3 = Theme.Secondary}, 0.15):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                CreateTween(Button, {BackgroundColor3 = Theme.Primary}, 0.15):Play()
            end)
            
            return ButtonFrame
        end
        
        function Tab:AddToggle(config)
            config = config or {}
            local toggleText = config.Text or "Toggle"
            local toggleDesc = config.Description or ""
            local default = config.Default or false
            local callback = config.Callback or function() end
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "ToggleFrame"
            ToggleFrame.Parent = TabContent
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Size = UDim2.new(1, 0, 0, 45)
            
            AddCorner(ToggleFrame, 8)
            AddStroke(ToggleFrame, Theme.Border, 1)
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Parent = ToggleFrame
            ToggleButton.BackgroundColor3 = default and Theme.Primary or Color3.fromRGB(50, 50, 50)
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Position = UDim2.new(1, -60, 0, 12)
            ToggleButton.Size = UDim2.new(0, 45, 0, 22)
            ToggleButton.Text = ""
            
            AddCorner(ToggleButton, 11)
            
            local ToggleKnob = Instance.new("Frame")
            ToggleKnob.Name = "ToggleKnob"
            ToggleKnob.Parent = ToggleButton
            ToggleKnob.BackgroundColor3 = Color3.new(1, 1, 1)
            ToggleKnob.BorderSizePixel = 0
            ToggleKnob.Position = default and UDim2.new(0, 25, 0, 2) or UDim2.new(0, 2, 0, 2)
            ToggleKnob.Size = UDim2.new(0, 18, 0, 18)
            
            AddCorner(ToggleKnob, 9)
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Name = "ToggleLabel"
            ToggleLabel.Parent = ToggleFrame
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0, 15, 0, 5)
            ToggleLabel.Size = UDim2.new(1, -80, 0, 20)
            ToggleLabel.Font = Enum.Font.GothamMedium
            ToggleLabel.Text = toggleText
            ToggleLabel.TextColor3 = Theme.Text
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local ToggleDesc = Instance.new("TextLabel")
            ToggleDesc.Name = "ToggleDesc"
            ToggleDesc.Parent = ToggleFrame
            ToggleDesc.BackgroundTransparency = 1
            ToggleDesc.Position = UDim2.new(0, 15, 0, 22)
            ToggleDesc.Size = UDim2.new(1, -80, 0, 18)
            ToggleDesc.Font = Enum.Font.Gotham
            ToggleDesc.Text = toggleDesc
            ToggleDesc.TextColor3 = Theme.TextMuted
            ToggleDesc.TextSize = 11
            ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left
            
            local isToggled = default
            
            -- Toggle functionality
            ToggleButton.MouseButton1Click:Connect(function()
                isToggled = not isToggled
                
                CreateTween(ToggleButton, {
                    BackgroundColor3 = isToggled and Theme.Primary or Color3.fromRGB(50, 50, 50)
                }, 0.2):Play()
                
                CreateTween(ToggleKnob, {
                    Position = isToggled and UDim2.new(0, 25, 0, 2) or UDim2.new(0, 2, 0, 2)
                }, 0.2):Play()
                
                callback(isToggled)
            end)
            
            return ToggleFrame, function() return isToggled end
        end
        
        function Tab:AddSlider(config)
            config = config or {}
            local sliderText = config.Text or "Slider"
            local sliderDesc = config.Description or ""
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or min
            local callback = config.Callback or function() end
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "SliderFrame"
            SliderFrame.Parent = TabContent
            SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Size = UDim2.new(1, 0, 0, 60)
            
            AddCorner(SliderFrame, 8)
            AddStroke(SliderFrame, Theme.Border, 1)
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Name = "SliderLabel"
            SliderLabel.Parent = SliderFrame
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Position = UDim2.new(0, 15, 0, 5)
            SliderLabel.Size = UDim2.new(1, -80, 0, 18)
            SliderLabel.Font = Enum.Font.GothamMedium
            SliderLabel.Text = sliderText .. ": " .. default
            SliderLabel.TextColor3 = Theme.Text
            SliderLabel.TextSize = 14
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local SliderDesc = Instance.new("TextLabel")
            SliderDesc.Name = "SliderDesc"
            SliderDesc.Parent = SliderFrame
            SliderDesc.BackgroundTransparency = 1
            SliderDesc.Position = UDim2.new(0, 15, 0, 20)
            SliderDesc.Size = UDim2.new(1, -30, 0, 15)
            SliderDesc.Font = Enum.Font.Gotham
            SliderDesc.Text = sliderDesc
            SliderDesc.TextColor3 = Theme.TextMuted
            SliderDesc.TextSize = 11
            SliderDesc.TextXAlignment = Enum.TextXAlignment.Left
            
            local SliderTrack = Instance.new("Frame")
            SliderTrack.Name = "SliderTrack"
            SliderTrack.Parent = SliderFrame
            SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            SliderTrack.BorderSizePixel = 0
            SliderTrack.Position = UDim2.new(0, 15, 0, 38)
            SliderTrack.Size = UDim2.new(1, -30, 0, 6)
            
            AddCorner(SliderTrack, 3)
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "SliderFill"
            SliderFill.Parent = SliderTrack
            SliderFill.BackgroundColor3 = Theme.Primary
            SliderFill.BorderSizePixel = 0
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            
            AddCorner(SliderFill, 3)
            
            local SliderKnob = Instance.new("Frame")
            SliderKnob.Name = "SliderKnob"
            SliderKnob.Parent = SliderTrack
            SliderKnob.BackgroundColor3 = Color3.new(1, 1, 1)
            SliderKnob.BorderSizePixel = 0
            SliderKnob.Position = UDim2.new((default - min) / (max - min), -8, 0, -4)
            SliderKnob.Size = UDim2.new(0, 16, 0, 14)
            
            AddCorner(SliderKnob, 7)
            
            local currentValue = default
            local dragging = false
            
            local function updateSlider(value)
                currentValue = math.clamp(value, min, max)
                local percentage = (currentValue - min) / (max - min)
                
                SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                SliderKnob.Position = UDim2.new(percentage, -8, 0, -4)
                SliderLabel.Text = sliderText .. ": " .. math.floor(currentValue)
                
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
                    
                    updateSlider(value)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            return SliderFrame, function() return currentValue end
        end
        
        function Tab:AddTextbox(config)
            config = config or {}
            local textboxText = config.Text or "Textbox"
            local textboxDesc = config.Description or ""
            local placeholder = config.Placeholder or "Enter text..."
            local callback = config.Callback or function() end
            
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Name = "TextboxFrame"
            TextboxFrame.Parent = TabContent
            TextboxFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            TextboxFrame.BorderSizePixel = 0
            TextboxFrame.Size = UDim2.new(1, 0, 0, 60)
            
            AddCorner(TextboxFrame, 8)
            AddStroke(TextboxFrame, Theme.Border, 1)
            
            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Name = "TextboxLabel"
            TextboxLabel.Parent = TextboxFrame
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Position = UDim2.new(0, 15, 0, 5)
            TextboxLabel.Size = UDim2.new(1, -30, 0, 18)
            TextboxLabel.Font = Enum.Font.GothamMedium
            TextboxLabel.Text = textboxText
            TextboxLabel.TextColor3 = Theme.Text
            TextboxLabel.TextSize = 14
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local TextboxDesc = Instance.new("TextLabel")
            TextboxDesc.Name = "TextboxDesc"
            TextboxDesc.Parent = TextboxFrame
            TextboxDesc.BackgroundTransparency = 1
            TextboxDesc.Position = UDim2.new(0, 15, 0, 20)
            TextboxDesc.Size = UDim2.new(1, -30, 0, 15)
            TextboxDesc.Font = Enum.Font.Gotham
            TextboxDesc.Text = textboxDesc
            TextboxDesc.TextColor3 = Theme.TextMuted
            TextboxDesc.TextSize = 11
            TextboxDesc.TextXAlignment = Enum.TextXAlignment.Left
            
            local Textbox = Instance.new("TextBox")
            Textbox.Name = "Textbox"
            Textbox.Parent = TextboxFrame
            Textbox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Textbox.BorderSizePixel = 0
            Textbox.Position = UDim2.new(0, 15, 0, 36)
            Textbox.Size = UDim2.new(1, -30, 0, 20)
            Textbox.Font = Enum.Font.Gotham
            Textbox.PlaceholderText = placeholder
            Textbox.PlaceholderColor3 = Theme.TextMuted
            Textbox.Text = ""
            Textbox.TextColor3 = Theme.Text
            Textbox.TextSize = 12
            Textbox.TextXAlignment = Enum.TextXAlignment.Left
            
            AddCorner(Textbox, 4)
            AddStroke(Textbox, Theme.Border, 1)
            
            -- Textbox functionality
            Textbox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    callback(Textbox.Text)
                end
            end)
            
            return TextboxFrame, function() return Textbox.Text end
        end
        
        function Tab:AddKeybind(config)
            config = config or {}
            local keybindText = config.Text or "Keybind"
            local keybindDesc = config.Description or ""
            local defaultKey = config.Default or Enum.KeyCode.F
            local callback = config.Callback or function() end
            
            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Name = "KeybindFrame"
            KeybindFrame.Parent = TabContent
            KeybindFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            KeybindFrame.BorderSizePixel = 0
            KeybindFrame.Size = UDim2.new(1, 0, 0, 45)
            
            AddCorner(KeybindFrame, 8)
            AddStroke(KeybindFrame, Theme.Border, 1)
            
            local KeybindLabel = Instance.new("TextLabel")
            KeybindLabel.Name = "KeybindLabel"
            KeybindLabel.Parent = KeybindFrame
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.Position = UDim2.new(0, 15, 0, 5)
            KeybindLabel.Size = UDim2.new(1, -120, 0, 20)
            KeybindLabel.Font = Enum.Font.GothamMedium
            KeybindLabel.Text = keybindText
            KeybindLabel.TextColor3 = Theme.Text
            KeybindLabel.TextSize = 14
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local KeybindDesc = Instance.new("TextLabel")
            KeybindDesc.Name = "KeybindDesc"
            KeybindDesc.Parent = KeybindFrame
            KeybindDesc.BackgroundTransparency = 1
            KeybindDesc.Position = UDim2.new(0, 15, 0, 22)
            KeybindDesc.Size = UDim2.new(1, -120, 0, 18)
            KeybindDesc.Font = Enum.Font.Gotham
            KeybindDesc.Text = keybindDesc
            KeybindDesc.TextColor3 = Theme.TextMuted
            KeybindDesc.TextSize = 11
            KeybindDesc.TextXAlignment = Enum.TextXAlignment.Left
            
            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Name = "KeybindButton"
            KeybindButton.Parent = KeybindFrame
            KeybindButton.BackgroundColor3 = Theme.Primary
            KeybindButton.BorderSizePixel = 0
            KeybindButton.Position = UDim2.new(1, -100, 0, 8)
            KeybindButton.Size = UDim2.new(0, 90, 0, 30)
            KeybindButton.Font = Enum.Font.GothamMedium
            KeybindButton.Text = defaultKey.Name
            KeybindButton.TextColor3 = Theme.Text
            KeybindButton.TextSize = 12
            
            AddCorner(KeybindButton, 6)
            
            local currentKey = defaultKey
            local listening = false
            
            -- Set up initial keybind
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.KeyCode == currentKey then
                    callback()
                end
            end)
            
            -- Keybind button functionality
            KeybindButton.MouseButton1Click:Connect(function()
                if listening then return end
                
                listening = true
                KeybindButton.Text = "..."
                KeybindButton.BackgroundColor3 = Theme.Warning
                
                local connection
                connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    
                    if input.KeyCode ~= Enum.KeyCode.Unknown then
                        currentKey = input.KeyCode
                        KeybindButton.Text = currentKey.Name
                        KeybindButton.BackgroundColor3 = Theme.Primary
                        listening = false
                        connection:Disconnect()
                        
                        -- Set up new keybind
                        UserInputService.InputBegan:Connect(function(newInput, newGameProcessed)
                            if newGameProcessed then return end
                            if newInput.KeyCode == currentKey then
                                callback()
                            end
                        end)
                    end
                end)
            end)
            
            return KeybindFrame, function() return currentKey end
        end
        
        return Tab
    end
    
    -- Button Event Handlers
    CloseButton.MouseButton1Click:Connect(function()
        CreateTween(CloseButton, {BackgroundColor3 = Theme.Secondary}, 0.1):Play()
        task.wait(0.1)
        
        ScreenGui:Destroy()
        if BlurEffect then
            BlurEffect:Destroy()
        end
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        CreateTween(MinimizeButton, {BackgroundColor3 = Color3.fromRGB(255, 200, 0)}, 0.1):Play()
        task.wait(0.1)
        CreateTween(MinimizeButton, {BackgroundColor3 = Theme.Warning}, 0.1):Play()
        
        Window:Toggle()
    end)
    
    -- Close button hover
    CloseButton.MouseEnter:Connect(function()
        CreateTween(CloseButton, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}, 0.15):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        CreateTween(CloseButton, {BackgroundColor3 = Theme.Error}, 0.15):Play()
    end)
    
    -- Minimize button hover
    MinimizeButton.MouseEnter:Connect(function()
        CreateTween(MinimizeButton, {BackgroundColor3 = Color3.fromRGB(255, 200, 0)}, 0.15):Play()
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        CreateTween(MinimizeButton, {BackgroundColor3 = Theme.Warning}, 0.15):Play()
    end)
    
    -- Dragging functionality
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    TopBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    TopBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Toggle keybind (Right Shift)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            Window:Toggle()
        end
    end)
    
    -- Initial state
    MainFrame.Visible = false
    GuiState.IsOpen = false
    
    -- Show initial notification
    task.spawn(function()
        task.wait(1)
        Window:Notify(
            "Hydroxide Hub V2.0", 
            "Successfully loaded! Press Right Shift to toggle.", 
            "success", 
            5
        )
    end)
    
    return Window
end

-- Return Library
return Library
