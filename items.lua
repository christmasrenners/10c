

-- Item database
function InitItemDB()

-- test objects
local yellowBall = {}
yellowBall.colour = {r=255,g=255,b=0}
yellowBall.pickup = true
yellowBall.mass = 1
yellowBall.width = 8
yellowBall.height = 8

local redBall = {}
redBall.colour = {r=255,g=0,b=0}
redBall.pickup = false
redBall.mass = 0.1
redBall.width = 6
redBall.height = 6

-- initialise prototype object list
itemDB = {yellowBall,redBall}

end

function SpawnItem( worldDefinition )
	-- generate item at random from DB
   local itemidx = math.random(#itemDB) 
   local newItem = deepcopy(itemDB[itemidx])

   newItem.body = love.physics.newBody( worldDefinition , math.random(worldSize.x) , math.random(worldSize.y) , "dynamic" )
   newItem.shape = love.physics.newCircleShape( 5 ) -- shape should be taken from DB

   newItem.body:setMass(itemDB[itemidx].mass)
   newItem.fixture = love.physics.newFixture(newItem.body, newItem.shape)
   newItem.width = itemDB[itemidx].width
   newItem.height = itemDB[itemidx].height

   return newItem
end
