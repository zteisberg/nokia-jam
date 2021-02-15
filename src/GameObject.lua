GameObject = Class{}

function GameObject:init(x, y)
    self.relative = true
    self.direction = 1
    self.flip = 1
    self.pos = {x=x, y=y}
    self.visible = true
end

function GameObject:move(x, y)
    self.pos.x = self.pos.x + x
    self.pos.y = self.pos.y + y
end

function GameObject:update()
    if self.animation then
        self.animation:update()
    end
end

function GameObject:render()
    if self.visible then
        if self.animation then
            self.animation:render(
                math.floor(self.pos.x - (self.relative and camera.pos.x or 0)),
                math.floor(self.pos.y - (self.relative and camera.pos.y or 0)),
                self.direction, self.flip
            )
        elseif self.sprite then
            love.graphics.draw(
                self.sprite, 
                math.floor(self.pos.x - (self.relative and camera.pos.x or 0)), 
                math.floor(self.pos.y - (self.relative and camera.pos.y or 0)),
                0, self.direction
            )
        end
    end
end

function GameObject:setRelative(relative)
    if relative and not self.relative then
        
    end

    self.relative = relative
end