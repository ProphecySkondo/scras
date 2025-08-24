-- Load from GitHub:
local RedThemeLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ProphecySkondo/scras/main/RedTheme-Blocky.lua"))()

-- Create your red-themed GUI:
local window = RedThemeLib:CreateWindow({
    Title = "My Red Theme App",
    Size = UDim2.new(0, 445, 0, 387) -- Your original design size
})

local tab = window:CreateTab({
    Name = "Main",
    Icon = "rbxassetid://14368300605" -- Your asset
})

tab:CreateButton({
    Text = "Click Me!",
    Callback = function()
        window:Notify("Success", "Red theme working perfectly!", "success", 3)
    end
})

-- Add more elements
tab:CreateToggle({
    Text = "Enable Feature",
    Default = false,
    Callback = function(value)
        if value then
            window:Notify("Feature ON", "Feature has been enabled!", "success", 2)
        else
            window:Notify("Feature OFF", "Feature has been disabled!", "warning", 2)
        end
    end
})

tab:CreateSlider({
    Text = "Speed Setting",
    Min = 1,
    Max = 10,
    Default = 5,
    Callback = function(value)
        window:Notify("Speed Changed", "Speed set to: " .. value, "info", 2)
    end
})

local statusLabel = tab:CreateLabel({
    Text = "Status: Ready"
})

-- Create another tab
local settingsTab = window:CreateTab({
    Name = "Settings",
    Icon = "rbxassetid://14368301329" -- Alert icon
})

settingsTab:CreateLabel({
    Text = "Configuration Options"
})

settingsTab:CreateButton({
    Text = "Save Settings",
    Callback = function()
        statusLabel:Set("Status: Settings Saved!")
        window:Notify("Saved", "All settings have been saved!", "success", 3)
    end
})
