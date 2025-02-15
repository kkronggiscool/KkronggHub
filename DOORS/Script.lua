-- Load Orion Library (Your Provided Version)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

-- Services
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera
local Main_Game = require(game.Players.LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game)

-- Variables
local FullbrightEnabled = false
local InstantPromptEnabled = false
local PromptConnection
local NoClipEnabled = false
local WalkSpeed = 16
local FOV = 70
local FlyEnabled = false
local FlySpeed = 50
local BodyVelocity = nil

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

_G.FullBrightExecuted = true

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

-- Player Tweaks (Walkspeed, NoClip)
local function setWalkSpeed(speed)
    WalkSpeed = speed
    -- Disable acceleration and set walk speed immediately
    spawn(function()
        while true do
            wait(0.1)  -- Update every 0.1 second
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                Humanoid.PlatformStand = true  -- Disable platform acceleration
                Humanoid.WalkSpeed = WalkSpeed  -- Keep walk speed constant
            end
        end
    end)
end

-- Function to toggle Fly (based on Camera direction)
local function toggleFly(state)
    FlyEnabled = state
    if state then
        -- Create BodyVelocity and attach it to HumanoidRootPart
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)  -- Allow movement in all directions
        BodyVelocity.Velocity = Vector3.zero  -- Initialize with zero velocity
        BodyVelocity.Parent = Character:WaitForChild("HumanoidRootPart")

        -- Update velocity on each Heartbeat (smoother than wait)
        local connection
        connection = RunService.Heartbeat:Connect(function()
            if FlyEnabled and BodyVelocity and Character:FindFirstChild("HumanoidRootPart") then
                -- Calculate movement direction based on camera direction
                local cameraDirection = Camera.CFrame.LookVector * FlySpeed  -- Forward movement
                local verticalDirection = Vector3.new(0, 0, 0)              -- Default no vertical movement
                
                -- Example: Add a condition to modify vertical movement (optional)
                if UserInputService:IsKeyDown(Enum.KeyCode.E) then  -- Go up
                    verticalDirection = Vector3.new(0, FlySpeed, 0)
                elseif UserInputService:IsKeyDown(Enum.KeyCode.Q) then  -- Go down
                    verticalDirection = Vector3.new(0, -FlySpeed, 0)
                end

                -- Combine forward and vertical movement
                BodyVelocity.Velocity = cameraDirection + verticalDirection
            else
                connection:Disconnect()  -- Stop updating if Fly is disabled
            end
        end)
    else
        -- Disable flying and clean up BodyVelocity
        if BodyVelocity then
            BodyVelocity:Destroy()
            BodyVelocity = nil
        end
    end
end

-- Function to toggle NoClip
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

-- Function to set the FOV correctly in DOORS
local function setFOV(fovValue)
    Main_Game.fovtarget = fovValue
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
    Default = false,  -- Fullbright is disabled by default
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

-- Walkspeed Slider
playersTab:AddSlider({
    Name = "Walkspeed",
    Min = 1,
    Max = 75,
    Default = 16,
    Callback = setWalkSpeed
})

-- FOV Slider
playersTab:AddSlider({
    Name = "FOV",
    Min = 70,
    Max = 120,
    Default = 70,
    Callback = setFOV
})

-- NoClip Toggle
playersTab:AddToggle({
    Name = "NoClip",
    Default = false,
    Callback = enableNoClip
})

-- Fly Toggle
playersTab:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = toggleFly
})

-- Finalize the UI Initialization
OrionLib:Init()
