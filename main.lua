
local _ROOT = (...):match("(.-)[^%.]+$")
local repl = require("love-repl") 


-- Init

function InitCharacter()

   screenSize = {x=800,y=600}
   screenLoc = {x=0,y=0}
   characterLoc = {x=screenSize.x/2,y=screenSize.y/2}
   mouseLoc = {x=0,y=0}
end

function InitWorld()

   worldSize = {x=800,y=600}

   tileSize = 20
   
   -- set the boundary conditions
   bc = bounded

   tileNumber = {x=worldSize.x/tileSize, y=worldSize.y/tileSize}

   terrainMap = {"land","scrub"}

   terrainValues = {}
   terrainValues.land = {}
   terrainValues.land.name = "land"
   terrainValues["land"].colour = {r=155,g=155,b=0,a=255}
   terrainValues.land.collision = false

   terrainValues.scrub = {}
   terrainValues.scrub.name = "scrub"
   terrainValues["scrub"].colour = {r=55,g=55,b=0,a=255}
   terrainValues.scrub.collision = false

   terrainValues.road = {}
   terrainValues.road.name = "road"
   terrainValues["road"].colour = {r=155,g=155,b=155,a=255}
   terrainValues.road.collision = false

   terrainValues.house = {}
   terrainValues.house.name = "house"
   terrainValues["house"].colour = {r=0,g=255,b=0,a=255}
   terrainValues.house.collision = true

   tileInfo = {}
   for i=1,tileNumber.x,1 do 
      tileInfo[i] = {}
      for j=1,tileNumber.y,1 do
	 tileInfo[i][j] = terrainValues[terrainMap[math.random(#terrainMap)]]
      end
   end




   for i=1,3,1 do

   	   local roadPosX =  math.random(tileNumber.x)

   	   for j=1,tileNumber.y,1 do
   	   		tileInfo[roadPosX][j] = terrainValues.road
   	   end
   end

    for i=1,3,1 do

   	   local roadPosY =  math.random(tileNumber.y)

   	   for j=1,tileNumber.x,1 do
   	   		tileInfo[j][roadPosY] = terrainValues.road
   	   end
   end


   local nHouses = 8

   for i=1,nHouses,1 do
   	local testX = math.random(tileNumber.x)
   	local testY = math.random(tileNumber.y)

   	-- check for adjacent road
   	tileInfo[testX][testY] = terrainValues.house

   end


end

--- LOVE Functions  -------------------------------------------------------------------------

function love.load()
   
   love.graphics.setCaption("10c")

   math.randomseed( os.time() )

   -- remove the cursor
   love.mouse.setVisible(false)

   -- Init debug console
   repl.initialize()


   InitCharacter()
   InitWorld()

end


function love.keypressed(key, unicode)

   -- DEBUG CONSOLE ---------------------------------------------------
   if key == 'tab' then
      repl.toggle()
      return
   end

   -- repl console
   if repl.toggled() then
      repl.keypressed(key, unicode)
      return
   end

   -- General keys
   if (key == 'q' and love.keyboard.isDown("lshift")==true ) then
      love.event.quit( )
   end

end



--- not used atm
function love.mousepressed(x, y, button)
   if repl.toggled() then
      repl.mousepressed(x, y, button)
      return
   end
end

--- boundary conditions periodic
function periodic( new , compare )
   if new < 0 then return compare end
   if new > compare then return 0 end
   return new 
end

-- boundary conditions, bounded
function bounded( new , compare )
   if new < 0 then return 0 end
   if new > compare then return compare end
   return new 
end

function love.update()
   -- If the REPL is open, you probably don't want to update your game
   if repl.toggled() then
      return
   end

   local dt = 100*love.timer.getDelta()

   --- periodic boundary conditions
   if love.keyboard.isDown("w") then characterLoc.y = bc(characterLoc.y-dt,screenSize.y) end
   if love.keyboard.isDown("a") then characterLoc.x = bc(characterLoc.x-dt,screenSize.x) end
   if love.keyboard.isDown("s") then characterLoc.y = bc(characterLoc.y+dt,screenSize.y) end
   if love.keyboard.isDown("d") then characterLoc.x = bc(characterLoc.x+dt,screenSize.x) end

end

-- get the mouse position and draw a line to it
function draw_player()
   -- draw the person
   love.graphics.setColor(255,0,0,255)
   love.graphics.circle( "fill", characterLoc.x, characterLoc.y, 5, 10 )

   love.graphics.setColor(255,255,255,255)
   love.graphics.print(characterLoc.x.."  "..characterLoc.y,100,100)

   -- draw a crosshair on the mouse pointer of +/- 2 on the mouse pointer
   local x,y = love.mouse.getPosition()
   local chx,chy = characterLoc.x,characterLoc.y

   love.graphics.setColor(255,255,255,255)

   love.graphics.line(x-4,y,x+4,y)
   love.graphics.line(x,y-4,x,y+4)
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

   -- set up the targeting
   draw_player()

   -- console
   if repl.toggled() then repl.draw() return end
end

