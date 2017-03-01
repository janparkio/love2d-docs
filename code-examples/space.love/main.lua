love.graphics.setDefaultFilter('nearest', 'nearest')
enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}
enemies_controller.image = love.graphics.newImage("images/enemy.png")
background_image = love.graphics.newImage("images/background.png")

particle_systems = {}
particle_systems.list = {}
particle_systems.image = love.graphics.newImage("images/particle.png")

function love.load()
  local background_music = love.audio.newSource("sound/space.mp3")
  background_music:setLooping(true)
  game_over = false
  game_win = false
  love.audio.play (background_music)
	-- generate player variables
	player = {}
	player.speed = 2
	player.width = 16
	player.height = 16
	player.x = 0
	player.y = 138
	player.bullets = {}
	player.bullet_cooldown = 20
	player.bullet_cooldown_counter = 0
	player.image = love.graphics.newImage("images/player.png")
	player.hit_sound = love.audio.newSource("sound/hit.ogg")
	player.fire = function()
		if player.bullet_cooldown_counter <= 0 and game_win == false then
      if (game_over == false) then
        love.audio.play(player.hit_sound)
        player.bullet_cooldown_counter = player.bullet_cooldown
        bullet = {}
        bullet.width = 6
        bullet.height = 6
        bullet.offset = bullet.width / 2
        bullet.speed = 4
        bullet.image = love.graphics.newImage("images/bullet.png")
        bullet.x = player.x + (player.width/2) - (bullet.width/2)
        bullet.y = player.y
        -- instanciate a player bullet
        table.insert( player.bullets, bullet)
      end
		end
	end
	-- create enemy's variables
	
  for i=0, 10 do
    enemies_controller:spawnEnemy(i*16, 0)
  end
end

function particle_systems:spawn(x ,y)
	local particles = {}
	particles.x = x
  particles.y = y
  particles.ps = love.graphics.newParticleSystem(particle_systems.image, 32)
	particles.ps:setParticleLifetime(2, 4)
	particles.ps:setEmissionRate(5)
	particles.ps:setSizeVariation(1)
	particles.ps:setLinearAcceleration(-20, -20, 20, 20)
	particles.ps:setColors(255, 255, 255, 255)
  table.insert(particle_systems.list, particles)
end

function particle_systems:draw()
  for _,v in pairs(particle_systems.list) do
    love.graphics.draw (v.ps, v.x, v.y)
  end
end

function particle_systems:update(dt)
  for _,v in pairs(particle_systems.list) do
    v.ps:update(dt)
  end
end

function particle_systems:cleanup()
  -- delete particle systsems after a length of time...
end

function checkCollisions(enemies, bullets)
	for i,e in ipairs(enemies) do
		for _,b in pairs(bullets) do
			if (b.y <= e.y + e.height) and (b.x > e.x) and (b.x < e.x + e.width) then
				particle_systems:spawn(e.x, e.y)
        table.remove(enemies, i)
			end
		end
	end

end

function enemies_controller:spawnEnemy(x, y)
	enemy = {}
	enemy.speed = 0.1
	enemy.x = x
	enemy.y = y
	enemy.width = 16
	enemy.height = 16
	enemy.bullets = {}
	enemy.bullet_cooldown = 20
	enemy.bullet_cooldown_counter = 0
	table.insert(self.enemies, enemy)
end

function enemy:fire()
	if self.bullet_cooldown_counter <= 0 then
		self.bullet_cooldown_counter = self.bullet_cooldown
		bullet = {}
		bullet.width = 6
		bullet.height = 6
    	bullet.speed = 4
		bullet.x = player.x + (self.width/2) - (bullet.width/2)
		bullet.y = player.y
		-- instanciate a player bullet
		table.insert( self.bullets, bullet)
	end
end

function love.update(dt)
	-- initialize the cooldown of the bullet instanciation
	player.bullet_cooldown_counter = player.bullet_cooldown_counter - 1
	
	if love.keyboard.isDown("right") then
		player.x = player.x + player.speed
	elseif love.keyboard.isDown("left") then
		player.x = player.x - player.speed
	end

	if love.keyboard.isDown("space") then
		player.fire()
	end

	for _,e in pairs(enemies_controller.enemies) do
		if e.y >= love.graphics.getHeight()/4 then
        game_over = true
    end
    e.y = e.y + e.speed
	end

	for i,b in ipairs(player.bullets) do
		if b.y < -10 then
			-- remove a player bullet if it's off the screen
			table.remove (player.bullets, i)
		end
		b.y = b.y - b.speed
	end
  
  if #enemies_controller.enemies == 0 then
    game_win = true
  end

	checkCollisions(enemies_controller.enemies, player.bullets)
end

function love.draw()
	love.graphics.scale(4)
	love.graphics.draw(background_image, 0, 0)
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(player.image, player.x, player.y, 0)

	for _,e in pairs (enemies_controller.enemies) do
		love.graphics.draw(enemies_controller.image, e.x, e.y, 0)
	end
  
  if game_over then
    love.graphics.print ("Game Over!")
    return
  elseif game_win then
    love.graphics.print ("You won!")
    return
  end
  
	for _,b in pairs (player.bullets) do
		love.graphics.draw(bullet.image, b.x, b.  y, 0)
	end

end
