NPCSpawn = {
    -- Shared Name / UID
    ["name"] = "npcspawn",

    -- Network values by client
    ["perams"] = {
        { ["name"] = "npcName", ["export"] = net.WriteString, ["import"] = net.ReadString },
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
        ["npcName"] = "npc_zombie",
    },

    -- User customizations storage (overwrites default)
    ["values"] = {
        ["init"] = true -- Avoid this variable being optimized out
    },

    -- Serverside function of action
    ["function"] = function(args)
        -- Sorry garry
        local function InternalSpawnNPC(Player, Position, Normal, Class, Equipment, SpawnFlagsSaved, NoDropToFloor)

            local NPCList = list.Get("NPC")
            local NPCData = NPCList[Class]

            -- Don't let them spawn this entity if it isn't in our NPC Spawn list.
            -- We don't want them spawning any entity they like!
            if ( ! NPCData) then
                if (IsValid(Player)) then
                    Player:SendLua("Derma_Message( \"Sorry! You can't spawn that NPC!\" )")
                end
                return
            end

            if (NPCData.AdminOnly & & ! Player:IsAdmin()) then return end

            local bDropToFloor = false

            --
            -- This NPC has to be spawned on a ceiling ( Barnacle )
            --
            if (NPCData.OnCeiling & & Vector(0, 0, -1):Dot(Normal) < 0.95) then
                return nil
            end

            --
            -- This NPC has to be spawned on a floor ( Turrets )
            --
            if (NPCData.OnFloor & & Vector(0, 0, 1):Dot(Normal) < 0.95) then
                return nil
            else
                bDropToFloor = true
            end

            if (NPCData.NoDrop | | NoDropToFloor) then bDropToFloor = false end

            -- Create NPC
            local NPC = ents.Create(NPCData.Class)
            if ( ! IsValid(NPC)) then return end

            --
            -- Offset the position
            --
            local Offset = NPCData.Offset or 32
            NPC:SetPos(Position + Normal * Offset)

            -- Rotate to face player (expected behaviour)
            local Angles = Angle(0, 0, 0)

            if (IsValid(Player)) then
                Angles = Player:GetAngles()
            end

            Angles.pitch = 0
            Angles.roll = 0
            Angles.yaw = Angles.yaw + 180

            if (NPCData.Rotate) then Angles = Angles + NPCData.Rotate end

            NPC:SetAngles(Angles)

            --
            -- This NPC has a special model we want to define
            --
            if (NPCData.Model) then
                NPC:SetModel(NPCData.Model)
            end

            --
            -- This NPC has a special texture we want to define
            --
            if (NPCData.Material) then
                NPC:SetMaterial(NPCData.Material)
            end

            --
            -- Spawn Flags
            --
            local SpawnFlags = bit.bor(SF_NPC_FADE_CORPSE, SF_NPC_ALWAYSTHINK)
            if (NPCData.SpawnFlags) then SpawnFlags = bit.bor(SpawnFlags, NPCData.SpawnFlags) end
            if (NPCData.TotalSpawnFlags) then SpawnFlags = NPCData.TotalSpawnFlags end
            if (SpawnFlagsSaved) then SpawnFlags = SpawnFlagsSaved end
            NPC:SetKeyValue("spawnflags", SpawnFlags)
            NPC.SpawnFlags = SpawnFlags

            --
            -- Optional Key Values
            --
            if (NPCData.KeyValues) then
                for k, v in pairs(NPCData.KeyValues) do
                    NPC:SetKeyValue(k, v)
                end
            end

            --
            -- This NPC has a special skin we want to define
            --
            if (NPCData.Skin) then
                NPC:SetSkin(NPCData.Skin)
            end

            --
            -- What weapon should this mother be carrying
            --

            -- Check if this is a valid entity from the list, or the user is trying to fool us.
            local valid = false
            for _, v in pairs(list.Get("NPCUsableWeapons")) do
                if v.class == Equipment then valid = true break end
            end

            if (Equipment & & Equipment ! = "none" & & valid) then
                NPC:SetKeyValue("additionalequipment", Equipment)
                NPC.Equipment = Equipment
            end

            DoPropSpawnedEffect(NPC)

            NPC:Spawn()
            NPC:Activate()

            if (bDropToFloor & & ! NPCData.OnCeiling) then
                NPC:DropToFloor()
            end

            if (NPCData.Health) then
                NPC:SetHealth(NPCData.Health)
            end

            return NPC
        end

        local ply = args["ply"]
        local effectdata = EffectData()
        local tr = ply:GetEyeTrace()
        InternalSpawnNPC(ply, tr.HitPos, tr.HitNormal, args["npcName"])
    end
}
return NPCSpawn
