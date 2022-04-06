local print = rconsoleinfo or print
local module
local cache = {}

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
