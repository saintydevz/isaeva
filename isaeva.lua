local isaeva = {}

local tweenservice = game:GetService("TweenService")
local userinputservice = game:GetService("UserInputService")
local runservice = game:GetService("RunService")
local textservice = game:GetService("TextService")
local httpservice = game:GetService("HttpService")

local screen = game:GetService("CoreGui"):FindFirstChild("isaeva_ui")
if screen then
    screen:Destroy()
end

screen = Instance.new("ScreenGui")
screen.Name = "isaeva_ui"
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.Parent = game:GetService("CoreGui")

local function tween(instance, properties, duration)
    local info = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    tweenservice:Create(instance, info, properties):Play()
end

local function create(class, properties)
    local instance = Instance.new(class)
    for property, value in pairs(properties) do
        if property ~= "parent" then
            instance[property] = value
        end
    end
    if properties.parent then
        instance.Parent = properties.parent
    end
    return instance
end

function isaeva:window(config)
    local window = {}
    
    local title = config.title or "isaeva"
    local size = config.size or UDim2.new(0, 600, 0, 400)
    
    local main = create("Frame", {
        Name = "main",
        Size = size,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(34, 35, 40),
        BorderSizePixel = 0,
        parent = screen
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        parent = main
    })
    
    local topbar = create("Frame", {
        Name = "topbar",
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = Color3.fromRGB(28, 29, 33),
        BorderSizePixel = 0,
        parent = main
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        parent = topbar
    })
    
    create("Frame", {
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 1, -6),
        BackgroundColor3 = Color3.fromRGB(28, 29, 33),
        BorderSizePixel = 0,
        parent = topbar
    })
    
    local titlelabel = create("TextLabel", {
        Name = "title",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(184, 106, 115),
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        parent = topbar
    })
    
    local container = create("Frame", {
        Name = "container",
        Size = UDim2.new(1, 0, 1, -45),
        Position = UDim2.new(0, 0, 0, 45),
        BackgroundTransparency = 1,
        parent = main
    })
    
    local tabcontainer = create("Frame", {
        Name = "tabs",
        Size = UDim2.new(0, 180, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Color3.fromRGB(39, 41, 46),
        BorderSizePixel = 0,
        parent = container
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        parent = tabcontainer
    })
    
    local tablist = create("ScrollingFrame", {
        Name = "list",
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Color3.fromRGB(184, 106, 115),
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        parent = tabcontainer
    })
    
    create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        parent = tablist
    })
    
    local contentcontainer = create("Frame", {
        Name = "content",
        Size = UDim2.new(1, -210, 1, -20),
        Position = UDim2.new(0, 200, 0, 10),
        BackgroundColor3 = Color3.fromRGB(39, 41, 46),
        BorderSizePixel = 0,
        parent = container
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        parent = contentcontainer
    })
    
    local dragging = false
    local dragstart = nil
    local startpos = nil
    
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragstart = input.Position
            startpos = main.Position
        end
    end)
    
    topbar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    userinputservice.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragstart
            main.Position = UDim2.new(
                startpos.X.Scale,
                startpos.X.Offset + delta.X,
                startpos.Y.Scale,
                startpos.Y.Offset + delta.Y
            )
        end
    end)
    
    window.tabs = {}
    window.currenttab = nil
    
    function window:tab(name)
        local tab = {}
        
        local tabbutton = create("TextButton", {
            Name = name,
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = Color3.fromRGB(34, 35, 40),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = name,
            TextColor3 = Color3.fromRGB(184, 106, 115),
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            parent = tablist
        })
        
        create("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
            parent = tabbutton
        })
        
        create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            parent = tabbutton
        })
        
        local tabcontent = create("ScrollingFrame", {
            Name = name,
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Color3.fromRGB(184, 106, 115),
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            parent = contentcontainer
        })
        
        local layout = create("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            parent = tabcontent
        })
        
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabcontent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
        end)
        
        tabbutton.MouseButton1Click:Connect(function()
            for _, othertab in pairs(window.tabs) do
                othertab.content.Visible = false
                othertab.button.BackgroundTransparency = 1
            end
            
            tabcontent.Visible = true
            tabbutton.BackgroundTransparency = 0
            window.currenttab = tab
        end)
        
        tabbutton.MouseEnter:Connect(function()
            if window.currenttab ~= tab then
                tween(tabbutton, {BackgroundTransparency = 0.5})
            end
        end)
        
        tabbutton.MouseLeave:Connect(function()
            if window.currenttab ~= tab then
                tween(tabbutton, {BackgroundTransparency = 1})
            end
        end)
        
        tab.button = tabbutton
        tab.content = tabcontent
        
        table.insert(window.tabs, tab)
        
        if #window.tabs == 1 then
            tabcontent.Visible = true
            tabbutton.BackgroundTransparency = 0
            window.currenttab = tab
        end
        
        function tab:label(config)
            local text = config.text or "label"
            
            local label = create("TextLabel", {
                Name = "label",
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Color3.fromRGB(184, 106, 115),
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                parent = tabcontent
            })
            
            return label
        end
        
        function tab:button(config)
            local text = config.text or "button"
            local callback = config.callback or function() end
            
            local buttonframe = create("Frame", {
                Name = "button",
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = Color3.fromHex("#722F38"),
                BackgroundTransparency = 0.9,
                BorderSizePixel = 0,
                parent = tabcontent
            })
            
            create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                parent = buttonframe
            })
            
            local button = create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Color3.fromRGB(184, 106, 115),
                TextSize = 13,
                Font = Enum.Font.Gotham,
                parent = buttonframe
            })
            
            button.MouseButton1Click:Connect(callback)
            
            button.MouseEnter:Connect(function()
                tween(button, {TextColor3 = Color3.fromRGB(220, 200, 205)})
            end)
            
            button.MouseLeave:Connect(function()
                tween(button, {TextColor3 = Color3.fromRGB(184, 106, 115)})
            end)
            
            return button
        end
        
        function tab:toggle(config)
            local text = config.text or "toggle"
            local default = config.default or false
            local callback = config.callback or function() end
            
            local toggled = default
            
            local toggleframe = create("Frame", {
                Name = "toggle",
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = Color3.fromHex("#722F38"),
                BackgroundTransparency = 0.9,
                BorderSizePixel = 0,
                parent = tabcontent
            })
            
            create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                parent = toggleframe
            })
            
            local label = create("TextLabel", {
                Size = UDim2.new(1, -50, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Color3.fromRGB(184, 106, 115),
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                parent = toggleframe
            })
            
            local toggle = create("TextButton", {
                Size = UDim2.new(0, 36, 0, 18),
                Position = UDim2.new(1, -48, 0.5, -9),
                BackgroundColor3 = toggled and Color3.fromRGB(184, 106, 115) or Color3.fromRGB(50, 51, 56),
                BorderSizePixel = 0,
                Text = "",
                parent = toggleframe
            })
            
            create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                parent = toggle
            })
            
            local indicator = create("Frame", {
                Size = UDim2.new(0, 14, 0, 14),
                Position = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                parent = toggle
            })
            
            create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                parent = indicator
            })
            
            toggle.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                tween(toggle, {BackgroundColor3 = toggled and Color3.fromRGB(184, 106, 115) or Color3.fromRGB(50, 51, 56)})
                tween(indicator, {Position = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)})
                
                callback(toggled)
            end)
            
            return toggle
        end
        
        function tab:slider(config)
            local text = config.text or "slider"
            local min = config.min or 0
            local max = config.max or 100
            local default = config.default or min
            local callback = config.callback or function() end
            
            local value = default
            
            local sliderframe = create("Frame", {
                Name = "slider",
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = Color3.fromHex("#722F38"),
                BackgroundTransparency = 0.9,
                BorderSizePixel = 0,
                parent = tabcontent
            })
            
            create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                parent = sliderframe
            })
            
            local label = create("TextLabel", {
                Size = UDim2.new(1, -24, 0, 20),
                Position = UDim2.new(0, 12, 0, 8),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Color3.fromRGB(184, 106, 115),
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                parent = sliderframe
            })
            
            local valuelabel = create("TextLabel", {
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(1, -62, 0, 8),
                BackgroundTransparency = 1,
                Text = tostring(value),
                TextColor3 = Color3.fromRGB(184, 106, 115),
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Right,
                parent = sliderframe
            })
            
            local sliderback = create("Frame", {
                Size = UDim2.new(1, -24, 0, 4),
                Position = UDim2.new(0, 12, 1, -14),
                BackgroundColor3 = Color3.fromRGB(50, 51, 56),
                BorderSizePixel = 0,
                parent = sliderframe
            })
            
            create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                parent = sliderback
            })
            
            local sliderfill = create("Frame", {
                Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = Color3.fromRGB(184, 106, 115),
                BorderSizePixel = 0,
                parent = sliderback
            })
            
            create("UICorner", {
                CornerRadius = UDim.new(1, 0),
                parent = sliderfill
            })
            
            local dragging = false
            
            sliderback.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            sliderback.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            userinputservice.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = (input.Position.X - sliderback.AbsolutePosition.X) / sliderback.AbsoluteSize.X
                    pos = math.clamp(pos, 0, 1)
                    value = math.floor(min + (max - min) * pos)
                    
                    valuelabel.Text = tostring(value)
                    sliderfill.Size = UDim2.new(pos, 0, 1, 0)
                    
                    callback(value)
                end
            end)
            
            return sliderback
        end
        
        function tab:textbox(config)
            local text = config.text or "textbox"
            local placeholder = config.placeholder or ""
            local callback = config.callback or function() end
            
            local textboxframe = create("Frame", {
                Name = "textbox",
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = Color3.fromHex("#722F38"),
                BackgroundTransparency = 0.9,
                BorderSizePixel = 0,
                parent = tabcontent
            })
            
            create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                parent = textboxframe
            })
            
            local textbox = create("TextBox", {
                Size = UDim2.new(1, -24, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = "",
                PlaceholderText = placeholder,
                TextColor3 = Color3.fromRGB(184, 106, 115),
                PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                parent = textboxframe
            })
            
            textbox.FocusLost:Connect(function()
                callback(textbox.Text)
            end)
            
            return textbox
        end
        
        function tab:dropdown(config)
            local text = config.text or "dropdown"
            local options = config.options or {}
            local default = config.default or (options[1] or "")
            local callback = config.callback or function() end
            
            local selected = default
            local opened = false
            
            local dropdownframe = create("Frame", {
                Name = "dropdown",
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = Color3.fromHex("#722F38"),
                BackgroundTransparency = 0.9,
                BorderSizePixel = 0,
                parent = tabcontent
            })
            
            create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                parent = dropdownframe
            })
            
            local label = create("TextLabel", {
                Size = UDim2.new(1, -50, 1, 0),
                Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Color3.fromRGB(184, 106, 115),
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                parent = dropdownframe
            })
            
            local current = create("TextLabel", {
                Size = UDim2.new(0, 100, 1, 0),
                Position = UDim2.new(1, -112, 0, 0),
                BackgroundTransparency = 1,
                Text = selected,
                TextColor3 = Color3.fromRGB(184, 106, 115),
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Right,
                parent = dropdownframe
            })
            
            local button = create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                parent = dropdownframe
            })
            
            local optionsframe = create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 1, 4),
                BackgroundColor3 = Color3.fromRGB(39, 41, 46),
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Visible = false,
                parent = dropdownframe
            })
            
            create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                parent = optionsframe
            })
            
            local optionslist = create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2),
                parent = optionsframe
            })
            
            for _, option in ipairs(options) do
                local optionbutton = create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 28),
                    BackgroundColor3 = Color3.fromRGB(34, 35, 40),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Text = option,
                    TextColor3 = Color3.fromRGB(184, 106, 115),
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    parent = optionsframe
                })
                
                optionbutton.MouseButton1Click:Connect(function()
                    selected = option
                    current.Text = option
                    opened = false
                    tween(optionsframe, {Size = UDim2.new(1, 0, 0, 0)}, 0.15)
                    task.wait(0.15)
                    optionsframe.Visible = false
                    callback(option)
                end)
                
                optionbutton.MouseEnter:Connect(function()
                    tween(optionbutton, {BackgroundTransparency = 0.5})
                end)
                
                optionbutton.MouseLeave:Connect(function()
                    tween(optionbutton, {BackgroundTransparency = 1})
                end)
            end
            
            button.MouseButton1Click:Connect(function()
                opened = not opened
                
                if opened then
                    optionsframe.Visible = true
                    tween(optionsframe, {Size = UDim2.new(1, 0, 0, #options * 30)}, 0.15)
                else
                    tween(optionsframe, {Size = UDim2.new(1, 0, 0, 0)}, 0.15)
                    task.wait(0.15)
                    optionsframe.Visible = false
                end
            end)
            
            return dropdownframe
        end
        
        return tab
    end
    
    return window
end

return isaeva
