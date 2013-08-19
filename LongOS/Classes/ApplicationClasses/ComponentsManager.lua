-- Components manager manages all components of the owner.
-- It takes care about correct events processing and drawing.
ComponentsManager = Class(Object, function(this)
	Object.init(this, 'ComponentsManager');

	local components = {};

	-- Add new component to the manager's collection.
	this.AddComponent = function(_, component)
		table.insert(components, component);
	end

	-- Draw all components to the buffer.
	this.Draw = function(_, videoBuffer, ownerX, ownerY, ownerWidth, ownerHeight)
		for i = 1, #components do
			components[i]:Draw(videoBuffer, ownerX, ownerY, ownerWidth, ownerHeight);
		end
	end

	-- Process left click.
	-- If any of the components has processed this event, processing stoppes.
	this.ProcessLeftClickEvent = function(_, cursorX, cursorY)
		for i = 1, #components do
			if (components[i]:ProcessLeftClickEvent(cursorX, cursorY)) then
				return true;
			end
		end
		return false;
	end

	-- Process key event.
	this.ProcessKeyEvent = function(_, key)
		for i = 1, #components do
			if (components[i]:ProcessKeyEvent(key)) then
				return true;
			end
		end
		return false;
	end

	-- Process char event.
	-- This is especcialy useful for edits or text boxes.
	this.ProcessCharEvent = function(_, char)
		for i = 1, #components do
			if (components[i]:ProcessCharEvent(char)) then
				return true;
			end
		end
		return false;
	end

	-- Process double click event.
	this.ProcessDoubleClickEvent = function(_, cursorX, cursorY)
		for i = 1, #components do
			if (components[i]:ProcessDoubleClickEvent(cursorX, cursorY)) then
				return true;
			end
		end
		return false;
	end

	this.ProcessMouseScrollEvent = function(_, direction, cursorX, cursorY)
		for i = 1, #components do
			if (components[i]:ProcessMouseScrollEvent(direction, cursorX, cursorY)) then
				return true;
			end
		end
		return false;
	end

	-- Gets components count for iteration or some other usages.
	this.GetComponentsCount = function(_)
		return #components;
	end

	-- Get components instance by it's index in the collection.
	this.GetComponent = function(_, index)
		return components[index];
	end

	-- Execute specified operation for each components in the collection.
	this.ForEach = function(_, operation)
		for i = 1, #components do
			operation(components);
		end
	end
end)