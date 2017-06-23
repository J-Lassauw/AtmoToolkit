-- Functions in this file taken from the ULib project, big thanks to:
--
-- Brett "Megiddo" Smith - Contact: megiddo@ulyssesmod.net
-- JamminR - Contact: jamminr@ulyssesmod.net
-- Stickly Man! - Contact: sticklyman@ulyssesmod.net
-- MrPresident - Contact: mrpresident@ulyssesmod.net
--
-- Original source: https://github.com/TeamUlysses/ulib/blob/master/lua/ulib/server/player.lua#L320
--
--
-- Only adaptation made by this project is the relocation of the invisible function to avoid conflicts with ULib.

local function doInvis()
    local players = player.GetAll()
    local remove = true
    for _, player in ipairs(players) do
        local t = player:GetTable()
        if t.invis then
            remove = false
            if player:Alive() and player:GetActiveWeapon():IsValid() then
                if player:GetActiveWeapon() ~= t.invis.wep then

                    if t.invis.wep and IsValid(t.invis.wep) then -- If changed weapon, set the old weapon to be visible.
                        t.invis.wep:SetRenderMode(RENDERMODE_NORMAL)
                        t.invis.wep:Fire("alpha", 255, 0)
                        t.invis.wep:SetMaterial("")
                    end

                    t.invis.wep = player:GetActiveWeapon()
                    ATK_ULIB_invisible(player, true, t.invis.vis)
                end
            end
        end
    end

    if remove then
        hook.Remove("Think", "InvisThink")
    end
end

--[[
	Function: invisible
	Makes a user invisible
	Parameters:
		ply - The player to affect.
		bool - Whether they're invisible or not
		visibility - *(Optional, defaults to 0)* A number from 0 to 255 for their visibility.
	Revisions:
		v2.40 - Removes shadow when invisible
]]
function ATK_ULIB_invisible(ply, bool, visibility)
    if not ply:IsValid() then return end -- This is called on a timer so we need to verify they're still connected

    if bool then
        visibility = visibility or 0
        ply:DrawShadow(false)
        ply:SetMaterial("models/effects/vol_light001")
        ply:SetRenderMode(RENDERMODE_TRANSALPHA)
        ply:Fire("alpha", visibility, 0)
        ply:GetTable().invis = { vis = visibility, wep = ply:GetActiveWeapon() }

        if IsValid(ply:GetActiveWeapon()) then
            ply:GetActiveWeapon():SetRenderMode(RENDERMODE_TRANSALPHA)
            ply:GetActiveWeapon():Fire("alpha", visibility, 0)
            ply:GetActiveWeapon():SetMaterial("models/effects/vol_light001")
            if ply:GetActiveWeapon():GetClass() == "gmod_tool" then
                ply:DrawWorldModel(false) -- tool gun has problems
            else
                ply:DrawWorldModel(true)
            end
        end

        hook.Add("Think", "InvisThink", doInvis)
    else
        ply:DrawShadow(true)
        ply:SetMaterial("")
        ply:SetRenderMode(RENDERMODE_NORMAL)
        ply:Fire("alpha", 255, 0)
        local activeWeapon = ply:GetActiveWeapon()
        if IsValid(activeWeapon) then
            activeWeapon:SetRenderMode(RENDERMODE_NORMAL)
            activeWeapon:Fire("alpha", 255, 0)
            activeWeapon:SetMaterial("")
        end
        ply:GetTable().invis = nil
    end
end