local handle = io.popen('fzf')
local result = handle:read("*a")
handle:close()
print(result)
