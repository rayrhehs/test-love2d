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

    background = love.graphics.newImage('sprites/day-background.png')
end

function DrawPlayer()
    love.graphics.draw(player.sprite, player.x, player.y)
end

function DrawBackground()
    love.graphics.draw(background, 0, 0)
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
end

-- primary function that draws everything
function love.draw()
    DrawBackground()
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