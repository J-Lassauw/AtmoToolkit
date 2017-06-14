ATK_Available_Actions = {}

function ATK_Register_Actions()
    local actionFiles = file.Find("atmotk/actions/*.lua", "LUA")
    for _, v in pairs(actionFiles) do
        table.insert(ATK_Available_Actions, include("atmotk/actions/" .. v))
    end
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
    for _, v in pairs(ATK_Available_Actions) do
        if v["name"] == actionName then action = v end
    end
    if action == nil then return end
    local args = ATK_Get_Default_Args(ply)
    for _, v in SortedPairs(action["perams"]) do
        args[v["name"]] = v["import"]()
    end
    action["function"](args)
end

net.Receive("ATK_Action", ATK_HandleAction)

