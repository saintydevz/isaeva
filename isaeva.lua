local isaeva = {}

local tweenservice = game:GetService("TweenService")
local userinputservice = game:GetService("UserInputService")
local textservice = game:GetService("TextService")

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

function isaeva:createscreen()
    local screen = game:GetService("CoreGui"):FindFirstChild("isaeva_screen")
    if screen then
        screen:Destroy()
    end
    
    screen = Instance.new("ScreenGui")
    screen.Name = "isaeva_screen"
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screen.Parent = game:GetService("CoreGui")
    
    return screen
end

function isaeva:window(config)
    local window = {}
    local parent = config.parent
    local size = config.size or UDim2.new(0, 730, 0, 455)
    local position = config.position or UDim2.new(0.5, 0, 0.5, 0)
    
    local main = create("Frame", {
        Name = "window",
        Size = size,
        Position = position,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        parent = parent
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        parent = main
    })
    
    window.frame = main
    
    local dragging = false
    local dragstart = nil
    local startpos = nil
    
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragstart = input.Position
            startpos = main.Position
        end
    end)
    
    main.InputEnded:Connect(function(input)
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
    
    return window
end

function isaeva:topbar(config)
    local topbar = {}
    local parent = config.parent
    
    local bar = create("Frame", {
        Name = "topbar",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Color3.fromRGB(37, 37, 38),
        BorderSizePixel = 0,
        parent = parent
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        parent = bar
    })
    
    local bottomcover = create("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Color3.fromRGB(37, 37, 38),
        BorderSizePixel = 0,
        parent = bar
    })
    
    topbar.frame = bar
    topbar.elements = {}
    
    return topbar
end

function isaeva:tabsystem(config)
    local tabsystem = {}
    local parent = config.parent
    
    local container = create("Frame", {
        Name = "tabs",
        Size = UDim2.new(1, -160, 1, 0),
        BackgroundTransparency = 1,
        parent = parent
    })
    
    local layout = create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 0),
        parent = container
    })
    
    tabsystem.container = container
    tabsystem.tabs = {}
    tabsystem.activetab = nil
    
    function tabsystem:addtab(name, closeable)
        local tab = {}
        
        local tabframe = create("Frame", {
            Name = name,
            Size = UDim2.new(0, closeable and 140 or 120, 1, 0),
            BackgroundColor3 = Color3.fromRGB(45, 45, 45),
            BorderSizePixel = 0,
            parent = container
        })
        
        local separator = create("Frame", {
            Size = UDim2.new(0, 1, 1, 0),
            Position = UDim2.new(1, 0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(60, 60, 60),
            BorderSizePixel = 0,
            parent = tabframe
        })
        
        local icon = create("ImageLabel", {
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0, 12, 0.5, -8),
            BackgroundTransparency = 1,
            Image = "rbxasset://textures/ui/TopBar/iconMain.png",
            ImageColor3 = Color3.fromRGB(200, 200, 200),
            parent = tabframe
        })
        
        local label = create("TextLabel", {
            Size = UDim2.new(1, closeable and -75 or -40, 1, 0),
            Position = UDim2.new(0, 35, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            parent = tabframe
        })
        
        if closeable then
            local closebutton = create("TextButton", {
                Size = UDim2.new(0, 26, 0, 26),
                Position = UDim2.new(1, -32, 0.5, -13),
                BackgroundTransparency = 1,
                Text = "×",
                TextColor3 = Color3.fromRGB(150, 150, 150),
                TextSize = 18,
                Font = Enum.Font.GothamBold,
                parent = tabframe
            })
            
            create("UICorner", {
                CornerRadius = UDim.new(0, 4),
                parent = closebutton
            })
            
            closebutton.MouseEnter:Connect(function()
                closebutton.BackgroundTransparency = 0
                closebutton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                tween(closebutton, {TextColor3 = Color3.fromRGB(255, 255, 255)})
            end)
            
            closebutton.MouseLeave:Connect(function()
                closebutton.BackgroundTransparency = 1
                tween(closebutton, {TextColor3 = Color3.fromRGB(150, 150, 150)})
            end)
            
            closebutton.MouseButton1Click:Connect(function()
                tabframe:Destroy()
                if tab.content then
                    tab.content:Destroy()
                end
            end)
        end
        
        local button = create("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 1,
            parent = tabframe
        })
        
        button.MouseButton1Click:Connect(function()
            tabsystem:activate(tab)
        end)
        
        tab.frame = tabframe
        tab.button = button
        tab.label = label
        tab.icon = icon
        
        table.insert(tabsystem.tabs, tab)
        
        if #tabsystem.tabs == 1 then
            tabsystem:activate(tab)
        end
        
        return tab
    end
    
    function tabsystem:activate(tab)
        for _, t in pairs(tabsystem.tabs) do
            t.frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            if t.content then
                t.content.Visible = false
            end
        end
        
        tab.frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        if tab.content then
            tab.content.Visible = true
        end
        
        tabsystem.activetab = tab
    end
    
    return tabsystem
end

function isaeva:addbutton(config)
    local parent = config.parent
    local size = config.size or UDim2.new(0, 26, 0, 26)
    local position = config.position or UDim2.new(0, 0, 0, 0)
    local text = config.text or "×"
    local textsize = config.textsize or 18
    local callback = config.callback or function() end
    
    local button = create("TextButton", {
        Size = size,
        Position = position,
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = textsize,
        Font = Enum.Font.GothamBold,
        parent = parent
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        parent = button
    })
    
    button.MouseEnter:Connect(function()
        button.BackgroundTransparency = 0
        button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundTransparency = 1
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

function isaeva:menubar(config)
    local menubar = {}
    local parent = config.parent
    
    local bar = create("Frame", {
        Name = "menubar",
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 0, 35),
        BackgroundColor3 = Color3.fromRGB(37, 37, 38),
        BorderSizePixel = 0,
        parent = parent
    })
    
    create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        BorderSizePixel = 0,
        parent = bar
    })
    
    local container = create("Frame", {
        Size = UDim2.new(1, -120, 1, 0),
        BackgroundTransparency = 1,
        parent = bar
    })
    
    local layout = create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 0),
        parent = container
    })
    
    create("UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        parent = container
    })
    
    menubar.frame = bar
    menubar.container = container
    menubar.buttons = {}
    
    function menubar:addbutton(config)
        local text = config.text or "button"
        local icon = config.icon
        local callback = config.callback or function() end
        
        local button = create("TextButton", {
            Size = UDim2.new(0, icon and 80 or 60, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            parent = container
        })
        
        create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            parent = button
        })
        
        if icon then
            local img = create("ImageLabel", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 8, 0.5, -8),
                BackgroundTransparency = 1,
                Image = icon,
                ImageColor3 = Color3.fromRGB(200, 200, 200),
                parent = button
            })
        end
        
        local label = create("TextLabel", {
            Size = UDim2.new(1, icon and -30 or -10, 1, 0),
            Position = UDim2.new(0, icon and 28 or 5, 0, 0),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            parent = button
        })
        
        button.MouseEnter:Connect(function()
            button.BackgroundTransparency = 0
            button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
        
        button.MouseLeave:Connect(function()
            button.BackgroundTransparency = 1
        end)
        
        button.MouseButton1Click:Connect(callback)
        
        table.insert(menubar.buttons, button)
        
        return button
    end
    
    return menubar
end

function isaeva:sidebar(config)
    local sidebar = {}
    local parent = config.parent
    local width = config.width or 210
    
    local bar = create("Frame", {
        Name = "sidebar",
        Size = UDim2.new(0, width, 1, -70),
        Position = UDim2.new(0, 0, 0, 70),
        BackgroundColor3 = Color3.fromRGB(37, 37, 38),
        BorderSizePixel = 0,
        parent = parent
    })
    
    create("Frame", {
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, -1, 0, 0),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        BorderSizePixel = 0,
        parent = bar
    })
    
    sidebar.frame = bar
    
    return sidebar
end

function isaeva:searchbox(config)
    local parent = config.parent
    local position = config.position or UDim2.new(0, 10, 0, 10)
    local size = config.size or UDim2.new(1, -20, 0, 30)
    
    local searchframe = create("Frame", {
        Size = size,
        Position = position,
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        BorderSizePixel = 0,
        parent = parent
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, 4),
        parent = searchframe
    })
    
    local searchicon = create("ImageLabel", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 8, 0.5, -8),
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/InspectMenu/ico_search.png",
        ImageColor3 = Color3.fromRGB(120, 120, 120),
        parent = searchframe
    })
    
    local searchbox = create("TextBox", {
        Size = UDim2.new(1, -32, 1, 0),
        Position = UDim2.new(0, 28, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = "Search...",
        TextColor3 = Color3.fromRGB(200, 200, 200),
        PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        parent = searchframe
    })
    
    return searchbox
end

function isaeva:folderlist(config)
    local folderlist = {}
    local parent = config.parent
    local position = config.position or UDim2.new(0, 0, 0, 50)
    local size = config.size or UDim2.new(1, 0, 1, -50)
    
    local scroll = create("ScrollingFrame", {
        Size = size,
        Position = position,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        parent = parent
    })
    
    local layout = create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        parent = scroll
    })
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)
    
    folderlist.frame = scroll
    folderlist.folders = {}
    
    function folderlist:addfolder(name, icon)
        local folder = {}
        
        local folderframe = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundTransparency = 1,
            Text = "",
            parent = scroll
        })
        
        create("UICorner", {
            CornerRadius = UDim.new(0, 4),
            parent = folderframe
        })
        
        local arrow = create("TextLabel", {
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.new(0, 5, 0, 0),
            BackgroundTransparency = 1,
            Text = "›",
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            parent = folderframe
        })
        
        local foldericon = create("TextLabel", {
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.new(0, 25, 0, 0),
            BackgroundTransparency = 1,
            Text = icon or "📁",
            TextSize = 14,
            parent = folderframe
        })
        
        local label = create("TextLabel", {
            Size = UDim2.new(1, -55, 1, 0),
            Position = UDim2.new(0, 50, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            parent = folderframe
        })
        
        folderframe.MouseEnter:Connect(function()
            folderframe.BackgroundTransparency = 0
            folderframe.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
        
        folderframe.MouseLeave:Connect(function()
            folderframe.BackgroundTransparency = 1
        end)
        
        folder.frame = folderframe
        folder.arrow = arrow
        folder.label = label
        
        table.insert(folderlist.folders, folder)
        
        return folder
    end
    
    return folderlist
end

function isaeva:editor(config)
    local editor = {}
    local parent = config.parent
    local position = config.position or UDim2.new(0, 210, 0, 70)
    local size = config.size or UDim2.new(1, -210, 1, -70)
    local defaulttext = config.text or ""
    
    local editorframe = create("Frame", {
        Name = "editor",
        Size = size,
        Position = position,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        parent = parent
    })
    
    local linenumbers = create("Frame", {
        Size = UDim2.new(0, 50, 1, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        parent = editorframe
    })
    
    create("Frame", {
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, -1, 0, 0),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        BorderSizePixel = 0,
        parent = linenumbers
    })
    
    local linenumbercontainer = create("Frame", {
        Size = UDim2.new(1, -10, 1, 0),
        BackgroundTransparency = 1,
        parent = linenumbers
    })
    
    local linenumber1 = create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 5),
        BackgroundTransparency = 1,
        Text = "1",
        TextColor3 = Color3.fromRGB(120, 120, 120),
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Right,
        parent = linenumbercontainer
    })
    
    local codebox = create("TextBox", {
        Size = UDim2.new(1, -60, 1, -10),
        Position = UDim2.new(0, 55, 0, 5),
        BackgroundTransparency = 1,
        Text = defaulttext,
        TextColor3 = Color3.fromRGB(206, 145, 120),
        TextSize = 15,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ClearTextOnFocus = false,
        MultiLine = true,
        parent = editorframe
    })
    
    codebox:GetPropertyChangedSignal("Text"):Connect(function()
        local lines = 1
        for _ in codebox.Text:gmatch("\n") do
            lines = lines + 1
        end
        
        linenumbercontainer:ClearAllChildren()
        
        for i = 1, lines do
            create("TextLabel", {
                Size = UDim2.new(1, 0, 0, 20),
                Position = UDim2.new(0, 0, 0, (i - 1) * 20 + 5),
                BackgroundTransparency = 1,
                Text = tostring(i),
                TextColor3 = Color3.fromRGB(120, 120, 120),
                TextSize = 14,
                Font = Enum.Font.Code,
                TextXAlignment = Enum.TextXAlignment.Right,
                parent = linenumbercontainer
            })
        end
    end)
    
    editor.frame = editorframe
    editor.textbox = codebox
    
    return editor
end

function isaeva:rightbuttons(config)
    local parent = config.parent
    
    local container = create("Frame", {
        Size = UDim2.new(0, 120, 1, 0),
        Position = UDim2.new(1, -120, 0, 0),
        BackgroundTransparency = 1,
        parent = parent
    })
    
    local layout = create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        parent = container
    })
    
    create("UIPadding", {
        PaddingRight = UDim.new(0, 8),
        parent = container
    })
    
    return container
end

function isaeva:iconbutton(config)
    local parent = config.parent
    local icon = config.icon
    local text = config.text
    local callback = config.callback or function() end
    
    local button = create("TextButton", {
        Size = UDim2.new(0, text and 90 or 35, 1, -8),
        Position = UDim2.new(0, 0, 0, 4),
        BackgroundTransparency = 1,
        Text = "",
        parent = parent
    })
    
    create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        parent = button
    })
    
    if icon then
        local img = create("ImageLabel", {
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, text and 6 or 8, 0.5, -9),
            BackgroundTransparency = 1,
            Image = icon,
            ImageColor3 = Color3.fromRGB(184, 106, 115),
            parent = button
        })
    end
    
    if text then
        local label = create("TextLabel", {
            Size = UDim2.new(1, -30, 1, 0),
            Position = UDim2.new(0, 28, 0, 0),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = Color3.fromRGB(184, 106, 115),
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            parent = button
        })
    end
    
    button.MouseEnter:Connect(function()
        button.BackgroundTransparency = 0
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundTransparency = 1
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

function isaeva:label(config)
    local parent = config.parent
    local text = config.text or "label"
    local size = config.size or UDim2.new(1, 0, 0, 20)
    local position = config.position or UDim2.new(0, 0, 0, 0)
    
    local label = create("TextLabel", {
        Size = size,
        Position = position,
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        parent = parent
    })
    
    return label
end

function isaeva:button(config)
    local parent = config.parent
    local text = config.text or "button"
    local size = config.size or UDim2.new(0, 100, 0, 32)
    local position = config.position or UDim2.new(0, 0, 0, 0)
    local callback = config.callback or function() end
    
    local button = create("TextButton", {
        Size = size,
        Position = position,
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.fromRGB(140, 140, 140),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        parent = parent
    })
    
    button.MouseButton1Click:Connect(callback)
    
    button.MouseEnter:Connect(function()
        tween(button, {TextColor3 = Color3.fromRGB(220, 220, 220)})
    end)
    
    button.MouseLeave:Connect(function()
        tween(button, {TextColor3 = Color3.fromRGB(140, 140, 140)})
    end)
    
    return button
end

return isaeva
