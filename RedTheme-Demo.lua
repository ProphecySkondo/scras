--[=[
🔥 RED THEME GUI LIBRARY - DEMONSTRATION SCRIPT 🔥
Professional Red Theme GUI Library Usage Example

This script demonstrates all the features and capabilities of the 
Red Theme GUI Library with practical examples.
]=]

-- Load the Red Theme GUI Library
local RedThemeLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/RedTheme-GUI-Library.lua"))()
-- Or if loading locally: local RedThemeLib = require(script.RedThemeGUILibrary)

print("🔥 Starting Red Theme GUI Demonstration...")

-- ═══════════════════════════════════════════════════════════════════════════════════════════
-- CREATE MAIN WINDOW
-- ═══════════════════════════════════════════════════════════════════════════════════════════

local window = RedThemeLib:CreateWindow({
    Title = "🔥 Red Theme Demo",
    Size = UDim2.new(0, 500, 0, 450),
    Position = UDim2.new(0.5, -250, 0.5, -225)
})

-- ═══════════════════════════════════════════════════════════════════════════════════════════
-- TAB 1: BASIC CONTROLS
-- ═══════════════════════════════════════════════════════════════════════════════════════════

local mainTab = window:CreateTab({
    Name = "Main",
    Icon = "rbxassetid://14368292698" -- Home icon
})

-- Welcome Label
local welcomeLabel = mainTab:CreateLabel({
    Text = "🔥 Welcome to Red Theme GUI Library v1.0!"
})

-- Basic Button Example
local clickCount = 0
local clickButton = mainTab:CreateButton({
    Text = "🎯 Click Me! (Count: 0)",
    Callback = function()
        clickCount = clickCount + 1
        clickButton.Text = "🎯 Click Me! (Count: " .. clickCount .. ")"
        window:Notify("Button Clicked", "You clicked the button " .. clickCount .. " times!", "success", 2)
    end
})

-- Toggle Example
local exampleToggle = mainTab:CreateToggle({
    Text = "🔄 Example Toggle",
    Default = false,
    Callback = function(value)
        if value then
            window:Notify("Toggle ON", "The example toggle has been enabled!", "success", 2)
            welcomeLabel:Set("🔥 Toggle is now ENABLED!")
        else
            window:Notify("Toggle OFF", "The example toggle has been disabled!", "warning", 2)
            welcomeLabel:Set("🔥 Toggle is now DISABLED!")
        end
    end
})

-- Slider Example
local valueLabel = mainTab:CreateLabel({
    Text = "📊 Current Value: 50"
})

local valueSlider = mainTab:CreateSlider({
    Text = "📊 Value Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        valueLabel:Set("📊 Current Value: " .. value)
        
        if value >= 80 then
            window:Notify("High Value", "Slider value is high: " .. value, "warning", 1.5)
        elseif value <= 20 then
            window:Notify("Low Value", "Slider value is low: " .. value, "info", 1.5)
        end
    end
})

-- Reset Button
mainTab:CreateButton({
    Text = "🔄 Reset All",
    Callback = function()
        clickCount = 0
        clickButton.Text = "🎯 Click Me! (Count: 0)"
        exampleToggle:Set(false)
        valueSlider:Set(50)
        valueLabel:Set("📊 Current Value: 50")
        welcomeLabel:Set("🔥 Welcome to Red Theme GUI Library v1.0!")
        window:Notify("Reset Complete", "All values have been reset to defaults!", "info", 3)
    end
})

-- ═══════════════════════════════════════════════════════════════════════════════════════════
-- TAB 2: ADVANCED FEATURES
-- ═══════════════════════════════════════════════════════════════════════════════════════════

local advancedTab = window:CreateTab({
    Name = "Advanced",
    Icon = "rbxassetid://14368293672" -- Settings icon
})

-- Status Labels
local statusLabel = advancedTab:CreateLabel({
    Text = "⚡ System Status: Ready"
})

local timeLabel = advancedTab:CreateLabel({
    Text = "🕒 Current Time: " .. os.date("%X")
})

-- Auto-updater for time
spawn(function()
    while true do
        wait(1)
        if timeLabel then
            timeLabel:Set("🕒 Current Time: " .. os.date("%X"))
        end
    end
end)

-- Multiple Toggles Example
local feature1Toggle = advancedTab:CreateToggle({
    Text = "🚀 Feature 1 (Speed Boost)",
    Default = false,
    Callback = function(value)
        if value then
            statusLabel:Set("⚡ System Status: Speed Boost Active")
            window:Notify("Feature Activated", "Speed Boost is now active!", "success", 2)
        else
            statusLabel:Set("⚡ System Status: Speed Boost Disabled")
        end
    end
})

local feature2Toggle = advancedTab:CreateToggle({
    Text = "🛡️ Feature 2 (Shield Mode)",
    Default = false,
    Callback = function(value)
        if value then
            statusLabel:Set("⚡ System Status: Shield Mode Active")
            window:Notify("Feature Activated", "Shield Mode is now protecting you!", "success", 2)
        else
            statusLabel:Set("⚡ System Status: Shield Mode Disabled")
        end
    end
})

-- Precision Slider
local precisionSlider = advancedTab:CreateSlider({
    Text = "🎯 Precision Setting",
    Min = 1,
    Max = 10,
    Default = 5,
    Callback = function(value)
        if value >= 8 then
            window:Notify("High Precision", "Maximum accuracy mode activated!", "success", 2)
        elseif value <= 3 then
            window:Notify("Low Precision", "Fast mode activated!", "info", 2)
        end
    end
})

-- Simulation Button
advancedTab:CreateButton({
    Text = "🧪 Run Simulation",
    Callback = function()
        window:Notify("Simulation Started", "Running advanced calculations...", "info", 3)
        
        -- Simulate some work with progress updates
        spawn(function()
            for i = 1, 5 do
                wait(1)
                statusLabel:Set("⚡ System Status: Processing... " .. (i * 20) .. "%")
            end
            
            statusLabel:Set("⚡ System Status: Simulation Complete ✅")
            window:Notify("Simulation Complete", "All calculations finished successfully!", "success", 4)
        end)
    end
})

-- ═══════════════════════════════════════════════════════════════════════════════════════════
-- TAB 3: CONFIGURATION
-- ═══════════════════════════════════════════════════════════════════════════════════════════

local configTab = window:CreateTab({
    Name = "Config",
    Icon = "rbxassetid://14368301329" -- Alert icon
})

-- Configuration Options
configTab:CreateLabel({
    Text = "⚙️ Configuration Panel"
})

local autoSaveToggle = configTab:CreateToggle({
    Text = "💾 Auto-Save Settings",
    Default = true,
    Callback = function(value)
        if value then
            window:Notify("Auto-Save ON", "Settings will be automatically saved!", "success", 2)
        else
            window:Notify("Auto-Save OFF", "Manual save required for settings!", "warning", 2)
        end
    end
})

local notificationsToggle = configTab:CreateToggle({
    Text = "🔔 Enable Notifications",
    Default = true,
    Callback = function(value)
        if value then
            window:Notify("Notifications ON", "You will receive system notifications!", "success", 2)
        else
            -- This would be the last notification if turned off
            window:Notify("Notifications OFF", "System notifications disabled!", "warning", 2)
        end
    end
})

-- Volume Slider
local volumeSlider = configTab:CreateSlider({
    Text = "🔊 Volume Level",
    Min = 0,
    Max = 100,
    Default = 75,
    Callback = function(value)
        if value == 0 then
            window:Notify("Audio Muted", "System audio has been muted!", "warning", 2)
        elseif value == 100 then
            window:Notify("Max Volume", "System audio at maximum level!", "info", 2)
        end
    end
})

-- Quality Slider
configTab:CreateSlider({
    Text = "🎨 Graphics Quality",
    Min = 1,
    Max = 5,
    Default = 3,
    Callback = function(value)
        local qualityNames = {
            [1] = "Very Low",
            [2] = "Low", 
            [3] = "Medium",
            [4] = "High",
            [5] = "Ultra"
        }
        
        window:Notify("Quality Changed", "Graphics quality set to: " .. qualityNames[value], "info", 2)
    end
})

-- Save/Load Buttons
configTab:CreateButton({
    Text = "💾 Save Configuration",
    Callback = function()
        window:Notify("Config Saved", "All settings have been saved successfully!", "success", 3)
    end
})

configTab:CreateButton({
    Text = "📂 Load Configuration", 
    Callback = function()
        window:Notify("Config Loaded", "Settings loaded from saved configuration!", "info", 3)
    end
})

-- ═══════════════════════════════════════════════════════════════════════════════════════════
-- TAB 4: INFORMATION & CREDITS
-- ═══════════════════════════════════════════════════════════════════════════════════════════

local infoTab = window:CreateTab({
    Name = "Info",
    Icon = "rbxassetid://14368300605" -- Add icon
})

-- Information Labels
infoTab:CreateLabel({
    Text = "ℹ️ Red Theme GUI Library Information"
})

infoTab:CreateLabel({
    Text = "📦 Version: 1.0.0 Professional"
})

infoTab:CreateLabel({
    Text = "👤 Player: " .. game.Players.LocalPlayer.Name
})

infoTab:CreateLabel({
    Text = "🎮 Game: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
})

infoTab:CreateLabel({
    Text = "🌟 Features: Tabs, Buttons, Toggles, Sliders, Notifications"
})

-- Test All Notifications Button
infoTab:CreateButton({
    Text = "🧪 Test All Notifications",
    Callback = function()
        window:Notify("Success Test", "This is a success notification!", "success", 2)
        wait(0.5)
        window:Notify("Warning Test", "This is a warning notification!", "warning", 2)
        wait(0.5)
        window:Notify("Error Test", "This is an error notification!", "error", 2)
        wait(0.5)
        window:Notify("Info Test", "This is an info notification!", "info", 2)
    end
})

-- Credits Button
infoTab:CreateButton({
    Text = "👑 Show Credits",
    Callback = function()
        window:Notify("Credits", "Red Theme GUI Library - Professional Edition", "success", 4)
        wait(1)
        window:Notify("Developer", "Created with professional design standards", "info", 3)
        wait(1)
        window:Notify("Thank You", "Thank you for using Red Theme GUI Library!", "success", 4)
    end
})

-- Performance Info
local performanceLabel = infoTab:CreateLabel({
    Text = "⚡ FPS: Calculating..."
})

-- FPS Counter (Simple)
spawn(function()
    local lastTime = tick()
    local frameCount = 0
    
    game:GetService("RunService").Heartbeat:Connect(function()
        frameCount = frameCount + 1
        
        if tick() - lastTime >= 1 then
            if performanceLabel then
                performanceLabel:Set("⚡ FPS: " .. frameCount)
            end
            frameCount = 0
            lastTime = tick()
        end
    end)
end)

-- ═══════════════════════════════════════════════════════════════════════════════════════════
-- FINAL SETUP & WELCOME SEQUENCE
-- ═══════════════════════════════════════════════════════════════════════════════════════════

-- Welcome sequence
window:Notify("🔥 Red Theme GUI", "Welcome to the professional Red Theme GUI Library!", "success", 4)

wait(2)
window:Notify("📋 Features Loaded", "All tabs and features are now available!", "info", 3)

wait(2)
window:Notify("🎯 Ready to Use", "Explore all tabs to see the full functionality!", "info", 3)

-- Demo completion message
print("🔥 Red Theme GUI Demonstration loaded successfully!")
print("📋 Features demonstrated:")
print("   • Professional Red Theme with smooth animations")
print("   • Multiple tabs with different content")
print("   • Buttons with click feedback and ripple effects")
print("   • Toggles with state management")
print("   • Sliders with real-time value updates")
print("   • Labels with dynamic text updates")
print("   • Notification system with multiple types")
print("   • Draggable window with blur effects")
print("   • Asset integration with custom icons")
print("   • Real-time updates and FPS monitoring")
print("🎉 Enjoy exploring the Red Theme GUI Library!")

-- Make the demo globally accessible
getgenv().RedThemeDemo = {
    window = window,
    mainTab = mainTab,
    advancedTab = advancedTab,
    configTab = configTab,
    infoTab = infoTab
}

return window
