-- Load Orion Library (Your Provided Version)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

-- Services
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- Variables
local FullbrightEnabled = false
local InstantPromptEnabled = false
local PromptConnection

-- Fullbright Script Integration (Your Provided Fullbright Script)
if not _G.FullBrightExecuted then
    _G.FullBrightEnabled = false

    _G.NormalLightingSettings = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        FogEnd = Lighting.FogEnd,
        GlobalShadows = Lighting.GlobalShadows,
        Ambient = Lighting.Ambient
    }

    Lighting:GetPropertyChangedSignal("Brightness"):Connect(function()
        if Lighting.Brightness ~= 1 and Lighting.Brightness ~= _G.NormalLightingSettings.Brightness then
            _G.NormalLightingSettings.Brightness = Lighting.Brightness
            if not _G.FullBrightEnabled then
                repeat wait() until _G.FullBrightEnabled
            end
            Lighting.Brightness = 1
        end
    end)

    Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
        if Lighting.ClockTime ~= 12 and Lighting.ClockTime ~= _G.NormalLightingSettings.ClockTime then
            _G.NormalLightingSettings.ClockTime = Lighting.ClockTime
            if not _G.FullBrightEnabled then
                repeat wait() until _G.FullBrightEnabled
            end
            Lighting.ClockTime = 12
        end
    end)

    Lighting:GetPropertyChangedSignal("FogEnd"):Connect(function()
        if Lighting.FogEnd ~= 786543 and Lighting.FogEnd ~= _G.NormalLightingSettings.FogEnd then
            _G.NormalLightingSettings.FogEnd = Lighting.FogEnd
            if not _G.FullBrightEnabled then
                repeat wait() until _G.FullBrightEnabled
            end
            Lighting.FogEnd = 786543
        end
    end)

    Lighting:GetPropertyChangedSignal("GlobalShadows"):Connect(function()
        if Lighting.GlobalShadows ~= false and Lighting.GlobalShadows ~= _G.NormalLightingSettings.GlobalShadows then
            _G.NormalLightingSettings.GlobalShadows = Lighting.GlobalShadows
            if not _G.FullBrightEnabled then
                repeat wait() until _G.FullBrightEnabled
            end
            Lighting.GlobalShadows = false
        end
    end)

    Lighting:GetPropertyChangedSignal("Ambient"):Connect(function()
        if Lighting.Ambient ~= Color3.fromRGB(178, 178, 178) and Lighting.Ambient ~= _G.NormalLightingSettings.Ambient then
            _G.NormalLightingSettings.Ambient = Lighting.Ambient
            if not _G.FullBrightEnabled then
                repeat wait() until _G.FullBrightEnabled
            end
            Lighting.Ambient = Color3.fromRGB(178, 178, 178)
        end
    end)

    Lighting.Brightness = 1
    Lighting.ClockTime = 12
    Lighting.FogEnd = 786543
    Lighting.GlobalShadows = false
    Lighting.Ambient = Color3.fromRGB(178, 178, 178)

    local LatestValue = true
    spawn(function()
        repeat wait() until _G.FullBrightEnabled
        while wait() do
            if _G.FullBrightEnabled ~= LatestValue then
                if not _G.FullBrightEnabled then
                    Lighting.Brightness = _G.NormalLightingSettings.Brightness
                    Lighting.ClockTime = _G.NormalLightingSettings.ClockTime
                    Lighting.FogEnd = _G.NormalLightingSettings.FogEnd
                    Lighting.GlobalShadows = _G.NormalLightingSettings.GlobalShadows
                    Lighting.Ambient = _G.NormalLightingSettings.Ambient
                else
                    Lighting.Brightness = 1
                    Lighting.ClockTime = 12
                    Lighting.FogEnd = 786543
                    Lighting.GlobalShadows = false
                    Lighting.Ambient = Color3.fromRGB(178, 178, 178)
                end
                LatestValue = not LatestValue
            end
        end
    end)
end

_G.FullBrightExecuted = true
_G.FullBrightEnabled = not _G.FullBrightEnabled


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
    Default = false,
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

-- Finalize the UI Initialization
OrionLib:Init()
