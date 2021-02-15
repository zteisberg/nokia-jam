Objects = Class{__includes = GameObject}


function Objects:init(object, x, y)
    if object == 'TV'               then self.sprite = sprites['SideA_TV']      end
    if object == 'Stairway_Railing' then self.sprite = sprites['SideA_Railing'] end
    self.direction = 1
    GameObject.init(self, x, y)
end

function Objects:update()
    GameObject.update(self)
end

function Objects:render()
    GameObject.render(self)
end