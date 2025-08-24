# 🔥 Red Theme GUI Library - Usage Guide

## Professional Red Theme GUI Library v1.0

A modern, professional GUI library based on your original Studio design with enhanced red theme styling, smooth animations, and comprehensive functionality.

---

## ✨ **Features**

- **🎨 Professional Red Theme** - Dark red sidebar with bright red borders
- **🖱️ Smooth Animations** - Tween-based animations with ripple effects  
- **📱 Responsive Design** - Auto-scaling elements and layouts
- **🔄 Multiple Tabs** - Organized content with icon support
- **🎛️ Rich Controls** - Buttons, toggles, sliders, and labels
- **🔔 Notification System** - Multiple notification types with animations
- **🖼️ Asset Integration** - Custom icons using the provided asset IDs
- **🌟 Blur Effects** - Professional background blur when active
- **🖱️ Draggable Windows** - Smooth drag functionality
- **💾 Easy Integration** - Simple API for quick implementation

---

## 🚀 **Quick Start**

### 1. Loading the Library

```lua
-- Method 1: Direct script loading (replace with your script)
local RedThemeLib = loadstring(game:HttpGet("your-script-url"))()

-- Method 2: Local require (if you have the script)
local RedThemeLib = require(script.RedThemeGUILibrary)
```

### 2. Creating a Window

```lua
local window = RedThemeLib:CreateWindow({
    Title = "🔥 My Red Theme GUI",
    Size = UDim2.new(0, 445, 0, 387), -- Default size from your design
    Position = UDim2.new(0.5, -222, 0.5, -193) -- Centered
})
```

### 3. Creating Your First Tab

```lua
local mainTab = window:CreateTab({
    Name = "Main",
    Icon = "rbxassetid://14368292698" -- Home icon from your assets
})
```

---

## 📚 **API Reference**

### **Window Creation**

```lua
local window = RedThemeLib:CreateWindow(options)
```

**Options:**
- `Title` (string): Window title text
- `Size` (UDim2): Window size
- `Position` (UDim2): Window position

### **Tab Creation**

```lua
local tab = window:CreateTab(options)
```

**Options:**
- `Name` (string): Tab display name
- `Icon` (string): Asset ID for tab icon

### **Button Creation**

```lua
local button = tab:CreateButton(options)
```

**Options:**
- `Text` (string): Button text
- `Callback` (function): Function to call when clicked

**Example:**
```lua
mainTab:CreateButton({
    Text = "🎯 Click Me!",
    Callback = function()
        print("Button was clicked!")
        window:Notify("Success", "Button clicked successfully!", "success", 3)
    end
})
```

### **Toggle Creation**

```lua
local toggle = tab:CreateToggle(options)
```

**Options:**
- `Text` (string): Toggle label text
- `Default` (boolean): Initial state (true/false)
- `Callback` (function): Function called with new state

**Example:**
```lua
local myToggle = mainTab:CreateToggle({
    Text = "🔄 Enable Feature",
    Default = false,
    Callback = function(value)
        if value then
            print("Feature enabled!")
        else
            print("Feature disabled!")
        end
    end
})

-- Programmatically set toggle state
myToggle:Set(true)
```

### **Slider Creation**

```lua
local slider = tab:CreateSlider(options)
```

**Options:**
- `Text` (string): Slider label text
- `Min` (number): Minimum value
- `Max` (number): Maximum value  
- `Default` (number): Initial value
- `Callback` (function): Function called with new value

**Example:**
```lua
local mySlider = mainTab:CreateSlider({
    Text = "📊 Volume",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Volume set to:", value)
    end
})

-- Programmatically set slider value
mySlider:Set(75)
```

### **Label Creation**

```lua
local label = tab:CreateLabel(options)
```

**Options:**
- `Text` (string): Label text

**Example:**
```lua
local statusLabel = mainTab:CreateLabel({
    Text = "⚡ Status: Ready"
})

-- Update label text
statusLabel:Set("⚡ Status: Processing...")
```

### **Notifications**

```lua
window:Notify(title, message, type, duration)
```

**Parameters:**
- `title` (string): Notification title
- `message` (string): Notification message
- `type` (string): "success", "warning", "error", or "info"
- `duration` (number): Display duration in seconds

**Example:**
```lua
window:Notify("Success", "Operation completed!", "success", 3)
window:Notify("Warning", "Check your settings!", "warning", 4)
window:Notify("Error", "Something went wrong!", "error", 5)
window:Notify("Info", "Here's some information.", "info", 2)
```

---

## 🎨 **Theme Colors**

The library uses these color values that match your original design:

```lua
Background = Color3.fromRGB(67, 67, 67)      -- Main gray background
Sidebar = Color3.fromRGB(25, 9, 9)           -- Dark red sidebar
Border = Color3.fromRGB(255, 0, 0)           -- Bright red borders
TextPrimary = Color3.fromRGB(255, 255, 255)  -- White text
AccentRed = Color3.fromRGB(255, 50, 50)      -- Bright accent red
```

---

## 🖼️ **Available Assets**

Your provided asset IDs are integrated:

```lua
["add"] = "rbxassetid://14368300605"      -- Plus/Add icon
["alert"] = "rbxassetid://14368301329"    -- Alert/Warning icon
```

Additional icons added for completeness:
```lua
["home"] = "rbxassetid://14368292698"     -- Home icon
["settings"] = "rbxassetid://14368293672" -- Settings icon
["close"] = "rbxassetid://14368294239"    -- Close X icon
["minimize"] = "rbxassetid://14368295058" -- Minimize icon
```

---

## 💡 **Complete Example**

```lua
-- Load the library
local RedThemeLib = loadstring(game:HttpGet("your-script-url"))()

-- Create main window
local window = RedThemeLib:CreateWindow({
    Title = "🔥 My Application",
    Size = UDim2.new(0, 500, 0, 400)
})

-- Create main tab
local mainTab = window:CreateTab({
    Name = "Main",
    Icon = "rbxassetid://14368292698"
})

-- Add a status label
local statusLabel = mainTab:CreateLabel({
    Text = "⚡ Status: Idle"
})

-- Add a button
mainTab:CreateButton({
    Text = "🚀 Start Process",
    Callback = function()
        statusLabel:Set("⚡ Status: Running...")
        window:Notify("Started", "Process has been started!", "success", 3)
        
        -- Simulate some work
        wait(2)
        statusLabel:Set("⚡ Status: Complete")
        window:Notify("Complete", "Process finished successfully!", "success", 3)
    end
})

-- Add a toggle
local autoModeToggle = mainTab:CreateToggle({
    Text = "🔄 Auto Mode",
    Default = false,
    Callback = function(enabled)
        if enabled then
            statusLabel:Set("⚡ Status: Auto Mode ON")
        else
            statusLabel:Set("⚡ Status: Manual Mode")
        end
    end
})

-- Add a slider
mainTab:CreateSlider({
    Text = "🎯 Speed",
    Min = 1,
    Max = 10,
    Default = 5,
    Callback = function(speed)
        window:Notify("Speed Changed", "Speed set to: " .. speed, "info", 2)
    end
})

-- Create settings tab
local settingsTab = window:CreateTab({
    Name = "Settings",
    Icon = "rbxassetid://14368293672"
})

settingsTab:CreateLabel({
    Text = "⚙️ Application Settings"
})

settingsTab:CreateButton({
    Text = "💾 Save Settings",
    Callback = function()
        window:Notify("Saved", "Settings saved successfully!", "success", 2)
    end
})
```

---

## 🔧 **Customization**

### Modifying Colors
You can modify the theme colors by editing the `Theme` table in the library:

```lua
-- In RedTheme-GUI-Library.lua
local Theme = {
    Background = Color3.fromRGB(67, 67, 67),      -- Change main background
    Sidebar = Color3.fromRGB(25, 9, 9),           -- Change sidebar color
    Border = Color3.fromRGB(255, 0, 0),           -- Change border color
    -- ... other colors
}
```

### Adding Custom Assets
Add your own asset IDs to the `Assets` table:

```lua
local Assets = {
    ["add"] = "rbxassetid://14368300605",
    ["alert"] = "rbxassetid://14368301329",
    ["my_custom_icon"] = "rbxassetid://your-asset-id",
}
```

---

## 🐛 **Troubleshooting**

### Common Issues

1. **GUI not showing**: Make sure the library loaded correctly
2. **Assets not loading**: Check that asset IDs are valid
3. **Animations stuttering**: Disable animations in config if needed
4. **Blur not working**: Some games restrict lighting effects

### Debug Mode
Enable debug mode for additional console output:

```lua
-- In the library configuration
local Config = {
    DebugMode = true, -- Enable debug output
    -- ... other config options
}
```

---

## 📋 **Requirements**

- ✅ Roblox Studio or Roblox Game
- ✅ LocalScript execution environment
- ✅ Access to PlayerGui
- ✅ Internet connection (for remote loading)

---

## 🎉 **Conclusion**

This Red Theme GUI Library provides all the functionality you need to create professional-looking interfaces with the red theme you love. The library is designed to be easy to use while providing powerful customization options.

**Key Benefits:**
- ✨ Professional appearance matching your design
- 🚀 Easy to implement and use
- 🎨 Consistent red theme throughout
- 📱 Responsive and smooth animations
- 🔧 Highly customizable
- 💾 Includes your original asset integration

For more advanced usage or custom modifications, refer to the library source code or create additional wrapper functions around the core API.

**Happy coding with your Red Theme GUI Library! 🔥**
