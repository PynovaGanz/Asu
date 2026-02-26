--[[
    ZOO VS OOF - PoopUnderGr0und
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local camera = workspace.CurrentCamera
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local mouse = player:GetMouse()

-- States
local espActive, aimLock, autoShoot = false, false, false
local menuOpen = true

local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "ZooVsOof_Final_V3"
ScreenGui.ResetOnSpawn = false

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 0)
ToggleBtn.Text = "OOF"
ToggleBtn.Font = Enum.Font.GothamBlack
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Active = true
ToggleBtn.Draggable = true -- Sekarang bisa digeser
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local TStroke = Instance.new("UIStroke", ToggleBtn)
TStroke.Color = Color3.fromRGB(255, 255, 255)
TStroke.Thickness = 1.5

-- Main Menu
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 320)
Main.Position = UDim2.new(0.5, -120, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(255, 60, 0)
Stroke.Thickness = 2

-- Judul & Credit
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "ZOO VS OOF\nPoopUnderGr0und"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 16
Title.BackgroundTransparency = 1

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(0.9, 0, 0.7, 0)
Container.Position = UDim2.new(0.05, 0, 0.22, 0)
Container.BackgroundTransparency = 1
local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 8)

ToggleBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    Main.Visible = menuOpen
end)

local function createButton(text, isToggle, callback)
    local btn = Instance.new("TextButton", Container)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        if isToggle then
            active = not active
            btn.BackgroundColor3 = active and Color3.fromRGB(255, 60, 0) or Color3.fromRGB(25, 25, 25)
            btn.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
            btn.Text = text .. (active and " [ON]" or " [OFF]")
            callback(active)
        else
            callback()
        end
    end)
end

--  FEATURES
createButton("ESP ANIMALS", true, function(s) espActive = s end)
createButton("LOCK ANIMALS", true, function(s) aimLock = s end)
createButton("AUTO SHOOTING", true, function(s) autoShoot = s end)

createButton("HIDE : PRESS ME", false, function()
    pcall(function()
        local obj = workspace.Lobby.Lobby.Visual.Props.Visual:GetChildren()[29]
        if obj then
            -- Teleport pemain ke lokasi objek (sedikit di atasnya agar tidak nyangkut)
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = obj:GetModelCFrame() or obj.CFrame + Vector3.new(0, 3, 0)
                task.wait(0.1)
                obj:Destroy() -- Sembunyikan setelah sampai
            end
        end
    end)
end)

-- Footer
local Credit = Instance.new("TextLabel", Main)
Credit.Size = UDim2.new(1, 0, 0, 20)
Credit.Position = UDim2.new(0, 0, 0.92, 0)
Credit.Text = "YT : PoopUnderGr0und"
Credit.TextColor3 = Color3.fromRGB(120, 120, 120)
Credit.Font = Enum.Font.GothamSemibold
Credit.TextSize = 11
Credit.BackgroundTransparency = 1

--  ENGINE
RunService.RenderStepped:Connect(function()
    local target = nil
    local dist = math.huge
    local anims = workspace:FindFirstChild("Gameplay") and workspace.Gameplay.Dynamic:FindFirstChild("Animals")
    
    if anims then
        for _, v in pairs(anims:GetChildren()) do
            -- ESP
            if espActive then
                local hl = v:FindFirstChild("OOF_ESP") or Instance.new("Highlight", v)
                hl.Name = "OOF_ESP"
                hl.FillColor = Color3.fromRGB(255, 60, 0)
                hl.Enabled = true
            elseif v:FindFirstChild("OOF_ESP") then
                v.OOF_ESP.Enabled = false
            end
            
            -- Lock Logic
            local root = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChildWhichIsA("BasePart")
            if root then
                local pos, onScreen = camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local mag = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
                    if mag < dist then dist = mag; target = root end
                end
            end
        end
    end

    if aimLock and target then
        camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
    end
end)

print(" ZOO VS OOF by PoopUnderGr0und Loaded!")
