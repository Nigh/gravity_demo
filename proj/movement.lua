movement={}

function movement.attachSpeed(o,x,y)
	o=o or {}
	o.vx,o.vy=x,y
end

function movement.changeSpeed(o,ax,ay,dt)
	o.vx,o.vy=o.vx+ax*dt,o.vy+ay*dt
end

function movement.move(o,dt)
	o.x,o.y=o.x+o.vx*dt,o.y+o.vy*dt
end

return movement
