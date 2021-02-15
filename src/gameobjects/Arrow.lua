Arrow = Class{__includes = GameObject}

function Arrow:init(x,y)
    GameObject.init(self,x,y,active,globalPositioning)
    self.animation = Animation(textures['ButtonCycles'], cycles['UpArrowIndicator'], 0.25, 9, 9)
end

function Arrow:update()
    GameObject.update(self)
end

function Arrow:render()
    if math.abs(player.pos.x - self.pos.x) < 30 then
        GameObject.render(self)
    end
end