local module
local cache = {}

local tostring
local print

local buffer = {}

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

tostring = function(input)
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
print = function(...)
    local args = {...}
    local printbuffer = buffer.new()
    for i=1, #args do
        printbuffer:Write(args[i])
        printbuffer:Write("\t")
    end
    rconsoleinfo(printbuffer:Read())
end

function findvalue_in_table(value,tb)
    for _,v in pairs(tb) do
        if value == v then
            return true
        end
    end
    return false
end

function gethttp(url)
    local sus, errorstatement = pcall(function()
        return game:HttpGet(url)
    end)
    if sus then
        return errorstatement
    else
        print("[Library Loader][Get Http]FAILED".. errorstatement)
        return "ERROR"
    end
end

module = {
    LocalLoad = function(path_to_file)
        local path_to_file = path_to_file or ""
        local LibraryContent = readfile(path_to_file) or ""
        local n_er, Library = pcall(function()
            return loadstring(LibraryContent)()
        end)
        if n_er then
            return Library
        end
    end,
    ExternalLoad = function(url)
        local url = url or ""
        local LibraryContent = gethttp(url)
        if LibraryContent == "ERROR" then
            print("[Library Loader][URL Loader]FAILED TO LOAD EXTERNAL LIB"..LibraryContent)
            return
        end
        local n_er, Library = pcall(function()
            return loadstring(LibraryContent)()
        end)
        if n_er then
            return Library
        end
	print(Library)
    end,
    Load = function(modulename)
	print("[Library Loader]Loading "..modulename)
        if not isfolder("module") then
            makefolder("module")
        end
        local modules = listfiles("module")
        if findvalue_in_table(modulename,modules) then
            return module.LocalLoad("module/"..modulename..".lua")
        else
            print("[Library Loader]Loading From https://raw.githubusercontent.com/plytalent/Roblox-Library-Repo/main/"..modulename:gsub("%s+","%%20")..".lua")
	    local  url = "https://raw.githubusercontent.com/plytalent/Roblox-Library-Repo/main/"..modulename:gsub("%s+","%%20")..".lua"
            local ScriptFromRepo = gethttp(url)
            if ScriptFromRepo ~= "404: Not Found" then
		local libraryloaded = cache[url]
	        if not libraryloaded or libraryloaded ~= "" then
		    cache[url] = module.ExternalLoad(url)
		    print(module.ExternalLoad(url) or "No Module Load!")
		    libraryloaded = cache[url]
		end
		if libraryloaded ~= nil then
                    return libraryloaded
		else
		    print("No Library Loaded")
		end
            else
                rconsoleinfo("NOT FOUND MODULE")
            end
        end
    end
}
return module
