-- based on where the mouse points
function set_velocity(chx,chy)
   -- launch something directed at the crosshairs
   local mousex,mousey = love.mouse.getPosition()
   local velx = ( mousex - chx )
   local vely = ( mousey - chy )
   local norm = 2.0 / ( math.sqrt( velx*velx + vely*vely ))
   return velx*norm,vely*norm
end

-- throw some shit
function throw()
   -- if we aren't holding anything we can't throw it !!
   if holding_object ~= false then
      local chx,chy = characterLoc.x,characterLoc.y
      throwbody[holding_object]:setPosition(chx,chy)
      -- I had to make the velocities global so that it wouldn't fuck up
      vx[holding_object],vy[holding_object] = set_velocity(chx,chy)
      throwbody[holding_object]:setLinearVelocity(vx[holding_object],vy[holding_object])
      local throwshape = love.physics.newCircleShape(2)
      throwfixture = love.physics.newFixture( throwbody[holding_object] , throwshape )
      holding_object = false
   end
   return
end

-- hit mechanic, will have to think about it
function hit()
   return
end

-- are we close to some object, if we are we pick up the one closest to us
function close_to_object()
   -- at the moment use the throwbody
   local dist = characterLoc.x + characterLoc.y
   local min_idx = false
   -- loop objects
   for i=1,nobjects,1 do
      local thx,thy = throwbody[i]:getPosition()
      local distfromobj = dist - ( thx + thy )
      distfromobj = math.sqrt( distfromobj * distfromobj )
      -- if we are close to an object return its index
      if distfromobj < 20 then min_idx = i end
   end
   return min_idx
end

-- sweet motherfucking pick up shit
function pick_up()
   -- have a distance to object fucking thing
   local close_idx = close_to_object()
   if close_idx ~= false and holding_object == false then
      --print("picked up this motherfucker ... ")
      holding_object = close_idx
   end
   return
end

-- the all important covet mechanic
function covet()
   if love.keyboard.isDown(" ") and covet_bool < 15 then
      -- covet some shit
      love.graphics.setColor(255,0,0,100)
      love.graphics.quad("fill",0,0,worldSize.x,0,worldSize.x,worldSize.y,0,worldSize.y)
      covet_bool = covet_bool + 1
      -- write the word covet
      love.graphics.setFont(font)
      love.graphics.setColor(255,255,255,255)
      love.graphics.print("COVET!!!", worldSize.x/2 - 100 , 10 )
   end
end

-- wrappers for the character drawing and animation of npcs
-- get the mouse position and draw a line to it
function draw_player()
   -- draw the person
   love.graphics.setColor(255,0,0,255)
   love.graphics.circle( "fill", characterLoc.x, characterLoc.y, 5, 10 )

   love.graphics.setColor(255,255,255,255)
   --love.graphics.print(characterLoc.x.."  "..characterLoc.y,100,100)

   love.graphics.drawq(characterImage,characterQuad,characterLoc.x-16,characterLoc.y-32)

   -- draw a crosshair on the mouse pointer of +/- 2 on the mouse pointer
   local x,y = love.mouse.getPosition()
   local chx,chy = characterLoc.x,characterLoc.y

   love.graphics.setColor(255,255,255,255)

   love.graphics.line(x-4,y,x+4,y)
   love.graphics.line(x,y-4,x,y+4)
end

--draw npcs