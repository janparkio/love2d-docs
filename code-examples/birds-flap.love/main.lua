game_started 				= true
game_slowmo					= false
game_slowmoReduction		= 0.05
game_slowmoDelay			= 1
game_slowmoDelay_counter 	= 0

sound_flaps = {
	love.audio.newSource('flaps1.wav'),
	love.audio.newSource('flaps2.wav')
}

new_dt 					= 0

screen 					= {}
screen.w 				= love.graphics.getWidth()
screen.h 				= love.graphics.getHeight()

pipe 					= {}
pipe.w 					= 54
pipe.h 					= 100
pipe.y1 				= 0
pipe.speed				= 60

pipe_spaceY_min 		= 54
pipe_spaceHeight 		= 100

gravity_pull 			= 520

function love.load()
	if game_started then
		score			= 0
		game_slowmoDelay_counter = 0 -- reset the counter
		bird 			= {}
		bird.x 			= 62
		bird.y 			= 200
		bird.w 			= 30
		bird.h 			= 25
		bird.speed 		= 0
		bird.impulse 	= -165

		bird.height_min = 0
		bird.height_max = screen.h + bird.h/2

		p1				= {}
		p1.x			= screen.w
		p1.y2 			= 100
		p2				= {}
		p2.x			= screen.w + ((screen.w + pipe.w) / 2)
		p2.y2			= 200

		pipe.upComming = 1

		function newPipeY2()
			local pipeY2 = love.math.random(
				pipe_spaceY_min,
				screen.h - pipe_spaceHeight - pipe_spaceY_min
			)

			return pipeY2
		end
	end
end

function love.keypressed(key)
    if game_started then
		if bird.y > bird.height_min then
			bird.speed = -165 -- flapping
			-- play sound_flaps
			love.audio.play(sound_flaps[math.random(1, 2)])
		end
	end

	if game_started == false then
		game_started = true
		love.load()
	end
end

function love.update(dt)

	new_dt = dt

	if game_slowmo and game_slowmoDelay_counter < game_slowmoDelay then
		
		new_dt = new_dt * game_slowmoReduction
		game_slowmoDelay_counter = game_slowmoDelay_counter + 1 * dt
	
	elseif game_slowmo and game_slowmoDelay_counter  >= game_slowmoDelay then
		game_started = false
		game_slowmo = false
	end
	
	if game_started then
		-- if bird.y > bird.height_min then
		bird.speed = bird.speed + (gravity_pull * new_dt)
		bird.y = bird.y + bird.speed * new_dt

		local function movePipe (pipeX, pipeY2)
			pipeX = pipeX - (pipe.speed * new_dt)
			
			if (pipeX + pipe.w) < 0 then
				pipeX = screen.w
				pipeY2 = newPipeY2()
			end

			return pipeX, pipeY2
		end

		local function updateScore (thisPipe, pipeX, otherPipe)
			if pipe.upComming == thisPipe
			and (bird.x > (pipeX + pipe.w)) then
				score = score + 1
				pipe.upComming = otherPipe
			end
		end

		p1.x, p1.y2 = movePipe (p1.x, p1.y2)
		p2.x, p2.y2 = movePipe (p2.x, p2.y2)

		updateScore (1, p1.x, 2)
		updateScore (2, p2.x, 1)
	end
end

function love.draw()
	-- draw brackground
	love.graphics.setColor(35, 92, 118) -- blue laggon color
	love.graphics.rectangle('fill', 0, 0, screen.w, screen.h)

	-- draw bird
	love.graphics.setColor(224, 214, 68) -- manz yellow color
	if bird.y > bird.height_min then
		love.graphics.rectangle('fill', bird.x, bird.y, bird.w, bird.h)
	else
		love.graphics.rectangle('fill', bird.x, bird.height_min, bird.w, bird.h)
	end

	--spawn the group of pipes
    spawnPipes (p1.x, p1.y2)
	spawnPipes (p2.x, p2.y2)

	if collisionCheck (p1.x, p1.y2)
	or collisionCheck (p2.x, p2.y2)
	or bird.y > screen.h then
		game_slowmo = true
	end

	love.graphics.setColor(255,255,255)
	love.graphics.setNewFont(32)
	if game_started == false then
		love.graphics.setColor(0,0,0, 150)
		love.graphics.rectangle('fill', 0, (screen.h/2)-100, screen.w, (screen.h/2)-32)

		love.graphics.setColor(252,0,10)
		love.graphics.setNewFont(20)
		love.graphics.printf("Score", 0, (screen.h/2)-90, screen.w, "center")
		love.graphics.setNewFont(32)
		love.graphics.setColor(255,255,255)
		love.graphics.printf("Press Any Button to Start Again", 0, (screen.h/2)-12, screen.w, "center")
		love.graphics.setColor(252,0,10)
	end

	love.graphics.printf(score, 0, (screen.h/2)-70, screen.w, "center")
end

function spawnPipes (x, y2)
	love.graphics.setColor(94, 201, 72) --dull lime color
	drawPipe(x, 0, pipe.w, y2)
	drawPipe(x, y2+pipe_spaceHeight, pipe.w, screen.h - y2 - pipe_spaceHeight)
end

function drawPipe (x, y, w, h)
	local rect = love.graphics.rectangle(
		'fill',
		x,
		y,
		w,
		h
	)
	return rect
end

function collisionCheck (pipeX, pipeY2)
	love.graphics.setColor(255,255,255)
	return
	(
		-- left edge of the bird is to the left of the right edge of the pipe
		bird.x < (pipeX + pipe.w)
		-- right edge of bird is to the right of the left edge of pipe
		and (bird.x + bird.w) > pipeX
		-- top edge of bird is above the bottom edge of first pipe segment
		and ((bird.y < pipeY2)
		or (bird.y + bird.h) > (pipeY2 + pipe_spaceHeight))
	)
end