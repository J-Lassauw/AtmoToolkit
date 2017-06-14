ATK_SelectedAction = {}
ATK_Available_Actions = {}

local function ATK_Register_Actions()
    local actionFiles = file.Find("atmotk/actions/*.lua", "LUA")
    for _, v in pairs(actionFiles) do
        print("adding " .. v)
        table.insert(ATK_Available_Actions, include("atmotk/actions/" .. v))
    end
    ATK_SelectedAction = ATK_Available_Actions[1]
end
ATK_Register_Actions()

function ATK_GetSelectionIndex()
    local indexFound = 1
    for _, v in SortedPairs(ATK_Available_Actions) do
        if (v["name"] == ATK_SelectedAction["name"]) then
            return indexFound
        end
        indexFound = indexFound + 1
    end
end


local function ATK_OnAttackBind(bind)
    if (bind == "+attack2") then
        print("Show Config")
    elseif (bind == "+attack") then
        print("Doing action " .. ATK_SelectedAction["name"])
        net.Start("ATK_Action")
        net.WriteString(ATK_SelectedAction["name"])
        for _, v in SortedPairs(ATK_SelectedAction["perams"]) do
            local paramName = v["name"]
            print(paramName)
            print(ATK_SelectedAction["default"][paramName])
            if (ATK_SelectedAction["values"][paramName] == nil) then
                v["export"](ATK_SelectedAction["default"][paramName])
            else
                v["export"](ATK_SelectedAction["values"][paramName])
            end
        end
        net.SendToServer()
    end
end

local function ATK_SelectActionByIndex(newIndex)
    local currentIndex = 1
    for _, v in SortedPairs(ATK_Available_Actions) do
        if currentIndex == newIndex then
            ATK_SelectedAction = v
            return
        end
        currentIndex = currentIndex + 1
    end
end

local function ATK_OnScrollBind(bind)
    local selectionIndex = ATK_GetSelectionIndex()
    if (bind == "invprev") then
        if (selectionIndex == 1) then
            ATK_SelectActionByIndex(#ATK_Available_Actions)
        else
            ATK_SelectActionByIndex(selectionIndex - 1)
        end
    elseif (bind == "invnext") then
        if (selectionIndex == #ATK_Available_Actions) then
            ATK_SelectActionByIndex(1)
        else
            ATK_SelectActionByIndex(selectionIndex + 1)
        end
    end
end


local function ATK_OnBindPress(_, bind)
    if (not ATK_Active) then return end

    if (bind == "+attack" or bind == "+attack2") then
        ATK_OnAttackBind(bind)
        return
    end

    if (bind == "invprev" or bind == "invnext") then
        ATK_OnScrollBind(bind)
        return
    end
end

hook.Add("PlayerBindPress", "ATK_OnBindPress", ATK_OnBindPress)
