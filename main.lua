staticObjectID = 0
controllableObjectID = 1
movingObjectID = 1
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
    },
    green = {
        r = 0,
        g = 1,
        b = 0
    },
    blue = {
        r = 0,
        g = 0,
        b = 1
    }
}
StaticObjects = {
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
ControllableObjects = {}
MovingObjects = {}

enemyStateText = "neutral"



function playerEnemyColCheck(CObject, MObject)
    if not(pcall(StaticObjects[5])) then
        return
    end

    if CObject.Data.position.x < MObject.Data.position.x - MObject.Data.size.width / 2 + MObject.Data.size.width and
            MObject.Data.position.x - MObject.Data.size.height / 2 < CObject.Data.position.x + CObject.Data.size.width and
            CObject.Data.position.y < MObject.Data.position.y - MObject.Data.size.height / 2 + MObject.Data.size.height and
            MObject.Data.position.y - MObject.Data.size.height / 2 < CObject.Data.position.y + CObject.Data.size.height then
        StaticObjects[5].Data.contents = MObject.name .. " is colliding with " .. CObject.name
    else
        StaticObjects[5].Data.contents = "Nothing is colliding"
    end
end

function addStaticObject(reference, name, Type, drawType, objectData)
    staticObjectID = staticObjectID + 1
    table.insert(StaticObjects, {
        ID = StaticObjectID,
        reference = reference,
        name = name,
        Type = Type,
        drawType = drawType,
        Data = objectData
    })
end

function addControllableObject(reference, name, Type, drawType, objectData)
    controllableObjectID = controllableObjectID + 1
    table.insert(ControllableObjects, {
        ID = controllableObjectID,
        reference = reference,
        name = name,
        Type = Type,
        drawType = drawType,
        Data = objectData
    })
end

function addMovingObject(reference, name, Type, drawType, objectData)
    movingObjectID = movingObjectID + 1
    table.insert(MovingObjects, {
        ID = movingObjectID,
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
    if love.keyboard.isDown("w") and love.keyboard.isDown("s") then
        player.Data.direction.y = 0
    end
    if love.keyboard.isDown("a") and love.keyboard.isDown("d") then
        player.Data.direction.x = 0
    end
    fixRandomAcceleration(player)
    if not(love.keyboard.isDown("w")) and not(love.keyboard.isDown("s")) then
        player.Data.direction.y = 0
    end
    if not(love.keyboard.isDown("a")) and not(love.keyboard.isDown("d")) then
        player.Data.direction.x = 0
    end
    fixVectors(player)
    
end

function fixVectors(object)
    local length = math.sqrt(object.Data.direction.x^2 + object.Data.direction.y^2)
    if length > 0 then
        object.Data.direction.x = object.Data.direction.x / length
        object.Data.direction.y = object.Data.direction.y / length
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
    elseif object.Data.position.x > StaticObjects[1].Data.size.width - object.Data.size.width then
        object.Data.position.x = StaticObjects[1].Data.size.width - object.Data.size.width
        object.Data.direction.x = 0
    end
    if object.Data.position.y < 0 then
        object.Data.position.y = 0
        object.Data.direction.y = 0
    elseif object.Data.position.y > StaticObjects[1].Data.size.height - object.Data.size.height then
        object.Data.position.y = StaticObjects[1].Data.size.height - object.Data.size.height
        object.Data.direction.y = 0
    end
        
end

function fixRandomAcceleration(object)
    if object.Data.direction.x > 1 then
        object.Data.direction.x = 1
    elseif object.Data.direction.x < -1 then
        object.Data.direction.x = -1
    end
    if object.Data.direction.y > 1 then
        object.Data.direction.y = 1
    elseif object.Data.direction.y < -1 then
        object.Data.direction.y = -1
    end
end
xValue = 50
yValue = 50
resetValue = 200
honeValue = 1
function updateEnemy(enemy)
    if math.random(1, xValue) == 50 then
        x1 = math.random(-1, 1)
        enemy.Data.direction.x = x1
        if pcall(StaticObjects[3]) then
            StaticObjects[3].Data.contents = "x - moving " .. x1
        end
    end
    if math.random(1, yValue) == 50 then
        y1 = math.random(-1, 1)
        enemy.Data.direction.y = y1
        if pcall(StaticObjects[4]) then
            StaticObjects[4].Data.contents = "y - moving " .. y1
        end
    end
    if math.random(1, resetValue) == 200 then
        enemy.Data.direction.x = 0
        enemy.Data.direction.y = 0
        if pcall(StaticObjects[3]) then
            StaticObjects[3].Data.contents = "x - neutral"
        end
        if pcall(StaticObjects[4]) then
            StaticObjects[4].Data.contents = "y - neutral"
        end
    end
    if math.random(honeValue, 1000) == 1000 then
        honeValue = 1000
        if pcall(StaticObjects[3]) then
            StaticObjects[3].Data.contents = "x - HONE"
        end
        if pcall(StaticObjects[4]) then
            StaticObjects[4].Data.contents = "y - HONE"
        end
        xValue = 1
        yValue = 1
        resetValue = 1
        if enemy.Data.position.x - enemy.Data.size.width / 2 > ControllableObjects[1].Data.position.x then
            enemy.Data.direction.x = enemy.Data.direction.x - 1
        elseif enemy.Data.position.x - enemy.Data.size.width / 2 < ControllableObjects[1].Data.position.x then
            enemy.Data.direction.x = enemy.Data.direction.x + 1
        elseif enemy.Data.position.x - enemy.Data.size.width / 2 == ControllableObjects[1].Data.position.x then
            enemy.Data.direction.x = 0
        end
        if enemy.Data.position.y - enemy.Data.size.height / 2 > ControllableObjects[1].Data.position.y then
            enemy.Data.direction.y = enemy.Data.direction.y - 1
        elseif enemy.Data.position.y - enemy.Data.size.height / 2 < ControllableObjects[1].Data.position.y then
            enemy.Data.direction.y = enemy.Data.direction.y + 1
        elseif enemy.Data.position.y - enemy.Data.size.height / 2 == ControllableObjects[1].Data.position.y then
            enemy.Data.direction.y = 0
        end
    end
    fixRandomAcceleration(enemy)
    fixVectors(enemy)
end

function doUpdate(object, dt) -- WTF DOES THIS DOOO?????
    if object.ID == 0 then
        return
    end
        
end

function doDraw(object)
    if object.ID == 0 then
        return
    end
    if object.visible == True then
        love.graphics.setColor(object.Data.color.r, object.Data.color.g, object.Data.color.b)
    elseif object.visible == False then
        love.graphics.setColor(StaticObjects[1].Data.color.r, StaticObjects[1].Data.color.g, StaticObjects[1].Data.color.b)
    else
        love.event.quit()
    end
    if object.Type == "rectangle" then

        love.graphics.rectangle(object.drawType, object.Data.position.x, object.Data.position.y, object.Data.size.width, object.Data.size.width)

    elseif object.Type == "ellipse" then
        love.graphics.ellipse(object.drawType, object.Data.position.x, object.Data.position.y, object.Data.size.width / 2, object.Data.size.height / 2)
    elseif object.Type == "text" then
        if object.reference == "playerVel" then
            love.graphics.print(ControllableObjects[1].Data.direction.x .. "," .. ControllableObjects[1].Data.direction.y, object.Data.position.x, object.Data.position.y)
        else
            love.graphics.print(object.Data.contents, object.Data.position.x, object.Data.position.y)
        end

    end


    love.graphics.setColor(StaticObjects[1].Data.color.r, StaticObjects[1].Data.color.g, StaticObjects[1].Data.color.b)
end

function love.load()
    StaticObjects[1].Data.size.width, StaticObjects[1].Data.size.height = love.graphics.getDimensions()
    addControllableObject("Player", "Player", "rectangle", "fill", {
        position = {
            x = StaticObjects[1].Data.size.width / 2,
            y = StaticObjects[1].Data.size.height / 2
        },
        size = {
            width = 20,
            height = 20
        },
        direction = {
            x = 0,
            y = 0
        },
        speed = 100,
        color = colors.white,
        visible = True
    })
    addMovingObject("enemy01", "Enemy#1", "ellipse", "fill", {
        position = {
            x = math.random(0, StaticObjects[1].Data.size.width - 20),
            y = math.random(0, StaticObjects[1].Data.size.height - 20)
        },
        size = {
            width = 20,
            height = 20
        },
        direction = {
            x = 0,
            y = 0
        },
        speed = 20,
        color = colors.red,
        visible = True
    })
    addMovingObject("enemy02", "Enemy#2", "ellipse", "fill", {
        position = {
            x = math.random(0, StaticObjects[1].Data.size.width - 20),
            y = math.random(0, StaticObjects[1].Data.size.height - 20)
        },
        size = {
            width = 20,
            height = 20
        },
        direction = {
            x = 0,
            y = 0
        },
        speed = 20,
        color = colors.red,
        visible = True
    })
end

function love.draw()
    for _, object in ipairs(StaticObjects) do
        doDraw(object)
    end
    for _, object in ipairs(ControllableObjects) do
        doDraw(object)
    end
    for _, object in ipairs(MovingObjects) do
        doDraw(object)
    end
end 

function love.update(dt)
    for _, object in ipairs(StaticObjects) do
        doUpdate(object, dt)
    end
    for _, object in ipairs(ControllableObjects) do
        playerInputManager(object)
        doUpdate(object, dt)
        move(object, dt)
        boundsCheck(object)
        for _, moving in ipairs(MovingObjects) do
            playerEnemyColCheck(object, moving)
        end
    end
    for _, object in ipairs(MovingObjects) do
        doUpdate(object, dt)
        updateEnemy(object)
        move(object, dt)
        boundsCheck(object)

    end
end
correctKeys = 0

function DebugON()
    DebugMode = True
    addStaticObject("playerVel", "Player Velocity thingie", "text" , 0, {
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
        color = colors.white,
        visible = True
    })
    addStaticObject("enemyStateX", "Enemy State X Display", "text", 0, {
        position = {
            x = StaticObjects[1].Data.size.width / 2 - 70,
            y = StaticObjects[1].Data.size.width / 2
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
        color = colors.white,
        contents = "y - neutral",
        visible = True
    })
    addStaticObject("enemyStateY", "Enemy State Y Display", "text", 0, {
        position = {
            x = StaticObjects[1].Data.size.width / 2 + 60,
            y = StaticObjects[1].Data.size.width / 2
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
        color = colors.white,
        contents = "x - neutral",
        visible = True
    })
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "up" or correctKeys == 1 then
        if correctKeys == 0 then
            correctKeys = correctKeys + 1
        end
        if key == "up" or correctKeys == 2 then
            if correctKeys == 1 then
                correctKeys = correctKeys + 1
            end
            if key == "down" or correctKeys == 3 then
                if correctKeys == 2 then
                    correctKeys = correctKeys + 1
                end
                if key == "down" or correctKeys == 4 then
                    if correctKeys == 3 then
                        correctKeys = correctKeys + 1
                    end
                    if key == "left" or correctKeys == 5 then
                        if correctKeys == 4 then
                            correctKeys = correctKeys + 1
                        end
                        if key == "right" or correctKeys == 6 then
                            if correctKeys == 5 then
                                correctKeys = correctKeys + 1
                            end
                            if key == "left" or correctKeys == 7 then
                                if correctKeys == 6 then
                                    correctKeys = correctKeys + 1
                                end
                                if key == "right" or correctKeys == 8 then
                                    if correctKeys == 7 then
                                        correctKeys = correctKeys + 1
                                    end
                                    if DebugMode then
                                        print("No need, debug is enabled")
                                    else
                                        debugON()
                                    end
                                else
                                    DebugMode = False
                                    correctKeys = 0
                                end
                            else
                                DebugMode = False
                                correctKeys = 0
                            end
                        else
                            DebugMode = False
                            correctKeys = 0
                        end
                    else
                        DebugMode = False
                        correctKeys = 0
                    end
                else
                    DebugMode = False
                    correctKeys = 0
                end
            else
                DebugMode = False
                correctKeys = 0
            end
        else
            DebugMode = False
            correctKeys = 0
        end
    else
        DebugMode = False
        correctKeys = 0
    end

end