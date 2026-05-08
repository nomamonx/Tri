local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

_G.Phantom = {
    Aktif = false,
    Tembus = false,
    Lari = 60,
    Sensitivitas = 1.4,
    NoiseJaringan = 0.002,
    LagOptimizer = true,
    BypassLevel = "ULTIMATE_OMEGA",
    Anti600 = true,
    VectorSync = true,
    AntiRaycast = true
}

local Char, Root, Hum
local ModGerak, ModPutar
local FakeCollision = {}

local function RefreshChar()
    Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    Root = Char:WaitForChild("HumanoidRootPart")
    Hum = Char:WaitForChild("Humanoid")
end

local function InjeksiBypassLengkap()
    pcall(function()
        if ModGerak then ModGerak:Destroy() end
        if ModPutar then ModPutar:Destroy() end
        
        ModGerak = Instance.new("BodyVelocity")
        ModPutar = Instance.new("BodyGyro")
        
        local HiddenName1 = ""
        for i = 1, 15 do HiddenName1 = HiddenName1 .. string.char(math.random(33, 126)) end
        local HiddenName2 = ""
        for i = 1, 15 do HiddenName2 = HiddenName2 .. string.char(math.random(33, 126)) end
        
        ModGerak.Name = HiddenName1
        ModPutar.Name = HiddenName2
        
        ModGerak.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        ModGerak.Velocity = Vector3.new(0, 0, 0)
        
        ModPutar.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        ModPutar.P = 45000
        ModPutar.D = 1000
        
        ModGerak.Parent = Root
        ModPutar.Parent = Root
    end)
    
    task.spawn(function()
        while _G.Phantom.Aktif do
            if Root and Hum then
                pcall(function() 
                    Root:SetNetworkOwner(LocalPlayer)
                    Hum:ChangeState(Enum.HumanoidStateType.Landed)
                    
                    local p = Instance.new("Part")
                    p.Transparency = 1
                    p.Anchored = true
                    p.CanCollide = false
                    p.Size = Vector3.new(2, 0.2, 2)
                    p.Position = Root.Position - Vector3.new(0, 3, 0)
                    p.Parent = workspace
                    task.wait(0.1)
                    p:Destroy()
                end)
            end
            task.wait(0.5) 
        end
    end)
end

local Window = Rayfield:CreateWindow({
    Name = "🌑 PHANTOM TELASO 🌑",
    LoadingTitle = "MENGAKTIFKAN BAYU 🛠️",
    LoadingSubtitle = "BYPASS 🛡️",
    ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("ULTIMATE MENU 🚀", 4483362458)

Tab:CreateSection("─── ✨ OMEGA BYPASS SYSTEM ✨ ───")

Tab:CreateToggle({
    Name = "MODE TERBANG SILUMAN 🦅✨",
    CurrentValue = false,
    Callback = function(v)
        _G.Phantom.Aktif = v
        RefreshChar()
        
        if v then
            InjeksiBypassLengkap()
            Hum.PlatformStand = true
            Rayfield:Notify({Title = "OMEGA AKTIF! 🔥", Content = "Shadow Zone Bypass level maksimal dinyalakan! 🛡️", Duration = 4})
            
            task.spawn(function()
                while _G.Phantom.Aktif do
                    pcall(function()
                        Hum:ChangeState(Enum.HumanoidStateType.Physics)
                        task.wait(0.1)
                        Hum:ChangeState(Enum.HumanoidStateType.Landed)
                    end)
                    task.wait(0.4)
                end
            end)
        else
            if ModGerak then ModGerak:Destroy() end
            if ModPutar then ModPutar:Destroy() end
            Hum.PlatformStand = false
             Hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            Root.Velocity = Vector3.new(0,0,0)
            Rayfield:Notify({Title = "OMEGA MATI! 😴", Content = "Sistem bypass dinonaktifkan.", Duration = 3})
        end
    end,
})

Tab:CreateToggle({
    Name = "TEMBUS TEMBOK (GHOST) 👻🧱",
    CurrentValue = false,
    Callback = function(v)
        _G.Phantom.Tembus = v
    end,
})

Tab:CreateSlider({
    Name = "KECEPATAN DEWA OMEGA 🏎️💨",
    Range = {10, 500},
    Increment = 5,
    CurrentValue = 60,
    Callback = function(v)
        _G.Phantom.Lari = v
    end,
})


RunService.Stepped:Connect(function()
    if _G.Phantom.Tembus and Char then
        for _, p in pairs(Char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end
end)

RunService.Heartbeat:Connect(function(dt)
    if _G.Phantom.Aktif and Root and Hum then
        
        local Jitter = Vector3.new(
            math.random(-10, 10)/2000, 
            math.random(-5, 5)/2000, 
            math.random(-10, 10)/2000
        )
        
        local MoveDir = Hum.MoveDirection
        local CamCF = Camera.CFrame
        
        if ModPutar and ModPutar.Parent then
            ModPutar.CFrame = CamCF
        end

        if MoveDir.Magnitude > 0 then
            local Vert = CamCF.LookVector.Y * _G.Phantom.Sensitivitas
            local Dir = (MoveDir + Vector3.new(0, Vert, 0)).Unit
            local Target = Root.Position + (Dir * _G.Phantom.Lari * dt)
            
            Root.CFrame = Root.CFrame:Lerp(CFrame.new(Target) * CamCF.Rotation, 0.75)
            
            local VelocityForce = (Dir * (_G.Phantom.Lari * 0.9))
            ModGerak.Velocity = VelocityForce + Jitter
        else
            ModGerak.Velocity = Vector3.new(0, 0.05, 0) + Jitter
            Root.Velocity = Vector3.new(0, 0.05, 0)
        end
        
        if _G.Phantom.Anti600 then
            pcall(function()
                Root.AssemblyLinearVelocity = ModGerak.Velocity
                Root.AssemblyAngularVelocity = Vector3.new(0,0,0)
            end)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1.5)
    RefreshChar()
    if _G.Phantom.Aktif then
        InjeksiBypassLengkap()
        Hum.PlatformStand = true
    end
end)

Rayfield:Notify({
    Title = "OMPONG! 🥳",
    Content = "Bypass Siap! 😎🤙",
    Duration = 5
})