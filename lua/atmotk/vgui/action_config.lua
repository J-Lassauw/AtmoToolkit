local function ATK_Init_Config_Frame(configFrame)
    configFrame:SetSize(ScrW() * 0.3, ScrH() * 0.5)
    configFrame:SetDraggable(false)
    configFrame:SetBackgroundBlur(true)
    configFrame:SetTitle("Action Configuration - AtmoTK")
    configFrame:Center()
    configFrame.OnClose = function()
        gui.EnableScreenClicker(false)
    end
    gui.EnableScreenClicker(true)
    local configScroll = vgui.Create("DScrollPanel", configFrame)
    configScroll:SetSize(ScrW() * 0.3 - 5, ScrH() * 0.5 - 40)
    configScroll:SetPos(0, 25)
    return configScroll
end

local function ATK_Add_Action_Info_To_Config(configScrollPanel)
    local actionInfoPanel = vgui.Create("DPanel", configScrollPanel)
    actionInfoPanel:SetPos(10, 10)
    actionInfoPanel:SetSize(ScrW() * 0.3 - 30, 100)
    local actionNameLabel = vgui.Create("DLabel", actionInfoPanel)
    actionNameLabel:SetText("Action Type: " .. ATK_SelectedAction["guiOptions"]["actionPrintName"])
    actionNameLabel:SetPos(0, 0)
end

function ATK_Show_Action_Config()
    local configFrame = vgui.Create("DFrame")
    local configScrollPanel = ATK_Init_Config_Frame(configFrame)
    ATK_Add_Action_Info_To_Config(configScrollPanel)
end