

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

	love.physics.setMeter(32)
	world = love.physics.newWorld(0, 0, true)
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	phyObj={}

	-- phyObj.earth=g:createObj(rand(150,250),rand(50,150),90,30)
	-- phyObj.earth2=g:createObj(rand(100,200),rand(250,350),50,25)
	-- phyObj.moon=g:createObj(rand(250,350),rand(250,350),10,5)
	-- phyObj.moon2=g:createObj(rand(250,350),rand(250,350),20,15)

	phyObj.earth={}
	phyObj.earth2={}
	phyObj.moon={}
	phyObj.moon2={}
	phyObj.star={}
	origin={}
	origin.body={}
	origin.body.x=0
	origin.body.y=0
	origin.body.getX=function(self)return self.x end
	origin.body.getY=function(self)return self.y end
	-- origin.body.getX=function(self)return phyObj.earth.body:getX() end
	-- origin.body.getY=function(self)return phyObj.earth.body:getY() end

	-- Body:setLinearVelocity
	-- Body:applyForce
	phyObj.earth.body = love.physics.newBody(world, 0, 0, "dynamic")
	phyObj.earth.shape = love.physics.newCircleShape(40)
	phyObj.earth.fixture = love.physics.newFixture(phyObj.earth.body, phyObj.earth.shape, 150/phyObj.earth.shape:getRadius()^2) --把圆形附加到物体上,密度为1
	phyObj.earth.fixture:setRestitution(0.91)
	phyObj.earth.fixture:setUserData("earth")

	phyObj.earth2.body = love.physics.newBody(world, 0, rand(520,1050), "dynamic") --创建一个动态物体
	phyObj.earth2.shape = love.physics.newCircleShape(25) --创建一个圆形
	phyObj.earth2.fixture = love.physics.newFixture(phyObj.earth2.body, phyObj.earth2.shape, 50/phyObj.earth2.shape:getRadius()^2) --把圆形附加到物体上,密度为1
	phyObj.earth2.fixture:setRestitution(0.95)
	phyObj.earth2.fixture:setUserData("earth2")

	phyObj.moon.body = love.physics.newBody(world, rand(-650,-400), 0, "dynamic") --创建一个动态物体
	phyObj.moon.shape = love.physics.newCircleShape(5) --创建一个圆形
	phyObj.moon.fixture = love.physics.newFixture(phyObj.moon.body, phyObj.moon.shape, 10/phyObj.moon.shape:getRadius()^2) --把圆形附加到物体上,密度为1
	phyObj.moon.fixture:setRestitution(0.97)
	phyObj.moon.fixture:setUserData("moon")

	phyObj.moon2.body = love.physics.newBody(world, rand(250,350), rand(-350,-250), "dynamic") --创建一个动态物体
	phyObj.moon2.shape = love.physics.newCircleShape(15) --创建一个圆形
	phyObj.moon2.fixture = love.physics.newFixture(phyObj.moon2.body, phyObj.moon2.shape, 20/phyObj.moon2.shape:getRadius()^2) --把圆形附加到物体上,密度为1
	phyObj.moon2.fixture:setRestitution(1.1) --反弹系数,即碰撞反弹后速度为原来的x倍
	phyObj.moon2.fixture:setUserData("moon2")

	phyObj.star.body = love.physics.newBody(world, rand(-250,350), rand(-250,350), "dynamic") --创建一个动态物体
	phyObj.star.shape = love.physics.newCircleShape(30) --创建一个圆形
	phyObj.star.fixture = love.physics.newFixture(phyObj.star.body, phyObj.star.shape, 80/phyObj.star.shape:getRadius()^2) --把圆形附加到物体上,密度为1
	phyObj.star.fixture:setRestitution(0.93) --反弹系数,即碰撞反弹后速度为原来的x倍
	phyObj.star.fixture:setUserData("star")


	gravity.attachPhyObj(phyObj.earth)
	gravity.attachPhyObj(phyObj.moon)
	gravity.attachPhyObj(phyObj.earth2)
	gravity.attachPhyObj(phyObj.moon2)
	gravity.attachPhyObj(phyObj.star)
	gscale=0.3
	center=phyObj.earth
	camera={x=0,y=0}
	-- phyObj.earth.body:setLinearVelocity(20,10)
	phyObj.earth.body:setLinearVelocity(0,0)
	phyObj.earth2.body:setLinearVelocity(rand(20,60),0)
	phyObj.moon.body:setLinearVelocity(0,rand(-128,-40))
	phyObj.moon2.body:setLinearVelocity(rand(-20,-14),rand(24,40))
	phyObj.star.body:setLinearVelocity(rand(-20,-5),rand(-24,-14))
end


function love.update(dt)
	local deltaT=dt
	if(deltaT>0.1) then	--限定最大时间片
		deltaT=0.1
	end

	g:update()
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
	phyObj.earth:draw()

	love.graphics.setColor(255, 155, 120, 255)
	phyObj.earth2:draw()

	love.graphics.setColor(120, 155, 255, 255)
	phyObj.moon2:draw()

	love.graphics.setColor(120, 155, 255, 255)
	phyObj.star:draw()

	-- love.graphics.circle( "fill", 
	-- 	phyObj.star.body:getX(), 
	-- 	phyObj.star.body:getY(),
	-- 	phyObj.star.shape:getRadius(),
	-- 	phyObj.star.shape:getRadius()*6)
	-- love.graphics.setColor(255, 155, 120, 255)
	-- love.graphics.circle( "fill", phyObj.earth2.x, phyObj.earth2.y,phyObj.earth2.r,phyObj.earth2.r+10)
	-- love.graphics.setColor(120, 155, 255, 255)
	-- love.graphics.circle( "fill", phyObj.moon2.x, phyObj.moon2.y,phyObj.moon2.r,phyObj.moon2.r+10)
	love.graphics.setColor(rand(100,255), rand(100,255), rand(100,255), 255)
	phyObj.moon:draw()

	-- phyObj.earth:drawGravity()
	-- phyObj.earth2:drawGravity()
	-- phyObj.moon2:drawGravity()
	-- phyObj.star:drawGravity()
	-- phyObj.moon:drawGravity()
	for i, v in ipairs(g.objList) do
		v:drawGravity()
		v:drawVelocity()
	end

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
		-- rootObj=g.objList[1]
		for i, v in ipairs(g.objList) do
			if center==v then
				center=g.objList[i+1]
				break
			end
		end 
		if center==nil then 
			origin.body.x,origin.body.y=g.objList[1].body:getX(),g.objList[1].body:getY()
			center=origin 
		else if center==origin then
			center=g.objList[1]
		end
		end
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
