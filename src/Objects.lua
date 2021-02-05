Objects = Class{__includes = Entity}


function Objects:init(object, x, y, globalPositioning)
    if object == "TV" then
        self.sprite = sprites["SideA_TV"]
        x = x or 90
        y = y or 140
    end

    Entity.init(self, x, y, globalPositioning)
end

function Objects:update()
    Entity.update(self)
end

function Objects:render()
    Entity.render(self)
end