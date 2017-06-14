hudTextures = {}
local function GetHudTextures()
    local insertIndex = 1
    for _, v in SortedPairs(ATK_Available_Actions) do
        table.insert(hudTextures, insertIndex, (Material(v["guiOptions"]["iconPath"], "noclamp smooh")))
        insertIndex = insertIndex + 1
    end
end

GetHudTextures()

local function ATK_DrawHud()
    if (ATK_Active) then
        -- Draw Icons
        for i = 1, #hudTextures do
            local xValue = ((i - 1) * 130) + 30
            if (i == ATK_GetSelectionIndex()) then
                draw.RoundedBox(0, xValue, 30, 128, 128, Color(170, 0, 0, 128))
            else
                draw.RoundedBox(0, xValue, 30, 128, 128, Color(0, 0, 0, 128))
            end
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(hudTextures[i])
            surface.DrawTexturedRect(xValue, 30, 128, 128)
        end
    end
end
hook.Add("HUDPaint", "atmotk_hud", ATK_DrawHud)