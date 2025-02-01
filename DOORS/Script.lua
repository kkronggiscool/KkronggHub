-- Load Orion Library (Your Provided Version)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

-- Services
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- Variables
local FullbrightEnabled = false
local InstantPromptEnabled = false
local PromptConnection

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

-- Orion UI
local Window = OrionLib:MakeWindow({Name = "Instant Interact", HidePremium = false, SaveConfig = true, ConfigFolder = "InstantInteractConfig"})

-- Fullbright Toggle
Window:MakeTab("Visuals", {Icon = "rbxassetid://4483345998"}):AddToggle({
    Name = "Fullbright",
    Default = false,
    Callback = toggleFullbright
})

-- Instant Proximity Prompt Toggle
Window:MakeTab("Gameplay", {Icon = "rbxassetid://4483345998"}):AddToggle({
    Name = "Instant Proximity Prompts",
    Default = false,
    Callback = toggleInstantPrompts
})

-- Finalize UI
OrionLib:Init()
