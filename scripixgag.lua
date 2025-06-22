-- Scripix ver 1.0.0 for Grow a Garden
-- Auto Farm script with GUI panel
-- Created for Roblox Luau, compatible with Summer Update (June 22, 2025)
-- Hosted on GitHub for loadstring access

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- Local player
local player = Players.LocalPlayer
local playerGui = player.PlayerGui

-- Configuration
local CONFIG = {
    AutoPlant = false,
    AutoSell = false,
    AutoBuy = false,
    SellMode = "Sell fruit in hand", -- Default dropdown option
    TargetSeed = "Carrot", -- Default seed for Auto Buy
    LogoImageId = "rbxassetid://136608071942699" -- Replace with your logo's rbxassetid
}

-- Available seeds (based on Summer Update)
local SEED_OPTIONS = {
    "Carrot",
    "Avocado",
    "Banana",
    "Blueberry",
    "Strawberry",
    "Watermelon",
    "Cactus",
    "Dragon Pepper"
}

-- GUI Setup
local function createGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ScripixGui"
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false

    -- Logo (small square, toggles panel)
    local logo = Instance.new("ImageButton")
    logo.Size = UDim2.new(0, 50, 0, 50)
    logo.Position = UDim2.new(0, 10, 0, 10)
    logo.Image = CONFIG.LogoImageId
    logo.BackgroundTransparency = 1
    logo.Parent = screenGui

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

    -- Auto Farm menu button
    local autoFarmButton = Instance.new("TextButton")
    autoFarmButton.Size = UDim2.new(1, -20, 0, 40)
    autoFarmButton.Position = UDim2.new(0, 10, 0, 50)
    autoFarmButton.Text = "Auto Farm Menu"
    autoFarmButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    autoFarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoFarmButton.Parent = panel

    -- Auto Farm sub-panel (hidden by default)
    local autoFarmPanel = Instance.new("Frame")
    autoFarmPanel.Size = UDim2.new(1, -20, 1, -100)
    autoFarmPanel.Position = UDim2.new(0, 10, 0, 100)
    autoFarmPanel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    autoFarmPanel.Visible = false
    autoFarmPanel.Parent = panel

    -- Auto Plant Seed toggle
    local autoPlantButton = Instance.new("TextButton")
    autoPlantButton.Size = UDim2.new(1, -20, 0, 40)
    autoPlantButton.Position = UDim2.new(0, 10, 0, 10)
    autoPlantButton.Text = "Auto Plant Seed: OFF"
    autoPlantButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    autoPlantButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoPlantButton.Parent = autoFarmPanel

    -- Auto Sell Fruits toggle
    local autoSellButton = Instance.new("TextButton")
    autoSellButton.Size = UDim2.new(1, -20, 0, 40)
    autoSellButton.Position = UDim2.new(0, 10, 0, 60)
    autoSellButton.Text = "Auto Sell Fruits: OFF"
    autoSellButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    autoSellButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoSellButton.Parent = autoFarmPanel

    -- Sell mode dropdown
    local sellDropdown = Instance.new("TextButton")
    sellDropdown.Size = UDim2.new(1, -20, 0, 30)
    sellDropdown.Position = UDim2.new(0, 10, 0, 110)
    sellDropdown.Text = CONFIG.SellMode
    sellDropdown.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    sellDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    sellDropdown.Parent = autoFarmPanel

    local sellDropdownList = Instance.new("Frame")
    sellDropdownList.Size = UDim2.new(1, -20, 0, 60)
    sellDropdownList.Position = UDim2.new(0, 0, 1, 0)
    sellDropdownList.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sellDropdownList.Visible = false
    sellDropdownList.Parent = sellDropdown

    local sellOption1 = Instance.new("TextButton")
    sellOption1.Size = UDim2.new(1, 0, 0, 30)
    sellOption1.Position = UDim2.new(0, 0, 0, 0)
    sellOption1.Text = "Sell fruit in hand"
    sellOption1.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    sellOption1.TextColor3 = Color3.fromRGB(255, 255, 255)
    sellOption1.Parent = sellDropdownList

    local sellOption2 = Instance.new("TextButton")
    sellOption2.Size = UDim2.new(1, 0, 0, 30)
    sellOption2.Position = UDim2.new(0, 0, 0, 30)
    sellOption2.Text = "Sell inventory"
    sellOption2.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    sellOption2.TextColor3 = Color3.fromRGB(255, 255, 255)
    sellOption2.Parent = sellDropdownList

    -- Auto Buy Seed toggle
    local autoBuyButton = Instance.new("TextButton")
    autoBuyButton.Size = UDim2.new(1, -20, 0, 40)
    autoBuyButton.Position = UDim2.new(0, 10, 0, 150)
    autoBuyButton.Text = "Auto Buy Seed: OFF"
    autoBuyButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    autoBuyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoBuyButton.Parent = autoFarmPanel

    -- Seed selection dropdown
    local seedDropdown = Instance.new("TextButton")
    seedDropdown.Size = UDim2.new(1, -20, 0, 30)
    seedDropdown.Position = UDim2.new(0, 10, 0, 200)
    seedDropdown.Text = CONFIG.TargetSeed
    seedDropdown.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    seedDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    seedDropdown.Parent = autoFarmPanel

    local seedDropdownList = Instance.new("Frame")
    seedDropdownList.Size = UDim2.new(1, -20, 0, #SEED_OPTIONS * 30)
    seedDropdownList.Position = UDim2.new(0, 0, 1, 0)
    seedDropdownList.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    seedDropdownList.Visible = false
    seedDropdownList.Parent = seedDropdown

    for i, seed in ipairs(SEED_OPTIONS) do
        local seedOption = Instance.new("TextButton")
        seedOption.Size = UDim2.new(1, 0, 0, 30)
        seedOption.Position = UDim2.new(0, 0, 0, (i-1) * 30)
        seedOption.Text = seed
        seedOption.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        seedOption.TextColor3 = Color3.fromRGB(255, 255, 255)
        seedOption.Parent = seedDropdownList
        seedOption.MouseButton1Click:Connect(function()
            CONFIG.TargetSeed = seed
            seedDropdown.Text = seed
            seedDropdownList.Visible = false
        end)
    end

    return screenGui, logo, panel, minimize, autoFarmButton, autoFarmPanel, autoPlantButton, autoSellButton, sellDropdown, sellDropdownList, autoBuyButton
end

-- Find remote events (hypothetical)
local function findRemotes()
    local remotes = {}
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            if v.Name == "PlantSeed" then
                remotes.PlantSeed = v
            elseif v.Name == "SellFruit" then
                remotes.SellFruit = v
            elseif v.Name == "BuySeed" then
                remotes.BuySeed = v
            end
        end
    end
    return remotes
end

-- Auto Plant Seed logic
local function autoPlant(remotes)
    while CONFIG.AutoPlant do
        -- Check if player is holding a seed (assumes seed in tool or inventory)
        local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
        if tool and remotes.PlantSeed then
            -- Simulate planting at mouse position or nearest plot
            local mouse = player:GetMouse()
            remotes.PlantSeed:FireServer(tool.Name, mouse.Hit.Position)
        end
        wait(0.5) -- Avoid server spam
    end
end

-- Auto Sell Fruits logic
local function autoSell(remotes)
    while CONFIG.AutoSell do
        if remotes.SellFruit then
            if CONFIG.SellMode == "Sell fruit in hand" then
                local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
                if tool then
                    remotes.SellFruit:FireServer(tool.Name)
                end
            elseif CONFIG.SellMode == "Sell inventory" then
                -- Assume inventory is in player.Backpack or a custom storage
                for _, item in pairs(player.Backpack:GetChildren()) do
                    if item:IsA("Tool") then
                        remotes.SellFruit:FireServer(item.Name)
                    end
                end
            end
        end
        wait(1)
    end
end

-- Auto Buy Seed logic
local function autoBuy(remotes)
    while CONFIG.AutoBuy do
        if remotes.BuySeed then
            remotes.BuySeed:FireServer(CONFIG.TargetSeed, 1) -- Buy one seed
        end
        wait(5) -- Align with Seed Shop restock (every 5 minutes)
    end
end

-- Main script
local function main()
    local screenGui, logo, panel, minimize, autoFarmButton, autoFarmPanel, autoPlantButton, autoSellButton, sellDropdown, sellDropdownList, autoBuyButton = createGui()
    local remotes = findRemotes()

    -- Toggle panel via logo
    logo.MouseButton1Click:Connect(function()
        panel.Visible = not panel.Visible
    end)

    -- Minimize button
    minimize.MouseButton1Click:Connect(function()
        panel.Visible = false
    end)

    -- Open Auto Farm menu
    autoFarmButton.MouseButton1Click:Connect(function()
        autoFarmPanel.Visible = not autoFarmPanel.Visible
    end)

    -- Auto Plant toggle
    autoPlantButton.MouseButton1Click:Connect(function()
        CONFIG.AutoPlant = not CONFIG.AutoPlant
        autoPlantButton.Text = "Auto Plant Seed: " .. (CONFIG.AutoPlant and "ON" or "OFF")
        autoPlantButton.BackgroundColor3 = CONFIG.AutoPlant and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        if CONFIG.AutoPlant then
            spawn(function() autoPlant(remotes) end)
        end
    end)

    -- Auto Sell toggle
    autoSellButton.MouseButton1Click:Connect(function()
        CONFIG.AutoSell = not CONFIG.AutoSell
        autoSellButton.Text = "Auto Sell Fruits: " .. (CONFIG.AutoSell and "ON" or "OFF")
        autoSellButton.BackgroundColor3 = CONFIG.AutoSell and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        if CONFIG.AutoSell then
            spawn(function() autoSell(remotes) end)
        end
    end)

    -- Sell dropdown toggle
    sellDropdown.MouseButton1Click:Connect(function()
        sellDropdownList.Visible = not sellDropdownList.Visible
    end)

    -- Sell mode options
    sellDropdownList:GetChildren()[1].MouseButton1Click:Connect(function()
        CONFIG.SellMode = "Sell fruit in hand"
        sellDropdown.Text = CONFIG.SellMode
        sellDropdownList.Visible = false
    end)
    sellDropdownList:GetChildren()[2].MouseButton1Click:Connect(function()
        CONFIG.SellMode = "Sell inventory"
        sellDropdown.Text = CONFIG.SellMode
        sellDropdownList.Visible = false
    end)

    -- Auto Buy toggle
    autoBuyButton.MouseButton1Click:Connect(function()
        CONFIG.AutoBuy = not CONFIG.AutoBuy
        autoBuyButton.Text = "Auto Buy Seed: " .. (CONFIG.AutoBuy and "ON" or "OFF")
        autoBuyButton.BackgroundColor3 = CONFIG.AutoBuy and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        if CONFIG.AutoBuy then
            spawn(function() autoBuy(remotes) end)
        end
    end)

    -- Notify player
    StarterGui:SetCore("SendNotification", {
        Title = "Scripix ver 1.0.0",
        Text = "Script loaded! Click the logo to open the panel.",
        Duration = 5
    })
end

-- Error handling
local success, err = pcall(main)
if not success then
    warn("Error in script: " .. err)
    StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Script failed to load: " .. err,
        Duration = 10
    })
end
