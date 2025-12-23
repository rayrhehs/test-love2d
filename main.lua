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
    background.sprite = love.graphics.newImage('sprites/day-background.png')
    background.x = 0
    background.y = 0
    background.width = 400
    background.height = 600

    ground = {}
    ground.x = 0
    ground.y = background.height - 64
    ground.width = 400
    ground.height = 64
    ground.sprite = love.graphics.newImage('sprites/ground.png')
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


function love.keypressed(key)
    if key == "f3" then
        debug = not debug
    end

    if key == "space" then
        -- load functionality
        player.velocity = player.jumpStrength
    end
end

function love.update(dt) -- 0.0167
    player.velocity = player.velocity + player.gravity * dt
    player.y = player.y + player.velocity * dt

    background.x = background.x - 80 * dt
    ground.x = ground.x - 120 * dt
end

-- primary function that draws everything
function love.draw()
    DrawBackground()
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