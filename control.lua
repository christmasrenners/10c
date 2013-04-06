-- love callbacks for the pressing of buttons and mouse clicks and stuff
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
   -- covet mechanic
   if key == ' ' then covet_bool=1 else covet_bool=0 end
   -- enter house
   if key == 'return' then checkEnter() end

end

-- return the tile coordinates that the player is currently standing on
function GetPlayerTile()
   return math.floor( characterLoc.x/tileSize ), math.floor( characterLoc.y/tileSize )
end

-- check to see if entering a doorway is possible
function checkEnter()

   local x,y = GetPlayerTile()
   if (tileInfo[x][y].name == "door") then
      if gamemode == "indoors" then SetOutdoorMode() return
      elseif gamemode == "outdoors" then GenRoom() SetIndoorMode() end
   end

end

function love.mousepressed(x, y, button)
   if repl.toggled() then
      repl.mousepressed(x, y, button)
      return
   end
   -- hit and throw
   if button=='l' then 
      return throw() 
   elseif button =='r' then 
      return pick_up()
   end
end

-- conditional move whereby we return the current position if we hit something
function moveObject(current, move)

   local target = { x=bc(current.x+move.x, worldSize.x), y=bc(current.y+move.y, worldSize.y) }
   local index = { x=math.floor( target.x/tileSize), y=math.floor(target.y/tileSize) }

   if index.x < worldSize.x and index.y < worldSize.y then
      if (tileInfo[index.x][index.y].collision == true) then
	 return current.x,current.y
      end
   end

   return target.x,target.y
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

-- set gamemode to indoors
function SetIndoorMode()
   gamemode = "indoors"

   characterLoc = indoorLoc
   characterBody = indoorBody
   characterShape = indoorShape
   characterFixture = indoorFixture

   world = indoorWorld
   tileInfo = indoorTile

   throwbody = throwbodyIndoors
end


function SetOutdoorMode()
   gamemode = "outdoors"

   characterLoc = outdoorLoc
   characterBody = outdoorBody
   characterShape = outdoorShape
   characterFixture = outdoorFixture

   world = outdoorWorld
   tileInfo = outdoorTile

   throwbody = throwbodyOutdoors
end