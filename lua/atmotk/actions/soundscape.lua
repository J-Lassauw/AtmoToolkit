SoundScape = {
    -- Shared Name / UID
    ["name"] = "soundscape",

    -- Network values by client
    ["perams"] = {
        { ["name"] = "soundName", ["export"] = net.WriteString, ["import"] = net.ReadString },
        { ["name"] = "soundNameVar", ["export"] = net.WriteString, ["import"] = net.ReadString },
        { ["name"] = "soundNameVarRangeStart", ["export"] = net.WriteFloat, ["import"] = net.ReadFloat },
        { ["name"] = "soundNameVarRangeEnd", ["export"] = net.WriteFloat, ["import"] = net.ReadFloat }
    },

    -- GUI representation of options
    ["guiOptions"] = {
        ["iconPath"] = "vgui/speaker.png",
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
        ["soundName"] = "footsteps/dirtX.wav",
        ["soundNameVar"] = "X",
        ["soundNameVarRangeStart"] = 1,
        ["soundNameVarRangeEnd"] = 4
    },

    -- User customizations storage (overwrites default)
    ["values"] = {
        ["init"] = true -- Avoid this variable being optimized out
    },

    -- Serverside function of action
    ["function"] = function(args)
        local ply = args["ply"]
        local marker = ents.Create("sent_atk_marker")
        timer.Simple(0.5, function() marker:Remove() end)
        marker:SetPos(ply:GetEyeTrace().HitPos)
        if (string.len(args["soundNameVar"]) >= 1) then
            local soundValue = math.random(args["soundNameVarRangeStart"], args["soundNameVarRangeEnd"])
            local soundPath = string.Replace(args["soundName"], args["soundNameVar"], util.TypeToString(soundValue))
            marker:EmitSound(soundPath)
        else
            marker:EmitSound(args["soundName"])
        end
    end
}
return SoundScape
