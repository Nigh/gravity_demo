

g = require("gravity")
m = require("movement")
local rand=love.math.random
function love.load()
  earth=g:createObj(rand(150,250),rand(50,150),90,30)
  moon=g:createObj(rand(250,350),rand(250,350),10,5)
  moon2=g:createObj(rand(250,350),rand(250,350),20,15)
  earth2=g:createObj(rand(100,200),rand(250,350),50,25)
  m.attachSpeed(earth,20,10)
  m.attachSpeed(moon,40,0)
  m.attachSpeed(moon2,5,30)
  m.attachSpeed(earth2,-10,0)
end


function love.update(dt)
	local deltaT=dt
	if(deltaT>0.1) then	--限定最大时间片
		deltaT=0.1
	end
	_1,_2=earth:getA_Global()
	m.changeSpeed(earth,_1,_2,deltaT)
	m.move(earth,deltaT)
	_1,_2=earth2:getA_Global()
	m.changeSpeed(earth2,_1,_2,deltaT)
	m.move(earth2,deltaT)

	_1,_2=moon:getA_Global()
	m.changeSpeed(moon,_1,_2,deltaT)
	m.move(moon,deltaT)
	_1,_2=moon2:getA_Global()
	m.changeSpeed(moon2,_1,_2,deltaT)
	m.move(moon2,deltaT)
end

function love.draw()
	_1,_2=earth:getA_Global()
  -- love.graphics.printf(moon:getMass(),1,0,1)
	love.graphics.printf(_1.."\n".._2 .. " ",1,0,1)

	love.graphics.setColor(155, 255, 120, 255)
	love.graphics.circle( "fill", earth.x, earth.y,earth.r,66)
	love.graphics.setColor(255, 155, 120, 255)
	love.graphics.circle( "fill", earth2.x, earth2.y,earth2.r,66)
	love.graphics.setColor(rand(100,255), rand(100,255), rand(100,255), 255)
	love.graphics.circle( "fill", moon.x, moon.y,moon.r,33)
	love.graphics.setColor(rand(100,255), rand(100,255), rand(100,255), 255)
	love.graphics.circle( "fill", moon2.x, moon2.y,moon2.r,33)
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	if key == "up" then
		earth.y=earth.y+50
		moon.y=moon.y+50
		moon2.y=moon2.y+50
		earth2.y=earth2.y+50
	end
	if key == "down" then
		earth.y=earth.y-50
		moon.y=moon.y-50
		moon2.y=moon2.y-50
		earth2.y=earth2.y-50
	end
	if key == "left" then
		earth.x=earth.x+50
		moon.x=moon.x+50
		moon2.x=moon2.x+50
		earth2.x=earth2.x+50
	end
	if key == "right" then
		earth.x=earth.x-50
		moon.x=moon.x-50
		moon2.x=moon2.x-50
		earth2.x=earth2.x-50
	end
	if key == "r" then
		-- love.load()
	end

end
