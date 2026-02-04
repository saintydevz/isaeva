local isaeva = {}

local tweenservice = game:GetService("TweenService")
local userinputservice = game:GetService("UserInputService")
local textservice = game:GetService("TextService")

local screen = game:GetService("CoreGui"):FindFirstChild("isaeva_ui")
if screen then
    screen:Destroy()
end

screen = Instance.new("ScreenGui")
screen.Name = "isaeva_ui"
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.Parent = game:GetService("CoreGui")

local function tween(instance, properties, duration)
    local info = TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
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
    
    local title = config.title or "script #1"
    local size = config.size or UDim2.new(0, 730, 0, 455)
    
    local main = create("Frame", {
        Name = "main",
        Size = size,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        parent = screen
    })
    
    local topbar = create("Frame", {
        Name = "topbar",
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Color3.fromRGB(37, 37, 38),
        BorderSizePixel = 0,
        parent = main
    })
    
    local tabbar = create("Frame", {
        Name = "tabbar",
        Size = UDim2.new(1, -50, 1, 0),
        BackgroundTransparency = 1,
        parent = topbar
    })
    
    local tablayout = create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        parent = tabbar
    })
    
    local topbarbuttons = create("Frame", {
        Name = "buttons",
        Size = UDim2.new(0, 50, 1, 0),
        Position = UDim2.new(1, -50, 0, 0),
        BackgroundTransparency = 1,
        parent = topbar
    })
    
    local closebutton = create("TextButton", {
        Size = UDim2.new(0, 35, 1, 0),
        Position = UDim2.new(1, -35, 0, 0),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = Color3.fromRGB(200, 200, 200),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        parent = topbarbuttons
    })
    
    closebutton.MouseButton1Click:Connect(function()
        main:Destroy()
    end)
    
    closebutton.MouseEnter:Connect(function()
        closebutton.BackgroundTransparency = 0
        closebutton.BackgroundColor3 = Color3.fromRGB(232, 17, 35)
    end)
    
    closebutton.MouseLeave:Connect(function()
        closebutton.BackgroundTransparency = 1
    end)
    
    local menubar = create("Frame", {
        Name = "menubar",
        Size = UDim2.new(1, 0, 0, 35),
        Position = UDim2.new(0, 0, 0, 35),
        BackgroundColor3 = Color3.fromRGB(37, 37, 38),
        BorderSizePixel = 0,
        parent = main
    })
    
    create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        BorderSizePixel = 0,
        parent = menubar
    })
    
    local menulayout = create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        parent = menubar
    })
    
    create("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        parent = menubar
    })
    
    local menus = {"Local", "Cloud", "Run", "Clear", "Open", "Save"}
    for _, menutext in ipairs(menus) do
        local menubutton = create("TextButton", {
            Size = UDim2.new(0, 60, 1, 0),
            BackgroundTransparency = 1,
            Text = menutext,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 13,
            Font = Enum.Font.Gotham,
            parent = menubar
        })
        
        menubutton.MouseEnter:Connect(function()
            menubutton.BackgroundTransparency = 0
            menubutton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
        
        menubutton.MouseLeave:Connect(function()
            menubutton.BackgroundTransparency = 1
        end)
    end
    
    local sidebar = create("Frame", {
        Name = "sidebar",
        Size = UDim2.new(0, 210, 1, -70),
        Position = UDim2.new(0, 0, 0, 70),
        BackgroundColor3 = Color3.fromRGB(37, 37, 38),
        BorderSizePixel = 0,
        parent = main
    })
    
    create("Frame", {
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, -1, 0, 0),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        BorderSizePixel = 0,
        parent = sidebar
    })
    
    local searchbar = create("Frame", {
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        BorderSizePixel = 0,
        parent = sidebar
    })
    
    local searchbox = create("TextBox", {
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 30, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = "Search...",
        TextColor3 = Color3.fromRGB(200, 200, 200),
        PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        parent = searchbar
    })
    
    local searchicon = create("ImageLabel", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 7, 0.5, -8),
        BackgroundTransparency = 1,
        Image = "rbxasset://textures/ui/InspectMenu/ico_search.png",
        ImageColor3 = Color3.fromRGB(120, 120, 120),
        parent = searchbar
    })
    
    local folderlist = create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -50),
        Position = UDim2.new(0, 0, 0, 50),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        parent = sidebar
    })
    
    local folderslayout = create("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
        parent = folderlist
    })
    
    folderslayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        folderlist.CanvasSize = UDim2.new(0, 0, 0, folderslayout.AbsoluteContentSize.Y)
    end)
    
    local folders = {
        {name = "Scripts", icon = "📁", expanded = false},
        {name = "Workspace", icon = "📁", expanded = false},
        {name = "AutoExec", icon = "📁", expanded = false}
    }
    
    for _, folder in ipairs(folders) do
        local folderbutton = create("TextButton", {
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundTransparency = 1,
            Text = "",
            parent = folderlist
        })
        
        local arrow = create("TextLabel", {
            Size = UDim2.new(0, 20, 1, 0),
            BackgroundTransparency = 1,
            Text = "›",
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            parent = folderbutton
        })
        
        local icon = create("TextLabel", {
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.new(0, 20, 0, 0),
            BackgroundTransparency = 1,
            Text = folder.icon,
            TextSize = 14,
            parent = folderbutton
        })
        
        local label = create("TextLabel", {
            Size = UDim2.new(1, -45, 1, 0),
            Position = UDim2.new(0, 45, 0, 0),
            BackgroundTransparency = 1,
            Text = folder.name,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            parent = folderbutton
        })
        
        folderbutton.MouseEnter:Connect(function()
            folderbutton.BackgroundTransparency = 0
            folderbutton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end)
        
        folderbutton.MouseLeave:Connect(function()
            folderbutton.BackgroundTransparency = 1
        end)
    end
    
    local editor = create("Frame", {
        Name = "editor",
        Size = UDim2.new(1, -210, 1, -70),
        Position = UDim2.new(0, 210, 0, 70),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        parent = main
    })
    
    local linenumbers = create("Frame", {
        Size = UDim2.new(0, 40, 1, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        parent = editor
    })
    
    create("Frame", {
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, -1, 0, 0),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        BorderSizePixel = 0,
        parent = linenumbers
    })
    
    local linenumber = create("TextLabel", {
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 0, 0, 5),
        BackgroundTransparency = 1,
        Text = "1",
        TextColor3 = Color3.fromRGB(120, 120, 120),
        TextSize = 13,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Right,
        parent = linenumbers
    })
    
    local codebox = create("TextBox", {
        Size = UDim2.new(1, -50, 1, -10),
        Position = UDim2.new(0, 45, 0, 5),
        BackgroundTransparency = 1,
        Text = "print('Welcome To Isaeva!')",
        TextColor3 = Color3.fromRGB(206, 145, 120),
        TextSize = 14,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ClearTextOnFocus = false,
        MultiLine = true,
        parent = editor
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
    window.main = main
    window.editor = codebox
    
    function window:addtab(name)
        local tab = create("TextButton", {
            Size = UDim2.new(0, 120, 1, 0),
            BackgroundColor3 = Color3.fromRGB(45, 45, 45),
            BorderSizePixel = 0,
            Text = "",
            parent = tabbar
        })
        
        local tablabel = create("TextLabel", {
            Size = UDim2.new(1, -35, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            parent = tab
        })
        
        local closetab = create("TextButton", {
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(1, -25, 0.5, -10),
            BackgroundTransparency = 1,
            Text = "×",
            TextColor3 = Color3.fromRGB(150, 150, 150),
            TextSize = 16,
            Font = Enum.Font.GothamBold,
            parent = tab
        })
        
        closetab.MouseButton1Click:Connect(function()
            tab:Destroy()
        end)
        
        closetab.MouseEnter:Connect(function()
            closetab.BackgroundTransparency = 0
            closetab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end)
        
        closetab.MouseLeave:Connect(function()
            closetab.BackgroundTransparency = 1
        end)
        
        tab.MouseButton1Click:Connect(function()
            for _, othertab in pairs(window.tabs) do
                othertab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            end
            tab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        end)
        
        table.insert(window.tabs, tab)
        
        if #window.tabs == 1 then
            tab.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        end
        
        return tab
    end
    
    window:addtab(title)
    
    return window
end

return isaeva
