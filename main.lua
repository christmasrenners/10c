
local _ROOT = (...):match("(.-)[^%.]+$")
local repl = require("love-repl") 


-- Init

function InitCharacter()

	screenSize = {x=800,y=600}
	screenLoc = {x=0,y=0}
	characterLoc = {x=screenSize.x/2,y=screenSize.y/2}
	mouseLoc = {x=0,y=0}
end

--- LOVE Functions  -------------------------------------------------------------------------

function love.load()
	
	love.graphics.setCaption("10c")

	math.randomseed( os.time() )

	-- Init debug console
	 repl.initialize()


	 InitCharacter()

end


function love.keypressed(key, unicode)

	if (key == "w") then characterLoc.y = characterLoc.y + 1 return end
	if (key == "a") then characterLoc.x = characterLoc.x - 1 return end
	if (key == "s") then characterLoc.y = characterLoc.y - 1 return end
	if (key == "d") then characterLoc.x = characterLoc.x + 1 return end


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

function love.update()
  -- If the REPL is open, you probably don't want to update your game
  if repl.toggled() then
    return
  end

  local dt = 100*love.timer.getDelta()

	if love.keyboard.isDown("w") then characterLoc.y = characterLoc.y - dt  end
	if love.keyboard.isDown("a") then characterLoc.x = characterLoc.x - dt  end
	if love.keyboard.isDown("s") then characterLoc.y = characterLoc.y + dt  end
	if love.keyboard.isDown("d") then characterLoc.x = characterLoc.x + dt  end

end

function love.draw()

	love.graphics.setColor(255,0,0,255)
	love.graphics.circle( "fill", characterLoc.x, characterLoc.y, 5, 10 )

	love.graphics.setColor(255,255,255,255)
	love.graphics.print(characterLoc.x.."  "..characterLoc.y,100,100)

-- console
	if repl.toggled() then
	    repl.draw()
	    return
	 end
end

