local omni = loadstring(game:HttpGet("https://raw.githubusercontent.com/TweedLeak-LeakScripts/FriseX/main/UI-Library"))()

local UI = omni.new({
    Name = "⚔️ ABA Hub";
    Credit = "ABA Script";
    Color = Color3.fromRGB(255, 50, 50);
    Bind = "LeftControl";
    UseLoader = false;
    FullName = "ABA Hub";
    CheckKey = function(inputtedKey)
        return true
    end;
    Discord = "discord.gg/aba";
})

local notifSound = Instance.new("Sound",workspace)
notifSound.PlaybackSpeed = 1
notifSound.Volume = 0.35
notifSound.SoundId = "rbxassetid://5829559206"
notifSound.PlayOnRemove = true
notifSound:Destroy()

UI:Notify({
  Title = "ABA Hub Loaded!";
  Content = "Toggle with 'LeftControl'";
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Settings
_G.NoStunSpeed = 0.15

-- Combat Page
local CombatPage = UI:CreatePage("Combat ⚔️")

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
