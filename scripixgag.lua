-- Scripix ver 1.0.0 for Grow a Garden
-- Simplified GUI script to test logo and panel
-- Created for Roblox Luau, compatible with Summer Update (June 22, 2025)
-- Hostable on GitHub for loadstring

-- Services
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

-- Local player
local player = Players.LocalPlayer
local playerGui = player.PlayerGui

-- Configuration
local CONFIG = {
    LogoImageId = "rbxassetid://99764942615873", -- NatHub's icon as fallback; replace with your logo's rbxassetid
    GameId = 7436755782 -- Grow a Garden's GameId
}

-- Debug print
print("Scripix script started! GameId: " .. tostring(game.GameId))

-- Verify game
if game.GameId ~= CONFIG.GameId then
    StarterGui:SetCore("SendNotification", {
        Title = "Scripix Error",
        Text = "This script is for Grow a Garden only!",
        Duration = 10
    })
    print("Wrong game! Expected GameId: " .. CONFIG.GameId .. ", Got: " .. game.GameId)
    return
end

-- GUI Setup
local function createGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ScripixGui"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui
    print("ScreenGui created and parented to PlayerGui")

    -- Logo (small square, toggles panel)
    local logo = Instance.new("ImageButton")
    logo.Size = UDim2.new(0, 50, 0, 50)
    logo.Position = UDim2.new(0, 10, 0, 10)
    logo.Image = CONFIG.LogoImageId
    logo.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red background for visibility
    logo.Parent = screenGui
    print("Logo created with ImageId: " .. CONFIG.LogoImageId)

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
    print("Panel and components created")

    return screenGui, logo, panel, minimize
end

-- Main script
local function main()
    -- Verify PlayerGui
    if not playerGui then
        print("PlayerGui not found!")
        StarterGui:SetCore("SendNotification", {
            Title = "Scripix Error",
            Text = "PlayerGui not found. Try again later.",
            Duration = 10
        })
        return
    end

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
        Icon = CONFIG.LogoImageId,
        Duration = 5
    })
    print("Notification sent!")
end

-- Error handling
local success, err = pcall(main)
if not success then
    warn("Error in script: " .. err)
    StarterGui:SetCore("SendNotification", {
        Title = "Scripix Error",
        Text = "Script failed: " .. err,
        Icon = CONFIG.LogoImageId,
        Duration = 10
    })
    print("Error: " .. err)
end
