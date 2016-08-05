local M = {}
local mt = {}

-- taken from https://gist.github.com/3344709
local function print_table ( t ) 
	local print_table_cache={}
	local function sub_print_table(t,indent)
		if ( print_table_cache[ tostring(t) ] ) then
			print( indent .. "*" .. tostring(t) )
		else
			print_table_cache[ tostring(t) ]=true
			if (type(t)=="table") then
				for pos,val in pairs(t) do
					if (type(val)=="table") then
						print(indent.."["..pos.."] => "..tostring(t).." {")
						sub_print_table(val,indent..string.rep(" ", 4))
						print(indent..string.rep(" ", 4) .."}")
					elseif (type(val)=="string") then
						print(indent.."[".. tostring( pos ) ..'] => "'..val..'"')
					else
						print(indent.."[" .. tostring( pos ) .."] => "..tostring(val))
					end
				end
			else
				print(indent..tostring(t))
			end
		end
	end
	if (type(t)=="table") then
		print(tostring(t).." {")
		sub_print_table(t," ")
		print("}")
	else
		sub_print_table(t," ")
	end
end

M.disabled = false

function M.log(...)
	if M.disabled then
		return
	end

	for _, val in ipairs{...} do
		if type(val) == 'table' then
			print_table(val)
		else
			print(tostring(val))
		end
	end
end

mt.__call = function (t, ...)
	M.log(...)
end

mt.__index = M

return setmetatable(M, mt)