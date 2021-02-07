Dad = Class{__includes = Player}

function Dad:init(x,y,active,globalPositioning)
    local animations = {
        ['idle'] = Animation(textures['FatherCycles1'], cycles['DadIdle'], 0.25, 15, 30, 7, 30),
        ['walk'] = Animation(textures['FatherCycles1'], cycles['DadWalk'], 0.25, 15, 30, 9, 30),
        ['idleFL'] = Animation(textures['FatherCycles1'], cycles['DadIdleFL'], 0.25, 15, 30, 7, 30),
        ['walkFL'] = Animation(textures['FatherCycles1'], cycles['DadWalkFL'], 0.25, 15, 30, 9, 30),
    }
    Player.init(self,x,y,animations,active,globalPositioning)
end

function Dad:update()
    Player.update(self)
end

function Dad:render()
    GameObject.render(self)
end

function Dad:setIdle()
    Player.setIdle(self)
    self.heightOffset = {1,1,1,1,1,1,0,0,0}
end

function Dad:setWalk()
    SoundSystem.playIfQuiet('steps')
    Player.setWalk(self)
    self.heightOffset = {0,0,1,0,0,0,1,1}
end