---------------
-- ROGUELIKE --
---------------

function _init()
 T = 0 --number of frames
 
 --player animation table
 playerAni = {100,101,102,103}
 
 --directions for x and y
 --left, right, up, down
 dirX = {-1, 1, 0, 0}
 dirY = {0, 0, -1, 1}
 
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
end

function startGame()
 playerX = 6
 playerY = 7
 playerOffsetX = 0
 playerOffsetY = 0
 playerStartOffsetX = 0 
 playerStartOffsetY = 0
 --not flipped by default
 playerFlipped = 1
 aniTimer = 0 
end

-------------------
--UPDATE FUNCTIONS
-------------------
function update_game()
 for i=1,4 do
  if btnp(i) then
    playerX = playerX + dirX[i]
    playerY = playerY + dirY[i]
    playerStartOffsetX = playerOffsetX - dirX[i]*8
    playerStartOffsetY = playerOffsetY - dirY[i]*8
    playerOffsetX = playerStartOffsetX
    playerOffsetY = playerStartOffsetY
    aniTimer=0
    _upd=update_pTurn
    return
  end
 end 
end

--player's turn
function update_pTurn()
--set 0.1 to another value to change player's speed
 aniTimer = min(aniTimer+0.125,1)
 playerOffsetX = playerStartOffsetX * (1-aniTimer)
 playerOffsetY = playerStartOffsetY * (1-aniTimer)
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
 
 -- DEBUGGING
 -------------
 --print("PX:"..playerX, 1, 1, 128)
 --print("PY:"..playerY, 30,1, 128)
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
 return ani[math.floor(T/15)%#ani+1]
end

function drawSprite(_Sprite,_X,_Y,_C, _FLIP)
 palt(0,false)
 pal(6,_C)
 
 --set _FLIP to either 1 or -1
 Sprite(_Sprite,_X,_Y, 0,_FLIP)
 pal()
end

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