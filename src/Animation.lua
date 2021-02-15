Animation = Class{}

function Animation:init(source, cycle, speed, width, height, xOrigin, yOrigin)
    self.source = source
    self.cycle = cycle
    self.speed = speed
    self.frame = 1
    self.width = width
    self.height = height
    self.reverse = false
    self.origin = {
        x = xOrigin or math.floor(self.width /2),
        y = yOrigin or math.floor(self.height/2)
    }
end

function Animation:update()
    if self.reverse then
         self.frame = (self.frame - self.speed) % #self.cycle
    else self.frame = (self.frame + self.speed) % #self.cycle end
end

function Animation:render(x, y, sx, sy)
    sx = sx or 1
    sy = sy or 1
    love.graphics.draw(
        self.source, self.cycle[self:getFrame()],
        x, y, 0, sx, sy, self.origin.x, self.origin.y
    )
end

function Animation:getFrame()
    return math.floor(self.frame+1)
end