--!strict
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local EventBus = require(ReplicatedStorage.Packages.EventBus)
local EventDefines = require(ReplicatedStorage.Modules.EventDefines)
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local TARGET_CUP = Workspace:WaitForChild("GetCups"):WaitForChild("17")
local TREADMILL_FAST = "10000"

local superRun = false
local autoWin = false
local uiVisible = true

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PoopExtreme_Final"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 240, 0, 280)
Main.Position = UDim2.new(0.1, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Main.Active = true
Main.Draggable = true 
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15)

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Color = Color3.fromRGB(255, 255, 0)
Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "PoopUnderGr0und\n+1 Speed Dinosaur Escapes"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.BackgroundTransparency = 1
Title.Parent = Main

-- Tombol Auto Super Run (Treadmill + Steps)
local RunBtn = Instance.new("TextButton")
RunBtn.Size = UDim2.new(0.85, 0, 0, 55)
RunBtn.Position = UDim2.new(0.075, 0, 0.22, 0)
RunBtn.Text = "AUTO SUPER RUN: NO"
RunBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
RunBtn.Font = Enum.Font.GothamBold
RunBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RunBtn.Parent = Main
Instance.new("UICorner", RunBtn)

-- Tombol Auto Win (Cup 17)
local WinBtn = Instance.new("TextButton")
WinBtn.Size = UDim2.new(0.85, 0, 0, 55)
WinBtn.Position = UDim2.new(0.075, 0, 0.48, 0)
WinBtn.Text = "AUTO WIN: NO"
WinBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
WinBtn.Font = Enum.Font.GothamBold
WinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
WinBtn.Parent = Main
Instance.new("UICorner", WinBtn)

-- Credit YouTube
local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(1, 0, 0, 40)
Credit.Position = UDim2.new(0, 0, 0.82, 0)
Credit.Text = "Youtubes : PoopyUnderGr0und / @Px3n"
Credit.TextColor3 = Color3.fromRGB(255, 255, 0)
Credit.Font = Enum.Font.GothamMedium
Credit.TextSize = 10
Credit.BackgroundTransparency = 1
Credit.Parent = Main

-- Minimize Button
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0, 50, 0, 50)
Toggle.Position = UDim2.new(0.05, 0, 0.1, 0)
Toggle.Text = "🦖"
Toggle.TextSize = 25
Toggle.Visible = false
Toggle.Parent = ScreenGui
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1, 0)

RunService.Heartbeat:Connect(function()
    if superRun then
        player:SetAttribute("InRuning", true)
        -- Spam Treadmill 10000
        EventBus.FireServer(EventDefines["进入跑步机"], {
            TreadMill = TREADMILL_FAST
        })
        EventBus.FireServer(EventDefines["玩家步数增加"])
    end
    
    if autoWin then
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            -- Teleport instan ke Cup 17
            root.CFrame = TARGET_CUP:GetPivot()
            -- Noclip agar tidak mental saat TP kencang
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

RunBtn.MouseButton1Click:Connect(function()
    superRun = not superRun
    RunBtn.Text = superRun and "AUTO SUPER RUN: YES" or "AUTO SUPER RUN: NO"
    RunBtn.BackgroundColor3 = superRun and Color3.fromRGB(255, 0, 100) or Color3.fromRGB(35, 35, 35)
end)

WinBtn.MouseButton1Click:Connect(function()
    autoWin = not autoWin
    WinBtn.Text = autoWin and "AUTO WIN: YES" or "AUTO WIN: NO"
    WinBtn.BackgroundColor3 = autoWin and Color3.fromRGB(0, 180, 255) or Color3.fromRGB(35, 35, 35)
end)

local function toggleUI()
    uiVisible = not uiVisible
    Main.Visible = uiVisible
    Toggle.Visible = not uiVisible
end

Toggle.MouseButton1Click:Connect(toggleUI)

-- Keyboard Shortcut "J"
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.J then toggleUI() end
end)

print("🦖 PoopUnderGr0und Extreme Loaded!")
