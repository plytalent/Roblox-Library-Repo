assert(rconsoleinfo, 'exploit not supported')
assert(Drawing, 'exploit not supported')
local s,e = pcall(function()
    error("")
end)

rconsoleinfo("Drawing Library "..string.sub(e,1,string.len(e)-4))
local RequireLibraryCode = ""
local success, ErrorStatement = pcall(function()
    return game:HttpGet("https://github.com/plytalent/Roblox-Library-Repo/raw/main/Library%20Loader.lua")
end)
if not success or test_fallback then
    rconsoleinfo(string.format("[Script][ERROR]\t %s",tostring(ErrorStatement)))
else
    RequireLibraryCode = ErrorStatement
end
local RequireLibrary = loadstring(RequireLibraryCode)().Load
local The_Slient_Library = RequireLibrary("The Slient Library")
local err, return_result = pcall(function()
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
            _internal_var_={lock = true},
            _Children_ = {},
            GetChildren = function(self)
                return self._Children_
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
        _index = function(self,index)
            if index ~= "_internal_var_" and rawget(rawget(self,"_internal_var_"),"lock") then
                local valuefromindex = rawget(self,index)
                if valuefromindex then
                    return valuefromindex
                end
            end
        end,
        _newindex  == function(self,index,value)
        end,
        _tostring = function()
            return "Custom_UI_Library_Object_From_Draw_Library(Screen)" 
        end,
        _unm = function()end,
        _add = function() end,
        _sub = function() end,
        _mul = function() end,
        _div = function() end,
        _mod = function() end,
        _pow = function() end,
        _eq = function() end,
        _lt = function() end,
        _le = function() end
    })
    function DrawUI.new(UIClass, Parent)
        local self = {}

        self._internal_var_ = {
            lock = true
        }
        self._internal_event_ = {}
        local Parent = Parent or DrawUI.Screen
        if not tostring(Parent):find("Custom_UI_Library_Object_From_Draw_Library(") then
            Parent = DrawUI.Screen
        end
        self.Parent = Parent
        self.Name = self.ClassName
        self.ClassName = UIClass

        self._Children_ = {}
        self.GetChildren = function()
            local newtable = {}
            for _, child in pairs(self._Children_) do
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
                The_Slient_Library.Custom_Functions.print("Not Line")
                self._internal_event_.MouseEvent = {
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

                self.MouseButton1Down = self._internal_event_.MouseEvent.MouseButton1Down.Event
                self.MouseButton1Up = self._internal_event_.MouseEvent.MouseButton1Up.Event
                self.MouseButton2Down = self._internal_event_.MouseEvent.MouseButton2Down.Event
                self.MouseButton2Up = self._internal_event_.MouseEvent.MouseButton2Up.Event
                self.InputBegan = self._internal_event_.MouseEvent.InputBegan.Event
                self.InputChanged = self._internal_event_.MouseEvent.InputChanged.Event
                self.InputEnded = self._internal_event_.MouseEvent.InputEnded.Event
                self.MouseMoved = self._internal_event_.MouseEvent.MouseMoved.Event
                self.MouseEnter = self._internal_event_.MouseEvent.MouseEnter.Event
                self.MouseLeave = self._internal_event_.MouseEvent.MouseLeave.Event
                self.MouseWheelBackward = self._internal_event_.MouseEvent.MouseWheelBackward.Event
                self.MouseWheelForward = self._internal_event_.MouseEvent.MouseWheelForward.Event

                self.MouseButton1Click = self.MouseButton1Down
                self.MouseButton2Click = self.MouseButton2Down

                for index, value in pairs(self._internal_event_.MouseEvent) do
                    local invarindex = index:gsub("Mouse","")
                    if invarindex == "Moved" then
                        invarindex = "Move"
                    end
                    local has, ev = pcall(function()
                        return mouse[invarindex]
                    end)
                    if has then
                        self._internal_var_[invarindex] = ev:Connect(function(...)
                            local UIObject = rawget(self,"_internal_var_")["DrawingObject"]
                            if self.ClassName == "TextButton" or self.ClassName == "TextLabel" then
                                UIObject = rawget(self,"_internal_var_")["DrawingObject"]
                            else
                                if IsMouseOverDrawing(rawget(self,"_internal_var_")["DrawingObject"]) and rawget(self,"_internal_var_")["DrawingObject"].Visible then
                                    self._internal_event_.MouseEvent[index]:Fire(mouse.x, mouse.y)
                                end
                            end
                            if IsMouseOverDrawing(rawget(self,"_internal_var_")["DrawingObject2"]) and rawget(self,"_internal_var_")["DrawingObject2"].Visible then
                                self._internal_event_.MouseEvent[index]:Fire(mouse.x, mouse.y)
                            end
                        end)
                    else
                        local has, ev = pcall(function()
                            return UserInputService[invarindex]
                        end)
                        if has then
                            self._internal_var_[invarindex] = ev:Connect(function(...)
                                local UIObject = rawget(self,"_internal_var_")["DrawingObject"]
                                if self.ClassName == "TextButton" or self.ClassName == "TextLabel" then
                                    UIObject = rawget(self,"_internal_var_")["DrawingObject"]
                                else
                                    if IsMouseOverDrawing(rawget(self,"_internal_var_")["DrawingObject"]) and rawget(self,"_internal_var_")["DrawingObject"].Visible then
                                        self._internal_event_.MouseEvent[index]:Fire(...)
                                    end
                                end
                                if IsMouseOverDrawing(rawget(self,"_internal_var_")["DrawingObject2"]) and rawget(self,"_internal_var_")["DrawingObject2"].Visible then
                                    self._internal_event_.MouseEvent[index]:Fire(...)
                                end
                            end)
                        end
                    end
                end
            end

            if self.ClassName == "TextButton" or self.ClassName == "TextLabel" then
                self._internal_var_.DrawingObject = Drawing.new("Text")
                self._internal_var_.DrawingObject2 = Drawing.new("Square")
            else
                self._internal_var_.DrawingObject = Drawing.new(self.ClassName)
            end

            self.UnLock = function()
                rawset(rawget(rawget(self,"_internal_var_"),"lock"), not rawget(rawget(self,"_internal_var_"),"lock"))
            end

            self.Remove = function()
                if self._internal_var_.DrawingObject then
                    self._internal_var_.DrawingObject:Remove()
                end
                if self._internal_var_.DrawingObject2 then
                    self._internal_var_.DrawingObject2:Remove()
                end
            end

            self = setmetatable(self,{
                _index = function(self,index)
                    if index ~= "_internal_var_" and rawget(rawget(self,"_internal_var_"),"lock") then
                        local valuefromindex = rawget(self,index) or rawget(self,"_internal_var_")["DrawingObject"][index]
                        if self.ClassName == "TextButton" or self.ClassName == "TextLabel" then
                            if index == "Text" then
                                valuefromindex = rawget(rawget(self,"_internal_var_"),"DrawingObject")[index]
                            elseif index == "ZIndex" then
                                valuefromindex = rawget(rawget(self,"_internal_var_"),"DrawingObject")[index]
                            elseif index == "BackgroundColor" then
                                valuefromindex = rawget(rawget(self,"_internal_var_"),"DrawingObject2")["Color"]
                            elseif index == "BackgroundTransparency" then
                                valuefromindex = rawget(rawget(self,"_internal_var_"),"DrawingObject2")["Transparency"]
                            end
                        end
                        if valuefromindex then
                            return valuefromindex
                        end
                    end
                end,
                _newindex  == function(self,index,value)
                    if index ~= "ClassName" and index ~= "TextBounds" and (index == "_internal_var_" and rawget(rawget(self,"_internal_var_"),"lock")) then
                        if self.ClassName == "TextButton" or self.ClassName == "TextLabel" then
                            if index == "Text" then
                                rawget(self,"_internal_var_").DrawingObject[index] = value
                                return
                            elseif index == "ZIndex" then
                                rawget(self,"_internal_var_").DrawingObject[index] = value
                                rawget(self,"_internal_var_").DrawingObject2[index] = rawget(self,"_internal_var_").DrawingObject[index] - 1 
                                return
                            elseif index == "BackgroundColor" then
                                rawget(self,"_internal_var_").DrawingObject2.Color = value
                                return
                            elseif index == "BackgroundTransparency" then
                                rawget(self,"_internal_var_").DrawingObject2.Transparency = value
                                return
                            end
                        else
                            if index == "Parent" then
                                rawset(self.Parent,self.Name,self)
                            end
                            rawset(self,index,value)
                            rawget(self,"_internal_var_").DrawingObject[index] = value
                        end
                    end
                end,
                _tostring = function()
                    return "Custom_UI_Library_Object_From_Draw_Library("..self.Name..")" 
                end,
                _unm = function()end,
                _add = function() end,
                _sub = function() end,
                _mul = function() end,
                _div = function() end,
                _mod = function() end,
                _pow = function() end,
                _eq = function() end,
                _lt = function() end,
                _le = function() end
            })
        end
        return self
    end
    return DrawUI
end)
if err then
    return return_result
end
The_Slient_Library.Custom_Functions.print(return_result)
