ZapAction = {
    -- Shared Name / UID
    ["name"] = "zap",

    -- Network values by client
    ["perams"] = {
        { ["name"] = "effectName", ["export"] = net.WriteString, ["import"] = net.ReadString },
        { ["name"] = "soundEnabled", ["export"] = net.WriteBool, ["import"] = net.ReadBool }
    },

    -- GUI representation of options
    ["gui_options"] = {
        ["effectName"] = {
            ["print"] = "Effect",
            ["type"] = "combo",
            ["choices"] = {}
        },
        ["soundEnabled"] = {
            ["print"] = "Play Sound",
            ["type"] = "check"
        }
    },

    -- Default Options
    ["default"] = {
        ["effectName"] = "TeslaHitBoxes",
        ["soundEnabled"] = true
    },

    -- User customizations storage (overwrites default)
    ["values"] = {
        ["init"] = true -- Avoid this variable being optimized out
    },

    -- Serverside function of action
    ["function"] = function(args)
        local ply = args["ply"]
        local effectdata = EffectData()
        local marker = ents.Create("sent_atk_marker")
        timer.Simple(0.5, function() marker:Remove() end)
        marker:SetPos(ply:GetEyeTrace().HitPos)
        effectdata:SetStart(marker:GetPos())
        effectdata:SetOrigin(marker:GetPos())
        effectdata:SetMagnitude(5)
        effectdata:SetScale(20)
        effectdata:SetRadius(100)
        effectdata:SetEntity(marker)
        -- Thanks FAdmin
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
}
return ZapAction
