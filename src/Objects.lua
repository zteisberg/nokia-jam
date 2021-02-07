Objects = Class{__includes = Entity}


function Objects:init(object, x, y)
    if object == "TV" then
        self.sprite = sprites["SideA_TV"]
        self.pos = {x=x, y=y}
    end
    self.direction = 1
    Entity.init(self, x, y)
end

function Objects:update()
    Entity.update(self)
end

function Objects:render()
    Entity.render(self)
end