require("items")

function InitCharacter()
   screenSize = {x=800,y=600}
   screenLoc = {x=0,y=0}
   characterLoc = {x=screenSize.x/2,y=screenSize.y/2}
   mouseLoc = {x=0,y=0}

   characterImage = love.graphics.newImage("character.png")

   ch_Width = 20
   ch_Height = 20

   characterQuad = love.graphics.newQuad(0,0,ch_Width,ch_Height,ch_Width,ch_Height)

   characterBody = love.physics.newBody(world,characterLoc.x,characterLoc.y,'dynamic')
   characterShape = love.physics.newCircleShape( ch_Height/2 )
   characterBody:setMass(10)
   characterFixture = love.physics.newFixture( characterBody, characterShape )
end

function InitObjects()

   -- initialise prototypes
   InitItemDB()

   -- nbodies, randomly generated
   nobjects = 8
   -- start with one
   holding_object=false

   -- initialise the object names
   throwbody = {}
   for i=1,nobjects,1 do
      throwbody[i] = SpawnItem()
   end
   
   if bc == bounded then
      edge = {}
      edge.body = love.physics.newBody(world,0,0,'static')
      edge.shapes = {}
      edge.shapes[1] = love.physics.newEdgeShape(0,0,0,worldSize.y)
      edge.shapes[2] = love.physics.newEdgeShape(0,0,worldSize.x,0)
      edge.shapes[3] = love.physics.newEdgeShape(worldSize.x,worldSize.y,worldSize.x,0)
      edge.shapes[4] = love.physics.newEdgeShape(0,worldSize.y,worldSize.x,worldSize.y)
   
      for i,s in ipairs(edge.shapes) do
	 love.physics.newFixture(edge.body,s)
      end
   end
end

-- is it on the road?
local function onroad(roads,newroad)
   for i,v in ipairs(roads) do
      if newroad == roads[i] then return true end
   end
   return false
end

-- find a suitable house position
function suitable_house( )
   -- pick a place along a road for the house
   local xory = math.random(2)
   local sub = 2*math.random(2)-3
   if xory == 1 then
      local x = (roadx[math.random(#roadx)]+sub)%tileNumber.x
      local y = (math.random(tileNumber.y+1)-sub)%tileNumber.y
      while onroad( roady , y ) == true do
	 y = (math.random(tileNumber.y+1)-sub)%tileNumber.y
      end
      return x,y
   else
      local x = (math.random(tileNumber.x+1)-sub)%tileNumber.x
      local y = (roady[math.random(#roady)]+sub)%tileNumber.y
      while onroad( roadx , x ) == true do
	 x = (math.random(tileNumber.x+1)-sub)%tileNumber.x
      end
      return x,y
   end
end

-- obvs initialise the houses
function InitHouses()
   -- initialise the houses
   local nHouses = 30
   for i=1,nHouses,1 do

      local testX,testY = suitable_house()

      tileInfo[testX][testY] = deepcopy(terrainValues.house)

      -- box2d
      tileInfo[testX][testY].body  = love.physics.newBody(world, testX*tileSize + tileSize/2, testY*tileSize + tileSize/2) 
      tileInfo[testX][testY].shape = love.physics.newRectangleShape( tileSize, tileSize )
      tileInfo[testX][testY].fixture = love.physics.newFixture( tileInfo[testX][testY].body, tileInfo[testX][testY].shape )

   end
end

-- why would we have two roads next to one another?
local function neigbor_roads(roads,newroad)
   for i,v in ipairs(roads) do
      if newroad == roads[i] then return true end
      if newroad == roads[i]+1 then return true end
      if newroad == roads[i]-1 then return true end
   end
   return false
end

-- obvs initialise the roads
function InitRoads()
   roadx = {}
   roady = {}
   local nRoads = 6
   for i=1,nRoads,1 do
      local roadPosX = math.random(tileNumber.x + 1) -1

      -- add road positions to array roadx
      if i == 1 then roadx[1] = math.random(tileNumber.x + 1) -1 
      else
	 local check = 0
	 while neigbor_roads(roadx,roadPosX) == true or check > 100 do
	    roadPosX = math.random(tileNumber.x + 1) -1
	    check = check + 1 
	 end
	 roadx[i] = roadPosX
      end
      --draw roads
      for j=0,tileNumber.y,1 do
	 tileInfo[roadPosX][j] = deepcopy(terrainValues.road)
      end
   end
   -- and some in the y direction
   for i=1,nRoads,1 do
      local roadPosY = math.random(tileNumber.y + 1) -1

      -- add road positions to array roady
      if i == 1 then roady[1] = roadPosY else
	 local check = 0
	 while neigbor_roads(roady,roadPosY) == true or check > 100 do
	    roadPosY = math.random(tileNumber.y + 1) -1
	    check = check + 1 
	 end
	 roady[i] = roadPosY
      end
      -- and draw again
      for j=0,tileNumber.x,1 do
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
   if (bc ~= bounded) and (bc ~= periodic) then bc = bounded end

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
   for i=0,tileNumber.x,1 do 
      tileInfo[i] = {}
      for j=0,tileNumber.y,1 do
	 tileInfo[i][j] = deepcopy(terrainValues[terrainMap[math.random(#terrainMap)]])
      end
   end

end

-- indoor generation
function InitIndoors()

end


-- initialisation wrapper
function Initialise()

   -- init physics world
   world = love.physics.newWorld( 0, 0 )

   InitWorldTiles()
   InitRoads()
   InitHouses()
   InitObjects()
   InitCharacter()
end