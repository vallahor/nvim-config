local t = {}
local t1 = {}

setmetatable(t, t1)
print(assert(getmetatable(t) == t1))
