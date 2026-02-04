local isaeva = {}

local uis = game:GetService("UserInputService")
local players = game:GetService("Players")
local lp = players.LocalPlayer

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
	main.Size = UDim2.fromScale(0,0)
	main.Position = UDim2.fromScale(0.5,0.5)
	main.AnchorPoint = Vector2.new(0.5,0.5)
	main.BackgroundColor3 = colors.bg
	main.BackgroundTransparency = 0.9
	main.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,10)
	corner.Parent = main

	local titlelabel = Instance.new("TextLabel")
	titlelabel.Size = UDim2.new(1,0,0,30)
	titlelabel.BackgroundTransparency = 1
	titlelabel.Text = title or "isaeva"
	titlelabel.TextColor3 = colors.text
	titlelabel.Font = Enum.Font.SourceSans
	titlelabel.TextSize = 18
	titlelabel.Parent = main

	local container = Instance.new("Frame")
	container.Size = UDim2.new(1,0,1,-30)
	container.Position = UDim2.new(0,0,0,30)
	container.BackgroundTransparency = 1
	container.Parent = main

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0,6)
	layout.Parent = container

	local tween = game:GetService("TweenService")
	tween:Create(main,TweenInfo.new(0.25),{Size=UDim2.fromOffset(400,300)}):Play()

	local win = {}

	function win:label(text)
		local l = Instance.new("TextLabel")
		l.Size = UDim2.new(1,-12,0,24)
		l.BackgroundTransparency = 1
		l.Text = text
		l.TextColor3 = colors.text
		l.Font = Enum.Font.SourceSans
		l.TextSize = 16
		l.TextXAlignment = Left
		l.Parent = container
	end

	function win:button(text,callback)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1,-12,0,28)
		b.BackgroundTransparency = 1
		b.Text = text
		b.TextColor3 = colors.text
		b.Font = Enum.Font.SourceSans
		b.TextSize = 16
		b.Parent = container

		b.MouseEnter:Connect(function()
			b.TextColor3 = colors.hover
		end)

		b.MouseLeave:Connect(function()
			b.TextColor3 = colors.text
		end)

		b.MouseButton1Click:Connect(function()
			if callback then
				callback()
			end
		end)
	end

	function win:editor()
		local box = Instance.new("TextBox")
		box.Size = UDim2.new(1,-12,0,140)
		box.BackgroundTransparency = 0.95
		box.BackgroundColor3 = colors.bg
		box.TextColor3 = colors.text
		box.Font = Enum.Font.Code
		box.TextSize = 14
		box.MultiLine = true
		box.ClearTextOnFocus = false
		box.RichText = true
		box.TextXAlignment = Left
		box.TextYAlignment = Top
		box.Parent = container

		local function highlight(txt)
			txt = txt:gsub("(%f[%w]local%f[%W])","<font color='#ffffff'>local</font>")
			txt = txt:gsub("(%f[%w]function%f[%W])","<font color='#ffffff'>function</font>")
			txt = txt:gsub("(%f[%w]end%f[%W])","<font color='#ffffff'>end</font>")
			txt = txt:gsub("(%f[%w]print%f[%W])","<font color='#ffffff'>print</font>")
			return txt
		end

		box:GetPropertyChangedSignal("Text"):Connect(function()
			local raw = box.Text
			box.Text = highlight(raw)
		end)

		return box
	end

	return win
end

return isaeva
