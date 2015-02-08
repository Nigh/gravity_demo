

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

	-- phyObj.earth=g:createObj(rand(150,250),rand(50,150),90,30)
	-- phyObj.earth2=g:createObj(rand(100,200),rand(250,350),50,25)
	-- phyObj.moon=g:createObj(rand(250,350),rand(250,350),10,5)
	-- phyObj.moon2=g:createObj(rand(250,350),rand(250,350),20,15)

	phyObj.earth={}
	phyObj.moon={}
	phyObj.moon2={}
	phyObj.earth2={}

	-- Body:setLinearVelocity
	-- Body:applyForce
	phyObj.earth.body = love.physics.newBody(world, rand(150,250), rand(50,150), "dynamic")
	phyObj.earth.shape = love.physics.newCircleShape(30)
	phyObj.earth.fixture = love.physics.newFixture(phyObj.earth.body, phyObj.earth.shape, 90/phyObj.earth.shape:getRadius()^2) --把圆形附加到物体上,密度为1
	phyObj.earth.fixture:setRestitution(0.91)
	phyObj.earth.fixture:setUserData("earth")

	phyObj.earth2.body = love.physics.newBody(world, rand(100,200), rand(250,350), "dynamic") --创建一个动态物体
	phyObj.earth2.shape = love.physics.newCircleShape(25) --创建一个圆形
	phyObj.earth2.fixture = love.physics.newFixture(phyObj.earth2.body, phyObj.earth2.shape, 50/phyObj.earth2.shape:getRadius()^2) --把圆形附加到物体上,密度为1
	phyObj.earth2.fixture:setRestitution(0.95)
	phyObj.earth2.fixture:setUserData("earth2")

	phyObj.moon.body = love.physics.newBody(world, rand(250,350), rand(250,350), "dynamic") --创建一个动态物体
	phyObj.moon.shape = love.physics.newCircleShape(5) --创建一个圆形
	phyObj.moon.fixture = love.physics.newFixture(phyObj.moon.body, phyObj.moon.shape, 10/phyObj.moon.shape:getRadius()^2) --把圆形附加到物体上,密度为1
	phyObj.moon.fixture:setRestitution(0.97)
	phyObj.moon.fixture:setUserData("moon")

	phyObj.moon2.body = love.physics.newBody(world, rand(250,350), rand(250,350), "dynamic") --创建一个动态物体
	phyObj.moon2.shape = love.physics.newCircleShape(15) --创建一个圆形
	phyObj.moon2.fixture = love.physics.newFixture(phyObj.moon2.body, phyObj.moon2.shape, 20/phyObj.moon2.shape:getRadius()^2) --把圆形附加到物体上,密度为1
	phyObj.moon2.fixture:setRestitution(0.99) --反弹系数,即碰撞反弹后速度为原来的x倍
	phyObj.moon2.fixture:setUserData("moon2")


	gravity.attachPhyObj(phyObj.earth)
	gravity.attachPhyObj(phyObj.moon)
	gravity.attachPhyObj(phyObj.earth2)
	gravity.attachPhyObj(phyObj.moon2)
	gscale=1
	center=phyObj.earth
	camera={x=0,y=0}
	-- phyObj.earth.body:setLinearVelocity(20,10)
	phyObj.earth.body:setLinearVelocity(20,10)
	phyObj.moon.body:setLinearVelocity(40,0)
	phyObj.moon2.body:setLinearVelocity(5,30)
	phyObj.earth2.body:setLinearVelocity(-10,0)
end


function love.update(dt)
	local deltaT=dt
	if(deltaT>0.1) then	--限定最大时间片
		deltaT=0.1
	end

	_1,_2=phyObj.earth:getG_Global()
	phyObj.earth.body:applyForce(_1,_2)

	_1,_2=phyObj.moon:getG_Global()
	phyObj.moon.body:applyForce(_1,_2)

	_1,_2=phyObj.earth2:getG_Global()
	phyObj.earth2.body:applyForce(_1,_2)

	_1,_2=phyObj.moon2:getG_Global()
	phyObj.moon2.body:applyForce(_1,_2)

	world:update(deltaT)
end


function love.draw()
	-- love.graphics.printf(moon:getMass(),1,0,1)
	_1,_2=phyObj.earth:getA_Global()
	love.graphics.printf(_1.."\n".._2 .."\n[方向键] 移动视角\n[m,n] 控制缩放\n[r] 键切换跟踪视角\n[Esc] 退出",1,0,200)
	-- love.graphics.printf(">>"..text,1,100,200)
	love.graphics.push()
	
	love.graphics.translate(400+((-center.body:getX()-camera.x)*gscale), 300+((-center.body:getY()-camera.y)*gscale))
	love.graphics.scale(gscale, gscale)

	love.graphics.setColor(155, 255, 120, 255)
	love.graphics.circle( "fill", 
		phyObj.earth.body:getX(), 
		phyObj.earth.body:getY(),
		phyObj.earth.shape:getRadius(),
		phyObj.earth.shape:getRadius()*6)
	love.graphics.setColor(255, 155, 120, 255)
	love.graphics.circle( "fill", 
		phyObj.earth2.body:getX(), 
		phyObj.earth2.body:getY(),
		phyObj.earth2.shape:getRadius(),
		phyObj.earth2.shape:getRadius()*6)
	love.graphics.setColor(120, 155, 255, 255)
	love.graphics.circle( "fill", 
		phyObj.moon2.body:getX(), 
		phyObj.moon2.body:getY(),
		phyObj.moon2.shape:getRadius(),
		phyObj.moon2.shape:getRadius()*6)
	-- love.graphics.setColor(255, 155, 120, 255)
	-- love.graphics.circle( "fill", phyObj.earth2.x, phyObj.earth2.y,phyObj.earth2.r,phyObj.earth2.r+10)
	-- love.graphics.setColor(120, 155, 255, 255)
	-- love.graphics.circle( "fill", phyObj.moon2.x, phyObj.moon2.y,phyObj.moon2.r,phyObj.moon2.r+10)
	love.graphics.setColor(rand(100,255), rand(100,255), rand(100,255), 255)
	love.graphics.circle( "fill", 
		phyObj.moon.body:getX(), 
		phyObj.moon.body:getY(),
		phyObj.moon.shape:getRadius(),
		phyObj.moon.shape:getRadius()*6)

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
		-- center=g.objList[center.index+1]
		if not center then center=g.objList[1] end
		camera={x=0,y=0}
	end

	if key == "m" then
		gscale=gscale*0.95	--世界缩小
	end
	if key == "n" then
		gscale=gscale*1.07	--世界放大
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

function postSolve(fixture1, fixture2, contact)
	nx, ny = contact:getNormal()
	text="postSolve:"..nx..","..ny.."\n"..string.sub(text,1,800)
	-- ia=fixture1:getUserData()
	-- ib=fixture2:getUserData()

	-- fa=phyObj[ia]
	-- fb=phyObj[ib]

end
