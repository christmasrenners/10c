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
end

--- not used atm
function love.mousepressed(x, y, button)
   if repl.toggled() then
      repl.mousepressed(x, y, button)
      return
   end
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