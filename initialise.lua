function InitCharacter()
   screenSize = {x=800,y=600}
   screenLoc = {x=0,y=0}
   characterLoc = {x=screenSize.x/2,y=screenSize.y/2}
   mouseLoc = {x=0,y=0}
end

-- obs initialise the houses
function InitHouses()
   -- initialise the houses
   local nHouses = 8
   for i=1,nHouses,1 do
      local testX = math.random(tileNumber.x)
      local testY = math.random(tileNumber.y)
      -- check for adjacent road
      tileInfo[testX][testY] = terrainValues.house
   end
end

-- obvs initialise the roads
function InitRoads()
   local nRoads = 3
   for i=1,nRoads,1 do
      local roadPosX =  math.random(tileNumber.x)
      for j=1,tileNumber.y,1 do
	 tileInfo[roadPosX][j] = terrainValues.road
      end
   end
   for i=1,nRoads,1 do
      local roadPosY =  math.random(tileNumber.y)
      for j=1,tileNumber.x,1 do
	 tileInfo[j][roadPosY] = terrainValues.road
      end
   end
end

-- initialise the land, at the moment we have land and scrub
function InitLand()
end

-- initialise the world with all its lovely global variables
function InitWorld()

   worldSize = {x=800,y=600}
   tileSize = 20

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
	 tileInfo[i][j] = terrainValues[terrainMap[math.random(#terrainMap)]]
      end
   end

end

-- initialisation wrapper
function Initialise()
   InitCharacter()
   InitWorld()
   InitRoads()
   InitHouses()
end