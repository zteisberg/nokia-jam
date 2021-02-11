Dad = Class{__includes = Player}

function Dad:init(x,y,active,globalPositioning)
    local animations = {
        ['idle'] = Animation(textures['FatherCycles1'], cycles['DadIdle'], 0.25, 15, 30, 7, 30),
        ['walk'] = Animation(textures['FatherCycles1'], cycles['DadWalk'], 0.5, 15, 30, 9, 30),
        ['idleFL'] = Animation(textures['FatherCycles1'], cycles['DadIdleFL'], 0.25, 15, 30, 7, 30),
        ['walkFL'] = Animation(textures['FatherCycles1'], cycles['DadWalkFL'], 0.5, 15, 30, 9, 30),
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
    self.heightOffset = {1,1,1,1,1,1,0,0,0}
end

function Dad:setWalk()
    Player.setWalk(self)
    self.heightOffset = {0,0,1,0,0,0,1,1}
end

function Dad:setStairsUp()
    Player.setStairsUp(self)
    self.heightOffset = {0,3,5,6,7,9, 11, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36}
end