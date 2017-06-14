ATK_Active_Players = {}

ATK_Active = false

util.AddNetworkString("ATK_Status")
util.AddNetworkString("ATK_Action")

include("atmotk/sv_action.lua")

function ATK_Add_CS_LUA_Files()
    local clientFiles = file.Find("atmotk/cl_*.lua", "LUA")
    table.ForEach(clientFiles, function(_, v)
        AddCSLuaFile("atmotk/" .. v)
    end)
    local clientFiles = file.Find("atmotk/actions/cl_*.lua", "LUA")
    table.ForEach(clientFiles, function(_, v)
        AddCSLuaFile("atmotk/actions/" .. v)
    end)
    local clientFiles = file.Find("atmotk/hud/*.lua", "LUA")
    table.ForEach(clientFiles, function(_, v)
        AddCSLuaFile("atmotk/hud/" .. v)
    end)
end

ATK_Add_CS_LUA_Files()

function ATK_Toggle(ply)
    if (table.HasValue(ATK_Active_Players, ply:SteamID64())) then
        ATK_Dissable(ply)
    else
        ATK_Enable(ply)
        ATK_Active = true
    end
end

concommand.Add("atmotk_toggle", ATK_Toggle, true, "", 0)


function ATK_Enable(ply)
    ply:SetNetworkedBool("atk_active", true)
    ATK_Active_Players[#ATK_Active_Players + 1] = ply:SteamID64()
    ATK_Ghost(ply)
    ATK_Activate_Client(ply)
end

function ATK_Dissable(_)
end

function ATK_Ghost(ply)
    -- ULX Spectate Code
    if not ply:IsValid() then
        Msg("You can't spectate from dedicated server console.\n")
        return
    end
    -- Check if player is already spectating. If so, stop spectating so we can start again
    local hookTable = hook.GetTable()["KeyPress"]
    if hookTable and hookTable["ulx_unspectate_" .. ply:EntIndex()] then
        -- Simulate keypress to properly exit spectate.
        hook.Call("KeyPress", _, ply, IN_FORWARD)
    end
    -- ULX Spectate Code
    ply:StripWeapons()
    ULib.invisible(ply, true)
    ply:Spectate(OBS_MODE_ROAMING)
end

function ATK_Activate_Client(ply)
    net.Start("ATK_Status")
    net.WriteBool(true)
    net.Send(ply)
end