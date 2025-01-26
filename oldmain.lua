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
triggers = {}


function flash(flash)
    if flash then
        love.graphics.setColor(0,0,0)
    else
        love.graphics.setColor(1,1,1)
    end
end
function triggerPlacement(x, y, width, height, linked) 
    linked = linked or 0
    table.insert(triggers, {
        x = x,
        y = y,
        width = width,
        height = height,
        link = linked
    })
end
function debugtriggers(trigger) 
    love.graphics.setColor(124,252,0)
    love.graphics.rectangle("fill", trigger.x, trigger.y, trigger.width, trigger.height)
    love.graphics.setColor(1,1,1)
end

function triggercheck(trigger, player)
    if (player.position.x > trigger.x and player.position.x < (trigger.x + trigger.width)) and (player.position.y > trigger.y and  player.position.y < (trigger.y + trigger.height)) then
        
    end
end

    
function createenemy(vp)
    size = math.random(10, 30)
    
    return {
        position = {
            x = math.random(0, vp.width - (size / 2)),
            y = math.random(0, vp.height - (size / 2))
        },
        size = {
            width = size,
            height = size
        },
        direction = {
            x = math.random(-1, 1),
            y = math.random(-1, 1)
        },
        speed = math.random(5, 20),
        dt = 0,
        damageDone = 0,
        speedloops = 0,
        dirloops = 0
    }
end

enemies = {
}
function initenemy(vp) 
    numofenemies = math.random(1, 20)
    for i = 1, numofenemies do
        local newEnemy = createenemy(vp)
        table.insert(enemies, newEnemy)
    end
end
    

function drawenemy(enemy)
    love.graphics.setColor(1, 0, 0)
    love.graphics.ellipse("fill", enemy.position.x, enemy.position.y, enemy.size.width / 2, enemy.size.width / 2)
    love.graphics.setColor(1, 1, 1)
    enemy.position.x = enemy.position.x + (enemy.direction.x * enemy.speed * enemy.dt)
    enemy.position.y = enemy.position.y + (enemy.direction.y * enemy.speed * enemy.dt)
    enemy.position, enemy.direction = offscreen(enemy.position, enemy.direction, enemy.size.width, enemy.size.height)
    if enemy.dirloops > 99 then
        enemy.dirloops = 99
    end
    if math.random(1, 200 - enemy.dirloops) == 1 then
        enemy.direction.x = math.random(-1, 1)
        enemy.direction.y = math.random(-1, 1)
        enemy.dirloops = enemy.dirloops + 1
    end
    if enemy.speedloops > 49 then
        enemy.speedloops = 49
    end
    if math.random(1, 50 - enemy.speedloops) == 1 then
        if enemy.speed > 100 then
            enemy.speed = 100
        end
        enemy.speed = enemy.speed + 1
        enemy.speedloops = enemy.speedloops + 1
    end
    
end
setmetatable(player, {__index = entity})
function entity.init(self, position, size)
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
    veiwport = {
        width = wwidth,
        height = wheight
    }
    center = {
        x = wwidth / 2,
        y = wheight / 2
    }
    initenemy(veiwport)
    triggerPlacement(50, 50, 30, 10)
    flasher = {
        x = 0,
        y = 0,
        width = veiwport.width,
        height = veiwport.height,
        flash = false
    }
end
function love.draw()
    for _, trigger in ipairs(triggers) do
        debugtriggers(trigger)
    end
    love.graphics.print(player.position.x .. ", " .. player.position.y)
    love.graphics.print(player.direction.x .. ", " .. player.direction.y, 0, 20)
    love.graphics.print("use WASD to move the cube", center.x, center.y)
    love.graphics.rectangle("fill", player.position.x, player.position.y, player.size.width, player.size.height)
    for _, enemy in ipairs(enemies) do
        drawenemy(enemy)
    end
    if flasher.flash then
        flash(true)
        flasher.flash = false
        flash(false)
    end
    love.graphics.rectangle("fill", flasher.x, flasher.y, flasher.width, flasher.height)
end 
function offscreen(pos, dir, sizew, sizeh)
    if pos.x < 0 then
        pos.x = 0
        dir.x = 0
    elseif pos.x > (wwidth - sizew) then
        pos.x = (wwidth - sizew)
        dir.x = 0
    end
    if pos.y < 0 then
        pos.y = 0
        dir.y = 0
    elseif pos.y > (wheight - sizeh) then
        pos.y = (wheight - sizeh)
        dir.y = 0
    end
    return pos, dir
end
function love.update(dt)
    if love.keyboard.isDown("w") then
        player.direction.y = player.direction.y - 1
    elseif love.keyboard.isDown("w") and player.direction.y < 0 and not love.keyboard.isDown("s") then
        player.direction.y = player.direction.y - 5
    end
    if love.keyboard.isDown("s") then
        player.direction.y = player.direction.y + 1
    elseif love.keyboard.isDown("s") and player.direction.y > 0 and not love.keyboard.isDown("w") then
        player.direction.y = player.direction.y + 5
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

    for _, trigger in ipairs(triggers) do
        if (player.position.x > trigger.x and player.position.x < (trigger.x + trigger.width)) and (player.position.y > trigger.y and  player.position.y < (trigger.y - trigger.height)) then
            flash()
        end
    end
        
    
    for _, enemy in  ipairs(enemies) do
        enemy.dt = dt
        enemy.position, enemy.direction = offscreen(enemy.position, enemy.direction, enemy.size.width / 2, enemy.size.height / 2)
    end
    if math.random(1,10) then
        
    end
    player:move(20, dt)
    player.position, player.direction = offscreen(player.position, player.direction, player.size.width, player.size.height)
end 
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "space" then
        table.insert(enemies, createenemy(veiwport))
    end
end 