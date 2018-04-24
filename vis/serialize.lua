-- Created:  Fri 09 Dec 2016
-- Modified: Fri 09 Dec 2016
-- Author:   Josh Wainwright
-- Filename: serialize.lua

local function dict2array(o)
	if type(o) == 'number' or type(o) == 'string' or type(o) == 'boolean' then
		return(o)
	elseif type(o) == 'table' then
		local values = {}
		for k, v in pairs(o) do
			values[#values+1] = {k=k, v=dict2array(v)}
		end
		return values
	else
		error('cannot serialize a ' .. type(o))
	end
end

local function serial(str, o, ind, opt)
	if type(o) == "number" then
		str[#str+1] = o
	elseif type(o) == "string" then
		str[#str+1] = ('%q'):format(o)
	elseif type(o) == 'boolean' then
		str[#str+1] = o and 'true' or 'false'
	elseif type(o) == "table" then
		if #o == 0 then -- Empty
			str[#str+1] = '{}'
		elseif o[1].k == 1 then -- Array
			str[#str+1] = '{'
			for i=1, #o-1 do
				serial(str, o[i].v, ind..opt.indchar, opt)
				str[#str+1] = ','
			end
			serial(str, o[#o].v, ind..opt.indchar, opt)
			str[#str+1] = '}'
		else -- Dictionary
			table.sort(o, function(a,b) return a.k < b.k end)
			str[#str+1] = opt.pretty and '{\n' or '{'
			for i=1, #o do
				local key, val = o[i].k, o[i].v
				local key_fmt = '[%q]='
				if key:match('^%a[%w_]*$') then
					-- simple table declaration format
					key_fmt = '%s='
				end
				str[#str+1] = (opt.pretty and ind or '') .. key_fmt:format(key)
				serial(str, val, ind..opt.indchar, opt)
				if i ~= #o then
					str[#str+1] = ','
				end
				str[#str+1] = opt.pretty and '\n' or ''
			end
			str[#str+1] = (opt.pretty and ind:sub(1,-2) or '') .. "}"
		end
	end
end

local function serialize(o, opt)
	local opt = opt or {}
	if opt.pretty == nil then opt.pretty = true end
	opt.indchar = opt.indchar or '\t'
	local str = {'return '}
	serial(str, dict2array(o), '', opt)
	return table.concat(str)
end

return serialize
