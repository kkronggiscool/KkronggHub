--[[ 
______   _______  _______  _______  _______             _______ _________ _______  _         
(  __  \ (  ___  )(  ___  )(  ____ )(  ____ \  |\     /|(  ___  )\__   __/(  ____ \( \       
| (  \  )| (   ) || (   ) || (    )|| (    \/  | )   ( || (   ) |   ) (   | (    \/| (       
| |   ) || |   | || |   | || (____)|| (_____   | (___) || |   | |   | |   | (__    | | _____ 
| |   | || |   | || |   | ||     __)(_____  )  |  ___  || |   | |   | |   |  __)   | |(_____)
| |   ) || |   | || |   | || (\ (         ) |  | (   ) || |   | |   | |   | (      | |       
| (__/  )| (___) || (___) || ) \ \__/\____) |  | )   ( || (___) |   | |   | (____/\| (____/\ 
(______/ (_______)(_______)|/   \__/\_______)  |/     \|(_______)   )_(   (_______/(_______/ 
                                                                                             
-- made by kkrongg!
]]

-- Load Orion Library (Your Provided Version)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

-- Services
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- PlaceId Validation
if game.PlaceId ~= 110258689672367 then
    print("Please execute this script in DOORS Hotel- or this script won't work.")
    return
end

-- Variables
local FullbrightEnabled = false
local InstantPromptEnabled = false
local PromptConnection
local NoClipEnabled = false
local WalkSpeed = 16
local FOV = 70

-- Fullbright Script Integration (Your Provided Fullbright Script)
if not _G.FullBrightExecuted then
    _G.FullBrightEnabled = true

    _G.NormalLightingSettings = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd,
        GlobalShadows = Lighting.GlobalShadows,
        Ambient = Lighting.Ambient
    }

    -- Fullbright Logic
    Lighting.Brightness = 1
    Lighting.ClockTime = 12
    Lighting.FogEnd = 786543
    Lighting.GlobalShadows = false
    Lighting.Ambient = Color3.fromRGB(178, 178, 178)

    spawn(function()
        repeat wait() until _G.FullBrightEnabled
        while wait() do
            if _G.FullBrightEnabled then
                Lighting.Brightness = 1
                Lighting.ClockTime = 12
                Lighting.FogEnd = 786543
                Lighting.GlobalShadows = false
                Lighting.Ambient = Color3.fromRGB(178, 178, 178)
            else
                Lighting.Brightness = _G.NormalLightingSettings.Brightness
                Lighting.ClockTime = _G.NormalLightingSettings.ClockTime
                Lighting.FogEnd = _G.NormalLightingSettings.FogEnd
                Lighting.GlobalShadows = _G.NormalLightingSettings.GlobalShadows
                Lighting.Ambient = _G.NormalLightingSettings.Ambient
            end
        end
    end)
end

-- Function to modify Proximity Prompts
local function makeInstant(prompt)
    if prompt and prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = 0
    end
end

-- Function to toggle Instant Proximity Prompts
local function toggleInstantPrompts(state)
    InstantPromptEnabled = state

    if state then
        -- Modify all existing prompts
        for _, prompt in ipairs(Workspace:GetDescendants()) do
            makeInstant(prompt)
        end

        -- Connect to new prompts (only once)
        if not PromptConnection then
            PromptConnection = Workspace.DescendantAdded:Connect(function(descendant)
                if InstantPromptEnabled and descendant:IsA("ProximityPrompt") then
                    makeInstant(descendant)
                end
            end)
        end
    else
        -- Disconnect event if toggled off
        if PromptConnection then
            PromptConnection:Disconnect()
            PromptConnection = nil
        end
    end
end

-- Player Tweaks (FOV, Walkspeed, NoClip)
local function setWalkSpeed(speed)
    WalkSpeed = speed
    -- Constantly set the WalkSpeed in a loop to bypass anti-cheat
    spawn(function()
        while true do
            wait(0.1)  -- Set a short wait to not overwhelm the server
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeed
            end
        end
    end)
end

local function setFOV(fov)
    game:GetService("Workspace").CurrentCamera.FieldOfView = fov
end

local function enableNoClip(state)
    NoClipEnabled = state
    if state then
        for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    else
        for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Create Orion Window (KkronggHub (DOORS))
local Window = OrionLib:MakeWindow({
    Name = "KkronggHub (DOORS)",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "InstantInteractConfig"
})

-- Create Tabs and Toggle Buttons

-- Visuals Tab
local visualsTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Fullbright Toggle for Visuals Tab
visualsTab:AddToggle({
    Name = "Fullbright",
    Default = true,
    Callback = function(state)
        _G.FullBrightEnabled = state
    end
})

-- Gameplay Tab
local gameplayTab = Window:MakeTab({
    Name = "Gameplay",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Instant Proximity Prompt Toggle for Gameplay Tab
gameplayTab:AddToggle({
    Name = "Instant Interact",
    Default = false,
    Callback = toggleInstantPrompts
})

-- Players Tab
local playersTab = Window:MakeTab({
    Name = "Players",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- FOV Slider
playersTab:AddSlider({
    Name = "Field of View (FOV)",
    Min = 70,
    Max = 120,
    Default = 70,
    Callback = setFOV
})

-- Walkspeed Slider
playersTab:AddSlider({
    Name = "Walkspeed",
    Min = 1,
    Max = 75,
    Default = 16,
    Callback = setWalkSpeed
})

-- NoClip Toggle
playersTab:AddToggle({
    Name = "NoClip",
    Default = false,
    Callback = enableNoClip
})

-- Finalize the UI Initialization
OrionLib:Init()
