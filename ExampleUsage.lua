-- Example Usage of Hydroxide Hub V2.0
-- This file demonstrates how to use the enhanced library

-- Load the library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourRepo/HydroxideHubV2.lua"))() 
-- Or use: local Library = require(script.HydroxideHubV2)

-- Create the main window
local Window = Library:CreateWindow({
    Title = "🚀 Hydroxide Hub V2.0 - Professional"
})

-- Create tabs
local MainTab = Window:CreateTab({
    Name = "Main",
    Icon = "⚡"
})

local PlayerTab = Window:CreateTab({
    Name = "Player", 
    Icon = "👤"
})

local VisualTab = Window:CreateTab({
    Name = "Visual",
    Icon = "🎨"
})

local MiscTab = Window:CreateTab({
    Name = "Misc",
    Icon = "🔧"
})

-- Main Tab Content
MainTab:AddSection("🎯 Main Features")

MainTab:AddButton({
    Text = "God Mode",
    Description = "Makes you invincible to all damage",
    Callback = function()
        Window:Notify("God Mode", "God mode activated!", "success")
        -- Your god mode code here
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.Humanoid.MaxHealth = math.huge
            game.Players.LocalPlayer.Character.Humanoid.Health = math.huge
        end
    end
})

MainTab:AddToggle({
    Text = "Infinite Jump",
    Description = "Jump as many times as you want",
    Default = false,
    Callback = function(state)
        if state then
            Window:Notify("Infinite Jump", "Infinite jump enabled!", "success")
            -- Enable infinite jump
            _G.InfiniteJump = true
            game:GetService("UserInputService").JumpRequest:Connect(function()
                if _G.InfiniteJump and game.Players.LocalPlayer.Character then
                    game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            Window:Notify("Infinite Jump", "Infinite jump disabled!", "warning")
            _G.InfiniteJump = false
        end
    end
})

MainTab:AddSeparator()

MainTab:AddSlider({
    Text = "Walk Speed",
    Description = "Change your walking speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character.Humanoid then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})

MainTab:AddSlider({
    Text = "Jump Power",
    Description = "Change your jump height",
    Min = 50,
    Max = 500,
    Default = 50,
    Callback = function(value)
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character.Humanoid then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end
})

-- Player Tab Content
PlayerTab:AddSection("👤 Player Controls")

PlayerTab:AddTextbox({
    Text = "Teleport to Player",
    Description = "Enter a player's username to teleport to them", 
    Placeholder = "Username...",
    Callback = function(text)
        local targetPlayer = nil
        for _, player in pairs(game.Players:GetPlayers()) do
            if string.lower(player.Name):find(string.lower(text)) or string.lower(player.DisplayName):find(string.lower(text)) then
                targetPlayer = player
                break
            end
        end
        
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                Window:Notify("Teleport", "Teleported to " .. targetPlayer.DisplayName, "success")
            end
        else
            Window:Notify("Teleport", "Player not found!", "error")
        end
    end
})

PlayerTab:AddToggle({
    Text = "No Clip",
    Description = "Walk through walls and objects",
    Default = false,
    Callback = function(state)
        _G.NoClip = state
        if state then
            Window:Notify("No Clip", "No clip enabled!", "success")
            game:GetService("RunService").Stepped:Connect(function()
                if _G.NoClip and game.Players.LocalPlayer.Character then
                    for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            Window:Notify("No Clip", "No clip disabled!", "warning")
        end
    end
})

PlayerTab:AddKeybind({
    Text = "Respawn Key", 
    Description = "Press this key to respawn your character",
    Default = Enum.KeyCode.R,
    Callback = function()
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.Humanoid.Health = 0
            Window:Notify("Respawn", "Character respawned!", "info")
        end
    end
})

-- Visual Tab Content
VisualTab:AddSection("🎨 Visual Effects")

VisualTab:AddToggle({
    Text = "Fullbright",
    Description = "Makes everything bright and visible",
    Default = false,
    Callback = function(state)
        if state then
            game.Lighting.Brightness = 2
            game.Lighting.ClockTime = 14
            game.Lighting.FogEnd = 100000
            game.Lighting.GlobalShadows = false
            game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            Window:Notify("Fullbright", "Fullbright enabled!", "success")
        else
            game.Lighting.Brightness = 1
            game.Lighting.ClockTime = 12
            game.Lighting.FogEnd = 100000
            game.Lighting.GlobalShadows = true
            game.Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
            Window:Notify("Fullbright", "Fullbright disabled!", "warning")
        end
    end
})

VisualTab:AddSlider({
    Text = "FOV",
    Description = "Change your field of view",
    Min = 70,
    Max = 120,
    Default = 70,
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value
    end
})

VisualTab:AddButton({
    Text = "Remove Fog",
    Description = "Removes all fog effects for better visibility",
    Callback = function()
        game.Lighting.FogEnd = 100000
        Window:Notify("Remove Fog", "Fog removed!", "success")
    end
})

-- Misc Tab Content
MiscTab:AddSection("🔧 Miscellaneous")

MiscTab:AddButton({
    Text = "Rejoin Server",
    Description = "Rejoin the current server",
    Callback = function()
        Window:Notify("Rejoin", "Rejoining server...", "info")
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

MiscTab:AddButton({
    Text = "Copy Game ID",
    Description = "Copy the current game's place ID",
    Callback = function()
        setclipboard(tostring(game.PlaceId))
        Window:Notify("Copy Game ID", "Game ID copied to clipboard!", "success")
    end
})

MiscTab:AddToggle({
    Text = "Anti AFK",
    Description = "Prevents you from being kicked for inactivity", 
    Default = false,
    Callback = function(state)
        if state then
            _G.AntiAFK = true
            game:GetService("Players").LocalPlayer.Idled:Connect(function()
                if _G.AntiAFK then
                    game:GetService("VirtualUser"):MoveMouse(Vector2.new())
                end
            end)
            Window:Notify("Anti AFK", "Anti AFK enabled!", "success")
        else
            _G.AntiAFK = false
            Window:Notify("Anti AFK", "Anti AFK disabled!", "warning")
        end
    end
})

MiscTab:AddSeparator()

MiscTab:AddTextbox({
    Text = "Chat Message",
    Description = "Send a message in chat",
    Placeholder = "Enter message...",
    Callback = function(text)
        if text and text ~= "" then
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(text, "All")
            Window:Notify("Chat", "Message sent!", "success")
        end
    end
})

-- Show a welcome notification
task.spawn(function()
    task.wait(2)
    Window:Notify(
        "🎉 Welcome!", 
        "Hydroxide Hub V2.0 loaded successfully! All features are ready to use.", 
        "success", 
        6
    )
end)

-- Auto-show the GUI after load
task.spawn(function()
    task.wait(0.5)
    Window:Toggle()
end)
