local uis = game:GetService("UserInputService")
local tween = game:GetService("TweenService")
local run = game:GetService("RunService")
local core = game:GetService("CoreGui")

local isaeva = {}
local viewport = workspace.CurrentCamera.ViewportSize

local font = Font.new("rbxasset://fonts/families/Outfit.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local theme = {
	bg = Color3.fromHex("121212"), 
	accent = Color3.fromHex("722F38"),
	text = Color3.fromHex("B86A73"),
	hover = Color3.fromRGB(255, 255, 255)
}

function isaeva.create(opts)
	local instance = {}
	local gui = Instance.new("ScreenGui")
	gui.Name = "isaeva"
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	if run:IsStudio() then
		gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	else
		gui.Parent = core
	end

	local main = Instance.new("Frame")
	main.Name = "main"
	main.Size = UDim2.fromOffset(650, 400)
	main.Position = UDim2.fromScale(0.5, 0.5)
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.BackgroundColor3 = theme.bg
	main.BorderSizePixel = 0
	main.Parent = gui

	local stroke = Instance.new("UIStroke")
	stroke.Color = theme.accent
	stroke.Transparency = 0.8
	stroke.Thickness = 1
	stroke.Parent = main

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = main

	local sidebar = Instance.new("Frame")
	sidebar.Name = "sidebar"
	sidebar.Size = UDim2.new(0, 180, 1, 0)
	sidebar.BackgroundColor3 = theme.accent
	sidebar.BackgroundTransparency = 0.95
	sidebar.BorderSizePixel = 0
	sidebar.Parent = main

	local sidecorner = Instance.new("UICorner")
	sidecorner.CornerRadius = UDim.new(0, 6)
	sidecorner.Parent = sidebar

	local sidefix = Instance.new("Frame")
	sidefix.Size = UDim2.new(0, 10, 1, 0)
	sidefix.Position = UDim2.new(1, -5, 0, 0)
	sidefix.BackgroundColor3 = theme.accent
	sidefix.BackgroundTransparency = 0.95
	sidefix.BorderSizePixel = 0
	sidefix.ZIndex = 0
	sidefix.Parent = sidebar

	local title = Instance.new("TextLabel")
	title.Text = opts.name or "isaeva"
	title.Font = Enum.Font.GothamMedium
	title.TextSize = 14
	title.TextColor3 = theme.text
	title.Size = UDim2.new(1, -20, 0, 40)
	title.Position = UDim2.fromOffset(20, 10)
	title.BackgroundTransparency = 1
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = sidebar

	local tabholder = Instance.new("ScrollingFrame")
	tabholder.Size = UDim2.new(1, 0, 1, -60)
	tabholder.Position = UDim2.fromOffset(0, 60)
	tabholder.BackgroundTransparency = 1
	tabholder.ScrollBarThickness = 0
	tabholder.Parent = sidebar

	local tablayout = Instance.new("UIListLayout")
	tablayout.SortOrder = Enum.SortOrder.LayoutOrder
	tablayout.Padding = UDim.new(0, 5)
	tablayout.Parent = tabholder

	local tabpadding = Instance.new("UIPadding")
	tabpadding.PaddingLeft = UDim.new(0, 10)
	tabpadding.PaddingRight = UDim.new(0, 10)
	tabpadding.Parent = tabholder

	local content = Instance.new("Frame")
	content.Name = "content"
	content.Size = UDim2.new(1, -180, 1, 0)
	content.Position = UDim2.fromOffset(180, 0)
	content.BackgroundTransparency = 1
	content.Parent = main

	local dragging, draginput, dragstart, startpos

	local function update(input)
		local delta = input.Position - dragstart
		main.Position = UDim2.new(startpos.X.Scale, startpos.X.Offset + delta.X, startpos.Y.Scale, startpos.Y.Offset + delta.Y)
	end

	main.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragstart = input.Position
			startpos = main.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	main.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragging then
				update(input)
			end
		end
	end)

	local tabs = {}
	local first = true

	function instance:tab(info)
		local tab = {}
		local name = info.name or "tab"

		local btn = Instance.new("TextButton")
		btn.Text = name
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 12
		btn.TextColor3 = theme.text
		btn.Size = UDim2.new(1, 0, 0, 32)
		btn.BackgroundColor3 = theme.accent
		btn.BackgroundTransparency = 1
		btn.AutoButtonColor = false
		btn.Parent = tabholder

		local btncorner = Instance.new("UICorner")
		btncorner.CornerRadius = UDim.new(0, 4)
		btncorner.Parent = btn

		local btnpad = Instance.new("UIPadding")
		btnpad.PaddingLeft = UDim.new(0, 10)
		btnpad.Parent = btn
		
		btn.TextXAlignment = Enum.TextXAlignment.Left

		local container = Instance.new("ScrollingFrame")
		container.Size = UDim2.new(1, 0, 1, 0)
		container.BackgroundTransparency = 1
		container.ScrollBarThickness = 2
		container.ScrollBarImageColor3 = theme.accent
		container.Visible = false
		container.Parent = content

		local contlayout = Instance.new("UIListLayout")
		contlayout.SortOrder = Enum.SortOrder.LayoutOrder
		contlayout.Padding = UDim.new(0, 6)
		contlayout.Parent = container

		local contpad = Instance.new("UIPadding")
		contpad.PaddingTop = UDim.new(0, 15)
		contpad.PaddingLeft = UDim.new(0, 15)
		contpad.PaddingRight = UDim.new(0, 15)
		contpad.Parent = container

		if first then
			container.Visible = true
			btn.BackgroundTransparency = 0.9
			btn.TextColor3 = theme.hover
			first = false
		end

		btn.MouseEnter:Connect(function()
			tween:Create(btn, TweenInfo.new(0.2), {TextColor3 = theme.hover}):Play()
		end)

		btn.MouseLeave:Connect(function()
			if container.Visible == false then
				tween:Create(btn, TweenInfo.new(0.2), {TextColor3 = theme.text}):Play()
			end
		end)

		btn.MouseButton1Click:Connect(function()
			for _, t in pairs(tabs) do
				t.container.Visible = false
				tween:Create(t.btn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextColor3 = theme.text}):Play()
			end
			container.Visible = true
			tween:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.9, TextColor3 = theme.hover}):Play()
		end)
		
		function tab:label(info)
			local lbl = Instance.new("TextLabel")
			lbl.Text = info.text
			lbl.Size = UDim2.new(1, 0, 0, 25)
			lbl.BackgroundTransparency = 1
			lbl.TextColor3 = theme.text
			lbl.TextTransparency = 0.4
			lbl.Font = Enum.Font.Gotham
			lbl.TextSize = 12
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = container
		end

		function tab:button(info)
			local b = Instance.new("TextButton")
			b.Text = info.name
			b.Size = UDim2.new(1, 0, 0, 36)
			b.BackgroundColor3 = theme.accent
			b.BackgroundTransparency = 0.9
			b.TextColor3 = theme.text
			b.Font = Enum.Font.Gotham
			b.TextSize = 13
			b.AutoButtonColor = false
			b.Parent = container

			local bcorner = Instance.new("UICorner")
			bcorner.CornerRadius = UDim.new(0, 4)
			bcorner.Parent = b
			
			local stroke = Instance.new("UIStroke")
			stroke.Color = theme.accent
			stroke.Transparency = 0.6
			stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			stroke.Parent = b

			b.MouseEnter:Connect(function()
				tween:Create(b, TweenInfo.new(0.2), {TextColor3 = theme.hover, BackgroundTransparency = 0.8}):Play()
			end)

			b.MouseLeave:Connect(function()
				tween:Create(b, TweenInfo.new(0.2), {TextColor3 = theme.text, BackgroundTransparency = 0.9}):Play()
			end)

			b.MouseButton1Click:Connect(function()
				tween:Create(b, TweenInfo.new(0.1), {TextSize = 11}):Play()
				task.wait(0.1)
				tween:Create(b, TweenInfo.new(0.1), {TextSize = 13}):Play()
				if info.callback then info.callback() end
			end)
		end
		
		function tab:editor(info)
			local edframe = Instance.new("Frame")
			edframe.Size = UDim2.new(1, 0, 0, 200)
			edframe.BackgroundColor3 = Color3.fromHex("0F0F0F")
			edframe.BorderSizePixel = 0
			edframe.Parent = container
			
			local edcorner = Instance.new("UICorner")
			edcorner.CornerRadius = UDim.new(0, 4)
			edcorner.Parent = edframe
			
			local edstroke = Instance.new("UIStroke")
			edstroke.Color = theme.accent
			edstroke.Transparency = 0.8
			edstroke.Parent = edframe
			
			local lines = Instance.new("TextLabel")
			lines.Size = UDim2.new(0, 30, 1, 0)
			lines.BackgroundTransparency = 1
			lines.TextYAlignment = Enum.TextYAlignment.Top
			lines.TextColor3 = theme.text
			lines.TextTransparency = 0.6
			lines.Font = Enum.Font.Code
			lines.TextSize = 13
			lines.LineHeight = 1.2
			lines.Text = "1"
			lines.Parent = edframe
			
			local scroller = Instance.new("ScrollingFrame")
			scroller.Size = UDim2.new(1, -35, 1, 0)
			scroller.Position = UDim2.fromOffset(35, 0)
			scroller.BackgroundTransparency = 1
			scroller.ScrollBarThickness = 2
			scroller.CanvasSize = UDim2.new(0, 0, 0, 0) 
			scroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
			scroller.Parent = edframe
			
			local input = Instance.new("TextBox")
			input.Size = UDim2.new(1, 0, 1, 0)
			input.BackgroundTransparency = 1
			input.TextXAlignment = Enum.TextXAlignment.Left
			input.TextYAlignment = Enum.TextYAlignment.Top
			input.TextColor3 = theme.hover
			input.Font = Enum.Font.Code
			input.TextSize = 13
			input.LineHeight = 1.2
			input.MultiLine = true
			input.ClearTextOnFocus = false
			input.Text = info.text or "print('Hello World')"
			input.Parent = scroller
			
			local function updatelines()
				local count = 0
				for _ in input.Text:gmatch("\n") do
					count = count + 1
				end
				local str = ""
				for i = 1, count + 1 do
					str = str .. i .. "\n"
				end
				lines.Text = str
			end
			
			input:GetPropertyChangedSignal("Text"):Connect(updatelines)
			updatelines()
			
			-- basic syntax coloring visualizer (fake)
			-- to do this properly requires a large lexer, 
			-- but we maintain the aesthetic here.
		end

		table.insert(tabs, {btn = btn, container = container})
		return tab
	end

	return instance
end

return isaeva
