function throw()
   -- launch something directed at the crosshairs
   local x,y = love.mouse.getPosition()
   return
end

function hit()
   return
end

function pick_up()
   return
end

-- the all important covet mechanic
function covet()
   if love.keyboard.isDown(" ") and covet_bool < 15 then
      -- covet some shit
      love.graphics.setColor(255,0,0,100)
      love.graphics.quad("fill",0,0,worldSize.x,0,worldSize.x,worldSize.y,0,worldSize.y)
      covet_bool = covet_bool + 1
      -- write the word covet
      love.graphics.setFont(font)
      love.graphics.setColor(255,255,255,255)
      love.graphics.print("COVET!!!", worldSize.x/2 - 100 , 10 )
   end
end

-- wrappers for the character drawing and animation of npcs
-- get the mouse position and draw a line to it
function draw_player()
   -- draw the person
   love.graphics.setColor(255,0,0,255)
   love.graphics.circle( "fill", characterLoc.x, characterLoc.y, 5, 10 )

   love.graphics.setColor(255,255,255,255)
   --love.graphics.print(characterLoc.x.."  "..characterLoc.y,100,100)

   love.graphics.drawq(characterImage,characterQuad,characterLoc.x-16,characterLoc.y-32)

   -- draw a crosshair on the mouse pointer of +/- 2 on the mouse pointer
   local x,y = love.mouse.getPosition()
   local chx,chy = characterLoc.x,characterLoc.y

   love.graphics.setColor(255,255,255,255)

   love.graphics.line(x-4,y,x+4,y)
   love.graphics.line(x,y-4,x,y+4)
end

--draw npcs