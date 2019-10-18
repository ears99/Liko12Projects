---------------
-- ROGUELIKE --
---------------

function _init()
 T = 0 --number of frames
 
 --player animation table
 playerAni = {100,101,102,103}
 
 --directions for x and y
 --left, right, up, down
 dirX = {-1, 1,  0, 0}
 dirY = { 0, 0, -1, 1}
 
 _upd = update_game
 _drw = draw_game
 startGame()
end

function _update60()
 T = T + 1 --add one to frame count
 _upd()
end

function _draw()
 _drw()
 --draw the windows on top of everthing else
 --windowcolor, bordercolor, textcolor
 showWindow(0,6,7)
end

function startGame()
 playerX = 1
 playerY = 1
 playerOffsetX = 0
 playerOffsetY = 0
 playerStartOffsetX = 0 
 playerStartOffsetY = 0
 --not flipped by default
 playerFlipped = 1
 aniTimer = 0 
 playerMovement = nil
 --window table
 window = {}
 talkWindow = nil
end

-------------------
--UPDATE FUNCTIONS
-------------------
function update_game()
 for i=1,4 do
  if btnp(i) then
    movePlayer(dirX[i], dirY[i])
    return
  end
 end 
end

--player's turn
function update_pTurn()
--set 0.1 to another value to change player's speed
 aniTimer = min(aniTimer+0.125,1)
 
 playerMovement()

 --check if the animation if over
 if aniTimer == 1 then
  _upd=update_game
 end
end

function update_gameover()
end

--------------------
-- DRAW FUNCTIONS
--------------------
function draw_game()
 clear()
 map()
 drawSprite(getFrame(playerAni), playerX*8+playerOffsetX, playerY*8+playerOffsetY, 10, playerFlipped)
end

function draw_gameover()
 clear(0)
 print("YOU DIED",70,50)
 color(7) --color of second row
 print("PRESS Z TO RESTART", 50, 60)
 color(8) --color of YOU DIED        
end

-----------
-- TOOLS --
-----------

function getFrame(ani)
 return ani[math.floor(T/8)%#ani+1]
end

function drawSprite(_Sprite,_X,_Y,_C, _FLIP)
 palt(0,false)
 pal(6,_C)
 
 --check setting of playerFlipped
 if playerFlipped == -1 then
  Sprite(_Sprite, _X + 8, _Y, 0, _FLIP, 1)
 elseif playerFlipped == 1 then 
  Sprite(_Sprite,_X,_Y, 0, _FLIP, 1)
 end
 
 pal()
end


--function rectFill(_X,_Y,_W,_H,_C)
 --rect(_X, _Y, _X+_W-1, _Y+_H-1)
 --color(_C)
--end  


--LIKO-12 doesnt have all the functions the PICO-8 has (as far as i know)
--so i'll have to write my own versions

function min(A,B)
 if A < B then
  return A
 else
  return B
 end
end

function max(A,B)
 if A > B then
  return A 
 elseif B > A then
  return B
 end
end

function mid(A,B,C)
 if B > A and B < C then
  return B
  end
 end

--------------
-- GAMEPLAY --
--------------
function movePlayer(dx, dy)
  local destX = playerX + dx
  local destY = playerY + dy
  --mget gets a coordinte on the map
  local tile = mget(destX,destY)
   
   --flip the player sprite
      if dx < 0 then
       playerFlipped = -1
      elseif dx > 0 then
       playerFlipped = 1
      end                             
   
   --check for collision with unwalkable
   --tiles
   if fget(tile,1) then
     --wall tile
      playerStartOffsetX = dx*8
      playerStartOffsetY = dy*8
      playerOffsetX = playerStartOffsetX 
      playerOffsetY = playerStartOffsetY
      aniTimer=0
      playerMovement = movement_bump
      _upd=update_pTurn      
      --if interact flag is set
      if fget(tile, 2) then
        trig_bump(tile, destX, destY)
       end    
    else
    playerX = playerX + dx
    playerY = playerY + dy
   end                                                        
end

-------------
--ANIMATIONS
-------------
function movement_walk()
  playerOffsetX = playerStartOffsetX * (1-aniTimer)
  playerOffsetY = playerStartOffsetY * (1-aniTimer)  
end

function movement_bump()
  if aniTimer < 0.5 then
   playerOffsetX = playerStartOffsetX * (aniTimer)
   playerOffsetY = playerStartOffsetY * (aniTimer)       
  else
   playerOffsetX = playerStartOffsetX * (1-aniTimer)
   playerOffsetY = playerStartOffsetY * (1-aniTimer)  
  end
end

function trig_bump(_tile, _destX, _destY)
 if _tile == 005 or _tile == 006 then
   --vase
   SFX(1)
   mset(_destX, _destY, 002)
 elseif _tile == 009 or _tile == 011 then
   --chest
   SFX(2)
   mset(_destX, _destY, _tile-1)
 elseif _tile == 007 then
   --door
   SFX(0)
   mset(_destX, _destY, 002)
 elseif _tile == 012 then
  --stone tablet
  --addWindow(64, 64, 64, 32, {"HELLO WORLD", "THIS IS LINE 2"})
  
  --14 character limit,including space
  --duration is in frames
  showMsg("PORKLIKE",120)
 end 
end

------
--UI--
------

--Window system

function addWindow(_x, _y, _w, _h, _txt)
 --window object
 local w={x=_x, y=_y, w=_w, h=_h, txt=_txt}
 --add the object to the window table
 table.insert(window, w)
 return w --return the object
end

function showWindow(_windowColor, _txtColor, _borderColor)
 for i = 1,#window do
  local w = window[i]
  --window and window color
  rect(w.x,w.y,w.w,w.h)
  color(_windowColor)
  --border of the window
  rect(w.x+1,w.y+1,w.w-2,w.h-2)
  color(_windowColor)
  
  rect(w.x+2,w.y+2,w.w-4,w.h-4)
  color(_borderColor)
  
  --clip not working? can't move player 
  --at all once 
  --clip is called!
  --animations don't play either - 
  --it's as if the game was frozen
  --and the text color 
  --also gets applied as the border
   
  --clip(w.x,w.y,w.w-8,w.h-8)
  
  --display text
  for j = 1,#w.txt do
   local txt=w.txt[i]
   
   --can't print two lines 
   --of text either
   --:(
   
   print(txt.."\n", w.x+2, w.y+2)
   --doesn't move cursor down without 
   --clip,
   --and even then it's not staying 
   --within
   --the bounds of the text box.
   --w.y = w.y + 6
   end
  color(_txtColor)
  --if window duration is not nil, then
  --subtract one from duration until it reaches 0
  --then make the window disappear
  if w.dur ~=nil then
   w.dur = w.dur - 1
   if w.dur == 0 then
     table.remove(window)
   end
  end 
 end
end

--text box that disappears after an 
--amount of time
function showMsg(txt, dur)
 local width=#txt*4+22 
 local w = addWindow(63-width/2,50,width,13,{txt})
 w.dur = dur 
end