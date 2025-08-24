-- Load Professional Hydroxide-Style Red Theme Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ProphecySkondo/scras/main/HydroxideRedTheme.lua"))()

-- Main Configuration Table
local Main = {
    Settings = {
        AutoSave = true,
        NotificationDuration = 4,
        Theme = "Professional Gray",
        Version = "2.0"
    },
    Features = {
        Enabled = {},
        Keybinds = {},
        Values = {}
    },
    Stats = {
        SessionTime = 0,
        ButtonClicks = 0,
        TogglesChanged = 0
    }
}

-- Create main window
local Window = Library:CreateWindow({
    Title = "🔥 Professional Hydroxide GUI - v2.0"
})

-- Main Tab
local MainTab = Window:CreateTab({
    Name = "Main"
})

MainTab:CreateLabel("🔥 Professional Hydroxide-Style Interface")
MainTab:CreateLabel("Welcome to the updated GUI with rounded close button!")

-- Notification Testing Section
MainTab:CreateLabel("📢 Notification System:")

MainTab:CreateButton({
    Text = "✅ Test Success Notification",
    Callback = function()
        Main.Stats.ButtonClicks = Main.Stats.ButtonClicks + 1
        Window:Notify("Success", "Professional notification system working perfectly! Clicks: " .. Main.Stats.ButtonClicks, "success")
    end
})

MainTab:CreateButton({
    Text = "⚠️ Show Warning Message",
    Callback = function()
        Main.Stats.ButtonClicks = Main.Stats.ButtonClicks + 1
        Window:Notify("Warning", "This is a warning notification with proper styling. Total clicks: " .. Main.Stats.ButtonClicks, "warning")
    end
})

MainTab:CreateButton({
    Text = "❌ Display Error Alert",
    Callback = function()
        Main.Stats.ButtonClicks = Main.Stats.ButtonClicks + 1
        Window:Notify("Error", "Error notification with red accent bar. Buttons pressed: " .. Main.Stats.ButtonClicks, "error")
    end
})

MainTab:CreateButton({
    Text = "ℹ️ Information Message",
    Callback = function()
        Main.Stats.ButtonClicks = Main.Stats.ButtonClicks + 1
        Window:Notify("Info", "Information notification with blue styling. Button interactions: " .. Main.Stats.ButtonClicks, "info")
    end
})

-- Feature Controls Section  
MainTab:CreateLabel("⚙️ Feature Controls:")

MainTab:CreateToggle({
    Text = "Enable Auto-Save",
    Default = Main.Settings.AutoSave,
    Callback = function(state)
        Main.Settings.AutoSave = state
        Main.Stats.TogglesChanged = Main.Stats.TogglesChanged + 1
        Main.Features.Enabled["AutoSave"] = state
        Window:Notify("Auto-Save", "Auto-save feature " .. (state and "enabled" or "disabled") .. ". Changes: " .. Main.Stats.TogglesChanged, state and "success" or "info")
    end
})

MainTab:CreateToggle({
    Text = "Professional Mode",
    Default = false,
    Callback = function(state)
        Main.Stats.TogglesChanged = Main.Stats.TogglesChanged + 1
        Main.Features.Enabled["Professional"] = state
        if state then
            Window:Notify("Professional Mode", "Professional mode activated with enhanced features!", "success")
        else
            Window:Notify("Professional Mode", "Switched to standard mode", "info")
        end
    end
})

-- Keybind Section
MainTab:CreateLabel("⌨️ Keybind Controls:")

MainTab:CreateKeybind({
    Text = "Quick Action",
    Default = "F",
    Callback = function()
        Main.Features.Keybinds["QuickAction"] = "F"
        Window:Notify("Quick Action", "Quick action keybind (F) was pressed!", "info")
    end
})

MainTab:CreateKeybind({
    Text = "Emergency Stop",
    Default = "X",
    Callback = function()
        Main.Features.Keybinds["Emergency"] = "X"
        Window:Notify("Emergency", "Emergency stop (X) activated!", "error")
    end
})

MainTab:CreateKeybind({
    Text = "Save Configuration",
    Default = "S",
    Callback = function()
        Main.Features.Keybinds["Save"] = "S"
        Window:Notify("Save", "Configuration saved via keybind (S)!", "success")
    end
})

-- Slider Controls Section
MainTab:CreateLabel("🎚️ Slider Controls:")

MainTab:CreateSlider({
    Text = "Master Volume",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        Main.Features.Values["Volume"] = value
        if value >= 80 then
            Window:Notify("Volume Control", "Volume set to " .. value .. "% (High Level)", "warning")
        elseif value <= 20 then
            Window:Notify("Volume Control", "Volume set to " .. value .. "% (Low Level)", "info")
        else
            -- Silent for mid-range values to avoid spam
        end
    end
})

MainTab:CreateSlider({
    Text = "GUI Transparency",
    Min = 0,
    Max = 50,
    Default = 10,
    Callback = function(value)
        Main.Features.Values["Transparency"] = value
        Window:Notify("Transparency", "GUI transparency adjusted to " .. value .. "%", "info")
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
