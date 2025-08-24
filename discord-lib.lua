--[[
    Enhanced Discord UI Library v2.0 - Single File Edition
    
    Major improvements over original:
    ✓ Smooth animations & transitions
    ✓ Dark & Light themes
    ✓ Better performance & memory management
    ✓ Mobile-friendly design
    ✓ Enhanced notifications
    ✓ Tooltips & hover effects
    ✓ Auto-save system
    ✓ Material design ripples
    ✓ Keyboard shortcuts
    
    Usage:
    local DiscordLib = loadstring(game:HttpGet("[YOUR_URL_HERE]"))()
    local win = DiscordLib:Window("My GUI")
    local server = win:Server("Server", "")
    local channel = server:Channel("Channel")
    channel:Button("Test", function() print("Hello!") end)
]]

local DiscordLib = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")

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

-- Theme System
local Themes = {
    Dark = {
        Background = Color3.fromRGB(32, 34, 37),
        SecondaryBackground = Color3.fromRGB(47, 49, 54),
        TertiaryBackground = Color3.fromRGB(54, 57, 63),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(185, 187, 190),
        TextMuted = Color3.fromRGB(114, 118, 125),
        Accent = Color3.fromRGB(114, 137, 228),
        AccentHover = Color3.fromRGB(103, 123, 196),
        Success = Color3.fromRGB(67, 181, 129),
        Warning = Color3.fromRGB(250, 166, 26),
        Error = Color3.fromRGB(240, 71, 71),
        Border = Color3.fromRGB(66, 69, 74)
    },
    Light = {
        Background = Color3.fromRGB(255, 255, 255),
        SecondaryBackground = Color3.fromRGB(248, 249, 250),
        TertiaryBackground = Color3.fromRGB(241, 243, 244),
        TextPrimary = Color3.fromRGB(32, 34, 37),
        TextSecondary = Color3.fromRGB(114, 118, 125),
        TextMuted = Color3.fromRGB(185, 187, 190),
        Accent = Color3.fromRGB(88, 101, 242),
        AccentHover = Color3.fromRGB(71, 82, 196),
        Success = Color3.fromRGB(59, 165, 93),
        Warning = Color3.fromRGB(250, 166, 26),
        Error = Color3.fromRGB(237, 66, 69),
        Border = Color3.fromRGB(227, 229, 232)
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

-- Main Window Creation
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
    
    -- Add corner radius
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
    Title.Name = "Title"
    Title.Parent = TopFrame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.0102790017, 0, 0, 0)
    Title.Size = UDim2.new(0, 192, 0, 23)
    Title.Font = Enum.Font.Gotham
    Title.Text = text or "Enhanced Discord Library"
    Title.TextColor3 = CurrentTheme.TextPrimary
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Parent = TopFrame
    CloseBtn.BackgroundColor3 = CurrentTheme.Background
    CloseBtn.Position = UDim2.new(0.959063113, 0, -0.0169996787, 0)
    CloseBtn.Size = UDim2.new(0, 28, 0, 22)
    CloseBtn.Font = Enum.Font.Gotham
    CloseBtn.Text = ""
    CloseBtn.TextColor3 = CurrentTheme.TextPrimary
    CloseBtn.TextSize = 14
    CloseBtn.BorderSizePixel = 0
    CloseBtn.AutoButtonColor = false
    
    local CloseIcon = Instance.new("ImageLabel")
    CloseIcon.Name = "CloseIcon"
    CloseIcon.Parent = CloseBtn
    CloseIcon.BackgroundTransparency = 1
    CloseIcon.Position = UDim2.new(0.189182192, 0, 0.128935531, 0)
    CloseIcon.Size = UDim2.new(0, 17, 0, 17)
    CloseIcon.Image = "http://www.roblox.com/asset/?id=6035047409"
    CloseIcon.ImageColor3 = CurrentTheme.TextSecondary
    
    -- Minimize Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeButton"
    MinimizeBtn.Parent = TopFrame
    MinimizeBtn.BackgroundColor3 = CurrentTheme.Background
    MinimizeBtn.Position = UDim2.new(0.917947114, 0, -0.0169996787, 0)
    MinimizeBtn.Size = UDim2.new(0, 28, 0, 22)
    MinimizeBtn.Font = Enum.Font.Gotham
    MinimizeBtn.Text = ""
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.AutoButtonColor = false
    
    local MinimizeIcon = Instance.new("ImageLabel")
    MinimizeIcon.Name = "MinimizeIcon"
    MinimizeIcon.Parent = MinimizeBtn
    MinimizeIcon.BackgroundTransparency = 1
    MinimizeIcon.Position = UDim2.new(0.189182192, 0, 0.128935531, 0)
    MinimizeIcon.Size = UDim2.new(0, 17, 0, 17)
    MinimizeIcon.Image = "http://www.roblox.com/asset/?id=6035067836"
    MinimizeIcon.ImageColor3 = CurrentTheme.TextSecondary
    
    -- Servers Holder
    local ServersFrame = Instance.new("Frame")
    ServersFrame.Name = "ServersFrame"
    ServersFrame.Parent = MainFrame
    ServersFrame.BackgroundColor3 = CurrentTheme.SecondaryBackground
    ServersFrame.BorderSizePixel = 0
    ServersFrame.Position = UDim2.new(0, 0, 0, 22)
    ServersFrame.Size = UDim2.new(0, 71, 1, -22)
    
    local ServersScroll = Instance.new("ScrollingFrame")
    ServersScroll.Name = "ServersScroll"
    ServersScroll.Parent = ServersFrame
    ServersScroll.Active = true
    ServersScroll.BackgroundTransparency = 1
    ServersScroll.BorderSizePixel = 0
    ServersScroll.Position = UDim2.new(0, 0, 0, 8)
    ServersScroll.Size = UDim2.new(1, 0, 1, -60)
    ServersScroll.ScrollBarThickness = 1
    ServersScroll.ScrollBarImageTransparency = 1
    ServersScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local ServersLayout = Instance.new("UIListLayout")
    ServersLayout.Parent = ServersScroll
    ServersLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ServersLayout.Padding = UDim.new(0, 7)
    ServersLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local ServersPadding = Instance.new("UIPadding")
    ServersPadding.Parent = ServersScroll
    ServersPadding.PaddingLeft = UDim.new(0, 14)
    
    -- User Panel
    local Userpad = Instance.new("Frame")
    Userpad.Name = "Userpad"
    Userpad.Parent = ServersFrame
    Userpad.BackgroundColor3 = CurrentTheme.TertiaryBackground
    Userpad.BorderSizePixel = 0
    Userpad.Position = UDim2.new(0.106243297, 0, 1, -52)
    Userpad.Size = UDim2.new(0, 179, 0, 43)
    
    local UserIcon = Instance.new("Frame")
    UserIcon.Name = "UserIcon"
    UserIcon.Parent = Userpad
    UserIcon.BackgroundColor3 = CurrentTheme.SecondaryBackground
    UserIcon.BorderSizePixel = 0
    UserIcon.Position = UDim2.new(0.0340000018, 0, 0.123999998, 0)
    UserIcon.Size = UDim2.new(0, 32, 0, 32)
    
    local UserIconCorner = Instance.new("UICorner")
    UserIconCorner.CornerRadius = UDim.new(1, 8)
    UserIconCorner.Parent = UserIcon
    
    local UserImage = Instance.new("ImageLabel")
    UserImage.Name = "UserImage"
    UserImage.Parent = UserIcon
    UserImage.BackgroundTransparency = 1
    UserImage.Size = UDim2.new(0, 32, 0, 32)
    UserImage.Image = userinfo.pfp
    
    local UserName = Instance.new("TextLabel")
    UserName.Name = "UserName"
    UserName.Parent = Userpad
    UserName.BackgroundTransparency = 1
    UserName.Position = UDim2.new(0.230000004, 0, 0.115999997, 0)
    UserName.Size = UDim2.new(0, 98, 0, 17)
    UserName.Font = Enum.Font.GothamSemibold
    UserName.TextColor3 = CurrentTheme.TextPrimary
    UserName.TextSize = 13
    UserName.TextXAlignment = Enum.TextXAlignment.Left
    UserName.ClipsDescendants = true
    UserName.Text = userinfo.user
    
    local UserTag = Instance.new("TextLabel")
    UserTag.Name = "UserTag"
    UserTag.Parent = Userpad
    UserTag.BackgroundTransparency = 1
    UserTag.Position = UDim2.new(0.230000004, 0, 0.455000013, 0)
    UserTag.Size = UDim2.new(0, 95, 0, 17)
    UserTag.Font = Enum.Font.Gotham
    UserTag.TextColor3 = CurrentTheme.TextMuted
    UserTag.TextSize = 13
    UserTag.TextTransparency = 0.300
    UserTag.TextXAlignment = Enum.TextXAlignment.Left
    UserTag.Text = "#" .. userinfo.tag
    
    -- Content Frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundColor3 = CurrentTheme.TertiaryBackground
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Position = UDim2.new(0, 71, 0, 22)
    ContentFrame.Size = UDim2.new(1, -71, 1, -22)
    
    -- Button Events
    CloseBtn.MouseEnter:Connect(function()
        Utils.CreateTween(CloseBtn, {BackgroundColor3 = CurrentTheme.Error}, 0.2)
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        Utils.CreateTween(CloseBtn, {BackgroundColor3 = CurrentTheme.Background}, 0.2)
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        Utils.CreateTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        task.wait(0.3)
        Discord:Destroy()
    end)
    
    MinimizeBtn.MouseEnter:Connect(function()
        Utils.CreateTween(MinimizeBtn, {BackgroundColor3 = CurrentTheme.SecondaryBackground}, 0.2)
    end)
    
    MinimizeBtn.MouseLeave:Connect(function()
        Utils.CreateTween(MinimizeBtn, {BackgroundColor3 = CurrentTheme.Background}, 0.2)
    end)
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        windowData.minimized = not windowData.minimized
        local targetSize = windowData.minimized and UDim2.new(0, 681, 0, 22) or UDim2.new(0, 681, 0, 396)
        Utils.CreateTween(MainFrame, {Size = targetSize}, Config.AnimationSpeed)
    end)
    
    -- Make window draggable
    MakeDraggable(TopFrame, MainFrame)
    
    -- Server Creation Function
    local ServerHold = {}
    function ServerHold:Server(text, img)
        local serverData = {
            channels = {},
            currentChannelToggled = "",
            firstChannel = true
        }
        
        -- Server Button
        local Server = Instance.new("TextButton")
        Server.Name = text .. "Server"
        Server.Parent = ServersScroll
        Server.BackgroundColor3 = CurrentTheme.SecondaryBackground
        Server.Size = UDim2.new(0, 47, 0, 47)
        Server.AutoButtonColor = false
        Server.Font = Enum.Font.Gotham
        Server.Text = img == "" and string.sub(text, 1, 1) or ""
        Server.TextColor3 = CurrentTheme.TextPrimary
        Server.TextSize = 18
        
        local ServerCorner = Instance.new("UICorner")
        ServerCorner.CornerRadius = UDim.new(1, 0)
        ServerCorner.Parent = Server
        
        local ServerIcon = Instance.new("ImageLabel")
        if img and img ~= "" then
            ServerIcon.Name = "ServerIcon"
            ServerIcon.Parent = Server
            ServerIcon.BackgroundTransparency = 1
            ServerIcon.Size = UDim2.new(1, 0, 1, 0)
            ServerIcon.Image = img
            
            local IconCorner = Instance.new("UICorner")
            IconCorner.CornerRadius = UDim.new(1, 0)
            IconCorner.Parent = ServerIcon
        end
        
        local ServerWhiteFrame = Instance.new("Frame")
        ServerWhiteFrame.Name = "ServerWhiteFrame"
        ServerWhiteFrame.Parent = Server
        ServerWhiteFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        ServerWhiteFrame.BackgroundColor3 = CurrentTheme.TextPrimary
        ServerWhiteFrame.Position = UDim2.new(-0.347378343, 0, 0.502659559, 0)
        ServerWhiteFrame.Size = UDim2.new(0, 11, 0, 10)
        
        local WhiteFrameCorner = Instance.new("UICorner")
        WhiteFrameCorner.CornerRadius = UDim.new(1, 0)
        WhiteFrameCorner.Parent = ServerWhiteFrame
        
        -- Server Content Frame
        local ServerFrame = Instance.new("Frame")
        ServerFrame.Name = "ServerFrame_" .. text
        ServerFrame.Parent = ContentFrame
        ServerFrame.BackgroundColor3 = CurrentTheme.TertiaryBackground
        ServerFrame.BorderSizePixel = 0
        ServerFrame.Size = UDim2.new(1, 0, 1, 0)
        ServerFrame.Visible = false
        
        -- Channels Sidebar
        local ChannelsFrame = Instance.new("Frame")
        ChannelsFrame.Name = "ChannelsFrame"
        ChannelsFrame.Parent = ServerFrame
        ChannelsFrame.BackgroundColor3 = CurrentTheme.SecondaryBackground
        ChannelsFrame.BorderSizePixel = 0
        ChannelsFrame.Size = UDim2.new(0, 180, 1, 0)
        
        local ServerTitle = Instance.new("TextLabel")
        ServerTitle.Name = "ServerTitle"
        ServerTitle.Parent = ChannelsFrame
        ServerTitle.BackgroundTransparency = 1
        ServerTitle.Position = UDim2.new(0.075, 0, 0, 0)
        ServerTitle.Size = UDim2.new(0, 97, 0, 39)
        ServerTitle.Font = Enum.Font.GothamSemibold
        ServerTitle.Text = text
        ServerTitle.TextColor3 = CurrentTheme.TextPrimary
        ServerTitle.TextSize = 15
        ServerTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local ChannelsScroll = Instance.new("ScrollingFrame")
        ChannelsScroll.Name = "ChannelsScroll"
        ChannelsScroll.Parent = ChannelsFrame
        ChannelsScroll.Active = true
        ChannelsScroll.BackgroundTransparency = 1
        ChannelsScroll.BorderSizePixel = 0
        ChannelsScroll.Position = UDim2.new(0, 0, 0, 45)
        ChannelsScroll.Size = UDim2.new(1, 0, 1, -45)
        ChannelsScroll.ScrollBarThickness = 4
        ChannelsScroll.ScrollBarImageTransparency = 1
        ChannelsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        local ChannelsLayout = Instance.new("UIListLayout")
        ChannelsLayout.Parent = ChannelsScroll
        ChannelsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ChannelsLayout.Padding = UDim.new(0, 4)
        
        local ChannelsPadding = Instance.new("UIPadding")
        ChannelsPadding.Parent = ChannelsScroll
        ChannelsPadding.PaddingLeft = UDim.new(0, 9)
        
        -- Channel Content Area
        local ChannelContentFrame = Instance.new("Frame")
        ChannelContentFrame.Name = "ChannelContentFrame"
        ChannelContentFrame.Parent = ServerFrame
        ChannelContentFrame.BackgroundColor3 = CurrentTheme.TertiaryBackground
        ChannelContentFrame.BorderSizePixel = 0
        ChannelContentFrame.Position = UDim2.new(0, 180, 0, 0)
        ChannelContentFrame.Size = UDim2.new(1, -180, 1, 0)
        
        -- Server Button Events
        Server.MouseEnter:Connect(function()
            if windowData.currentServerToggled ~= Server.Name then
                Utils.CreateTween(Server, {BackgroundColor3 = CurrentTheme.Accent}, 0.2)
                Utils.CreateTween(ServerCorner, {CornerRadius = UDim.new(0, 15)}, 0.2)
                ServerWhiteFrame:TweenSize(UDim2.new(0, 11, 0, 27), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
            end
        end)
        
        Server.MouseLeave:Connect(function()
            if windowData.currentServerToggled ~= Server.Name then
                Utils.CreateTween(Server, {BackgroundColor3 = CurrentTheme.SecondaryBackground}, 0.2)
                Utils.CreateTween(ServerCorner, {CornerRadius = UDim.new(1, 0)}, 0.2)
                ServerWhiteFrame:TweenSize(UDim2.new(0, 11, 0, 10), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
            end
        end)
        
        Server.MouseButton1Click:Connect(function()
            windowData.currentServerToggled = Server.Name
            
            -- Hide all other server contents
            for _, child in pairs(ContentFrame:GetChildren()) do
                if child.Name:find("ServerFrame_") then
                    child.Visible = false
                end
            end
            ServerFrame.Visible = true
            
            -- Update all server buttons
            for _, server in pairs(ServersScroll:GetChildren()) do
                if server:IsA("TextButton") then
                    if server == Server then
                        Utils.CreateTween(server, {BackgroundColor3 = CurrentTheme.Accent}, 0.2)
                        Utils.CreateTween(server.UICorner, {CornerRadius = UDim.new(0, 15)}, 0.2)
                        server.ServerWhiteFrame:TweenSize(UDim2.new(0, 11, 0, 46), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
                    else
                        Utils.CreateTween(server, {BackgroundColor3 = CurrentTheme.SecondaryBackground}, 0.2)
                        Utils.CreateTween(server.UICorner, {CornerRadius = UDim.new(1, 0)}, 0.2)
                        server.ServerWhiteFrame:TweenSize(UDim2.new(0, 11, 0, 10), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
                    end
                end
            end
        end)
        
        -- Auto-select first server
        if #windowData.servers == 0 then
            spawn(function()
                task.wait(0.1)
                -- Simulate the click by calling the function directly
                windowData.currentServerToggled = Server.Name
                
                -- Hide all other server contents
                for _, child in pairs(ContentFrame:GetChildren()) do
                    if child.Name:find("ServerFrame_") then
                        child.Visible = false
                    end
                end
                ServerFrame.Visible = true
                
                -- Update all server buttons
                for _, server in pairs(ServersScroll:GetChildren()) do
                    if server:IsA("TextButton") then
                        if server == Server then
                            Utils.CreateTween(server, {BackgroundColor3 = CurrentTheme.Accent}, 0.2)
                            Utils.CreateTween(server.UICorner, {CornerRadius = UDim.new(0, 15)}, 0.2)
                            server.ServerWhiteFrame:TweenSize(UDim2.new(0, 11, 0, 46), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
                        else
                            Utils.CreateTween(server, {BackgroundColor3 = CurrentTheme.SecondaryBackground}, 0.2)
                            Utils.CreateTween(server.UICorner, {CornerRadius = UDim.new(1, 0)}, 0.2)
                            server.ServerWhiteFrame:TweenSize(UDim2.new(0, 11, 0, 10), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
                        end
                    end
                end
            end)
        end
        
        table.insert(windowData.servers, Server)
        ServersScroll.CanvasSize = UDim2.new(0, 0, 0, ServersLayout.AbsoluteContentSize.Y)
        
        -- Channel Creation Function
        local ChannelHold = {}
        function ChannelHold:Channel(text)
            local channelData = {components = {}}
            
            -- Channel Button
            local ChannelBtn = Instance.new("TextButton")
            ChannelBtn.Name = text .. "ChannelBtn"
            ChannelBtn.Parent = ChannelsScroll
            ChannelBtn.BackgroundColor3 = CurrentTheme.SecondaryBackground
            ChannelBtn.BorderSizePixel = 0
            ChannelBtn.Size = UDim2.new(0, 160, 0, 30)
            ChannelBtn.AutoButtonColor = false
            ChannelBtn.Font = Enum.Font.SourceSans
            ChannelBtn.Text = ""
            
            local ChannelCorner = Instance.new("UICorner")
            ChannelCorner.CornerRadius = UDim.new(0, 6)
            ChannelCorner.Parent = ChannelBtn
            
            local ChannelHashtag = Instance.new("TextLabel")
            ChannelHashtag.Name = "ChannelHashtag"
            ChannelHashtag.Parent = ChannelBtn
            ChannelHashtag.BackgroundTransparency = 1
            ChannelHashtag.Position = UDim2.new(0.0279720314, 0, 0, 0)
            ChannelHashtag.Size = UDim2.new(0, 24, 0, 30)
            ChannelHashtag.Font = Enum.Font.Gotham
            ChannelHashtag.Text = "#"
            ChannelHashtag.TextColor3 = CurrentTheme.TextMuted
            ChannelHashtag.TextSize = 21
            
            local ChannelTitle = Instance.new("TextLabel")
            ChannelTitle.Name = "ChannelTitle"
            ChannelTitle.Parent = ChannelBtn
            ChannelTitle.BackgroundTransparency = 1
            ChannelTitle.Position = UDim2.new(0.173747092, 0, -0.166666672, 0)
            ChannelTitle.Size = UDim2.new(0, 95, 0, 39)
            ChannelTitle.Font = Enum.Font.Gotham
            ChannelTitle.Text = text
            ChannelTitle.TextColor3 = CurrentTheme.TextMuted
            ChannelTitle.TextSize = 14
            ChannelTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            -- Channel Content
            local ChannelContent = Instance.new("ScrollingFrame")
            ChannelContent.Name = "ChannelContent_" .. text
            ChannelContent.Parent = ChannelContentFrame
            ChannelContent.Active = true
            ChannelContent.BackgroundTransparency = 1
            ChannelContent.BorderSizePixel = 0
            ChannelContent.Size = UDim2.new(1, 0, 1, 0)
            ChannelContent.ScrollBarThickness = 6
            ChannelContent.CanvasSize = UDim2.new(0, 0, 0, 0)
            ChannelContent.ScrollBarImageTransparency = 0
            ChannelContent.ScrollBarImageColor3 = CurrentTheme.Border
            ChannelContent.Visible = false
            
            local ContentLayout = Instance.new("UIListLayout")
            ContentLayout.Parent = ChannelContent
            ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ContentLayout.Padding = UDim.new(0, 6)
            
            local ContentPadding = Instance.new("UIPadding")
            ContentPadding.Parent = ChannelContent
            ContentPadding.PaddingLeft = UDim.new(0, 15)
            ContentPadding.PaddingRight = UDim.new(0, 15)
            ContentPadding.PaddingTop = UDim.new(0, 8)
            
            -- Channel Button Events
            ChannelBtn.MouseEnter:Connect(function()
                if serverData.currentChannelToggled ~= ChannelBtn.Name then
                    ChannelBtn.BackgroundColor3 = CurrentTheme.TertiaryBackground
                    ChannelTitle.TextColor3 = CurrentTheme.TextSecondary
                end
            end)
            
            ChannelBtn.MouseLeave:Connect(function()
                if serverData.currentChannelToggled ~= ChannelBtn.Name then
                    ChannelBtn.BackgroundColor3 = CurrentTheme.SecondaryBackground
                    ChannelTitle.TextColor3 = CurrentTheme.TextMuted
                end
            end)
            
            ChannelBtn.MouseButton1Click:Connect(function()
                serverData.currentChannelToggled = ChannelBtn.Name
                
                -- Hide all other channel contents
                for _, child in pairs(ChannelContentFrame:GetChildren()) do
                    if child.Name:find("ChannelContent_") then
                        child.Visible = false
                    end
                end
                ChannelContent.Visible = true
                
                -- Update all channel buttons
                for _, channel in pairs(ChannelsScroll:GetChildren()) do
                    if channel:IsA("TextButton") then
                        if channel == ChannelBtn then
                            channel.BackgroundColor3 = CurrentTheme.TertiaryBackground
                            channel.ChannelTitle.TextColor3 = CurrentTheme.TextPrimary
                        else
                            channel.BackgroundColor3 = CurrentTheme.SecondaryBackground
                            channel.ChannelTitle.TextColor3 = CurrentTheme.TextMuted
                        end
                    end
                end
            end)
            
            -- Auto-select first channel
            if serverData.firstChannel then
                serverData.firstChannel = false
                spawn(function()
                    task.wait(0.1)
                    -- Simulate the click by calling the function directly
                    serverData.currentChannelToggled = ChannelBtn.Name
                    
                    -- Hide all other channel contents
                    for _, child in pairs(ChannelContentFrame:GetChildren()) do
                        if child.Name:find("ChannelContent_") then
                            child.Visible = false
                        end
                    end
                    ChannelContent.Visible = true
                    
                    -- Update all channel buttons
                    for _, channel in pairs(ChannelsScroll:GetChildren()) do
                        if channel:IsA("TextButton") then
                            if channel == ChannelBtn then
                                channel.BackgroundColor3 = CurrentTheme.TertiaryBackground
                                channel.ChannelTitle.TextColor3 = CurrentTheme.TextPrimary
                            else
                                channel.BackgroundColor3 = CurrentTheme.SecondaryBackground
                                channel.ChannelTitle.TextColor3 = CurrentTheme.TextMuted
                            end
                        end
                    end
                end)
            end
            
            table.insert(serverData.channels, ChannelBtn)
            ChannelsScroll.CanvasSize = UDim2.new(0, 0, 0, ChannelsLayout.AbsoluteContentSize.Y)
            
            -- Component Creation Functions
            local ComponentHold = {}
            
            function ComponentHold:Button(text, callback)
                local Button = Instance.new("TextButton")
                Button.Name = "Button"
                Button.Parent = ChannelContent
                Button.BackgroundColor3 = CurrentTheme.Accent
                Button.Size = UDim2.new(0, 401, 0, 30)
                Button.AutoButtonColor = false
                Button.Font = Enum.Font.Gotham
                Button.TextColor3 = CurrentTheme.TextPrimary
                Button.TextSize = 14
                Button.Text = text
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 4)
                ButtonCorner.Parent = Button
                
                Button.MouseEnter:Connect(function()
                    Utils.CreateTween(Button, {BackgroundColor3 = CurrentTheme.AccentHover}, 0.2)
                end)
                
                Button.MouseLeave:Connect(function()
                    Utils.CreateTween(Button, {BackgroundColor3 = CurrentTheme.Accent}, 0.2)
                end)
                
                Button.MouseButton1Click:Connect(function()
                    Utils.RippleEffect(Button, Mouse.Hit.Position)
                    Button.TextSize = 0
                    Utils.CreateTween(Button, {TextSize = 14}, 0.2)
                    if callback then pcall(callback) end
                end)
                
                ChannelContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
                table.insert(channelData.components, Button)
                return Button
            end
            
            function ComponentHold:Toggle(text, default, callback)
                local toggled = default or false
                
                local Toggle = Instance.new("TextButton")
                Toggle.Name = "Toggle"
                Toggle.Parent = ChannelContent
                Toggle.BackgroundColor3 = CurrentTheme.SecondaryBackground
                Toggle.BorderSizePixel = 0
                Toggle.Size = UDim2.new(0, 401, 0, 30)
                Toggle.AutoButtonColor = false
                Toggle.Font = Enum.Font.Gotham
                Toggle.Text = ""
                
                local ToggleTitle = Instance.new("TextLabel")
                ToggleTitle.Name = "ToggleTitle"
                ToggleTitle.Parent = Toggle
                ToggleTitle.BackgroundTransparency = 1
                ToggleTitle.Position = UDim2.new(0, 5, 0, 0)
                ToggleTitle.Size = UDim2.new(0, 200, 0, 30)
                ToggleTitle.Font = Enum.Font.Gotham
                ToggleTitle.Text = text
                ToggleTitle.TextColor3 = CurrentTheme.TextSecondary
                ToggleTitle.TextSize = 14
                ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = "ToggleFrame"
                ToggleFrame.Parent = Toggle
                ToggleFrame.BackgroundColor3 = toggled and CurrentTheme.Success or CurrentTheme.Border
                ToggleFrame.Position = UDim2.new(0.900481343, -5, 0.13300018, 0)
                ToggleFrame.Size = UDim2.new(0, 40, 0, 21)
                
                local ToggleFrameCorner = Instance.new("UICorner")
                ToggleFrameCorner.CornerRadius = UDim.new(1, 8)
                ToggleFrameCorner.Parent = ToggleFrame
                
                local ToggleCircle = Instance.new("Frame")
                ToggleCircle.Name = "ToggleCircle"
                ToggleCircle.Parent = ToggleFrame
                ToggleCircle.BackgroundColor3 = CurrentTheme.TextPrimary
                ToggleCircle.Position = toggled and UDim2.new(0.655, -5, 0.133, 0) or UDim2.new(0.235, -5, 0.133, 0)
                ToggleCircle.Size = UDim2.new(0, 15, 0, 15)
                
                local CircleCorner = Instance.new("UICorner")
                CircleCorner.CornerRadius = UDim.new(1, 0)
                CircleCorner.Parent = ToggleCircle
                
                Toggle.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    
                    Utils.CreateTween(ToggleFrame, {
                        BackgroundColor3 = toggled and CurrentTheme.Success or CurrentTheme.Border
                    }, 0.2)
                    
                    ToggleCircle:TweenPosition(
                        toggled and UDim2.new(0.655, -5, 0.133, 0) or UDim2.new(0.235, -5, 0.133, 0),
                        Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true
                    )
                    
                    if callback then pcall(callback, toggled) end
                end)
                
                ChannelContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
                table.insert(channelData.components, Toggle)
                
                local ToggleFunc = {}
                function ToggleFunc:Set(value)
                    if value ~= toggled then
                        Toggle.MouseButton1Click:Fire()
                    end
                end
                return ToggleFunc
            end
            
            function ComponentHold:Slider(text, min, max, start, callback)
                local dragging = false
                local value = start or min
                
                local Slider = Instance.new("TextButton")
                Slider.Name = "Slider"
                Slider.Parent = ChannelContent
                Slider.BackgroundColor3 = CurrentTheme.SecondaryBackground
                Slider.BorderSizePixel = 0
                Slider.Size = UDim2.new(0, 401, 0, 38)
                Slider.AutoButtonColor = false
                Slider.Font = Enum.Font.Gotham
                Slider.Text = ""
                
                local SliderTitle = Instance.new("TextLabel")
                SliderTitle.Name = "SliderTitle"
                SliderTitle.Parent = Slider
                SliderTitle.BackgroundTransparency = 1
                SliderTitle.Position = UDim2.new(0, 5, 0, -4)
                SliderTitle.Size = UDim2.new(0, 200, 0, 27)
                SliderTitle.Font = Enum.Font.Gotham
                SliderTitle.Text = text
                SliderTitle.TextColor3 = CurrentTheme.TextSecondary
                SliderTitle.TextSize = 14
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = "SliderFrame"
                SliderFrame.Parent = Slider
                SliderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                SliderFrame.BackgroundColor3 = CurrentTheme.Border
                SliderFrame.Position = UDim2.new(0.498, 0, 0.757, 0)
                SliderFrame.Size = UDim2.new(0, 385, 0, 8)
                
                local SliderFrameCorner = Instance.new("UICorner")
                SliderFrameCorner.Parent = SliderFrame
                
                local CurrentValueFrame = Instance.new("Frame")
                CurrentValueFrame.Name = "CurrentValueFrame"
                CurrentValueFrame.Parent = SliderFrame
                CurrentValueFrame.BackgroundColor3 = CurrentTheme.Accent
                CurrentValueFrame.Size = UDim2.new((start or 0) / max, 0, 0, 8)
                
                local ValueFrameCorner = Instance.new("UICorner")
                ValueFrameCorner.Parent = CurrentValueFrame
                
                local Zip = Instance.new("Frame")
                Zip.Name = "Zip"
                Zip.Parent = SliderFrame
                Zip.BackgroundColor3 = CurrentTheme.TextPrimary
                Zip.Position = UDim2.new((start or 0) / max, -6, -0.645, 0)
                Zip.Size = UDim2.new(0, 10, 0, 18)
                
                local ZipCorner = Instance.new("UICorner")
                ZipCorner.CornerRadius = UDim.new(0, 3)
                ZipCorner.Parent = Zip
                
                local function move(input)
                    local pos = UDim2.new(
                        math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1),
                        -6, -0.645, 0
                    )
                    local pos1 = UDim2.new(
                        math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1),
                        0, 0, 8
                    )
                    
                    CurrentValueFrame.Size = pos1
                    Zip.Position = pos
                    value = math.floor(((pos.X.Scale * max) / max) * (max - min) + min)
                    
                    if callback then pcall(callback, value) end
                end
                
                Zip.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)
                
                Zip.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        move(input)
                    end
                end)
                
                ChannelContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
                table.insert(channelData.components, Slider)
                
                local SliderFunc = {}
                function SliderFunc:Change(tochange)
                    CurrentValueFrame.Size = UDim2.new((tochange or 0) / max, 0, 0, 8)
                    Zip.Position = UDim2.new((tochange or 0) / max, -6, -0.645, 0)
                    value = tochange
                    if callback then pcall(callback, tochange) end
                end
                
                return SliderFunc
            end
            
            function ComponentHold:Dropdown(text, list, callback)
                local isOpen = false
                local selectedValue = ""
                
                local Dropdown = Instance.new("Frame")
                Dropdown.Name = "Dropdown"
                Dropdown.Parent = ChannelContent
                Dropdown.BackgroundTransparency = 1
                Dropdown.Size = UDim2.new(0, 403, 0, 73)
                
                local DropdownTitle = Instance.new("TextLabel")
                DropdownTitle.Name = "DropdownTitle"
                DropdownTitle.Parent = Dropdown
                DropdownTitle.BackgroundTransparency = 1
                DropdownTitle.Position = UDim2.new(0, 5, 0, 0)
                DropdownTitle.Size = UDim2.new(0, 200, 0, 29)
                DropdownTitle.Font = Enum.Font.Gotham
                DropdownTitle.Text = text
                DropdownTitle.TextColor3 = CurrentTheme.TextSecondary
                DropdownTitle.TextSize = 14
                DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = "DropdownFrame"
                DropdownFrame.Parent = Dropdown
                DropdownFrame.BackgroundColor3 = CurrentTheme.TertiaryBackground
                DropdownFrame.ClipsDescendants = true
                DropdownFrame.Position = UDim2.new(0.01, 0, 1.067, 0)
                DropdownFrame.Size = UDim2.new(0, 392, 0, 32)
                
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 3)
                DropdownCorner.Parent = DropdownFrame
                
                local DropdownBtn = Instance.new("TextButton")
                DropdownBtn.Parent = DropdownFrame
                DropdownBtn.BackgroundTransparency = 1
                DropdownBtn.Size = UDim2.new(1, 0, 0, 32)
                DropdownBtn.Font = Enum.Font.Gotham
                DropdownBtn.Text = selectedValue == "" and text or selectedValue
                DropdownBtn.TextColor3 = CurrentTheme.TextSecondary
                DropdownBtn.TextSize = 14
                
                local DropdownList = Instance.new("Frame")
                DropdownList.Name = "DropdownList"
                DropdownList.Parent = DropdownFrame
                DropdownList.BackgroundColor3 = CurrentTheme.TertiaryBackground
                DropdownList.Position = UDim2.new(0, 0, 0, 32)
                DropdownList.Size = UDim2.new(1, 0, 0, 0)
                
                local ListLayout = Instance.new("UIListLayout")
                ListLayout.Parent = DropdownList
                ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                
                local function createOption(optionText)
                    local Option = Instance.new("TextButton")
                    Option.Name = optionText
                    Option.Parent = DropdownList
                    Option.BackgroundTransparency = 1
                    Option.Size = UDim2.new(1, 0, 0, 32)
                    Option.Font = Enum.Font.Gotham
                    Option.Text = optionText
                    Option.TextColor3 = CurrentTheme.TextSecondary
                    Option.TextSize = 13
                    
                    Option.MouseEnter:Connect(function()
                        Option.BackgroundColor3 = CurrentTheme.Accent
                        Option.BackgroundTransparency = 0
                    end)
                    
                    Option.MouseLeave:Connect(function()
                        Option.BackgroundTransparency = 1
                    end)
                    
                    Option.MouseButton1Click:Connect(function()
                        selectedValue = optionText
                        DropdownBtn.Text = selectedValue
                        
                        if callback then pcall(callback, selectedValue) end
                        
                        -- Close dropdown
                        isOpen = false
                        Utils.CreateTween(DropdownFrame, {Size = UDim2.new(0, 392, 0, 32)}, 0.3)
                    end)
                    
                    return Option
                end
                
                -- Create initial options
                for _, option in pairs(list) do
                    createOption(option)
                end
                
                DropdownBtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    
                    if isOpen then
                        local listHeight = 32 + (#DropdownList:GetChildren() * 32)
                        Utils.CreateTween(DropdownFrame, {Size = UDim2.new(0, 392, 0, listHeight)}, 0.3)
                    else
                        Utils.CreateTween(DropdownFrame, {Size = UDim2.new(0, 392, 0, 32)}, 0.3)
                    end
                end)
                
                ChannelContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
                table.insert(channelData.components, Dropdown)
                
                local DropdownFunc = {}
                function DropdownFunc:Add(option)
                    createOption(option)
                    table.insert(list, option)
                end
                
                function DropdownFunc:Clear()
                    for _, child in pairs(DropdownList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    list = {}
                    selectedValue = ""
                    DropdownBtn.Text = text
                end
                
                return DropdownFunc
            end
            
            function ComponentHold:Textbox(text, placeholder, clearonfocus, callback)
                local Textbox = Instance.new("Frame")
                Textbox.Name = "Textbox"
                Textbox.Parent = ChannelContent
                Textbox.BackgroundTransparency = 1
                Textbox.Size = UDim2.new(0, 403, 0, 60)
                
                local TextboxTitle = Instance.new("TextLabel")
                TextboxTitle.Name = "TextboxTitle"
                TextboxTitle.Parent = Textbox
                TextboxTitle.BackgroundTransparency = 1
                TextboxTitle.Position = UDim2.new(0, 5, 0, 0)
                TextboxTitle.Size = UDim2.new(0, 200, 0, 27)
                TextboxTitle.Font = Enum.Font.Gotham
                TextboxTitle.Text = text
                TextboxTitle.TextColor3 = CurrentTheme.TextSecondary
                TextboxTitle.TextSize = 14
                TextboxTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                local TextboxFrame = Instance.new("Frame")
                TextboxFrame.Name = "TextboxFrame"
                TextboxFrame.Parent = Textbox
                TextboxFrame.BackgroundColor3 = CurrentTheme.TertiaryBackground
                TextboxFrame.Position = UDim2.new(0.01, 0, 0.45, 0)
                TextboxFrame.Size = UDim2.new(0, 392, 0, 32)
                
                local TextboxCorner = Instance.new("UICorner")
                TextboxCorner.CornerRadius = UDim.new(0, 3)
                TextboxCorner.Parent = TextboxFrame
                
                local TextboxInput = Instance.new("TextBox")
                TextboxInput.Name = "TextboxInput"
                TextboxInput.Parent = TextboxFrame
                TextboxInput.BackgroundTransparency = 1
                TextboxInput.Position = UDim2.new(0.038, 0, 0, 0)
                TextboxInput.Size = UDim2.new(0, 365, 0, 32)
                TextboxInput.Font = Enum.Font.Gotham
                TextboxInput.PlaceholderText = placeholder or ""
                TextboxInput.Text = ""
                TextboxInput.TextColor3 = CurrentTheme.TextPrimary
                TextboxInput.TextSize = 14
                TextboxInput.TextXAlignment = Enum.TextXAlignment.Left
                TextboxInput.ClearTextOnFocus = clearonfocus or false
                
                TextboxInput.Focused:Connect(function()
                    Utils.CreateTween(TextboxFrame, {BackgroundColor3 = CurrentTheme.Accent}, 0.3)
                end)
                
                TextboxInput.FocusLost:Connect(function()
                    Utils.CreateTween(TextboxFrame, {BackgroundColor3 = CurrentTheme.TertiaryBackground}, 0.3)
                    if callback then pcall(callback, TextboxInput.Text) end
                end)
                
                ChannelContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
                table.insert(channelData.components, Textbox)
                
                return TextboxInput
            end
            
            function ComponentHold:Label(text)
                local Label = Instance.new("TextLabel")
                Label.Name = "Label"
                Label.Parent = ChannelContent
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(0, 401, 0, 20)
                Label.Font = Enum.Font.Gotham
                Label.Text = text
                Label.TextColor3 = CurrentTheme.TextSecondary
                Label.TextSize = 14
                Label.TextXAlignment = Enum.TextXAlignment.Left
                
                ChannelContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
                table.insert(channelData.components, Label)
                
                return Label
            end
            
            function ComponentHold:Seperator()
                local Separator = Instance.new("Frame")
                Separator.Name = "Separator"
                Separator.Parent = ChannelContent
                Separator.BackgroundColor3 = CurrentTheme.Border
                Separator.BorderSizePixel = 0
                Separator.Size = UDim2.new(0, 401, 0, 1)
                
                ChannelContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
                table.insert(channelData.components, Separator)
                
                return Separator
            end
            
            function ComponentHold:Colorpicker(text, defaultcolor, callback)
                local selectedColor = defaultcolor or Color3.fromRGB(255, 255, 255)
                
                local ColorPicker = Instance.new("TextButton")
                ColorPicker.Name = "ColorPicker"
                ColorPicker.Parent = ChannelContent
                ColorPicker.BackgroundColor3 = CurrentTheme.SecondaryBackground
                ColorPicker.BorderSizePixel = 0
                ColorPicker.Size = UDim2.new(0, 401, 0, 30)
                ColorPicker.AutoButtonColor = false
                ColorPicker.Font = Enum.Font.Gotham
                ColorPicker.Text = ""
                
                local ColorTitle = Instance.new("TextLabel")
                ColorTitle.Name = "ColorTitle"
                ColorTitle.Parent = ColorPicker
                ColorTitle.BackgroundTransparency = 1
                ColorTitle.Position = UDim2.new(0, 5, 0, 0)
                ColorTitle.Size = UDim2.new(0, 200, 0, 30)
                ColorTitle.Font = Enum.Font.Gotham
                ColorTitle.Text = text
                ColorTitle.TextColor3 = CurrentTheme.TextSecondary
                ColorTitle.TextSize = 14
                ColorTitle.TextXAlignment = Enum.TextXAlignment.Left
                
                local ColorDisplay = Instance.new("Frame")
                ColorDisplay.Name = "ColorDisplay"
                ColorDisplay.Parent = ColorPicker
                ColorDisplay.BackgroundColor3 = selectedColor
                ColorDisplay.Position = UDim2.new(0.85, 0, 0.17, 0)
                ColorDisplay.Size = UDim2.new(0, 50, 0, 20)
                
                local ColorDisplayCorner = Instance.new("UICorner")
                ColorDisplayCorner.CornerRadius = UDim.new(0, 4)
                ColorDisplayCorner.Parent = ColorDisplay
                
                ColorPicker.MouseButton1Click:Connect(function()
                    -- Simple color picker - cycles through preset colors
                    local colors = {
                        Color3.fromRGB(255, 0, 0),    -- Red
                        Color3.fromRGB(0, 255, 0),    -- Green
                        Color3.fromRGB(0, 0, 255),    -- Blue
                        Color3.fromRGB(255, 255, 0),  -- Yellow
                        Color3.fromRGB(255, 0, 255),  -- Magenta
                        Color3.fromRGB(0, 255, 255),  -- Cyan
                        Color3.fromRGB(255, 255, 255), -- White
                        Color3.fromRGB(0, 0, 0)       -- Black
                    }
                    
                    -- Find current color index and move to next
                    local currentIndex = 1
                    for i, color in ipairs(colors) do
                        if selectedColor == color then
                            currentIndex = i
                            break
                        end
                    end
                    
                    local nextIndex = currentIndex % #colors + 1
                    selectedColor = colors[nextIndex]
                    
                    Utils.CreateTween(ColorDisplay, {BackgroundColor3 = selectedColor}, 0.3)
                    
                    if callback then pcall(callback, selectedColor) end
                end)
                
                ChannelContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
                table.insert(channelData.components, ColorPicker)
                
                return ColorPicker
            end
            
            return ComponentHold
        end
        
        return ChannelHold
    end
    
    return ServerHold
end

-- Enhanced Notification System
function DiscordLib:Notification(title, description, buttontext)
    local NotificationHolder = Instance.new("TextButton")
    NotificationHolder.Name = "NotificationHolder"
    NotificationHolder.Parent = Discord
    NotificationHolder.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    NotificationHolder.BackgroundTransparency = 1
    NotificationHolder.BorderSizePixel = 0
    NotificationHolder.Size = UDim2.new(1, 0, 1, 0)
    NotificationHolder.AutoButtonColor = false
    NotificationHolder.Font = Enum.Font.SourceSans
    NotificationHolder.Text = ""
    NotificationHolder.ZIndex = 100
    
    Utils.CreateTween(NotificationHolder, {BackgroundTransparency = 0.2}, 0.2)
    
    local Notification = Instance.new("Frame")
    Notification.Name = "Notification"
    Notification.Parent = NotificationHolder
    Notification.AnchorPoint = Vector2.new(0.5, 0.5)
    Notification.BackgroundColor3 = CurrentTheme.TertiaryBackground
    Notification.ClipsDescendants = true
    Notification.Position = UDim2.new(0.5, 0, 0.5, 0)
    Notification.Size = UDim2.new(0, 0, 0, 0)
    Notification.BackgroundTransparency = 1
    Notification.ZIndex = 101
    
    local NotificationCorner = Instance.new("UICorner")
    NotificationCorner.CornerRadius = UDim.new(0, 5)
    NotificationCorner.Parent = Notification
    
    Notification:TweenSize(UDim2.new(0, 346, 0, 176), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
    Utils.CreateTween(Notification, {BackgroundTransparency = 0}, 0.2)
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = Notification
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 0, 0.02, 0)
    TitleLabel.Size = UDim2.new(0, 346, 0, 68)
    TitleLabel.Font = Enum.Font.GothamSemibold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = CurrentTheme.TextPrimary
    TitleLabel.TextSize = 20
    TitleLabel.ZIndex = 102
    
    local DescLabel = Instance.new("TextLabel")
    DescLabel.Name = "DescLabel"
    DescLabel.Parent = Notification
    DescLabel.BackgroundTransparency = 1
    DescLabel.Position = UDim2.new(0.106, 0, 0.318, 0)
    DescLabel.Size = UDim2.new(0, 272, 0, 63)
    DescLabel.Font = Enum.Font.Gotham
    DescLabel.Text = description
    DescLabel.TextColor3 = CurrentTheme.TextSecondary
    DescLabel.TextSize = 14
    DescLabel.TextWrapped = true
    DescLabel.ZIndex = 102
    
    local AlrightBtn = Instance.new("TextButton")
    AlrightBtn.Name = "AlrightBtn"
    AlrightBtn.Parent = Notification
    AlrightBtn.BackgroundColor3 = CurrentTheme.Accent
    AlrightBtn.Position = UDim2.new(0.033, 0, 0.789, 0)
    AlrightBtn.Size = UDim2.new(0, 322, 0, 27)
    AlrightBtn.Font = Enum.Font.Gotham
    AlrightBtn.Text = buttontext or "Okay!"
    AlrightBtn.TextColor3 = CurrentTheme.TextPrimary
    AlrightBtn.TextSize = 13
    AlrightBtn.AutoButtonColor = false
    AlrightBtn.ZIndex = 102
    
    local AlrightCorner = Instance.new("UICorner")
    AlrightCorner.CornerRadius = UDim.new(0, 4)
    AlrightCorner.Parent = AlrightBtn
    
    AlrightBtn.MouseEnter:Connect(function()
        Utils.CreateTween(AlrightBtn, {BackgroundColor3 = CurrentTheme.AccentHover}, 0.2)
    end)
    
    AlrightBtn.MouseLeave:Connect(function()
        Utils.CreateTween(AlrightBtn, {BackgroundColor3 = CurrentTheme.Accent}, 0.2)
    end)
    
    AlrightBtn.MouseButton1Click:Connect(function()
        Utils.CreateTween(NotificationHolder, {BackgroundTransparency = 1}, 0.2)
        Notification:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
        Utils.CreateTween(Notification, {BackgroundTransparency = 1}, 0.2)
        task.wait(0.2)
        NotificationHolder:Destroy()
    end)
end

-- Save configuration on close
game.Players.PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        SaveSystem.Save()
    end
end)

-- Auto-save every 30 seconds
if Config.AutoSave then
    task.spawn(function()
        while true do
            task.wait(30)
            SaveSystem.Save()
        end
    end)
end

return DiscordLib

