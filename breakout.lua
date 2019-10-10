--------------
-- BREAKOUT --
--------------

function _init()
 ballX = 1      --ball Y pos
 ballY = 1      --ball X pos
 ballDeltaX = 1.5 --ball speed for X
 ballDeltaY = 1.5 --ball speed for Y
 ballRadius = 3 --ball size

 paddleX = 30   --paddle X pos
 paddleY = 120  --paddle Y pos
 paddleDX = 2   --paddle speed
 paddleW = 30   --paddle width
 paddleH = 4    --paddle heihgt
 
 MODE = "START"
end

function _update60()
 if MODE == "GAME" then
   update_game()
 elseif MODE == "START" then
   update_start()
 elseif MODE == "GAMEOVER" then
   update_gameover()
  end            
end


 
function update_game()
 local nextX,nextY
 
--check for button presses
 if btnp(1) then --left arrow
  paddleX = paddleX - 5
  paddleDX = paddleDX -5
 elseif btnp(2) then --right arrow
  paddleX = paddleX + 5
  paddleDX = paddleDX + 5
 end

  nextX = ballX + ballDeltaX
  nextY = ballY + ballDeltaY  
 
 --bounce the ball off 
 --the screen edges (192x128 screen) 
 if nextX > 192 or nextX < 0 then
   ballDeltaX = -ballDeltaX
   SFX(0) --play the SFX
  elseif nextY > 128 or nextY < 0 then
   ballDeltaY = -ballDeltaY
   SFX(0)
  end
  
  --if ball and paddle collide
  if ballCollide(nextX,nextY,paddleX, paddleY, paddleW, paddleH) then
   --change the color to red
   color(8)
   SFX(1)
   --make the ball bounce off paddle
   ballDeltaY = -ballDeltaY 
  else
  --if ball hasn't hit paddle
  --change color back to white
  color(7)
  end
  ballX = nextX
  ballY = nextY                                                                      
end

function update_start()
 clear(1)
end

function update_gameover()
end 
 
function _draw()
 if MODE == "START" then
  draw_start()
  elseif MODE == "GAME" then
   draw_game()
  elseif MODE == "GAMEOVER" then
   draw_gameover()
   end
end

------------------------
--POSSIBLE ERROR HERE?--
------------------------
function draw_start()
 clear(1)
 print("BREAKOUT") 
end

function draw_gameover()
 clear(1) 
end

function draw_game()
 clear(1)
 --draw the ball
 circle(ballX,ballY,ballRadius)
 --draw the paddle
 rect(paddleX,paddleY,paddleW,paddleH)    
end


--check ball collision with rect
function ballCollide(BX,BY, boxX, boxY, boxW, boxH)
 if BY - ballRadius > boxY + boxH then
  return false 
 end
 if BY + ballRadius < boxY then
  return false 
 end
 if BX - ballRadius > boxX + boxW then
  return false 
 end
 if BX + ballRadius < boxX then
  return false
 end         
  return true
end

function deflectBall(bX,bY,bDX,bdY,tX,tY,tW,tH)
 --deflect horizontally or vertically
 --when the ball hits a box?
 if bDX == 0 then
  --vertically
  return false
 elseif bDY == 0 then
 --horizontally
 return true 
 else
 --moving diagonally, calc slope
 local slp = bDY / bDX
 local cX, cY

 --check variants
-------------------
 
 --quadrant 1
 if slp > 0 and bDX > 0 then
  --moving down-right
  cX = tX-bX
  cY = tY-bY
  if cX <= 0 then
   return false
  elseif cY/cX < slp then
   return true
   else
  return false 
 end
 
 --quadrant 2
 elseif slp < 0 and bDX > 0 then
 --moving up-right 
 cX = tX-bX
 cY = tY+tH-bY
 if cX<=0 then
 return false
 else
 return true
end

--quadrant 3
elseif slp > 0 and bDX < 0 then
--moving up-left
cX = tX+tW-bX
cY = tY+tH-bY
if cX >= 0 then
 return false
 elseif cY/cX > slp then
  return false
  else
  return true
 end
 else
 --quadrant 4
 --moving left-down
 cX = tX+tW-bX
 cY = tY-bY
 if cX>= 0 then
  return false
  elseif cY/cX < slp then
   return false
   else
   return true
   end
 return false
  end
 end
 end
