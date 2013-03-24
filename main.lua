
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

   local dt = 100*love.timer.getDelta()

   -- Update physics
   world:update( dt )

   local moveVal = {x=0,y=0}
   --- periodic boundary conditions
   if love.keyboard.isDown("w") then moveVal.y = moveVal.y-dt end
   if love.keyboard.isDown("a") then moveVal.x = moveVal.x-dt end
   if love.keyboard.isDown("s") then moveVal.y = moveVal.y+dt end
   if love.keyboard.isDown("d") then moveVal.x = moveVal.x+dt end

   local tx,ty = moveObject(characterLoc,moveVal)
   characterLoc = {x=tx, y=ty}

   characterBody:setX(characterLoc.x)
   characterBody:setY(characterLoc.y)

end

-- drawing
function love.draw()

   for i=1,tileNumber.x,1 do 
      for j=1,tileNumber.y,1 do
	 love.graphics.setColor(tileInfo[i][j].colour.r,tileInfo[i][j].colour.g,tileInfo[i][j].colour.b,255)

	 local loc = {(i-1)*tileSize, (j-1)*tileSize}

	 love.graphics.quad("fill",loc[1],loc[2],loc[1]+tileSize, loc[2],loc[1]+tileSize,loc[2]+tileSize,loc[1],loc[2]+tileSize)
      end
   end

   -- draw all of the objects
   for i=1,nobjects,1 do
   -- linearly damp the thrown velocities
      vx[i] = vx[i] * 0.97
      vy[i] = vy[i] * 0.97
      throwbody[i]:setLinearVelocity(vx[i],vy[i])
      -- update the position, seems like each call to this altered the vel?
      local thx,thy = throwbody[i]:getPosition()
      -- if we are holding it we cannot plot it
      love.graphics.setColor(0,0,255,255)
      if holding_object ~=i then
	 love.graphics.circle( "fill", thx, thy, 2, 10 )
      end
   end

   -- set up the targeting
   draw_player()

   -- covet that ass
   covet() 

   -- console
   if repl.toggled() then repl.draw() return end
end

