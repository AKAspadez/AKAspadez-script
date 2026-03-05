--// AKAspadez LoopWalkSpeed Command Bar
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local LoopWSConnection = nil
local LoopWSValue = 16

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AKAspadez_LoopWS_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local Bar = Instance.new("Frame")
Bar.Size = UDim2.new(0.6, 0, 0, 40)
Bar.Position = UDim2.new(0.2, 0, 1, 40)
Bar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Bar.BorderSizePixel = 0
Bar.Parent = ScreenGui

local Corner = Instance.new("UICorner", Bar)
Corner.CornerRadius = UDim.new(0, 6)

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(1, -10, 1, -10)
TextBox.Position = UDim2.new(0, 5, 0, 5)
TextBox.BackgroundTransparency = 1
TextBox.Text = ""
TextBox.PlaceholderText = "loopws <number>"
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.Font = Enum.Font.Code
TextBox.TextSize = 20
TextBox.ClearTextOnFocus = false
TextBox.Parent = Bar

local Watermark = Instance.new("TextLabel")
Watermark.Size = UDim2.new(0, 120, 0, 20)
Watermark.Position = UDim2.new(1, -125, 1, -25)
Watermark.BackgroundTransparency = 1
Watermark.Text = "AKAspadez"
Watermark.TextColor3 = Color3.fromRGB(180, 180, 180)
Watermark.Font = Enum.Font.Code
Watermark.TextSize = 16
Watermark.Parent = Bar

TweenService:Create(
	Bar,
	TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	{Position = UDim2.new(0.2, 0, 1, -50)}
):Play()

-- REAL Infinite Yield LoopWalkSpeed
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

local function StopLoopWS()
	if LoopWSConnection then
		LoopWSConnection:Disconnect()
		LoopWSConnection = nil
	end

	local char = LocalPlayer.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = 16
		end
	end
end

TextBox.FocusLost:Connect(function(enterPressed)
	if not enterPressed then return end

	local text = TextBox.Text:lower()

	if text:match("^loopws%s+%d+") then
		local num = tonumber(text:match("%d+"))
		if num then
			LoopWSValue = num
			StartLoopWS()
		end
	elseif text == "loopws off" then
		StopLoopWS()
	end
end)
