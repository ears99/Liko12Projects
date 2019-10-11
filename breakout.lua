--------------
-- BREAKOUT --
--------------

function _init()
 MODE = "START"
end

function _update()
 if MODE == "GAME" then
   update_game()
 elseif MODE == "START" then
   update_start()
 elseif MODE == "GAMEOVER" then
   update_gameover()
 elseif MODE == "WIN" then
   update_win() 
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
  elseif nextY < 0 then
   ballDeltaY = -ballDeltaY
   SFX(0)
   --if ball goes off the bottom
   --subtract one life and play SFX 2
   --and serve the ball again
  end
  --if ball and paddle collide
  if ballCollide(nextX,nextY,paddleX, paddleY, paddleW, paddleH) then
   SFX(1)
   --make the ball bounce off paddle
   ballDeltaY = -ballDeltaY
   score = score + 1 
  end
   
   local i   
   for i =1,#brickX do           
   --if ball and brick collide
    if brickVisable[i] and ballCollide(nextX,nextY,brickX[i],brickY[i],brickW,brickH) then
     SFX(4)
     --make the ball bounce off brick
     ballDeltaY = -ballDeltaY
     brickVisable[i] = false
     score = score + 10 
    end                 
  end
  
    ballX = nextX
    ballY = nextY    
  
   if nextY > 128 then
   SFX(2)
    lives = lives - 1
    serveBall()         
   end
   if lives < 0 then
    --end the game
    SFX(3)
    MODE="GAMEOVER"
   end                                                                  
end

function update_start()
 clear()
 if btnp(5) then --btn 5 = Z
  startGame()
end

function update_win()
end

function startGame()
 MODE="GAME"
 ballRadius = 3 --ball size

 paddleX = 60   --paddle X pos
 paddleY = 120  --paddle Y pos
 paddleDX = 2   --paddle speed
 paddleW = 30   --paddle width
 paddleH = 4    --paddle height
    
 brickW = 10   --brick width
 brickH = 4    --brick height     
 buildBricks() 
 
 lives=3        --number of lives
 score=0
 serveBall()             
end

function serveBall() 
 ballX = 5      --ball Y pos
 ballY = 33      --ball X pos
 ballDeltaX = 1.2 --ball speed for X
 ballDeltaY = 1.2 --ball speed for Y       
end 

function buildBricks() 
 local i
 brickX = {}
 brickY = {}
 brickVisable = {}
 for i =1,10 do
   table.insert(brickX,5+(i-1)*(brickW+1))
   table.insert(brickY,20)
   table.insert(brickVisable,true)        
 end    
end

function update_gameover()
 if btnp(5) then
 --restart the game
  color(7)
  startGame()
 elseif btnp(7) then
 --return to the main menu
  clear()
  MODE="START"
  end 
end 
 
function _draw()
 if MODE == "START" then
  draw_start()
  elseif MODE == "GAME" then
   draw_game()
  elseif MODE == "GAMEOVER" then
   draw_gameover()
  elseif MODE == "RESET" then
   draw_reset()
  end
end

function draw_start()
 print("BREAKOUT", 70, 50)
 color(11) --sets color of PRESS Z TO START
 print("PRESS Z TO START", 50, 60)
 color(7) --sets color of "BREAKOUT"  
end

function draw_gameover()
 clear(0)
 print("GAME OVER",70,50)
 color(11) --color of PRESS Z TO RESTART and PRESS C TO RETURN
 print("PRESS Z TO RESTART", 50, 60)
 print("PRESS C TO RETURN", 50, 70)
 color(8) --color of GAME OVER 
end

function draw_game()
 clear(1)
 --draw the ball
 circle(ballX,ballY,ballRadius)
 --draw the paddle
 rect(paddleX,paddleY,paddleW,paddleH)


--draw bricks
for i =1,#brickX do
   if brickVisable then 
    rect(brickX[i],brickY[i],brickW,brickH)
   end                
end                        

 

 print("LIVES:"..lives, 1, 1, 128)
 print("SCORE:"..score, 50, 1, 128)    
end

function draw_win()  
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
end
