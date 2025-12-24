local debug = true

function love.load()
    player = {}
    player.x = 170
    player.y = 200
    player.speed = 3
    player.velocity = 0
    player.gravity = 500
    player.jumpStrength = -300
    player.sprite = love.graphics.newImage('sprites/bird.png')

    background = {}
    background.x = 0
    background.y = 0
    background.width = 400
    background.height = 600
    background.sprite = love.graphics.newImage('sprites/day-background.png')

    ground = {}
    ground.x = 0
    ground.y = background.height - 64
    ground.width = 400
    ground.height = 64
    ground.sprite = love.graphics.newImage('sprites/ground.png')

    pipes = {}
    pipes.x = 800
    pipes.y = love.math.random(64, 350)
    pipes.width = 78
    pipes.height = 360
    pipes.gap = 125
    pipes.sprite = {}
    pipes.sprite.pipe_up = love.graphics.newImage('sprites/pipe_up.png')
    pipes.sprite.pipe_down = love.graphics.newImage('sprites/pipe_down.png')
end

function DrawPlayer()
    love.graphics.draw(player.sprite, player.x, player.y)
end

function DrawBackground()
    love.graphics.draw(background.sprite, background.x, 0) -- background 1
    love.graphics.draw(background.sprite, background.x + background.width, 0) -- background 2 placed ahead of background width

    if background.x <= -background.width then
        background.x = 0
    end
end

function DrawGround()
    love.graphics.draw(ground.sprite, ground.x, ground.y)
    love.graphics.draw(ground.sprite, ground.x + ground.width, ground.y)

    if ground.x <= -ground.width then
        ground.x = 0
    end
end

function DrawPipe()
    love.graphics.draw(pipes.sprite.pipe_up, pipes.x, 0 - pipes.height + pipes.y)
    love.graphics.draw(pipes.sprite.pipe_down, pipes.x, pipes.y + pipes.gap)

    if pipes.x <= -pipes.width then
        pipes.x = 400
        pipes.y = love.math.random(64, 350)
    end
end


function love.keypressed(key)
    if key == "f3" then
        debug = not debug
    end

    if key == "space" then
        -- load functionality
        player.velocity = player.jumpStrength
    end
end

-- runs every frame
function love.update(dt) -- dt = ~0.0167
    player.velocity = player.velocity + player.gravity * dt
    player.y = player.y + player.velocity * dt

    background.x = background.x - 80 * dt
    ground.x = ground.x - 200 * dt
    pipes.x = pipes.x - 150 * dt
end

-- primary function that draws everything
function love.draw()
    DrawBackground()
    DrawPipe()
    DrawGround()
    DrawPlayer()

    if debug then
        love.graphics.print(
            "FPS: " .. love.timer.getFPS() ..
            "\nPlayer X: " .. player.x ..
            "\nPlayer Y: " .. player.y,
            10, 10
        )
    end
end