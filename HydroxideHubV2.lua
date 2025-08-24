--[=[\r
 ██╗  ██╗██╗   ██╗██████╗ ██████╗  ██████╗ ██╗  ██╗██╗██████╗ ███████╗    ██╗   ██╗██████╗ \r
 ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝██║██╔══██╗██╔════╝    ██║   ██║╚════██╗\r
 ███████║ ╚████╔╝ ██║  ██║██████╔╝██║   ██║ ╚███╔╝ ██║██║  ██║█████╗      ██║   ██║ █████╔╝\r
 ██╔══██║  ╚██╔╝  ██║  ██║██╔══██╗██║   ██║ ██╔██╗ ██║██║  ██║██╔══╝      ╚██╗ ██╔╝██╔═══╝ \r
 ██║  ██║   ██║   ██████╔╝██║  ██║╚██████╔╝██╔╝ ██╗██║██████╔╝███████╗     ╚████╔╝ ███████╗\r
 ╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝╚═════╝ ╚══════╝      ╚═══╝  ╚══════╝\r
]=]\r
\r
-- Enhanced Hydroxide Hub V2.0 - Professional Gaming Hub\r
-- No Hooks | No Metamethods | Clean & Secure\r
\r
repeat wait() until game:IsLoaded() and game.Players.LocalPlayer and game.Players.LocalPlayer.Character\r
\r
-- Services\r
local Players = game:GetService("Players")\r
local TweenService = game:GetService("TweenService")\r
local UserInputService = game:GetService("UserInputService")\r
local RunService = game:GetService("RunService")\r
local CoreGui = game:GetService("CoreGui")\r
local HttpService = game:GetService("HttpService")\r
local TeleportService = game:GetService("TeleportService")\r
local MarketplaceService = game:GetService("MarketplaceService")\r
local Lighting = game:GetService("Lighting")\r
\r
local Player = Players.LocalPlayer\r
local PlayerGui = Player:WaitForChild("PlayerGui")\r
local Character = Player.Character or Player.CharacterAdded:Wait()\r
local Humanoid = Character:WaitForChild("Humanoid")\r
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")\r
\r
-- Clean existing GUIs\r
for _, gui in pairs(PlayerGui:GetChildren()) do\r
    if gui.Name == "HydroxideHubV2" or gui.Name == "HydroxideRedThemeGUI" then\r
        gui:Destroy()\r
    end\r
end\r
\r
-- Variables\r
local Library = {}\r
local GuiState = {\r
    IsOpen = false,\r
    CurrentTab = nil,\r
    Tabs = {},\r
    Connections = {},\r
    Settings = {}\r
}\r
\r
-- Theme Configuration\r
local Theme = {\r
    -- Main Colors\r
    Background = Color3.fromRGB(0, 0, 0),\r
    Sidebar = Color3.fromRGB(0, 0, 0),\r
    Content = Color3.fromRGB(0, 0, 0),\r
    TopBar = Color3.fromRGB(0, 0, 0),\r
    \r
    -- Accent Colors\r
    Primary = Color3.fromRGB(220, 50, 60),\r
    Secondary = Color3.fromRGB(240, 70, 80),\r
    Accent = Color3.fromRGB(255, 60, 70),\r
    \r
    -- Text Colors\r
    Text = Color3.fromRGB(255, 255, 255),\r
    TextDark = Color3.fromRGB(180, 180, 180),\r
    TextMuted = Color3.fromRGB(130, 130, 130),\r
    \r
    -- Border Colors\r
    Border = Color3.fromRGB(220, 50, 60),\r
    BorderLight = Color3.fromRGB(255, 60, 70),\r
    \r
    -- Status Colors\r
    Success = Color3.fromRGB(72, 187, 120),\r
    Warning = Color3.fromRGB(245, 158, 11),\r
    Error = Color3.fromRGB(239, 68, 68),\r
    Info = Color3.fromRGB(59, 130, 246),\r
    \r
    -- Interactive Colors\r
    Hover = Color3.fromRGB(15, 15, 15),\r
    Active = Color3.fromRGB(25, 25, 25),\r
    Disabled = Color3.fromRGB(50, 50, 50)\r
}\r
\r
-- Utility Functions\r
local function CreateTween(object, properties, duration, style, direction)\r
    duration = duration or 0.3\r
    style = style or Enum.EasingStyle.Quad\r
    direction = direction or Enum.EasingDirection.Out\r
    \r
    local tweenInfo = TweenInfo.new(duration, style, direction)\r
    local tween = TweenService:Create(object, tweenInfo, properties)\r
    return tween\r
end\r
\r
local function AddCorner(object, radius)\r
    radius = radius or 8\r
    local corner = Instance.new("UICorner")\r
    corner.CornerRadius = UDim.new(0, radius)\r
    corner.Parent = object\r
    return corner\r
end\r
\r
local function AddStroke(object, color, thickness)\r
    thickness = thickness or 1\r
    color = color or Theme.Border\r
    local stroke = Instance.new("UIStroke")\r
    stroke.Color = color\r
    stroke.Thickness = thickness\r
    stroke.Parent = object\r
    return stroke\r
end\r
\r
local function FormatTime(seconds)\r
    local hours = math.floor(seconds / 3600)\r
    local minutes = math.floor((seconds % 3600) / 60)\r
    local secs = math.floor(seconds % 60)\r
    return string.format("%02d:%02d:%02d", hours, minutes, secs)\r
end\r
\r
local function GetPing()\r
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()\r
    return ping:match("(%d+)") or "0"\r
end\r
\r
local function GetFPS()\r
    local fps = workspace:GetRealPhysicsFPS()\r
    return math.floor(fps)\r
end\r
\r
-- Main GUI Creation\r
function Library:CreateWindow(config)\r
    config = config or {}\r
    local windowTitle = config.Title or "Hydroxide Hub V2"\r
    \r
    -- Create ScreenGui\r
    local ScreenGui = Instance.new("ScreenGui")\r
    ScreenGui.Name = "HydroxideHubV2"\r
    ScreenGui.Parent = PlayerGui\r
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling\r
    ScreenGui.ResetOnSpawn = false\r
    \r
    -- Create blur effect\r
    local BlurEffect = Instance.new("BlurEffect")\r
    BlurEffect.Name = "HydroxideBlur"\r
    BlurEffect.Size = 0\r
    BlurEffect.Parent = Lighting\r
    \r
    -- Main Frame\r
    local MainFrame = Instance.new("Frame")\r
    MainFrame.Name = "MainFrame"\r
    MainFrame.Parent = ScreenGui\r
    MainFrame.BackgroundColor3 = Theme.Background\r
    MainFrame.BorderSizePixel = 0\r
    MainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)\r
    MainFrame.Size = UDim2.new(0, 800, 0, 500)\r
    MainFrame.ClipsDescendants = true\r
    \r
    AddCorner(MainFrame, 12)\r
    AddStroke(MainFrame, Theme.Border, 2)\r
    \r
    -- TopBar\r
    local TopBar = Instance.new("Frame")\r
    TopBar.Name = "TopBar"\r
    TopBar.Parent = MainFrame\r
    TopBar.BackgroundColor3 = Theme.TopBar\r
    TopBar.BorderSizePixel = 0\r
    TopBar.Size = UDim2.new(1, 0, 0, 50)\r
    TopBar.Position = UDim2.new(0, 0, 0, 0)\r
    \r
    AddCorner(TopBar, 12)\r
    AddStroke(TopBar, Theme.Border, 1)\r
    \r
    -- Title\r
    local Title = Instance.new("TextLabel")\r
    Title.Name = "Title"\r
    Title.Parent = TopBar\r
    Title.BackgroundTransparency = 1\r
    Title.Position = UDim2.new(0, 20, 0, 0)\r
    Title.Size = UDim2.new(1, -120, 1, 0)\r
    Title.Font = Enum.Font.GothamBold\r
    Title.Text = windowTitle\r
    Title.TextColor3 = Theme.Text\r
    Title.TextSize = 18\r
    Title.TextXAlignment = Enum.TextXAlignment.Left\r
    \r
    -- Close Button\r
    local CloseButton = Instance.new("TextButton")\r
    CloseButton.Name = "CloseButton"\r
    CloseButton.Parent = TopBar\r
    CloseButton.BackgroundColor3 = Theme.Error\r
    CloseButton.BorderSizePixel = 0\r
    CloseButton.Position = UDim2.new(1, -40, 0, 10)\r
    CloseButton.Size = UDim2.new(0, 30, 0, 30)\r
    CloseButton.Font = Enum.Font.GothamBold\r
    CloseButton.Text = "×"\r
    CloseButton.TextColor3 = Color3.new(1, 1, 1)\r
    CloseButton.TextSize = 20\r
    \r
    AddCorner(CloseButton, 6)\r
    \r
    -- Minimize Button\r
    local MinimizeButton = Instance.new("TextButton")\r
    MinimizeButton.Name = "MinimizeButton"\r
    MinimizeButton.Parent = TopBar\r
    MinimizeButton.BackgroundColor3 = Theme.Warning\r
    MinimizeButton.BorderSizePixel = 0\r
    MinimizeButton.Position = UDim2.new(1, -75, 0, 10)\r
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)\r
    MinimizeButton.Font = Enum.Font.GothamBold\r
    MinimizeButton.Text = "−"\r
    MinimizeButton.TextColor3 = Color3.new(1, 1, 1)\r
    MinimizeButton.TextSize = 20\r
    \r
    AddCorner(MinimizeButton, 6)\r
    \r
    -- Sidebar\r
    local Sidebar = Instance.new("Frame")\r
    Sidebar.Name = "Sidebar"\r
    Sidebar.Parent = MainFrame\r
    Sidebar.BackgroundColor3 = Theme.Sidebar\r
    Sidebar.BorderSizePixel = 0\r
    Sidebar.Position = UDim2.new(0, 0, 0, 50)\r
    Sidebar.Size = UDim2.new(0, 200, 1, -50)\r
    \r
    AddCorner(Sidebar, 12)\r
    AddStroke(Sidebar, Theme.Border, 1)\r
    \r
    -- Sidebar ScrollingFrame\r
    local SidebarScroll = Instance.new("ScrollingFrame")\r
    SidebarScroll.Name = "SidebarScroll"\r
    SidebarScroll.Parent = Sidebar\r
    SidebarScroll.BackgroundTransparency = 1\r
    SidebarScroll.BorderSizePixel = 0\r
    SidebarScroll.Position = UDim2.new(0, 10, 0, 20)\r
    SidebarScroll.Size = UDim2.new(1, -20, 1, -30)\r
    SidebarScroll.ScrollBarThickness = 4\r
    SidebarScroll.ScrollBarImageColor3 = Theme.Primary\r
    SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)\r
    \r
    local SidebarLayout = Instance.new("UIListLayout")\r
    SidebarLayout.Name = "SidebarLayout"\r
    SidebarLayout.Parent = SidebarScroll\r
    SidebarLayout.FillDirection = Enum.FillDirection.Vertical\r
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder\r
    SidebarLayout.Padding = UDim.new(0, 8)\r
    \r
    -- Content Area\r
    local ContentArea = Instance.new("Frame")\r
    ContentArea.Name = "ContentArea"\r
    ContentArea.Parent = MainFrame\r
    ContentArea.BackgroundColor3 = Theme.Content\r
    ContentArea.BorderSizePixel = 0\r
    ContentArea.Position = UDim2.new(0, 210, 0, 60)\r
    ContentArea.Size = UDim2.new(1, -220, 1, -70)\r
    \r
    AddCorner(ContentArea, 12)\r
    AddStroke(ContentArea, Theme.Border, 1)\r
    \r
    -- Content ScrollingFrame\r
    local ContentScroll = Instance.new("ScrollingFrame")\r
    ContentScroll.Name = "ContentScroll"\r
    ContentScroll.Parent = ContentArea\r
    ContentScroll.BackgroundTransparency = 1\r
    ContentScroll.BorderSizePixel = 0\r
    ContentScroll.Position = UDim2.new(0, 15, 0, 15)\r
    ContentScroll.Size = UDim2.new(1, -30, 1, -30)\r
    ContentScroll.ScrollBarThickness = 6\r
    ContentScroll.ScrollBarImageColor3 = Theme.Primary\r
    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)\r
    \r
    local ContentLayout = Instance.new("UIListLayout")\r
    ContentLayout.Name = "ContentLayout"\r
    ContentLayout.Parent = ContentScroll\r
    ContentLayout.FillDirection = Enum.FillDirection.Vertical\r
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder\r
    ContentLayout.Padding = UDim.new(0, 10)\r
    \r
    -- Notification Area\r
    local NotificationArea = Instance.new("Frame")\r
    NotificationArea.Name = "NotificationArea"\r
    NotificationArea.Parent = ScreenGui\r
    NotificationArea.BackgroundTransparency = 1\r
    NotificationArea.Position = UDim2.new(1, -320, 0, 20)\r
    NotificationArea.Size = UDim2.new(0, 300, 1, -40)\r
    \r
    local NotificationLayout = Instance.new("UIListLayout")\r
    NotificationLayout.Name = "NotificationLayout"\r
    NotificationLayout.Parent = NotificationArea\r
    NotificationLayout.FillDirection = Enum.FillDirection.Vertical\r
    NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder\r
    NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Top\r
    NotificationLayout.Padding = UDim.new(0, 10)\r
    \r
    -- Window Functions\r
    local Window = {}\r
    \r
    -- Toggle GUI\r
    function Window:Toggle()\r
        GuiState.IsOpen = not GuiState.IsOpen\r
        \r
        if GuiState.IsOpen then\r
            MainFrame.Visible = true\r
            CreateTween(BlurEffect, {Size = 8}, 0.3):Play()\r
            \r
            MainFrame.Position = UDim2.new(0.5, -400, 0.5, -300)\r
            CreateTween(MainFrame, {\r
                Position = UDim2.new(0.5, -400, 0.5, -250)\r
            }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()\r
        else\r
            CreateTween(BlurEffect, {Size = 0}, 0.3):Play()\r
            \r
            local exitTween = CreateTween(MainFrame, {\r
                Position = UDim2.new(0.5, -400, 0.5, -300)\r
            }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)\r
            \r
            exitTween:Play()\r
            exitTween.Completed:Connect(function()\r
                MainFrame.Visible = false\r
            end)\r
        end\r
    end\r
    \r
    -- Show notification\r
    function Window:Notify(title, description, notifType, duration)\r
        notifType = notifType or "info"\r
        duration = duration or 4\r
        \r
        local typeColors = {\r
            success = Theme.Success,\r
            warning = Theme.Warning,\r
            error = Theme.Error,\r
            info = Theme.Info\r
        }\r
        \r
        local NotificationFrame = Instance.new("Frame")\r
        NotificationFrame.Name = "Notification"\r
        NotificationFrame.Parent = NotificationArea\r
        NotificationFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)\r
        NotificationFrame.BorderSizePixel = 0\r
        NotificationFrame.Size = UDim2.new(1, 0, 0, 80)\r
        NotificationFrame.Position = UDim2.new(1, 50, 0, 0)\r
        \r
        AddCorner(NotificationFrame, 8)\r
        AddStroke(NotificationFrame, typeColors[notifType] or Theme.Info, 2)\r
        \r
        -- Notification Title\r
        local NotifTitle = Instance.new("TextLabel")\r
        NotifTitle.Name = "Title"\r
        NotifTitle.Parent = NotificationFrame\r
        NotifTitle.BackgroundTransparency = 1\r
        NotifTitle.Position = UDim2.new(0, 15, 0, 8)\r
        NotifTitle.Size = UDim2.new(1, -30, 0, 20)\r
        NotifTitle.Font = Enum.Font.GothamBold\r
        NotifTitle.Text = title\r
        NotifTitle.TextColor3 = Theme.Text\r
        NotifTitle.TextSize = 14\r
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left\r
        \r
        -- Notification Description\r
        local NotifDesc = Instance.new("TextLabel")\r
        NotifDesc.Name = "Description"\r
        NotifDesc.Parent = NotificationFrame\r
        NotifDesc.BackgroundTransparency = 1\r
        NotifDesc.Position = UDim2.new(0, 15, 0, 30)\r
        NotifDesc.Size = UDim2.new(1, -30, 0, 40)\r
        NotifDesc.Font = Enum.Font.Gotham\r
        NotifDesc.Text = description\r
        NotifDesc.TextColor3 = Theme.TextDark\r
        NotifDesc.TextSize = 12\r
        NotifDesc.TextXAlignment = Enum.TextXAlignment.Left\r
        NotifDesc.TextYAlignment = Enum.TextYAlignment.Top\r
        NotifDesc.TextWrapped = true\r
        \r
        -- Animate in\r
        CreateTween(NotificationFrame, {\r
            Position = UDim2.new(0, 0, 0, 0)\r
        }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()\r
        \r
        -- Auto remove\r
        task.spawn(function()\r
            task.wait(duration)\r
            \r
            local fadeOut = CreateTween(NotificationFrame, {\r
                Position = UDim2.new(1, 50, 0, 0),\r
                BackgroundTransparency = 1\r
            }, 0.3)\r
            \r
            CreateTween(NotifTitle, {TextTransparency = 1}, 0.3):Play()\r
            CreateTween(NotifDesc, {TextTransparency = 1}, 0.3):Play()\r
            \r
            fadeOut:Play()\r
            fadeOut.Completed:Connect(function()\r
                NotificationFrame:Destroy()\r
            end)\r
        end)\r
    end\r
    \r
    -- Create Tab\r
    function Window:CreateTab(config)\r
        config = config or {}\r
        local tabName = config.Name or "Tab"\r
        local tabIcon = config.Icon or "🔹"\r
        \r
        local Tab = {}\r
        \r
        -- Tab Button\r
        local TabButton = Instance.new("TextButton")\r
        TabButton.Name = tabName .. "Button"\r
        TabButton.Parent = SidebarScroll\r
        TabButton.BackgroundColor3 = Theme.Sidebar\r
        TabButton.BorderSizePixel = 0\r
        TabButton.Size = UDim2.new(1, 0, 0, 40)\r
        TabButton.Font = Enum.Font.GothamMedium\r
        TabButton.Text = tabIcon .. "  " .. tabName\r
        TabButton.TextColor3 = Theme.TextDark\r
        TabButton.TextSize = 14\r
        TabButton.TextXAlignment = Enum.TextXAlignment.Left\r
        \r
        local TabPadding = Instance.new("UIPadding")\r
        TabPadding.Parent = TabButton\r
        TabPadding.PaddingLeft = UDim.new(0, 15)\r
        \r
        AddCorner(TabButton, 8)\r
        AddStroke(TabButton, Theme.Border, 1)\r
        \r
        -- Tab Content\r
        local TabContent = Instance.new("Frame")\r
        TabContent.Name = tabName .. "Content"\r
        TabContent.Parent = ContentScroll\r
        TabContent.BackgroundTransparency = 1\r
        TabContent.Size = UDim2.new(1, 0, 0, 0)\r
        TabContent.Visible = false\r
        \r
        local TabContentLayout = Instance.new("UIListLayout")\r
        TabContentLayout.Name = "TabContentLayout"\r
        TabContentLayout.Parent = TabContent\r
        TabContentLayout.FillDirection = Enum.FillDirection.Vertical\r
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder\r
        TabContentLayout.Padding = UDim.new(0, 8)\r
        \r
        -- Tab Selection Logic\r
        TabButton.MouseButton1Click:Connect(function()\r
            -- Hide all tabs\r
            for _, tab in pairs(GuiState.Tabs) do\r
                tab.Content.Visible = false\r
                CreateTween(tab.Button, {\r
                    BackgroundColor3 = Theme.Sidebar,\r
                    TextColor3 = Theme.TextDark\r
                }, 0.2):Play()\r
            end\r
            \r
            -- Show selected tab\r
            TabContent.Visible = true\r
            GuiState.CurrentTab = Tab\r
            \r
            CreateTween(TabButton, {\r
                BackgroundColor3 = Theme.Primary,\r
                TextColor3 = Theme.Text\r
            }, 0.2):Play()\r
        end)\r
        \r
        -- Hover Effects\r
        TabButton.MouseEnter:Connect(function()\r
            if GuiState.CurrentTab ~= Tab then\r
                CreateTween(TabButton, {\r
                    BackgroundColor3 = Theme.Hover\r
                }, 0.15):Play()\r
            end\r
        end)\r
        \r
        TabButton.MouseLeave:Connect(function()\r
            if GuiState.CurrentTab ~= Tab then\r
                CreateTween(TabButton, {\r
                    BackgroundColor3 = Theme.Sidebar\r
                }, 0.15):Play()\r
            end\r
        end)\r
        \r
        Tab.Button = TabButton\r
        Tab.Content = TabContent\r
        Tab.Layout = TabContentLayout\r
        table.insert(GuiState.Tabs, Tab)\r
        \r
        -- Auto-select first tab\r
        if #GuiState.Tabs == 1 then\r
            TabContent.Visible = true\r
            GuiState.CurrentTab = Tab\r
            CreateTween(TabButton, {\r
                BackgroundColor3 = Theme.Primary,\r
                TextColor3 = Theme.Text\r
            }, 0.2):Play()\r
        end\r
        \r
        -- Update canvas size\r
        local function updateCanvasSize()\r
            SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y + 20)\r
            ContentScroll.CanvasSize = UDim2.new(0, 0, 0, TabContentLayout.AbsoluteContentSize.Y + 30)\r
        end\r
        \r
        SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)\r
        TabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)\r
        \r
        -- Tab Elements\r
        function Tab:AddSection(title)\r
            local Section = Instance.new("Frame")\r
            Section.Name = "Section"\r
            Section.Parent = TabContent\r
            Section.BackgroundTransparency = 1\r
            Section.Size = UDim2.new(1, 0, 0, 30)\r
            \r
            local SectionTitle = Instance.new("TextLabel")\r
            SectionTitle.Name = "SectionTitle"\r
            SectionTitle.Parent = Section\r
            SectionTitle.BackgroundTransparency = 1\r
            SectionTitle.Size = UDim2.new(1, 0, 1, 0)\r
            SectionTitle.Font = Enum.Font.GothamBold\r
            SectionTitle.Text = title\r
            SectionTitle.TextColor3 = Theme.Text\r
            SectionTitle.TextSize = 16\r
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left\r
            \r
            return Section\r
        end\r
        \r
        function Tab:AddSeparator()\r
            local Separator = Instance.new("Frame")\r
            Separator.Name = "Separator"\r
            Separator.Parent = TabContent\r
            Separator.BackgroundColor3 = Theme.Border\r
            Separator.BorderSizePixel = 0\r
            Separator.Size = UDim2.new(1, 0, 0, 2)\r
            \r
            AddCorner(Separator, 1)\r
            \r
            return Separator\r
        end\r
        \r
        function Tab:AddButton(config)\r
            config = config or {}\r
            local buttonText = config.Text or "Button"\r
            local buttonDesc = config.Description or ""\r
            local callback = config.Callback or function() end\r
            \r
            local ButtonFrame = Instance.new("Frame")\r
            ButtonFrame.Name = "ButtonFrame"\r
            ButtonFrame.Parent = TabContent\r
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)\r
            ButtonFrame.BorderSizePixel = 0\r
            ButtonFrame.Size = UDim2.new(1, 0, 0, 45)\r
            \r
            AddCorner(ButtonFrame, 8)\r
            AddStroke(ButtonFrame, Theme.Border, 1)\r
            \r
            local Button = Instance.new("TextButton")\r
            Button.Name = "Button"\r
            Button.Parent = ButtonFrame\r
            Button.BackgroundColor3 = Theme.Primary\r
            Button.BorderSizePixel = 0\r
            Button.Position = UDim2.new(1, -100, 0, 8)\r
            Button.Size = UDim2.new(0, 90, 0, 30)\r
            Button.Font = Enum.Font.GothamMedium\r
            Button.Text = "Execute"\r
            Button.TextColor3 = Theme.Text\r
            Button.TextSize = 12\r
            \r
            AddCorner(Button, 6)\r
            \r
            local ButtonLabel = Instance.new("TextLabel")\r
            ButtonLabel.Name = "ButtonLabel"\r
            ButtonLabel.Parent = ButtonFrame\r
            ButtonLabel.BackgroundTransparency = 1\r
            ButtonLabel.Position = UDim2.new(0, 15, 0, 5)\r
            ButtonLabel.Size = UDim2.new(1, -120, 0, 20)\r
            ButtonLabel.Font = Enum.Font.GothamMedium\r
            ButtonLabel.Text = buttonText\r
            ButtonLabel.TextColor3 = Theme.Text\r
            ButtonLabel.TextSize = 14\r
            ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left\r
            \r
            local ButtonDesc = Instance.new("TextLabel")\r
            ButtonDesc.Name = "ButtonDesc"\r
            ButtonDesc.Parent = ButtonFrame\r
            ButtonDesc.BackgroundTransparency = 1\r
            ButtonDesc.Position = UDim2.new(0, 15, 0, 22)\r
            ButtonDesc.Size = UDim2.new(1, -120, 0, 18)\r
            ButtonDesc.Font = Enum.Font.Gotham\r
            ButtonDesc.Text = buttonDesc\r
            ButtonDesc.TextColor3 = Theme.TextMuted\r
            ButtonDesc.TextSize = 11\r
            ButtonDesc.TextXAlignment = Enum.TextXAlignment.Left\r
            \r
            -- Button functionality\r
            Button.MouseButton1Click:Connect(function()\r
                CreateTween(Button, {BackgroundColor3 = Theme.Secondary}, 0.1):Play()\r
                task.wait(0.1)\r
                CreateTween(Button, {BackgroundColor3 = Theme.Primary}, 0.1):Play()\r
                \r
                callback()\r
            end)\r
            \r
            -- Hover effects\r
            Button.MouseEnter:Connect(function()\r
                CreateTween(Button, {BackgroundColor3 = Theme.Secondary}, 0.15):Play()\r
            end)\r
            \r
            Button.MouseLeave:Connect(function()\r
                CreateTween(Button, {BackgroundColor3 = Theme.Primary}, 0.15):Play()\r
            end)\r
            \r
            return ButtonFrame\r
        end\r
        \r
        function Tab:AddToggle(config)\r
            config = config or {}\r
            local toggleText = config.Text or "Toggle"\r
            local toggleDesc = config.Description or ""\r
            local default = config.Default or false\r
            local callback = config.Callback or function() end\r
            \r
            local ToggleFrame = Instance.new("Frame")\r
            ToggleFrame.Name = "ToggleFrame"\r
            ToggleFrame.Parent = TabContent\r
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)\r
            ToggleFrame.BorderSizePixel = 0\r
            ToggleFrame.Size = UDim2.new(1, 0, 0, 45)\r
            \r
            AddCorner(ToggleFrame, 8)\r
            AddStroke(ToggleFrame, Theme.Border, 1)\r
            \r
            local ToggleButton = Instance.new("TextButton")\r
            ToggleButton.Name = "ToggleButton"\r
            ToggleButton.Parent = ToggleFrame\r
            ToggleButton.BackgroundColor3 = default and Theme.Primary or Color3.fromRGB(50, 50, 50)\r
            ToggleButton.BorderSizePixel = 0\r
            ToggleButton.Position = UDim2.new(1, -60, 0, 12)\r
            ToggleButton.Size = UDim2.new(0, 45, 0, 22)\r
            ToggleButton.Text = ""\r
            \r
            AddCorner(ToggleButton, 11)\r
            \r
            local ToggleKnob = Instance.new("Frame")\r
            ToggleKnob.Name = "ToggleKnob"\r
            ToggleKnob.Parent = ToggleButton\r
            ToggleKnob.BackgroundColor3 = Color3.new(1, 1, 1)\r
            ToggleKnob.BorderSizePixel = 0\r
            ToggleKnob.Position = default and UDim2.new(0, 25, 0, 2) or UDim2.new(0, 2, 0, 2)\r
            ToggleKnob.Size = UDim2.new(0, 18, 0, 18)\r
            \r
            AddCorner(ToggleKnob, 9)\r
            \r
            local ToggleLabel = Instance.new("TextLabel")\r
            ToggleLabel.Name = "ToggleLabel"\r
            ToggleLabel.Parent = ToggleFrame\r
            ToggleLabel.BackgroundTransparency = 1\r
            ToggleLabel.Position = UDim2.new(0, 15, 0, 5)\r
            ToggleLabel.Size = UDim2.new(1, -80, 0, 20)\r
            ToggleLabel.Font = Enum.Font.GothamMedium\r
            ToggleLabel.Text = toggleText\r
            ToggleLabel.TextColor3 = Theme.Text\r
            ToggleLabel.TextSize = 14\r
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left\r
            \r
            local ToggleDesc = Instance.new("TextLabel")\r
            ToggleDesc.Name = "ToggleDesc"\r
            ToggleDesc.Parent = ToggleFrame\r
            ToggleDesc.BackgroundTransparency = 1\r
            ToggleDesc.Position = UDim2.new(0, 15, 0, 22)\r
            ToggleDesc.Size = UDim2.new(1, -80, 0, 18)\r
            ToggleDesc.Font = Enum.Font.Gotham\r
            ToggleDesc.Text = toggleDesc\r
            ToggleDesc.TextColor3 = Theme.TextMuted\r
            ToggleDesc.TextSize = 11\r
            ToggleDesc.TextXAlignment = Enum.TextXAlignment.Left\r
            \r
            local isToggled = default\r
            \r
            -- Toggle functionality\r
            ToggleButton.MouseButton1Click:Connect(function()\r
                isToggled = not isToggled\r
                \r
                CreateTween(ToggleButton, {\r
                    BackgroundColor3 = isToggled and Theme.Primary or Color3.fromRGB(50, 50, 50)\r
                }, 0.2):Play()\r
                \r
                CreateTween(ToggleKnob, {\r
                    Position = isToggled and UDim2.new(0, 25, 0, 2) or UDim2.new(0, 2, 0, 2)\r
                }, 0.2):Play()\r
                \r
                callback(isToggled)\r
            end)\r
            \r
            return ToggleFrame, function() return isToggled end\r
        end\r
        \r
        function Tab:AddSlider(config)\r
            config = config or {}\r
            local sliderText = config.Text or "Slider"\r
            local sliderDesc = config.Description or ""\r
            local min = config.Min or 0\r
            local max = config.Max or 100\r
            local default = config.Default or min\r
            local callback = config.Callback or function() end\r
            \r
            local SliderFrame = Instance.new("Frame")\r
            SliderFrame.Name = "SliderFrame"\r
            SliderFrame.Parent = TabContent\r
            SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)\r
            SliderFrame.BorderSizePixel = 0\r
            SliderFrame.Size = UDim2.new(1, 0, 0, 60)\r
            \r
            AddCorner(SliderFrame, 8)\r
            AddStroke(SliderFrame, Theme.Border, 1)\r
            \r
            local SliderLabel = Instance.new("TextLabel")\r
            SliderLabel.Name = "SliderLabel"\r
            SliderLabel.Parent = SliderFrame\r
            SliderLabel.BackgroundTransparency = 1\r
            SliderLabel.Position = UDim2.new(0, 15, 0, 5)\r
            SliderLabel.Size = UDim2.new(1, -80, 0, 18)\r
            SliderLabel.Font = Enum.Font.GothamMedium\r
            SliderLabel.Text = sliderText .. ": " .. default\r
            SliderLabel.TextColor3 = Theme.Text\r
            SliderLabel.TextSize = 14\r
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left\r
            \r
            local SliderDesc = Instance.new("TextLabel")\r
            SliderDesc.Name = "SliderDesc"\r
            SliderDesc.Parent = SliderFrame\r
            SliderDesc.BackgroundTransparency = 1\r
            SliderDesc.Position = UDim2.new(0, 15, 0, 20)\r
            SliderDesc.Size = UDim2.new(1, -30, 0, 15)\r
            SliderDesc.Font = Enum.Font.Gotham\r
            SliderDesc.Text = sliderDesc\r
            SliderDesc.TextColor3 = Theme.TextMuted\r
            SliderDesc.TextSize = 11\r
            SliderDesc.TextXAlignment = Enum.TextXAlignment.Left\r
            \r
            local SliderTrack = Instance.new("Frame")\r
            SliderTrack.Name = "SliderTrack"\r
            SliderTrack.Parent = SliderFrame\r
            SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)\r
            SliderTrack.BorderSizePixel = 0\r
            SliderTrack.Position = UDim2.new(0, 15, 0, 38)\r
            SliderTrack.Size = UDim2.new(1, -30, 0, 6)\r
            \r
            AddCorner(SliderTrack, 3)\r
            \r
            local SliderFill = Instance.new("Frame")\r
            SliderFill.Name = "SliderFill"\r
            SliderFill.Parent = SliderTrack\r
            SliderFill.BackgroundColor3 = Theme.Primary\r
            SliderFill.BorderSizePixel = 0\r
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)\r
            \r
            AddCorner(SliderFill, 3)\r
            \r
            local SliderKnob = Instance.new("Frame")\r
            SliderKnob.Name = "SliderKnob"\r
            SliderKnob.Parent = SliderTrack\r
            SliderKnob.BackgroundColor3 = Color3.new(1, 1, 1)\r
            SliderKnob.BorderSizePixel = 0\r
            SliderKnob.Position = UDim2.new((default - min) / (max - min), -8, 0, -4)\r
            SliderKnob.Size = UDim2.new(0, 16, 0, 14)\r
            \r
            AddCorner(SliderKnob, 7)\r
            \r
            local currentValue = default\r
            local dragging = false\r
            \r
            local function updateSlider(value)\r
                currentValue = math.clamp(value, min, max)\r
                local percentage = (currentValue - min) / (max - min)\r
                \r
                SliderFill.Size = UDim2.new(percentage, 0, 1, 0)\r
                SliderKnob.Position = UDim2.new(percentage, -8, 0, -4)\r
                SliderLabel.Text = sliderText .. ": " .. math.floor(currentValue)\r
                \r
                callback(math.floor(currentValue))\r
            end\r
            \r
            SliderKnob.InputBegan:Connect(function(input)\r
                if input.UserInputType == Enum.UserInputType.MouseButton1 then\r
                    dragging = true\r
                end\r
            end)\r
            \r
            UserInputService.InputChanged:Connect(function(input)\r
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then\r
                    local mousePos = UserInputService:GetMouseLocation().X\r
                    local trackPos = SliderTrack.AbsolutePosition.X\r
                    local trackSize = SliderTrack.AbsoluteSize.X\r
                    \r
                    local percentage = math.clamp((mousePos - trackPos) / trackSize, 0, 1)\r
                    local value = min + (percentage * (max - min))\r
                    \r
                    updateSlider(value)\r
                end\r
            end)\r
            \r
            UserInputService.InputEnded:Connect(function(input)\r
                if input.UserInputType == Enum.UserInputType.MouseButton1 then\r
                    dragging = false\r
                end\r
            end)\r
            \r
            return SliderFrame, function() return currentValue end\r
        end\r
        \r
        function Tab:AddTextbox(config)\r
            config = config or {}\r
            local textboxText = config.Text or "Textbox"\r
            local textboxDesc = config.Description or ""\r
            local placeholder = config.Placeholder or "Enter text..."\r
            local callback = config.Callback or function() end\r
            \r
            local TextboxFrame = Instance.new("Frame")\r
            TextboxFrame.Name = "TextboxFrame"\r
            TextboxFrame.Parent = TabContent\r
            TextboxFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)\r
            TextboxFrame.BorderSizePixel = 0\r
            TextboxFrame.Size = UDim2.new(1, 0, 0, 60)\r
            \r
            AddCorner(TextboxFrame, 8)\r
            AddStroke(TextboxFrame, Theme.Border, 1)\r
            \r
            local TextboxLabel = Instance.new("TextLabel")\r
            TextboxLabel.Name = "TextboxLabel"\r
            TextboxLabel.Parent = TextboxFrame\r
            TextboxLabel.BackgroundTransparency = 1\r
            TextboxLabel.Position = UDim2.new(0, 15, 0, 5)\r
            TextboxLabel.Size = UDim2.new(1, -30, 0, 18)\r
            TextboxLabel.Font = Enum.Font.GothamMedium\r
            TextboxLabel.Text = textboxText\r
            TextboxLabel.TextColor3 = Theme.Text\r
            TextboxLabel.TextSize = 14\r
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left\r
            \r
            local TextboxDesc = Instance.new("TextLabel")\r
            TextboxDesc.Name = "TextboxDesc"\r
            TextboxDesc.Parent = TextboxFrame\r
            TextboxDesc.BackgroundTransparency = 1\r
            TextboxDesc.Position = UDim2.new(0, 15, 0, 20)\r
            TextboxDesc.Size = UDim2.new(1, -30, 0, 15)\r
            TextboxDesc.Font = Enum.Font.Gotham\r
            TextboxDesc.Text = textboxDesc\r
            TextboxDesc.TextColor3 = Theme.TextMuted\r
            TextboxDesc.TextSize = 11\r
            TextboxDesc.TextXAlignment = Enum.TextXAlignment.Left\r
            \r
            local Textbox = Instance.new("TextBox")\r
            Textbox.Name = "Textbox"\r
            Textbox.Parent = TextboxFrame\r
            Textbox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)\r
            Textbox.BorderSizePixel = 0\r
            Textbox.Position = UDim2.new(0, 15, 0, 36)\r
            Textbox.Size = UDim2.new(1, -30, 0, 20)\r
            Textbox.Font = Enum.Font.Gotham\r
            Textbox.PlaceholderText = placeholder\r
            Textbox.PlaceholderColor3 = Theme.TextMuted\r
            Textbox.Text = ""\r
            Textbox.TextColor3 = Theme.Text\r
            Textbox.TextSize = 12\r
            Textbox.TextXAlignment = Enum.TextXAlignment.Left\r
            \r
            AddCorner(Textbox, 4)\r
            AddStroke(Textbox, Theme.Border, 1)\r
            \r
            -- Textbox functionality\r
            Textbox.FocusLost:Connect(function(enterPressed)\r
                if enterPressed then\r
                    callback(Textbox.Text)\r
                end\r
            end)\r
            \r
            return TextboxFrame, function() return Textbox.Text end\r
        end\r
        \r
        function Tab:AddKeybind(config)\r
            config = config or {}\r
            local keybindText = config.Text or "Keybind"\r
            local keybindDesc = config.Description or ""\r
            local defaultKey = config.Default or Enum.KeyCode.F\r
            local callback = config.Callback or function() end\r
            \r
            local KeybindFrame = Instance.new("Frame")\r
            KeybindFrame.Name = "KeybindFrame"\r
            KeybindFrame.Parent = TabContent\r
            KeybindFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)\r
            KeybindFrame.BorderSizePixel = 0\r
            KeybindFrame.Size = UDim2.new(1, 0, 0, 45)\r
            \r
            AddCorner(KeybindFrame, 8)\r
            AddStroke(KeybindFrame, Theme.Border, 1)\r
            \r
            local KeybindLabel = Instance.new("TextLabel")\r
            KeybindLabel.Name = "KeybindLabel"\r
            KeybindLabel.Parent = KeybindFrame\r
            KeybindLabel.BackgroundTransparency = 1\r
            KeybindLabel.Position = UDim2.new(0, 15, 0, 5)\r
            KeybindLabel.Size = UDim2.new(1, -120, 0, 20)\r
            KeybindLabel.Font = Enum.Font.GothamMedium\r
            KeybindLabel.Text = keybindText\r
            KeybindLabel.TextColor3 = Theme.Text\r
            KeybindLabel.TextSize = 14\r
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left\r
            \r
            local KeybindDesc = Instance.new("TextLabel")\r
            KeybindDesc.Name = "KeybindDesc"\r
            KeybindDesc.Parent = KeybindFrame\r
            KeybindDesc.BackgroundTransparency = 1\r
            KeybindDesc.Position = UDim2.new(0, 15, 0, 22)\r
            KeybindDesc.Size = UDim2.new(1, -120, 0, 18)\r
            KeybindDesc.Font = Enum.Font.Gotham\r
            KeybindDesc.Text = keybindDesc\r
            KeybindDesc.TextColor3 = Theme.TextMuted\r
            KeybindDesc.TextSize = 11\r
            KeybindDesc.TextXAlignment = Enum.TextXAlignment.Left\r
            \r
            local KeybindButton = Instance.new("TextButton")\r
            KeybindButton.Name = "KeybindButton"\r
            KeybindButton.Parent = KeybindFrame\r
            KeybindButton.BackgroundColor3 = Theme.Primary\r
            KeybindButton.BorderSizePixel = 0\r
            KeybindButton.Position = UDim2.new(1, -100, 0, 8)\r
            KeybindButton.Size = UDim2.new(0, 90, 0, 30)\r
            KeybindButton.Font = Enum.Font.GothamMedium\r
            KeybindButton.Text = defaultKey.Name\r
            KeybindButton.TextColor3 = Theme.Text\r
            KeybindButton.TextSize = 12\r
            \r
            AddCorner(KeybindButton, 6)\r
            \r
            local currentKey = defaultKey\r
            local listening = false\r
            \r
            -- Set up initial keybind\r
            UserInputService.InputBegan:Connect(function(input, gameProcessed)\r
                if gameProcessed then return end\r
                if input.KeyCode == currentKey then\r
                    callback()\r
                end\r
            end)\r
            \r
            -- Keybind button functionality\r
            KeybindButton.MouseButton1Click:Connect(function()\r
                if listening then return end\r
                \r
                listening = true\r
                KeybindButton.Text = "..."\r
                KeybindButton.BackgroundColor3 = Theme.Warning\r
                \r
                local connection\r
                connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)\r
                    if gameProcessed then return end\r
                    \r
                    if input.KeyCode ~= Enum.KeyCode.Unknown then\r
                        currentKey = input.KeyCode\r
                        KeybindButton.Text = currentKey.Name\r
                        KeybindButton.BackgroundColor3 = Theme.Primary\r
                        listening = false\r
                        connection:Disconnect()\r
                        \r
                        -- Set up new keybind\r
                        UserInputService.InputBegan:Connect(function(newInput, newGameProcessed)\r
                            if newGameProcessed then return end\r
                            if newInput.KeyCode == currentKey then\r
                                callback()\r
                            end\r
                        end)\r
                    end\r
                end)\r
            end)\r
            \r
            return KeybindFrame, function() return currentKey end\r
        end\r
        \r
        return Tab\r
    end\r
    \r
    -- Button Event Handlers\r
    CloseButton.MouseButton1Click:Connect(function()\r
        CreateTween(CloseButton, {BackgroundColor3 = Theme.Secondary}, 0.1):Play()\r
        task.wait(0.1)\r
        \r
        ScreenGui:Destroy()\r
        if BlurEffect then\r
            BlurEffect:Destroy()\r
        end\r
    end)\r
    \r
    MinimizeButton.MouseButton1Click:Connect(function()\r
        CreateTween(MinimizeButton, {BackgroundColor3 = Color3.fromRGB(255, 200, 0)}, 0.1):Play()\r
        task.wait(0.1)\r
        CreateTween(MinimizeButton, {BackgroundColor3 = Theme.Warning}, 0.1):Play()\r
        \r
        Window:Toggle()\r
    end)\r
    \r
    -- Close button hover\r
    CloseButton.MouseEnter:Connect(function()\r
        CreateTween(CloseButton, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}, 0.15):Play()\r
    end)\r
    \r
    CloseButton.MouseLeave:Connect(function()\r
        CreateTween(CloseButton, {BackgroundColor3 = Theme.Error}, 0.15):Play()\r
    end)\r
    \r
    -- Minimize button hover\r
    MinimizeButton.MouseEnter:Connect(function()\r
        CreateTween(MinimizeButton, {BackgroundColor3 = Color3.fromRGB(255, 200, 0)}, 0.15):Play()\r
    end)\r
    \r
    MinimizeButton.MouseLeave:Connect(function()\r
        CreateTween(MinimizeButton, {BackgroundColor3 = Theme.Warning}, 0.15):Play()\r
    end)\r
    \r
    -- Dragging functionality\r
    local dragging = false\r
    local dragStart = nil\r
    local startPos = nil\r
    \r
    TopBar.InputBegan:Connect(function(input)\r
        if input.UserInputType == Enum.UserInputType.MouseButton1 then\r
            dragging = true\r
            dragStart = input.Position\r
            startPos = MainFrame.Position\r
        end\r
    end)\r
    \r
    TopBar.InputChanged:Connect(function(input)\r
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then\r
            local delta = input.Position - dragStart\r
            MainFrame.Position = UDim2.new(\r
                startPos.X.Scale,\r
                startPos.X.Offset + delta.X,\r
                startPos.Y.Scale,\r
                startPos.Y.Offset + delta.Y\r
            )\r
        end\r
    end)\r
    \r
    TopBar.InputEnded:Connect(function(input)\r
        if input.UserInputType == Enum.UserInputType.MouseButton1 then\r
            dragging = false\r
        end\r
    end)\r
    \r
    -- Toggle keybind (Right Shift)\r
    UserInputService.InputBegan:Connect(function(input, gameProcessed)\r
        if gameProcessed then return end\r
        if input.KeyCode == Enum.KeyCode.RightShift then\r
            Window:Toggle()\r
        end\r
    end)\r
    \r
    -- Initial state\r
    MainFrame.Visible = false\r
    GuiState.IsOpen = false\r
    \r
    -- Show initial notification\r
    task.spawn(function()\r
        task.wait(1)\r
        Window:Notify(\r
            "Hydroxide Hub V2.0", \r
            "Successfully loaded! Press Right Shift to toggle.", \r
            "success", \r
            5\r
        )\r
    end)\r
    \r
    return Window\r
end\r
\r
-- Return Library\r
return Library\r
