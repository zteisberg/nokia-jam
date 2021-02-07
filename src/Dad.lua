Dad = Class{__includes = Player}

function Dad:init(x,y,active,globalPositioning)
    local animations = {
        ['idle'] = Animation(textures['FatherCycles1'], cycles['DadIdle'], 0.5, 15, 30, 7, 30),
        ['walk'] = Animation(textures['FatherCycles1'], cycles['DadWalk'], 0.5, 15, 30, 9, 30),
        ['idleFL'] = Animation(textures['FatherCycles1'], cycles['DadIdleFL'], 0.5, 15, 30, 7, 30),
        ['walkFL'] = Animation(textures['FatherCycles1'], cycles['DadWalkFL'], 0.5, 15, 30, 9, 30),
    }
    Player.init(self,x,y,animations,active,globalPositioning)
end

function Dad:move(x, y)
    Entity.move(self, x,y)
end

function Dad:setPosition(x, y)
    Entity.setPosition(self,x,y)
end

function Dad:update()
    Player.update(self)
end

function Dad:render()
    Entity.render(self)
end