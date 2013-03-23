
local _ROOT = (...):match("(.-)[^%.]+$")
local repl = require("love-repl") 


--- LOVE Functions  -------------------------------------------------------------------------

function love.load()
	
	love.graphics.setCaption("10c")

	math.randomseed( os.time() )

	-- Init debug console
	 repl.initialize()

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

function love.update()
  -- If the REPL is open, you probably don't want to update your game
  if repl.toggled() then
    return
  end
end

function love.draw()
-- console
	if repl.toggled() then
	    repl.draw()
	    return
	 end
end

