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
        color = colors.white
    })
end

function love.draw()
    for _, object in ipairs(objects) do
        doDraw(object)
    end
end 