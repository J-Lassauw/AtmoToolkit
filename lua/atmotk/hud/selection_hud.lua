local hudTextures = {
    [1] = Material("vgui/bolt-spell-cast.png", "noclamp smooth"),
    [2] = Material("vgui/speaker.png", "noclamp smooth"),
    [3] = Material("vgui/shambling-zombie.png", "noclamp smooth"),
    [4] = Material("vgui/blindfold.png", "noclamp smooth")
}

function ATK_DrawHud()
    if (ATK_Active) then
        -- Draw Icons
        for i = 0, 3 do
            if (i + 1 == ATK_Selection) then
                draw.RoundedBox(0, (i * 130) + 30, 30, 128, 128, Color(170, 0, 0, 128))
            else
                draw.RoundedBox(0, (i * 130) + 30, 30, 128, 128, Color(0, 0, 0, 128))
            end
            surface.SetDrawColor(255, 255, 255, 255)
            surface.SetMaterial(hudTextures[i + 1])
            surface.DrawTexturedRect((i * 130) + 30, 30, 128, 128)
        end
    end
end

hook.Add("HUDPaint", "atmotk_hud", ATK_DrawHud)