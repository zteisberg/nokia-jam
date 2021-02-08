Obstruction = Class{__includes = GameObject}

function Obstruction:init(x, y, width, height)
    GameObject.init(self, x, y)
    self.size = {x = width, y = height}
end

function Obstruction:render()
    if input.keysDown['up']    then self.pos.y = self.pos.y - 1 end
    if input.keysDown['down']  then self.pos.y = self.pos.y + 1 end
    if input.keysDown['left']  then self.pos.x = self.pos.x - 1 end
    if input.keysDown['right'] then self.pos.x = self.pos.x + 1 end
    love.graphics.rectangle('fill', self.pos.x-camera.x, self.pos.y-camera.y, self.size.x, self.size.y)
end

function Obstruction:shadow(lightSource)
    
end

function rayTraceToEdge(v1, v2)

end