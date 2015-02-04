
gravity={}
_ENV=gravity
objList={}

gravity.objList=objList

G=1000
scale=0.9

function gravity:createObj( x,y,mass,radius,o )
	o=o or {x=x,y=y,mass=mass,r=radius}
	_G.setmetatable(o, self)
	self.__index = self
	o.index=#objList+1
	objList[#objList+1]=o
	return o
end

function gravity:getMass()
	return self.mass
end

function gravity:getG_Between(Obj_B)
	-- 输出以 self 为观察者的引力向量
	local dist=math.dist(self.x,self.y,Obj_B.x,Obj_B.y)
	local _x,_y=direction(self.x,self.y,Obj_B.x,Obj_B.y)
	local dist2
	if(dist>self.r+Obj_B.r-1) then	--重叠时，按照接触距离计算引力
		dist2=((scale*dist)^2)
	else
		dist2=((scale*(self.r+Obj_B.r))^2)
	end
	local force=G*self:getMass()*Obj_B:getMass()/dist2
	return _x*force,_y*force
end

function gravity:getG_Global()
	local forceX,forceY=0,0
	for i=1,#objList do
		if(i~=self.index) then
			_x,_y=self:getG_Between(objList[i])
			forceX=forceX+_x
			forceY=forceY+_y
		end
	end
	return forceX,forceY
end

function gravity:getA_Global()
	local _x,_y=self:getG_Global()
	return _x/self:getMass(),_y/self:getMass()
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
