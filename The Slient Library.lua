local libsetting = {
    loglevel=1
}
local scheduler = {}
local buffer = {}
local real_func = {
    print = print,
    tostring = tostring
}

local namepool = {}

local random = Random.new()
local letters = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}

function getRandomLetter()
	return letters[random:NextInteger(1,#letters)]
end

function getRandomString(length, includeCapitals)
	local length = length or 10
	local str = ''
	for i=1,length do
		local randomLetter = getRandomLetter()
		if includeCapitals and random:NextNumber() > .5 then
			randomLetter = string.upper(randomLetter)
		end
		str = str .. randomLetter
	end
    if namepool[str] then
        str = getRandomString()
    end
    namepool[str] = str
	return str
end

function buffer.new()
    local self = setmetatable({},buffer)
    self.Buffer = {}
    return self
end

function buffer:Read()
    local newstr = ""
    for i=1,#self.buffer do
        newstr = newstr.. tostring(self.buffer[i])
    end
    return newstr
end

function buffer:Write(data)
    self.buffer[#self.buffer+1] = data
end

function scheduler.new()
    local self = setmetatable({},scheduler)
    self.loop = game:GetService("RunService").Stepped
    self.__internal_event__ = {}
    self.__internal_var__ = {}
    self.__internal_func__ = {}
    self.funcs = {}
    self.__internal_var__.Changing_event = false
    self.__internal_var__.Executed_Function = true
    self.__internal_var__.execution_index = 1
    self.__internal_var__.RandomString = getRandomString()
    self.__internal_func__.bindtoloop = function()
        self.__internal_event__.MainEventLoop = self.loop:Connect(function(delta)
            local start_index = 1
            if self.__internal_var__.execution_index > 1 then
                start_index = self.__internal_var__.execution_index
            end
            local delta = tick()
            for i=start_index , #self.funcs do
                if self.funcs[i] then
                    self.__internal_var__.Executed_Function = false
                    self.funcs[i]()
                    self.__internal_var__.Executed_Function = true
                    debug("[Scheduler Event]", "[", self.__internal_var__.RandomString, "]", "Function Took", (tick()-delta)*1000, "ms to Execute")
                    delta = tick()
                    self.__internal_var__.execution_index = i
                    if self.__internal_var__.Changing_event then
                        break
                    end  
                end
            end
        end)
        debug("[Scheduler]", "[", self.__internal_var__.RandomString, "]", "Binded To New Loop")
    end
    self.__internal_func__.bindtoloop()
    debug("[Scheduler]", "[", self.__internal_var__.RandomString, "]", "Initialized")
    return self
end
function scheduler:Add_Func(self,func,args)
    debug("[Scheduler]", "[", self.__internal_var__.RandomString, "]", "Add Function To scheduler")
    self.funcs[#self.funcs+1] = func
end
function scheduler:Remove_Func(self,func)
    for index=1, #self.funcs do
        if self.funcs[index] == func then
            debug("[Scheduler]", "[", self.__internal_var__.RandomString, "]", "Remove Function From scheduler")
            self.funcs[index] = nil
        end
    end
end
function scheduler:Switch_Event(ev)
    if not ev then
        debug("[Scheduler]", "[", self.__internal_var__.RandomString, "]", "Switching Event Scheduler")
        self.__internal_event__.MainEventLoop:Disconnect()
        self.__internal_var__.Changing_event = true
        while self.__internal_var__.Executed_Function do
            self.loop:Wait()
        end
        self.__internal_var__.Changing_event = false
        self.loop = ev
        self.__internal_func__.bindtoloop()
    end
end

local tostring = function(input)
    local typeofinput = typeof(input):lower()
    if typeofinput == "instance" or typeofinput == "userdata" then
        local can_get_name, name = pcall(function()
            return input.Name
        end)
        if can_get_name then
            return tostring(name)
        end
    elseif typeofinput == "table" then
        local newbuffer = buffer.new()
        newbuffer:Write("{")
        newbuffer:Write("\n")
        for index,value in pairs(input) do
            newbuffer:Write(index)
            newbuffer:Write(" = ")
            newbuffer:Write(tostring(value))
            newbuffer:Write(",")
            newbuffer:Write("\n")
        end
        newbuffer:Write("}")
        return newbuffer:Read()
    end
    return real_func["tostring"](input)
end
local print = function(...)
    if libsetting.loglevel > 0 then
        local args = {...}
        local buffer = buffer.new()
        for i=1, #args do
            buffer:Write(args[i])
            buffer:Write("\t")
        end
        rconsoleinfo(buffer:Read())
    end
end
local debug = function(...)
    if libsetting.loglevel > 4 then
        local args = {"[Debug]",...}
        print(args)
    end
end
function Count_Newline(str)
    local lines = 1
    for i = 1, #str do
        local c = str:sub(i, i)
        if c == '\n' then
            lines = lines + 1
        end
    end
    return lines
end
return {
    scheduler   =   scheduler,
    buffer      =   buffer,
    Custom_Functions = {
        tostring = tostring,
        print = print,
        debug = debug,
        count_Newline = Count_Newline
    },
    settings = libsetting
}