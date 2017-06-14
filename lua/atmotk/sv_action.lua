ATK_Available_Actions = {}

function ATK_Register_Actions()
    local actionFiles = file.Find("atmotk/actions/sv_*.lua", "LUA")
    table.ForEach(actionFiles, function(_, v)
        table.insert(ATK_Available_Actions, include("atmotk/actions/" .. v))
    end)
end

ATK_Register_Actions()

local function ATK_Get_Default_Args(ply)
    return {
        ["ply"] = ply
    }
end

function ATK_HandleAction(_, ply)
    if (not ply:SteamID64() == nil and not table.HasValue(ATK_Active_Players, ply:SteamID64())) then return end
    local actionName = net.ReadString()
    local action
    table.ForEach(ATK_Available_Actions, function(_, v)
        if v["name"] == actionName then action = v end
    end)
    if action == nil then return end
    local args = ATK_Get_Default_Args(ply)
    table.ForEach(action["perams"], function(k, v)
        args[k] = v()
    end)
    action["function"](args)
end

net.Receive("ATK_Action", ATK_HandleAction)

