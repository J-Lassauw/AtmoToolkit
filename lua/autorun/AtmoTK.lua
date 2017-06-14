if SERVER then
    include("atmotk/sv_init.lua")
else
    IncludeCS("atmotk/cl_init.lua")
end