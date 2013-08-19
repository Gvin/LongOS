function Class(base, init)
   local c = {}    -- a new class instance
   if not init and type(base) == 'function' then
      init = base
      base = nil
   elseif type(base) == 'table' then
    -- our new class is a shallow copy of the base class!
      for i,v in pairs(base) do
         c[i] = v
      end
      c._base = base
   end
   -- the class will be the metatable for all its objects,
   -- and they will look up their methods in it.
   c.__index = c

   -- expose a constructor which can be called by <classname>(<args>)
   local mt = {}
   mt.__call = function(class_tbl, ...)
   local obj = {}
   setmetatable(obj,c)
   if init then
      init(obj,...)
   else 
      -- make sure that any stuff from the base class is initialized!
      if base and base.init then
         base.init(obj, ...)
      end
   end
   return obj
   end
   c.init = init
   c._is_a = function(self, klass)
      local m = getmetatable(self)
      while m do 
         if m == klass then return true end
         m = m._base
      end
      return false
   end
   setmetatable(c, mt)
   return c
end

Object = Class(function(this, _className)

   local className;

   function this:GetClassName()
      return className;
   end

   function this:ToString()
      return 'Instance of class "'..className..'".';
   end

   local function constructor(_className)
      if (type(_className) ~= 'string') then
         error('Object.Construnctor [className]: String expected, got '..type(_className)..'.');
      end

      className = _className;
   end

   constructor(_className);
end)