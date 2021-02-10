Arrow = Class{__includes = GameObject}

function Arrow:init(x,y)
    GameObject.init(self,x,y,active,globalPositioning)
    self.animation = Animation(textures['ButtonCycles'], cycles['ArrowIndicator'], 0.25, 8, 8, 0, 0)
    self.pos = {x=x, y=y}
end

function Arrow:update()
    GameObject.update(self)
end

function Arrow:render()
    local absolute_position = camera.pos.x - player.pos.x
    if absolute_position >= -180 and absolute_position <= -145  then
        GameObject.render(self)
    end
end