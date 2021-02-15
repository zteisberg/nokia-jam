Dad = Class{__includes = Player}

function Dad:init(x,y)
    local animations = {
        ['idle'] = Animation(textures['FatherCycles1'], cycles['DadIdle'], 0.25, 30, 31, 12, 30),
        ['walk'] = Animation(textures['FatherCycles1'], cycles['DadWalk'], 0.5, 30, 31, 12, 30),
        ['idleFL'] = Animation(textures['FatherCycles1'], cycles['DadIdleFL'], 0.25, 30, 31, 12, 30),
        ['walkFL'] = Animation(textures['FatherCycles1'], cycles['DadWalkFL'], 0.5, 30, 31, 12, 30),
        ['idleFL45'] = Animation(textures['FatherCycles2'], cycles['DadIdleFL45'], 0.25, 27, 31, 10, 30),
        ['walkFL45'] = Animation(textures['FatherCycles2'], cycles['DadWalkFL45'], 0.5, 27, 31, 11, 30),
        ['idleFL90'] = Animation(textures['FatherCycles2'], cycles['DadIdleFL90'], 0.25, 27, 31, 10, 30),
        ['walkFL90'] = Animation(textures['FatherCycles2'], cycles['DadWalkFL90'], 0.5, 27, 31, 12, 30),
        ['stairsUp'] = Animation(textures['FatherCycles3'], cycles['DadStairsUp'], 0.5, 53, 73, 15, 73),
        ['stairsDown'] = Animation(textures['FatherCycles3'], cycles['DadStairsDown'], 0.5, 53, 73, 15, 73),
        ['stairsUpFL'] = Animation(textures['FatherCycles3'], cycles['DadStairsUpFL'], 0.5, 53, 73, 15, 73),
        ['stairsDownFL'] = Animation(textures['FatherCycles3'], cycles['DadStairsDownFL'], 0.5, 53, 73, 15, 73),
    }
    Player.init(self,x,y,animations,active,globalPositioning)
end

function Dad:update()
    Player.update(self)
    if self.state == 'walking' then
        if self.animation:getFrame() % 4 == 1 then
            SoundSystem.playIfQuiet('steps')
        end
    elseif self.state == 'stairs' then
        if self.animation:getFrame() % 2 == 0 then
            SoundSystem.playIfQuiet('interact')
        end
    end
end

function Dad:render()
    GameObject.render(self)
end

function Dad:setIdle()
    Player.setIdle(self)
    if self.angle == 0 then self.flashlightOffset = {
        {10, 9}, {10, 9}, {10, 9}, 
        {10, 9}, {10, 9}, {10, 9}, 
        {10, 8}, {10, 8}, {10, 8},    
    }
    elseif self.angle == math.pi/4 then self.flashlightOffset = {
        {11, 11}, {11, 11}, {11, 11}, 
        {11, 11}, {11, 11}, {11, 11}, 
        {11, 10}, {11, 10}, {11, 10}, 
    }
    elseif self.angle == math.pi/2 then self.flashlightOffset = {
        {10, 18}, {10, 18}, {10, 18}, 
        {10, 18}, {10, 18}, {10, 18}, 
        {10, 17}, {10, 17}, {10, 17}, 
    }
    end
    -- self.heightOffset = {1,1,1,1,1,1,0,0,0}
end

function Dad:setWalk()
    Player.setWalk(self)
    if self.angle == 0 then self.flashlightOffset = {
        {10, 8}, {10, 8}, {10, 9}, {10, 8},
        {10, 8}, {10, 8}, {10, 9}, {10, 9},   
    }
    elseif self.angle == math.pi/4 then self.flashlightOffset = {
        {11, 10}, {11, 10}, {11, 11}, {11, 11}, 
        {11, 10}, {11, 11}, {11, 12}, {11, 12},
    }
    elseif self.angle == math.pi/2 then self.flashlightOffset = {
        {10, 18}, {10, 18}, {10, 19}, {10, 19},
        {10, 18}, {10, 19}, {10, 20}, {10, 19},
    }
    end
    -- self.heightOffset = {0,0,1,0,0,0,1,1}
end

function Dad:setStairsUp()
    Player.setStairsUp(self)
    -- self.heightOffset = {0,3,5,6,7,9, 11, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36}
end