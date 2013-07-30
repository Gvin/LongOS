Timer = Class(function(this, interval)

	this.GetClassName = function()
		return 'Timer';
	end

	this.Interval = interval;
	local enabled = false;
	this.OnTick = nil;
	this.OnTickParams = nil;

	this.Tick = function(_)
		if (this.OnTick ~= nil) then
			this.OnTick(this.OnTickParams);
		end
	end

	this.GetEnabled = function(_)
		return enabled;
	end

	this.Start = function(_)
		enabled = true;
		System:AddTimer(this);
	end

	this.Stop = function(_)
		enabled = false;
	end
end)