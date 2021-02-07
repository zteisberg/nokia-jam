Sprites = {}

function Sprites:Load()
    textures = {
        ['FatherCycles1'] = love.graphics.newImage('assets/FatherCycles1.png'),
    }
    cycles = {
        ['DadIdle'] = ExtractDadIdle(textures['FatherCycles1']),
        ['DadIdleFL'] = ExtractDadIdleFL(textures['FatherCycles1']),
        ['DadWalk'] = ExtractDadWalk(textures['FatherCycles1']),
        ['DadWalkFL'] = ExtractDadWalkFL(textures['FatherCycles1']),
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

function ExtractCycle(spriteSheet, width, height, xStart, yStart, xGap, xEnd)
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
    return ExtractCycle(spriteSheet, 17, 32, 5, 1, 13, 262)
end

function ExtractDadIdleFL(spriteSheet)
    return ExtractCycle(spriteSheet, 24, 31, 5, 38, 6, 269)
end

function ExtractDadWalk(spriteSheet)
    return ExtractCycle(spriteSheet, 22, 32, 2, 73, 8, 234)
end

function ExtractDadWalkFL(spriteSheet)
    return ExtractCycle(spriteSheet, 26, 31, 3, 110, 4, 239)
end