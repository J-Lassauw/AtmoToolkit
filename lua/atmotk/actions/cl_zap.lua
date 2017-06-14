ZapAction = {
    ["name"] = "zap",
    ["perams"] = {
        ["effectName"] = net.WriteString,
        ["soundEnabled"] = net.WriteBool
    },
    ["gui_options"] = {
        ["effectName"] = {
            ["print"] = "Effect",
            ["type"] = "Combo",
            ["choices"] = {}
        }
    },
    ["default"] = {
        ["effectName"] = "TeslaHitBoxes",
        ["soundEnabled"] = true
    },
    ["values"] = {
        ["init"] = true
    }
}
return ZapAction