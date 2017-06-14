AddCSLuaFile()

DEFINE_BASECLASS("base_gmodentity")


ENT.Editable = false
ENT.Spawnable = false
ENT.AdminOnly = true

function ENT:Initialize()
    self:SetModel("models/props/de_nuke/hr_nuke/wires_001/wires_005a_curve_vert_tiny.mdl")
    self:SetSolid(SOLID_NONE)
    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
    self:SetColor(Color(0, 0, 0, 0))
    self:SetRenderMode(RENDERMODE_TRANSALPHA)
    self:AddFlags(FL_KILLME)
    self:SetModelScale(0.001)
end