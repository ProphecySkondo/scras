-- Load Hydroxide-Style Red Theme Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ProphecySkondo/scras/main/HydroxideRedTheme.lua"))()

-- Create main window
local Window = Library:CreateWindow({
    Title = "Hydroxide Red Theme - Professional GUI"
})

-- Main Tab
local MainTab = Window:CreateTab({
    Name = "Main"
})

MainTab:CreateLabel("🔥 Professional Hydroxide-Style Interface")

MainTab:CreateButton({
    Text = "Test Notification System",
    Callback = function()
        Window:Notify("Success", "Professional notification system working perfectly!", "success")
    end
})

MainTab:CreateButton({
    Text = "Show Warning",
    Callback = function()
        Window:Notify("Warning", "This is a warning notification with proper styling", "warning")
    end
})

MainTab:CreateButton({
    Text = "Show Error",
    Callback = function()
        Window:Notify("Error", "Error notification with red accent bar", "error")
    end
})

MainTab:CreateToggle({
    Text = "Enable Feature",
    Default = false,
    Callback = function(state)
        Window:Notify("Toggle", "Feature " .. (state and "enabled" or "disabled"), state and "success" or "info")
    end
})

MainTab:CreateKeybind({
    Text = "Test Keybind",
    Default = "F",
    Callback = function()
        Window:Notify("Keybind", "Test keybind was pressed!", "info")
    end
})

MainTab:CreateKeybind({
    Text = "Emergency Stop",
    Default = "X",
    Callback = function()
        Window:Notify("Emergency", "Emergency stop activated!", "error")
    end
})

MainTab:CreateSlider({
    Text = "Volume",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        if value >= 80 then
            Window:Notify("Volume", "Volume set to " .. value .. " (High)", "warning")
        elseif value <= 20 then
            Window:Notify("Volume", "Volume set to " .. value .. " (Low)", "info")
        end
    end
})

-- Settings Tab
local SettingsTab = Window:CreateTab({
    Name = "Settings"
})

SettingsTab:CreateLabel("⚙️ Configuration Settings")

SettingsTab:CreateToggle({
    Text = "Auto Notifications",
    Default = true,
    Callback = function(state)
        Window:Notify("Auto Notifications", state and "Enabled" or "Disabled", "info")
    end
})

SettingsTab:CreateToggle({
    Text = "Sound Effects",
    Default = false,
    Callback = function(state)
        Window:Notify("Sound Effects", "Sound effects " .. (state and "enabled" or "disabled"), "info")
    end
})

SettingsTab:CreateKeybind({
    Text = "Quick Save",
    Default = "S",
    Callback = function()
        Window:Notify("Quick Save", "Configuration saved successfully!", "success")
    end
})

SettingsTab:CreateSlider({
    Text = "GUI Scale",
    Min = 75,
    Max = 125,
    Default = 100,
    Callback = function(value)
        Window:Notify("GUI Scale", "Interface scale set to " .. value .. "%", "info")
    end
})

-- Features Tab
local FeaturesTab = Window:CreateTab({
    Name = "Features"
})

FeaturesTab:CreateLabel("✨ Hydroxide-Style Features")
FeaturesTab:CreateLabel("• Professional square design")
FeaturesTab:CreateLabel("• Perfectly centered window")
FeaturesTab:CreateLabel("• Red theme with proper contrast")
FeaturesTab:CreateLabel("• Insert key to toggle GUI visibility")
FeaturesTab:CreateLabel("• Proper notification system from right")
FeaturesTab:CreateLabel("• Smooth animations and transitions")
FeaturesTab:CreateLabel("• Keybind system with visual feedback")

FeaturesTab:CreateButton({
    Text = "Test All Notifications",
    Callback = function()
        Window:Notify("Success Test", "This is a success notification!", "success")
        task.wait(1)
        Window:Notify("Warning Test", "This is a warning notification!", "warning")
        task.wait(1)
        Window:Notify("Error Test", "This is an error notification!", "error")
        task.wait(1)
        Window:Notify("Info Test", "This is an info notification!", "info")
    end
})

FeaturesTab:CreateKeybind({
    Text = "Feature Toggle",
    Default = "G",
    Callback = function()
        Window:Notify("Feature", "Feature toggled via keybind!", "success")
    end
})

-- Info Tab
local InfoTab = Window:CreateTab({
    Name = "Info"
})

InfoTab:CreateLabel("📋 Hydroxide Red Theme GUI Library")
InfoTab:CreateLabel("Version: Professional Edition")
InfoTab:CreateLabel("Style: Hydroxide-inspired")
InfoTab:CreateLabel("Theme: Red with professional contrast")
InfoTab:CreateLabel("Toggle Key: Insert")
InfoTab:CreateLabel("Design: Square, centered, modern")

InfoTab:CreateButton({
    Text = "Show Library Info",
    Callback = function()
        Window:Notify("Library Info", "Professional Hydroxide-style GUI with red theme, square design, and proper notifications", "info")
    end
})

InfoTab:CreateButton({
    Text = "Credits",
    Callback = function()
        Window:Notify("Credits", "Hydroxide-style Red Theme GUI Library - Professional Edition", "success")
    end
})

print("Hydroxide-Style Red Theme GUI Demo loaded!")
print("Features:")
print("- Professional square Hydroxide-style design")
print("- Perfectly centered window")
print("- Red theme with proper contrast")
print("- Press Insert to toggle GUI visibility")
print("- Notifications appear from the right side")
print("- Smooth animations and professional styling")
print("- Keybind system with proper feedback")
