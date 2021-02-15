Graphics = Class{}

function Graphics:Load()
    textures = {
        ['FatherCycles1'] = love.graphics.newImage('assets/FatherCycles1.png'),
        ['FatherCycles2'] = love.graphics.newImage('assets/FatherCycles2.png'),
        ['FatherCycles3'] = love.graphics.newImage('assets/FatherCycles3.png'),
        ['FatherCycles4'] = love.graphics.newImage('assets/FatherCycles4.png'),
        ['ButtonCycles'] = love.graphics.newImage('assets/UISheet.png'),
    }
    cycles = {
        ['DadIdle'] = self:ExtractDadIdle(textures['FatherCycles1']),
        ['DadIdleFL'] = self:ExtractDadIdleFL(textures['FatherCycles1']),
        ['DadIdleFL45'] = self:ExtractDadIdleFL45(textures['FatherCycles2']),
        ['DadIdleFL90'] = self:ExtractDadIdleFL90(textures['FatherCycles2']),

        ['DadWalk'] = self:ExtractDadWalk(textures['FatherCycles1']),
        ['DadWalkFL'] = self:ExtractDadWalkFL(textures['FatherCycles1']),
        ['DadWalkFL45'] = self:ExtractDadWalkFL45(textures['FatherCycles2']),
        ['DadWalkFL90'] = self:ExtractDadWalkFL90(textures['FatherCycles2']),

        ['DadStairsUp'] = self:ExtractDadStairsUp(textures['FatherCycles3']),
        ['DadStairsUpFL'] = self:ExtractDadStairsUpFL(textures['FatherCycles3']),
        ['DadStairsDown'] = self:ExtractDadStairsDown(textures['FatherCycles3']),
        ['DadStairsDownFL'] = self:ExtractDadStairsDownFL(textures['FatherCycles3']),
        ['DadStairsExit'] = self:ExtractDadStairsExit(textures['FatherCycles4']),
        ['DadStairsExitFL'] = self:ExtractDadStairsExitFL(textures['FatherCycles4']),
        ['DadStairsEnter'] = self:ExtractDadStairsEnter(textures['FatherCycles4']),

        ['BatteryPower'] = self:ExtractBatteryPower(textures['ButtonCycles']),
        ['ButtonIndicator'] = self:ExtractButtonPress(textures['ButtonCycles']),
        ['UpArrowIndicator'] = self:ExtractUpArrowIndicator(textures['ButtonCycles']),
        ['SideArrowIndicator'] = self:ExtractSideArrowIndicator(textures['ButtonCycles']),
    }
    sprites = {
        ['SideA_TV'] = love.graphics.newImage('assets/ForegroundObjects/sideA_TV.png'),
        ['SideA_Railing'] = love.graphics.newImage('assets/ForegroundObjects/railing.png'),
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

function Graphics:ExtractCycle(spriteSheet, width, height, xStart, yStart, count)
    local cycle = {}

    for column=0, count-1 do
        cycle[#cycle+1] =
            love.graphics.newQuad(
                xStart + width*column, yStart,
                width, height, spriteSheet:getDimensions()
        )
    end
    return cycle
end

function Graphics:ExtractDadIdle(spriteSheet)
    return self:ExtractCycle(spriteSheet, 30, 31, 0, 1, 9)
end

function Graphics:ExtractDadIdleFL(spriteSheet)
    return self:ExtractCycle(spriteSheet, 30, 31, 0, 34, 9)
end

function Graphics:ExtractDadIdleFL45(spriteSheet)
    return self:ExtractCycle(spriteSheet, 27, 31, 0, 0, 9)
end

function Graphics:ExtractDadIdleFL90(spriteSheet)
    return self:ExtractCycle(spriteSheet, 27, 31, 0, 33, 9)
end

function Graphics:ExtractDadWalk(spriteSheet)
    return self:ExtractCycle(spriteSheet, 30, 31, 0, 67, 8)
end

function Graphics:ExtractDadWalkFL(spriteSheet)
    return self:ExtractCycle(spriteSheet, 30, 31, 0, 100, 8)
end

function Graphics:ExtractDadWalkFL45(spriteSheet)
    return self:ExtractCycle(spriteSheet, 27, 31, 0, 64, 8)
end

function Graphics:ExtractDadWalkFL90(spriteSheet)
    return self:ExtractCycle(spriteSheet, 27, 31, 0, 96, 8)
end

function Graphics:ExtractDadStairsUp(spriteSheet)
    return self:ExtractCycle(spriteSheet, 53, 73, 85, 0, 19)
end

function Graphics:ExtractDadStairsDown(spriteSheet)
    return self:ExtractCycle(spriteSheet, 53, 73, 85, 74, 19)
end

function Graphics:ExtractDadStairsUpFL(spriteSheet)
    return self:ExtractCycle(spriteSheet, 62, 73, 0, 148, 19)
end

function Graphics:ExtractDadStairsDownFL(spriteSheet)
    return self:ExtractCycle(spriteSheet, 58, 73, 0, 222, 19)
end

function Graphics:ExtractDadStairsExit(spritesheet)
    return self:ExtractCycle(spritesheet, 21, 38, 0, 1, 3)
end

function Graphics:ExtractDadStairsExitFL(spritesheet)
    return self:ExtractCycle(spritesheet, 21, 38, 0, 40, 3)
end

function Graphics:ExtractDadStairsEnter(spritesheet)
    return self:ExtractCycle(spritesheet, 21, 38, 0, 79, 3)
end

function Graphics:ExtractButtonPress(spriteSheet)
    return self:ExtractCycle(spriteSheet, 7, 7, 0, 0, 8)
end

function Graphics:ExtractUpArrowIndicator(spriteSheet)
    return self:ExtractCycle(spriteSheet, 9, 9, 0, 22, 4)
end

function Graphics:ExtractSideArrowIndicator(spriteSheet)
    return self:ExtractCycle(spriteSheet, 9, 8, 0, 13, 4)
end

function Graphics:ExtractBatteryPower(spriteSheet)
    return self:ExtractCycle(spriteSheet, 8, 4, 0, 8, 6)
end