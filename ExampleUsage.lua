-- Example Usage of Hydroxide Hub V2.0\r
-- This file demonstrates how to use the enhanced library\r
\r
-- Load the library\r
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourRepo/HydroxideHubV2.lua"))() \r
-- Or use: local Library = require(script.HydroxideHubV2)\r
\r
-- Create the main window\r
local Window = Library:CreateWindow({\r
    Title = "🚀 Hydroxide Hub V2.0 - Professional"\r
})\r
\r
-- Create tabs\r
local MainTab = Window:CreateTab({\r
    Name = "Main",\r
    Icon = "⚡"\r
})\r
\r
local PlayerTab = Window:CreateTab({\r
    Name = "Player", \r
    Icon = "👤"\r
})\r
\r
local VisualTab = Window:CreateTab({\r
    Name = "Visual",\r
    Icon = "🎨"\r
})\r
\r
local MiscTab = Window:CreateTab({\r
    Name = "Misc",\r
    Icon = "🔧"\r
})\r
\r
-- Main Tab Content\r
MainTab:AddSection("🎯 Main Features")\r
\r
MainTab:AddButton({\r
    Text = "God Mode",\r
    Description = "Makes you invincible to all damage",\r
    Callback = function()\r
        Window:Notify("God Mode", "God mode activated!", "success")\r
        -- Your god mode code here\r
        if game.Players.LocalPlayer.Character then\r
            game.Players.LocalPlayer.Character.Humanoid.MaxHealth = math.huge\r
            game.Players.LocalPlayer.Character.Humanoid.Health = math.huge\r
        end\r
    end\r
})\r
\r
MainTab:AddToggle({\r
    Text = "Infinite Jump",\r
    Description = "Jump as many times as you want",\r
    Default = false,\r
    Callback = function(state)\r
        if state then\r
            Window:Notify("Infinite Jump", "Infinite jump enabled!", "success")\r
            -- Enable infinite jump\r
            _G.InfiniteJump = true\r
            game:GetService("UserInputService").JumpRequest:Connect(function()\r
                if _G.InfiniteJump and game.Players.LocalPlayer.Character then\r
                    game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)\r
                end\r
            end)\r
        else\r
            Window:Notify("Infinite Jump", "Infinite jump disabled!", "warning")\r
            _G.InfiniteJump = false\r
        end\r
    end\r
})\r
\r
MainTab:AddSeparator()\r
\r
MainTab:AddSlider({\r
    Text = "Walk Speed",\r
    Description = "Change your walking speed",\r
    Min = 16,\r
    Max = 200,\r
    Default = 16,\r
    Callback = function(value)\r
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character.Humanoid then\r
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value\r
        end\r
    end\r
})\r
\r
MainTab:AddSlider({\r
    Text = "Jump Power",\r
    Description = "Change your jump height",\r
    Min = 50,\r
    Max = 500,\r
    Default = 50,\r
    Callback = function(value)\r
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character.Humanoid then\r
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = value\r
        end\r
    end\r
})\r
\r
-- Player Tab Content\r
PlayerTab:AddSection("👤 Player Controls")\r
\r
PlayerTab:AddTextbox({\r
    Text = "Teleport to Player",\r
    Description = "Enter a player's username to teleport to them", \r
    Placeholder = "Username...",\r
    Callback = function(text)\r
        local targetPlayer = nil\r
        for _, player in pairs(game.Players:GetPlayers()) do\r
            if string.lower(player.Name):find(string.lower(text)) or string.lower(player.DisplayName):find(string.lower(text)) then\r
                targetPlayer = player\r
                break\r
            end\r
        end\r
        \r
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then\r
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then\r
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame\r
                Window:Notify("Teleport", "Teleported to " .. targetPlayer.DisplayName, "success")\r
            end\r
        else\r
            Window:Notify("Teleport", "Player not found!", "error")\r
        end\r
    end\r
})\r
\r
PlayerTab:AddToggle({\r
    Text = "No Clip",\r
    Description = "Walk through walls and objects",\r
    Default = false,\r
    Callback = function(state)\r
        _G.NoClip = state\r
        if state then\r
            Window:Notify("No Clip", "No clip enabled!", "success")\r
            game:GetService("RunService").Stepped:Connect(function()\r
                if _G.NoClip and game.Players.LocalPlayer.Character then\r
                    for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do\r
                        if part:IsA("BasePart") and part.CanCollide then\r
                            part.CanCollide = false\r
                        end\r
                    end\r
                end\r
            end)\r
        else\r
            Window:Notify("No Clip", "No clip disabled!", "warning")\r
        end\r
    end\r
})\r
\r
PlayerTab:AddKeybind({\r
    Text = "Respawn Key", \r
    Description = "Press this key to respawn your character",\r
    Default = Enum.KeyCode.R,\r
    Callback = function()\r
        if game.Players.LocalPlayer.Character then\r
            game.Players.LocalPlayer.Character.Humanoid.Health = 0\r
            Window:Notify("Respawn", "Character respawned!", "info")\r
        end\r
    end\r
})\r
\r
-- Visual Tab Content\r
VisualTab:AddSection("🎨 Visual Effects")\r
\r
VisualTab:AddToggle({\r
    Text = "Fullbright",\r
    Description = "Makes everything bright and visible",\r
    Default = false,\r
    Callback = function(state)\r
        if state then\r
            game.Lighting.Brightness = 2\r
            game.Lighting.ClockTime = 14\r
            game.Lighting.FogEnd = 100000\r
            game.Lighting.GlobalShadows = false\r
            game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)\r
            Window:Notify("Fullbright", "Fullbright enabled!", "success")\r
        else\r
            game.Lighting.Brightness = 1\r
            game.Lighting.ClockTime = 12\r
            game.Lighting.FogEnd = 100000\r
            game.Lighting.GlobalShadows = true\r
            game.Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)\r
            Window:Notify("Fullbright", "Fullbright disabled!", "warning")\r
        end\r
    end\r
})\r
\r
VisualTab:AddSlider({\r
    Text = "FOV",\r
    Description = "Change your field of view",\r
    Min = 70,\r
    Max = 120,\r
    Default = 70,\r
    Callback = function(value)\r
        workspace.CurrentCamera.FieldOfView = value\r
    end\r
})\r
\r
VisualTab:AddButton({\r
    Text = "Remove Fog",\r
    Description = "Removes all fog effects for better visibility",\r
    Callback = function()\r
        game.Lighting.FogEnd = 100000\r
        Window:Notify("Remove Fog", "Fog removed!", "success")\r
    end\r
})\r
\r
-- Misc Tab Content\r
MiscTab:AddSection("🔧 Miscellaneous")\r
\r
MiscTab:AddButton({\r
    Text = "Rejoin Server",\r
    Description = "Rejoin the current server",\r
    Callback = function()\r
        Window:Notify("Rejoin", "Rejoining server...", "info")\r
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)\r
    end\r
})\r
\r
MiscTab:AddButton({\r
    Text = "Copy Game ID",\r
    Description = "Copy the current game's place ID",\r
    Callback = function()\r
        setclipboard(tostring(game.PlaceId))\r
        Window:Notify("Copy Game ID", "Game ID copied to clipboard!", "success")\r
    end\r
})\r
\r
MiscTab:AddToggle({\r
    Text = "Anti AFK",\r
    Description = "Prevents you from being kicked for inactivity", \r
    Default = false,\r
    Callback = function(state)\r
        if state then\r
            _G.AntiAFK = true\r
            game:GetService("Players").LocalPlayer.Idled:Connect(function()\r
                if _G.AntiAFK then\r
                    game:GetService("VirtualUser"):MoveMouse(Vector2.new())\r
                end\r
            end)\r
            Window:Notify("Anti AFK", "Anti AFK enabled!", "success")\r
        else\r
            _G.AntiAFK = false\r
            Window:Notify("Anti AFK", "Anti AFK disabled!", "warning")\r
        end\r
    end\r
})\r
\r
MiscTab:AddSeparator()\r
\r
MiscTab:AddTextbox({\r
    Text = "Chat Message",\r
    Description = "Send a message in chat",\r
    Placeholder = "Enter message...",\r
    Callback = function(text)\r
        if text and text ~= "" then\r
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(text, "All")\r
            Window:Notify("Chat", "Message sent!", "success")\r
        end\r
    end\r
})\r
\r
-- Show a welcome notification\r
task.spawn(function()\r
    task.wait(2)\r
    Window:Notify(\r
        "🎉 Welcome!", \r
        "Hydroxide Hub V2.0 loaded successfully! All features are ready to use.", \r
        "success", \r
        6\r
    )\r
end)\r
\r
-- Auto-show the GUI after load\r
task.spawn(function()\r
    task.wait(0.5)\r
    Window:Toggle()\r
end)\r
