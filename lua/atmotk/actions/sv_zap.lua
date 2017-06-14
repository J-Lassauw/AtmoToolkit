ZapAction = {
    ["name"] = "zap",
    ["perams"] = {
        ["effectName"] = net.ReadString,
        ["soundEnabled"] = net.ReadBool
    },
    ["function"] = function(args)
        if not (CLIENT and (not IsFirstTimePredicted())) then
            local ply = args["ply"]
            local effectdata = EffectData()
            local marker = ents.Create("sent_atk_marker")
            timer.Simple(5, function() marker:Remove() end)
            marker:SetPos(ply:GetEyeTrace().HitPos)
            effectdata:SetStart(marker:GetPos())
            effectdata:SetOrigin(marker:GetPos())
            effectdata:SetMagnitude(500)
            effectdata:SetScale(500)
            effectdata:SetRadius(500)
            effectdata:SetEntity(marker)
            for i = 1, 100, 1 do
                timer.Simple(1 / i, function()
                    util.Effect(args["effectName"], effectdata, true, true)
                end)
            end
            if (args["soundEnabled"]) then
                local Zap = math.random(1, 9)
                if Zap == 4 then Zap = 3 end
                marker:EmitSound("ambient/energy/zap" .. Zap .. ".wav")
            end
        end
    end
}
return ZapAction

