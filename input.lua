local isDown = love.keyboard.isDown

Input = Object:new { list = {} }
function Input:init(joy)
	table.insert(self.list, self)
	if joy then self.joy = joy end
	self.state = {}
	self.prev_state = {}
end
function Input:update()
	local s
	if self.joy then

		local x, y = self.joy:getAxes()
		x = x or 0
		y = y or 0
		s = {
			left	= self.joy:isGamepadDown("dpleft")	or x < -0.1,
			right	= self.joy:isGamepadDown("dpright")	or x >  0.1,
			up		= self.joy:isGamepadDown("dpup")	or y < -0.1,
			down	= self.joy:isGamepadDown("dpdown")	or y >  0.1,
			a		= self.joy:isGamepadDown("a") or self.joy:isDown(1),
			b		= self.joy:isGamepadDown("b") or self.joy:isDown(2),
			start	= self.joy:isGamepadDown("start"),
			enter	= self.joy:isGamepadDown("start"),
			back	= self.joy:isGamepadDown("back"),
		}
	else
		s = {
			left	= isDown("left"),
			right	= isDown("right"),
			up		= isDown("up"),
			down	= isDown("down"),
			a		= isDown("x"),
			b		= isDown("y") or isDown("z"),
			start	= isDown("space") or isDown(" ") or isDown("return"),
			enter	= isDown("return"),
			back	= isDown("escape"),
		}
	end
	s.dx = bool[s.right] - bool[s.left]
	s.dy = bool[s.down] - bool[s.up]
	self.prev_state = self.state
	self.state = s
end
function Input:gotPressed(key)
	return self.state[key] and not self.prev_state[key]
end
function Input:gotAnyPressed(key)
	for _, input in ipairs(self.list) do
		if input:gotPressed(key) then
			return input
		end
	end
	return false
end
function Input:isConnected()
	if self.joy then self.joy:isConnected() end
	return true
end

Input() -- keyboard
