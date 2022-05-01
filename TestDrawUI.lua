local module = {}
module.__index = module

local UIElements = {}
local Renderlast_tick = tick()
local RenderDelta = 0

--local function Pointer(...) -- A "pointer" to a vararg. Performant, small, and stupidly useful!
--	local func = coroutine.wrap(function(func, ...) -- Hold the vararg and wrapped function (to return via yield)
--		coroutine.yield(func) -- Yield the wrapped function
--		return ... -- Return the full vararg once resumed again
--	end) -- Create a wrapped function to hold the vararg in memory
--	return func(func, ...) -- Call the function (to start the coroutine and literally hold the vararg in memory)
--end
--local function cwrap(func) -- Wraps a function so it behaves exactly like it did previously but it is now wrapped within a coroutine (and thus appears like a c function to Roblox and user code)
--	return coroutine.wrap(function() -- A wrapper function
--		local results = Pointer() -- Empty pointer for function results
--		while true do
--			results = Pointer(func(coroutine.yield(results()))) -- Repeatedly yield results pointer and call a function with custom args
--		end
--	end)
--end

local Look_Up_Property_Compatibility={
    ["Syn"] = {
        Transparency = "Transparency",
        OutlineColor = "OutlineColor"
        TextBounds   = "TextBounds",
        Thickness    = "Thickness",
        Position     = "Position",
        Outline      = "Outline",
        Visible      = "Visible",
        Zindex       = "Zindex",
        Center       = "Center",
        Remove       = "Remove",
        Filled       = "Filled",
        Color        = "Color",
        From         = "From",
        Size         = "Size",
        Text         = "Text",
        Size         = "Size",
        Font         = "Font",
        To           = "To"
    },
    ["Krnl"] = {
        Transparency = "Transparency",
        OutlineColor = "OutlineColor"
        TextBounds   = "TextBounds",
        Thickness    = "Thickness",
        Position     = "Position",
        Outline      = "Outline",
        Visible      = "Visible",
        Zindex       = "Zindex",
        Center       = "Center",
        Remove       = "Remove",
        Filled       = "Filled",
        Color        = "Color",
        From         = "From",
        Size         = "Size",
        Text         = "Text",
        Size         = "Size",
        Font         = "Font",
        To           = "To"
    }
}

local RenderUpdateThread == coroutine.wrap(function()
    local skippedrender = false
    function UpdateProperty(object)
        pcall(function()
            if object.ClassName == "Line" then
                object.raw_ui.Visible = object.Visible
                object.raw_ui.ZIndex = object.ZIndex
                object.raw_ui.Transparency = object.Transparency
                object.raw_ui.Color = object.Color
            elseif object.ClassName:find("Label") or object.ClassName:find("Button") then
                
            end
        end)
    end
    while true do
        Renderlast_tick = tick()
        for i=1, #UIElements do
            UpdateProperty(UIElements[i])
        end
        RenderDelta = tick() - Renderlast_tick
        if RenderDelta < 1/60 or skippedrender then
            skippedrender = false
            game:GetService("RunService").RenderStepped:Wait()
        else
            skippedrender = true
        end
    end
end)
RenderUpdateThread()
function module.new(classname)
    local self = setmetatable({},module)
    self.ClassName = classname
    if self.ClassName:find("Label") or self.ClassName:find("Button") then
        self.raw_ui2 = Drawing.new("Square")
        self.raw_ui2.Filled = true
        if self.ClassName:find("Text") then
            self.raw_ui = Drawing.new("Text")
            self.Text = "TextLabel"
            self.raw_ui.Text = self.Text
        elseif self.ClassName:find("Image") then
            self.ImageURL = ""
        end
    elseif self.ClassName == "Line" then
        self.raw_ui = Drawing.new("Line")
    end
    if self.ClassName == "Line" then
        self.Visible = true
        self.ZIndex = 0
        self.Transparency = 0
        self.Color = Color3.new(1,1,1)
        self.Thickness = 1
        self.To = Vector2.new(0,0)
        self.From = workspace.CurrentCamera.ViewportSize
    elseif self.ClassName:find("Label") then
        self.Position = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2,workspace.CurrentCamera.ViewportSize.Y/2)
    end
    return self
end

function module:Destroy(self)
    self.Destroy = true
    pcall(function()
        self.raw_ui.Transparency = 0
        self.raw_ui2.Transparency = 0
    end)
    pcall(function()
        self.raw_ui:Remove()
        self.raw_ui2:Remove()
    end)
end
