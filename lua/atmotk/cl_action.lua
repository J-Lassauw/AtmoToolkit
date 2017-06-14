SelectedAction = {}
ATK_Available_Actions = {}

function ATK_Register_Actions()
    local actionFiles = file.Find("atmotk/actions/cl_*.lua", "LUA")
    table.ForEach(actionFiles, function(_, v)
        print("adding " .. v)
        table.insert(ATK_Available_Actions, include("atmotk/actions/" .. v))
    end)
    SelectedAction = ATK_Available_Actions[1]
end

ATK_Register_Actions()



local function ATK_OnBindPress(_, bind)
    if (not ATK_Active) then return end
    if (not bind == "+attack" and not bind == "+attack2") then return end
    if (bind == "+attack2") then
        print("Show Config")
    elseif (bind == "+attack") then
        print("Doing action " .. SelectedAction["name"])
        net.Start("ATK_Action")
        net.WriteString(SelectedAction["name"])
        table.ForEach(SelectedAction["perams"], function(k, v)
            if (SelectedAction["values"][k] == nil) then
                v(SelectedAction["default"][k])
            else
                v(SelectedAction["values"][k])
            end
        end)
        net.SendToServer()
    end
end

hook.Add("PlayerBindPress", "ATK_OnBindPress", ATK_OnBindPress)
