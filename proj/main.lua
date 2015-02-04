

g = require("gravity")
m = require("movement")
local rand=love.math.random
function love.load()
	text=""
	love.window.setTitle("Gravity Alpha")
	love.graphics.setFont(love.graphics.newFont("ZpixEX2_EX.ttf",12));

	-- love.graphics.setBackgroundColor(104, 136, 248) --设置背景为蓝色
	love.graphics.setBackgroundColor(33, 35, 34)
	love.window.setMode(800, 600,{vsync=true,fsaa=4})

	love.physics.setMeter(2)
	world = love.physics.newWorld(0, 0, true)
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	phyObj={}

	phyObj.earth=g:createObj(rand(150,250),rand(50,150),90,30)
	phyObj.moon=g:createObj(rand(250,350),rand(250,350),10,5)
	phyObj.moon2=g:createObj(rand(250,350),rand(250,350),20,15)
	phyObj.earth2=g:createObj(rand(100,200),rand(250,350),50,25)


	phyObj.earth.body = love.physics.newBody(world, phyObj.earth.x, phyObj.earth.y, "dynamic") --创建一个动态物体
	phyObj.earth.shape = love.physics.newCircleShape(phyObj.earth.r) --创建一个圆形
	phyObj.earth.fixture = love.physics.newFixture(phyObj.earth.body, phyObj.earth.shape, phyObj.earth.mass/phyObj.earth.r^2) --把圆形附加到物体上,密度为1
	phyObj.earth.fixture:setRestitution(0.2) --反弹系数,即碰撞反弹后速度为原来的0.7倍
	phyObj.earth.fixture:setUserData("earth")

	phyObj.earth2.body = love.physics.newBody(world, phyObj.earth2.x, phyObj.earth2.y, "dynamic") --创建一个动态物体
	phyObj.earth2.shape = love.physics.newCircleShape(phyObj.earth2.r) --创建一个圆形
	phyObj.earth2.fixture = love.physics.newFixture(phyObj.earth2.body, phyObj.earth2.shape, phyObj.earth2.mass/phyObj.earth2.r^2) --把圆形附加到物体上,密度为1
	phyObj.earth2.fixture:setRestitution(0.3) --反弹系数,即碰撞反弹后速度为原来的0.7倍
	phyObj.earth2.fixture:setUserData("earth2")

	phyObj.moon.body = love.physics.newBody(world, phyObj.moon.x, phyObj.moon.y, "dynamic") --创建一个动态物体
	phyObj.moon.shape = love.physics.newCircleShape(phyObj.moon.r) --创建一个圆形
	phyObj.moon.fixture = love.physics.newFixture(phyObj.moon.body, phyObj.moon.shape, phyObj.moon.mass/phyObj.moon.r^2) --把圆形附加到物体上,密度为1
	phyObj.moon.fixture:setRestitution(0.5) --反弹系数,即碰撞反弹后速度为原来的0.7倍
	phyObj.moon.fixture:setUserData("moon")

	phyObj.moon2.body = love.physics.newBody(world, phyObj.moon2.x, phyObj.moon2.y, "dynamic") --创建一个动态物体
	phyObj.moon2.shape = love.physics.newCircleShape(phyObj.moon2.r) --创建一个圆形
	phyObj.moon2.fixture = love.physics.newFixture(phyObj.moon2.body, phyObj.moon2.shape, phyObj.moon2.mass/phyObj.moon2.r^2) --把圆形附加到物体上,密度为1
	phyObj.moon2.fixture:setRestitution(0.7) --反弹系数,即碰撞反弹后速度为原来的0.7倍
	phyObj.moon2.fixture:setUserData("moon2")


	gscale=1
	center=phyObj.earth
	camera={x=0,y=0}
	m.attachSpeed(phyObj.earth,20,10)
	m.attachSpeed(phyObj.moon,40,0)
	m.attachSpeed(phyObj.moon2,5,30)
	m.attachSpeed(phyObj.earth2,-10,0)
end


function love.update(dt)
	local deltaT=dt
	if(deltaT>0.1) then	--限定最大时间片
		deltaT=0.1
	end

	_1,_2=phyObj.earth:getA_Global()
	m.changeSpeed(phyObj.earth,_1,_2,deltaT)
	m.move(phyObj.earth,deltaT)
	_1,_2=phyObj.earth2:getA_Global()
	m.changeSpeed(phyObj.earth2,_1,_2,deltaT)
	m.move(phyObj.earth2,deltaT)

	_1,_2=phyObj.moon:getA_Global()
	m.changeSpeed(phyObj.moon,_1,_2,deltaT)
	m.move(phyObj.moon,deltaT)
	_1,_2=phyObj.moon2:getA_Global()
	m.changeSpeed(phyObj.moon2,_1,_2,deltaT)
	m.move(phyObj.moon2,deltaT)

	phyObj.moon2.body:setX(phyObj.moon2.x);
	phyObj.moon2.body:setY(phyObj.moon2.y);
	phyObj.moon.body:setX(phyObj.moon.x);
	phyObj.moon.body:setY(phyObj.moon.y);
	phyObj.earth2.body:setX(phyObj.earth2.x);
	phyObj.earth2.body:setY(phyObj.earth2.y);
	phyObj.earth.body:setX(phyObj.earth.x);
	phyObj.earth.body:setY(phyObj.earth.y);
	world:update(deltaT)
end


function love.draw()
	-- love.graphics.printf(moon:getMass(),1,0,1)
	_1,_2=phyObj.earth:getA_Global()
	love.graphics.printf(_1.."\n".._2 .."\n[方向键] 移动视角\n[m,n] 控制缩放\n[r] 键切换跟踪视角\n[Esc] 退出",1,0,200)
	love.graphics.printf(">>"..text,1,100,200)
	love.graphics.push()
	
	love.graphics.translate(400+((-center.x-camera.x)*gscale), 300+((-center.y-camera.y)*gscale))
	love.graphics.scale(gscale, gscale)

	love.graphics.setColor(155, 255, 120, 255)
	love.graphics.circle( "fill", phyObj.earth.x, phyObj.earth.y,phyObj.earth.r,phyObj.earth.r+10)
	love.graphics.setColor(255, 155, 120, 255)
	love.graphics.circle( "fill", phyObj.earth2.x, phyObj.earth2.y,phyObj.earth2.r,phyObj.earth2.r+10)
	love.graphics.setColor(120, 155, 255, 255)
	love.graphics.circle( "fill", phyObj.moon2.x, phyObj.moon2.y,phyObj.moon2.r,phyObj.moon2.r+10)
	love.graphics.setColor(rand(100,255), rand(100,255), rand(100,255), 255)
	love.graphics.circle( "fill", phyObj.moon.x, phyObj.moon.y,phyObj.moon.r,phyObj.moon.r+10)

	love.graphics.pop()
end

function love.keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
	if key == "up" then
		camera.y=camera.y-50
	end
	if key == "down" then
		camera.y=camera.y+50
	end
	if key == "left" then
		camera.x=camera.x-50
	end
	if key == "right" then
		camera.x=camera.x+50
	end
	if key == "r" then
		center=g.objList[center.index+1]
		if not center then center=g.objList[1] end
		camera={x=0,y=0}
	end

	if key == "m" then
		gscale=gscale*0.9	--世界缩小
	end
	if key == "n" then
		gscale=gscale*1.1
	end
end

function beginContact(a, b, coll)
	text="beginContact".."\n"..string.sub(text,1,800)
end

function endContact(a, b, coll)
	text="endContact".."\n"..string.sub(text,1,800)
end

function preSolve(a, b, coll)
	text="preSolve".."\n"..string.sub(text,1,800)
end
function postSolve(a, b, coll)
	nx, ny = coll:getNormal()
	text="postSolve:"..nx..","..ny.."\n"..string.sub(text,1,800)
	ia=a:getUserData()
	ib=b:getUserData()
	-- print(ia)
	-- print(ib)
	-- for i=1,#phyObj do
	-- 	if phyObj[ia].fixture == a then
	-- 		fa=phyObj[ia]
	-- 	end
	-- 	if phyObj[ib].fixture == b then
	-- 		fb=phyObj[ib]
	-- 	end
	-- end
	fa=phyObj[ia]
	fb=phyObj[ib]

	fa.vx=fa.vx-nx*3
	fa.vy=fa.vy-ny*3
	fb.vx=fb.vx+nx*3
	fb.vy=fb.vy+ny*3
end
