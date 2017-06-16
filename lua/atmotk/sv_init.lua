ATK_Active_Players = {}
local ATK_Weapons_Storage = {}
local ATK_Ply_Had_God = {}

util.AddNetworkString("ATK_Status")
util.AddNetworkString("ATK_Action")

include("atmotk/util/ulib/invis.lua")
include("atmotk/util/npcs/npc_spawn.lua")

include("atmotk/sv_action.lua")

function ATK_Add_CS_LUA_Files()
    local clientFiles = file.Find("atmotk/cl_*.lua", "LUA")
    for _, v in pairs(clientFiles) do
        AddCSLuaFile("atmotk/" .. v)
    end
    local clientFiles = file.Find("atmotk/actions/*.lua", "LUA")
    for _, v in pairs(clientFiles) do
        AddCSLuaFile("atmotk/actions/" .. v)
    end
    local clientFiles = file.Find("atmotk/vgui/*.lua", "LUA")
    for _, v in pairs(clientFiles) do
        AddCSLuaFile("atmotk/vgui/" .. v)
    end
end

ATK_Add_CS_LUA_Files()

function ATK_Toggle(ply)
    if (table.HasValue(ATK_Active_Players, ply:SteamID64()) or ATK_SP_And_Active) then
        ATK_Dissable(ply)
    else
        ATK_Ply_Had_God = ply:HasGodMode()
        ATK_Enable(ply)
    end
end

concommand.Add("atmotk_toggle", ATK_Toggle, true, "", 0)


function ATK_Enable(ply)
    ply:SetNetworkedBool("atk_active", true)
    ATK_Active_Players[#ATK_Active_Players + 1] = ply:SteamID64()
    ATK_StoreWeapons(ply)
    ATK_Ghost(ply)
    ATK_SendClientStatus(ply, true)
end

function ATK_Dissable(ply)
    ply:SetNetworkedBool("atk_active", false)
    table.RemoveByValue(ATK_Active_Players, ply:SteamID64())
    ply:UnSpectate()
    ATK_RetrieveWeapons(ply)
    ATK_ULIB_invisible(ply, false)
    if (not ATK_Ply_Had_God) then
        ply:GodDisable()
    end
    ply:SetNoTarget(false)
    ATK_SendClientStatus(ply, false)
end

function ATK_StoreWeapons(ply)
    ATK_Weapons_Storage[ply:SteamID64()] = {}
    for _, v in pairs(ply:GetWeapons()) do
        local wep_index = #ATK_Weapons_Storage[ply:SteamID64()]
        ATK_Weapons_Storage[ply:SteamID64()][wep_index + 1] = v:GetClass()
    end
    ply:StripWeapons()
end

function ATK_RetrieveWeapons(ply)
    for _, v in pairs(ATK_Weapons_Storage[ply:SteamID64()]) do
        ply:Give(v, true);
    end
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
    -- END ULX Spectate Code
    ATK_ULIB_invisible(ply, true)
    ply:Spectate(OBS_MODE_ROAMING)
    ply:GodEnable()
    ply:SetNoTarget(true)
end

function ATK_SendClientStatus(ply, enabled)
    net.Start("ATK_Status")
    net.WriteBool(enabled)
    net.Send(ply)
end