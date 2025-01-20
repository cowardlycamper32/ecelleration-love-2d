--ent = require("ent")
entity = {
    position = {
        x = 0,
        y = 0
    },
    direction = {
        x = 0,
        y = 0
    },
    size = {
        width = 0,
        height = 0
    }
}
player = {
    position = {
        x = 200,
        y = 200
    },
    direction = {
        x = 0,
        y = 0
    },

    size = {
        width = 20,
        height = 20
    },
    health = 100
}
enemy = {
    position = {
        x = 0,
        y = 0
    },
    size = {
        width = 0,
        height = 0
    },
    direction = {
        x = 0,
        y = 0
    },
    damageDone = 0
}
function enemy.init(self, position, size)
    self.position = position
    self.size = size
    self.direction = {
        x = math.random(-1, 1),
        y = math.random(-1, 1)
    }
end
function entity:move(speed, dt)
    self.position.x = self.position.x + (self.direction.x * speed * dt)
    self.position.y = self.position.y + (self.direction.y * speed * dt)
end

function love.load()
    wwidth, wheight = love.graphics.getDimensions()
end
function love.draw()
    love.graphics.rectangle("fill", player.position.x, player.position.y, player.size.width, player.size.height)
    love.graphics.print(player.position.x .. ", " .. player.position.y)
    love.graphics.print(player.direction.x .. ", " .. player.direction.y, 0, 20)
end 
function offscreen(pos, dir)
    if pos.x < 0 then
        pos.x = 0
        dir.x = 0
    elseif pos.x > (wwidth - player.size.width) then
        pos.x = (wwidth - player.size.width)
        dir.x = 0
    end
    if pos.y < 0 then
        pos.y = 0
        dir.y = 0
    elseif pos.y > (wheight - player.size.height) then
        pos.y = (wheight - player.size.height)
        dir.y = 0
    end
    return pos, dir
        
        
end
function love.update(dt)
    if love.keyboard.isDown("w") then
        player.direction.y = player.direction.y - 1
    end
    if love.keyboard.isDown("s") then
        player.direction.y = player.direction.y + 1
    end
    if love.keyboard.isDown("a") then
        player.direction.x = player.direction.x - 1
    end
    if love.keyboard.isDown("d") then
        player.direction.x = player.direction.x + 1
    end
    if (not (love.keyboard.isDown("w") or love.keyboard.isDown("s"))) and player.direction.y > 0 then
        player.direction.y = player.direction.y - 1
    end
    if (not (love.keyboard.isDown("w") or love.keyboard.isDown("s"))) and player.direction.y < 0 then
        player.direction.y = player.direction.y + 1
    end
    if not (love.keyboard.isDown("a") or  love.keyboard.isDown("d")) and player.direction.x > 0 then
        player.direction.x = player.direction.x - 1
    end
    if not (love.keyboard.isDown("a") or  love.keyboard.isDown("d")) and player.direction.x < 0 then
        player.direction.x = player.direction.x + 1
    end
    
    player:move(20, dt) -- for some reason this line of code causes an error. why??
    

    player.position, player.direction = offscreen(player.position, player.direction)
end 
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end 