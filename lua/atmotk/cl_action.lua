local SelectedAction = {}
local ATK_Available_Actions = {}

local function ATK_Register_Actions()
    local actionFiles = file.Find("atmotk/actions/*.lua", "LUA")
    for _, v in pairs(actionFiles) do
        print("adding " .. v)
        table.insert(ATK_Available_Actions, include("atmotk/actions/" .. v))
    end
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
        for _, v in SortedPairs(action["perams"]) do
            local paramName = v["name"]
            if (SelectedAction["values"][paramName] == nil) then
                v["export"](SelectedAction["default"][paramName])
            else
                v["export"](SelectedAction["values"][paramName])
            end
        end
        net.SendToServer()
    end
end

hook.Add("PlayerBindPress", "ATK_OnBindPress", ATK_OnBindPress)
