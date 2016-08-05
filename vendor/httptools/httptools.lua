local M = {}

function M.urlencode(str)
	if str and type(str) == 'string' then
		str = string.gsub (str, "\n", "\r\n")
		str = string.gsub (str, "([^%w ])", function (c)
			return string.format ("%%%02X", string.byte(c))
		end)
		str = string.gsub (str, " ", "+")

	elseif type(str) == 'boolean' then
		str = tostring(str)
	end
	return str
end

function M.postbody(arg)
	if type(arg) == 'table' then
		local t = {}
		for k, v in pairs(arg) do
			t[#t + 1] = k .. '=' .. M.urlEncode(v)
		end
		local c = table.concat(t, '&')
		return c
	end
	return arg
end

return M
