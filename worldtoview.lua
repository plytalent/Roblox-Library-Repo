assert(rconsoleinfo, "Exploit Not Support")
assert(writefile,    "Exploit Not Support")
assert(readfile,     "Exploit Not Support")
local s,e = pcall(function()
    error("")
end)

rconsoleinfo("worldtoview "..string.sub(e,1,string.len(e)-4))
local RequireLibraryCode = ""
local success, ErrorStatement = pcall(function()
    return game:HttpGet("https://github.com/plytalent/Roblox-Library-Repo/raw/main/Library%20Loader.lua")
end)
if not success or test_fallback then
    rconsoleinfo(string.format("[Script][ERROR]\t %s",tostring(ErrorStatement)))
else
    RequireLibraryCode = ErrorStatement
end
local RequireLibraryRaw = loadstring(RequireLibraryCode)()
local RequireLibrary = RequireLibraryRaw.Load
local The_Slient_Library = RequireLibrary("The Slient Library")
local module = {}
local worldpoint_to_viewpoint = {}
local currentcamera = workspace.CurrentCamera
local scheduler_wpoint_to_vpoint = The_Slient_Library.scheduler.new()
--[[
The_Slient_Library.scheduler

The_Slient_Library.buffer

The_Slient_Library.Custom_Functions
--custom lua functions
The_Slient_Library.settings

--]]
function findplayercharacterinworkspace(plr)
    for _, instance in pairs(workspace:Getdescendants()) do
        if instance:IsA("Model") then
            local founded_player = game:GetService("Players"):GetPlayerFromCharacter(Instance)
            if founded_player == plr then
                return instance
            end
        end
    end
end

function worldpoint_to_viewpoint_list()
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        local char = player.Character
        local charpartposition = {}
        local charpartsize = {}
        local Bounding = {}
        local viewpoint = {}
        local FacingDirection = Vector3.new()
        if char then
            if not char:IsA("Model") or #char:GetChildren() == 0 then
                char = findplayercharacterinworkspace(player)
            end
    
            if char then
                FacingDirection           = (char.Head.CFrame * CFrame.new(0,0,char.Head.Size.Z/2)).p
                charpartposition.Head     = char.Head.Position
                viewpoint.Head            = {currentcamera:WorldToViewportPoint(charpartposition.Head)}
                viewpoint.FacingDirection = {currentcamera:WorldToViewportPoint(FacingDirection)}
                worldpoint_to_viewpoint[player.Name] = viewpoint
                --[[
                charpartposition.Torso    = char.Torso.Position
                charpartposition.LeftArm  = char["Left Arm"].Position
                charpartposition.LeftLeg  = char["Left Leg"].Position
                charpartposition.RightArm = char["Right Arm"].Position
                charpartposition.RightLeg = char["Right Leg"].Position
    
                charpartsize.Torso        = char.Torso.Size
                charpartsize.Head         = char.Head.Size
                charpartsize.LeftArm      = char["Left Arm"].Size
                charpartsize.LeftLeg      = char["Left Leg"].Size
                charpartsize.RightArm     = char["Right Arm"].Size
                charpartsize.RightLeg     = char["Right Leg"].Size

                viewpoint.Torso           = currentcamera:WorldToViewportPoint(charpartposition.Torso)
                viewpoint.LeftArm         = currentcamera:WorldToViewportPoint(charpartposition.LeftArm)
                viewpoint.LeftLeg         = currentcamera:WorldToViewportPoint(charpartposition.LeftLeg)
                viewpoint.RightArm        = currentcamera:WorldToViewportPoint(charpartposition.RightArm)
                viewpoint.RightLeg        = currentcamera:WorldToViewportPoint(charpartposition.RightLeg)
                --]]
            else
                worldpoint_to_viewpoint[player.Name] = nil
            end
        end
    end
end

scheduler_wpoint_to_vpoint:Add_Func(worldpoint_to_viewpoint_list)

function module.GetPlayerViewpointList(player)
    if worldpoint_to_viewpoint[player.Name] then
        return worldpoint_to_viewpoint[player.Name]
    end
end

function module.Switch_scheduler_EV(ev)
    scheduler_wpoint_to_vpoint:Switch_Event(ev)
end
function module.shutdown()
    scheduler_wpoint_to_vpoint:Remove_Func(worldpoint_to_viewpoint_list)
end

module.worldpoint_to_viewpoint = worldpoint_to_viewpoint
return module
