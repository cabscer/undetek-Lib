-- ============================================
-- UNDETEK II - Complete Example with Addons
-- ============================================

-- Replace these with your actual raw GitHub/raw links
local repo = 'https://raw.githubusercontent.com/yourname/yourrepo/main/'

-- Load the UNDETEK II styled library
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()

-- Load addons (SaveManager & ThemeManager)
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- ============================================
-- CREATE WINDOW
-- ============================================

local Window = Library:CreateWindow({
    Title = 'UNDETEK II',
    Center = true,
    AutoShow = true,
    TabPadding = 4,
    MenuFadeTime = 0.2
})

-- ============================================
-- TABS
-- ============================================

local Tabs = {
    Main = Window:AddTab('Combat'),
    Visuals = Window:AddTab('Visuals'),
    Misc = Window:AddTab('Misc'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- ============================================
-- COMBAT TAB (Left Side)
-- ============================================

local CombatLeft = Tabs.Main:AddLeftGroupbox('Aimbot')

CombatLeft:AddToggle('Aimbot', {
    Text = 'Aimbot',
    Default = true,
    Tooltip = 'Enable aimbot assistance',
    Callback = function(Value)
        print('Aimbot:', Value)
    end
})

Toggles.Aimbot:AddKeyPicker('AimbotKey', {
    Default = 'MB2',
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Aimbot Keybind',
    NoUI = false,
    Callback = function(Value)
        print('Aimbot key pressed:', Value)
    end
})

CombatLeft:AddSlider('Smoothness', {
    Text = 'Smooth',
    Default = 65,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        print('Smoothness:', Value)
    end
})

CombatLeft:AddSlider('FOV', {
    Text = 'FOV',
    Default = 100,
    Min = 10,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        print('FOV:', Value)
    end
})

CombatLeft:AddToggle('TriggerBot', {
    Text = 'Trigger',
    Default = false,
    Tooltip = 'Auto-shoot when hovering enemy',
    Callback = function(Value)
        print('Trigger:', Value)
    end
})

Toggles.TriggerBot:AddKeyPicker('TriggerKey', {
    Default = '6',
    Mode = 'Toggle',
    Text = 'Trigger Keybind',
    Callback = function(Value)
        print('Trigger key:', Value)
    end
})

CombatLeft:AddDivider()

CombatLeft:AddToggle('SilentAim', {
    Text = 'Silent Aim',
    Default = false,
    Callback = function(Value)
        print('Silent Aim:', Value)
    end
})

-- ============================================
-- COMBAT TAB (Right Side)
-- ============================================

local CombatRight = Tabs.Main:AddRightGroupbox('Weapon')

CombatRight:AddToggle('NoRecoil', {
    Text = 'No Recoil',
    Default = false,
    Callback = function(Value)
        print('No Recoil:', Value)
    end
})

CombatRight:AddToggle('NoSpread', {
    Text = 'No Spread',
    Default = false,
    Callback = function(Value)
        print('No Spread:', Value)
    end
})

CombatRight:AddToggle('InstantReload', {
    Text = 'Instant Reload',
    Default = false,
    Callback = function(Value)
        print('Instant Reload:', Value)
    end
})

CombatRight:AddSlider('FireRate', {
    Text = 'Fire Rate',
    Default = 1,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Callback = function(Value)
        print('Fire Rate:', Value)
    end
})

-- ============================================
-- VISUALS TAB
-- ============================================

local VisualsLeft = Tabs.Visuals:AddLeftGroupbox('ESP')

VisualsLeft:AddToggle('ESPEnabled', {
    Text = 'Esp',
    Default = true,
    Callback = function(Value)
        print('ESP:', Value)
    end
})

VisualsLeft:AddToggle('Spotted', {
    Text = 'Spotted',
    Default = true,
    Callback = function(Value)
        print('Spotted:', Value)
    end
})

VisualsLeft:AddToggle('AimSpot', {
    Text = 'Aim Spot',
    Default = false,
    Callback = function(Value)
        print('Aim Spot:', Value)
    end
})

VisualsLeft:AddToggle('BoxESP', {
    Text = 'Box ESP',
    Default = false,
    Callback = function(Value)
        print('Box ESP:', Value)
    end
})

VisualsLeft:AddToggle('SkeletonESP', {
    Text = 'Skeleton',
    Default = false,
    Callback = function(Value)
        print('Skeleton:', Value)
    end
})

VisualsLeft:AddLabel('Box Color'):AddColorPicker('BoxColor', {
    Default = Color3.new(1, 0, 0),
    Title = 'Box Color',
    Transparency = 0,
    Callback = function(Value)
        print('Box color:', Value)
    end
})

local VisualsRight = Tabs.Visuals:AddRightGroupbox('World')

VisualsRight:AddToggle('FullBright', {
    Text = 'Full Bright',
    Default = false,
    Callback = function(Value)
        print('Full Bright:', Value)
    end
})

VisualsRight:AddToggle('NoFog', {
    Text = 'No Fog',
    Default = false,
    Callback = function(Value)
        print('No Fog:', Value)
    end
})

VisualsRight:AddSlider('Brightness', {
    Text = 'Brightness',
    Default = 5,
    Min = 0,
    Max = 20,
    Rounding = 1,
    Callback = function(Value)
        print('Brightness:', Value)
    end
})

-- ============================================
-- MISC TAB
-- ============================================

local MiscLeft = Tabs.Misc:AddLeftGroupbox('Movement')

MiscLeft:AddToggle('SpeedHack', {
    Text = 'Speed',
    Default = false,
    Callback = function(Value)
        print('Speed:', Value)
    end
})

MiscLeft:AddSlider('SpeedValue', {
    Text = 'Speed',
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        print('Speed Value:', Value)
    end
})

MiscLeft:AddToggle('Fly', {
    Text = 'Fly',
    Default = false,
    Callback = function(Value)
        print('Fly:', Value)
    end
})

MiscLeft:AddToggle('BHop', {
    Text = 'Bunny Hop',
    Default = false,
    Callback = function(Value)
        print('BHop:', Value)
    end
})

local MiscRight = Tabs.Misc:AddRightGroupbox('Other')

MiscRight:AddButton('Rejoin', {
    Text = 'Rejoin Server',
    Func = function()
        print('Rejoining...')
        Library:Notify('Rejoining server...', 2)
    end,
    DoubleClick = false,
    Tooltip = 'Rejoin the current server'
})

MiscRight:AddButton('ServerHop', {
    Text = 'Server Hop',
    Func = function()
        print('Hopping...')
        Library:Notify('Finding new server...', 2)
    end,
    DoubleClick = true,
    Tooltip = 'Double click to hop servers'
})

MiscRight:AddDivider()

MiscRight:AddInput('CustomMessage', {
    Default = '',
    Numeric = false,
    Finished = true,
    Text = 'Custom Message',
    Tooltip = 'Enter a custom message',
    Placeholder = 'Type here...',
    Callback = function(Value)
        print('Message:', Value)
    end
})

MiscRight:AddDropdown('ThemeSelect', {
    Values = { 'Default', 'Red', 'Green', 'Blue', 'Purple' },
    Default = 1,
    Multi = false,
    Text = 'Theme',
    Tooltip = 'Select menu theme',
    Callback = function(Value)
        print('Theme:', Value)
    end
})

MiscRight:AddDropdown('MultiSelect', {
    Values = { 'Option A', 'Option B', 'Option C', 'Option D' },
    Default = 1,
    Multi = true,
    Text = 'Multi Select',
    Callback = function(Value)
        print('Multi:', Value)
    end
})

MiscRight:AddDropdown('PlayerSelect', {
    SpecialType = 'Player',
    Text = 'Select Player',
    Callback = function(Value)
        print('Selected:', Value)
    end
})

-- ============================================
-- DEPENDENCY BOX EXAMPLE
-- ============================================

local DepBox = Tabs.Misc:AddLeftGroupbox('Dependencies')

DepBox:AddToggle('MasterToggle', {
    Text = 'Master Switch',
    Default = false,
    Callback = function(Value)
        print('Master:', Value)
    end
})

local Dep = DepBox:AddDependencyBox()
Dep:AddToggle('SubToggle', {
    Text = 'Sub Feature',
    Default = false,
    Callback = function(Value)
        print('Sub:', Value)
    end
})

Dep:AddSlider('SubSlider', {
    Text = 'Sub Slider',
    Default = 50,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(Value)
        print('Sub Slider:', Value)
    end
})

Dep:SetupDependencies({
    { Toggles.MasterToggle, true }
})

-- ============================================
-- TABBOX EXAMPLE
-- ============================================

local TabBox = Tabs.Misc:AddRightTabbox()

local Tab1 = TabBox:AddTab('Tab 1')
Tab1:AddToggle('Tab1Toggle', { Text = 'Feature 1', Default = false })
Tab1:AddSlider('Tab1Slider', { Text = 'Slider 1', Default = 50, Min = 0, Max = 100, Rounding = 0 })

local Tab2 = TabBox:AddTab('Tab 2')
Tab2:AddToggle('Tab2Toggle', { Text = 'Feature 2', Default = false })
Tab2:AddButton('Tab2Button', { Text = 'Click Me', Func = function() print('Tab2 button!') end })

-- ============================================
-- UI SETTINGS TAB
-- ============================================

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

-- ============================================
-- ADDONS SETUP
-- ============================================

-- Hand the library over to our managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager
SaveManager:IgnoreThemeSettings()

-- Adds our MenuKeybind to the ignore list
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs['UI Settings'])

-- Builds our theme menu (with plenty of built in themes) on the left side
ThemeManager:ApplyToTab(Tabs['UI Settings'])

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()

-- ============================================
-- WATERMARK & NOTIFICATIONS
-- ============================================

Library:SetWatermarkVisibility(true)

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1
    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end
    Library:SetWatermark(('UNDETEK II | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ))
end)

Library.KeybindFrame.Visible = true

Library:OnUnload(function()
    WatermarkConnection:Disconnect()
    print('Unloaded!')
    Library.Unloaded = true
end)

-- ============================================
-- ACCESSING VALUES PROGRAMMATICALLY
-- ============================================

-- Toggles
-- Toggles.Aimbot.Value              -> true/false
-- Toggles.Aimbot:SetValue(false)    -> turn off

-- Options
-- Options.Smoothness.Value          -> 65
-- Options.Smoothness:SetValue(80)   -> set to 80

-- Keybinds
-- Options.AimbotKey.Value           -> "MB2"
-- Options.AimbotKey:GetState()      -> true/false

-- Dropdowns
-- Options.ThemeSelect.Value         -> "Default"
-- Options.MultiSelect.Value         -> { OptionA = true, OptionB = false }

-- ColorPickers
-- Options.BoxColor.Value            -> Color3
-- Options.BoxColor.Transparency     -> 0

Library:Notify('UNDETEK II loaded successfully!', 3)
print('UNDETEK II Example Script Loaded!')
