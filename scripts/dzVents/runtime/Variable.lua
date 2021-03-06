local Time = require('Time')

--local function Variable(domoticz, name, value)

local function Variable(domoticz, data)

	local self = {
		['value'] = data.data.value,
		['name'] = data.name,
		['type'] = data.variableType,
		['changed'] = data.changed,
		['id'] = data.id,
		['lastUpdate'] = Time(data.lastUpdate)
	}

	if (data.variableType == 'float' or data.variableType == 'integer') then
		-- actually this isn't needed as value is already in the
		-- proper type
		-- just for backward compatibility
		self['nValue'] = data.data.value
	end

	if (data.variableType == 'date') then
		local d, mon, y = string.match(data.data.value, "(%d+)%/(%d+)%/(%d+)")
		local date = y .. '-' .. mon .. '-' .. d .. ' 00:00:00'
		self['date'] = Time(date)
	end

	if (data.variableType == 'time') then
		local now = os.date('*t')
		local time = tostring(now.year) ..
				'-' .. tostring(now.month) ..
				'-' .. tostring(now.day) ..
				' ' .. data.data.value ..
				':00'
		self['time'] = Time(time)
	end


	-- send an update to domoticz
	function self.set(value)
--		domoticz.sendCommand('Variable:' .. data.name, tostring(value))

		local url = domoticz.settings['Domoticz url'] ..
				'/json.htm?type=command&param=updateuservariable&vname=' .. data.name ..'&vtype=' .. data.variableType .. '&vvalue=' .. tostring(value)

		domoticz.openURL(url)
	end

	return self
end

return Variable