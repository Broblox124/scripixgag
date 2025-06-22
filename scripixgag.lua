-- Scripix ver 1.0.0 for Grow a Garden
-- Simplified GUI script to test logo and panel
-- Created for Roblox Luau, compatible with Summer Update (June 22, 2025)

-- Services
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

-- Local player
local player = Players.LocalPlayer
local playerGui = player.PlayerGui

-- Configuration
local CONFIG = {
    LogoImageId = "rbxassetid://188078643" -- Fallback Roblox logo; replace with your rbxassetid
}

-- Debug print
print("Scripix script started!")

-- GUI Setup
local function createGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ScripixGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    print("ScreenGui created!")

    -- Logo (small square, toggles panel)
    local logo = Instance.new("ImageButton")
    logo.Size = UDim2.new(0, 50, 0, 50)
    logo.Position = UDim2.new(0, 10, 0, 10)
    logo.Image = CONFIG.LogoImageId
    logo.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red background to make logo visible if image fails
    logo.Parent = screenGui
    print("Logo created!")

    -- Main panel (hidden by default)
    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(0, 300, 0, 400)
    panel.Position = UDim2.new(0.5, -150, 0.5, -200)
    panel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    panel.BorderSizePixel = 2
    panel.Visible = false
    panel.Parent = screenGui

    -- Panel title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 30)
    title.Position = UDim2.new(0, 20, 0, 10)
    title.Text = "Scripix ver 1.0.0"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20
    title.Parent = panel

    -- Minimize button
    local minimize = Instance.new("TextButton")
    minimize.Size = UDim2.new(0, 30, 0, 30)
    minimize.Position = UDim2.new(1, -40, 0, 10)
    minimize.Text = "-"
    minimize.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimize.Parent = panel
    print("Panel created!")

    return screenGui, logo, panel, minimize
end

-- Main script
local function main()
    local screenGui, logo, panel, minimize = createGui()

    -- Toggle panel via logo
    logo.MouseButton1Click:Connect(function()
        panel.Visible = not panel.Visible
        print("Logo clicked, panel visibility: " .. tostring(panel.Visible))
    end)

    -- Minimize button
    minimize.MouseButton1Click:Connect(function()
        panel.Visible = false
        print("Minimize clicked")
    end)

    -- Notify player
    StarterGui:SetCore("SendNotification", {
        Title = "Scripix ver 1.0.0",
        Text = "Script loaded! Click the red square/logo to open the panel.",
        Duration = 5
    })
    print("Notification sent!")
end

-- Error handling
local success, err = pcall(main)
if not success then
    warn("Error in script: " .. err)
    StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Script failed: " .. err,
        Duration = 10
    })
    print("Error: " .. err)
end
