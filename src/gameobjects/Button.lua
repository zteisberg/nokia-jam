Button = Class{__includes = GameObject}

function Button:init(x,y)
    GameObject.init(self,x,y)
    self.animation = Animation(textures['ButtonCycles'], cycles['ButtonIndicator'], 1, 7, 7)
end

function Button:update()
    GameObject.update(self)
end

function Button:render()
    if math.abs(player.pos.x - self.pos.x) < 30 then
        GameObject.render(self)
    end
end