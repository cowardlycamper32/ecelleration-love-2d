objectID = 0
colors = {
    black = {
        r = 0,
        g = 0,
        b = 0
    },
    white = {
        r = 1,
        g = 1,
        b = 1
    },
    red = {
        r = 1,
        g = 0,
        b = 0
    }
}
objects = {
    {
        ID = 0,
        reference = "gameWindow",
        name = "Viewport",
        Type = 0,
        Data = {
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
            speed = 0,
            color = colors.black
        }
    }
}

InitialEnemies = {
    ID = 0,
    reference = "enemy01",
    name = "Enemy",
    Type = "elipse",
    Data = {
        position = {
            x = math.random(0, objects[1].Data.size.width - 20 / 2),
            y = math.random(0, objects[1].Data.size.width - 20 / 2)
        },
        size = {
            width = 20 / 2,
            height = 20 / 2
        },
        direction = {
            x = 0,
            y = 0
        },
        speed = 0,
        color = colors.red
    }

}

function addObject(reference, name, Type, drawType, objectData) 
    objectID = objectID + 1
    table.insert(objects, {
        ID = objectID,
        reference = reference,
        name = name,
        Type = Type,
        drawType = drawType,
        Data = objectData
    })
end

function playerInputManager(player)
    if love.keyboard.isDown("w") then
        player.Data.direction.y = player.Data.direction.y - 1
    end
    if love.keyboard.isDown("s") then
        player.Data.direction.y = player.Data.direction.y + 1
    end
    if love.keyboard.isDown("a") then
        player.Data.direction.x = player.Data.direction.x - 1
    end
    if love.keyboard.isDown("d") then
        player.Data.direction.x = player.Data.direction.x + 1
    end
    if player.Data.direction.y > 1 then
        player.Data.direction.y = 1
    end
    if player.Data.direction.y < -1 then
        player.Data.direction.y = -1
    end
    if player.Data.direction.x > 1 then
        player.Data.direction.x = 1
    end
    if player.Data.direction.x < -1 then
        player.Data.direction.x = -1
    end
    if not(love.keyboard.isDown("w")) and not(love.keyboard.isDown("s")) then
        player.Data.direction.y = 0
    end
    if not(love.keyboard.isDown("a")) and not(love.keyboard.isDown("d")) then
        player.Data.direction.x = 0
    end
    local length = math.sqrt(player.Data.direction.x^2 + player.Data.direction.y^2)
    if length > 0 then
        player.Data.direction.x = player.Data.direction.x / length
        player.Data.direction.y = player.Data.direction.y / length
    end
    
end

function move(object, dt) 
    object.Data.position.x = object.Data.position.x + (object.Data.speed * object.Data.direction.x) * dt
    object.Data.position.y = object.Data.position.y + (object.Data.speed * object.Data.direction.y) * dt
end

function boundsCheck(object)
    if object.Data.position.x < 0 then
        object.Data.position.x = 0
        object.Data.direction.x = 0
    elseif object.Data.position.x > objects[2].Data.size.width - object.Data.size.width then
        object.Data.position.x = objects[2].Data.size.width - object.Data.size.width
        object.Data.direction.x = 0
    end
    if object.Data.position.y < 0 then
        object.Data.position.y = 0
        object.Data.direction.y = 0
    elseif object.Data.position.y > objects[2].Data.size.height - object.Data.size.height then
        object.Data.position.y = objects[2].Data.size.height - object.Data.size.height
        object.Data.direction.y = 0
    end
        
end

function updateEnemy(enemy, dt)
    enemy.Data.position.x = enemy.Data.position.x + (enemy.Data.speed * enemy.Data.direction.x) * dt
    enemy.Data.position.y = enemy.Data.position.y + (enemy.Data.speed * enemy.Data.direction.y) * dt
end

function generateEnemy(enemy) 
    
end

function doUpdate(object, dt)
    if object.ID == 0 then
        return
    end
    if object.reference == "Player" then
        playerInputManager(object)
        move(object, dt)
        boundsCheck(object)
    elseif object.reference == "enemies" then
        for _, enemy in pairs(object.Data) do
            updateEnemy(enemy, dt)
        end
    end
        
end

function doDraw(object)
    if object.ID == 0 then
        return
    end
    if not(object.reference == "enemies") then
        love.graphics.setColor(object.Data.color.r, object.Data.color.g, object.Data.color.b)
    else
        for _, enemy in pairs(object) do
            doDraw(enemy)
        end
    end
    if object.Type == "rectangle" then

        love.graphics.rectangle(object.drawType, object.Data.position.x, object.Data.position.y, object.Data.size.width, object.Data.size.width)

    elseif object.Type == "elipse" then
        love.graphics.elipse(object.drawType, object.Data.position.x, object.Data.position.y, object.Data.size.width / 2, object.Data.size.height / 2)
    elseif object.Type == "text" then
        if object.reference == "playerVel" then
            love.graphics.print(objects[2].Data.direction.x .. "," .. objects[2].Data.direction.y, object.Data.position.x, object.Data.position.y)
        end
    end


    love.graphics.setColor(objects[1].Data.color.r, objects[1].Data.color.g, objects[1].Data.color.b)
end

function love.load()
    objects[1].Data.size.width, objects[1].Data.size.height = love.graphics.getDimensions()
    addObject("Player", "Player", "rectangle", "fill", {
        position = {
            x = objects[1].Data.size.width / 2,
            y = objects[1].Data.size.height / 2
        },
        size = {
            width = 20,
            height = 20
        },
        direction = {
            x = 0,
            y = 0
        },
        speed = 1000,
        color = colors.white
    })
    addObject("enemies", "Enemies", "table", 0, {InitialEnemies})
    addObject("playerVel", "Player Velocity thingie", "text" , 0, {
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
        speed = 0,
        color = colors.white
    })
end

function love.draw()
    for _, object in ipairs(objects) do
        doDraw(object)
    end
end 

function love.update(dt)
    for _, object in ipairs(objects) do
        doUpdate(object, dt)
    end
end 