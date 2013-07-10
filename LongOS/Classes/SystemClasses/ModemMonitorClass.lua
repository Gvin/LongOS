ModemMonitor = Class(function(this)

	local modems = {};

	local function updateSide()
		local sides = rs.getSides();

		modemSide = '';
		for i = 1, #sides do
			if (peripheral.getType(sides[i]) == 'modem') then
				modemSide = sides[i];
			end
		end
	end

	this.IsModemConnected = function(_)
		return (#modems > 0);
	end

	this.IsModemEnabled = function(_)
		for i = 1, #modems do
			if (modems[i].Enabled) then
				return true;
			end
		end
		return false;
	end

	this.GetModems = function(_)
		return modems;
	end

	local function getModemType(side)
		local modem = peripheral.wrap(side);
		if (modem.isWireless == nil or modem.isWireless()) then
			return 'wireless';
		else
			return 'wired';
		end
	end

	this.Update = function(_)
		modems = {};
		local sides = rs.getSides();
		for i = 1, #sides do
			if (peripheral.getType(sides[i]) == 'modem') then
				local modem = {};
				modem.Side = sides[i];
				modem.Enabled = rednet.isOpen(sides[i]);
				modem.Type = getModemType(sides[i]);
				table.insert(modems, modem);
			end
		end
	end
end)