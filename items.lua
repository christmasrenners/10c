

-- Item database
function InitItemDB()

-- test objects
local yellowBall = {}
yellowBall.colour = {r=255,g=255,b=0}
yellowBall.pickup = true

local redBall = {}
redBall.colour = {r=255,g=0,b=0}
redBall.pickup = false

-- initialise prototype object list
itemDB = {yellowBall,redBall}

end

function SpawnItem()
	-- generate item at random from DB
	local newItem = deepcopy(itemDB[math.random(#itemDB)])

	newItem.body = 	love.physics.newBody( world , math.random(worldSize.x) , math.random(worldSize.y) , "dynamic" )
	newItem.shape = love.physics.newCircleShape( 5 ) -- shape should be taken from DB
	newItem.fixture = love.physics.newFixture(newItem.body, newItem.shape)

	return newItem
end