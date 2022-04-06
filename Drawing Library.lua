assert(rconsoleinfo, 'exploit not supported')
assert(Drawing, 'exploit not supported')

if _G.DrawUI then
    return _G.DrawUI
end

local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local ODrawingSynX = {}
local DrawUIold = {
    mouse_down = false,
    drawinglist = {},
    mouse_down_funcs = {}
}

local DrawUI = {
    Screen = {
        ClassName="Screen",
        Name = "Screen",
        __internal_var__={lock = true},
        __Children__ = {},
        GetChildren = function(self)
            return self.__Children__
        end
    }
}

function GetMouseLocation()
	return UserInputService:GetMouseLocation();
end

function IsMouseOverDrawing(Drawing, MousePosition)
	local TopLeft = Drawing.Position;
    local BottomRight
    if Drawing.Text then
        BottomRight = Vector2.new(Drawing.Position.X + #Drawing.Text, Drawing.Position.Y+(DrawUI:Count_Newline(Drawing.Text)*Drawing.Size))
    else
        BottomRight = Drawing.Position + Drawing.Size;
    end
    local MousePosition = MousePosition or GetMouseLocation();

    return MousePosition.X > TopLeft.X and MousePosition.Y > TopLeft.Y and MousePosition.X < BottomRight.X and MousePosition.Y < BottomRight.Y;
end

function MakeDraggable(drawingobject)
    DrawUI.mouse_down_funcs[drawingobject] = (function(drawingobject)
        local drawingobject = drawingobject
        local MouseLocation = GetMouseLocation()
        local delta = drawingobject.Position - MouseLocation
        while DrawUI.mouse_down do
            game:GetService("RunService").RenderStepped:Wait()
            drawingobject.Position = GetMouseLocation() + delta
        end
    end)
end

setmetatable(DrawUI.Screen,{
    __index = function(self,index)
        if index ~= "__internal_var__" and rawget(rawget(self,"__internal_var__"),"lock") then
            local valuefromindex = rawget(self,index)
            if valuefromindex then
                return valuefromindex
            end
        end
    end,
    __newindex  == function(self,index,value)
    end,
    __tostring = function()
        return "Custom_UI_Library_Object_From_Draw_Library(Screen)" 
    end,
    __unm = function()end,
    __add = function() end,
    __sub = function() end,
    __mul = function() end,
    __div = function() end,
    __mod = function() end,
    __pow = function() end,
    __eq = function() end,
    __lt = function() end,
    __le = function() end
})
function DrawUI.new(UIClass, Parent)
    local self = {}

    self.__internal_var__ = {
        lock = true
    }

    local Parent = Parent
    if not Parent["ClassName"] and not tostring(Parent):find("Custom_UI_Library_Object_From_Draw_Library(") then
        Parent = DrawUI.Screen
    end
    self.Parent = Parent
    self.Name = self.ClassName
    self.ClassName = self.ClassName

    self.__Children__ = {}
    self.GetChildren = function()
        local newtable = {}
        for _, child in pairs(self.__Children__) do
            newtable[#newtable+1] = child
        end
        return newtable
    end

    if self.ClassName ~= "Folder" then
        self.Color = Color3.new(1,1,1)
        self.ZIndex = 0
        self.Visible = true
        self.Transparency = 1

        if self.ClassName ~= "Line" then
            self.__internal_event__.MouseEvent = {
                MouseButton1Down = Instance.new("BindableEvent"),
                MouseButton1Up = Instance.new("BindableEvent"),
                MouseButton2Down = Instance.new("BindableEvent"),
                MouseButton2Up = Instance.new("BindableEvent"),
                InputBegan = Instance.new("BindableEvent"),
                InputChanged = Instance.new("BindableEvent"),
                InputEnded = Instance.new("BindableEvent"),
                MouseMoved = Instance.new("BindableEvent"),
                MouseEnter = Instance.new("BindableEvent"),
                MouseLeave = Instance.new("BindableEvent"),
                MouseWheelBackward = Instance.new("BindableEvent"),
                MouseWheelForward = Instance.new("BindableEvent")
            }

            self.MouseButton1Down = self.__internal_event__.MouseEvent.MouseButton1Down.Event
            self.MouseButton1Up = self.__internal_event__.MouseEvent.MouseButton1Up.Event
            self.MouseButton2Down = self.__internal_event__.MouseEvent.MouseButton2Down.Event
            self.MouseButton2Up = self.__internal_event__.MouseEvent.MouseButton2Up.Event
            self.InputBegan = self.__internal_event__.MouseEvent.InputBegan.Event
            self.InputChanged = self.__internal_event__.MouseEvent.InputChanged.Event
            self.InputEnded = self.__internal_event__.MouseEvent.InputEnded.Event
            self.MouseMoved = self.__internal_event__.MouseEvent.MouseMoved.Event
            self.MouseEnter = self.__internal_event__.MouseEvent.MouseEnter.Event
            self.MouseLeave = self.__internal_event__.MouseEvent.MouseLeave.Event
            self.MouseWheelBackward = self.__internal_event__.MouseEvent.MouseWheelBackward.Event
            self.MouseWheelForward = self.__internal_event__.MouseEvent.MouseWheelForward.Event

            self.MouseButton1Click = self.MouseButton1Down
            self.MouseButton2Click = self.MouseButton2Down

            for index, value in pairs(self.__internal_event__.MouseEvent) do
                local invarindex = index:gsub("Mouse","")
                if invarindex == "Moved" then
                    invarindex = "Move"
                end
                local has, ev = pcall(function()
                    return mouse[invarindex]
                end)
                if has then
                    self.__internal_var__[invarindex] = ev:Connect(function(...)
                        local UIObject = rawget(self,"__internal_var__")["DrawingObject"]
                        if self.ClassName == "TextButton" or self.ClassName == "TextLabel" then
                            UIObject = rawget(self,"__internal_var__")["DrawingObject"]
                        else
                            if IsMouseOverDrawing(rawget(self,"__internal_var__")["DrawingObject"]) and rawget(self,"__internal_var__")["DrawingObject"].Visible then
                                self.__internal_event__.MouseEvent[index]:Fire(mouse.x, mouse.y)
                            end
                        end
                        if IsMouseOverDrawing(rawget(self,"__internal_var__")["DrawingObject2"]) and .Visible then
                            self.__internal_event__.MouseEvent[index]:Fire(mouse.x, mouse.y)
                        end
                    end)
                else
                    local has, ev = pcall(function()
                        return UserInputService[invarindex]
                    end)
                    if has then
                        self.__internal_var__[invarindex] = ev:Connect(function(...)
                            local UIObject = rawget(self,"__internal_var__")["DrawingObject"]
                            if self.ClassName == "TextButton" or self.ClassName == "TextLabel" then
                                UIObject = rawget(self,"__internal_var__")["DrawingObject"]
                            else
                                if IsMouseOverDrawing(rawget(self,"__internal_var__")["DrawingObject"]) and rawget(self,"__internal_var__")["DrawingObject"].Visible then
                                    self.__internal_event__.MouseEvent[index]:Fire(...)
                                end
                            end
                            if IsMouseOverDrawing(rawget(self,"__internal_var__")["DrawingObject2"]) and .Visible then
                                self.__internal_event__.MouseEvent[index]:Fire(...)
                            end
                        end)
                    end
                end
            end
        end

        if self.ClassName == "TextButton" or self.ClassName == "TextLabel" then
            self.__internal_var__.DrawingObject = Drawing.new("Text")
            self.__internal_var__.DrawingObject2 = Drawing.new("Square")
        else
            self.__internal_var__.DrawingObject = Drawing.new(self.ClassName)
        end

        self.UnLock = function()
            rawset(rawget(rawget(self,"__internal_var__"),"lock"), not rawget(rawget(self,"__internal_var__"),"lock"))
        end

        self.Remove = function()
            if self.__internal_var__.DrawingObject then
                self.__internal_var__.DrawingObject:Remove()
            end
            if self.__internal_var__.DrawingObject2 then
                self.__internal_var__.DrawingObject2:Remove()
            end
        end

        self = setmetatable(self,{
            __index = function(self,index)
                if index ~= "__internal_var__" and rawget(rawget(self,"__internal_var__"),"lock") then
                    local valuefromindex = rawget(self,index) or rawget(self,"__internal_var__")["DrawingObject"][index]
                    if self.ClassName == "TextButton" or self.ClassName == "TextLabel" then
                        if index == "Text" then
                            valuefromindex = rawget(rawget(self,"__internal_var__"),"DrawingObject")[index]
                        elseif index == "ZIndex" then
                            valuefromindex = rawget(rawget(self,"__internal_var__"),"DrawingObject")[index]
                        elseif index == "BackgroundColor" then
                            valuefromindex = rawget(rawget(self,"__internal_var__"),"DrawingObject2")["Color"]
                        elseif index == "BackgroundTransparency" then
                            valuefromindex = rawget(rawget(self,"__internal_var__"),"DrawingObject2")["Transparency"]
                        end
                    end
                    if valuefromindex then
                        return valuefromindex
                    end
                end
            end,
            __newindex  == function(self,index,value)
                if index ~= "ClassName" and index ~= "TextBounds" and (index == "__internal_var__" and rawget(rawget(self,"__internal_var__"),"lock")) then
                    if self.ClassName == "TextButton" or self.ClassName == "TextLabel" then
                        if index == "Text" then
                            rawget(rawget(self,"__internal_var__"),"DrawingObject")[index] = value
                        elseif index == "ZIndex" then
                            rawget(rawget(self,"__internal_var__"),"DrawingObject")[index] = value
                            rawget(rawget(self,"__internal_var__"),"DrawingObject2")[index] = rawget(rawget(self,"__internal_var__"),"DrawingObject")[index] - 1 
                        elseif index == "BackgroundColor" then
                            rawget(rawget(self,"__internal_var__"),"DrawingObject2")["Color"] = value
                        elseif index == "BackgroundTransparency" then
                            rawget(rawget(self,"__internal_var__"),"DrawingObject2")["Transparency"] = value
                        end
                    else
                        if index == "Parent" then
                            rawset(self.Parent,self.Name,self)
                        end
                        rawset(self,index,value)
                    end
                end
            end,
            __tostring = function()
                return "Custom_UI_Library_Object_From_Draw_Library("..self.Name..")" 
            end,
            __unm = function()end,
            __add = function() end,
            __sub = function() end,
            __mul = function() end,
            __div = function() end,
            __mod = function() end,
            __pow = function() end,
            __eq = function() end,
            __lt = function() end,
            __le = function() end
        })
    end
    return self
end

_G.DrawUI = DrawUI
return DrawUI