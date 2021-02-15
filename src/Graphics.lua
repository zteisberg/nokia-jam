Graphics = Class{}

function Graphics:Load()
    textures = {
        ['FatherCycles1'] = love.graphics.newImage('assets/FatherCycles1.png'),
        ['FatherCycles2'] = love.graphics.newImage('assets/FatherCycles2.png'),
        ['FatherCycles3'] = love.graphics.newImage('assets/FatherCycles3.png'),
        ['ButtonCycles'] = love.graphics.newImage('assets/UISheet.png'),
    }
    cycles = {
        ['DadIdle'] = self:ExtractDadIdle(textures['FatherCycles1']),
        ['DadWalk'] = self:ExtractDadWalk(textures['FatherCycles1']),
        ['DadIdleFL'] = self:ExtractDadIdleFL(textures['FatherCycles1']),
        ['DadWalkFL'] = self:ExtractDadWalkFL(textures['FatherCycles1']),
        ['DadStairsUp'] = self:ExtractDadStairsUp(textures['FatherCycles3']),
        ['DadStairsDown'] = self:ExtractDadStairsDown(textures['FatherCycles3']),
        ['DadStairsUpFL'] = self:ExtractDadStairsUpFL(textures['FatherCycles3']),
        ['DadStairsDownFL'] = self:ExtractDadStairsDownFL(textures['FatherCycles3']),
        ['ButtonIndicator'] = self:ExtractButtonPress(textures['ButtonCycles']),
        ['ArrowIndicator'] = self:ExtractArrowIndicator(textures['ButtonCycles']),
        ['BatteryPower'] = self:ExtractBatteryPower(textures['ButtonCycles']),
    }
    sprites = {
        ['SideA_TV'] = love.graphics.newImage('assets/sideA_TV.png'),
    }
end

function Graphics:ExtractSprites(spriteSheet, width, height)
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

function Graphics:ExtractCycle(spriteSheet, width, height, xStart, yStart, xGap, xEnd)
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

function Graphics:ExtractDadIdle(spriteSheet)
    return self:ExtractCycle(spriteSheet, 30, 31, 0, 1, 0, 270)
end

function Graphics:ExtractDadIdleFL(spriteSheet)
    return self:ExtractCycle(spriteSheet, 30, 31, 0, 34, 0, 270)
end

function Graphics:ExtractDadWalk(spriteSheet)
    return self:ExtractCycle(spriteSheet, 30, 31, 0, 67, 0, 240)
end

function Graphics:ExtractDadWalkFL(spriteSheet)
    return self:ExtractCycle(spriteSheet, 30, 31, 0, 100, 0, 240)
end

function Graphics:ExtractDadStairsUp(spriteSheet)
    return self:ExtractCycle(spriteSheet, 53, 73, 85, 0, 0, 1092)
end

function Graphics:ExtractDadStairsDown(spriteSheet)
    return self:ExtractCycle(spriteSheet, 53, 73, 85, 74, 0, 1092)
end

function Graphics:ExtractDadStairsUpFL(spriteSheet)
    return self:ExtractCycle(spriteSheet, 62, 73, 0, 148, 0, 1178)
end

function Graphics:ExtractDadStairsDownFL(spriteSheet)
    return self:ExtractCycle(spriteSheet, 62, 73, 0, 222, 0, 1178)
end

function Graphics:ExtractButtonPress(spriteSheet)
    return self:ExtractCycle(spriteSheet, 7, 5, 35, 2, 0, 55)
end

function Graphics:ExtractArrowIndicator(spriteSheet)
    return self:ExtractCycle(spriteSheet, 8, 9, 0, 22, 1, 35)
end

function Graphics:ExtractBatteryPower(spriteSheet)
    return self:ExtractCycle(spriteSheet, 8, 4, 0, 8, 0, 48)
end