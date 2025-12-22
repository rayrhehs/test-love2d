local debug = true

function love.load()
    player = {}
    player.x = 370
    player.y = 200
    player.speed = 3
    player.velocity = 5
end

function DrawPlayer()
    love.graphics.rectangle("fill", player.x, player.y, 50, 50)
end

-- function 
function love.keypressed(key)
    if key == "f3" then
        debug = not debug
    end

    if key == "space" then
        -- load functionality
        player.y = player.y - 120
    end

end

function love.update(dt)
    player.y = player.y + player.velocity
end

-- primary function that draws everything
function love.draw()
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