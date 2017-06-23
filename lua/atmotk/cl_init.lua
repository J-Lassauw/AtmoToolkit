ATK_Active = false

IncludeCS("atmotk/cl_action.lua")
IncludeCS("atmotk/vgui/selection_hud.lua")
IncludeCS("atmotk/vgui/action_config.lua")

function ATK_SetStatus()
    ATK_Active = net.ReadBool()
end
net.Receive("ATK_Status", ATK_SetStatus)

