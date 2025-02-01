-- Load Orion Library
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

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

-- Function to make prompts instant
local function makeInstant(prompt)
    if prompt.HoldDuration > 0 then
        prompt.HoldDuration = 0
    end
end

-- Function to toggle Instant Proximity Prompts
local function toggleInstantPrompts(state)
    InstantPromptEnabled = state

    if state then
        -- Modify all existing prompts
        for _, prompt in ipairs(Workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                makeInstant(prompt)
            end
        end

        -- Listen for new Proximity Prompts
        Workspace.DescendantAdded:Connect(function(descendant)
            if InstantPromptEnabled and descendant:IsA("ProximityPrompt") then
                makeInstant(descendant)
            end
        end)
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
    Callback = toggleFullbright
})

-- Instant Proximity Prompt Toggle
Window:MakeTab({
    Name = "Gameplay",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
}):AddToggle({
    Name = "Instant Proximity Prompts",
    Default = false,
    Callback = toggleInstantPrompts
})

-- Finalize UI
OrionLib:Init()
