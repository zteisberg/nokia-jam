Sprites = {}

function Sprites:Load()
    textures = {
        ['CharacterCycles'] = love.graphics.newImage('assets/Cycles1.png'),
    }
    cycles = {
        ['DadIdle'] = ExtractDadIdle(textures['CharacterCycles']),
        ['DadWalk'] = ExtractDadWalk(textures['CharacterCycles']),
        ['DadWalkFL'] = ExtractDadWalkFL(textures['CharacterCycles']),
    }
    sprites = {
        ['SideA_TV'] = love.graphics.newImage('assets/sideA_TV.png')
    }
end

function ExtractSprites(spriteSheet, width, height)
    local rows = spriteSheet:getWidth()  / width
    local columns = spriteSheet:getHeight() / height
    local sprites = {}
    
    for row=0, rows-1 do
        for col=0, columns-1 do
            sprites[#sprites+1] =
                love.graphics.newQuad(row * width, columns*height,
                width, height, spriteSheet:getDimensions()
            )
        end
    end
    return sprites
end

function ExtractCycle(spriteSheet, width, height, xStart, xGap, xEnd, yStart)
    local columns = (xEnd-xStart+xGap) / (width+xGap)
    local cycle = {}

    for col=0, columns-1 do
        cycle[#cycle+1] =
            love.graphics.newQuad(
                xStart + (xGap+width)*col, yStart,
                width, height, spriteSheet:getDimensions()
        )
    end
    return cycle
end

function ExtractDadIdle(spriteSheet)
    return ExtractCycle(spriteSheet, 17, 32, 5, 13, 262, 1)
end

function ExtractDadWalk(spriteSheet)
    return ExtractCycle(spriteSheet, 17, 32, 5, 13, 202, 71)
end

function ExtractDadWalkFL(spriteSheet)
    return ExtractCycle(spriteSheet, 24, 32, 5, 6, 269, 36)
end