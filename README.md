# 🚀 Hydroxide Hub V2.0 - Professional Gaming Hub

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Lua](https://img.shields.io/badge/Language-Lua-blue.svg)](https://www.lua.org/)
[![Roblox](https://img.shields.io/badge/Platform-Roblox-red.svg)](https://www.roblox.com/)

> **🎯 A professional, Nova-inspired GUI library for Roblox with enhanced features, sleek animations, and zero exploitative methods.**

## ✨ Features

### 🎨 **Visual Excellence**
- **100% Black Theme** with striking red borders (1-2px)
- **Professional Animations** with smooth blur effects (8px)
- **Rounded Corners** throughout (8-12px radius)
- **Modern UI Elements** with hover effects and transitions
- **Top-Right Notifications** with fade animations
- **Draggable Windows** with smooth positioning

### ⚡ **Advanced Functionality**
- **RShift Toggle** for easy GUI access
- **Smart Auto-Sizing** for content and scrolling areas
- **Professional Notification System** (success/warning/error/info)
- **Memory Efficient** with proper cleanup functions
- **No Hooks/Metamethods** - completely secure and clean

### 🛠️ **UI Components**
- ✅ **Buttons** with click animations
- ✅ **Toggles** with smooth transitions
- ✅ **Sliders** with real-time value updates
- ✅ **Textboxes** with focus states
- ✅ **Keybinds** with listening mode
- ✅ **Sections** for organization
- ✅ **Separators** for visual breaks

## 📦 Installation

### Method 1: Direct Load (Recommended)
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ProphecySkondo/scras/main/HydroxideHubV2.lua"))()
```

### Method 2: Local File
1. Download `HydroxideHubV2.lua`
2. Place it in your executor's workspace
3. Load it using:
```lua
local Library = loadstring(readfile("HydroxideHubV2.lua"))()
```

## 🚀 Quick Start

### Basic Window Setup
```lua
-- Create the main window
local Window = Library:CreateWindow({
    Title = "My Awesome Hub"
})

-- Create tabs
local MainTab = Window:CreateTab({
    Name = "Main",
    Icon = "⚡"
})
```

### Adding UI Elements
```lua
-- Add a section
MainTab:AddSection("🎯 Main Features")

-- Add a button
MainTab:AddButton({
    Text = "God Mode",
    Description = "Makes you invincible",
    Callback = function()
        -- Your code here
        print("God mode activated!")
    end
})

-- Add a toggle
MainTab:AddToggle({
    Text = "Infinite Jump",
    Description = "Jump infinitely",
    Default = false,
    Callback = function(state)
        print("Infinite jump:", state)
    end
})

-- Add a slider
MainTab:AddSlider({
    Text = "Walk Speed",
    Description = "Change walking speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(value)
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
})
```

## 📖 Complete Example

Check out [`ExampleUsage.lua`](ExampleUsage.lua) for a comprehensive implementation with:
- Multiple tabs (Main, Player, Visual, Misc)
- All UI components demonstrated
- Real working features
- Professional organization

## 🎮 Controls

| Key | Action |
|-----|--------|
| **Right Shift** | Toggle GUI |
| **Drag TopBar** | Move Window |
| **Close Button (×)** | Close GUI |
| **Minimize Button (−)** | Hide/Show GUI |

## 🔧 API Reference

### Window Methods
```lua
Window:CreateTab(config)     -- Create a new tab
Window:Toggle()              -- Show/hide the GUI
Window:Notify(title, desc, type, duration)  -- Show notification
```

### Tab Methods
```lua
Tab:AddSection(title)        -- Add section header
Tab:AddSeparator()           -- Add visual separator
Tab:AddButton(config)        -- Add clickable button
Tab:AddToggle(config)        -- Add on/off toggle
Tab:AddSlider(config)        -- Add value slider
Tab:AddTextbox(config)       -- Add text input
Tab:AddKeybind(config)       -- Add key binding
```

### Configuration Objects

#### Button Config
```lua
{
    Text = "Button Name",
    Description = "What this button does",
    Callback = function() 
        -- Your code here
    end
}
```

#### Toggle Config
```lua
{
    Text = "Toggle Name",
    Description = "What this toggle controls",
    Default = false,
    Callback = function(state)
        -- state is true/false
    end
}
```

#### Slider Config
```lua
{
    Text = "Slider Name",
    Description = "What this controls",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        -- value is the selected number
    end
}
```

#### Textbox Config
```lua
{
    Text = "Textbox Name",
    Description = "What to enter",
    Placeholder = "Enter text...",
    Callback = function(text)
        -- text is what was entered
    end
}
```

#### Keybind Config
```lua
{
    Text = "Keybind Name",
    Description = "What this key does",
    Default = Enum.KeyCode.F,
    Callback = function()
        -- Triggered when key is pressed
    end
}
```

## 🎨 Theme Customization

The theme can be customized by modifying the `Theme` table:

```lua
local Theme = {
    -- Main Colors
    Background = Color3.fromRGB(0, 0, 0),
    Sidebar = Color3.fromRGB(0, 0, 0),
    Content = Color3.fromRGB(0, 0, 0),
    
    -- Accent Colors  
    Primary = Color3.fromRGB(220, 50, 60),
    Secondary = Color3.fromRGB(240, 70, 80),
    
    -- Text Colors
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 180),
    
    -- Status Colors
    Success = Color3.fromRGB(72, 187, 120),
    Warning = Color3.fromRGB(245, 158, 11),
    Error = Color3.fromRGB(239, 68, 68),
    Info = Color3.fromRGB(59, 130, 246)
}
```

## 🔍 Notifications

Show different types of notifications:

```lua
-- Success notification (green)
Window:Notify("Success", "Operation completed!", "success", 3)

-- Warning notification (yellow) 
Window:Notify("Warning", "Be careful!", "warning", 4)

-- Error notification (red)
Window:Notify("Error", "Something went wrong!", "error", 5)

-- Info notification (blue)
Window:Notify("Info", "Useful information", "info", 3)
```

## 💡 Best Practices

### 🎯 Organization
- Use **sections** to group related features
- Add **separators** between different feature groups
- Use descriptive names and descriptions
- Organize tabs logically (Main, Player, Visual, Misc, etc.)

### 🔧 Performance
- Avoid creating too many GUI elements at once
- Use callbacks efficiently (don't spam operations)
- Clean up connections when not needed
- Test with different screen resolutions

### 🎨 User Experience
- Provide clear descriptions for all elements
- Use appropriate default values
- Give immediate feedback through notifications
- Keep the interface intuitive and clean

## 🆚 Comparison with Other Libraries

| Feature | Hydroxide V2 | Nova Hub | Venyx |
|---------|-------------|----------|-------|
| **Security** | ✅ No hooks | ❌ Uses hooks | ✅ Clean |
| **Animations** | ✅ Advanced | ⚠️ Basic | ✅ Good |
| **Theme** | ✅ Professional | ⚠️ Outdated | ✅ Modern |
| **Documentation** | ✅ Complete | ❌ Limited | ⚠️ Basic |
| **Customization** | ✅ Extensive | ❌ Limited | ⚠️ Moderate |
| **Performance** | ✅ Optimized | ⚠️ Heavy | ✅ Good |

## 🛠️ Troubleshooting

### Common Issues

**GUI doesn't appear:**
- Make sure you're using the correct load method
- Check that the script executed without errors
- Try pressing Right Shift to toggle

**Elements not working:**
- Verify your callback functions are correct
- Check the console for error messages
- Ensure you're using the right parameter names

**Performance issues:**
- Reduce the number of simultaneous operations
- Avoid creating too many elements
- Check for infinite loops in callbacks

### Support

If you encounter issues:
1. Check the console for error messages
2. Verify your implementation against the examples
3. Make sure you're using the latest version
4. Test in a clean environment

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to:
- Report bugs
- Suggest features
- Submit pull requests
- Improve documentation

## 🎉 Credits

- **Inspired by**: Nova Hub (improved and enhanced)
- **Design Elements**: Venyx UI Library
- **Created by**: @uniquadev
- **Enhanced for**: Professional gaming environments

---

### 🌟 **Ready to create amazing GUIs? Get started with Hydroxide Hub V2.0 today!**

```lua
-- Quick start - Copy and paste this to get started immediately!
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ProphecySkondo/scras/main/HydroxideHubV2.lua"))()
local Window = Library:CreateWindow({Title = "My Hub"})
local Tab = Window:CreateTab({Name = "Main", Icon = "⚡"})

Tab:AddButton({
    Text = "Hello World", 
    Description = "Click me!",
    Callback = function()
        Window:Notify("Hello", "Welcome to Hydroxide Hub V2.0!", "success")
    end
})
```
