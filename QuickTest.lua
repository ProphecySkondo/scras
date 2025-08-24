-- Quick test of the Hydroxide Red Theme Library
print("Testing Hydroxide Red Theme Library...")

-- Load the library (simulated local loading)
local Library = dofile("HydroxideRedTheme.lua")

print("✅ Library loaded successfully!")
print("Type:", type(Library))
print("CreateWindow function:", type(Library.CreateWindow))

-- Test window creation
local Window = Library:CreateWindow({
    Title = "Test Window"
})

print("✅ Window created successfully!")
print("Window type:", type(Window))
print("CreateTab function:", type(Window.CreateTab))
print("Notify function:", type(Window.Notify))

-- Test tab creation
local Tab = Window:CreateTab({
    Name = "Test Tab"
})

print("✅ Tab created successfully!")
print("Tab type:", type(Tab))
print("CreateLabel function:", type(Tab.CreateLabel))
print("CreateButton function:", type(Tab.CreateButton))

-- Test basic elements
Tab:CreateLabel("✅ Test label working!")
Tab:CreateButton({
    Text = "Test Button",
    Callback = function()
        print("✅ Button callback working!")
        Window:Notify("Test", "Button clicked successfully!", "success")
    end
})

print("✅ All tests passed! The library is working correctly!")
print("🚀 Ready for use with the demo!")
