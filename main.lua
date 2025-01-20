--ent = require("ent")
function love.load()
    position = {
        x = 200,
        y = 200
    }
    direction = {
        x = 0,
        y = 0
    }
    wwidth, wheight = love.graphics.getDimensions()
    objectsize = {
        x = 20,
        y = 20
    }
end
function move(dir, pos, speed, dt)
    pos.x = pos.x + (dir.x * speed * dt)
    pos.y = pos.y + (dir.y * speed * dt)
    return pos
end
function love.draw()
    love.graphics.rectangle("fill", position.x, position.y, objectsize.x, objectsize.y)
    love.graphics.print(position.x .. ", " .. position.y)
end 
function offscreen(pos)
    if pos.x < 0 then
        pos.x = 0
    elseif pos.x > (wwidth - objectsize.x) then
        pos.x = (wwidth - objectsize.x)
    end
    if pos.y < 0 then
        pos.y = 0
    elseif pos.y > (wheight - objectsize.y) then
        pos.y = (wheight - objectsize.y)
    end
    return pos
        
        
end
function love.update(dt)
    if love.keyboard.isDown("w") then
        direction.y = direction.y - 1
    end
    if love.keyboard.isDown("s") then
        direction.y = direction.y + 1
    end
    if love.keyboard.isDown("a") then
        direction.x = direction.x - 1
    end
    if love.keyboard.isDown("d") then
        direction.x = direction.x + 1
    end
    if (not (love.keyboard.isDown("w") or love.keyboard.isDown("s"))) and direction.y > 0 then
        direction.y = direction.y - 1
    end
    if (not (love.keyboard.isDown("w") or love.keyboard.isDown("s"))) and direction.y < 0 then
        direction.y = direction.y + 1
    end
    if not (love.keyboard.isDown("a") or  love.keyboard.isDown("d")) and direction.x > 0 then
        direction.x = direction.x - 1
    end
    if not (love.keyboard.isDown("a") or  love.keyboard.isDown("d")) and direction.x < 0 then
        direction.x = direction.x + 1
    end
    
    position = move(direction, position, 10, dt)
    position = offscreen(position)
end 
