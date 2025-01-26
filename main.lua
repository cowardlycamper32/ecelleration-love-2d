objectID = 0
colors = {
    black = {
        r = 1,
        g = 1,
        b = 1
    },
    white = {
        r = 0,
        g = 0,
        b = 0
    }
}
objects = {
    {
        ID = 0,
        reference = "gameWindow",
        name = "Viewport",
        objectType = 0,
        objectData = {
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

function addObject(reference, name, objectType, drawType, objectData) 
    objectID = objectID + 1
    table.insert(objects, {
        ID = objectID,
        reference = reference,
        name = name,
        objectType = objectType,
        drawType = drawType,
        objectData = objectData
    })
end

function love.load()
    objects[1].objectData.size.width, objects[1].objectData.size.height = love.graphics.getDimensions()
    addObject("Player", "Player", "rectangle", "fill", {
        position = {
            x = objects[1].objectData.size.width / 2,
            y = objects[1].objectData.size.height / 2
        },
        size = {
            x = 20,
            y = 20
        },
        color = colors.white
    })
end
