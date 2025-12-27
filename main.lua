local debug = false

function love.load()
    player = {}
    player.sprite = love.graphics.newImage('sprites/bird.png')
    player.x = 170
    player.y = 200
    player.width = player.sprite:getWidth()
    player.height = player.sprite:getHeight()
    player.velocity = 0
    player.gravity = 700
    player.jumpStrength = -250

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

    game = {}
    game.state = true
    game.score = 0
    game.pointPassed = false

    font = love.graphics.newFont('fonts/BaiJamjuree-Bold.ttf', 48)
    love.graphics.setFont(font)

    slap_sfx = love.audio.newSource('sounds/slap.wav', 'static')
    woosh_sfx = love.audio.newSource('sounds/woosh.wav', 'static')
    score_sfx = love.audio.newSource('sounds/score.wav', 'static')
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
        game.pointPassed = false
    end
end

function DrawScore()
    -- love.graphics.print automatically chooses a font
    -- love.graphics.printf uses custom formatting
    love.graphics.setColor(0.196, 0.090, 0.020)
    love.graphics.printf(tostring(game.score), 0, 50, 400, "center")
    love.graphics.setColor(1, 1, 1)

end

function DrawStats()
    love.graphics.print(
        "FPS: " .. love.timer.getFPS() ..
        "\nPlayer X: " .. player.x ..
        "\nPlayer Y: " .. player.y ..
        "\nScore: " .. game.score ..
        "\nGame Over: " .. (game.state and "false" or "true"),
        10, 10
    )
end

function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x2 < x1 + w1 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end

function love.keypressed(key)
    if key == "f3" then
        debug = not debug
    end

    if game.state and key == "space" then
        -- load functionality
        player.velocity = player.jumpStrength
        love.audio.play(woosh_sfx)
    end

    if game.state == false and key == "r" then
        game.state = true
        game.score = 0
        game.pointPassed = false
        pipes.x = 800
        pipes.y = love.math.random(64, 350)
        player.y = 200
        player.velocity = 0
    end
end

-- runs every frame
function love.update(dt) -- dt = ~0.0167
    if game.state then
        player.velocity = player.velocity + player.gravity * dt
        player.y = player.y + player.velocity * dt

        background.x = background.x - 80 * dt
        ground.x = ground.x - 200 * dt
        pipes.x = pipes.x - 150 * dt

        -- increase score b/c this is checking for entire pipes obj (top and bottom)
        if player.x >= pipes.x and not game.pointPassed then
            game.score = game.score + 1
            game.pointPassed = true
            love.audio.play(score_sfx)
        end

        if checkCollision(player.x, player.y, player.width, player.height, pipes.x, pipes.y - pipes.height, pipes.width, pipes.height) or checkCollision(player.x, player.y, player.width, player.height, pipes.x, pipes.y + pipes.gap, pipes.width, pipes.height) then
            player.velocity = 0
            game.state = false
            love.audio.play(slap_sfx)
        end

        if player.y + player.height >= ground.y or player.y + player.y <= 0 then
            player.velocity = 0
            game.state = false
            love.audio.play(slap_sfx)
        end

    end
end

-- primary function that draws and runs everything per frame
function love.draw()
    DrawBackground()
    DrawPipe()
    DrawGround()
    DrawPlayer()
    DrawScore()

    if debug then
        DrawStats()
    end
end