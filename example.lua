-- Example usage with enhanced features:
local DiscordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/RepoName/main/discord-lib.lua"))()
local win = DiscordLib:Window("Enhanced Discord Library v2.0")

local serv = win:Server("Main", "")
local btns = serv:Channel("Buttons")
local sliders = serv:Channel("Sliders")
local toggles = serv:Channel("Toggles")
local misc = serv:Channel("Miscellaneous")

-- Welcome notification with the new system
DiscordLib:Notification("Welcome! 🎉", "Enhanced Discord library loaded successfully with blur effects and smooth animations!", "success", 4)

-- Inform about Z-key toggle
task.wait(1)
DiscordLib:Notification("Pro Tip 💡", "Press 'Z' to toggle the GUI visibility with smooth blur effects", "info", 5)

-- Button examples
btns:Button("Print Hello", function()
    print("Hello World!")
    DiscordLib:Notification("Action Complete", "Hello button was pressed successfully", "info", 2)
end)

btns:Button("Test Error Notification", function()
    DiscordLib:Notification("Error Example", "This is what an error notification looks like", "error", 3)
end)

btns:Button("Test Warning", function()
    DiscordLib:Notification("Warning Example", "This demonstrates a warning notification", "warning", 3)
end)

-- Toggle examples
local myToggle = toggles:Toggle("Enable Feature", false, function(t)
    print("Toggle:", t)
    DiscordLib:Notification("Setting Updated", "Feature is now " .. (t and "enabled" or "disabled"), t and "success" or "warning", 2)
end)

toggles:Toggle("Smooth Animations", true, function(enabled)
    print("Smooth animations:", enabled)
end)

-- Slider examples
sliders:Slider("Volume", 0, 100, 50, function(t)
    print("Volume:", t)
end)

sliders:Slider("Transparency", 0, 1, 0.5, function(value)
    print("Transparency level:", value)
end)

-- Miscellaneous components
misc:Label("Enhanced Discord Library v2.0")
misc:Label("Features: Smooth animations, modern notifications, blur effects")
misc:Seperator()

misc:Textbox("Username", "Enter your username...", false, function(text)
    if text ~= "" then
        DiscordLib:Notification("Username Set", "Welcome, " .. text .. "!", "success", 2)
    end
end)

local dropdown = misc:Dropdown("Theme", {"Dark", "Light", "Auto"}, function(option)
    print("Selected theme:", option)
    DiscordLib:Notification("Theme Changed", "Switched to " .. option .. " theme", "info", 2)
end)

local colorPicker = misc:Colorpicker("Accent Color", Color3.fromRGB(114, 137, 228), function(color)
    print("Selected color:", color)
end)

-- Show tips about the enhanced features
task.spawn(function()
    task.wait(3)
    DiscordLib:Notification("Enhanced Features 🚀", "Try the blur effects, smooth animations, and modern notifications!", "info", 4)
    
    task.wait(5)
    DiscordLib:Notification("Z-Key Toggle Ready ⌨️", "Your GUI is ready! Press 'Z' anytime to toggle visibility", "success", 3)
end)
