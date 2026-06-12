local InputService = game:GetService('UserInputService');
local TextService = game:GetService('TextService');
local CoreGui = game:GetService('CoreGui');
local Teams = game:GetService('Teams');
local Players = game:GetService('Players');
local RunService = game:GetService('RunService')
local TweenService = game:GetService('TweenService');
local RenderStepped = RunService.RenderStepped;
local LocalPlayer = Players.LocalPlayer;
local Mouse = LocalPlayer:GetMouse();

local ProtectGui = protectgui or (syn and syn.protect_gui) or (function() end);

local ScreenGui = Instance.new('ScreenGui');
ProtectGui(ScreenGui);

ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global;
ScreenGui.Parent = CoreGui;

local Toggles = {};
local Options = {};

getgenv().Toggles = Toggles;
getgenv().Options = Options;

local Library = {
    Registry = {};
    RegistryMap = {};
    HudRegistry = {};

    -- UNDETEK II Color Scheme
    FontColor = Color3.fromRGB(255, 255, 255);
    MainColor = Color3.fromRGB(20, 20, 20);
    BackgroundColor = Color3.fromRGB(15, 15, 15);
    AccentColor = Color3.fromRGB(255, 105, 180); -- Pink for title
    AccentColorDark = Color3.fromRGB(200, 50, 150);
    OutlineColor = Color3.fromRGB(40, 40, 40);
    RiskColor = Color3.fromRGB(255, 50, 50);
    NotificationColor = Color3.fromRGB(20, 20, 20);
    WatermarkColor = Color3.fromRGB(20, 20, 20);

    -- UNDETEK II specific colors
    OnColor = Color3.fromRGB(0, 255, 0);       -- Green for "On"
    OffColor = Color3.fromRGB(255, 0, 0);      -- Red for "Off"
    NumberColor = Color3.fromRGB(100, 150, 255); -- Blue for numbers
    ButtonHighlight = Color3.fromRGB(255, 140, 0); -- Orange for selected button

    Black = Color3.new(0, 0, 0);
    Font = Enum.Font.Code;
    FontSize = 14;
    TitleFontSize = 20;

    WindowCornerRadius = UDim.new(0, 0);
    GroupboxCornerRadius = UDim.new(0, 0);
    TabButtonCornerRadius = UDim.new(0, 0);
    ButtonCornerRadius = UDim.new(0, 0);
    SliderCornerRadius = UDim.new(0, 0);
    ToggleCornerRadius = UDim.new(0, 0);
    InputCornerRadius = UDim.new(0, 0);
    DropdownCornerRadius = UDim.new(0, 0);
    ColorPickerCornerRadius = UDim.new(0, 0);
    KeyPickerCornerRadius = UDim.new(0, 0);
    NotificationCornerRadius = UDim.new(0, 0);
    WatermarkCornerRadius = UDim.new(0, 0);
    KeybindCornerRadius = UDim.new(0, 0);
    TooltipCornerRadius = UDim.new(0, 0);

    OpenedFrames = {};
    DependencyBoxes = {};
    Signals = {};
    ScreenGui = ScreenGui;
};

function Library:SetTheme(Theme)
    for Key, Value in next, Theme do
        Library[Key] = Value;
    end;
    Library.AccentColorDark = Library:GetDarkerColor(Library.AccentColor);
    Library:UpdateColorsUsingRegistry();
end;

local RainbowStep = 0
local Hue = 0

table.insert(Library.Signals, RunService.Heartbeat:Connect(function(Delta)
    RainbowStep = RainbowStep + Delta
    if RainbowStep >= (1 / 60) then
        RainbowStep = 0
        Hue = Hue + (1 / 400);
        if Hue > 1 then
            Hue = 0;
        end;
        Library.CurrentRainbowHue = Hue;
        Library.CurrentRainbowColor = Color3.fromHSV(Hue, 0.8, 1);
    end
end))

local function GetPlayersString()
    local PlayerList = Players:GetPlayers();
    for i = 1, #PlayerList do
        PlayerList[i] = PlayerList[i].Name;
    end;
    table.sort(PlayerList, function(str1, str2) return str1 < str2 end);
    return PlayerList;
end;

local function GetTeamsString()
    local TeamList = Teams:GetTeams();
    for i = 1, #TeamList do
        TeamList[i] = TeamList[i].Name;
    end;
    table.sort(TeamList, function(str1, str2) return str1 < str2 end);
    return TeamList;
end;

function Library:SafeCallback(f, ...)
    if (not f) then return; end;
    if not Library.NotifyOnError then
        return f(...);
    end;
    local success, event = pcall(f, ...);
    if not success then
        local _, i = event:find(":%d+: ");
        if not i then
            return Library:Notify(event);
        end;
        return Library:Notify(event:sub(i + 1), 3);
    end;
end;

function Library:AttemptSave()
    if Library.SaveManager then
        Library.SaveManager:Save();
    end;
end;

function Library:Create(Class, Properties)
    local _Instance = Class;
    if type(Class) == 'string' then
        _Instance = Instance.new(Class);
    end;
    for Property, Value in next, Properties do
        _Instance[Property] = Value;
    end;
    return _Instance;
end;

function Library:ApplyTextStroke(Inst)
    Inst.TextStrokeTransparency = 1;
    Library:Create('UIStroke', {
        Color = Color3.new(0, 0, 0);
        Thickness = 1;
        LineJoinMode = Enum.LineJoinMode.Miter;
        Parent = Inst;
    });
end;

function Library:CreateLabel(Properties, IsHud)
    local _Instance = Library:Create('TextLabel', {
        BackgroundTransparency = 1;
        Font = Library.Font;
        TextColor3 = Library.FontColor;
        TextSize = Library.FontSize;
        TextStrokeTransparency = 0;
    });
    Library:ApplyTextStroke(_Instance);
    Library:AddToRegistry(_Instance, {
        TextColor3 = 'FontColor';
    }, IsHud);
    return Library:Create(_Instance, Properties);
end;

function Library:MakeDraggable(Instance, Cutoff)
    Instance.Active = true;
    local dragging = false;
    local dragInput = nil;
    local dragOffset = nil;

    Instance.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            local ObjPos = Vector2.new(
                Mouse.X - Instance.AbsolutePosition.X,
                Mouse.Y - Instance.AbsolutePosition.Y
            );
            if ObjPos.Y > (Cutoff or 40) then
                return;
            end;
            dragging = true;
            dragOffset = Vector2.new(
                Mouse.X - Instance.AbsolutePosition.X,
                Mouse.Y - Instance.AbsolutePosition.Y
            );
            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    dragging = false;
                end;
            end);
        end;
    end);

    Instance.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = Input;
        end;
    end);

    Library:GiveSignal(InputService.InputChanged:Connect(function(Input)
        if Input == dragInput and dragging then
            if not Instance or not Instance.Parent then
                dragging = false;
                return;
            end;
            local newX = Mouse.X - dragOffset.X + (Instance.Size.X.Offset * Instance.AnchorPoint.X);
            local newY = Mouse.Y - dragOffset.Y + (Instance.Size.Y.Offset * Instance.AnchorPoint.Y);
            Instance.Position = UDim2.new(0, newX, 0, newY);
        end;
    end));
end;

function Library:MouseIsOverOpenedFrame()
    for Frame, _ in next, Library.OpenedFrames do
        local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;
        if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X
            and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then
            return true;
        end;
    end;
end;

function Library:IsMouseOverFrame(Frame)
    local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;
    if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X
        and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then
        return true;
    end;
end;

function Library:UpdateDependencyBoxes()
    for _, Depbox in next, Library.DependencyBoxes do
        Depbox:Update();
    end;
end;

function Library:MapValue(Value, MinA, MaxA, MinB, MaxB)
    return (1 - ((Value - MinA) / (MaxA - MinA))) * MinB + ((Value - MinA) / (MaxA - MinA)) * MaxB;
end;

function Library:GetTextBounds(Text, Font, Size, Resolution)
    local Bounds = TextService:GetTextSize(Text, Size, Font, Resolution or Vector2.new(1920, 1080))
    return Bounds.X, Bounds.Y
end;

function Library:GetDarkerColor(Color)
    local H, S, V = Color3.toHSV(Color);
    return Color3.fromHSV(H, S, V / 1.5);
end;
Library.AccentColorDark = Library:GetDarkerColor(Library.AccentColor);

function Library:AddToRegistry(Instance, Properties, IsHud)
    local Idx = #Library.Registry + 1;
    local Data = {
        Instance = Instance;
        Properties = Properties;
        Idx = Idx;
    };
    table.insert(Library.Registry, Data);
    Library.RegistryMap[Instance] = Data;
    if IsHud then
        table.insert(Library.HudRegistry, Data);
    end;
end;

function Library:RemoveFromRegistry(Instance)
    local Data = Library.RegistryMap[Instance];
    if Data then
        for Idx = #Library.Registry, 1, -1 do
            if Library.Registry[Idx] == Data then
                table.remove(Library.Registry, Idx);
            end;
        end;
        for Idx = #Library.HudRegistry, 1, -1 do
            if Library.HudRegistry[Idx] == Data then
                table.remove(Library.HudRegistry, Idx);
            end;
        end;
        Library.RegistryMap[Instance] = nil;
    end;
end;

function Library:UpdateColorsUsingRegistry()
    for Idx, Object in next, Library.Registry do
        for Property, ColorIdx in next, Object.Properties do
            if type(ColorIdx) == 'string' then
                Object.Instance[Property] = Library[ColorIdx];
            elseif type(ColorIdx) == 'function' then
                Object.Instance[Property] = ColorIdx()
            end
        end;
    end;
end;

function Library:GiveSignal(Signal)
    table.insert(Library.Signals, Signal)
end

function Library:Unload()
    for Idx = #Library.Signals, 1, -1 do
        local Connection = table.remove(Library.Signals, Idx)
        Connection:Disconnect()
    end
    if Library.OnUnload then
        Library.OnUnload()
    end
    ScreenGui:Destroy()
end

function Library:OnUnload(Callback)
    Library.OnUnload = Callback
end

Library:GiveSignal(ScreenGui.DescendantRemoving:Connect(function(Instance)
    if Library.RegistryMap[Instance] then
        Library:RemoveFromRegistry(Instance);
    end;
end))

-- ==================== UNDETEK II STYLE WINDOW ====================

function Library:CreateWindow(Title)
    local Window = {
        Elements = {};
        Title = Title or 'UNDETEK II';
    };

    local WindowWidth = 200;
    local WindowPadding = 8;

    -- Main outer frame (dark background)
    local Outer = Library:Create('Frame', {
        BackgroundColor3 = Library.BackgroundColor;
        BorderColor3 = Library.OutlineColor;
        BorderSizePixel = 1;
        Position = UDim2.fromOffset(175, 50);
        Size = UDim2.fromOffset(WindowWidth, 300);
        ZIndex = 1;
        Parent = ScreenGui;
        Active = true;
    });

    Library:MakeDraggable(Outer, 35);

    Library:AddToRegistry(Outer, {
        BackgroundColor3 = 'BackgroundColor';
        BorderColor3 = 'OutlineColor';
    });

    -- Title label with pink/magenta color
    local TitleLabel = Library:CreateLabel({
        Position = UDim2.new(0, 0, 0, 4);
        Size = UDim2.new(1, 0, 0, 28);
        Text = Window.Title;
        TextSize = Library.TitleFontSize;
        TextXAlignment = Enum.TextXAlignment.Center;
        TextColor3 = Library.AccentColor;
        Font = Enum.Font.GothamBold;
        ZIndex = 2;
        Parent = Outer;
    });

    Library:AddToRegistry(TitleLabel, {
        TextColor3 = 'AccentColor';
    });

    -- Container for elements
    local Container = Library:Create('Frame', {
        BackgroundTransparency = 1;
        Position = UDim2.new(0, WindowPadding, 0, 32);
        Size = UDim2.new(1, -WindowPadding * 2, 1, -36);
        ZIndex = 2;
        Parent = Outer;
    });

    local Layout = Library:Create('UIListLayout', {
        Padding = UDim.new(0, 2);
        FillDirection = Enum.FillDirection.Vertical;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Parent = Container;
    });

    -- Function to resize window based on content
    local function ResizeWindow()
        local totalHeight = 32; -- title height
        for _, child in ipairs(Container:GetChildren()) do
            if child:IsA('Frame') or child:IsA('TextLabel') then
                totalHeight = totalHeight + child.Size.Y.Offset + 2;
            end
        end
        Outer.Size = UDim2.fromOffset(WindowWidth, totalHeight + 8);
    end

    Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
        ResizeWindow();
    end);

    -- ==================== ELEMENT CREATION FUNCTIONS ====================

    -- Add a toggle with left label + right "On"/"Off" value
    function Window:AddToggle(Idx, Info)
        assert(Info.Text, 'AddToggle: Missing Text string.')

        local Toggle = {
            Value = Info.Default or false;
            Type = 'Toggle';
            Callback = Info.Callback or function(Value) end;
        };

        local Row = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Size = UDim2.new(1, 0, 0, 20);
            ZIndex = 3;
            Parent = Container;
        });

        -- Left label
        local Label = Library:CreateLabel({
            Position = UDim2.new(0, 0, 0, 0);
            Size = UDim2.new(0.6, 0, 1, 0);
            Text = Info.Text;
            TextSize = Library.FontSize;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextYAlignment = Enum.TextYAlignment.Center;
            ZIndex = 4;
            Parent = Row;
        });

        -- Right value label (On/Off)
        local ValueLabel = Library:CreateLabel({
            Position = UDim2.new(0.6, 0, 0, 0);
            Size = UDim2.new(0.4, 0, 1, 0);
            Text = Toggle.Value and 'On' or 'Off';
            TextSize = Library.FontSize;
            TextXAlignment = Enum.TextXAlignment.Right;
            TextYAlignment = Enum.TextYAlignment.Center;
            TextColor3 = Toggle.Value and Library.OnColor or Library.OffColor;
            ZIndex = 4;
            Parent = Row;
        });

        function Toggle:Display()
            ValueLabel.Text = Toggle.Value and 'On' or 'Off';
            ValueLabel.TextColor3 = Toggle.Value and Library.OnColor or Library.OffColor;
        end;

        function Toggle:SetValue(Bool)
            Bool = (not not Bool);
            Toggle.Value = Bool;
            Toggle:Display();
            Library:SafeCallback(Toggle.Callback, Toggle.Value);
            Library:SafeCallback(Toggle.Changed, Toggle.Value);
        end;

        function Toggle:OnChanged(Func)
            Toggle.Changed = Func;
            Func(Toggle.Value);
        end;

        -- Click area
        local ClickArea = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 5;
            Parent = Row;
        });

        ClickArea.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Toggle:SetValue(not Toggle.Value);
                Library:AttemptSave();
            end;
        end);

        Toggle:Display();
        Toggles[Idx] = Toggle;
        ResizeWindow();
        return Toggle;
    end;

    -- Add a key setting (label + key number)
    function Window:AddKey(Idx, Info)
        assert(Info.Text, 'AddKey: Missing Text string.')

        local KeySetting = {
            Value = Info.Default or 1;
            Type = 'Key';
            Callback = Info.Callback or function(Value) end;
        };

        local Row = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Size = UDim2.new(1, 0, 0, 20);
            ZIndex = 3;
            Parent = Container;
        });

        local Label = Library:CreateLabel({
            Position = UDim2.new(0, 0, 0, 0);
            Size = UDim2.new(0.6, 0, 1, 0);
            Text = Info.Text;
            TextSize = Library.FontSize;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextYAlignment = Enum.TextYAlignment.Center;
            ZIndex = 4;
            Parent = Row;
        });

        local ValueLabel = Library:CreateLabel({
            Position = UDim2.new(0.6, 0, 0, 0);
            Size = UDim2.new(0.4, 0, 1, 0);
            Text = tostring(KeySetting.Value);
            TextSize = Library.FontSize;
            TextXAlignment = Enum.TextXAlignment.Right;
            TextYAlignment = Enum.TextYAlignment.Center;
            TextColor3 = Library.NumberColor;
            ZIndex = 4;
            Parent = Row;
        });

        function KeySetting:Display()
            ValueLabel.Text = tostring(KeySetting.Value);
        end;

        function KeySetting:SetValue(Value)
            KeySetting.Value = Value;
            KeySetting:Display();
            Library:SafeCallback(KeySetting.Callback, KeySetting.Value);
            Library:SafeCallback(KeySetting.Changed, KeySetting.Value);
        end;

        function KeySetting:OnChanged(Func)
            KeySetting.Changed = Func;
            Func(KeySetting.Value);
        end;

        KeySetting:Display();
        Options[Idx] = KeySetting;
        ResizeWindow();
        return KeySetting;
    end;

    -- Add a slider (label + number value)
    function Window:AddSlider(Idx, Info)
        assert(Info.Default, 'AddSlider: Missing default value.');
        assert(Info.Text, 'AddSlider: Missing slider text.');
        assert(Info.Min, 'AddSlider: Missing minimum value.');
        assert(Info.Max, 'AddSlider: Missing maximum value.');

        local Slider = {
            Value = Info.Default;
            Min = Info.Min;
            Max = Info.Max;
            Type = 'Slider';
            Callback = Info.Callback or function(Value) end;
        };

        local Row = Library:Create('Frame', {
            BackgroundTransparency = 1;
            Size = UDim2.new(1, 0, 0, 20);
            ZIndex = 3;
            Parent = Container;
        });

        local Label = Library:CreateLabel({
            Position = UDim2.new(0, 0, 0, 0);
            Size = UDim2.new(0.6, 0, 1, 0);
            Text = Info.Text;
            TextSize = Library.FontSize;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextYAlignment = Enum.TextYAlignment.Center;
            ZIndex = 4;
            Parent = Row;
        });

        local ValueLabel = Library:CreateLabel({
            Position = UDim2.new(0.6, 0, 0, 0);
            Size = UDim2.new(0.4, 0, 1, 0);
            Text = tostring(Slider.Value);
            TextSize = Library.FontSize;
            TextXAlignment = Enum.TextXAlignment.Right;
            TextYAlignment = Enum.TextYAlignment.Center;
            TextColor3 = Library.NumberColor;
            ZIndex = 4;
            Parent = Row;
        });

        function Slider:Display()
            ValueLabel.Text = tostring(Slider.Value);
        end;

        function Slider:SetValue(Value)
            local Num = tonumber(Value);
            if not Num then return; end;
            Num = math.clamp(Num, Slider.Min, Slider.Max);
            Slider.Value = Num;
            Slider:Display();
            Library:SafeCallback(Slider.Callback, Slider.Value);
            Library:SafeCallback(Slider.Changed, Slider.Value);
        end;

        function Slider:OnChanged(Func)
            Slider.Changed = Func;
            Func(Slider.Value);
        end;

        Slider:Display();
        Options[Idx] = Slider;
        ResizeWindow();
        return Slider;
    end;

    -- Add a button (highlighted row)
    function Window:AddButton(Idx, Info)
        assert(Info.Text, 'AddButton: Missing Text string.')

        local Button = {
            Type = 'Button';
            Callback = Info.Callback or function() end;
        };

        local Row = Library:Create('Frame', {
            BackgroundColor3 = Library.ButtonHighlight;
            BorderSizePixel = 0;
            Size = UDim2.new(1, 0, 0, 22);
            ZIndex = 3;
            Parent = Container;
        });

        local Label = Library:CreateLabel({
            Position = UDim2.new(0, 4, 0, 0);
            Size = UDim2.new(1, -8, 1, 0);
            Text = Info.Text;
            TextSize = Library.FontSize;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextYAlignment = Enum.TextYAlignment.Center;
            TextColor3 = Color3.fromRGB(255, 255, 255);
            ZIndex = 4;
            Parent = Row;
        });

        Row.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Library:SafeCallback(Button.Callback);
            end;
        end);

        ResizeWindow();
        return Button;
    end;

    -- Toggle window visibility
    local Toggled = true;
    function Library:Toggle()
        Toggled = not Toggled;
        Outer.Visible = Toggled;
    end;

    Library:GiveSignal(InputService.InputBegan:Connect(function(Input, Processed)
        if Input.KeyCode == Enum.KeyCode.RightControl or (Input.KeyCode == Enum.KeyCode.RightShift and (not Processed)) then
            task.spawn(Library.Toggle)
        end
    end))

    Window.Holder = Outer;
    return Window;
end;

-- ==================== NOTIFICATIONS ====================

Library.NotificationArea = Library:Create('Frame', {
    BackgroundTransparency = 1;
    Position = UDim2.new(0, 0, 0, 40);
    Size = UDim2.new(0, 300, 0, 200);
    ZIndex = 100;
    Parent = ScreenGui;
});

Library:Create('UIListLayout', {
    Padding = UDim.new(0, 4);
    FillDirection = Enum.FillDirection.Vertical;
    SortOrder = Enum.SortOrder.LayoutOrder;
    Parent = Library.NotificationArea;
});

function Library:Notify(Text, Time)
    local XSize, YSize = Library:GetTextBounds(Text, Library.Font, 14);
    YSize = YSize + 7

    local NotifyOuter = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        Position = UDim2.new(0, 100, 0, 10);
        Size = UDim2.new(0, 0, 0, YSize);
        ClipsDescendants = true;
        ZIndex = 100;
        Parent = Library.NotificationArea;
    });

    local NotifyInner = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor;
        BorderColor3 = Library.OutlineColor;
        BorderMode = Enum.BorderMode.Inset;
        Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 101;
        Parent = NotifyOuter;
    });

    Library:AddToRegistry(NotifyInner, {
        BackgroundColor3 = 'MainColor';
        BorderColor3 = 'OutlineColor';
    }, true);

    local LeftColor = Library:Create('Frame', {
        BackgroundColor3 = Library.AccentColor;
        BorderSizePixel = 0;
        Position = UDim2.new(0, -1, 0, -1);
        Size = UDim2.new(0, 3, 1, 2);
        ZIndex = 104;
        Parent = NotifyOuter;
    });

    Library:AddToRegistry(LeftColor, {
        BackgroundColor3 = 'AccentColor';
    }, true);

    local NotifyLabel = Library:CreateLabel({
        Position = UDim2.new(0, 4, 0, 0);
        Size = UDim2.new(1, -4, 1, 0);
        Text = Text;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextSize = Library.FontSize;
        ZIndex = 103;
        Parent = NotifyInner;
    });

    pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, XSize + 8 + 4, 0, YSize), 'Out', 'Quad', 0.4, true);

    task.spawn(function()
        wait(Time or 5);
        pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, 0, 0, YSize), 'Out', 'Quad', 0.4, true);
        wait(0.4);
        NotifyOuter:Destroy();
    end);
end;

-- ==================== WATERMARK ====================

local WatermarkOuter = Library:Create('Frame', {
    BorderColor3 = Color3.new(0, 0, 0);
    Position = UDim2.new(0, 100, 0, -25);
    Size = UDim2.new(0, 213, 0, 20);
    ZIndex = 200;
    Visible = false;
    Parent = ScreenGui;
});

local WatermarkInner = Library:Create('Frame', {
    BackgroundColor3 = Library.MainColor;
    BorderColor3 = Library.AccentColor;
    BorderMode = Enum.BorderMode.Inset;
    Size = UDim2.new(1, 0, 1, 0);
    ZIndex = 201;
    Parent = WatermarkOuter;
});

Library:AddToRegistry(WatermarkInner, {
    BorderColor3 = 'AccentColor';
});

local WatermarkLabel = Library:CreateLabel({
    Position = UDim2.new(0, 5, 0, 0);
    Size = UDim2.new(1, -4, 1, 0);
    TextSize = Library.FontSize;
    TextXAlignment = Enum.TextXAlignment.Left;
    ZIndex = 203;
    Parent = WatermarkInner;
});

Library.Watermark = WatermarkOuter;
Library.WatermarkText = WatermarkLabel;
Library:MakeDraggable(Library.Watermark);

function Library:SetWatermarkVisibility(Bool)
    Library.Watermark.Visible = Bool;
end;

function Library:SetWatermark(Text)
    local X, Y = Library:GetTextBounds(Text, Library.Font, 14);
    Library.Watermark.Size = UDim2.new(0, X + 15, 0, (Y * 1.5) + 3);
    Library:SetWatermarkVisibility(true)
    Library.WatermarkText.Text = Text;
end;

-- ==================== KEYBINDS ====================

local KeybindOuter = Library:Create('Frame', {
    AnchorPoint = Vector2.new(0, 0.5);
    BorderColor3 = Color3.new(0, 0, 0);
    Position = UDim2.new(0, 10, 0.5, 0);
    Size = UDim2.new(0, 210, 0, 20);
    Visible = false;
    ZIndex = 100;
    Parent = ScreenGui;
});

local KeybindInner = Library:Create('Frame', {
    BackgroundColor3 = Library.MainColor;
    BorderColor3 = Library.OutlineColor;
    BorderMode = Enum.BorderMode.Inset;
    Size = UDim2.new(1, 0, 1, 0);
    ZIndex = 101;
    Parent = KeybindOuter;
});

Library:AddToRegistry(KeybindInner, {
    BackgroundColor3 = 'MainColor';
    BorderColor3 = 'OutlineColor';
}, true);

local ColorFrame = Library:Create('Frame', {
    BackgroundColor3 = Library.AccentColor;
    BorderSizePixel = 0;
    Size = UDim2.new(1, 0, 0, 2);
    ZIndex = 102;
    Parent = KeybindInner;
});

Library:AddToRegistry(ColorFrame, {
    BackgroundColor3 = 'AccentColor';
}, true);

local KeybindLabel = Library:CreateLabel({
    Size = UDim2.new(1, 0, 0, 20);
    Position = UDim2.fromOffset(5, 2),
    TextXAlignment = Enum.TextXAlignment.Left;
    Text = 'Keybinds';
    ZIndex = 104;
    Parent = KeybindInner;
});

local KeybindContainer = Library:Create('Frame', {
    BackgroundTransparency = 1;
    Size = UDim2.new(1, 0, 1, -20);
    Position = UDim2.new(0, 0, 0, 20);
    ZIndex = 1;
    Parent = KeybindInner;
});

Library:Create('UIListLayout', {
    FillDirection = Enum.FillDirection.Vertical;
    SortOrder = Enum.SortOrder.LayoutOrder;
    Parent = KeybindContainer;
});

Library:Create('UIPadding', {
    PaddingLeft = UDim.new(0, 5),
    Parent = KeybindContainer,
})

Library.KeybindFrame = KeybindOuter;
Library.KeybindContainer = KeybindContainer;
Library:MakeDraggable(KeybindOuter);

-- ==================== PLAYER UPDATES ====================

local function OnPlayerChange()
    local PlayerList = GetPlayersString();
    for _, Value in next, Options do
        if Value.Type == 'Dropdown' and Value.SpecialType == 'Player' then
            Value:SetValues(PlayerList);
        end;
    end;
end;

Players.PlayerAdded:Connect(OnPlayerChange);
Players.PlayerRemoving:Connect(OnPlayerChange);

getgenv().Library = Library
return Library
