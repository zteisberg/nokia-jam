Dad = Class{__includes = Player}

function Dad:init(x,y,active,globalPositioning)
    animations = {
        ['idle'] = Animation(textures['CharacterCycles'], cycles['DadIdle'], 0.5, 15, 30, 7, 30),
        ['walk'] = Animation(textures['CharacterCycles'], cycles['DadWalk'], 0.5, 15, 30, 8, 30),
    }
    Player:init(x,y,animations,active,globalPositioning)
end

function Dad:move(x, y)
    Entity:move(x,y)
end

function Dad:setPosition(x, y)
    Entity:setPosition(x,y)
end

function Dad:update()
    Player:update()
end

function Dad:render()
    Entity:render()
end