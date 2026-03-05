--// Clean Professional LoopWalkSpeed UI by AKAspadez

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local LoopWSConnection = nil
local LoopWSValue = 16

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
pcall(function()
    ScreenGui.Parent = (game.CoreGui or LocalPlayer:WaitForChild("PlayerGui"))
end)
ScreenGui.Name = "SmoothWalkSpeedUI"

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Size = UDim2.new(0, 230, 0, 140)
Frame.Position = UDim2.new(0.05, 0, 1.2, 0) -- start off-screen for slide-in
Frame.Active = true
Frame.Draggable = true

local Corner = Instance.new("UICorner", Frame)
Corner.CornerRadius = UDim.new(0, 10)

-- Slide-in animation
TweenService:Create(Frame, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.05, 0, 0.25, 0)
}):Play()

-- Title Bar
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1, 0, 0, 32)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "WalkSpeed Control"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local TitleCorner = Instance.new("UICorner", Title)
TitleCorner.CornerRadius = UDim.new(0, 10)

-- Minimize Button
local Minimize = Instance.new("TextButton")
Minimize.Parent = Title
Minimize.Size = UDim2.new(0, 32, 0, 32)
Minimize.Position = UDim2.new(1, -32, 0, 0)
Minimize.BackgroundTransparency = 1
Minimize.Text = "-"
Minimize.TextColor3 = Color3.fromRGB(200, 200, 200)
Minimize.Font = Enum.Font.GothamBold
Minimize.TextSize = 20

---------------------------------------------------------------------
-- CONTENT HOLDER (Prevents UI leaking when minimized)
---------------------------------------------------------------------

local Content = Instance.new("Frame")
Content.Parent = Frame
Content.BackgroundTransparency = 1
Content.Size = UDim2.new(1, 0, 1, -32)
Content.Position = UDim2.new(0, 0, 0, 32)

-- Input Box
local Input = Instance.new("TextBox")
Input.Parent = Content
Input.PlaceholderText = "Enter speed"
Input.Position = UDim2.new(0.1, 0, 0.15, 0)
Input.Size = UDim2.new(0.8, 0, 0, 32)
Input.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
Input.TextColor3 = Color3.fromRGB(255, 255, 255)
Input.Font = Enum.Font.Gotham
Input.TextSize = 14

local InputCorner = Instance.new("UICorner", Input)
InputCorner.CornerRadius = UDim.new(0, 8)

-- Button
local Button = Instance.new("TextButton")
Button.Parent = Content
Button.Text = "Apply Speed"
Button.Position = UDim2.new(0.1, 0, 0.55, 0)
Button.Size = UDim2.new(0.8, 0, 0, 30)
Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 14

local ButtonCorner = Instance.new("UICorner", Button)
ButtonCorner.CornerRadius = UDim.new(0, 8)

---------------------------------------------------------------------
-- CLICKABLE, GLOWING WATERMARK
---------------------------------------------------------------------

local Watermark = Instance.new("TextButton")
Watermark.Parent = Content
Watermark.Size = UDim2.new(0, 120, 0, 20)
Watermark.Position = UDim2.new(1, -125, 1, -25)
Watermark.BackgroundTransparency = 1
Watermark.Text = "AKAspadez"
Watermark.TextColor3 = Color3.fromRGB(180, 180, 180)
Watermark.Font = Enum.Font.GothamBold
Watermark.TextSize = 14
Watermark.TextXAlignment = Enum.TextXAlignment.Right
Watermark.AutoButtonColor = false

-- Click to open GitHub
Watermark.MouseButton1Click:Connect(function()
    setclipboard("https://github.com/AKAspadez")
end)

-- Glow animation
task.spawn(function()
    while true do
        TweenService:Create(Watermark, TweenInfo.new(1.2, Enum.EasingStyle.Quad), {
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        task.wait(1.2)
        TweenService:Create(Watermark, TweenInfo.new(1.2, Enum.EasingStyle.Quad), {
            TextColor3 = Color3.fromRGB(180, 180, 180)
        }):Play()
        task.wait(1.2)
    end
end)

---------------------------------------------------------------------
-- REAL Infinite Yield LoopWalkSpeed
---------------------------------------------------------------------

local function StartLoopWS()
    if LoopWSConnection then
        LoopWSConnection:Disconnect()
    end

    LoopWSConnection = RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = LoopWSValue
        end
    end)
end

Button.MouseButton1Click:Connect(function()
    local speed = tonumber(Input.Text)
    if speed then
        LoopWSValue = speed
        StartLoopWS()
    end
end)

---------------------------------------------------------------------
-- Minimize Animation (Watermark included)
---------------------------------------------------------------------

local Minimized = false

Minimize.MouseButton1Click:Connect(function()
    if not Minimized then
        Minimized = true

        -- Fade out content
        for _, v in ipairs(Content:GetChildren()) do
            TweenService:Create(v, TweenInfo.new(0.25), {
                TextTransparency = 1
            }):Play()
        end

        task.delay(0.25, function()
            Content.Visible = false
        end)

        -- Shrink frame
        TweenService:Create(Frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 230, 0, 32)
        }):Play()

    else
        Minimized = false

        Content.Visible = true

        -- Expand frame
        TweenService:Create(Frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 230, 0, 140)
        }):Play()

        -- Fade content back in
        task.delay(0.1, function()
            for _, v in ipairs(Content:GetChildren()) do
                TweenService:Create(v, TweenInfo.new(0.25), {
                    TextTransparency = 0
                }):Play()
            end
        end)
    end
end)
