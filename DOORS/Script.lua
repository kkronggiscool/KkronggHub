-- Load Orion Library (Ensure it's loaded properly before using)
local success, OrionLib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
end)

if not success or not OrionLib then
    warn("Failed to load Orion Library!")
    return
end

-- Services
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- Variables
local FullbrightEnabled = false
local InstantPromptEnabled = false

-- Function to toggle Fullbright
local function toggleFullbright(state)
    FullbrightEnabled = state
    if state then
        Lighting.Brightness = 5
        Lighting.ExposureCompensation = 2
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    else
        Lighting.Brightness = 1
        Lighting.ExposureCompensation = 0
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
    end
end

-- Function to modify Proximity Prompts
local function makeInstant(prompt)
    if prompt and prompt:IsA("ProximityPrompt") and prompt.HoldDuration > 0 then
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

        -- Connect to new prompts only once
        if not _G.InstantPromptConnection then
            _G.InstantPromptConnection = Workspace.DescendantAdded:Connect(function(descendant)
                if InstantPromptEnabled and descendant:IsA("ProximityPrompt") then
                    makeInstant(descendant)
                end
            end)
        end
    else
        -- Disconnect event if toggled off
        if _G.InstantPromptConnection then
            _G.InstantPromptConnection:Disconnect()
            _G.InstantPromptConnection = nil
        end
    end
end

-- Orion UI
local Window = OrionLib:MakeWindow({Name = "Instant Interact", HidePremium = false, SaveConfig = true, ConfigFolder = "InstantInteractConfig"})

-- Fullbright Toggle
Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
}):AddToggle({
    Name = "Fullbright",
    Default = false,
    Callback = function(state)
        toggleFullbright(state)
    end
})

-- Instant Proximity Prompt Toggle
Window:MakeTab({
    Name = "Gameplay",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
}):AddToggle({
    Name = "Instant Proximity Prompts",
    Default = false,
    Callback = function(state)
        toggleInstantPrompts(state)
    end
})

-- Finalize UI
OrionLib:Init()
