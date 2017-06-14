AddCSLuaFile()

DEFINE_BASECLASS("base_gmodentity")


ENT.Editable = false
ENT.Spawnable = false
ENT.AdminOnly = true

function ENT:Initialize()
    self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
    self:SetSolid(SOLID_NONE)
    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
    self:SetColor(Color(0, 0, 0, 0))
    self:SetRenderMode(RENDERMODE_TRANSALPHA)
end