-- KEY SYSTEM
local correctKey = "X7mQ2vLp9K"
local discordLink = "https://discord.gg/vDrdWwk8C"

-- Create temporary key verification UI
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create ScreenGui for key system
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "WaterWorksKeySystem"
KeyGui.Parent = game.CoreGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 280)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = KeyGui

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(135, 206, 250)
Title.Text = "💧 WaterWorks Key System"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 24
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

-- Discord Label
local DiscordLabel = Instance.new("TextLabel")
DiscordLabel.Size = UDim2.new(1, -20, 0, 30)
DiscordLabel.Position = UDim2.new(0, 10, 0, 60)
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.Text = "Join Discord for key:"
DiscordLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
DiscordLabel.TextSize = 14
DiscordLabel.Font = Enum.Font.SourceSans
DiscordLabel.Parent = MainFrame

-- Copy Discord Button
local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(1, -40, 0, 35)
CopyBtn.Position = UDim2.new(0, 20, 0, 90)
CopyBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242) -- Discord blurple
CopyBtn.Text = "📋 Copy Discord Link"
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.TextSize = 16
CopyBtn.Font = Enum.Font.SourceSansBold
CopyBtn.Parent = MainFrame

-- Copy Status
local CopyStatus = Instance.new("TextLabel")
CopyStatus.Size = UDim2.new(1, -20, 0, 20)
CopyStatus.Position = UDim2.new(0, 10, 0, 125)
CopyStatus.BackgroundTransparency = 1
CopyStatus.Text = ""
CopyStatus.TextColor3 = Color3.fromRGB(50, 255, 50)
CopyStatus.TextSize = 12
CopyStatus.Font = Enum.Font.SourceSans
CopyStatus.Parent = MainFrame

-- Key Input
local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -40, 0, 40)
KeyBox.Position = UDim2.new(0, 20, 0, 150)
KeyBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
KeyBox.Text = ""
KeyBox.PlaceholderText = "Enter Key Here..."
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
KeyBox.TextSize = 18
KeyBox.Font = Enum.Font.SourceSans
KeyBox.ClearTextOnFocus = false
KeyBox.Parent = MainFrame

-- Submit Button
local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0, 150, 0, 40)
SubmitBtn.Position = UDim2.new(0.5, -75, 1, -70)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(135, 206, 250)
SubmitBtn.Text = "Submit"
SubmitBtn.TextColor3 = Color3.fromRGB(30, 30, 30)
SubmitBtn.TextSize = 20
SubmitBtn.Font = Enum.Font.SourceSansBold
SubmitBtn.Parent = MainFrame

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 25)
StatusLabel.Position = UDim2.new(0, 10, 0, 195)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.Parent = MainFrame

-- Copy Discord Function
CopyBtn.MouseButton1Click:Connect(function()
    local success, err = pcall(function()
        setclipboard(discordLink)
    end)
    
    if success then
        CopyStatus.Text = "✓ Link copied to clipboard!"
        CopyStatus.TextColor3 = Color3.fromRGB(50, 255, 50)
    else
        CopyStatus.Text = "✗ Could not copy (executor may not support)"
        CopyStatus.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
    
    -- Clear status after 3 seconds
    wait(3)
    CopyStatus.Text = ""
end)

-- Submit Function
SubmitBtn.MouseButton1Click:Connect(function()
    local enteredKey = KeyBox.Text:gsub("%s+", "") -- Remove spaces
    
    if enteredKey == correctKey then
        StatusLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
        StatusLabel.Text = "✓ Key Accepted! Loading..."
        
        wait(1)
        KeyGui:Destroy()
        
        -- LOAD MAIN SCRIPT
        loadMainScript()
    else
        StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        StatusLabel.Text = "✗ Invalid Key! Join Discord for key."
        KeyBox.Text = ""
    end
end)

-- Also submit on Enter key
KeyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        SubmitBtn.MouseButton1Click:Fire()
    end
end)

-- MAIN SCRIPT FUNCTION
function loadMainScript()
    local omni = loadstring(game:HttpGet("https://raw.githubusercontent.com/TweedLeak-LeakScripts/FriseX/main/UI-Library"))()

    local UI = omni.new({
        Name = "💧 WaterWorks";
        Credit = "WaterWorks";
        Color = Color3.fromRGB(135, 206, 250);
        Bind = "LeftControl";
        UseLoader = false;
        FullName = "WaterWorks";
        CheckKey = function(inputtedKey)
            return true
        end;
        Discord = "discord.gg/waterworks";
    })

    local notifSound = Instance.new("Sound",workspace)
    notifSound.PlaybackSpeed = 1
    notifSound.Volume = 0.35
    notifSound.SoundId = "rbxassetid://5829559206"
    notifSound.PlayOnRemove = true
    notifSound:Destroy()

    UI:Notify({
      Title = "WaterWorks Loaded!";
      Content = "Toggle with 'LeftControl'";
    })

    -- Services
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local player = Players.LocalPlayer

    -- Settings
    _G.NoStunSpeed = 0.15

    -- Combat Page
    local CombatPage = UI:CreatePage("Combat 💧")

    local CombatSection = CombatPage:CreateSection("Stun Bypass")

    CombatSection:CreateSlider({
        Name = "⚠️ CFrame Speed (High=BAN)";
        Flag = "NoStunSpeed";
        Min = 0.05;
        Max = 1.0;
        AllowOutOfRange = false;
        Digits = 2;
        Default = 0.15;
        Callback = function(value)
            _G.NoStunSpeed = value
        end;
    })

    local keys = {W = false, A = false, S = false, D = false}

    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.W then keys.W = true end
        if input.KeyCode == Enum.KeyCode.A then keys.A = true end
        if input.KeyCode == Enum.KeyCode.S then keys.S = true end
        if input.KeyCode == Enum.KeyCode.D then keys.D = true end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then keys.W = false end
        if input.KeyCode == Enum.KeyCode.A then keys.A = false end
        if input.KeyCode == Enum.KeyCode.S then keys.S = false end
        if input.KeyCode == Enum.KeyCode.D then keys.D = false end
    end)

    CombatSection:CreateToggle({
        Name = "🛡 No Stun (CFrame Walk)";
        Flag = "NoStun";
        Default = false;
        Callback = function(state)
            _G.NoStunEnabled = state
            
            local notifSound = Instance.new("Sound",workspace)
            notifSound.PlaybackSpeed = 1
            notifSound.Volume = 0.15
            notifSound.SoundId = "rbxassetid://4590662766"
            notifSound.PlayOnRemove = true
            notifSound:Destroy()
            
            if state then
                _G.NoStunLoop = RunService.RenderStepped:Connect(function()
                    local char = player.Character
                    if not char then return end
                    
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local humanoid = char:FindFirstChild("Humanoid")
                    if not hrp or not humanoid then return end
                    
                    -- FORCE UNANCHOR
                    if hrp.Anchored then
                        hrp.Anchored = false
                    end
                    
                    -- REMOVE STUN CONSTRAINTS
                    for _, v in pairs(hrp:GetChildren()) do
                        if v:IsA("BodyPosition") or v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                            v:Destroy()
                        end
                    end
                    
                    -- REMOVE STUN OBJECTS
                    for _, v in pairs(char:GetDescendants()) do
                        if v.Name == "Stun" or v.Name == "Stunned" or v.Name == "RagdollConstraint" then
                            v:Destroy()
                        end
                    end
                    
                    -- RESET WALKSPEED
                    if humanoid.WalkSpeed < 5 then
                        humanoid.WalkSpeed = 16
                    end
                    
                    -- MOVEMENT
                    local moving = keys.W or keys.A or keys.S or keys.D
                    if not moving then return end
                    
                    local moveDir = Vector3.new(0, 0, 0)
                    local cam = workspace.CurrentCamera
                    
                    if keys.W then moveDir = moveDir + cam.CFrame.LookVector end
                    if keys.S then moveDir = moveDir - cam.CFrame.LookVector end
                    if keys.A then moveDir = moveDir - cam.CFrame.RightVector end
                    if keys.D then moveDir = moveDir + cam.CFrame.RightVector end
                    
                    moveDir = Vector3.new(moveDir.X, 0, moveDir.Z)
                    
                    if moveDir.Magnitude > 0 then
                        local speed = _G.NoStunSpeed * (humanoid.WalkSpeed / 16)
                        moveDir = moveDir.Unit * speed
                        hrp.CFrame = hrp.CFrame + moveDir
                    end
                end)
                
            else
                if _G.NoStunLoop then
                    _G.NoStunLoop:Disconnect()
                    _G.NoStunLoop = nil
                end
            end
        end;
        Warning = "Always use CFrame movement. Escapes combos automatically.";
        WarningIcon = 11453115091;
    })

    -- Hitbox Expander Section
    local HitboxSection = CombatPage:CreateSection("Hitbox Expander")

    local HitboxSize = 10
    _G.ModifiedPlayers = {}

    HitboxSection:CreateSlider({
        Name = "Hitbox Size";
        Flag = "HitboxSize";
        Min = 2;
        Max = 50;
        AllowOutOfRange = false;
        Digits = 1;
        Default = 10;
        Callback = function(value)
            HitboxSize = value
            for userId, data in pairs(_G.ModifiedPlayers) do
                if userId ~= player.UserId and data and data.HRP then
                    data.HRP.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                end
            end
        end;
    })

    local function expandHitbox(targetPlayer)
        if targetPlayer == player or targetPlayer.UserId == player.UserId then return end
        
        local char = targetPlayer.Character
        if not char then return end
        
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        if not _G.ModifiedPlayers[targetPlayer.UserId] then
            _G.ModifiedPlayers[targetPlayer.UserId] = {
                OriginalSize = hrp.Size,
                OriginalTransparency = hrp.Transparency,
                HRP = hrp
            }
        end
        
        hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
        hrp.Transparency = 0.7
        hrp.Color = Color3.fromRGB(0, 255, 0)
        hrp.Material = Enum.Material.ForceField
    end

    local function restoreHitbox(targetPlayer)
        if targetPlayer == player then return end
        
        local data = _G.ModifiedPlayers[targetPlayer.UserId]
        if data and data.HRP then
            data.HRP.Size = data.OriginalSize
            data.HRP.Transparency = data.OriginalTransparency
        end
        _G.ModifiedPlayers[targetPlayer.UserId] = nil
    end

    local function restoreAll()
        for userId, data in pairs(_G.ModifiedPlayers) do
            if data and data.HRP then
                data.HRP.Size = data.OriginalSize
                data.HRP.Transparency = data.OriginalTransparency
            end
        end
        _G.ModifiedPlayers = {}
    end

    HitboxSection:CreateToggle({
        Name = "📦 Expand Enemy Hitboxes";
        Flag = "HitboxToggle";
        Default = false;
        Callback = function(state)
            _G.HitboxEnabled = state
            
            local notifSound = Instance.new("Sound",workspace)
            notifSound.PlaybackSpeed = 1
            notifSound.Volume = 0.15
            notifSound.SoundId = "rbxassetid://4590662766"
            notifSound.PlayOnRemove = true
            notifSound:Destroy()
            
            if state then
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= player and plr.UserId ~= player.UserId then
                        expandHitbox(plr)
                    end
                end
                
                _G.PlayerAddedConnection = Players.PlayerAdded:Connect(function(newPlayer)
                    if newPlayer == player or newPlayer.UserId == player.UserId then return end
                    
                    newPlayer.CharacterAdded:Connect(function()
                        task.wait(0.3)
                        if _G.HitboxEnabled then
                            expandHitbox(newPlayer)
                        end
                    end)
                    
                    if newPlayer.Character then
                        expandHitbox(newPlayer)
                    end
                end)
                
                _G.PlayerRemovingConnection = Players.PlayerRemoving:Connect(function(leavingPlayer)
                    restoreHitbox(leavingPlayer)
                end)
                
                _G.UpdateLoop = RunService.Heartbeat:Connect(function()
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr == player or plr.UserId == player.UserId then continue end
                        
                        local char = plr.Character
                        if char then
                            local hrp = char:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local data = _G.ModifiedPlayers[plr.UserId]
                                if not data or hrp.Size.X < HitboxSize - 1 then
                                    expandHitbox(plr)
                                end
                            end
                        end
                    end
                end)
                
            else
                restoreAll()
                
                if _G.PlayerAddedConnection then
                    _G.PlayerAddedConnection:Disconnect()
                    _G.PlayerAddedConnection = nil
                end
                if _G.PlayerRemovingConnection then
                    _G.PlayerRemovingConnection:Disconnect()
                    _G.PlayerRemovingConnection = nil
                end
                if _G.UpdateLoop then
                    _G.UpdateLoop:Disconnect()
                    _G.UpdateLoop = nil
                end
            end
        end;
        Warning = "Expands enemy HRP - green boxes visible";
        WarningIcon = 11453115091;
    })

    -- Settings Page
    local SettingsPage = UI:CreatePage("Settings ⚙️")

    local SettingsSection = SettingsPage:CreateSection("GUI")

    SettingsSection:CreateInteractable({
        Name = "Destroy GUI";
        ActionText = "Destroy";
        Callback = function()
            restoreAll()
            _G.NoStunEnabled = false
            
            if _G.NoStunLoop then _G.NoStunLoop:Disconnect() end
            
            local notifSound = Instance.new("Sound",workspace)
            notifSound.PlaybackSpeed = 1
            notifSound.Volume = 0.40
            notifSound.SoundId = "rbxassetid://3673835822"
            notifSound.PlayOnRemove = true
            notifSound:Destroy()
            wait(0.5)
            UI:Destroy()
        end;
    })
end
