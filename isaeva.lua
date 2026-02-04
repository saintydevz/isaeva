local isaeva = {}

local players = game:GetService("Players")
local lp = players.LocalPlayer
local tween = game:GetService("TweenService")

local colors = {
	bg = Color3.fromHex("722F38"),
	text = Color3.fromHex("B86A73"),
	hover = Color3.fromRGB(255,255,255)
}

function isaeva:createwindow(title)
	local gui = Instance.new("ScreenGui")
	gui.Name = "isaeva"
	gui.ResetOnSpawn = false
	gui.Parent = lp:WaitForChild("PlayerGui")

	local main = Instance.new("Frame")
	main.Size = UDim2.fromOffset(420,320)
	main.Position = UDim2.fromScale(0.5,0.5)
	main.AnchorPoint = Vector2.new(0.5,0.5)
	main.BackgroundColor3 = colors.bg
	main.BackgroundTransparency = 0.9
	main.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,10)
	corner.Parent = main

	local pad = Instance.new("UIPadding")
	pad.PaddingLeft = UDim.new(0,10)
	pad.PaddingRight = UDim.new(0,10)
	pad.PaddingTop = UDim.new(0,10)
	pad.PaddingBottom = UDim.new(0,10)
	pad.Parent = main

	local titlelabel = Instance.new("TextLabel")
	titlelabel.Size = UDim2.new(1,0,0,24)
	titlelabel.BackgroundTransparency = 1
	titlelabel.Text = title or "isaeva"
	titlelabel.TextColor3 = colors.text
	titlelabel.Font = Enum.Font.Gotham
	titlelabel.TextSize = 18
	titlelabel.TextXAlignment = Enum.TextXAlignment.Left
	titlelabel.Parent = main

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1,0,1,-28)
	container.Position = UDim2.new(0,0,0,28)
	container.BackgroundTransparency = 1
	container.Parent = main

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0,6)
	layout.Parent = container

	local win = {}

	function win:label(text)
		local l = Instance.new("TextLabel")
		l.Size = UDim2.new(1,0,0,22)
		l.BackgroundTransparency = 1
		l.Text = text
		l.TextColor3 = colors.text
		l.Font = Enum.Font.Gotham
		l.TextSize = 15
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.Parent = container
	end

	function win:button(text,callback)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1,0,0,26)
		b.BackgroundColor3 = colors.bg
		b.BackgroundTransparency = 0.85
		b.Text = text
		b.TextColor3 = colors.text
		b.Font = Enum.Font.Gotham
		b.TextSize = 15
		b.Parent = container

		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0,6)
		c.Parent = b

		b.MouseEnter:Connect(function()
			tween:Create(b,TweenInfo.new(0.12),{TextColor3 = colors.hover}):Play()
		end)

		b.MouseLeave:Connect(function()
			tween:Create(b,TweenInfo.new(0.12),{TextColor3 = colors.text}):Play()
		end)

		b.MouseButton1Click:Connect(function()
			if callback then callback() end
		end)
	end

	function win:editor()
		local box = Instance.new("TextBox")
		box.Size = UDim2.new(1,0,0,150)
		box.BackgroundColor3 = colors.bg
		box.BackgroundTransparency = 0.92
		box.TextColor3 = colors.text
		box.Font = Enum.Font.Code
		box.TextSize = 14
		box.MultiLine = true
		box.ClearTextOnFocus = false
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.TextYAlignment = Enum.TextYAlignment.Top
		box.Parent = container

		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0,6)
		c.Parent = box

		return box
	end

	return win
end

return isaeva
