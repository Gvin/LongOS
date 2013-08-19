local Canvas = Classes.System.Graphics.Canvas;


RedirectorGenerator = Class(Object, function(this)
	Object.init(this, 'RedirectorGenerator');

	function this.GenerateRedirector(_, _width, _height)
		local redirector = {};

		redirector.canvas = Canvas(1, 1, _width, _height, 'left-top');

		function redirector.getSize()
			return redirector.canvas:GetWidth(), redirector.canvas:GetHeight();
		end

		function redirector.isColor()
			return true;
		end

		function redirector.isColour()
			return true;
		end

		function redirector.getCursorPos()
			return redirector.canvas:GetCursorPos();
		end

		function redirector.setCursorPos(_x, _y)
			local x = math.floor(_x);
			local y = math.floor(_y);
			redirector.canvas:SetRealCursorPos(x, y);
			redirector.canvas:SetCursorPos(x, y);
		end

		function redirector.write(_text)
			redirector.canvas:Write(_text);
			redirector.canvas:SetRealCursorPos(redirector.canvas:GetCursorPos());
		end

		function redirector.clear()
			redirector.canvas:Clear();
		end

		function redirector.setCursorBlink(_value)
			redirector.canvas:SetCursorBlink(_value);
		end

		function redirector.setTextColor(_value)
			redirector.canvas:SetTextColor(_value);
		end

		function redirector.setBackgroundColor(_value)
			redirector.canvas:SetBackgroundColor(_value);
		end

		function redirector.setTextColour(_value)
			redirector.canvas:SetTextColor(_value);
		end

		function redirector.setBackgroundColour(_value)
			redirector.canvas:SetBackgroundColor(_value);
		end

		function redirector.scroll(_value)
			redirector.canvas:Scroll(_value);
		end

		function redirector.clearLine(_line)
			redirector.canvas:ClearLine(_value);
		end

		return redirector;
	end
end)