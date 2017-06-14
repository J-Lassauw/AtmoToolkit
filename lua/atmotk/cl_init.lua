ATK_Active = false
ATK_Selection = 1

IncludeCS("atmotk/hud/selection_hud.lua")
IncludeCS("atmotk/cl_action.lua")

function ATK_SetStatus()
    ATK_Active = net.ReadBool()
end

net.Receive("ATK_Status", ATK_SetStatus)

