Button = Class{__includes = GameObject}

function Button:init(x,y,active,globalPositioning)
    GameObject.init(self,x,y,active,globalPositioning)
    self.animation = Animation(textures['ButtonCycles'], cycles['ButtonIndicator'], 0.25, 7, 5, 0, 0)
    self.pos = {x=x, y=y}
end

function Button:update()
    GameObject.update(self)
end

function Button:render()
    local absolute_position = camera.pos.x - player.pos.x
    if absolute_position >= -88 and absolute_position <= -35  then
        GameObject.render(self)
    end
end