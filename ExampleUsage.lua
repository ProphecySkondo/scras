local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/NovaHydroxide/main/NovaHydroxide.lua"))()

-- Create Window
local Window = Library:Window("Nova Hydroxide Hub")

-- Show notification
Window:Notification("Welcome!", "Nova Hydroxide has been loaded successfully!", "Success", 5)

-- Create Main Tab
local MainTab = Window:Tab("Main", "rbxassetid://7743878358")

-- Add elements to Main Tab
MainTab:Section("Player Features")

MainTab:Button("Infinite Jump", "Allows you to jump infinitely in the game", function()
    getgenv().InfiniteJump = not getgenv().InfiniteJump
    if getgenv().InfiniteJump then
        Window:Notification("Activated", "Infinite Jump has been enabled", "Success")
    else
        Window:Notification("Deactivated", "Infinite Jump has been disabled", "Info")
    end
end)

MainTab:Toggle("Fly", "Enables flight mode for your character", false, function(value)
    getgenv().Fly = value
    if value then
        Window:Notification("Fly Enabled", "You can now fly around the map", "Success")
    else
        Window:Notification("Fly Disabled", "Flight mode has been turned off", "Info")
    end
end)

MainTab:Slider("WalkSpeed", "Adjust your character's walking speed", 16, 200, 50, function(value)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end)

MainTab:Section("Visuals")

MainTab:Toggle("ESP", "Shows player names through walls", false, function(value)
    getgenv().ESP = value
    Window:Notification("ESP " .. (value and "Enabled" or "Disabled"), "Player ESP is now " .. (value and "active" or "inactive"), value and "Success" or "Info")
end)

MainTab:Toggle("Fullbright", "Makes the game brighter", false, function(value)
    getgenv().Fullbright = value
    local lighting = game:GetService("Lighting")
    
    if value then
        lighting.Brightness = 2
        lighting.ClockTime = 14
        lighting.FogEnd = 100000
        lighting.GlobalShadows = false
        lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    else
        lighting.Brightness = 1
        lighting.ClockTime = 12
        lighting.FogEnd = 100000
        lighting.GlobalShadows = true
        lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
    end
end)

-- Create Combat Tab
local CombatTab = Window:Tab("Combat", "rbxassetid://7743876142")

CombatTab:Section("Aimbot Settings")

CombatTab:Toggle("Aimbot", "Automatically aims at enemies", false, function(value)
    getgenv().Aimbot = value
    Window:Notification("Aimbot " .. (value and "Enabled" or "Disabled"), "Auto-aim is now " .. (value and "active" or "inactive"), value and "Success" or "Info")
end)

CombatTab:Slider("Aimbot FOV", "Field of view for aimbot targeting", 50, 360, 120, function(value)
    getgenv().AimbotFOV = value
end)

CombatTab:Section("Weapon Mods")

CombatTab:Toggle("Infinite Ammo", "Never run out of ammunition", false, function(value)
    getgenv().InfiniteAmmo = value
    Window:Notification("Infinite Ammo " .. (value and "Enabled" or "Disabled"), "Ammo modifications are now " .. (value and "active" or "inactive"), value and "Success" or "Info")
end)

CombatTab:Toggle("No Recoil", "Removes weapon recoil", false, function(value)
    getgenv().NoRecoil = value
    Window:Notification("No Recoil " .. (value and "Enabled" or "Disabled"), "Recoil modifications are now " .. (value and "active" or "inactive"), value and "Success" or "Info")
end)

-- Create Settings Tab
local SettingsTab = Window:Tab("Settings", "rbxassetid://7743875615")

SettingsTab:Section("UI Settings")

SettingsTab:Button("Destroy GUI", "Removes the interface from screen", function()
    Window:Notification("Goodbye!", "Thank you for using Nova Hydroxide!", "Info", 3)
    wait(3)
    game:GetService("CoreGui").NovaHydroxide:Destroy()
end)

SettingsTab:Section("About")

SettingsTab:Button("Join Discord", "Opens our Discord server invite", function()
    setclipboard("https://discord.gg/example")
    Window:Notification("Discord Link", "Discord invite copied to clipboard!", "Success")
end)

-- Auto-show the GUI
wait(1)
Window:Toggle()
