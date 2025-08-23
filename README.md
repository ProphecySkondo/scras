# Enhanced Discord UI Library v2.0

A significantly improved version of the original Discord UI library for Roblox with modern features and better performance.

## 🚀 Key Improvements

### ✨ **Visual Enhancements**
- **Smooth Animations** - Hardware-accelerated TweenService animations
- **Material Design Ripples** - Click effects on interactive elements  
- **Modern UI Design** - Rounded corners, shadows, and consistent theming
- **Dual Themes** - Dark (default) and Light themes included
- **Better Typography** - Improved fonts and text hierarchy

### ⚡ **Performance & Technical**
- **Memory Management** - Proper cleanup and connection handling
- **Optimized Rendering** - Reduced GUI element overhead
- **Error Handling** - Safe function calls with pcall()
- **Auto-Save System** - Automatically saves user preferences
- **Mobile Support** - Touch-friendly interactions

### 🎛️ **Enhanced Components**
- **Improved Sliders** - Better visual feedback and interaction
- **Animated Toggles** - Smooth switch animations
- **Enhanced Dropdowns** - Smooth expand/collapse with hover effects
- **Color Picker** - Simple color selection component
- **Better Notifications** - Modern notification system

## 📦 Installation & Usage

```lua
-- Load the library
local DiscordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ProphecySkondo/scras/main/discord-lib.lua"))()

-- Create a window
local win = DiscordLib:Window("Enhanced Discord Library")

-- Create a server
local server = win:Server("Main Server", "rbxassetid://6031075938") 

-- Create a channel
local channel = server:Channel("General")

-- Add components
channel:Button("Test Button", function()
    print("Button clicked!")
    DiscordLib:Notification("Success", "Button was clicked!", "Cool!")
end)

channel:Toggle("Auto Farm", false, function(state)
    print("Auto Farm:", state)
end)

channel:Slider("Walk Speed", 16, 100, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

local dropdown = channel:Dropdown("Select Option", {"Option 1", "Option 2", "Option 3"}, function(option)
    print("Selected:", option)
end)

channel:Textbox("Username", "Enter your username...", false, function(text)
    print("Username:", text)
end)

channel:Colorpicker("ESP Color", Color3.fromRGB(255, 0, 0), function(color)
    print("Color changed to:", color)
end)

channel:Label("This is a label")
channel:Seperator()
```

## 🎨 Themes

The library includes built-in Dark and Light themes. You can easily switch themes by modifying the `Config.DefaultTheme` in the library file.

### Dark Theme (Default)
- Background: `#202225`
- Accent: `#7289da`
- Text: `#ffffff`

### Light Theme  
- Background: `#ffffff`
- Accent: `#5865f2`
- Text: `#202225`

## 🆚 Original vs Enhanced

| Feature | Original | Enhanced |
|---------|----------|----------|
| Animations | Basic | Smooth & Hardware-accelerated |
| Themes | None | Dark/Light + Customizable |
| Performance | Standard | Optimized + Memory managed |
| Mobile Support | Limited | Full touch support |
| Components | 8 basic | 10+ with enhanced features |
| Error Handling | Basic | Comprehensive with pcall |
| Auto-Save | None | Automatic preference saving |
| UI Polish | Minimal | Material design inspired |

## 🔧 Advanced Features

### Auto-Save System
Automatically saves:
- User profile (name, avatar, tag)
- Theme preferences  
- Component states
- Custom configurations

### Keyboard Shortcuts
- **Ctrl+F** - Search (placeholder for future feature)
- **Escape** - Close window
- **Drag** - Move window anywhere

### Enhanced Notifications
```lua
DiscordLib:Notification("Title", "Description", "Button Text")
```

### Component Control
Most components return control objects:
```lua
local toggle = channel:Toggle("Feature", false, callback)
toggle:Set(true) -- Programmatically control

local slider = channel:Slider("Value", 0, 100, 50, callback)  
slider:Change(75) -- Set slider value

local dropdown = channel:Dropdown("Pick", {"A", "B"}, callback)
dropdown:Add("C") -- Add option
dropdown:Clear() -- Clear all options
```

## 📱 Mobile Compatibility

- Touch-friendly button sizes
- Responsive layouts  
- Mobile-optimized animations
- Touch gesture support for dragging

## ⚠️ Migration from Original

This library maintains **100% API compatibility** with the original Discord library. Simply replace your loadstring URL and enjoy all the enhancements immediately!

```lua
-- Old
local DiscordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/discord%20lib.txt"))()

-- New  
local DiscordLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ProphecySkondo/scras/main/discord-lib.lua"))()
```

All your existing code will work unchanged while benefiting from improved performance, animations, and visual enhancements.

## 🎯 Configuration

You can customize the library by modifying the `Config` table:

```lua
local Config = {
    AnimationSpeed = 0.3,     -- Animation duration
    DefaultTheme = "Dark",    -- "Dark" or "Light"  
    EnableSounds = true,      -- UI sound effects
    EnableParticles = true,   -- Ripple effects
    AutoSave = true,          -- Auto-save preferences
    MaxTooltipWidth = 200,    -- Tooltip width limit
    DebugMode = false         -- Debug logging
}
```

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly  
5. Submit a pull request

## 📄 License

This enhanced version maintains compatibility with the original while adding significant improvements. Use responsibly and respect Roblox's Terms of Service.

## 🙏 Credits

- **Original Discord Library** by dawid-scripts
- **Enhanced Version** with modern improvements
- **Material Design** principles for animations
- **Community feedback** and suggestions

---

⭐ **Star this repo if you find it useful!**

**Raw URL:** `https://raw.githubusercontent.com/ProphecySkondo/scras/main/discord-lib.lua`
