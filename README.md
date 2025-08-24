# Nova Hydroxide GUI Library

A premium Roblox GUI library inspired by Nova Hub, featuring a fully black theme with elegant red borders and smooth animations. This library provides a professional, clean interface for your Roblox exploiting needs.

## Features

✨ **Modern Design**
- Pure black backgrounds with red accent borders
- Smooth animations and transitions
- Professional Nova-inspired styling
- Rounded corners and clean typography

🎮 **Complete Widget Set**
- Buttons with descriptions
- Toggle switches with smooth animations
- Sliders with real-time value updates
- Section headers for organization
- Notification system

🔧 **Advanced Functionality**
- Blur effect when GUI is open
- Draggable interface
- Right Shift toggle keybind
- Sound effects
- Auto-sizing scrollable content

## Quick Start

```lua
-- Load the library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ProphecySkondo/scras/main/NovaHydroxide.lua"))()

-- Create a window
local Window = Library:Window("My Script Hub")

-- Create a tab
local MainTab = Window:Tab("Main", "rbxassetid://icon_id")

-- Add elements
MainTab:Section("Features")
MainTab:Button("Click Me", "This button does something cool", function()
    print("Button clicked!")
end)

MainTab:Toggle("Enable Feature", "Toggles a feature on/off", false, function(value)
    print("Toggle:", value)
end)

MainTab:Slider("Speed", "Adjust movement speed", 0, 100, 50, function(value)
    print("Slider value:", value)
end)
```

## API Documentation

### Window Creation

```lua
local Window = Library:Window(title)
```

Creates a new GUI window with the specified title.

**Parameters:**
- `title` (string): The title displayed in the window header

**Returns:**
- Window object with methods for creating tabs and showing notifications

### Window Methods

#### Toggle
```lua
Window:Toggle()
```
Shows/hides the GUI window. Can also be triggered with Right Shift key.

#### Notification
```lua
Window:Notification(title, text, type, duration)
```
Displays a notification popup.

**Parameters:**
- `title` (string): Notification title
- `text` (string): Notification message
- `type` (string): Notification type ("Info", "Success", "Warning", "Error")
- `duration` (number): How long to show the notification (seconds)

#### Tab
```lua
local Tab = Window:Tab(name, icon)
```
Creates a new tab in the window.

**Parameters:**
- `name` (string): Tab display name
- `icon` (string): Roblox asset ID for tab icon

**Returns:**
- Tab object with methods for adding elements

### Tab Methods

#### Section
```lua
Tab:Section(text)
```
Adds a section header for organizing elements.

**Parameters:**
- `text` (string): Section title

#### Button
```lua
Tab:Button(text, desc, callback)
```
Adds a clickable button.

**Parameters:**
- `text` (string): Button label
- `desc` (string): Button description
- `callback` (function): Function to execute when clicked

#### Toggle
```lua
Tab:Toggle(text, desc, default, callback)
```
Adds a toggle switch.

**Parameters:**
- `text` (string): Toggle label
- `desc` (string): Toggle description
- `default` (boolean): Initial state
- `callback` (function): Function called with new state

#### Slider
```lua
Tab:Slider(text, desc, min, max, default, callback)
```
Adds a value slider.

**Parameters:**
- `text` (string): Slider label
- `desc` (string): Slider description
- `min` (number): Minimum value
- `max` (number): Maximum value
- `default` (number): Initial value
- `callback` (function): Function called with new value

## Styling

The library uses a consistent color scheme:

- **Primary Background**: RGB(0, 0, 0) - Pure black
- **Secondary Background**: RGB(24, 24, 24) - Dark gray
- **Border Color**: RGB(220, 50, 60) - Red accent
- **Active Color**: RGB(78, 0, 121) - Purple accent
- **Text Color**: RGB(255, 255, 255) - White
- **Description Text**: RGB(138, 138, 138) - Gray

## Controls

- **Right Shift**: Toggle GUI visibility
- **Mouse Drag**: Move the window around
- **Scroll Wheel**: Navigate through tab content

## Example Usage

Check out `ExampleUsage.lua` for a complete example showing all available features and how to implement common scripting functionalities.

## Requirements

- Roblox exploit with `loadstring` and `HttpGet` support
- Modern executor with CoreGui access

## Contributing

This library is designed to be clean, professional, and hook-free. When contributing:

1. Maintain the Nova-inspired styling
2. No exploitative hooks or metamethods
3. Clean, readable code with proper documentation
4. Consistent color scheme and animations

## License

This project is open source. Feel free to use, modify, and distribute as needed.

---

**Created with ❤️ for the Roblox exploiting community**
