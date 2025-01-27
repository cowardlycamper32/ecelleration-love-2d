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
        player.Data.position.y = player.Data.position.y - 1
    end
    if love.keyboard.isDown("s") then
        player.Data.position.y = player.Data.position.y + 1
    end
    if love.keyboard.isDown("a") then
        player.Data.position.x = player.Data.position.x - 1
    end
    if love.keyboard.isDown("d") then
        player.Data.position.x = player.Data.position.x + 1
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
end

function move(object, dt) 
    object.Data.position.x = object.Data.position.x + (object.Data.speed * object.Data.direction.x) * dt
    object.Data.position.y = object.Data.position.y + (object.Data.speed * object.Data.direction.y) * dt
end

function doUpdate(object, dt)
    if object.ID == 0 then
        return
    end
    if object.reference == "Player" then
        playerInputManager(object)
        move(object, dt)
    end
end

function doDraw(object)
    if object.ID == 0 then
        return
    end
    
    love.graphics.setColor(object.Data.color.r, object.Data.color.g, object.Data.color.b)
    
    if object.Type == "rectangle" then
        
        love.graphics.rectangle(object.drawType, object.Data.position.x, object.Data.position.y, object.Data.size.width, object.Data.size.width)
        
    elseif object.Type == "elipse" then
        love.graphics.elipse(object.drawType, object.Data.position.x, object.Data.position.y, object.Data.size.width / 2, object.Data.size.height / 2)
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
        speed = 400,
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