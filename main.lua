
local _ROOT = (...):match("(.-)[^%.]+$")
repl = require("love-repl") 

-- utility file has deep copy
util = require("utility")

-- global initialisation variables
require("initialise")

-- mouse and keyboard controls
require("control")

-- animation of the character and npc's
require("animate")

-- item management
require("items")

--- LOVE Functions  -------------------------------------------------------------------------

function love.load()

   love.graphics.setCaption("10c")
   math.randomseed( os.time() )

   -- remove the cursor
   love.mouse.setVisible(false)

   -- draw the world
   world = love.physics.newWorld( 0 , 0 , true )

   -- Init debug console
   repl.initialize()

   -- wrapped into initialise.lua
   Initialise()

end


function love.update()
   -- If the REPL is open, you probably don't want to update your game
   if repl.toggled() then return end

   local dt = love.timer.getDelta()

   -- sleep for a bit
   --love.timer.sleep(0.01) 

   -- Update physics
   world:update( 100*dt )

   local moveVal = {x=0,y=0}
   --- periodic boundary conditions
   if love.keyboard.isDown("w") then moveVal.y = moveVal.y-dt end
   if love.keyboard.isDown("a") then moveVal.x = moveVal.x-dt end
   if love.keyboard.isDown("s") then moveVal.y = moveVal.y+dt end
   if love.keyboard.isDown("d") then moveVal.x = moveVal.x+dt end

   characterBody:applyForce( moveVal.x , moveVal.y )
   local tx,ty = characterBody:getPosition()
   --local tx,ty = moveObject(characterLoc,moveVal)
   characterLoc = {x=tx, y=ty}

   --characterBody:setX(characterLoc.x)
   --characterBody:setY(characterLoc.y)

end

-- drawing
function love.draw()

   for i=0,tileNumber.x,1 do 
      for j=0,tileNumber.y,1 do
	 love.graphics.setColor(tileInfo[i][j].colour.r,tileInfo[i][j].colour.g,tileInfo[i][j].colour.b,255)

	 local loc = {i*tileSize, j*tileSize}

	 love.graphics.quad("fill",loc[1],loc[2],loc[1]+tileSize, loc[2],loc[1]+tileSize,loc[2]+tileSize,loc[1],loc[2]+tileSize)
      end
   end

   -- draw all of the objects
   for i=1,nobjects,1 do
   -- linearly damp the thrown velocities
      local vdmpX,vdmpY = throwbody[i].body:getLinearVelocity()
      throwbody[i].body:setLinearVelocity(0.97*vdmpX,0.97*vdmpY)

      -- update the position
      local thx,thy = throwbody[i].body:getPosition()

      -- wrap into our boundary conditions
      local dt = love.timer.getDelta()
      if bc == periodic then 
	 if (vdmpX*vdmpX + vdmpY*vdmpY) > 1E-3 then
	 thx = bc( thx + vdmpX*dt , worldSize.x )
	 thy = bc( thy + vdmpY*dt , worldSize.y )
	 throwbody[i].body:setPosition( thx , thy )
	 end
      end

      -- if we are holding it we will not plot it
      love.graphics.setColor(throwbody[i].colour.r,throwbody[i].colour.g,throwbody[i].colour.b,255)
      if holding_object ~=i then
	 love.graphics.circle( "fill", thx, thy, 4, 10 )
      end
   end

   -- always try and bring the body to rest
   local chvx,chvy = characterBody:getLinearVelocity()
   characterBody:applyForce( -chvx*0.015 , -chvy*0.015 )

   -- set up the targeting
   draw_player()

   -- covet that ass
   covet() 

   -- console
   if repl.toggled() then repl.draw() return end
end

