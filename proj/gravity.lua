
gravity={}
_ENV=gravity
objList={}

gravity.objList=objList

G=60000
scale=0.1

function gravity.attachPhyObj(o,mass)
	objList[#objList+1]=o
	o.setMass=o.body.setMass
	if mass~=nil then
		o.setMass(mass)
	end
	o.getG_Between=getG_Between
	o.getG_Global=getG_Global
	o.getA_Global=getA_Global
	o.draw=obj_drawSelf
	o.drawGravity=obj_drawGravity
	o.drawVelocity=obj_drawVelocity
end

function obj_drawSelf( self )
	_G.love.graphics.circle( "fill", 
	self.body:getX(), 
	self.body:getY(),
	self.shape:getRadius(),
	self.shape:getRadius()*6)
end

function obj_drawVelocity( self )
	r=self.shape:getRadius()
	gx,gy=self.body:getLinearVelocity()
	k=r/math.dist(gx,gy,0,0)
	_G.love.graphics.setColor(255, 255, 0, 100)
	_G.love.graphics.line(
	self.body:getX()+gx*k, 
	self.body:getY()+gy*k,
	self.body:getX()+gx*(1+k), 
	self.body:getY()+gy*(1+k))
end
function obj_drawGravity( self )
	r=self.shape:getRadius()
	gx,gy=self:getA_Global()
	k=r/math.dist(gx,gy,0,0)
	_G.love.graphics.setColor(255, 255, 255, 100)
	_G.love.graphics.line(
	self.body:getX()+gx*k, 
	self.body:getY()+gy*k,
	self.body:getX()+gx*(1+k), 
	self.body:getY()+gy*(1+k))
end

function getG_Between( self,Obj_B )
	-- 输出以 self 为观察者的引力向量
	local dist=math.dist(self.body:getX(),self.body:getY(),Obj_B.body:getX(),Obj_B.body:getY())
	local _x,_y=direction(self.body:getX(),self.body:getY(),Obj_B.body:getX(),Obj_B.body:getY())
	local dist2
	if(dist>self.shape:getRadius()+Obj_B.shape:getRadius()-1) then	--重叠时，按照接触距离计算引力
		dist2=((scale*dist)^2)
	else
		dist2=((scale*(self.shape:getRadius()+Obj_B.shape:getRadius()))^2)
	end
	local force=G*self.body:getMass()*Obj_B.body:getMass()/dist2
	return _x*force,_y*force
end

function getG_Global( self )
	local forceX,forceY=0,0
	for i=1,#objList do
		if(objList[i]~=self) then
			_x,_y=self:getG_Between(objList[i])
			forceX=forceX+_x
			forceY=forceY+_y
		end
	end
	return forceX,forceY
end

function getA_Global(self)
	local _x,_y=self:getG_Global()
	return _x/self.body:getMass(),_y/self.body:getMass()
end

function gravity:update( ... )
	for i,v in ipairs(objList) do
		v.body:applyForce(v:getG_Global())
	end
end

function math.dist(x1,y1,x2,y2)--求2点距离
	return _G.math.sqrt( (x1-x2)^2 + (y1-y2)^2 )
end

function direction(x1,y1,x2,y2)--归一化方向向量
	-- 以 1 为观测者
	local x = x2-x1
	local y = y2-y1
	local dist = math.dist(x,y,0,0)
	return x/dist,y/dist
end

-- function gravity(x1,y1,x2,y2)
-- 	local distance = math.dist(x1,y1,x2,y2)
-- 	local force = 1000/(distance^2)
-- 	return {force,direction(x1,y1,x2,y2)}
-- end


-- function antigravity(x1,y1,x2,y2)
-- 	local distance = math.dist(x1,y1,x2,y2)
-- 	local force = (distance^2)/1000
-- 	return {force,direction(x1,y1,x2,y2)}
-- end

return gravity
