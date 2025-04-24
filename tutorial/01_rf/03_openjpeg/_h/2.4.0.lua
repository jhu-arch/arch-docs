-- module for software --
local name  = myModuleName()        -- Software name
local version = myModuleVersion()   -- Should be of form MAJ.MIN.PATCH

local uses_library = true
local uses_include = true
local uses_bin = true
local uses_man = false
local root = pathJoin(marccBase(), name, version)

-- shouldn't be necessary to change anything below this--

if uses_bin then
	prepend_path("PATH", pathJoin(root, "bin"))
end
if uses_library then
	prepend_path("LD_LIBRARY_PATH", pathJoin(root, "lib"))
end
if uses_include then
	prepend_path("C_INCLUDE_PATH", pathJoin(root, "include"))
end
if uses_man then
	prepend_path("MANPATH", pathJoin(root, "share/man"))
end

-- help message
whatis([[PROGRAM: adds ]] .. name .. [[ to your environment variables ]])
