-- Load Enhanced Red Theme Library
local RedThemeLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ProphecySkondo/scras/main/RedTheme-Enhanced.lua"))()

-- Create window
local window = RedThemeLib:CreateWindow({
    Title = "Enhanced Red Theme GUI",
    Size = UDim2.new(0, 445, 0, 387)
})

-- Main Tab
local mainTab = window:CreateTab({
    Name = "Main",
    Icon = "rbxassetid://14368300605"
})

-- Welcome notification
window:Notify("Welcome!", "Enhanced Red Theme GUI loaded successfully with all features", "success")

-- Basic elements
mainTab:CreateLabel({
    Text = "🔥 Enhanced Red Theme GUI - All Features"
})

mainTab:CreateButton({
    Text = "Test Notification",
    Callback = function()
        window:Notify("Test Complete", "This is a test notification with description showing off the new notification system!", "info")
    end
})

-- Keybind example
mainTab:CreateKeybind({
    Text = "Toggle GUI Keybind",
    Default = "T",
    Callback = function()
        window:Notify("Keybind Pressed", "The toggle GUI keybind was pressed!", "success")
    end
})

-- Another keybind
mainTab:CreateKeybind({
    Text = "Action Keybind",
    Default = "F",
    Callback = function()
        window:Notify("Action Triggered", "Action keybind was activated!", "warning")
    end
})

-- Toggle with notification
mainTab:CreateToggle({
    Text = "Feature Toggle",
    Default = false,
    Callback = function(value)
        if value then
            window:Notify("Feature ON", "The feature has been enabled successfully", "success")
        else
            window:Notify("Feature OFF", "The feature has been disabled", "error")
        end
    end
})

-- Slider with notifications
mainTab:CreateSlider({
    Text = "Value Slider",
    Min = 0,
    Max = 100,
    Default = 25,
    Callback = function(value)
        if value >= 75 then
            window:Notify("High Value", "Slider value is now at " .. value .. " (High)", "warning")
        elseif value <= 25 then
            window:Notify("Low Value", "Slider value is now at " .. value .. " (Low)", "info")
        end
    end
})

-- Settings Tab
local settingsTab = window:CreateTab({
    Name = "Settings",
    Icon = "rbxassetid://14368293672"
})

settingsTab:CreateLabel({
    Text = "⚙️ GUI Configuration Settings"
})

-- Theme changer
settingsTab:CreateThemeChanger()

-- More keybinds in settings
settingsTab:CreateKeybind({
    Text = "Emergency Stop",
    Default = "X",
    Callback = function()
        window:Notify("Emergency Stop", "Emergency stop keybind activated!", "error")
    end
})

settingsTab:CreateKeybind({
    Text = "Quick Save",
    Default = "S",
    Callback = function()
        window:Notify("Quick Save", "Configuration has been quickly saved!", "success")
    end
})

-- Settings toggles
settingsTab:CreateToggle({
    Text = "Auto Notifications",
    Default = true,
    Callback = function(value)
        window:Notify("Auto Notifications", value and "Enabled" or "Disabled", value and "success" or "warning")
    end
})

settingsTab:CreateToggle({
    Text = "Smooth Animations", 
    Default = true,
    Callback = function(value)
        window:Notify("Animations", "Smooth animations " .. (value and "enabled" or "disabled"), "info")
    end
})

-- Advanced settings slider
settingsTab:CreateSlider({
    Text = "Drag Smoothness",
    Min = 1,
    Max = 10,
    Default = 5,
    Callback = function(value)
        -- Update the drag speed based on slider (lower = smoother)
        local dragSpeed = value / 50  -- Convert to 0.02 - 0.2 range
        window:Notify("Drag Speed", "Window drag smoothness set to level " .. value, "info")
    end
})

-- Info Tab
local infoTab = window:CreateTab({
    Name = "Info",
    Icon = "rbxassetid://14368301329"
})

infoTab:CreateLabel({
    Text = "📋 Enhanced Features Information"
})

infoTab:CreateLabel({
    Text = "✅ Only main frame has red border outline"
})

infoTab:CreateLabel({
    Text = "✅ More reddish sidebar color"
})

infoTab:CreateLabel({
    Text = "✅ Keybind system - click text to set keys"
})

infoTab:CreateLabel({
    Text = "✅ Smooth dragging with adjustable speed"
})

infoTab:CreateLabel({
    Text = "✅ Theme changer (Red/Blue/Green)"
})

infoTab:CreateLabel({
    Text = "✅ Notification system from bottom right"
})

infoTab:CreateLabel({
    Text = "✅ Transparent notifications with borders"
})

-- Test buttons for different notification types
infoTab:CreateButton({
    Text = "Test Success Notification",
    Callback = function()
        window:Notify("Success!", "This is a success notification with green accent", "success")
    end
})

infoTab:CreateButton({
    Text = "Test Warning Notification", 
    Callback = function()
        window:Notify("Warning!", "This is a warning notification with orange accent", "warning")
    end
})

infoTab:CreateButton({
    Text = "Test Error Notification",
    Callback = function()
        window:Notify("Error!", "This is an error notification with red accent", "error")
    end
})

infoTab:CreateButton({
    Text = "Test Info Notification",
    Callback = function()
        window:Notify("Information", "This is an info notification with theme accent color", "info")
    end
})

print("Enhanced Red Theme GUI Demo loaded!")
print("Features:")
print("- Only main frame has red border")
print("- More reddish sidebar")
print("- Keybind system (click to set)")  
print("- Smooth dragging")
print("- Theme changer")
print("- Bottom-right notifications")
print("- Transparent notifications with borders")
