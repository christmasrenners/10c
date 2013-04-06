require("items")

function InitCharacter()
  
   -- Character quads
   characterImage = love.graphics.newImage("character.png")
   -- size of the image
   ch_Width = 20
   ch_Height = 20
   ch_distance = math.sqrt( ch_Width*ch_Width + ch_Height*ch_Height)
   characterQuad = love.graphics.newQuad(0,0,ch_Width,ch_Height,ch_Width,ch_Height)

  -- Indoor character
   indoorLoc = {x=screenSize.x/2,y=screenSize.y/2}

   indoorBody = love.physics.newBody(indoorWorld,indoorLoc.x,indoorLoc.y,'dynamic')
   indoorShape = love.physics.newCircleShape( 5 )
   indoorBody:setMass(10)
   indoorFixture = love.physics.newFixture( indoorBody, indoorShape )

   -- Outdoor character
   outdoorLoc = {x=screenSize.x/2,y=screenSize.y/2}

   outdoorBody = love.physics.newBody(outdoorWorld,outdoorLoc.x,outdoorLoc.y,'dynamic')
   outdoorShape = love.physics.newCircleShape( 5 )
   outdoorBody:setMass(10)
   outdoorFixture = love.physics.newFixture( outdoorBody, outdoorShape )

   SetOutdoorMode()

end

function InitObjects()

   -- initialise prototypes
   InitItemDB()

   -- nbodies, randomly generated
   nobjects = 8
   -- start with one
   holding_object=false

   -- initialise the object names
   throwbodyOutdoors = {}
   for i=1,nobjects,1 do
      throwbodyOutdoors[i] = SpawnItem( outdoorWorld )
   end

   throwbodyIndoors = {}
   for i=1,nobjects,1 do
      throwbodyIndoors[i] = SpawnItem( indoorWorld )
   end
   
   if bc == bounded then
      edge = {}
      edge.body = love.physics.newBody(outdoorWorld,0,0,'static')
      edge.shapes = {}
      edge.shapes[1] = love.physics.newEdgeShape(0,0,0,worldSize.y)
      edge.shapes[2] = love.physics.newEdgeShape(0,0,worldSize.x,0)
      edge.shapes[3] = love.physics.newEdgeShape(worldSize.x,worldSize.y,worldSize.x,0)
      edge.shapes[4] = love.physics.newEdgeShape(0,worldSize.y,worldSize.x,worldSize.y)
   
      for i,s in ipairs(edge.shapes) do
	 love.physics.newFixture(edge.body,s)
      end
   end

   -- init indoors boundaries
   edge = {}
   edge.body = love.physics.newBody(indoorWorld,0,0,'static')
   edge.shapes = {}
   edge.shapes[1] = love.physics.newEdgeShape(2*tileSize,2*tileSize,2*tileSize,worldSize.y - 2*tileSize)
   edge.shapes[2] = love.physics.newEdgeShape(2*tileSize,2*tileSize,worldSize.x - 2*tileSize,2*tileSize)
   edge.shapes[3] = love.physics.newEdgeShape(worldSize.x - 2*tileSize,worldSize.y - 2*tileSize,worldSize.x - 2*tileSize,2*tileSize)
   edge.shapes[4] = love.physics.newEdgeShape(2*tileSize,worldSize.y - 2*tileSize,worldSize.x - 2*tileSize,worldSize.y - 2*tileSize)

   for i,s in ipairs(edge.shapes) do
 love.physics.newFixture(edge.body,s)
   end
end

-- is it on the road?
local function onroad(roads,newroad)
   for i,v in ipairs(roads) do
      if newroad == roads[i] then return true end
   end
   return false
end


-- obvs initialise the houses
function InitHouses()

   PlaceHouse(30,4)
   PlaceHouse(20,4)
end

function PlaceHouse(doorX, doorY)

   outdoorTile[doorX][doorY] = deepcopy(outdoorTileDB.door)

   outdoorTile[doorX-1][doorY] = deepcopy(outdoorTileDB.house)
   outdoorTile[doorX+1][doorY] = deepcopy(outdoorTileDB.house)

   outdoorTile[doorX-1][doorY-1] = deepcopy(outdoorTileDB.house)
   outdoorTile[doorX+1][doorY-1] = deepcopy(outdoorTileDB.house)
   outdoorTile[doorX][doorY-1] = deepcopy(outdoorTileDB.house)

   -- Probably should make this a polygon at some point
   AddHouseBody(doorX-1,doorY)
   AddHouseBody(doorX+1,doorY)
   AddHouseBody(doorX-1,doorY-1)
   AddHouseBody(doorX,doorY-1)
   AddHouseBody(doorX+1,doorY-1)

end

-- add the box2d body and shape to a house tile
function AddHouseBody(x,y)

      outdoorTile[x][y].body  = love.physics.newBody(outdoorWorld, x*tileSize + tileSize/2, y*tileSize + tileSize/2) 
      outdoorTile[x][y].shape = love.physics.newRectangleShape( tileSize, tileSize )
      outdoorTile[x][y].fixture = love.physics.newFixture( outdoorTile[x][y].body, outdoorTile[x][y].shape )

end

-- obvs initialise the roads
function InitRoads()

  -- main road
   for j=10,tileNumber.x,1 do
	 outdoorTile[j][5] = deepcopy(outdoorTileDB.road)
   end
end

-- initialse world tile information
function InitWorldTiles()

   worldSize = {x=800,y=600}
   tileSize = 20

   -- set the boundary conditions , choices are bounded or periodic
   bc = bounded
   if (bc ~= bounded) and (bc ~= periodic) then bc = bounded end

   tileNumber = {x=worldSize.x/tileSize, y=worldSize.y/tileSize}

   outdoorTileDB = {}
   outdoorTileDB.land = {}
   outdoorTileDB.land.name = "land"
   outdoorTileDB["land"].colour = {r=155,g=155,b=0,a=255}
   outdoorTileDB.land.collision = false

   outdoorTileDB.scrub = {}
   outdoorTileDB.scrub.name = "scrub"
   outdoorTileDB["scrub"].colour = {r=55,g=55,b=0,a=255}
   outdoorTileDB.scrub.collision = false

   -- house type
   outdoorTileDB.house = {}
   outdoorTileDB.house.name = "house"
   outdoorTileDB["house"].colour = {r=0,g=255,b=0,a=255}
   outdoorTileDB.house.collision = true

   outdoorTileDB.door = {}
   outdoorTileDB.door.name = "door"
   outdoorTileDB["door"].colour = {r=0,g=0,b=0,a=255}
   outdoorTileDB.door.collision = false

   outdoorTileDB.road = {}
   outdoorTileDB.road.name = "road"
   outdoorTileDB["road"].colour = {r=155,g=155,b=155,a=255}
   outdoorTileDB.road.collision = false

end

-- indoor generation
function InitIndoorTiles()

   -- should allow indoors to have different worldsize later
   --worldSize = {x=800,y=600}
   --tileSize = 20

   indoorTileDB = {}
   indoorTileDB.woodenfloor = {}
   indoorTileDB.woodenfloor.name = "woodenfloor"
   indoorTileDB["woodenfloor"].colour = {r=139,g=69,b=19,a=255}
   indoorTileDB.woodenfloor.collision = false

   indoorTileDB.outerwall = {}
   indoorTileDB.outerwall.name = "outerwall"
   indoorTileDB["outerwall"].colour = {r=0,g=0,b=0,a=255}
   indoorTileDB.outerwall.collision = true

   indoorTileDB.door = {}
   indoorTileDB.door.name = "door"
   indoorTileDB["door"].colour = {r=155,g=0,b=0,a=255}
   indoorTileDB.door.collision = false
end

-- randomly generate new world
function GenWorld()

   local  terrainMap = {"land","scrub"}

   outdoorTile = {}
   for i=0,tileNumber.x,1 do 
      outdoorTile[i] = {}
      for j=0,tileNumber.y,1 do
    outdoorTile[i][j] = deepcopy(outdoorTileDB[terrainMap[math.random(#terrainMap)]])
      end
   end
end

-- randomly generate new room
function GenRoom()

   local indoorMap = {"woodenfloor"}

   indoorTile = {}
   for i=0,tileNumber.x,1 do  -- should allow different sizes!
      indoorTile[i] = {}
      for j=0,tileNumber.y,1 do
    indoorTile[i][j] = deepcopy(indoorTileDB[indoorMap[math.random(#indoorMap)]])
      end
   end

   for i=0,tileNumber.x,1 do  -- should allow different sizes!
      indoorTile[i][0] = deepcopy(indoorTileDB.outerwall)
      indoorTile[i][1] = deepcopy(indoorTileDB.outerwall)

      indoorTile[i][tileNumber.y-2] = deepcopy(indoorTileDB.outerwall)
      indoorTile[i][tileNumber.y-1] = deepcopy(indoorTileDB.outerwall)
   end

      for i=0,tileNumber.y,1 do  -- should allow different sizes!
      indoorTile[0][i] = deepcopy(indoorTileDB.outerwall)
      indoorTile[1][i] = deepcopy(indoorTileDB.outerwall)

      indoorTile[tileNumber.x-2][i] = deepcopy(indoorTileDB.outerwall)
      indoorTile[tileNumber.x-1][i] = deepcopy(indoorTileDB.outerwall)
   end

   indoorTile[20][27] = deepcopy(indoorTileDB.door)
   indoorTile[19][27] = deepcopy(indoorTileDB.door)
   indoorTile[21][27] = deepcopy(indoorTileDB.door)

end


-- initialisation wrapper
function Initialise()

   screenSize = {x=800,y=600}
   screenLoc = {x=0,y=0}
   mouseLoc = {x=0,y=0}

   -- init physics worlds
   indoorWorld = love.physics.newWorld( 0, 0 )
   outdoorWorld = love.physics.newWorld( 0, 0 )

   -- initialise the hit counter
   hitClicked = 0

   font = love.graphics.newFont(50) -- the number denotes the font size

   InitWorldTiles()
   InitIndoorTiles()

   GenWorld()
   GenRoom()

   InitRoads()
   InitHouses()
   InitObjects()
   InitCharacter()

      SetOutdoorMode()

end