function InitCharacter()
   screenSize = {x=800,y=600}
   screenLoc = {x=0,y=0}
   characterLoc = {x=screenSize.x/2,y=screenSize.y/2}
   mouseLoc = {x=0,y=0}

   characterImage = love.graphics.newImage("character.png")
   characterQuad  = love.graphics.newQuad(0,0,32,48,32,48)

   characterBody = love.physics.newBody(world,characterLoc.x,characterLoc.y)
   characterShape = love.physics.newCircleShape( 5 )
   characterFixture = love.physics.newFixture( characterBody, characterShape )
end

-- obs initialise the houses
function InitHouses()
   -- initialise the houses
   local nHouses = 8
   for i=1,nHouses,1 do
      local testX = math.random(tileNumber.x)
      local testY = math.random(tileNumber.y)

      tileInfo[testX][testY] = deepcopy(terrainValues.house)

      -- box2d
      tileInfo[testX][testY].body  = love.physics.newBody(world, testX*tileSize + tileSize/2, testY*tileSize + tileSize/2) 
      tileInfo[testX][testY].shape = love.physics.newRectangleShape( tileSize, tileSize )
      tileInfo[testX][testY].fixture = love.physics.newFixture( tileInfo[testX][testY].body, tileInfo[testX][testY].shape )

   end
end

-- obvs initialise the roads
function InitRoads()
   local nRoads = 3
   for i=1,nRoads,1 do
      local roadPosX =  math.random(tileNumber.x)
      for j=1,tileNumber.y,1 do
	 tileInfo[roadPosX][j] = deepcopy(terrainValues.road)
      end
   end
   for i=1,nRoads,1 do
      local roadPosY =  math.random(tileNumber.y)
      for j=1,tileNumber.x,1 do
	 tileInfo[j][roadPosY] = deepcopy(terrainValues.road)
      end
   end
end

function InitWorldTiles()

   worldSize = {x=800,y=600}
   tileSize = 20

   font = love.graphics.newFont(50) -- the number denotes the font size

   -- set the boundary conditions , choices are bounded or periodic
   bc = bounded
   if (bc ~= bounded) or (bc ~= periodic) then bc = bounded end

   tileNumber = {x=worldSize.x/tileSize, y=worldSize.y/tileSize}

   local terrainMap = {"land","scrub"}
   terrainValues = {}
   terrainValues.land = {}
   terrainValues.land.name = "land"
   terrainValues["land"].colour = {r=155,g=155,b=0,a=255}
   terrainValues.land.collision = false

   terrainValues.scrub = {}
   terrainValues.scrub.name = "scrub"
   terrainValues["scrub"].colour = {r=55,g=55,b=0,a=255}
   terrainValues.scrub.collision = false

   -- house type
   terrainValues.house = {}
   terrainValues.house.name = "house"
   terrainValues["house"].colour = {r=0,g=255,b=0,a=255}
   terrainValues.house.collision = true

   terrainValues.road = {}
   terrainValues.road.name = "road"
   terrainValues["road"].colour = {r=155,g=155,b=155,a=255}
   terrainValues.road.collision = false

   tileInfo = {}
   for i=1,tileNumber.x,1 do 
      tileInfo[i] = {}
      for j=1,tileNumber.y,1 do
	 tileInfo[i][j] = deepcopy(terrainValues[terrainMap[math.random(#terrainMap)]])
      end
   end

end


function InitIndoors()

end


-- initialisation wrapper
function Initialise()

   -- init physics world
   world = love.physics.newWorld( 0, 0 )

   InitCharacter()
   InitWorldTiles()
   InitRoads()
   InitHouses()
end