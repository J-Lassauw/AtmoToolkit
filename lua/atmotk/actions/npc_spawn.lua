NPCSpawn = {
    -- Shared Name / UID
    ["name"] = "npcspawn",

    -- Network values by client
    ["perams"] = {
        { ["name"] = "npcName", ["export"] = net.WriteString, ["import"] = net.ReadString }
    },

    -- GUI representation of options
    ["guiOptions"] = {
        ["iconPath"] = "vgui/shambling-zombie.png",
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
        ["npcName"] = "npc_zombie"
    },

    -- User customizations storage (overwrites default)
    ["values"] = {
        ["init"] = true -- Avoid this variable being optimized out
    },

    -- Serverside function of action
    ["function"] = function(args)
        local ply = args["ply"]
        local tr = ply:GetEyeTrace()
        ATK_Do_Npc_Spawn(ply, tr.HitPos, tr.HitNormal, args["npcName"])
    end
}
return NPCSpawn
