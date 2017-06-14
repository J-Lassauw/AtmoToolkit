ATK_Active = false

IncludeCS("atmotk/cl_action.lua")
IncludeCS("atmotk/hud/selection_hud.lua")

function ATK_SetStatus()
    ATK_Active = net.ReadBool()
end

net.Receive("ATK_Status", ATK_SetStatus)

