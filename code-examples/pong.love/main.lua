local key = love.keyboard
local can_play = false

sound_bounce = love.audio.newSource('bounce.wav')
sound_loss = love.audio.newSource('loss.wav')

-- Load some default values for our rectangle.
function love.load()
    big_font = love.graphics.newFont(32)
    score_pos = 10
    score_linePos = 30+32
    score_height = 1
    max_pos = score_linePos + score_height
    p1          = {}
    p1          = spawnPlayer(p1, 0, max_pos)

    width       = 10
    height      = 100

    speed       = 10
    getHeight   = love.graphics.getHeight( ) - height
    getWidth    = love.graphics.getWidth( ) - width

    screenHeight      = love.graphics.getHeight()
    screenWidth       = love.graphics.getWidth()

    p2          = {}
    p2          = spawnPlayer(p2, getWidth, max_pos)

    spawnBall()
end

function spawnPlayer(self, x, y)
    self.score = 0
    self.x = x or 0
    self.y = y or 0
    return self
end

function spawnBall()
    ball={
        math.random(getWidth/2 - getWidth/3, getWidth/2 + getWidth/3),
        math.random(max_pos, getHeight-5)
    }
    ball.w = 10
    ball.h = 10
    ball.speed=math.random(3,5)
    ball.ascension=math.random(-8,8)
    ball.direction = math.random(1,2)
end

-- Draw a coloured rectangle.
function love.draw()
    love.graphics.setColor(255,255,255)
    if can_play == false then
        love.graphics.setFont(big_font)
        love.graphics.printf("Press space to play", 0, screenHeight/2, screenWidth, "center")
    end

    -- draw line division
    love.graphics.rectangle("fill", 0, score_linePos, screenWidth, score_height)

    -- draw players
    -- love.graphics.setColor(0,255,0) -- color green
    love.graphics.rectangle("fill", p1.x, p1.y, width, height) -- player 1
    love.graphics.rectangle("fill", p2.x, p2.y, width, height) -- player 2

    -- draw ball
    if can_play == true then
        love.graphics.setColor(255,255,255)
    else
        love.graphics.setColor(255,255,51)
    end
    love.graphics.rectangle("fill", ball[1], ball[2], ball.w, ball.h)

    -- draw score
    love.graphics.setColor(255,0,0,255)
    --    love.graphics.setFont(big_font)
    love.graphics.printf(p1.score .. " | ".. p2.score, 0, score_pos, screenWidth, "center")
end

-- Increase the size of the rectangle every frame.
function love.update(dt)
    -- we will use awsd for player 1 and arrows for player 2

    if key.isDown("space") and can_play == false then
        can_play = true
    end
    -- keyboard
    -- player 1 controls
    if key.isDown("w") then
        p1.y = p1.y - 1 * speed
        if p1.y < max_pos then p1.y = max_pos end
    elseif key.isDown("s") then
        p1.y = p1.y + 1 + speed
        if p1.y > getHeight then p1.y = getHeight end
    end

    -- player 2 controls
    if key.isDown("up") then
        p2.y = p2.y - 1 * speed
        if p2.y < max_pos then p2.y = max_pos end
    elseif key.isDown("down") then
        p2.y = p2.y + 1 + speed
        if p2.y > getHeight then p2.y = getHeight end
    end

    --joystick

    if can_play == true then
        -- ball movement right
        if ball.direction == 1 then
        ball[1]=ball[1]-ball.speed
        else
        ball[1]=ball[1]+ball.speed
        end
        ball[2]=ball[2]+ball.ascension
    end
    -- Collision detection
    if ball[1] >= screenWidth-20 and ball[2] >= p2.y and ball[2] <= p2.y+45 then
        ball.direction=1
        ball.speed=ball.speed+1
        ball.ascension=math.random(-2,2)
        
        -- play bounce sound
        love.audio.play(sound_bounce)

    elseif ball[1] >= screenWidth-20 and ball[2] >= p2.y+45 and ball[2] <= p2.y+90 then
        ball.direction=1
        ball.speed=ball.speed+1
        ball.ascension=math.random(-2,2)
        -- play bounce sound
        love.audio.play(sound_bounce)

    elseif ball[1] <= 20 and ball[2] >= p1.y+45 and ball[2] <= p1.y+90 then
        ball.direction=2
        ball.speed=ball.speed+1
        -- play bounce sound
        love.audio.play(sound_bounce)

    elseif ball[1] <= 20 and ball[2] >= p1.y and ball[2] <= p1.y+45 then
        ball.direction=2
        ball.speed=ball.speed+1
        -- play bounce sound
        love.audio.play(sound_bounce)

    elseif ball[2] > screenHeight-(ball.h/2) then -- we need collision for borders too
        ball.ascension=ball.ascension*-1
        ball.speed=ball.speed+1
        -- play bounce sound
        love.audio.play(sound_bounce)

    elseif ball[2] < max_pos then -- we need collision for borders too
        ball.ascension=ball.ascension*-1
        ball.speed=ball.speed+1
        -- play bounce sound
        love.audio.play(sound_bounce)

    end

    if ball.speed > 10 then
        ball.speed = 10
    end

    -- score points
    if ball[1] > screenWidth+(ball.w/2) then
      p1.score = p1.score + 1
      -- play loss sound
      love.audio.play(sound_loss)

      can_play = false
      spawnBall ()
    elseif ball[1] < -(ball.w/2) then
      p2.score = p2.score + 1
      -- play loss sound
      love.audio.play(sound_loss)

      can_play = false
      spawnBall ()
    end
end
